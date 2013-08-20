From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 8/9] target: Add support for COMPARE_AND_WRITE emulation
Date: Tue, 20 Aug 2013 20:07:59 +0000
Message-ID: <1377029280-19144-9-git-send-email-nab@daterainc.com>
References: <1377029280-19144-1-git-send-email-nab@daterainc.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1377029280-19144-1-git-send-email-nab@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Martin Petersen <martin.petersen@oracle.com>, Chris Mason <chris.mason@fusionio.com>, James Bottomley <JBottomley@Parallels.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Nicholas Bellinger <nab@daterainc.com>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@daterainc.com>

This patch adds support for COMPARE_AND_WRITE emulation on a per block
basis.  This logic is used as an atomic test and set primative currently
used by VMWare ESX VAAI for performing array side locking of individual
VMFS extent ownership.

This includes the COMPARE_AND_WRITE CDB parsing within sbc_parse_cdb(),
and does the majority of the work within the compare_and_write_callback()
to perform the verify instance user data comparision, and subsequent
write instance user data I/O submission upon a successfull comparision.

The implementation currently assumes a single logical block (NoLB=1).

FIXME: Determine sychronization necessary between I/O submission path
and compare_and_write_callback() I/O submission path.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Martin Petersen <martin.petersen@oracle.com>
Cc: Chris Mason <chris.mason@fusionio.com>
Cc: James Bottomley <JBottomley@Parallels.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Nicholas Bellinger <nab@daterainc.com>
---
 drivers/target/target_core_sbc.c  |  139 +++++++++++++++++++++++++++++++++++++
 include/target/target_core_base.h |    1 +
 2 files changed, 140 insertions(+)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index e98581a..1370efc 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -25,6 +25,7 @@
 #include <linux/ratelimit.h>
 #include <asm/unaligned.h>
 #include <scsi/scsi.h>
+#include <scsi/scsi_tcq.h>
 
 #include <target/target_core_base.h>
 #include <target/target_core_backend.h>
@@ -337,6 +338,122 @@ out:
 	return ret;
 }
 
+static sense_reason_t compare_and_write_done(struct se_cmd *cmd)
+{
+	return TCM_NO_SENSE;
+}
+
+static sense_reason_t compare_and_write_callback(struct se_cmd *cmd)
+{
+	struct se_device *dev = cmd->se_dev;
+	struct scatterlist *write_sg = NULL, *sg;
+	unsigned char *buf, *addr;
+	struct sg_mapping_iter m;
+	unsigned int offset = 0, len;
+	unsigned int nlbas = cmd->t_task_nolb;
+	unsigned int block_size = dev->dev_attrib.block_size;
+	unsigned int compare_len = (nlbas * block_size);
+	sense_reason_t ret = TCM_NO_SENSE;
+	int rc, i;
+
+	buf = kzalloc(cmd->data_length, GFP_KERNEL);
+	if (!buf) {
+		pr_err("Unable to allocate compare_and_write buf\n");
+		return TCM_OUT_OF_RESOURCES;
+	}
+
+	write_sg = kzalloc(sizeof(struct scatterlist) * cmd->t_data_nents,
+			   GFP_KERNEL);
+	if (!write_sg) {
+		pr_err("Unable to allocate compare_and_write sg\n");
+		ret = TCM_OUT_OF_RESOURCES;
+		goto out;
+	}
+	/*
+	 * Setup verify and write data payloads from total NumberLBAs.
+	 */
+	rc = sg_copy_to_buffer(cmd->t_data_sg, cmd->t_data_nents, buf,
+			       cmd->data_length);
+	if (!rc) {
+		pr_err("sg_copy_to_buffer() failed for compare_and_write\n");
+		ret = TCM_OUT_OF_RESOURCES;
+		goto out;
+	}
+	/*
+	 * Compare against SCSI READ payload against verify payload
+	 */
+	for_each_sg(cmd->t_bidi_data_sg, sg, cmd->t_bidi_data_nents, i) {
+		addr = (unsigned char *)kmap_atomic(sg_page(sg));
+		if (!addr) {
+			ret = TCM_OUT_OF_RESOURCES;
+			goto out;
+		}
+
+		len = min(sg->length, compare_len);
+
+		if (memcmp(addr, buf + offset, len)) {
+			pr_warn("Detected MISCOMPARE for addr: %p buf: %p\n",
+				addr, buf + offset);
+			kunmap_atomic(addr);
+			goto miscompare;
+		}
+		kunmap_atomic(addr);
+
+		offset += len;
+		compare_len -= len;
+		if (!compare_len)
+			break;
+	}
+
+	i = 0;
+	len = cmd->t_task_nolb * block_size;
+	sg_miter_start(&m, cmd->t_data_sg, cmd->t_data_nents, SG_MITER_TO_SG);
+	/*
+	 * Currently assumes NoLB=1 and SGLs are PAGE_SIZE..
+	 */
+	while (len) {
+		sg_miter_next(&m);
+
+		if (block_size < PAGE_SIZE) {
+			sg_set_page(&write_sg[i], m.page, block_size,
+				    block_size);
+		} else {
+			sg_miter_next(&m);
+			sg_set_page(&write_sg[i], m.page, block_size,
+				    0);
+		}
+	}
+	sg_miter_stop(&m);
+	/*
+	 * Save the original SGL + nents values before updating to new
+	 * assignments, to be released in transport_free_pages() ->
+	 * transport_reset_sgl_orig()
+	 */
+	cmd->t_data_sg_orig = cmd->t_data_sg;
+	cmd->t_data_sg = write_sg;
+	cmd->t_data_nents_orig = cmd->t_data_nents;
+	cmd->t_data_nents = 1;
+
+	cmd->sam_task_attr = MSG_HEAD_TAG;
+	cmd->se_cmd_flags |= SCF_COMPARE_AND_WRITE_POST;
+	cmd->transport_complete_callback = compare_and_write_done;
+
+#warning FIXME: Replace with __target_execute_cmd()..?
+	target_execute_cmd(cmd);
+
+	kfree(buf);
+	return ret;
+
+miscompare:
+	pr_warn("Target/%s: Send MISCOMPARE check condition and sense\n",
+		dev->transport->name);
+	ret = TCM_MISCOMPARE_VERIFY;
+out:
+	kfree(write_sg);
+	kfree(buf);
+	return ret;
+}
+
 static sense_reason_t
 sbc_execute_rw(struct se_cmd *cmd)
 {
@@ -497,6 +614,28 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		}
 		break;
 	}
+	case COMPARE_AND_WRITE:
+		sectors = cdb[13];
+		/*
+		 * Currently enforce COMPARE_AND_WRITE for a single sector
+		 */
+		if (sectors > 1) {
+			pr_err("COMPARE_AND_WRITE contains NoLB: %u greater"
+			       " than 1\n", sectors);
+			return TCM_INVALID_CDB_FIELD;
+		}
+		/*
+		 * Double size because we have two buffers, note that
+		 * zero is not an error..
+		 */
+		size = 2 * sbc_get_size(cmd, sectors);
+		cmd->t_task_lba = get_unaligned_be64(&cdb[2]);
+		cmd->t_task_nolb = sectors;
+		cmd->se_cmd_flags |= SCF_SCSI_DATA_CDB | SCF_BIDI;
+		cmd->execute_rw = ops->execute_rw;
+		cmd->execute_cmd = sbc_execute_rw;
+		cmd->transport_complete_callback = compare_and_write_callback;
+		break;
 	case READ_CAPACITY:
 		size = READ_CAP_LEN;
 		cmd->execute_cmd = sbc_emulate_readcapacity;
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 2f9a438..c7bf1e3 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -456,6 +456,7 @@ struct se_cmd {
 	unsigned char		*t_task_cdb;
 	unsigned char		__t_task_cdb[TCM_MAX_COMMAND_SIZE];
 	unsigned long long	t_task_lba;
+	unsigned int		t_task_nolb;
 	unsigned int		transport_state;
 #define CMD_T_ABORTED		(1 << 0)
 #define CMD_T_ACTIVE		(1 << 1)
-- 
1.7.10.4

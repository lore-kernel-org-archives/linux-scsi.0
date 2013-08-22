From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v2 10/12] target: Add support for COMPARE_AND_WRITE emulation
Date: Thu, 22 Aug 2013 04:54:08 +0000
Message-ID: <1377147250-10125-11-git-send-email-nab@daterainc.com>
References: <1377147250-10125-1-git-send-email-nab@daterainc.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1377147250-10125-1-git-send-email-nab@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Martin Petersen <martin.petersen@oracle.com>, Chris Mason <chris.mason@fusionio.com>, Roland Dreier <roland@purestorage.com>, James Bottomley <JBottomley@Parallels.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Nicholas Bellinger <nab@daterainc.com>
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

The synchronization is enforced by se_device->caw_mutex, that is obtained
before the initial READ I/O submission in sbc_compare_and_write().  The
mutex is then released upon MISCOMPARE in compare_and_write_callback(),
or upon WRITE instance user-data completion in compare_and_write_post().

The implementation currently assumes a single logical block (NoLB=1).

v2 changes:
 - Set SCF_COMPARE_AND_WRITE and cmd->execute_cmd() to
   sbc_compare_and_write() during setup in sbc_parse_cdb()
 - Use sbc_compare_and_write() for initial READ submission with
   DMA_FROM_DEVICE
 - Reset cmd->execute_cmd() to sbc_execute_rw() for write instance
   user-data in compare_and_write_callback()
 - Drop SCF_BIDI command flag usage
 - Set TRANSPORT_PROCESSING + transport_state flags before write
   instance submission, and convert to __target_execute_cmd()
 - Prevent sbc_get_size() from being being called twice to
   generate incorrect size in sbc_parse_cdb()
 - Enforce se_device->caw_mutex synchronization between initial
   READ I/O submission, and final WRITE I/O completion.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Martin Petersen <martin.petersen@oracle.com>
Cc: Chris Mason <chris.mason@fusionio.com>
Cc: James Bottomley <JBottomley@Parallels.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Nicholas Bellinger <nab@daterainc.com>
---
 drivers/target/target_core_device.c |    1 +
 drivers/target/target_core_sbc.c    |  190 ++++++++++++++++++++++++++++++++++-
 include/target/target_core_base.h   |    1 +
 3 files changed, 191 insertions(+), 1 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 0b5f868..de89046 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -1413,6 +1413,7 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
 	spin_lock_init(&dev->se_port_lock);
 	spin_lock_init(&dev->se_tmr_lock);
 	spin_lock_init(&dev->qf_cmd_lock);
+	mutex_init(&dev->caw_mutex);
 	atomic_set(&dev->dev_ordered_id, 0);
 	INIT_LIST_HEAD(&dev->t10_wwn.t10_vpd_list);
 	spin_lock_init(&dev->t10_wwn.t10_vpd_lock);
diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index 5569b36..4076828 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -25,6 +25,7 @@
 #include <linux/ratelimit.h>
 #include <asm/unaligned.h>
 #include <scsi/scsi.h>
+#include <scsi/scsi_tcq.h>
 
 #include <target/target_core_base.h>
 #include <target/target_core_backend.h>
@@ -344,6 +345,170 @@ sbc_execute_rw(struct se_cmd *cmd)
 			       cmd->data_direction);
 }
 
+static sense_reason_t compare_and_write_post(struct se_cmd *cmd)
+{
+	struct se_device *dev = cmd->se_dev;
+
+	cmd->se_cmd_flags |= SCF_COMPARE_AND_WRITE_POST;
+	/*
+	 * Unlock ->caw_mutex originally obtained during sbc_compare_and_write()
+	 * before the original READ I/O submission.
+	 */
+	mutex_unlock(&dev->caw_mutex);
+
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
+		len -= block_size;
+		i++;
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
+	cmd->transport_complete_callback = compare_and_write_post;
+	/*
+	 * Now reset ->execute_cmd() to the normal sbc_execute_rw() handler
+	 * for submitting the adjusted SGL to write instance user-data.
+	 */
+	cmd->execute_cmd = sbc_execute_rw;
+
+	spin_lock_irq(&cmd->t_state_lock);
+	cmd->t_state = TRANSPORT_PROCESSING;
+	cmd->transport_state |= CMD_T_ACTIVE|CMD_T_BUSY|CMD_T_SENT;
+	spin_unlock_irq(&cmd->t_state_lock);
+
+	__target_execute_cmd(cmd);
+
+	kfree(buf);
+	return ret;
+
+miscompare:
+	pr_warn("Target/%s: Send MISCOMPARE check condition and sense\n",
+		dev->transport->name);
+	ret = TCM_MISCOMPARE_VERIFY;
+out:
+	/*
+	 * In the MISCOMPARE or failure case, unlock ->caw_mutex obtained in
+	 * sbc_compare_and_write() before the original READ I/O submission.
+	 */
+	mutex_unlock(&dev->caw_mutex);
+	kfree(write_sg);
+	kfree(buf);
+	return ret;
+}
+
+static sense_reason_t
+sbc_compare_and_write(struct se_cmd *cmd)
+{
+	struct se_device *dev = cmd->se_dev;
+	sense_reason_t ret;
+	/*
+	 * Submit the READ first for COMPARE_AND_WRITE to perform the
+	 * comparision using SGLs at cmd->t_bidi_data_sg..
+	 */
+	mutex_lock(&dev->caw_mutex);
+	ret = cmd->execute_rw(cmd, cmd->t_bidi_data_sg, cmd->t_bidi_data_nents,
+			      DMA_FROM_DEVICE);
+	if (ret) {
+		mutex_unlock(&dev->caw_mutex);
+		return ret;
+	}
+	/*
+	 * Unlock of dev->caw_mutex to occur in compare_and_write_callback()
+	 * upon MISCOMPARE, or in compare_and_write_done() upon completion
+	 * of WRITE instance user-data.
+	 */
+	return TCM_NO_SENSE;
+}
+
 sense_reason_t
 sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 {
@@ -481,6 +646,28 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
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
+		cmd->se_cmd_flags |= SCF_SCSI_DATA_CDB | SCF_COMPARE_AND_WRITE;
+		cmd->execute_rw = ops->execute_rw;
+		cmd->execute_cmd = sbc_compare_and_write;
+		cmd->transport_complete_callback = compare_and_write_callback;
+		break;
 	case READ_CAPACITY:
 		size = READ_CAP_LEN;
 		cmd->execute_cmd = sbc_emulate_readcapacity;
@@ -620,7 +807,8 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 			return TCM_ADDRESS_OUT_OF_RANGE;
 		}
 
-		size = sbc_get_size(cmd, sectors);
+		if (!(cmd->se_cmd_flags & SCF_COMPARE_AND_WRITE))
+			size = sbc_get_size(cmd, sectors);
 	}
 
 	return target_cmd_size_check(cmd, size);
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 53eea33..0783b2c 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -672,6 +672,7 @@ struct se_device {
 	spinlock_t		se_port_lock;
 	spinlock_t		se_tmr_lock;
 	spinlock_t		qf_cmd_lock;
+	struct mutex		caw_mutex;
 	/* Used for legacy SPC-2 reservationsa */
 	struct se_node_acl	*dev_reserved_node_acl;
 	/* Used for ALUA Logical Unit Group membership */
-- 
1.7.2.5

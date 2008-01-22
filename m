From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH 3/3] scsi_debug: add XDWRITEREAD_10 support
Date: Wed, 23 Jan 2008 01:32:01 +0900
Message-ID: <20080123013122O.tomof@acm.org>
References: <20080123013012N.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:53938 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751975AbYAVQfz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Jan 2008 11:35:55 -0500
In-Reply-To: <20080123013012N.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, dougg@torque.net
Cc: bharrosh@panasas.com, fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, Jens.Axboe@oracle.comfujita.tomonori@lab.ntt.co.jp


Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/scsi_debug.c |   70 +++++++++++++++++++++++++++++++++++++++++++++
 include/scsi/scsi.h       |    1 +
 2 files changed, 71 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index d810aa7..1541c17 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -280,6 +280,8 @@ static int resp_write(struct scsi_cmnd * SCpnt, unsigned long long lba,
 		      unsigned int num, struct sdebug_dev_info * devip);
 static int resp_report_luns(struct scsi_cmnd * SCpnt,
 			    struct sdebug_dev_info * devip);
+static int resp_xdwriteread(struct scsi_cmnd *scp, unsigned long long lba,
+			    unsigned int num, struct sdebug_dev_info *devip);
 static int fill_from_dev_buffer(struct scsi_cmnd * scp, unsigned char * arr,
                                 int arr_len);
 static int fetch_to_dev_buffer(struct scsi_cmnd * scp, unsigned char * arr,
@@ -334,6 +336,7 @@ static void get_data_transfer_info(unsigned char *cmd,
 		break;
 	case WRITE_10:
 	case READ_10:
+	case XDWRITEREAD_10:
 		*lba = cmd[5] + (cmd[4] << 8) +	(cmd[3] << 16) + (cmd[2] << 24);
 		*num = cmd[8] + (cmd[7] << 8);
 		break;
@@ -542,6 +545,28 @@ int scsi_debug_queuecommand(struct scsi_cmnd * SCpnt, done_funct_t done)
 	case WRITE_BUFFER:
 		errsts = check_readiness(SCpnt, 1, devip);
 		break;
+	case XDWRITEREAD_10:
+		if (!scsi_bidi_cmnd(SCpnt)) {
+			mk_sense_buffer(devip, ILLEGAL_REQUEST,
+					INVALID_FIELD_IN_CDB, 0);
+			errsts = check_condition_result;
+			break;
+		}
+
+		errsts = check_readiness(SCpnt, 0, devip);
+		if (errsts)
+			break;
+		if (scsi_debug_fake_rw)
+			break;
+		get_data_transfer_info(cmd, &lba, &num);
+		errsts = resp_read(SCpnt, lba, num, devip);
+		if (errsts)
+			break;
+		errsts = resp_write(SCpnt, lba, num, devip);
+		if (errsts)
+			break;
+		errsts = resp_xdwriteread(SCpnt, lba, num, devip);
+		break;
 	default:
 		if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
 			printk(KERN_INFO "scsi_debug: Opcode: 0x%x not "
@@ -1948,6 +1973,50 @@ static int resp_report_luns(struct scsi_cmnd * scp,
 				    min((int)alloc_len, SDEBUG_RLUN_ARR_SZ));
 }
 
+static int resp_xdwriteread(struct scsi_cmnd *scp, unsigned long long lba,
+			    unsigned int num, struct sdebug_dev_info *devip)
+{
+	int i, j, ret = -1;
+	unsigned char *kaddr, *buf;
+	unsigned int offset;
+	struct scatterlist *sg;
+	struct scsi_data_buffer *sdb = scsi_in(scp);
+
+	/* better not to use temporary buffer. */
+	buf = kmalloc(scsi_bufflen(scp), GFP_ATOMIC);
+	if (!buf)
+		return ret;
+
+	offset = 0;
+	scsi_for_each_sg(scp, sg, scsi_sg_count(scp), i) {
+		kaddr = (unsigned char *)kmap_atomic(sg_page(sg), KM_USER0);
+		if (!kaddr)
+			goto out;
+
+		memcpy(buf + offset, kaddr + sg->offset, sg->length);
+		offset += sg->length;
+		kunmap_atomic(kaddr, KM_USER0);
+	}
+
+	offset = 0;
+	for_each_sg(sdb->table.sgl, sg, sdb->table.nents, i) {
+		kaddr = (unsigned char *)kmap_atomic(sg_page(sg), KM_USER0);
+		if (!kaddr)
+			goto out;
+
+		for (j = 0; j < sg->length; j++)
+			*(kaddr + sg->offset + j) ^= *(buf + offset + j);
+
+		offset += sg->length;
+		kunmap_atomic(kaddr, KM_USER0);
+	}
+	ret = 0;
+out:
+	kfree(buf);
+
+	return ret;
+}
+
 /* When timer goes off this function is called. */
 static void timer_intr_handler(unsigned long indx)
 {
@@ -1981,6 +2050,7 @@ static int scsi_debug_slave_alloc(struct scsi_device * sdp)
 	if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
 		printk(KERN_INFO "scsi_debug: slave_alloc <%u %u %u %u>\n",
 		       sdp->host->host_no, sdp->channel, sdp->id, sdp->lun);
+	set_bit(QUEUE_FLAG_BIDI, &sdp->request_queue->queue_flags);
 	return 0;
 }
 
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 056c5af..19ca9e9 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -102,6 +102,7 @@ extern const unsigned char scsi_command_size[8];
 #define READ_TOC              0x43
 #define LOG_SELECT            0x4c
 #define LOG_SENSE             0x4d
+#define XDWRITEREAD_10        0x53
 #define MODE_SELECT_10        0x55
 #define RESERVE_10            0x56
 #define RELEASE_10            0x57
-- 
1.5.3.4


From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: PATCH [4/15] qla2xxx:  Endianess fix while reading stats
Date: Sun, 14 Mar 2004 00:24:34 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040314082434.GA3409@linux.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-03-qfe0.socal.rr.com ([66.75.162.135]:410 "EHLO
	ms-smtp-03-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S263316AbUCNIWF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Mar 2004 03:22:05 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

ChangeSet
  1.1660 04/02/28 22:02:06 andrew.vasquez@qlogic.com +2 -0
  Return firmware statistics retrieved from
  qla2x00_get_link_status() in host-endian form.

  drivers/scsi/qla2xxx/qla_gbl.h
    1.5 04/02/28 22:02:00 andrew.vasquez@qlogic.com +1 -1
    Use a pointer to a known structure form rather than an
    opaque pointer.

 drivers/scsi/qla2xxx/qla_gbl.h |    2 +-
 drivers/scsi/qla2xxx/qla_mbx.c |   32 ++++++++++++++++++--------------
 2 files changed, 19 insertions(+), 15 deletions(-)

ftp://ftp.qlogic.com/outgoing/linux/patches/8.x/8.00.00b11k/13_endian_fix_link_stats.patch

diff -Nru a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
--- a/drivers/scsi/qla2xxx/qla_gbl.h	Fri Mar 12 17:07:04 2004
+++ b/drivers/scsi/qla2xxx/qla_gbl.h	Fri Mar 12 17:07:04 2004
@@ -195,7 +195,7 @@
 qla2x00_get_port_name(scsi_qla_host_t *, uint16_t, uint8_t *, uint8_t);
 
 extern uint8_t
-qla2x00_get_link_status(scsi_qla_host_t *, uint8_t, void *, uint16_t *);
+qla2x00_get_link_status(scsi_qla_host_t *, uint8_t, link_stat_t *, uint16_t *);
 
 extern int
 qla2x00_lip_reset(scsi_qla_host_t *);
diff -Nru a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
--- a/drivers/scsi/qla2xxx/qla_mbx.c	Fri Mar 12 17:07:04 2004
+++ b/drivers/scsi/qla2xxx/qla_mbx.c	Fri Mar 12 17:07:04 2004
@@ -1598,8 +1598,8 @@
  *	BIT_1 = mailbox error.
  */
 uint8_t
-qla2x00_get_link_status(scsi_qla_host_t *ha, uint8_t loop_id, void *ret_buf,
-    uint16_t *status)
+qla2x00_get_link_status(scsi_qla_host_t *ha, uint8_t loop_id,
+    link_stat_t *ret_buf, uint16_t *status)
 {
 	int rval;
 	mbx_cmd_t mc;
@@ -1646,16 +1646,20 @@
 			status[0] = mcp->mb[0];
 			rval = BIT_1;
 		} else {
-			/* copy over data */
-			memcpy(ret_buf, stat_buf,sizeof(link_stat_t));
-			DEBUG(printk("qla2x00_get_link_status(%ld): stat dump: "
-			    "fail_cnt=%d loss_sync=%d loss_sig=%d seq_err=%d "
-			    "inval_xmt_word=%d inval_crc=%d.\n",
-			    ha->host_no,
-			    stat_buf->link_fail_cnt, stat_buf->loss_sync_cnt,
-			    stat_buf->loss_sig_cnt, stat_buf->prim_seq_err_cnt,
-			    stat_buf->inval_xmit_word_cnt,
-			    stat_buf->inval_crc_cnt);)
+			/* copy over data -- firmware data is LE. */
+			ret_buf->link_fail_cnt =
+			    le32_to_cpu(stat_buf->link_fail_cnt);
+			ret_buf->loss_sync_cnt =
+			    le32_to_cpu(stat_buf->loss_sync_cnt);
+			ret_buf->loss_sig_cnt =
+			    le32_to_cpu(stat_buf->loss_sig_cnt);
+			ret_buf->prim_seq_err_cnt =
+			    le32_to_cpu(stat_buf->prim_seq_err_cnt);
+			ret_buf->inval_xmit_word_cnt =
+			    le32_to_cpu(stat_buf->inval_xmit_word_cnt);
+			ret_buf->inval_crc_cnt =
+			    le32_to_cpu(stat_buf->inval_crc_cnt);
+
 			DEBUG11(printk("qla2x00_get_link_status(%ld): stat "
 			    "dump: fail_cnt=%d loss_sync=%d loss_sig=%d "
 			    "seq_err=%d inval_xmt_word=%d inval_crc=%d.\n",
@@ -1672,8 +1676,8 @@
 		rval = BIT_1;
 	}
 
-	pci_free_consistent(ha->pdev, sizeof(link_stat_t),
-	    stat_buf, phys_address);
+	pci_free_consistent(ha->pdev, sizeof(link_stat_t), stat_buf,
+	    phys_address);
 
 	return rval;
 }

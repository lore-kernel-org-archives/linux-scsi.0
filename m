From: wenxiong@vmlinux.vnet.ibm.com
Subject: [PATCH RESEND 1/7] ipr: Remove extended delay bit on GSCSI reads/writes ops
Date: Wed, 12 Mar 2014 16:08:46 -0500
Message-ID: <20140312210905.802415034@vmlinux.vnet.ibm.com>
References: <20140312210845.384489953@vmlinux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [32.97.110.57] ([32.97.110.57]:60415 "HELO
	jupiter1-lp2.austin.ibm.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1752690AbaCLVMK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Mar 2014 17:12:10 -0400
Content-Disposition: inline; filename=delay
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, bjking1@us.ibm.com, Wen Xiong <wenxiong@linux.vnet.ibm.com>

This patch removes extended delay bit on GSCSI reads/writes ops, the
performance will be significanly better.

Signed-off-by: Wen Xiong <wenxiong@linux.vnet.ibm.com>

---
 drivers/scsi/ipr.c |    6 +++++-
 drivers/scsi/ipr.h |    1 +
 2 files changed, 6 insertions(+), 1 deletion(-)

Index: b/drivers/scsi/ipr.c
===================================================================
--- a/drivers/scsi/ipr.c	2014-03-11 17:11:04.487766647 -0500
+++ b/drivers/scsi/ipr.c	2014-03-11 17:12:07.218702192 -0500
@@ -1143,6 +1143,7 @@ static void ipr_init_res_entry(struct ip
 	res->add_to_ml = 0;
 	res->del_from_ml = 0;
 	res->resetting_device = 0;
+	res->reset_occurred = 0;
 	res->sdev = NULL;
 	res->sata_port = NULL;
 
@@ -5015,6 +5016,7 @@ static int __ipr_eh_dev_reset(struct scs
 	} else
 		rc = ipr_device_reset(ioa_cfg, res);
 	res->resetting_device = 0;
+	res->reset_occurred = 1;
 
 	LEAVE;
 	return rc ? FAILED : SUCCESS;
@@ -6183,8 +6185,10 @@ static int ipr_queuecommand(struct Scsi_
 			ioarcb->cmd_pkt.flags_hi |= IPR_FLAGS_HI_NO_ULEN_CHK;
 
 		ioarcb->cmd_pkt.flags_hi |= IPR_FLAGS_HI_NO_LINK_DESC;
-		if (ipr_is_gscsi(res))
+		if (ipr_is_gscsi(res) && res->reset_occurred) {
+			res->reset_occurred = 0;
 			ioarcb->cmd_pkt.flags_lo |= IPR_FLAGS_LO_DELAY_AFTER_RST;
+		}
 		ioarcb->cmd_pkt.flags_lo |= IPR_FLAGS_LO_ALIGNED_BFR;
 		ioarcb->cmd_pkt.flags_lo |= ipr_get_task_attributes(scsi_cmd);
 	}
Index: b/drivers/scsi/ipr.h
===================================================================
--- a/drivers/scsi/ipr.h	2014-03-11 17:10:58.577766209 -0500
+++ b/drivers/scsi/ipr.h	2014-03-11 17:12:07.218702192 -0500
@@ -1252,6 +1252,7 @@ struct ipr_resource_entry {
 	u8 add_to_ml:1;
 	u8 del_from_ml:1;
 	u8 resetting_device:1;
+	u8 reset_occurred:1;
 
 	u32 bus;		/* AKA channel */
 	u32 target;		/* AKA id */

-- 

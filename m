From: madhu.iyengar@qlogic.com
Subject: [PATCH 11/14] qla2xxx: Display mailbox register 4 during 8012 AEN for ISP82XX parts.
Date: Tue, 21 Dec 2010 16:00:24 -0800
Message-ID: <1292976027-12034-12-git-send-email-madhu.iyengar@qlogic.com>
References: <1292976027-12034-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:36170 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1752862Ab0LVADZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Dec 2010 19:03:25 -0500
In-Reply-To: <1292976027-12034-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_isr.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 7f77898..d17ed9a 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -321,6 +321,7 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
 	struct qla_hw_data *ha = vha->hw;
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 	struct device_reg_24xx __iomem *reg24 = &ha->iobase->isp24;
+	struct device_reg_82xx __iomem *reg82 = &ha->iobase->isp82;
 	uint32_t	rscn_entry, host_pid;
 	uint8_t		rscn_queue_index;
 	unsigned long	flags;
@@ -498,6 +499,7 @@ skip_rio:
 
 	case MBA_LOOP_DOWN:		/* Loop Down Event */
 		mbx = IS_QLA81XX(ha) ? RD_REG_WORD(&reg24->mailbox4) : 0;
+		mbx = IS_QLA82XX(ha) ? RD_REG_WORD(&reg82->mailbox_out[4]) : mbx;
 		DEBUG2(printk("scsi(%ld): Asynchronous LOOP DOWN "
 		    "(%x %x %x %x).\n", vha->host_no, mb[1], mb[2], mb[3],
 		    mbx));
-- 
1.6.0.2


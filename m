From: madhu.iyengar@qlogic.com
Subject: [PATCH 06/14] qla2xxx: Fix for memory wedge on fw halt for ISP82XX
Date: Tue, 21 Dec 2010 16:00:19 -0800
Message-ID: <1292976027-12034-7-git-send-email-madhu.iyengar@qlogic.com>
References: <1292976027-12034-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:36165 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1753291Ab0LVADY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Dec 2010 19:03:24 -0500
In-Reply-To: <1292976027-12034-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>

From: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>

Signed-off-by: Swapnil Nagle <swapnil.nagle@qlogic.com>
Signed-off-by: Karen Higgins <karen.higgins@qlogic.com>
Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_nx.c |   44 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 44 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index 9175e84..6ea5e98 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -1079,11 +1079,55 @@ qla82xx_pinit_from_rom(scsi_qla_host_t *vha)
 
 	/* Halt all the indiviual PEGs and other blocks of the ISP */
 	qla82xx_rom_lock(ha);
+
+	/* mask all niu interrupts */
+	qla82xx_wr_32(ha, QLA82XX_CRB_NIU + 0x40, 0xff);
+	/* disable xge rx/tx */
+	qla82xx_wr_32(ha, QLA82XX_CRB_NIU + 0x70000, 0x00);
+	/* disable xg1 rx/tx */
+	qla82xx_wr_32(ha, QLA82XX_CRB_NIU + 0x80000, 0x00);
+
+	/* halt sre */
+	val = qla82xx_rd_32(ha, QLA82XX_CRB_SRE + 0x1000);
+	qla82xx_wr_32(ha, QLA82XX_CRB_SRE + 0x1000, val & (~(0x1)));
+
+	/* halt epg */
+	qla82xx_wr_32(ha, QLA82XX_CRB_EPG + 0x1300, 0x1);
+
+	/* halt timers */
+	qla82xx_wr_32(ha, QLA82XX_CRB_TIMER + 0x0, 0x0);
+	qla82xx_wr_32(ha, QLA82XX_CRB_TIMER + 0x8, 0x0);
+	qla82xx_wr_32(ha, QLA82XX_CRB_TIMER + 0x10, 0x0);
+	qla82xx_wr_32(ha, QLA82XX_CRB_TIMER + 0x18, 0x0);
+	qla82xx_wr_32(ha, QLA82XX_CRB_TIMER + 0x100, 0x0);
+
+	/* halt pegs */
+	qla82xx_wr_32(ha, QLA82XX_CRB_PEG_NET_0 + 0x3c, 1);
+	qla82xx_wr_32(ha, QLA82XX_CRB_PEG_NET_1 + 0x3c, 1);
+	qla82xx_wr_32(ha, QLA82XX_CRB_PEG_NET_2 + 0x3c, 1);
+	qla82xx_wr_32(ha, QLA82XX_CRB_PEG_NET_3 + 0x3c, 1);
+	qla82xx_wr_32(ha, QLA82XX_CRB_PEG_NET_4 + 0x3c, 1);
+
+	/* big hammer */
+	msleep(1000);
 	if (test_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags))
 		/* don't reset CAM block on reset */
 		qla82xx_wr_32(ha, QLA82XX_ROMUSB_GLB_SW_RESET, 0xfeffffff);
 	else
 		qla82xx_wr_32(ha, QLA82XX_ROMUSB_GLB_SW_RESET, 0xffffffff);
+
+	/* reset ms */
+	val = qla82xx_rd_32(ha, QLA82XX_CRB_QDR_NET + 0xe4);
+	val |= (1 << 1);
+	qla82xx_wr_32(ha, QLA82XX_CRB_QDR_NET + 0xe4, val);
+	msleep(20);
+
+	/* unreset ms */
+	val = qla82xx_rd_32(ha, QLA82XX_CRB_QDR_NET + 0xe4);
+	val &= ~(1 << 1);
+	qla82xx_wr_32(ha, QLA82XX_CRB_QDR_NET + 0xe4, val);
+	msleep(20);
+
 	qla82xx_rd_32(ha, QLA82XX_PCIE_REG(PCIE_SEM2_UNLOCK));
 
 	/* Read the signature value from the flash.
-- 
1.6.0.2


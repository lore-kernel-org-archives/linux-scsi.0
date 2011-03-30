From: madhu.iyengar@qlogic.com
Subject: [PATCH 09/18] qla2xxx: Updated the reset sequence for ISP82xx.
Date: Wed, 30 Mar 2011 11:46:24 -0700
Message-ID: <1301510793-2492-10-git-send-email-madhu.iyengar@qlogic.com>
References: <1301510793-2492-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:45796 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1754815Ab1C3SvQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Mar 2011 14:51:16 -0400
In-Reply-To: <1301510793-2492-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_nx.c |   19 +++++++++++++++++--
 1 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index b221705..d823098 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -1081,12 +1081,26 @@ qla82xx_pinit_from_rom(scsi_qla_host_t *vha)
 	/* Halt all the indiviual PEGs and other blocks of the ISP */
 	qla82xx_rom_lock(ha);
 
-	/* mask all niu interrupts */
+	/* disable all I2Q */
+	qla82xx_wr_32(ha, QLA82XX_CRB_I2Q + 0x10, 0x0);
+	qla82xx_wr_32(ha, QLA82XX_CRB_I2Q + 0x14, 0x0);
+	qla82xx_wr_32(ha, QLA82XX_CRB_I2Q + 0x18, 0x0);
+	qla82xx_wr_32(ha, QLA82XX_CRB_I2Q + 0x1c, 0x0);
+	qla82xx_wr_32(ha, QLA82XX_CRB_I2Q + 0x20, 0x0);
+	qla82xx_wr_32(ha, QLA82XX_CRB_I2Q + 0x24, 0x0);
+
+	/* disable all niu interrupts */
 	qla82xx_wr_32(ha, QLA82XX_CRB_NIU + 0x40, 0xff);
 	/* disable xge rx/tx */
 	qla82xx_wr_32(ha, QLA82XX_CRB_NIU + 0x70000, 0x00);
 	/* disable xg1 rx/tx */
 	qla82xx_wr_32(ha, QLA82XX_CRB_NIU + 0x80000, 0x00);
+	/* disable sideband mac */
+	qla82xx_wr_32(ha, QLA82XX_CRB_NIU + 0x90000, 0x00);
+	/* disable ap0 mac */
+	qla82xx_wr_32(ha, QLA82XX_CRB_NIU + 0xa0000, 0x00);
+	/* disable ap1 mac */
+	qla82xx_wr_32(ha, QLA82XX_CRB_NIU + 0xb0000, 0x00);
 
 	/* halt sre */
 	val = qla82xx_rd_32(ha, QLA82XX_CRB_SRE + 0x1000);
@@ -1101,6 +1115,7 @@ qla82xx_pinit_from_rom(scsi_qla_host_t *vha)
 	qla82xx_wr_32(ha, QLA82XX_CRB_TIMER + 0x10, 0x0);
 	qla82xx_wr_32(ha, QLA82XX_CRB_TIMER + 0x18, 0x0);
 	qla82xx_wr_32(ha, QLA82XX_CRB_TIMER + 0x100, 0x0);
+	qla82xx_wr_32(ha, QLA82XX_CRB_TIMER + 0x200, 0x0);
 
 	/* halt pegs */
 	qla82xx_wr_32(ha, QLA82XX_CRB_PEG_NET_0 + 0x3c, 1);
@@ -1108,9 +1123,9 @@ qla82xx_pinit_from_rom(scsi_qla_host_t *vha)
 	qla82xx_wr_32(ha, QLA82XX_CRB_PEG_NET_2 + 0x3c, 1);
 	qla82xx_wr_32(ha, QLA82XX_CRB_PEG_NET_3 + 0x3c, 1);
 	qla82xx_wr_32(ha, QLA82XX_CRB_PEG_NET_4 + 0x3c, 1);
+	msleep(20);
 
 	/* big hammer */
-	msleep(1000);
 	if (test_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags))
 		/* don't reset CAM block on reset */
 		qla82xx_wr_32(ha, QLA82XX_ROMUSB_GLB_SW_RESET, 0xfeffffff);
-- 
1.6.0.2


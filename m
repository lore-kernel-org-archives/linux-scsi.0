From: vikas.chaudhary@qlogic.com
Subject: [PATCH 02/10] qla4xxx: Updated the reset sequence for ISP82xx
Date: Tue, 17 May 2011 23:17:04 -0700
Message-ID: <1305699432-13225-3-git-send-email-vikas.chaudhary@qlogic.com>
References: <1305699432-13225-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:50922 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1754359Ab1ERGXq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 May 2011 02:23:46 -0400
In-Reply-To: <1305699432-13225-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_nx.c |   19 +++++++++++++++++--
 1 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.c
index 35381cb..e1085ed 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.c
+++ b/drivers/scsi/qla4xxx/ql4_nx.c
@@ -943,12 +943,26 @@ qla4_8xxx_pinit_from_rom(struct scsi_qla_host *ha, int verbose)
 	/* Halt all the indiviual PEGs and other blocks of the ISP */
 	qla4_8xxx_rom_lock(ha);
 
-	/* mask all niu interrupts */
+	/* disable all I2Q */
+	qla4_8xxx_wr_32(ha, QLA82XX_CRB_I2Q + 0x10, 0x0);
+	qla4_8xxx_wr_32(ha, QLA82XX_CRB_I2Q + 0x14, 0x0);
+	qla4_8xxx_wr_32(ha, QLA82XX_CRB_I2Q + 0x18, 0x0);
+	qla4_8xxx_wr_32(ha, QLA82XX_CRB_I2Q + 0x1c, 0x0);
+	qla4_8xxx_wr_32(ha, QLA82XX_CRB_I2Q + 0x20, 0x0);
+	qla4_8xxx_wr_32(ha, QLA82XX_CRB_I2Q + 0x24, 0x0);
+
+	/* disable all niu interrupts */
 	qla4_8xxx_wr_32(ha, QLA82XX_CRB_NIU + 0x40, 0xff);
 	/* disable xge rx/tx */
 	qla4_8xxx_wr_32(ha, QLA82XX_CRB_NIU + 0x70000, 0x00);
 	/* disable xg1 rx/tx */
 	qla4_8xxx_wr_32(ha, QLA82XX_CRB_NIU + 0x80000, 0x00);
+	/* disable sideband mac */
+	qla4_8xxx_wr_32(ha, QLA82XX_CRB_NIU + 0x90000, 0x00);
+	/* disable ap0 mac */
+	qla4_8xxx_wr_32(ha, QLA82XX_CRB_NIU + 0xa0000, 0x00);
+	/* disable ap1 mac */
+	qla4_8xxx_wr_32(ha, QLA82XX_CRB_NIU + 0xb0000, 0x00);
 
 	/* halt sre */
 	val = qla4_8xxx_rd_32(ha, QLA82XX_CRB_SRE + 0x1000);
@@ -963,6 +977,7 @@ qla4_8xxx_pinit_from_rom(struct scsi_qla_host *ha, int verbose)
 	qla4_8xxx_wr_32(ha, QLA82XX_CRB_TIMER + 0x10, 0x0);
 	qla4_8xxx_wr_32(ha, QLA82XX_CRB_TIMER + 0x18, 0x0);
 	qla4_8xxx_wr_32(ha, QLA82XX_CRB_TIMER + 0x100, 0x0);
+	qla4_8xxx_wr_32(ha, QLA82XX_CRB_TIMER + 0x200, 0x0);
 
 	/* halt pegs */
 	qla4_8xxx_wr_32(ha, QLA82XX_CRB_PEG_NET_0 + 0x3c, 1);
@@ -970,9 +985,9 @@ qla4_8xxx_pinit_from_rom(struct scsi_qla_host *ha, int verbose)
 	qla4_8xxx_wr_32(ha, QLA82XX_CRB_PEG_NET_2 + 0x3c, 1);
 	qla4_8xxx_wr_32(ha, QLA82XX_CRB_PEG_NET_3 + 0x3c, 1);
 	qla4_8xxx_wr_32(ha, QLA82XX_CRB_PEG_NET_4 + 0x3c, 1);
+	msleep(5);
 
 	/* big hammer */
-	msleep(1000);
 	if (test_bit(DPC_RESET_HA, &ha->dpc_flags))
 		/* don't reset CAM block on reset */
 		qla4_8xxx_wr_32(ha, QLA82XX_ROMUSB_GLB_SW_RESET, 0xfeffffff);
-- 
1.7.3.2


From: Joao Pinto <Joao.Pinto@synopsys.com>
Subject: [PATCH v15 4/9] ufs: added unipro attributes
Date: Mon,  2 May 2016 14:55:30 +0100
Message-ID: <b1879aeb1d975b71f6e13e3a0e1e8570c759886c.1462187952.git.jpinto@synopsys.com>
References: <c6e39c4050ec0d43186465b04fb8c4b18b93e98e.1462187952.git.jpinto@synopsys.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from us01smtprelay-2.synopsys.com ([198.182.60.111]:46481 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045AbcEBNzu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 May 2016 09:55:50 -0400
In-Reply-To: <c6e39c4050ec0d43186465b04fb8c4b18b93e98e.1462187952.git.jpinto@synopsys.com>
In-Reply-To: <c6e39c4050ec0d43186465b04fb8c4b18b93e98e.1462187952.git.jpinto@synopsys.com>
References: <c6e39c4050ec0d43186465b04fb8c4b18b93e98e.1462187952.git.jpinto@synopsys.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, Joao Pinto <Joao.Pinto@synopsys.com>

Added unipro attributes.

Signed-off-by: Joao Pinto <jpinto@synopsys.com>
Acked-by: Tomas Winkler <tomas.winkler@intel.com>
---
Changes v12->v15:
- Nothing changed (just to keep up with patch set version).
Changes v0->v12 (Tomas Winkler):
- This patch only appeared in v12

 drivers/scsi/ufs/unipro.h | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/drivers/scsi/ufs/unipro.h b/drivers/scsi/ufs/unipro.h
index e2854e4..eff8b56 100644
--- a/drivers/scsi/ufs/unipro.h
+++ b/drivers/scsi/ufs/unipro.h
@@ -36,6 +36,10 @@
 #define TX_LCC_SEQUENCER			0x0032
 #define TX_MIN_ACTIVATETIME			0x0033
 #define TX_PWM_G6_G7_SYNC_LENGTH		0x0034
+#define TX_REFCLKFREQ				0x00EB
+#define TX_CFGCLKFREQVAL			0x00EC
+#define	CFGEXTRATTR				0x00F0
+#define DITHERCTRL2				0x00F1
 
 /*
  * M-RX Configuration Attributes
@@ -51,10 +55,40 @@
 #define RX_TERMINATION_FORCE_ENABLE		0x0089
 #define RX_MIN_ACTIVATETIME_CAPABILITY		0x008F
 #define RX_HIBERN8TIME_CAPABILITY		0x0092
+#define RX_REFCLKFREQ				0x00EB
+#define	RX_CFGCLKFREQVAL			0x00EC
+#define CFGWIDEINLN				0x00F0
+#define CFGRXCDR8				0x00BA
+#define ENARXDIRECTCFG4				0x00F2
+#define CFGRXOVR8				0x00BD
+#define RXDIRECTCTRL2				0x00C7
+#define ENARXDIRECTCFG3				0x00F3
+#define RXCALCTRL				0x00B4
+#define ENARXDIRECTCFG2				0x00F4
+#define CFGRXOVR4				0x00E9
+#define RXSQCTRL				0x00B5
+#define CFGRXOVR6				0x00BF
 
 #define is_mphy_tx_attr(attr)			(attr < RX_MODE)
 #define RX_MIN_ACTIVATETIME_UNIT_US		100
 #define HIBERN8TIME_UNIT_US			100
+
+/*
+ * Common Block Attributes
+ */
+#define TX_GLOBALHIBERNATE			UNIPRO_CB_OFFSET(0x002B)
+#define REFCLKMODE				UNIPRO_CB_OFFSET(0x00BF)
+#define DIRECTCTRL19				UNIPRO_CB_OFFSET(0x00CD)
+#define DIRECTCTRL10				UNIPRO_CB_OFFSET(0x00E6)
+#define CDIRECTCTRL6				UNIPRO_CB_OFFSET(0x00EA)
+#define RTOBSERVESELECT				UNIPRO_CB_OFFSET(0x00F0)
+#define CBDIVFACTOR				UNIPRO_CB_OFFSET(0x00F1)
+#define CBDCOCTRL5				UNIPRO_CB_OFFSET(0x00F3)
+#define CBPRGPLL2				UNIPRO_CB_OFFSET(0x00F8)
+#define CBPRGTUNING				UNIPRO_CB_OFFSET(0x00FB)
+
+#define UNIPRO_CB_OFFSET(x)			(0x8000 | x)
+
 /*
  * PHY Adpater attributes
  */
@@ -119,6 +153,11 @@
 #define PA_TACTIVATE_TIME_UNIT_US	10
 #define PA_HIBERN8_TIME_UNIT_US		100
 
+/*Other attributes*/
+#define VS_MPHYCFGUPDT		0xD085
+#define VS_DEBUGOMC		0xD09E
+#define VS_POWERSTATE		0xD083
+
 /* PHY Adapter Protocol Constants */
 #define PA_MAXDATALANES	4
 
-- 
1.8.1.5


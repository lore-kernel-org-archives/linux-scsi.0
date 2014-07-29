From: Suman Tripathi <stripathi@apm.com>
Subject: [PATCH v4 1/4] ata: Fix the watermark threshold for the APM X-Gene SATA host controller driver.
Date: Tue, 29 Jul 2014 12:24:49 +0530
Message-ID: <1406616892-30273-2-git-send-email-stripathi@apm.com>
References: <1406616892-30273-1-git-send-email-stripathi@apm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from denmail01-v4020.amcc.com ([192.195.68.30]:52611 "EHLO
	denmail01.apm.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752093AbaG2Gzt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Jul 2014 02:55:49 -0400
In-Reply-To: <1406616892-30273-1-git-send-email-stripathi@apm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, ddutile@redhat.com, jcm@redhat.com, patches@apm.com, Suman Tripathi <stripathi@apm.com>, Loc Ho <lho@apm.com>

As per SATA IO specification, when Host sends HOLD, the device takes
about 20DW latency to reply to HOLDA. In some case, device doesn't
response to HOLDA over 20DW and causes FIFO goes into over flow
condition. Due to this condition, device enumerations fails with
those devices. This patch adjust the watermark FIFO by increasing
the FIFO depth from 0x16(default) to 0x30 to address this issue.

Signed-off-by: Loc Ho <lho@apm.com>
Signed-off-by: Suman Tripathi <stripathi@apm.com>
---
 drivers/ata/ahci_xgene.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/ata/ahci_xgene.c b/drivers/ata/ahci_xgene.c
index 77c89bf..03b6b0f 100644
--- a/drivers/ata/ahci_xgene.c
+++ b/drivers/ata/ahci_xgene.c
@@ -67,6 +67,9 @@
 #define PORTAXICFG			0x000000bc
 #define PORTAXICFG_OUTTRANS_SET(dst, src) \
 		(((dst) & ~0x00f00000) | (((u32)(src) << 0x14) & 0x00f00000))
+#define PORTRANSCFG			0x000000c8
+#define PORTRANSCFG_RXWM_SET(dst, src)		\
+		(((dst) & ~0x0000007f) | (((u32)(src)) & 0x0000007f))

 /* SATA host controller AXI CSR */
 #define INT_SLV_TMOMASK			0x00000010
@@ -176,6 +179,10 @@ static void xgene_ahci_set_phy_cfg(struct xgene_ahci_context *ctx, int channel)
 	val = PORTAXICFG_OUTTRANS_SET(val, 0xe); /* Set outstanding */
 	writel(val, mmio + PORTAXICFG);
 	readl(mmio + PORTAXICFG); /* Force a barrier */
+	/* Set the watermark threshold of the receive FIFO */
+	val = readl(mmio + PORTRANSCFG);
+	val = PORTRANSCFG_RXWM_SET(val, 0x30);
+	writel(val, mmio + PORTRANSCFG);
 }

 /**
--
1.8.2.1


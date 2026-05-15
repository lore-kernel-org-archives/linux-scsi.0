Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6126322083;
	Fri, 15 May 2026 02:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778813302; cv=none; b=XNFZ9qopweJHWLY040zIV5lQ9AjS/Y/KRpQ8gcq2Fph1T6vNFn9J17zyWWdDwwy2uGcMPEF3/qaIgVAtAAok6L0rBtBJiRc4eFNX//mEMj9Hi/lpLhH6b096PgYlF3T8lfL6DUhp1K8QDdnMzLoSK3Z+GUOp8eknX8P9OL+CXUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778813302; c=relaxed/simple;
	bh=YkzkOrylA8nEm2aG/s/kNWb70b8eyU8VaWurgGh5W6Q=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=OlI3aaqxd9UfsqG5huNceGdXtaNgdKPzlJx63V101KvAAS/Wg1gmLiu2MWi3Cq3F7gNqZuLgp+JHsI5uTmntDmTcr3BNtU8RUTYspLPsh4fkg2ixcU0Cmj4PGrPdMbM9Z7bmWRLN80yEadKxkeH9iM9T1zgfHwWQ8WJ0ldOhG2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 856bc238500811f1aa26b74ffac11d73-20260515
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:2f495cb5-31e9-4292-a226-c16665d23828,IP:0,U
	RL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-5
X-CID-META: VersionHash:e7bac3a,CLOUDID:8c522fb1b43ce2e26dac7905457bb932,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:102|850|898,TC:nil,Content:0|15|50,EDM:-
	3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,A
	V:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 856bc238500811f1aa26b74ffac11d73-20260515
X-User: zenghongling@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <zenghongling@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 630515043; Fri, 15 May 2026 10:48:15 +0800
From: Hongling Zeng <zenghongling@kylinos.cn>
To: hare@kernel.org,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhongling0719@126.com,
	Hongling Zeng <zenghongling@kylinos.cn>
Subject: [PATCH] scsi: myrb: Fix region leak in hw_init functions
Date: Fri, 15 May 2026 10:48:11 +0800
Message-Id: <20260515024811.17858-1-zenghongling@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When DAC960_PD_hw_init() and DAC960_P_hw_init() fail after successfully
requesting the I/O region with request_region(), the region is not
released before returning. This causes a resource leak.

Fix this by using a common error label to release the I/O region
before returning error codes, following the kernel's standard
error handling pattern.

Fixes: 081ff398c56c ("scsi: myrb: Add Mylex RAID controller (block interface)")
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
---
 drivers/scsi/myrb.c | 34 ++++++++++++++++++++++++++--------
 1 file changed, 26 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/myrb.c b/drivers/scsi/myrb.c
index 3678b66310ed..28cdf648783e 100644
--- a/drivers/scsi/myrb.c
+++ b/drivers/scsi/myrb.c
@@ -3111,6 +3111,7 @@ static int DAC960_PD_hw_init(struct pci_dev *pdev,
 {
 	int timeout = 0;
 	unsigned char error, parm0, parm1;
+	int ret = 0;
 
 	if (!request_region(cb->io_addr, 0x80, "myrb")) {
 		dev_err(&pdev->dev, "IO port 0x%lx busy\n",
@@ -3124,21 +3125,25 @@ static int DAC960_PD_hw_init(struct pci_dev *pdev,
 	       timeout < MYRB_MAILBOX_TIMEOUT) {
 		if (DAC960_PD_read_error_status(base, &error,
 					      &parm0, &parm1) &&
-		    myrb_err_status(cb, error, parm0, parm1))
-			return -EIO;
+		    myrb_err_status(cb, error, parm0, parm1)) {
+			ret = -EIO;
+			goto out_release_region;
+		}
 		udelay(10);
 		timeout++;
 	}
 	if (timeout == MYRB_MAILBOX_TIMEOUT) {
 		dev_err(&pdev->dev,
 			"Timeout waiting for Controller Initialisation\n");
-		return -ETIMEDOUT;
+		ret = -ETIMEDOUT;
+		goto out_release_region;
 	}
 	if (!myrb_enable_mmio(cb, NULL)) {
 		dev_err(&pdev->dev,
 			"Unable to Enable Memory Mailbox Interface\n");
 		DAC960_PD_reset_ctrl(base);
-		return -ENODEV;
+		ret = -ENODEV;
+		goto out_release_region;
 	}
 	DAC960_PD_enable_intr(base);
 	cb->qcmd = DAC960_PD_qcmd;
@@ -3146,6 +3151,10 @@ static int DAC960_PD_hw_init(struct pci_dev *pdev,
 	cb->reset = DAC960_PD_reset_ctrl;
 
 	return 0;
+
+out_release_region:
+	release_region(cb->io_addr, 0x80);
+	return ret;
 }
 
 static irqreturn_t DAC960_PD_intr_handler(int irq, void *arg)
@@ -3277,6 +3286,7 @@ static int DAC960_P_hw_init(struct pci_dev *pdev,
 {
 	int timeout = 0;
 	unsigned char error, parm0, parm1;
+	int ret = 0;
 
 	if (!request_region(cb->io_addr, 0x80, "myrb")) {
 		dev_err(&pdev->dev, "IO port 0x%lx busy\n",
@@ -3290,21 +3300,25 @@ static int DAC960_P_hw_init(struct pci_dev *pdev,
 	       timeout < MYRB_MAILBOX_TIMEOUT) {
 		if (DAC960_PD_read_error_status(base, &error,
 						&parm0, &parm1) &&
-		    myrb_err_status(cb, error, parm0, parm1))
-			return -EAGAIN;
+		    myrb_err_status(cb, error, parm0, parm1)) {
+			ret = -EAGAIN;
+			goto out_release_region;
+		}
 		udelay(10);
 		timeout++;
 	}
 	if (timeout == MYRB_MAILBOX_TIMEOUT) {
 		dev_err(&pdev->dev,
 			"Timeout waiting for Controller Initialisation\n");
-		return -ETIMEDOUT;
+		ret = -ETIMEDOUT;
+		goto out_release_region;
 	}
 	if (!myrb_enable_mmio(cb, NULL)) {
 		dev_err(&pdev->dev,
 			"Unable to allocate DMA mapped memory\n");
 		DAC960_PD_reset_ctrl(base);
-		return -ETIMEDOUT;
+		ret = -ETIMEDOUT;
+		goto out_release_region;
 	}
 	DAC960_PD_enable_intr(base);
 	cb->qcmd = DAC960_P_qcmd;
@@ -3312,6 +3326,10 @@ static int DAC960_P_hw_init(struct pci_dev *pdev,
 	cb->reset = DAC960_PD_reset_ctrl;
 
 	return 0;
+
+out_release_region:
+	release_region(cb->io_addr, 0x80);
+	return ret;
 }
 
 static irqreturn_t DAC960_P_intr_handler(int irq, void *arg)
-- 
2.25.1


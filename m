Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5629C433F5
	for <linux-scsi@archiver.kernel.org>; Sun, 22 May 2022 08:19:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241235AbiEVITj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 22 May 2022 04:19:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230461AbiEVITh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 22 May 2022 04:19:37 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3157227CF3
        for <linux-scsi@vger.kernel.org>; Sun, 22 May 2022 01:19:36 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id A6A1B21A51;
        Sun, 22 May 2022 08:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1653207574; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=dS/go9y2/G5eo8pMz5L5F3j8+HaeVCrvf5u6NT3/3+A=;
        b=TEMAHEO+CmZQN8cWAhZXUCs52WTuVD55Tuy8cHRpNh0pJp7waZAWA+ZI/uyH6Fc7N90xpp
        +j/0jclfQQy2v4Cm9tX644btVAGSiyZxTw8RUDNIh/DWulsHAPrz7CmB2tdEZ/rRcVQxI8
        jZ58uPw5BOHKmvV4nzHtNWl2TbN8JAw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1653207574;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=dS/go9y2/G5eo8pMz5L5F3j8+HaeVCrvf5u6NT3/3+A=;
        b=1tlVDFQKm8f6zg7c9cpj92qA+q01h53CwKaJuWW3s82/EUld1HZv9lRbzJimBepHAjVLTc
        qQIwug2NHsQ8oHCw==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id AA8422C141;
        Sun, 22 May 2022 08:19:33 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 9D4C551945E3; Sun, 22 May 2022 10:19:33 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Zheyu Ma <zheyuma97@gmail.com>
Subject: [PATCH] myrb: fixup null pointer access on myrb_cleanup()
Date:   Sun, 22 May 2022 10:19:21 +0200
Message-Id: <20220522081921.105515-1-hare@suse.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When myrb_probe() fails the callback might not be set, so we need
to validate the 'disable_intr' callback in myrb_cleanup() to not
cause a null pointer exception. And while at it do not call
myrb_cleanup() if we cannot enable the PCI device at all.

Reported-by: Zheyu Ma <zheyuma97@gmail.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/myrb.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/myrb.c b/drivers/scsi/myrb.c
index 71585528e8db..f460aed2435f 100644
--- a/drivers/scsi/myrb.c
+++ b/drivers/scsi/myrb.c
@@ -1239,7 +1239,8 @@ static void myrb_cleanup(struct myrb_hba *cb)
 	myrb_unmap(cb);
 
 	if (cb->mmio_base) {
-		cb->disable_intr(cb->io_base);
+		if (cb->disable_intr)
+			cb->disable_intr(cb->io_base);
 		iounmap(cb->mmio_base);
 	}
 	if (cb->irq)
@@ -3414,8 +3415,11 @@ static struct myrb_hba *myrb_detect(struct pci_dev *pdev,
 	mutex_init(&cb->dma_mutex);
 	cb->pdev = pdev;
 
-	if (pci_enable_device(pdev))
-		goto failure;
+	if (pci_enable_device(pdev)) {
+		dev_err(&pdev->dev, "Failed to enable PCI device\n");
+		scsi_host_put(shost);
+		return NULL;
+	}
 
 	if (privdata->hw_init == DAC960_PD_hw_init ||
 	    privdata->hw_init == DAC960_P_hw_init) {
-- 
2.29.2


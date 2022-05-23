Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C78BBC433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 23 May 2022 12:02:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235322AbiEWMCv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 May 2022 08:02:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235324AbiEWMCs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 May 2022 08:02:48 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81D7624F03
        for <linux-scsi@vger.kernel.org>; Mon, 23 May 2022 05:02:46 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id F022B1F8BE;
        Mon, 23 May 2022 12:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1653307364; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=E+/WcHV/pFWN/ZqaPouJZ48cXXiXCAGJ0RAXgFYl3wU=;
        b=wY1v2vC7EDJXjDBM4++5kwCbsNjvdTOKMrdNIrRs1ujxY0TJcCPWfTUJASaSeDZee4pVQw
        E0dEvozd5qsp7UYCpoY4O8cPBChoRfVFnr0G2SMrbCzwgKbxZ5jWl03Dc5e/y27Wz+Xdvu
        rczhI65kyygVjl1/F7Dy4oWxJXFG/Ps=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1653307364;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=E+/WcHV/pFWN/ZqaPouJZ48cXXiXCAGJ0RAXgFYl3wU=;
        b=8uCZBP0i51ON99G1j/Bbob+tdZ+2JPQ3hbRWdhVENvZ2cfSDNFtriGjS+R3I+fHGlYJxIj
        NsBiJZaQixeBW0Ag==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id DCEBF2C141;
        Mon, 23 May 2022 12:02:44 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id CAECF5194619; Mon, 23 May 2022 14:02:44 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Zheyu Ma <zheyuma97@gmail.com>
Subject: [PATCHv2] myrb: fixup null pointer access on myrb_cleanup()
Date:   Mon, 23 May 2022 14:02:44 +0200
Message-Id: <20220523120244.99515-1-hare@suse.de>
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
 drivers/scsi/myrb.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/myrb.c b/drivers/scsi/myrb.c
index 71585528e8db..e885c1dbf61f 100644
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
@@ -3413,9 +3414,13 @@ static struct myrb_hba *myrb_detect(struct pci_dev *pdev,
 	mutex_init(&cb->dcmd_mutex);
 	mutex_init(&cb->dma_mutex);
 	cb->pdev = pdev;
+	cb->host = shost;
 
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


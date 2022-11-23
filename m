Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12F31C433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Nov 2022 13:34:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238749AbiKWNeS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Nov 2022 08:34:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238912AbiKWNcZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Nov 2022 08:32:25 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0D0BDF74
        for <linux-scsi@vger.kernel.org>; Wed, 23 Nov 2022 05:18:03 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 3CD8B21BE4;
        Wed, 23 Nov 2022 13:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1669209482; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=1qtmFEjC7Gau5nXTNg6c3cXB1dSp0ynM79TxpoBXrnM=;
        b=b/NU4xSi6mSjQNZcNT4Hu+28B2gn9l4EmyElvOPXfwJCTqpJCSfgfiG+G9wYJV5/BBJnwH
        Unb0iphlaHOq0kcCdWWp+9fHRtkXks2R/N3YrCrQ3msMZBLwvxrBPy32wclZL++2Y3a4+2
        BasTsFYUBJgk0NxBj8XG/0Ve4Vn9H10=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1669209482;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=1qtmFEjC7Gau5nXTNg6c3cXB1dSp0ynM79TxpoBXrnM=;
        b=NfNCF46GCwjRsQKIHSvrrizcp9k/JiEUHUebom7iaY8iD+V4ukeMNo5pVS5+/bEV/upGSG
        bxUyHX3cR5GnMMAg==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 352FB2C142;
        Wed, 23 Nov 2022 13:18:02 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 220EC51AE33A; Wed, 23 Nov 2022 14:18:02 +0100 (CET)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH] scsi: do not put scsi_common in a separate module
Date:   Wed, 23 Nov 2022 14:18:01 +0100
Message-Id: <20221123131801.4409-1-hare@suse.de>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_common.ko is a tiny module which is not shared with anything,
so include it in scsi_mod.ko like the rest of the files.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index f055bfd54a68..d9f5f27246b1 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -20,7 +20,6 @@ CFLAGS_aha152x.o =   -DAHA152X_STAT -DAUTOCONF
 obj-$(CONFIG_PCMCIA)		+= pcmcia/
 
 obj-$(CONFIG_SCSI)		+= scsi_mod.o
-obj-$(CONFIG_SCSI_COMMON)	+= scsi_common.o
 
 obj-$(CONFIG_RAID_ATTRS)	+= raid_class.o
 
@@ -167,6 +166,7 @@ scsi_mod-y			+= scsi_trace.o scsi_logging.o
 scsi_mod-$(CONFIG_PM)		+= scsi_pm.o
 scsi_mod-$(CONFIG_SCSI_DH)	+= scsi_dh.o
 scsi_mod-$(CONFIG_BLK_DEV_BSG)	+= scsi_bsg.o
+scsi_mod-$(CONFIG_SCSI_COMMON)	+= scsi_common.o
 
 hv_storvsc-y			:= storvsc_drv.o
 
-- 
2.35.3


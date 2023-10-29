Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DD31C4167B
	for <linux-scsi@archiver.kernel.org>; Sun, 29 Oct 2023 23:07:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232187AbjJ2XHv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 29 Oct 2023 19:07:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232116AbjJ2XHN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Oct 2023 19:07:13 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C0F593CD;
        Sun, 29 Oct 2023 16:03:02 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95451C4166B;
        Sun, 29 Oct 2023 23:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698620480;
        bh=mj0ILMXpUHhYBb1pCnia6gCc2u6Kw8LGd8pHLh9ZYHA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qI2vpSfRBqDg7KpRAy8eAZVfH4t7c6JjBPgbaFc4Jsgl3njTlxvogD2JBbIOa+dpa
         anVgItjz0z4U/lKmXOyykFjMR0jxfy5YDanTpmyANrhGTp6ot5wqMDJM81SheJ4ieP
         dw31PQuQGLxtHJKRHZwUiTbmu3VU8qcAcvQARUbw5rmnEHqHygL2vW87KmAe1Vy9Jl
         97y4GFpY/Kd9BiOFL7Ltc6QauopAF3ajJJQHdv/f6xIkDV08y3jRQswp07YjEGgzu4
         Ybdjg5+N4NfTSR3Dtr0MY2hnWhnC1JX4g16nntd9s5wea6JNqOMn97Nelb/ojK1e/5
         yi4rj3AtE7swA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tomas Henzl <thenzl@redhat.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, sathya.prakash@broadcom.com,
        sreekanth.reddy@broadcom.com,
        suganath-prabu.subramani@broadcom.com, jejb@linux.ibm.com,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 11/13] scsi: mpt3sas: Fix in error path
Date:   Sun, 29 Oct 2023 19:00:44 -0400
Message-ID: <20231029230057.792930-11-sashal@kernel.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231029230057.792930-1-sashal@kernel.org>
References: <20231029230057.792930-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.4.259
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Tomas Henzl <thenzl@redhat.com>

[ Upstream commit e40c04ade0e2f3916b78211d747317843b11ce10 ]

The driver should be deregistered as misc driver after PCI registration
failure.

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
Link: https://lore.kernel.org/r/20231015114529.10725-1-thenzl@redhat.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 044a00edb5459..4731e464dfb95 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -11138,8 +11138,10 @@ _mpt3sas_init(void)
 	mpt3sas_ctl_init(hbas_to_enumerate);
 
 	error = pci_register_driver(&mpt3sas_driver);
-	if (error)
+	if (error) {
+		mpt3sas_ctl_exit(hbas_to_enumerate);
 		scsih_exit();
+	}
 
 	return error;
 }
-- 
2.42.0


Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34F56C25B08
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Aug 2022 07:26:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbiHQH0y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Aug 2022 03:26:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbiHQH0x (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Aug 2022 03:26:53 -0400
Received: from mx.swemel.ru (mx.swemel.ru [95.143.211.150])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FB5E6BD46
        for <linux-scsi@vger.kernel.org>; Wed, 17 Aug 2022 00:26:52 -0700 (PDT)
From:   Denis Arefev <arefev@swemel.ru>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=swemel.ru; s=mail;
        t=1660720845;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=t8/HL36ILiXUMiDm+KzGUMxwljN0PIyy4doVpjPjc+s=;
        b=dCFOPN8PnQVnXJ/bdKOBaW2NqzSIUsm7kfWML4izVLQW9cA5+vW65etRjDsUNT0TjVpLWU
        GAsFMrvt/6gdmFv2Qpfm5UkeGBmbO5cr+LO4EwDqntbIE3/Xi8IAbc+O8dqT7imF64VD58
        +3iaPP123vb4/8Mfqu2wphrVCzJ6Fzk=
To:     Anil Gurumurthy <anil.gurumurthy@qlogic.com>
Cc:     Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org, trufanov@swemel.ru, vfh@swemel.ru
Subject: [PATCH] bfad_bsg: Buffer overflow decrement loop counter
Date:   Wed, 17 Aug 2022 10:20:45 +0300
Message-Id: <20220817072045.47035-1-arefev@swemel.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Denis Arefev <arefev@swemel.ru>
---
 drivers/scsi/bfa/bfad_bsg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/bfa/bfad_bsg.c b/drivers/scsi/bfa/bfad_bsg.c
index fc515424ca88..2981f49215e5 100644
--- a/drivers/scsi/bfa/bfad_bsg.c
+++ b/drivers/scsi/bfa/bfad_bsg.c
@@ -98,9 +98,9 @@ bfad_iocmd_ioc_get_info(struct bfad_s *bfad, void *cmd)
 
 	/* set adapter hw path */
 	strcpy(iocmd->adapter_hwpath, bfad->pci_name);
-	for (i = 0; iocmd->adapter_hwpath[i] != ':' && i < BFA_STRING_32; i++)
+	for (i = 0; iocmd->adapter_hwpath[i] != ':' && i < BFA_STRING_32-2; i++)
 		;
-	for (; iocmd->adapter_hwpath[++i] != ':' && i < BFA_STRING_32; )
+	for (; iocmd->adapter_hwpath[++i] != ':' && i < BFA_STRING_32-1; )
 		;
 	iocmd->adapter_hwpath[i] = '\0';
 	iocmd->status = BFA_STATUS_OK;
-- 
2.25.1


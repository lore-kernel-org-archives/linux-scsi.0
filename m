Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 959D0C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Feb 2022 21:33:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234694AbiBYVeX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Feb 2022 16:34:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234087AbiBYVeT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Feb 2022 16:34:19 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0534A2118E8
        for <linux-scsi@vger.kernel.org>; Fri, 25 Feb 2022 13:33:47 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id r13so13297842ejd.5
        for <linux-scsi@vger.kernel.org>; Fri, 25 Feb 2022 13:33:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=K7Cw7eu7nDP9gSWCyQumSXQvnof21/Hpw/hSXbhKoc0=;
        b=XFP1TGFIFvS96DH+ZRhA6VduKZIVQ6ky4VVPdkCTMymVIAcpyL4Mz/i5Et/G4RhC2T
         ccL8k8dEiAj6Ie87fYCusYcVDttHBNy5B+Cn9e6xHG2z1kCnWrDCUwltGhzGFnBA99bu
         THirPpE0s/Goap/u9bCZe95JHVwRjsbawuckJG9BPlmcmbIZ262iW4RDII9jPz/T/JcM
         aXFQJsaaiU7ZopFj81fNEMukna6tYsh/T35tRa4y8q49rt6tF7XLJ0AYMkR5dS7lyLm9
         Jw8YuE5lIhglZCh9x95bILj/Ic1NvmrUci+4B1R54GkoJCTJQjsM+p5Gx/KBJWNclgyx
         rDUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=K7Cw7eu7nDP9gSWCyQumSXQvnof21/Hpw/hSXbhKoc0=;
        b=vOGYxflVTJ7S5k18Zy/h0OWvhsWKW83TsKomOmUDHl8ckIP4L+CP7tiEOO2Uuc8B+1
         e2A27q4U/W8RngCGfSzzrSvhCuDUiao8LkMAR9uXAf2cQa4wrT25zofenN2as2UxiKkS
         jb/Akq0pueOBpO63xZDqcqsJEwFP+M+8C/vjvDcYaQ6kA1cVeO1wy3QZflDwvEyJnYC1
         DNKZSEpkkfP1aP396PC1VqZxG4jAQ54e5FFhUadFaOy6JrB3mA7+7woUVtvsnoy1QG2p
         1Z2GANbiNgGTi/wQ91OVS+VGN5V8zSHgIzCezfnQ5ZwIamrcaEALbM5FI3eEEKKbaTYz
         uX7Q==
X-Gm-Message-State: AOAM531JNmooVYE5upZqapLmY0KDAUbe4mfN4zsEGNRdU7tBbz0FcLeG
        NZJJudtSN1/VZE970ODBdPZTMgdm97U=
X-Google-Smtp-Source: ABdhPJxfWA3zYtvNmhqv7DO56vmWzGueKhLr/Aq+Yml0moNVY/E3HdwrSNSig+vzj9uoBLmhAASnjQ==
X-Received: by 2002:a17:907:8a04:b0:6b6:1f22:a5e with SMTP id sc4-20020a1709078a0400b006b61f220a5emr7448638ejc.528.1645824825593;
        Fri, 25 Feb 2022 13:33:45 -0800 (PST)
Received: from nlaptop.localdomain (178-117-137-225.access.telenet.be. [178.117.137.225])
        by smtp.gmail.com with ESMTPSA id r13-20020a1709064d0d00b0069f263a8104sm1443552eju.177.2022.02.25.13.33.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Feb 2022 13:33:45 -0800 (PST)
From:   Niels Dossche <dossche.niels@gmail.com>
X-Google-Original-From: Niels Dossche <niels.dossche@ugent.be>
To:     linux-scsi@vger.kernel.org
Cc:     aacraid@microsemi.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, Niels Dossche <niels.dossche@ugent.be>,
        Niels Dossche <dossche.niels@gmail.com>
Subject: [PATCH v2] scsi: aacraid: add missing manage_lock on management_fib_count
Date:   Fri, 25 Feb 2022 22:33:08 +0100
Message-Id: <20220225213308.89883-1-niels.dossche@ugent.be>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

All other places modify the management_fib_count under the manage_lock.
Avoid a possible race condition by also applying that lock in
aac_src_intr_message.

Signed-off-by: Niels Dossche <niels.dossche@ugent.be>
Signed-off-by: Niels Dossche <dossche.niels@gmail.com>
---
Changes in v2:
  - Fix whitespace.

 drivers/scsi/aacraid/src.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
index 11ef58204e96..ca73439587ed 100644
--- a/drivers/scsi/aacraid/src.c
+++ b/drivers/scsi/aacraid/src.c
@@ -91,7 +91,9 @@ static irqreturn_t aac_src_intr_message(int irq, void *dev_id)
 					dev->sync_fib);
 			spin_lock_irqsave(&dev->sync_fib->event_lock, sflags);
 			if (dev->sync_fib->flags & FIB_CONTEXT_FLAG_WAIT) {
+				spin_lock(&dev->manage_lock);
 				dev->management_fib_count--;
+				spin_unlock(&dev->manage_lock);
 				complete(&dev->sync_fib->event_wait);
 			}
 			spin_unlock_irqrestore(&dev->sync_fib->event_lock,
-- 
2.35.1


Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7C16C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Sep 2021 17:34:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF147611C5
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Sep 2021 17:34:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230492AbhIURgZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Sep 2021 13:36:25 -0400
Received: from mail-pg1-f178.google.com ([209.85.215.178]:34750 "EHLO
        mail-pg1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231200AbhIURgV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Sep 2021 13:36:21 -0400
Received: by mail-pg1-f178.google.com with SMTP id f129so21421364pgc.1
        for <linux-scsi@vger.kernel.org>; Tue, 21 Sep 2021 10:34:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :mime-version:content-transfer-encoding;
        bh=w1iEouq48AVpn75b5A9apKQ3RgVM9gjJRAkhFFydADE=;
        b=WTFBOqgZNRAn4aG1RPZvY5s12wSTyZqSHybEsa8Ie8i403COsZqU5IQ67qyOpkxaQn
         i73BeVlixOcQHBJuZYK7qo/qLkn4EXQdO+m9F5zwvDVl95dLy6nvxNeVdt8qnKdu19ND
         nlOlN1R5SouCpCbWzwdApBNcgwfY5+HtwJUVVHPB7g+IueOpxSRuuUzhcbosD7QLEVmU
         6j88JUsacJA7265iu+qhKKCkBdj3sgo8SwR4FMeBMfKRfHNpGqSUla7gOxqHUm+1SP7R
         uN2XIBMxX1iI/KGbAVeZcYFxJeYsv1Pp+Eyqgf4aDK/xd59k1rJhXFMp71MthWrIikld
         c/8A==
X-Gm-Message-State: AOAM533dWltwW3grHXS1Sc9cB0EMrNYwq/Ym0p05Lja7dhgjkZGpmDxd
        hJTMEJzWbPMa9xr4gAqoinc=
X-Google-Smtp-Source: ABdhPJxBBHxaO0Q2hidm/N/OvYalF9CK7ZEoSXK9t/fkAt+u7Pqg4CKmikSD/8U3CB0IDiCQdLLchA==
X-Received: by 2002:aa7:8e91:0:b0:43e:1dd:812b with SMTP id a17-20020aa78e91000000b0043e01dd812bmr31501813pfr.35.1632245692386;
        Tue, 21 Sep 2021 10:34:52 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:3f15:8d17:800:eea3])
        by smtp.gmail.com with ESMTPSA id w22sm14561603pgc.56.2021.09.21.10.34.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 10:34:51 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 79/84] xen-scsifront: Call scsi_done() directly
Date:   Tue, 21 Sep 2021 10:34:31 -0700
Message-Id: <20210921173436.3533078-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Reply-To: 20210918000607.450448-1-bvanassche@acm.org
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Conditional statements are faster than indirect calls. Hence call
scsi_done() directly.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/xen-scsifront.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/xen-scsifront.c b/drivers/scsi/xen-scsifront.c
index 0204e314b482..12c10a5e3d93 100644
--- a/drivers/scsi/xen-scsifront.c
+++ b/drivers/scsi/xen-scsifront.c
@@ -276,7 +276,7 @@ static void scsifront_cdb_cmd_done(struct vscsifrnt_info *info,
 	if (sense_len)
 		memcpy(sc->sense_buffer, ring_rsp->sense_buffer, sense_len);
 
-	sc->scsi_done(sc);
+	scsi_done(sc);
 }
 
 static void scsifront_sync_cmd_done(struct vscsifrnt_info *info,
@@ -558,7 +558,7 @@ static int scsifront_queuecommand(struct Scsi_Host *shost,
 		if (err == -ENOMEM)
 			return SCSI_MLQUEUE_HOST_BUSY;
 		sc->result = DID_ERROR << 16;
-		sc->scsi_done(sc);
+		scsi_done(sc);
 		return 0;
 	}
 

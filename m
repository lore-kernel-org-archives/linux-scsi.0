Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DF9CC433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:07:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21DFC61406
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:07:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347099AbhI2WJA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 18:09:00 -0400
Received: from mail-pg1-f178.google.com ([209.85.215.178]:44580 "EHLO
        mail-pg1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347135AbhI2WI5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 18:08:57 -0400
Received: by mail-pg1-f178.google.com with SMTP id s11so4130169pgr.11
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 15:07:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G/U5AT0JdS1JPpSLRlnz336WYbeTNuEagu7XBIhXTCc=;
        b=Ga93ZzPjmRyU1JaccOkwIcGJAnfkTKCAqRphoahAPvbsY0qC/0JwXcPbyTZAjvqNNl
         kOoGyOiXkdeYfLt2LsoA13/9KuRpDFjaqtIi0SDqB7hJ5T4Ykvq/Zf0gxiTTewuM4NQY
         gdhwsl8lBDPMb9+AK1HwiVJkc7OM6JCHFVx+D1qI9IYOnruslzee2dy4ZziJ1wRJHxfk
         +5ix5gtpdQFJZYwoxYcrEwoVUpVtEffaaPJn3fozu7yR3kUIXj81B/Vo9QftX+96mhFv
         1aGa37/hn1ITUDwu2WGoqCz6EIoiS127AqbKh3vBndvgm3CE3AuTduhtlJGkZjj7noKU
         hhTg==
X-Gm-Message-State: AOAM530ECq0aKpS9WLDhkt6Qarl88i0O8mDe3QTYfpIZfQGLn99l6IXo
        r1s6SuVZkLwCHKItcALtJwg=
X-Google-Smtp-Source: ABdhPJyaHqI+rGx9hX+Mp8tNncAmgPV6mwhNDJP9c7IcXBNbQGOheXmUlC2r756BcKgoshS6o9WpSQ==
X-Received: by 2002:a05:6a00:1390:b0:447:961d:39b9 with SMTP id t16-20020a056a00139000b00447961d39b9mr2005824pfg.83.1632953236014;
        Wed, 29 Sep 2021 15:07:16 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5c11:c4f:db56:119])
        by smtp.gmail.com with ESMTPSA id gk14sm2785585pjb.35.2021.09.29.15.07.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 15:07:15 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        HighPoint Linux Team <linux@highpoint-tech.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 37/84] hptiop: Call scsi_done() directly
Date:   Wed, 29 Sep 2021 15:05:13 -0700
Message-Id: <20210929220600.3509089-38-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
In-Reply-To: <20210929220600.3509089-1-bvanassche@acm.org>
References: <20210929220600.3509089-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Conditional statements are faster than indirect calls. Hence call
scsi_done() directly.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/hptiop.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/hptiop.c b/drivers/scsi/hptiop.c
index 61cda7b7624f..f18f6a677c1b 100644
--- a/drivers/scsi/hptiop.c
+++ b/drivers/scsi/hptiop.c
@@ -769,7 +769,7 @@ static void hptiop_finish_scsi_req(struct hptiop_hba *hba, u32 tag,
 
 skip_resid:
 	dprintk("scsi_done(%p)\n", scp);
-	scp->scsi_done(scp);
+	scsi_done(scp);
 	free_req(hba, &hba->reqs[tag]);
 }
 
@@ -1002,9 +1002,6 @@ static int hptiop_queuecommand_lck(struct scsi_cmnd *scp,
 	int sg_count = 0;
 	struct hptiop_request *_req;
 
-	BUG_ON(!done);
-	scp->scsi_done = done;
-
 	_req = get_req(hba);
 	if (_req == NULL) {
 		dprintk("hptiop_queuecmd : no free req\n");
@@ -1059,7 +1056,7 @@ static int hptiop_queuecommand_lck(struct scsi_cmnd *scp,
 
 cmd_done:
 	dprintk("scsi_done(scp=%p)\n", scp);
-	scp->scsi_done(scp);
+	scsi_done(scp);
 	return 0;
 }
 

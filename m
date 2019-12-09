Return-Path: <SRS0=QSh0=Z7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24281C00454
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Dec 2019 18:02:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 058C5207FF
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Dec 2019 18:02:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbfLISCg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Dec 2019 13:02:36 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:35540 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726928AbfLISCf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Dec 2019 13:02:35 -0500
Received: by mail-pl1-f194.google.com with SMTP id s10so6125669plp.2
        for <linux-scsi@vger.kernel.org>; Mon, 09 Dec 2019 10:02:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mVfTwLMaUZZMeIwNTsT20iZ21dbzCyTPNleeGYlC5f0=;
        b=WGp3lSlVmOGnfVBlKf7z1IrdI8SzNCHDbxWEwsvBOECy/r9XRHzcWQEAm/BTRdJhM0
         7T3lBJMwDx7doC4ifWx7bay+Xoc8kK69yDJc+E3Lsje74/zYX/HxlwbL8S6WPYRq3xsD
         oXJ12NbfGVs5uTAVs8ycsJiFWhACqiR0GfjE7SuKpWha2XS4AF0y3tLQpLUsT0ZXW5Ij
         QuBf9f+6SK/jIy+cBbbLFT2Wi8kH96aIZxAEDy1agxcMnL97yQv0JjFavZMyTtOHGQNh
         XxRYs2JWjFRleb925G7eACOL8kqgYulhES7CsUaWv3UnjJlb0azgJZREeElFvsOE+fH4
         wSFw==
X-Gm-Message-State: APjAAAUsaD7dTk4N+juUcjAKF/fHyVhxVh/GWWYeM4kAsI2HgcLUXi5w
        nhwUv8gHevCVe3WZKNLGrdk=
X-Google-Smtp-Source: APXvYqwf7A00EcGJV5KzFhi64Z4wJOgOW30z3CGb4FwcU707iezEuGqdLeJQJds52xEGIhM6AhnsFg==
X-Received: by 2002:a17:90a:a48a:: with SMTP id z10mr319611pjp.52.1575914554496;
        Mon, 09 Dec 2019 10:02:34 -0800 (PST)
Received: from bvanassche-glaptop.roam.corp.google.com ([216.9.110.7])
        by smtp.gmail.com with ESMTPSA id f13sm132393pfa.57.2019.12.09.10.02.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Dec 2019 10:02:33 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Daniel Wagner <dwagner@suse.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH 3/4] qla2xxx: Fix point-to-point mode for qla25xx and older
Date:   Mon,  9 Dec 2019 10:02:22 -0800
Message-Id: <20191209180223.194959-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.24.0.393.g34dc348eaf-goog
In-Reply-To: <20191209180223.194959-1-bvanassche@acm.org>
References: <20191209180223.194959-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Restore point-to-point for qla25xx and older. Although this patch initializes
a field (s_id) that has been marked as "reserved" in the firmware manual, it
works fine on my setup.

Cc: Quinn Tran <qutran@marvell.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Daniel Wagner <dwagner@suse.de>
Cc: Roman Bolshakov <r.bolshakov@yadro.com>
Fixes: 0aabb6b699f7 ("scsi: qla2xxx: Fix Nport ID display value")
Fixes: edd05de19759 ("scsi: qla2xxx: Changes to support N2N logins")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_iocb.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index b25f87ff8cde..e2e91b3f2e65 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2656,10 +2656,16 @@ qla24xx_els_logo_iocb(srb_t *sp, struct els_entry_24xx *els_iocb)
 	els_iocb->port_id[0] = sp->fcport->d_id.b.al_pa;
 	els_iocb->port_id[1] = sp->fcport->d_id.b.area;
 	els_iocb->port_id[2] = sp->fcport->d_id.b.domain;
-	/* For SID the byte order is different than DID */
-	els_iocb->s_id[1] = vha->d_id.b.al_pa;
-	els_iocb->s_id[2] = vha->d_id.b.area;
-	els_iocb->s_id[0] = vha->d_id.b.domain;
+	if (IS_QLA23XX(vha->hw) || IS_QLA24XX(vha->hw) || IS_QLA25XX(vha->hw)) {
+		els_iocb->s_id[0] = vha->d_id.b.al_pa;
+		els_iocb->s_id[1] = vha->d_id.b.area;
+		els_iocb->s_id[2] = vha->d_id.b.domain;
+	} else {
+		/* For SID the byte order is different than DID */
+		els_iocb->s_id[1] = vha->d_id.b.al_pa;
+		els_iocb->s_id[2] = vha->d_id.b.area;
+		els_iocb->s_id[0] = vha->d_id.b.domain;
+	}
 
 	if (elsio->u.els_logo.els_cmd == ELS_DCMD_PLOGI) {
 		els_iocb->control_flags = 0;

Return-Path: <SRS0=JpCa=WK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BF96C433FF
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 23:57:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B74E20866
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 23:57:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FQ/2QG/1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728972AbfHNX50 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Aug 2019 19:57:26 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:35013 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726119AbfHNX50 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Aug 2019 19:57:26 -0400
Received: by mail-pl1-f194.google.com with SMTP id gn20so337927plb.2
        for <linux-scsi@vger.kernel.org>; Wed, 14 Aug 2019 16:57:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=xc9Wv3svCPf69lmVFx6hl/SDyVuNcI+jzEO6uRy4iLY=;
        b=FQ/2QG/1XDFM6ypQHi5dMdKGKEsNc6KBIPWdoD5rLvjcAhhFV4DBCKltHgA19kfu+/
         RTixnA+ViZX1kY+tJ2M++kIfiK+00p+gbY7WxXMjSbQDAs+RATiaFOql83HwogdmirIY
         pQsasVZcBjYIEdFHEqgWh+2SocHGX6uXoiOI2Wti1kWo6HepQhvCZSlmAh1UkqThRj98
         VAoQSeESMkVo55Iahl6Bagk6QJnDLxmhlJyynUBPZgp34SQvTD99GF9t2MG6gZEP7BzH
         9oFr+SZwDVhXJK0v+ClvOC4Nxa95WjdaHyPwuF/7OTwpV2Pl3iM49WiLcqgpXYvZrvu1
         dI1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=xc9Wv3svCPf69lmVFx6hl/SDyVuNcI+jzEO6uRy4iLY=;
        b=h8Tw3DfIKbBslrnnq9Ww5Npq8CfVciAeHKEhI5wCT8Ww5uJrf3RFE3PYX2ORbrELYW
         +UNut5GOcii92aCaEeSp2ueTXVhYG/dCd9x2bqOGrAh86eCC2U6TIOuOW9V+TQKQyjyE
         tc4KvjUEjsFt1c4LmJQG2NE9HqdACxuKkFJgJGQ59fWSFH5eaK+DYI4vA9t3oa4HOTnq
         +c5L2TjG+mQHUTN+22IXAWe4TnP+zaI49H8AbEqxGnYkYOJzuEHU0NUr2la8vLD1VIFb
         qU9REzW/2CRAZeKUd25WLV0bOellXn7uBujgLaZNQp9P2HbcXvSOuSC9uVYToA84M7bI
         Fr1g==
X-Gm-Message-State: APjAAAUYssqqJUKQ38X9jd900UB9xFKNUb264ZoOP/aQisY65VfFiTLS
        RWIKEd2zUTg1gLLDIp/PmBQyqTks
X-Google-Smtp-Source: APXvYqwDtse4ZyiL33JH6gAyGUvQ/nwNlnYUjCRRD46cjRLmruhFU4s9Ad0PK6k985pP3Bomcldn4Q==
X-Received: by 2002:a17:902:82c4:: with SMTP id u4mr1817910plz.196.1565827045558;
        Wed, 14 Aug 2019 16:57:25 -0700 (PDT)
Received: from pallmd1.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id k22sm987299pfk.157.2019.08.14.16.57.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 14 Aug 2019 16:57:25 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 04/42] lpfc: Fix crash on driver unload in wq free
Date:   Wed, 14 Aug 2019 16:56:34 -0700
Message-Id: <20190814235712.4487-5-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20190814235712.4487-1-jsmart2021@gmail.com>
References: <20190814235712.4487-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If a timer routine uses workqueues, it could fire before the
workqueue is allocated.

Fix by allocating the workqueue before the timer routines are setup

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 02231370428a..50d641f65af9 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -6415,6 +6415,11 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 	if (rc)
 		return -ENODEV;
 
+	/* Allocate all driver workqueues here */
+
+	/* The lpfc_wq workqueue for deferred irq use */
+	phba->wq = alloc_workqueue("lpfc_wq", WQ_MEM_RECLAIM, 0);
+
 	/*
 	 * Initialize timers used by driver
 	 */
@@ -6998,12 +7003,6 @@ lpfc_setup_driver_resource_phase2(struct lpfc_hba *phba)
 		return error;
 	}
 
-	/* The lpfc_wq workqueue for deferred irq use, is only used for SLI4 */
-	if (phba->sli_rev == LPFC_SLI_REV4)
-		phba->wq = alloc_workqueue("lpfc_wq", WQ_MEM_RECLAIM, 0);
-	else
-		phba->wq = NULL;
-
 	return 0;
 }
 
-- 
2.13.7


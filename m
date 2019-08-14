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
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8345C433FF
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 23:57:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 87A3C20866
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 23:57:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tiX4RlnJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729112AbfHNX5c (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Aug 2019 19:57:32 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:46585 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729009AbfHNX5b (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Aug 2019 19:57:31 -0400
Received: by mail-pg1-f195.google.com with SMTP id w3so401355pgt.13
        for <linux-scsi@vger.kernel.org>; Wed, 14 Aug 2019 16:57:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=nxbEK20vGbYFJ2RUgDJbR9ITRszWaYsi31ec7mlqlm4=;
        b=tiX4RlnJFUl10ptB7NoEiKU3QzkdAnkgunRiluc7a0R3hK8bthpesnDaaUuSrGkvQy
         p1MW/KPMTS30rpuIUokaHO2zSGH2P6+VKI23JgmUxOJ7jGBdjdjCSjloHGwzCMJ8uq0V
         NZiCAaiwxOCmf8G8ZtqXmuf+4kATgeQN+QL3RBPFF0AEI+QSKdDrpp5Z6AZ45/T5uXyk
         DkE0DqGYsIpyYA6Dw84uwDSZoOvY8blR82uI41DJHGeS5cdoacdXgpSYbaZiqzGPlJZ4
         stuJfdjgL97rn7cLbNKC/r6XgEY5WA/W3Y/afxO4USA80UntFuES0mOAYLQYsM2eLEII
         vQ7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=nxbEK20vGbYFJ2RUgDJbR9ITRszWaYsi31ec7mlqlm4=;
        b=glaflZQGKW1Tg0jAbHGK5qMJAaI5hjBfCie2gIBzSzIUZHDcvKKRKSAzTOc+QN9iPJ
         oHOZdvxkkumJJrz1RFZ4/xMvKt1EA5Qgpsl5chkimsUmzOhf87rs0n9A9FKq+OI3WZzD
         TiW8GPX6AKax5v5ukIfpOT9CYtMYgGXKFb8agWei8fRa+JrgMA9fiYLDfd/6YMjOjCcb
         6BVf//OrphfNUSglb+RkarbRzwG45gtHMhbsc3BsnJwfpu+WxJnv5Qd9H8CDh0TWo0i3
         qNzE6MdU3ojAycazaojKWeHKOcGLebnZcqdx2CG6Dp/yoH4tkeK0b6vIg74E/C6zHDYl
         mXNw==
X-Gm-Message-State: APjAAAUcdsgCFqxvmmGz8YrV86BcTsiWwMnX171ssfLa0zDywIHYmc+P
        6kZo2Yma68YSWoT0U7/7hbMh1TeT
X-Google-Smtp-Source: APXvYqw1CQCOEJe15G7FyqZyGhewzApkgmHlI4zSnpf1rI8AWdjdzQFpwGO0UG61+5bhgpA1G0p2Pg==
X-Received: by 2002:aa7:90c9:: with SMTP id k9mr2484859pfk.171.1565827050680;
        Wed, 14 Aug 2019 16:57:30 -0700 (PDT)
Received: from pallmd1.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id k22sm987299pfk.157.2019.08.14.16.57.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 14 Aug 2019 16:57:30 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 11/42] lpfc: Fix Oops in nvme_register with target logout/login
Date:   Wed, 14 Aug 2019 16:56:41 -0700
Message-Id: <20190814235712.4487-12-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20190814235712.4487-1-jsmart2021@gmail.com>
References: <20190814235712.4487-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

lpfc_nvme_register_port hit a null prev_ndlp pointer in a test
with lots of target ports swapping addresses. The oldport value
was stale, thus it's ndlp (prev_ndlp set to it) was used.

Fix by moving oldrport pointer checks, and if used prev_ndlp pointer
assignment, to be done while the lock is held.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_nvme.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 946642cee3df..9746808cf94f 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -2317,9 +2317,13 @@ lpfc_nvme_register_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 
 	spin_lock_irq(&vport->phba->hbalock);
 	oldrport = lpfc_ndlp_get_nrport(ndlp);
-	spin_unlock_irq(&vport->phba->hbalock);
-	if (!oldrport)
+	if (oldrport) {
+		prev_ndlp = oldrport->ndlp;
+		spin_unlock_irq(&vport->phba->hbalock);
+	} else {
+		spin_unlock_irq(&vport->phba->hbalock);
 		lpfc_nlp_get(ndlp);
+	}
 
 	ret = nvme_fc_register_remoteport(localport, &rpinfo, &remote_port);
 	if (!ret) {
@@ -2338,7 +2342,6 @@ lpfc_nvme_register_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 			/* New remoteport record does not guarantee valid
 			 * host private memory area.
 			 */
-			prev_ndlp = oldrport->ndlp;
 			if (oldrport == remote_port->private) {
 				/* Same remoteport - ndlp should match.
 				 * Just reuse.
@@ -2352,7 +2355,7 @@ lpfc_nvme_register_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 						 remote_port->port_name,
 						 remote_port->port_id,
 						 remote_port->port_role,
-						 prev_ndlp,
+						 oldrport->ndlp,
 						 ndlp,
 						 ndlp->nlp_type,
 						 ndlp->nlp_DID);
-- 
2.13.7


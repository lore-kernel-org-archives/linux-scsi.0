Return-Path: <SRS0=nyLG=ZD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03487C17441
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Nov 2019 23:04:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C9B33214DB
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Nov 2019 23:04:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DlkeCn3l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727211AbfKKXES (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Nov 2019 18:04:18 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:40151 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727224AbfKKXES (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Nov 2019 18:04:18 -0500
Received: by mail-wm1-f68.google.com with SMTP id f3so975117wmc.5
        for <linux-scsi@vger.kernel.org>; Mon, 11 Nov 2019 15:04:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=kjCDmhnPLmdm9EQgcBlsh6iXBCXo8RHk+j0Ae0eJir0=;
        b=DlkeCn3lxbvlRDDPbzUwwnDM99JrgjSRWSahqUcUh5+CLFcJoo+1RCJXjWaNfB6ePr
         mRmrbyT4A1OskVeP1MOFXDBkL0qHRE2TfVSgnjIJerrMLslA/X51Vtgz1rofcOZefU+a
         yEIIVrB4YsnvCQ7Nq79kchPTM25OObRt5UTJY128sBt15wrs4/LMkEzjPgkfGNTbiSWe
         dWv0PMiMa+nAoRNTwONt9hgOIKdvIZqmnXzd7Ze1TkPM3AYX94A+nDSn9LNiTseoa66F
         CiBIVgoiSq8G4knGrJrTqaP0vzwuykdbx4R49K7RGec7Lub6Yy+cH4D5D14YZfE9wPep
         3Flg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=kjCDmhnPLmdm9EQgcBlsh6iXBCXo8RHk+j0Ae0eJir0=;
        b=kq4LeaCfUI7VQV2qdvy8oSF2Dn86DNiyvWjbbTSKdHijpZlZ4O3ZPzBbL7sFc+b6s2
         Xoo0mDCx7k6JRr/asHF0hFAs93o1rMbAdKylpdSiWdsWaEQfgLdadwxnHwpKZq36KTn9
         tbqEpI7j4Jy2BzJWlDmDq8OHnwWIw+SG75WTPBK5BdgCbjBF7OoCLjTVMCAfy/rpoyd2
         bie+2FOgBsJPprxR5DsHvJvBB+YeBe6oBL3ydUjbooeOPtL/4NCz4OYk/fBK1rjr64ha
         7/g5K8Genjp+RiQOS7kKSnnA7s0FCOY17paqlXt62g1QkeZw7u5yyzAYceV+al9AQ2kU
         PMCQ==
X-Gm-Message-State: APjAAAXK2PveBCpK9T/qSz6fex64vMqkb577mZA6RX7OrmCFxftKHmbl
        HXOOjb3tjE0RgBZBGUmqTACYaQg0
X-Google-Smtp-Source: APXvYqyZTBKj0cjtoFC//oxHTLLiL+23LtkjHXlZjb/MdhONkmNa+ijB6d4SpXHBHstCMuM205V9rg==
X-Received: by 2002:a1c:790b:: with SMTP id l11mr1185246wme.127.1573513456243;
        Mon, 11 Nov 2019 15:04:16 -0800 (PST)
Received: from pallmd1.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id m25sm655146wmi.46.2019.11.11.15.04.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 11 Nov 2019 15:04:15 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 3/6] lpfc: fix inlining of lpfc_sli4_cleanup_poll_list()
Date:   Mon, 11 Nov 2019 15:03:58 -0800
Message-Id: <20191111230401.12958-4-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20191111230401.12958-1-jsmart2021@gmail.com>
References: <20191111230401.12958-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Compilation can fail due to having an inline function
reference where the function body is not present.

Fix by removing the inline tag.

Fixes: 93a4d6f40198 ("scsi: lpfc: Add registration for CPU Offline/Online events")

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
patch is in the 12.6.0.1 set which is in 5.5/scsi-queue
---
 drivers/scsi/lpfc/lpfc_crtn.h | 2 +-
 drivers/scsi/lpfc/lpfc_sli.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index d91aa5330306..ee353c84a097 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -215,7 +215,7 @@ irqreturn_t lpfc_sli_fp_intr_handler(int, void *);
 irqreturn_t lpfc_sli4_intr_handler(int, void *);
 irqreturn_t lpfc_sli4_hba_intr_handler(int, void *);
 
-inline void lpfc_sli4_cleanup_poll_list(struct lpfc_hba *phba);
+void lpfc_sli4_cleanup_poll_list(struct lpfc_hba *phba);
 int lpfc_sli4_poll_eq(struct lpfc_queue *q, uint8_t path);
 void lpfc_sli4_poll_hbtimer(struct timer_list *t);
 void lpfc_sli4_start_polling(struct lpfc_queue *q);
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index fad890cea21a..6d82ad9380db 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -14466,7 +14466,7 @@ static inline void lpfc_sli4_remove_from_poll_list(struct lpfc_queue *eq)
 		del_timer_sync(&phba->cpuhp_poll_timer);
 }
 
-inline void lpfc_sli4_cleanup_poll_list(struct lpfc_hba *phba)
+void lpfc_sli4_cleanup_poll_list(struct lpfc_hba *phba)
 {
 	struct lpfc_queue *eq, *next;
 
-- 
2.13.7


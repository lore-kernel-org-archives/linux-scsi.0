Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51B82C07E95
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jul 2021 18:44:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3109361CCE
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jul 2021 18:44:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231875AbhGGSqk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Jul 2021 14:46:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232614AbhGGSqi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jul 2021 14:46:38 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31EE3C061764
        for <linux-scsi@vger.kernel.org>; Wed,  7 Jul 2021 11:43:57 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id y2so1564214plc.8
        for <linux-scsi@vger.kernel.org>; Wed, 07 Jul 2021 11:43:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hhXq0i5fh5/IZG5p6s02l1Yzc2ZTBC+FLtzUS4iLLns=;
        b=FE/rP8yh0tHt7ymrtCDAo2TSrctvOsSmgk3M/qeKCIeDLLTItdLp8NeNhLERe02xRF
         IiLqQAIEhhITlYsJs7ICIsNbIR3OA5nBSFNWWHrUK8YROuZImSRwGS12R7xzy9IdWV1l
         3C7mwjgMe6dWhut7ujpsSOM4+Sqg/aGZtmCpQpSAR6j5dl8OAR9lcYdxKvlflPAqk6pV
         VlkKEE2XXIkfjk5r6PHLC1MnVWN+C5J8rcTmmbO52r13ka+9cKHNLRjpyZ+9F4UucU1F
         yVtI85FbJ34TKqUCVLmUVqGCInGS8IQEcbUAqzVYqPB94nYety1rt/Tczlr9q/sGgN0E
         05eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hhXq0i5fh5/IZG5p6s02l1Yzc2ZTBC+FLtzUS4iLLns=;
        b=jeI9gzz3Hs9UN7Fr74T+69Fakm6G+b0bV1Kp4mPQEtiIBg0w3jS9jg/JuZnHAv4eYV
         3qKnJxVB4RBPf9m0fcW53bHaUZS9GCTmOdzQF+tLycQmDCXsxhcjUIrKRKXe3AusWMVl
         um1JZHHA03sC6aYois+ypq4vyHXAqVIbMAxsCQrRwxwM3N62yqhXij49mBb3BvhZkTmE
         cdUTYG7GiD1WtOoUqR+KmD3jC6+jYbx77eAYSIEVP34D54Hj4PuMHCYty95IZWUwdOd7
         8gXFPmfF2QNHQbIiJwtmpACvd+B4Iu4UbCeGK/eKYqL1gpspuJmD/eZU70VfoY9/VF4T
         s/Cw==
X-Gm-Message-State: AOAM533wDfDDqt9kkFQAf4bw6SS2N1s6AFr18XKwkpGeQ7zk43H8Xp2W
        b5cW3nunbfqwBd+W+1jPE71ZrOeKxP4=
X-Google-Smtp-Source: ABdhPJyils2y7wDuDch9jA44TQxmEwgJBEstxEz1Fgk04jHGxfPxiKBQNskfh7Cb3aDi8rmsTuV2Uw==
X-Received: by 2002:a17:90a:4884:: with SMTP id b4mr419046pjh.173.1625683436718;
        Wed, 07 Jul 2021 11:43:56 -0700 (PDT)
Received: from localhost.localdomain (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id z3sm23578631pgl.77.2021.07.07.11.43.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 11:43:56 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 02/20] lpfc: Remove use of kmalloc in trace event logging
Date:   Wed,  7 Jul 2021 11:43:33 -0700
Message-Id: <20210707184351.67872-3-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210707184351.67872-1-jsmart2021@gmail.com>
References: <20210707184351.67872-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There are instances when trace event logs are triggered from an
interrupt context. The trace event log may attempt to alloc memory
causing scheduling while atomic bug call traces.

Remove the need for the kmalloc'ed vport array when checking the
log_verbose flag, which eliminates the need for any allocation.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index cf5bfd27058a..51f4058a75b8 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -14162,8 +14162,9 @@ void lpfc_dmp_dbg(struct lpfc_hba *phba)
 	unsigned int temp_idx;
 	int i;
 	int j = 0;
-	unsigned long rem_nsec;
-	struct lpfc_vport **vports;
+	unsigned long rem_nsec, iflags;
+	bool log_verbose = false;
+	struct lpfc_vport *port_iterator;
 
 	/* Don't dump messages if we explicitly set log_verbose for the
 	 * physical port or any vport.
@@ -14171,16 +14172,24 @@ void lpfc_dmp_dbg(struct lpfc_hba *phba)
 	if (phba->cfg_log_verbose)
 		return;
 
-	vports = lpfc_create_vport_work_array(phba);
-	if (vports != NULL) {
-		for (i = 0; i <= phba->max_vpi && vports[i] != NULL; i++) {
-			if (vports[i]->cfg_log_verbose) {
-				lpfc_destroy_vport_work_array(phba, vports);
+	spin_lock_irqsave(&phba->port_list_lock, iflags);
+	list_for_each_entry(port_iterator, &phba->port_list, listentry) {
+		if (port_iterator->load_flag & FC_UNLOADING)
+			continue;
+		if (scsi_host_get(lpfc_shost_from_vport(port_iterator))) {
+			if (port_iterator->cfg_log_verbose)
+				log_verbose = true;
+
+			scsi_host_put(lpfc_shost_from_vport(port_iterator));
+
+			if (log_verbose) {
+				spin_unlock_irqrestore(&phba->port_list_lock,
+						       iflags);
 				return;
 			}
 		}
 	}
-	lpfc_destroy_vport_work_array(phba, vports);
+	spin_unlock_irqrestore(&phba->port_list_lock, iflags);
 
 	if (atomic_cmpxchg(&phba->dbg_log_dmping, 0, 1) != 0)
 		return;
-- 
2.26.2


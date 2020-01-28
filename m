Return-Path: <SRS0=0wOg=3R=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31522C32771
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jan 2020 00:23:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 05E022467E
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jan 2020 00:23:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cdKNe0I1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbgA1AXh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Jan 2020 19:23:37 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46617 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726444AbgA1AXh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jan 2020 19:23:37 -0500
Received: by mail-wr1-f68.google.com with SMTP id z7so13918722wrl.13
        for <linux-scsi@vger.kernel.org>; Mon, 27 Jan 2020 16:23:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=y1AasoUI0Dj1uB1HVpyYb5pMjQszMp8QjnX7YD9tEOc=;
        b=cdKNe0I11z3OFkNVBHnWSR8J/4bP+q5h2CQfvmMsm9LbbfD3nTlLg6Npo1K74uivHf
         LLI6s3DwV4F1ss9BV1WClfVboI5w5huEHBFSN+Ekkiqs7Fb1FLSygPlXhxsKnbGlwezp
         8oEa5j4Oh5zjJoebyXl0NSxPyJKCftIbd3eORojxWIIVUyNXa6JiEdwV0rAoif4LDjG1
         15EHoynbHlSeRR6Ck2iiwGQCN3ULKBSgA1J+Ub6KttOvq7mJRzCzcgDd5Ll00TnaiYIG
         BRkjw6n8vb9pOmDRmoZvQsA2ViO5HyYZ/PThaaCUtw07/uxqXKTtbEvoDUZh8vpLSyw5
         mCTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=y1AasoUI0Dj1uB1HVpyYb5pMjQszMp8QjnX7YD9tEOc=;
        b=pclaEgieHkgzewsclYQYUKkFPNHTHhS9i75pqnh7YJ3GcYYPfZVv/2nglTo4YlKwR6
         EI7u+zFiUpWMXLiYX3CLXVVzwLMU3d7mJ2UT9/nlo1MLFl5NrSbNZrDiIlhSmOWB30/d
         jNVuDSUG7keQi8kt5NuWTy0zgroZt2ai6oOmFij9TcyVgXnK5yszhxZ/6lkpQa9UWm6o
         bT05zoBS7TL1hNQ7rw+MbVy8FppWxL3ka2r/zVFqX48F/YZGxvw3NxH2RVje9LTo6Iq9
         IP4q5UnuYP0H3aXhoQBxZ4DR6tei873oxhvce7UkqxAA5/1J/BGqxq9eMnvvnhqJc4xc
         5QEA==
X-Gm-Message-State: APjAAAVAtnI+FB3Bq6fduHah+/EjUtHsn+rf0YaGFBZD9cGsx0+AVp5H
        z5I6PbhueI5QoMBDY3w5TGJHTtX6
X-Google-Smtp-Source: APXvYqwRIR+r4FCyA8xVoXi9XjIMmpmME3Ux8MitBL+teJ+MajwGAi9FD52nuTJXkIeRE6y7ZCtFnQ==
X-Received: by 2002:a5d:6305:: with SMTP id i5mr23908677wru.119.1580171014638;
        Mon, 27 Jan 2020 16:23:34 -0800 (PST)
Received: from os42.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z19sm583769wmi.43.2020.01.27.16.23.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 27 Jan 2020 16:23:34 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 06/12] lpfc: Fix compiler warning on frame size
Date:   Mon, 27 Jan 2020 16:23:06 -0800
Message-Id: <20200128002312.16346-7-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20200128002312.16346-1-jsmart2021@gmail.com>
References: <20200128002312.16346-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following error is see from the compiler:

  drivers/scsi/lpfc/lpfc_init.c: In function
    ‘lpfc_cpuhp_get_eq’: drivers/scsi/lpfc/lpfc_init.c:12660:1:
      error: the frame size of 1032 bytes is larger than 1024 bytes
         [-Werror=frame-larger-than=]

The issue is due to allocating a cpumask on the stack.

Fix by converting to a dynamical allocation of the cpu mask.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 9fd238d49117..9a6191818a23 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -11106,15 +11106,19 @@ lpfc_cpu_affinity_check(struct lpfc_hba *phba, int vectors)
  * @cpu:    cpu going offline
  * @eqlist:
  */
-static void
+static int
 lpfc_cpuhp_get_eq(struct lpfc_hba *phba, unsigned int cpu,
 		  struct list_head *eqlist)
 {
 	const struct cpumask *maskp;
 	struct lpfc_queue *eq;
-	cpumask_t tmp;
+	struct cpumask *tmp;
 	u16 idx;
 
+	tmp = kzalloc(cpumask_size(), GFP_KERNEL);
+	if (!tmp)
+		return -ENOMEM;
+
 	for (idx = 0; idx < phba->cfg_irq_chann; idx++) {
 		maskp = pci_irq_get_affinity(phba->pcidev, idx);
 		if (!maskp)
@@ -11124,7 +11128,7 @@ lpfc_cpuhp_get_eq(struct lpfc_hba *phba, unsigned int cpu,
 		 * then we don't need to poll the eq attached
 		 * to it.
 		 */
-		if (!cpumask_and(&tmp, maskp, cpumask_of(cpu)))
+		if (!cpumask_and(tmp, maskp, cpumask_of(cpu)))
 			continue;
 		/* get the cpus that are online and are affini-
 		 * tized to this irq vector.  If the count is
@@ -11132,8 +11136,8 @@ lpfc_cpuhp_get_eq(struct lpfc_hba *phba, unsigned int cpu,
 		 * down this vector.  Since this cpu has not
 		 * gone offline yet, we need >1.
 		 */
-		cpumask_and(&tmp, maskp, cpu_online_mask);
-		if (cpumask_weight(&tmp) > 1)
+		cpumask_and(tmp, maskp, cpu_online_mask);
+		if (cpumask_weight(tmp) > 1)
 			continue;
 
 		/* Now that we have an irq to shutdown, get the eq
@@ -11144,6 +11148,8 @@ lpfc_cpuhp_get_eq(struct lpfc_hba *phba, unsigned int cpu,
 		eq = phba->sli4_hba.hba_eq_hdl[idx].eq;
 		list_add(&eq->_poll_list, eqlist);
 	}
+	kfree(tmp);
+	return 0;
 }
 
 static void __lpfc_cpuhp_remove(struct lpfc_hba *phba)
@@ -11314,7 +11320,9 @@ static int lpfc_cpu_offline(unsigned int cpu, struct hlist_node *node)
 
 	lpfc_irq_rebalance(phba, cpu, true);
 
-	lpfc_cpuhp_get_eq(phba, cpu, &eqlist);
+	retval = lpfc_cpuhp_get_eq(phba, cpu, &eqlist);
+	if (retval)
+		return retval;
 
 	/* start polling on these eq's */
 	list_for_each_entry_safe(eq, next, &eqlist, _poll_list) {
-- 
2.13.7


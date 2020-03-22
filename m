Return-Path: <SRS0=LJp0=5H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B02D9C54FD0
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Mar 2020 18:13:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 897DA2072E
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Mar 2020 18:13:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X8n0XhPn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbgCVSNP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 22 Mar 2020 14:13:15 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:43731 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725785AbgCVSNP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Mar 2020 14:13:15 -0400
Received: by mail-pf1-f193.google.com with SMTP id f206so6297898pfa.10
        for <linux-scsi@vger.kernel.org>; Sun, 22 Mar 2020 11:13:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=XYsLdEmg6yBIb6N/qToI5bdBDdttkeu9l09K7OFHTvU=;
        b=X8n0XhPnsf1dPe4m5sQxtdxrHUjOMehNqaTiHf+GbttopRBxwD7/ehBHQIuqnP7EHQ
         zjIYtF3Cr3eqD+v+vr7mynvNoRL/LsJA2FEbq3Z+2zNq+qSxWjaxQHsGEJNgAoKKM4p8
         2deea0q/7+9INOZlp9xtaE57BrMXPCS8cOEtyMy3PCGHzse02c+mdF+krV43W3qhC5SB
         FlyD7zpMG8WlLedNggxqibVrb5pKMO0Yuc2mmJizegiVOBYVijDcZRRGxNiW3zx1Tfo0
         iTStzrx3m/jrur/c2pqYD1420BcKDgMEEf+sHJytaN5LJ2nyZBqb6d2a2wShXrvEEH1+
         CM/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=XYsLdEmg6yBIb6N/qToI5bdBDdttkeu9l09K7OFHTvU=;
        b=cZayHrGGsbgBLS/LhqbJUFVqD7yjm3GeNFCyDSWsfTlsnqUMzwhxwLIcYdK3aDcDBN
         GcxbPxsh8Rna7sl7m87Qn+9pdkgCbChc3PEALOD+W/Rye+RnMK1TIEfWRAMjQWeknuP9
         4XHAIcny10TMuyHrHbwfhMVahsbr+hV3rKr4oXl9+kLgWSDY7poYl1ordaveJcNMNxvT
         4fV9FfUabhGis6FEThqehIiwJeHqrJi09qqaXjqLOfWySXC7J4t07I9zQqk52SuoWEV/
         sc6AV5z3sTY4Rw2iYeEoDSeIhni+kPSscvAwTYXszNLpJxTZpKQy8VYXmbs8rRGKgNKo
         HfjQ==
X-Gm-Message-State: ANhLgQ3Q1w9nxwEhz1NGDh8n9fxMfLMU10TFCiQ/rtcaHJhbUNP1ybp8
        fssuKrx5JnWkhLaSq1JOhRs/FueY
X-Google-Smtp-Source: ADFU+vvYzBzW638bEmzbCSBZ25hShRxgHOanfQsjw1YN5KEVOPm39TGc/Tp+ltPIDTmcrNqZNpXNWQ==
X-Received: by 2002:a65:4081:: with SMTP id t1mr18998189pgp.134.1584900793161;
        Sun, 22 Mar 2020 11:13:13 -0700 (PDT)
Received: from localhost.localdomain.localdomain (ip68-5-146-102.oc.oc.cox.net. [68.5.146.102])
        by smtp.gmail.com with ESMTPSA id bt19sm1331657pjb.3.2020.03.22.11.13.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 22 Mar 2020 11:13:12 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 02/12] lpfc: Fix lockdep error - register non-static key
Date:   Sun, 22 Mar 2020 11:12:54 -0700
Message-Id: <20200322181304.37655-3-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200322181304.37655-1-jsmart2021@gmail.com>
References: <20200322181304.37655-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following lockdep error was reported when unloading the lpfc driver:

  INFO: trying to register non-static key.
  the code is fine but needs lockdep annotation.
  turning off the locking correctness validator.
  ...
  Call Trace:
  dump_stack+0x96/0xe0
  register_lock_class+0x8b8/0x8c0
  ? lockdep_hardirqs_on+0x190/0x280
  ? is_dynamic_key+0x150/0x150
  ? wait_for_completion_interruptible+0x2a0/0x2a0
  ? wake_up_q+0xd0/0xd0
  __lock_acquire+0xda/0x21a0
  ? register_lock_class+0x8c0/0x8c0
  ? synchronize_rcu_expedited+0x500/0x500
  ? __call_rcu+0x850/0x850
  lock_acquire+0xf3/0x1f0
  ? del_timer_sync+0x5/0xb0
  del_timer_sync+0x3c/0xb0
  ? del_timer_sync+0x5/0xb0
  lpfc_pci_remove_one.cold.102+0x8b7/0x935 [lpfc]
  ...

Unloading the driver resulted in a call to del_timer_sync for the
cpuhp_poll_timer. However the call to setup the timer had never been
made, so the timer structures used by lockdep checking were not
initialized.

Unconditionally call setup_timer for the cpuhp_poll_timer during
driver initialization. Calls to start the timer remain "as needed".

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 5 ++---
 drivers/scsi/lpfc/lpfc_sli.c  | 6 ++----
 2 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 9d03e9b71efb..6eb3112a45a2 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -11173,11 +11173,9 @@ static void lpfc_cpuhp_add(struct lpfc_hba *phba)
 
 	rcu_read_lock();
 
-	if (!list_empty(&phba->poll_list)) {
-		timer_setup(&phba->cpuhp_poll_timer, lpfc_sli4_poll_hbtimer, 0);
+	if (!list_empty(&phba->poll_list))
 		mod_timer(&phba->cpuhp_poll_timer,
 			  jiffies + msecs_to_jiffies(LPFC_POLL_HB));
-	}
 
 	rcu_read_unlock();
 
@@ -13145,6 +13143,7 @@ lpfc_pci_probe_one_s4(struct pci_dev *pdev, const struct pci_device_id *pid)
 	lpfc_sli4_ras_setup(phba);
 
 	INIT_LIST_HEAD(&phba->poll_list);
+	timer_setup(&phba->cpuhp_poll_timer, lpfc_sli4_poll_hbtimer, 0);
 	cpuhp_state_add_instance_nocalls(lpfc_cpuhp_state, &phba->cpuhp);
 
 	return 0;
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 4fc14bebb76e..08bf2f0a1065 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -14444,12 +14444,10 @@ static inline void lpfc_sli4_add_to_poll_list(struct lpfc_queue *eq)
 {
 	struct lpfc_hba *phba = eq->phba;
 
-	if (list_empty(&phba->poll_list)) {
-		timer_setup(&phba->cpuhp_poll_timer, lpfc_sli4_poll_hbtimer, 0);
-		/* kickstart slowpath processing for this eq */
+	/* kickstart slowpath processing if needed */
+	if (list_empty(&phba->poll_list))
 		mod_timer(&phba->cpuhp_poll_timer,
 			  jiffies + msecs_to_jiffies(LPFC_POLL_HB));
-	}
 
 	list_add_rcu(&eq->_poll_list, &phba->poll_list);
 	synchronize_rcu();
-- 
2.16.4


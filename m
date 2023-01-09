Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4107C54EBE
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Jan 2023 23:22:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237743AbjAIXWy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Jan 2023 18:22:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237616AbjAIXWv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jan 2023 18:22:51 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CEDD959C
        for <linux-scsi@vger.kernel.org>; Mon,  9 Jan 2023 15:22:47 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id jl4so11288692plb.8
        for <linux-scsi@vger.kernel.org>; Mon, 09 Jan 2023 15:22:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ir9HGZ45FJzt0JfYeTk3McJ+X2KaO54ZpeNTElTDStE=;
        b=oKLj8WKoCvLJ0Y+mWcyeGfwvr3lXIr3dcv3KW2NjBwWN6+O7MAc8L200WPbdpYCP1X
         8N6nOwSANteq0xVV6uYwf5iJi/UCatoNk/4r31OpX1r6jaf2dXIr8EREr8u5KIMmDJi2
         tJnF8BuAdeworZLeHfp8elobwRCKAN0PkRqkqclo7k6n03SgYQxR8qb1sh5AA5mdGOa2
         V6BtJ0tKfg/1a8hue/ST6Cd++S0VjdFjNF+uZ8D+Paf/vCfN77tyAalY7FYNYMvKPurf
         gamTt74IMwmu4BN4zK8BXqHBuudynGS8Qt9IyEf0LQgF6fqdQUqCg5exmgEq1qeC65qV
         4HlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ir9HGZ45FJzt0JfYeTk3McJ+X2KaO54ZpeNTElTDStE=;
        b=kAIgBdBQo/j8mPNrihb2Xw90yL053ckmUDS9PtXd0nAlGhI6thS4EFT7ahWz06cA4v
         p1ExdEVCze/0jDrLbw0P457sbW0QPm/Bha+hvN5k+fLHlEMZVIh9OanZ1MD48hbr1dds
         nN7rtNEESkcUoLd8mAtlliTYUpaevwD48k436KSeXq+X34pg62uFvJU1aNnzrFEqD1Jj
         YA3wHqrF8SusyjGUhGYkZog1BruJhXrKJ7IYYpl/lJrV7vGgtlVV3cKaylHD/0Nl4TYk
         tlSDMp0JFAyp1Y/lvbdNgUGqV14agwwqPEUpOdLZn2XsOYqsImALDE3Ku2dk822nH2Ov
         3LlA==
X-Gm-Message-State: AFqh2kp0OmFTCWcyV8HURJC3ddrxrNnr0Ium/z8SdqTmibYjMuyL7elw
        rGp3AH6JtMJOmazHS/GEyLWdteEsIt0=
X-Google-Smtp-Source: AMrXdXsrqGevRoCXUPf5LTStJbPKSBfAkN1qAFYPNkvqF6FYaOUIy4GQPJjftOHIednitIvwlilTPg==
X-Received: by 2002:a17:902:74c1:b0:193:2bc9:eb25 with SMTP id f1-20020a17090274c100b001932bc9eb25mr6146244plt.20.1673306566478;
        Mon, 09 Jan 2023 15:22:46 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d22-20020a170902aa9600b001871461688esm6628572plr.175.2023.01.09.15.22.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Jan 2023 15:22:46 -0800 (PST)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, justin.tee@broadcom.com,
        Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 05/12] lpfc: Remove redundant clean up code in disable_vport
Date:   Mon,  9 Jan 2023 15:33:10 -0800
Message-Id: <20230109233317.54737-6-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230109233317.54737-1-justintee8345@gmail.com>
References: <20230109233317.54737-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The disable_vport path calls the discovery state machine on all ndlps, puts
them into NPR state, and then calls lpfc_cleanup_rpis with the remove flag
set.  This unintentionally decrements an ndlp's kref twice and can result
in premature release of an ndlp because lpfc_dev_loss_tmo_handler triggers
clean up of the ndlp again later.

Remove redundant code in disable_vport that sets all the ndlps to NPR, and
change the call to cleanup_rpis to not remove the ndlps.
lpfc_dev_loss_tmo_handler will handle final removal of the ndlps.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_vport.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_vport.c b/drivers/scsi/lpfc/lpfc_vport.c
index 4d171f5c213f..5aeda245369b 100644
--- a/drivers/scsi/lpfc/lpfc_vport.c
+++ b/drivers/scsi/lpfc/lpfc_vport.c
@@ -534,7 +534,7 @@ disable_vport(struct fc_vport *fc_vport)
 {
 	struct lpfc_vport *vport = *(struct lpfc_vport **)fc_vport->dd_data;
 	struct lpfc_hba   *phba = vport->phba;
-	struct lpfc_nodelist *ndlp = NULL, *next_ndlp = NULL;
+	struct lpfc_nodelist *ndlp = NULL;
 	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
 
 	/* Can't disable during an outstanding delete. */
@@ -546,17 +546,7 @@ disable_vport(struct fc_vport *fc_vport)
 		(void)lpfc_send_npiv_logo(vport, ndlp);
 
 	lpfc_sli_host_down(vport);
-
-	/* Mark all nodes for discovery so we can remove them by
-	 * calling lpfc_cleanup_rpis(vport, 1)
-	 */
-	list_for_each_entry_safe(ndlp, next_ndlp, &vport->fc_nodes, nlp_listp) {
-		if (ndlp->nlp_state == NLP_STE_UNUSED_NODE)
-			continue;
-		lpfc_disc_state_machine(vport, ndlp, NULL,
-					NLP_EVT_DEVICE_RECOVERY);
-	}
-	lpfc_cleanup_rpis(vport, 1);
+	lpfc_cleanup_rpis(vport, 0);
 
 	lpfc_stop_vport_timers(vport);
 	lpfc_unreg_all_rpis(vport);
-- 
2.38.0


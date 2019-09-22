Return-Path: <SRS0=kJCz=XR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18136C3A5A2
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Sep 2019 03:59:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E07F420820
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Sep 2019 03:59:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SSbXkltY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727494AbfIVD7b (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 21 Sep 2019 23:59:31 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:34471 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727487AbfIVD7a (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Sep 2019 23:59:30 -0400
Received: by mail-ot1-f66.google.com with SMTP id m19so7562656otp.1
        for <linux-scsi@vger.kernel.org>; Sat, 21 Sep 2019 20:59:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=WnLRLaRN9xIz2iTBWwNidQHrVKtJC5KwZgudUdPGF6s=;
        b=SSbXkltYqyOIcLCfLnYPm33oDvLPE7ASdosEftt+vS8vTF64k3eQG9HZb4oqVKolM1
         tppwOtXgE298y5r7QG+MCVx/LoqDUv46VY05AtsbQXOd3L4kQv8eYLvk9v7KRNkEDb1u
         412QhTyxklkbAAU295L/cwe82BYyPBdIzKv3MyuWUFnMFmWbxb8dyI/rFGLlu2zSPy1x
         exOJ15oZH9jcnBx4lgqSdCt1K2aFUf1535vIzt4kRdtL40NRG2KWzge9zvN+Fjy2b251
         x89N4xREc9TSdHQaMROT9TbKOXcP3roriv6Swr1WA/FYIjZeJvvS35FH1QX6oMDgeGjM
         8EEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=WnLRLaRN9xIz2iTBWwNidQHrVKtJC5KwZgudUdPGF6s=;
        b=XXos6N8pmSxj/aWclQtMhWCtCSKhdvS0BxZFdcRdNeqAYIJN6WThpq0Bug9zzCEXMQ
         8UrJbQ3cCObKGWgWGOXlKRjyQbIiMfuKs4a6M2eQUE9kvzDvr26XfoTR57tmdGC1/Z1g
         cTxaakKRd8yqKGvZr0nidm+lwhVknCS7Cd3rhKFbEtWEd5R4GcJqE9UP0Xe5bb9wwZL4
         fTACOe6HlduhCUfMfqMUJWOShKIFwBkEC8pRlZiHU1AfNDQMNVB1tpSWL//eMXzGm39B
         qkzFCUsx/KSoF8TCmS2mBsamdTkBrhnYus3cVdpTU6kq2fxNoEK6P4Lur65F5sKQxLrC
         heoA==
X-Gm-Message-State: APjAAAXWkGhXuHokqlKvxmONTUaJaAv8hPN98e0ggnBeVVzVDmsnudRO
        YHGrm2eDN0mmQbIvfGWcvMKmFI2g
X-Google-Smtp-Source: APXvYqxd9r1jRLVKlPtOYdaNYS2tkBNrOOTTGvGIEE9bOlrI1GO1LSIHz4bFRIwAtc1+4iO8opIRfQ==
X-Received: by 2002:a9d:774b:: with SMTP id t11mr4513255otl.319.1569124769887;
        Sat, 21 Sep 2019 20:59:29 -0700 (PDT)
Received: from os42.localdomain (ip68-5-145-143.oc.oc.cox.net. [68.5.145.143])
        by smtp.gmail.com with ESMTPSA id a9sm2395889otc.75.2019.09.21.20.59.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sat, 21 Sep 2019 20:59:29 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 13/20] lpfc: Fix list corruption in lpfc_sli_get_iocbq
Date:   Sat, 21 Sep 2019 20:58:59 -0700
Message-Id: <20190922035906.10977-14-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20190922035906.10977-1-jsmart2021@gmail.com>
References: <20190922035906.10977-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

After study, it was determined there was a double free of a CT
iocb during execution of lpfc_offline_prep and lpfc_offline.
The prep routine issued an abort for some CT iocbs, but the
aborts did not complete fast enough for a subsequent routine
that waits for completion. Thus the driver proceeded to
lpfc_offline, which releases any pending iocbs. Unfortunately,
the completions for the aborts were then received which re-released
the ct iocbs.

Turns out the issue for why the aborts didn't complete fast
enough was not their time on the wire/in the adapter. It was the
lpfc_work_done routine, which requires the adapter state to be UP
before it calls lpfc_sli_handle_slow_ring_event() to process the
completions. The issue is the prep routine takes the link down
as part of it's processing.

To fix, the following was performed:
- Prevent the offline routine from releasing iocbs that have had aborts
  issued on them. Defer to the abort completions. Also means the
  driver fully waits for the completions.
  Given this change, the recognition of "driver-generated" status
  which then releases the iocb is no longer valid. As such, the change
  made in the commit 296012285c90 is reverted.
  As recognition of "driver-generated" status is no longer valid,
  this patch reverts the changes made in
  commit 296012285c90 ("scsi: lpfc: Fix leak of ELS completions on adapter reset").
- Modify lpfc_work_done to allow slow path completions so that
  the abort completions aren't ignored.
- Updated the fdmi path to recognize a CT request that fails
  due to the port being unusable. This stops FDMI retries. FDMI
  will be restarted on next link up.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_ct.c      | 6 ++++++
 drivers/scsi/lpfc/lpfc_els.c     | 3 +++
 drivers/scsi/lpfc/lpfc_hbadisc.c | 5 ++++-
 drivers/scsi/lpfc/lpfc_sli.c     | 3 ---
 4 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 25e86706e207..f883fac2d2b1 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -1868,6 +1868,12 @@ lpfc_cmpl_ct_disc_fdmi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		if (irsp->ulpStatus == IOSTAT_LOCAL_REJECT) {
 			switch ((irsp->un.ulpWord[4] & IOERR_PARAM_MASK)) {
 			case IOERR_SLI_ABORTED:
+			case IOERR_SLI_DOWN:
+				/* Driver aborted this IO.  No retry as error
+				 * is likely Offline->Online or some adapter
+				 * error.  Recovery will try again.
+				 */
+				break;
 			case IOERR_ABORT_IN_PROGRESS:
 			case IOERR_SEQUENCE_TIMEOUT:
 			case IOERR_ILLEGAL_FRAME:
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 55ab37572e92..bd8109b2a083 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -8019,6 +8019,9 @@ lpfc_els_flush_cmd(struct lpfc_vport *vport)
 		if (piocb->vport != vport)
 			continue;
 
+		if (piocb->iocb_flag & LPFC_DRIVER_ABORTED)
+			continue;
+
 		/* On the ELS ring we can have ELS_REQUESTs or
 		 * GEN_REQUESTs waiting for a response.
 		 */
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index f483b3aea22b..808ad666bb1b 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -700,7 +700,10 @@ lpfc_work_done(struct lpfc_hba *phba)
 			if (!(phba->hba_flag & HBA_SP_QUEUE_EVT))
 				set_bit(LPFC_DATA_READY, &phba->data_flags);
 		} else {
-			if (phba->link_state >= LPFC_LINK_UP ||
+			/* Driver could have abort request completed in queue
+			 * when link goes down.  Allow for this transition.
+			 */
+			if (phba->link_state >= LPFC_LINK_DOWN ||
 			    phba->link_flag & LS_MDS_LOOPBACK) {
 				pring->flag &= ~LPFC_DEFERRED_RING_EVENT;
 				lpfc_sli_handle_slow_ring_event(phba, pring,
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 412cd8c56d90..ff261c0c738a 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -11090,9 +11090,6 @@ lpfc_sli_abort_els_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 				irsp->ulpStatus, irsp->un.ulpWord[4]);
 
 		spin_unlock_irq(&phba->hbalock);
-		if (irsp->ulpStatus == IOSTAT_LOCAL_REJECT &&
-		    irsp->un.ulpWord[4] == IOERR_SLI_ABORTED)
-			lpfc_sli_release_iocbq(phba, abort_iocb);
 	}
 release_iocb:
 	lpfc_sli_release_iocbq(phba, cmdiocb);
-- 
2.13.7


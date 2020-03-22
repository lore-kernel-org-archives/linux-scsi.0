Return-Path: <SRS0=LJp0=5H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD5B4C54FCF
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Mar 2020 18:13:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 97A9E2072E
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Mar 2020 18:13:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TJqRMezJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726785AbgCVSNV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 22 Mar 2020 14:13:21 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:40613 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726809AbgCVSNU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Mar 2020 14:13:20 -0400
Received: by mail-pl1-f193.google.com with SMTP id h11so4875172plk.7
        for <linux-scsi@vger.kernel.org>; Sun, 22 Mar 2020 11:13:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=SjL9wlULIM+y0g1hpu15Horm4Fl2ghOSsG8nfxzCATU=;
        b=TJqRMezJKk/veKx7VJ326oITxV/Ivs9sYaoXlPLVwvczsPb6mCTDbBbzaAls/R/wql
         cNFPSYpwVZr4+8LoRVT7/8XnfFS1WfdAhaKu/mnNmvQ68dGcqDHXcvTu9VyoUdfdjtbY
         zpmhrerctUA5bVieL7ePjOcDjB6yLMPpUoHRuxGCmFK36P/SfXbrKqvTrznpAH+OVZG3
         iDp3aufcU8nLELZ/IcLZ6YN52aIHNox+MG9qBUZ5aKjom9C6slZVfRvbcqd1LUWUDYmx
         2UctIWHyPEWnJ2yvGpUFY8Af2M8ZI+nzuHEE1eitI1lUXPPJwq2DPHIjGcKKOMNeT6QZ
         FePw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=SjL9wlULIM+y0g1hpu15Horm4Fl2ghOSsG8nfxzCATU=;
        b=FnFvSDrRk+uSA1NCR4RNR6aoT84AOMTKioeuQysUG8nJYYwhoN+4kf+6mpjh1O+TL0
         yx3DK0gtK7G+TNhpB7cxUkzroYLMASNOjLOLzkgZ8XLipCM744eb8Clt76p+Dd3TsfNP
         O6iqOQQx1WicBmJLTMibeQp9/L0pfX0E83LCb+h6chPv1+qF6pPUFIPVv0hZpUu8wYT4
         McUCZ3w1+GlYq2beI/N8SVr/lbi3Ha0fTz80hW8PhEYhFmA+pK6vRUL9h5vd2N+IznQ1
         kwpvDUibhI2An0UFpisIolFEuHWNbYoZBVOQ6HpdqcOS4mDPq8oYJkpSu4V5a8aLpjhO
         0M0Q==
X-Gm-Message-State: ANhLgQ2DqF9AYEA4jvpCz/eHLImXIszRcB2g8SxLwE9DkU0Kuc7zsMYP
        nBHuN11266mJ1pKnxzakWbVRK8WU
X-Google-Smtp-Source: ADFU+vuKi0t1pBprji+oKfAM2Ez1sVViUTuPvdv2bcPEjdeqtRFWGdrPLXFjTGyToRJ3kW4/CnVjtQ==
X-Received: by 2002:a17:902:347:: with SMTP id 65mr18010585pld.21.1584900799715;
        Sun, 22 Mar 2020 11:13:19 -0700 (PDT)
Received: from localhost.localdomain.localdomain (ip68-5-146-102.oc.oc.cox.net. [68.5.146.102])
        by smtp.gmail.com with ESMTPSA id bt19sm1331657pjb.3.2020.03.22.11.13.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 22 Mar 2020 11:13:19 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 07/12] lpfc: Fix crash in target side cable pulls hitting WAIT_FOR_UNREG
Date:   Sun, 22 Mar 2020 11:12:59 -0700
Message-Id: <20200322181304.37655-8-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200322181304.37655-1-jsmart2021@gmail.com>
References: <20200322181304.37655-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Kernel is crashing with the following stacktrace:
  BUG: unable to handle kernel NULL pointer dereference at
    00000000000005bc
  IP: lpfc_nvme_register_port+0x1a8/0x3a0 [lpfc]
  ...
  Call Trace:
  lpfc_nlp_state_cleanup+0x2b2/0x500 [lpfc]
  lpfc_nlp_set_state+0xd7/0x1a0 [lpfc]
  lpfc_cmpl_prli_prli_issue+0x1f7/0x450 [lpfc]
  lpfc_disc_state_machine+0x7a/0x1e0 [lpfc]
  lpfc_cmpl_els_prli+0x16f/0x1e0 [lpfc]
  lpfc_sli_sp_handle_rspiocb+0x5b2/0x690 [lpfc]
  lpfc_sli_handle_slow_ring_event_s4+0x182/0x230 [lpfc]
  lpfc_do_work+0x87f/0x1570 [lpfc]
  kthread+0x10d/0x130
  ret_from_fork+0x35/0x40

During target side fault injections, it is possible to hit the
NLP_WAIT_FOR_UNREG case in lpfc_nvme_remoteport_delete. A prior commit
fixed a rebind and delete race condition, but called lpfc_nlp_put
unconditionally. This triggered a deletion and the crash.

Fix by movng nlp_put to inside the NLP_WAIT_FOR_UNREG case, where the nlp
will be being unregistered/removed. Leave the reference if the flag isn't
set.

Fixes: 	b15bd3e6212e ("scsi: lpfc: Fix nvme remoteport registration race conditions")
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_nvme.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index f6c8963c915d..32b28651039e 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -382,13 +382,15 @@ lpfc_nvme_remoteport_delete(struct nvme_fc_remote_port *remoteport)
 	if (ndlp->upcall_flags & NLP_WAIT_FOR_UNREG) {
 		ndlp->nrport = NULL;
 		ndlp->upcall_flags &= ~NLP_WAIT_FOR_UNREG;
-	}
-	spin_unlock_irq(&vport->phba->hbalock);
+		spin_unlock_irq(&vport->phba->hbalock);
 
-	/* Remove original register reference. The host transport
-	 * won't reference this rport/remoteport any further.
-	 */
-	lpfc_nlp_put(ndlp);
+		/* Remove original register reference. The host transport
+		 * won't reference this rport/remoteport any further.
+		 */
+		lpfc_nlp_put(ndlp);
+	} else {
+		spin_unlock_irq(&vport->phba->hbalock);
+	}
 
  rport_err:
 	return;
-- 
2.16.4


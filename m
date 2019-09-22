Return-Path: <SRS0=kJCz=XR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5247C3A5A6
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Sep 2019 03:59:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 958D620B7C
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Sep 2019 03:59:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HxDC81H9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727478AbfIVD71 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 21 Sep 2019 23:59:27 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:39121 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727476AbfIVD70 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Sep 2019 23:59:26 -0400
Received: by mail-oi1-f195.google.com with SMTP id w144so5002944oia.6
        for <linux-scsi@vger.kernel.org>; Sat, 21 Sep 2019 20:59:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=HhPJWvSkc0N/+H4eEoEu7pe5cOw51s7pSPF4u+2FFUg=;
        b=HxDC81H9xw7veNAOBGaaa13mswONYw4XKTiLH4fw7k5rxncp3PJJTBaNkPNZtpiMaX
         U4BDq6QxmIYfYlQO4iSPS8qTbg+EZf+bPXaE8oMpOHR1snWzBThrSimIgMIk8oqg/5T3
         fvs8lL7sJCCKK1+TkrPYZPwFcU/6dLTbdMNTtVQk1zFDHFeo6jR2V9f+YvwhUVY64sYx
         m4Pa07cIwQOdoIY4DC3w9a6YQcqx1eDZa5PjwgyE/6yKF0ISH8AsUbij4hTte86KSLsC
         as8Vd0pEnZyabRwUfkiUEsMwuXLSUnTwy1fLWnGzXtCexgpDYkFCbbdljcMoFFJtVpVn
         E1Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=HhPJWvSkc0N/+H4eEoEu7pe5cOw51s7pSPF4u+2FFUg=;
        b=MfWcqHwhANfaCbi5yHtiC4+O2jZMsDlnani3Qe6J4xHrXjpcG8peg2/t8KlQV+OZUU
         tpQY+Z1NWewG0MNWX6MPOMoMkyTrfLy4VmL10gIz7tSwW/iIiNuEbr3hVTIXrwkChw0/
         feiUf89PTUj0oTniI6iNZwad1LiTGikXehL3yY8Bq4me4naLB79MKcyKKS74m1ifGxr7
         44oUoOXOHZljNIBi815BaMjZ62gZCSiEasnRe6bsdTdZwyQMxc4XYXQHs9CslAODnTdR
         QjJ9BUN5+xjfpxfK0THpemP19nLSlS3OfBQNRo2lDa15XhCLyAYbz8IiFgBaoCrmrVto
         PJJw==
X-Gm-Message-State: APjAAAVRvWvbXPcW+k+VqexWjCNxcdD017SX2fMTwq+AzVJhUdLJHEin
        lBLvanHtMyL8nhHqpVj+Hp1CnxhS
X-Google-Smtp-Source: APXvYqw79C+CZN9JPsRFkruCpB++3fgxhmEhHUduoHFAfI0fZYUTLSgQnHFhSdD8qGO67uUeFaTDaw==
X-Received: by 2002:aca:b743:: with SMTP id h64mr8752982oif.29.1569124765224;
        Sat, 21 Sep 2019 20:59:25 -0700 (PDT)
Received: from os42.localdomain (ip68-5-145-143.oc.oc.cox.net. [68.5.145.143])
        by smtp.gmail.com with ESMTPSA id a9sm2395889otc.75.2019.09.21.20.59.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sat, 21 Sep 2019 20:59:24 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 09/20] lpfc: Fix discovery failures when target device connectivity bounces
Date:   Sat, 21 Sep 2019 20:58:55 -0700
Message-Id: <20190922035906.10977-10-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20190922035906.10977-1-jsmart2021@gmail.com>
References: <20190922035906.10977-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

An issue was seen discovering all SCSI Luns when a target device
undergoes link bounce.

The driver currently does not qualify the FC4 support on the target.
Therefore it will send a SCSI PRLI and an NVMe PRLI. The expectation
is that the target will reject the PRLI if it is not supported. If a
PRLI times out, the driver will retry. The driver will not proceed
with the device until both SCSI and NVMe PRLIs are resolved.
In the failure case, the device is FCP only and does not respond to
the NVMe PRLI, thus initiating the wait/retry loop in the driver.
During that time, a RSCN is received (device bounced) causing the
driver to issue a GID_FT.  The GID_FT response comes back before the
PRLI mess is resolved and it prematurely cancels the PRLI retry
logic and leaves the device in a STE_PRLI_ISSUE state. Discovery
with the target never completes or resets.

Fix by resetting the node state back to STE_NPR_NODE when GID_FT
completes, thereby restarting the discovery process for the node.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 144786947b63..f483b3aea22b 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -5444,9 +5444,14 @@ lpfc_setup_disc_node(struct lpfc_vport *vport, uint32_t did)
 			/* If we've already received a PLOGI from this NPort
 			 * we don't need to try to discover it again.
 			 */
-			if (ndlp->nlp_flag & NLP_RCV_PLOGI)
+			if (ndlp->nlp_flag & NLP_RCV_PLOGI &&
+			    !(ndlp->nlp_type &
+			     (NLP_FCP_TARGET | NLP_NVME_TARGET)))
 				return NULL;
 
+			ndlp->nlp_prev_state = ndlp->nlp_state;
+			lpfc_nlp_set_state(vport, ndlp, NLP_STE_NPR_NODE);
+
 			spin_lock_irq(shost->host_lock);
 			ndlp->nlp_flag |= NLP_NPR_2B_DISC;
 			spin_unlock_irq(shost->host_lock);
-- 
2.13.7


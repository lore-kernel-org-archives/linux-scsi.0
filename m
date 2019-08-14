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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 261F9C433FF
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 23:57:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E988320866
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 23:57:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oWm7eCS8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729103AbfHNX5b (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Aug 2019 19:57:31 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:40894 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728983AbfHNX5a (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Aug 2019 19:57:30 -0400
Received: by mail-pl1-f194.google.com with SMTP id a93so329544pla.7
        for <linux-scsi@vger.kernel.org>; Wed, 14 Aug 2019 16:57:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=NAVHtSROOA6grjVPNxByNxQSRFAr4kBJBub/nRw1Q2w=;
        b=oWm7eCS8W/mR1h/lWJVb2mJRU+hp36ytMzKBmlh+leJIGXsQoxpCtB2Hpxpfi5nAs3
         8ZcqcascBYvEbMuUU6oKgjUwVeQWVkUyb8CAYYWG61JGvPpnmSTCPa0l8BtNELrVlkDb
         QhPpJj0Xx3Qz/QrS3SsWq6J2S9YavB5y2LHedx/q93GbKtJr5zF8/pwvmNaQTeGelDqG
         guc+PT5UU3yxRjqERMSTLUw1JeBcTQqdmWXsKm0v+Xh2y6nzD8IYvtBawpIfbJDvvvK8
         9qO2CC9alJf0uSYZRuTzWX11zKTxxxQmau+m2fY1fhWzanUYZ8JwZj0dL9hEvjTRQ7Kd
         TIjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=NAVHtSROOA6grjVPNxByNxQSRFAr4kBJBub/nRw1Q2w=;
        b=KYk0LVq288eR8BacOMDKMBL2Gv+ItgAoHsEFDqfZvQvbdE6McpvCU34U9KFe4zQf3r
         /ZqstD0oZahjWUlSuiPAW1GtNyeC/XaCuOK8SX+1BEw/bYLk0fhKAgu4qDX0HENYV4xD
         9Sh0M3c8Lr1MX36QveJ+DX70G4kDcjFwmOLJLZ8G5zhTU4wUc0wbHmqwIo6T81LTw38f
         D8Fp2GmjO4yzRqheY6QRIWaasdio14HvNCIix7EBWoXguvPqfkjRfnVGTlyU17/xzuSw
         vp6rFwwG/cdXAtD0kviek9uDyKJxtwkg6kAJ/vRyKnDYK6Cu2NnYKZZ5JljSMwjHHZwZ
         gBqQ==
X-Gm-Message-State: APjAAAVcx8FdUE8pJoTLlRqSb2JbsVZzj6CopGEuqvEv5zxExSIM1MWC
        XdGVgI5QP0NaO3aqJVcFbp7fIh/6
X-Google-Smtp-Source: APXvYqxnUL1c0VXKdip/TjJ/nKiX5hdlIpEunEIW1XY/Jg5gQEuEjAGXzusFcH2DH27troZwu6tqoQ==
X-Received: by 2002:a17:902:ba81:: with SMTP id k1mr1846767pls.213.1565827049225;
        Wed, 14 Aug 2019 16:57:29 -0700 (PDT)
Received: from pallmd1.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id k22sm987299pfk.157.2019.08.14.16.57.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 14 Aug 2019 16:57:28 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 09/42] lpfc: Fix ADISC reception terminating login state if a NVME target
Date:   Wed, 14 Aug 2019 16:56:39 -0700
Message-Id: <20190814235712.4487-10-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20190814235712.4487-1-jsmart2021@gmail.com>
References: <20190814235712.4487-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If a target issues an ADISC to the port and the target is a NVME
target, the driver is inadvertantly invalidating the login and
marking the remote port as logged out. Communication with the
target is lost.

Revise the ADISC check so that FCP or NVME targets will be
marked valid at the end of ADISC processing.
Enhance logging to recognize condition better.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_nportdisc.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index d76d76081d1a..f4eea52c66f5 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -614,7 +614,7 @@ lpfc_rcv_padisc(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		}
 out:
 		/* If we are authenticated, move to the proper state */
-		if (ndlp->nlp_type & NLP_FCP_TARGET)
+		if (ndlp->nlp_type & (NLP_FCP_TARGET | NLP_NVME_TARGET))
 			lpfc_nlp_set_state(vport, ndlp, NLP_STE_MAPPED_NODE);
 		else
 			lpfc_nlp_set_state(vport, ndlp, NLP_STE_UNMAPPED_NODE);
@@ -2903,18 +2903,21 @@ lpfc_disc_state_machine(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	uint32_t(*func) (struct lpfc_vport *, struct lpfc_nodelist *, void *,
 			 uint32_t);
 	uint32_t got_ndlp = 0;
+	uint32_t data1;
 
 	if (lpfc_nlp_get(ndlp))
 		got_ndlp = 1;
 
 	cur_state = ndlp->nlp_state;
 
+	data1 = (((uint32_t)ndlp->nlp_fc4_type << 16) |
+		((uint32_t)ndlp->nlp_type));
 	/* DSM in event <evt> on NPort <nlp_DID> in state <cur_state> */
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
 			 "0211 DSM in event x%x on NPort x%x in "
 			 "state %d rpi x%x Data: x%x x%x\n",
 			 evt, ndlp->nlp_DID, cur_state, ndlp->nlp_rpi,
-			 ndlp->nlp_flag, ndlp->nlp_fc4_type);
+			 ndlp->nlp_flag, data1);
 
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_DSM,
 		 "DSM in:          evt:%d ste:%d did:x%x",
@@ -2925,10 +2928,13 @@ lpfc_disc_state_machine(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 
 	/* DSM out state <rc> on NPort <nlp_DID> */
 	if (got_ndlp) {
+		data1 = (((uint32_t)ndlp->nlp_fc4_type << 16) |
+			((uint32_t)ndlp->nlp_type));
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
 			 "0212 DSM out state %d on NPort x%x "
-			 "rpi x%x Data: x%x\n",
-			 rc, ndlp->nlp_DID, ndlp->nlp_rpi, ndlp->nlp_flag);
+			 "rpi x%x Data: x%x x%x\n",
+			 rc, ndlp->nlp_DID, ndlp->nlp_rpi, ndlp->nlp_flag,
+			 data1);
 
 		lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_DSM,
 			"DSM out:         ste:%d did:x%x flg:x%x",
-- 
2.13.7


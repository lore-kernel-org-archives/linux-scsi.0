Return-Path: <SRS0=ePHC=6P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAE42C47256
	for <linux-scsi@archiver.kernel.org>; Fri,  1 May 2020 21:43:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A3EAC216FD
	for <linux-scsi@archiver.kernel.org>; Fri,  1 May 2020 21:43:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VxLbMJ5U"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726564AbgEAVn2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 May 2020 17:43:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726473AbgEAVn1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 May 2020 17:43:27 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B412DC08E859
        for <linux-scsi@vger.kernel.org>; Fri,  1 May 2020 14:43:26 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id j1so13218507wrt.1
        for <linux-scsi@vger.kernel.org>; Fri, 01 May 2020 14:43:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Vv4ytNzEcopKaz8vwbQnowrsOWj2zpwTXKtoo4+Vczk=;
        b=VxLbMJ5Uag5/Y15QQg6HOyi1qIGGHfBoUvww14S9PZvWN5wdzALRY07gIweUUYJSnb
         qa0GGT53W4KGDhtatGDL4mw/OKTLr0q0XhUprOQrIFjcGHjS3guVHJG4Wh3kRfFjFVSQ
         nVhFI1HapZ3HxI2/CDkySbjzARYGngvxgHvJuRS9tRIW6TFWi53TV6jIu1s7P7cgHC8e
         7kkqGN7wKFD5I79bTDLiJsRN5HY08pkTLpSlSiLz5iJObdx5de2hOvHnMXSY12I0sMMq
         TuUKu7ashqkKc6GwiMCad2Jb4quu3fEDdpJbjyGYePHRpHXpz0otkte2vGrCo2r7ky8A
         5SuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Vv4ytNzEcopKaz8vwbQnowrsOWj2zpwTXKtoo4+Vczk=;
        b=puHm0AB5ZjPxH4MEKqe69rU2XNkq/OfKbmtPAZXEYNCeAfYWR2wDxclqLx0XOQ9qrT
         qPEauDRuXuZSkMnNfOISsGMqcomlsC9xgHh0veVt8dDKw3BIvl3I44y7EvQki3yLOXCZ
         8FUAq0WNGQ5IMKeEPb5NI9H55x9DTtLQFPHIylx47JKpWR7SW0Nvy6bq9T+V/f7qN6dc
         Ta+5ppfe+bT1qBx79nrvY7MbUYTI6Z+LcNs91+7edbY+aRPvTIcKh+tH25Bhzyc9tliQ
         q+RXvvIEFJYL6C3sCSonUwtLJqVBH7JSQreXTyBULsQm/+Le84j8pfUzli2lWLU5V+QS
         2BuA==
X-Gm-Message-State: AGi0PuY8gnsaV0SyywZnKZakuk3B2IsdksbvINgxLaAWD9xDZ0eQTBhQ
        3ipzXvUsKQQW1OSnLemF0ZpZC6rF
X-Google-Smtp-Source: APiQypLd9xS2P920d2QS8nuesUj1eZHUEBM+lwxHtpEU2NI0eLL+dqNNy4dHp5mgy3ngj0GlVtz+0g==
X-Received: by 2002:adf:edc6:: with SMTP id v6mr5997781wro.8.1588369405225;
        Fri, 01 May 2020 14:43:25 -0700 (PDT)
Received: from localhost.localdomain.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id t2sm1207734wmt.15.2020.05.01.14.43.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 01 May 2020 14:43:24 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 3/9] lpfc: Remove re-binding of nvme rport during registration
Date:   Fri,  1 May 2020 14:43:04 -0700
Message-Id: <20200501214310.91713-4-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200501214310.91713-1-jsmart2021@gmail.com>
References: <20200501214310.91713-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The lldd rebinds the ndlp with rport during a nvme rport registration
(va nvme_fc_register_remoteport). If rport & ndlp pointers are same as
the previous one, the lldd will re-use the ndlp and rport association
without re-iniitalization. This assumption is incorrect. The lldd should
be ignorant of whether the returned rport pointer is new or not, and
should always assume it is new.

Remove the re-binding code, always assumes that rport pointer received
from transport is a new pointer.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_nvme.c | 32 --------------------------------
 1 file changed, 32 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 43df08aeecf1..3121cf37a572 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -2322,38 +2322,6 @@ lpfc_nvme_register_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 		spin_unlock_irq(&vport->phba->hbalock);
 		rport = remote_port->private;
 		if (oldrport) {
-			/* New remoteport record does not guarantee valid
-			 * host private memory area.
-			 */
-			if (oldrport == remote_port->private) {
-				/* Same remoteport - ndlp should match.
-				 * Just reuse.
-				 */
-				lpfc_printf_vlog(ndlp->vport, KERN_INFO,
-						 LOG_NVME_DISC,
-						 "6014 Rebind lport to current "
-						 "remoteport x%px wwpn 0x%llx, "
-						 "Data: x%x x%x x%px x%px x%x "
-						 " x%06x\n",
-						 remote_port,
-						 remote_port->port_name,
-						 remote_port->port_id,
-						 remote_port->port_role,
-						 oldrport->ndlp,
-						 ndlp,
-						 ndlp->nlp_type,
-						 ndlp->nlp_DID);
-
-				/* It's a complete rebind only if the driver
-				 * is registering with the same ndlp. Otherwise
-				 * the driver likely executed a node swap
-				 * prior to this registration and the ndlp to
-				 * remoteport binding needs to be redone.
-				 */
-				if (prev_ndlp == ndlp)
-					return 0;
-
-			}
 
 			/* Sever the ndlp<->rport association
 			 * before dropping the ndlp ref from
-- 
2.26.1


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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53179C32753
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 23:57:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2815F20866
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 23:57:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oVU3lBqX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729795AbfHNX5o (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Aug 2019 19:57:44 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:39480 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729789AbfHNX5n (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Aug 2019 19:57:43 -0400
Received: by mail-pg1-f193.google.com with SMTP id u17so419349pgi.6
        for <linux-scsi@vger.kernel.org>; Wed, 14 Aug 2019 16:57:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=PPuoM/EbKyg8oKfh2hpxCgf7QxGdSoMeutciCnlu/9s=;
        b=oVU3lBqXwBYq8MEeHUIfLieUzaIB8EOzmwu3RgFIJz2pWbDrkfyue8TcFcLTR+EXoQ
         I2Y8fkniGzUWlDfYCYJfDh1Iph3vd74ZWw0170jMWGJpQaQRT++ERDEvSVTz04DUhhI6
         iGljp53brjOp6qVCYEHzaEBsAM1NugBjzo3a0ieo2XUgot+7cMkICVFgpjvTB8UeIDKX
         ydipJbvvHA68BpEvum7zk6pmrIorQzYtIkxqQtNqr01yzA7azW+/0tJC9xdIMUF5KNzw
         AMeOaMXB4aMOch+oklmJlV++Hg0gBb+A5p7DEi/jM0hbnW6D9+qouNl1ieI2bVq0q9uY
         Ig8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=PPuoM/EbKyg8oKfh2hpxCgf7QxGdSoMeutciCnlu/9s=;
        b=a1MUEsBucG8gPqdNj8WtJkUOOLVe5gv3YmY9WcXjJoLhM9TFHx7wWxmmltrVSCBSlj
         YtCfydocRSKwmAWtKOj+nXJfU7UCEqmg7ZdKsXMuLQR+eMydPB60Uli98gUk6b5Ou7J/
         YR6P6XG+rqADaj5kNQDd13x3HCJrqZmx/ZMiIdkQrEb3Y2CSgRqfH/fCSTX3DGOnW37q
         m/VuEhFBBWcpIq2vsS/TTBYyeFvsoD+JDdtuhywkiFFpVcehnQqSs6Y1L2Q/wLTS6O90
         E9x+AnMuMZxhZKibGSykpfJRqoMh18x5OzI+MFnFQk9nsMRgx+vJTy4/k9WhU+HbOWMC
         KGOQ==
X-Gm-Message-State: APjAAAXRFJo6VncXL5Fu+lbV3wFcTK+b+yxltVtFk9G3sV4SbcRi9XOW
        Ou7h/A+NwXWoul9oBXk4MyrywtOa
X-Google-Smtp-Source: APXvYqzJz7BYt16vmqBG9w2Mj+Hc9rJbVsfeESRTjatON35PGjpEQyIO9yfXJmSt2DS5a1Fce3u4QQ==
X-Received: by 2002:a65:5b09:: with SMTP id y9mr1385375pgq.345.1565827062504;
        Wed, 14 Aug 2019 16:57:42 -0700 (PDT)
Received: from pallmd1.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id k22sm987299pfk.157.2019.08.14.16.57.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 14 Aug 2019 16:57:41 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 26/42] lpfc: Fix nvme target mode ABTSing a received ABTS
Date:   Wed, 14 Aug 2019 16:56:56 -0700
Message-Id: <20190814235712.4487-27-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20190814235712.4487-1-jsmart2021@gmail.com>
References: <20190814235712.4487-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If an unsolicited ABTS was received, the driver looks up the
exchange it references. It it does various searches looking for
the exchange context. When one is eventually matched and it is
associated with an XRI context, the driver sends an ABORT WQE
to terminate the exchange. Current code looks at whether the
transport had taken action on the XRI yet or not  (no action if
set to LPFC_NVMET_STE_RCV; action if non-LPFC_NVMET_STE_RCV).
Based on action or not one of two (sol vs unsol) issue abort
routines are called. The unsol version cheats and transmits a
sequence containing an ABTS with no interaction with the adapter.
The sol version issues an Abort WQE and lets the adapter manage
whether the ABTS is sent to not.

The issue is the unsol version is sending ABTS unconditionally
for the exchange that received the ABTS. It's unnecessary.

Remove the conditional and just call the adapter command-based
routine to let the adapter manage the ABTS.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_nvmet.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index faa596f9e861..f0840e3182c0 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -1790,12 +1790,8 @@ lpfc_nvmet_rcv_unsol_abort(struct lpfc_vport *vport,
 			lpfc_nvmet_defer_release(phba, ctxp);
 			spin_unlock_irqrestore(&ctxp->ctxlock, iflag);
 		}
-		if (ctxp->state == LPFC_NVMET_STE_RCV)
-			lpfc_nvmet_unsol_fcp_issue_abort(phba, ctxp, ctxp->sid,
-							 ctxp->oxid);
-		else
-			lpfc_nvmet_sol_fcp_issue_abort(phba, ctxp, ctxp->sid,
-						       ctxp->oxid);
+		lpfc_nvmet_sol_fcp_issue_abort(phba, ctxp, ctxp->sid,
+					       ctxp->oxid);
 
 		lpfc_sli4_seq_abort_rsp(vport, fc_hdr, 1);
 		return 0;
-- 
2.13.7


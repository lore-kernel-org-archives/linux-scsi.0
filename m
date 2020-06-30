Return-Path: <SRS0=aUil=AL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44BDBC433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 21:50:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20A012078D
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 21:50:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WZBvwTIy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729676AbgF3VuV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Jun 2020 17:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726737AbgF3VuT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Jun 2020 17:50:19 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55D0AC03E979
        for <linux-scsi@vger.kernel.org>; Tue, 30 Jun 2020 14:50:19 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id z15so10362167wrl.8
        for <linux-scsi@vger.kernel.org>; Tue, 30 Jun 2020 14:50:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=todmM6xACCtwv/AKoPuTg4yZIh726Ble1VQM2uvTNSY=;
        b=WZBvwTIyYUX46x7t8bDHrEH2gbLrRj2XMgDUgaXvl5MB2HQHUA2RM3wriLoFxjpDUK
         JgSkfoUAASlTERai8h/OJ7TqLvX5eAdMXdAVGZkRRPNOPImaxnmLlRS93CaHlgOSejX4
         6IpmdgLBa3eHYRiphMLPMYkzYYgqzFLSDb7vXMlkZTKxoJnMTGM+vyPxpJ+kClhmRAFz
         82oXQ0KtMMTu57g/S+6ydSHylOl/g4dL+23z4NAmgV3iU6LFmz0sMgZ2DCmjTVCW42HV
         wu/UZRPVvgz49ikOV/HOnb4qUCfCRQpGuE9qUi5/Iax4pyFcAjgYEIRAX/sDX3Zd4ZOP
         eJYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=todmM6xACCtwv/AKoPuTg4yZIh726Ble1VQM2uvTNSY=;
        b=rwDhDBP21KVnpQlG1NEKy6WdBPoN4GuGnc40DoO11IXDs0/umI4W6oVNminoFXNfUq
         V+iqdIe0mtLmZAQSd3Uu+6dmkX59ndKZKgcOb0mz2t9Jac8ipnTQCzSLYeCR7XR1HT1f
         r05JmZmaDf5k6bLNRxgUqo365CxppSwDRKsqYVn5N0L5t0d4rghY5tM8dgEFul19+qKI
         68nV121a9/+HppK8CXqgGMKmFpBWgpGXPNZURyKgOfwuCe+j651k3eTyGxi8iU0GYTNB
         BbP0gCDZLSlX0GL0F5H7E77CQ0f1TccMoHU63yf0Xln9IvV/RuBUu4Exg0CxLvevQDr5
         jarQ==
X-Gm-Message-State: AOAM532Hog6lCWSUyjMhGc7C/P2nd28oKv2/IirTK//k7yGlGg+SHJ5C
        4PbEqAWk07BXySjOe17M4H21Byd4
X-Google-Smtp-Source: ABdhPJxjdwCQyFXJKbViKxN0Gwnu9Vlrmb44nO5NU8sTAPOI2Zzy4a97urDN9RmlWCiHNHq3SSibrw==
X-Received: by 2002:adf:b312:: with SMTP id j18mr22146723wrd.195.1593553817775;
        Tue, 30 Jun 2020 14:50:17 -0700 (PDT)
Received: from localhost.localdomain.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id f14sm5518551wro.90.2020.06.30.14.50.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2020 14:50:17 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 04/14] lpfc: Fix NVME rport deregister and registration during ADISC
Date:   Tue, 30 Jun 2020 14:49:51 -0700
Message-Id: <20200630215001.70793-5-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200630215001.70793-1-jsmart2021@gmail.com>
References: <20200630215001.70793-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

During driver unload/reload testing, the nvme initiator would
not re-establish connectivity to nvme controllers on reload.

The failing nvme array supports concurrent FCP and NVME operation
via different nport_id's. The array was repeatedly sending an ADISC
every 2 seconds after PLOGI completed and while nvme subsytems were
executing discovery. The target would continue this state for
roughly 45 seconds.

The driver's current behavior on ADISC receipt is to validate a
the ADISC vs the device and issue a RESUME_RPI to restore
transmission. The receipt of the ADISC effectively caused a driver to
take actions similar to a logout and login for the remote port, causing
the deregistration of the nvme rport and a subsequent re-registration.
This caused a constant reset and re-connect of the nvme controller while
this 45s window occurred. There was no need for the state changes as
ADISC does not change login state.

This patch corrects this behavior by validating if the remoteport is
already logged in (MAPPED) and when true, avoids the call to set the ndlp
state to MAPPED, which triggers the unreg/re-reg. Thus ADISC does not
change the login state of the node.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_nportdisc.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index 2871c9b0cbfa..057af32f498d 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -797,11 +797,17 @@ lpfc_rcv_padisc(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 				ndlp, NULL);
 		}
 out:
-		/* If we are authenticated, move to the proper state */
-		if (ndlp->nlp_type & (NLP_FCP_TARGET | NLP_NVME_TARGET))
-			lpfc_nlp_set_state(vport, ndlp, NLP_STE_MAPPED_NODE);
-		else
-			lpfc_nlp_set_state(vport, ndlp, NLP_STE_UNMAPPED_NODE);
+		/* If we are authenticated, move to the proper state.
+		 * It is possible an ADISC arrived and the remote nport
+		 * is already in MAPPED or UNMAPPED state.  Catch this
+		 * condition and don't set the nlp_state again because
+		 * it causes an unnecessary transport unregister/register.
+		 */
+		if (ndlp->nlp_type & (NLP_FCP_TARGET | NLP_NVME_TARGET)) {
+			if (ndlp->nlp_state != NLP_STE_MAPPED_NODE)
+				lpfc_nlp_set_state(vport, ndlp,
+						   NLP_STE_MAPPED_NODE);
+		}
 
 		return 1;
 	}
-- 
2.25.0


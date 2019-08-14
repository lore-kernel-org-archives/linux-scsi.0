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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BDD3C32753
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 23:57:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C32B20866
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 23:57:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PZaXjjK5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729316AbfHNX5i (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Aug 2019 19:57:38 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:35494 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729133AbfHNX5h (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Aug 2019 19:57:37 -0400
Received: by mail-pg1-f195.google.com with SMTP id n4so432335pgv.2
        for <linux-scsi@vger.kernel.org>; Wed, 14 Aug 2019 16:57:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=V7hn4J6UFm2kpDnZ3Df7CoZ0/NVyZFXifTidEGvtbN0=;
        b=PZaXjjK5u9pssImh85uzA2tBl6HW2+KiDL977UfatIgkCeNXMrNWt/22tT3Cla+UJf
         njxEJZ+TxTpjLMGVrMV5Bfv+Ew/rZT1JubhziERo61pEdZ2/bClsFvLHG2Yrn28dd5j3
         6c23G5wZiID9uV9jnTyPkqh8fPKO/D5x0sch5CjUw93fQ1cO9Em5L7iYP7NX/wDxyxxL
         HTft3DmtxR2omD+dUEbSKnpWNlODLnBMvgGfbunRSPx0jMRoRo3MuEaqaly2g8/JFdkc
         UGNqu/pXPJtiKcvTuLLwkIu1G4+10zvDrQrLdLu3MGtCNSPFbB1s7pRcjHl8fkxKeTXf
         OROg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=V7hn4J6UFm2kpDnZ3Df7CoZ0/NVyZFXifTidEGvtbN0=;
        b=CYfZSixCuKEwpEythkGGy0fJcaobUbRYzusglB1V+O7u2av2aHrzN22sgE/8O9kxzD
         qY7830AjAgZkTQhpy/HMzIYfqbh67/+Lfl4WgYRxDLYKrSd6Oqf9tfHpe3PTj65f9J3D
         ylxndzI5IstrfdTPL3QlBPe/UojsmrNunrB4Mww+FHzLQxMBsE26AP8/mDw3n4H8v7DO
         H1F2GVB2Q/lglV7NkrENIYo1nPFs1lAbIjrNgp/tqG+sSn5jT+gc0+6jkDeun8xVbsgt
         A+rULeoE1WSeXkIcvpaVT7vl2VcyknbH3WYKN/sSXdCMx+D1E/ePKp6IhBcE0ALjwfF+
         iF8w==
X-Gm-Message-State: APjAAAU8dKQ3qEqDf0kvH748Y9KIB2j7v64OPFw0Aqft8sTN5eskvT4l
        1HbtrVQUVRxF26SekwiQ/yWe7EQg
X-Google-Smtp-Source: APXvYqyvV7WZRK3p2iRRHXp2NSkXLrD+yOQVhNNBHT94axmUVhi419opmjc95nEayEck8MUCj7cmMA==
X-Received: by 2002:a17:90a:e38e:: with SMTP id b14mr403951pjz.125.1565827056174;
        Wed, 14 Aug 2019 16:57:36 -0700 (PDT)
Received: from pallmd1.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id k22sm987299pfk.157.2019.08.14.16.57.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 14 Aug 2019 16:57:35 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 18/42] lpfc: Fix propagation of devloss_tmo setting to nvme transport
Date:   Wed, 14 Aug 2019 16:56:48 -0700
Message-Id: <20190814235712.4487-19-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20190814235712.4487-1-jsmart2021@gmail.com>
References: <20190814235712.4487-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If admin changes the devloss_tmo on an rport via the fc_remote_port
rport dev_loss_tmo attribute, the value is on set on scsi stack.
The change is not propagated to NVMe.

The set routine in the lldd lacks the call to
nvme_fc_set_remoteport_devloss() to set the value.

Fix by adding the call to the lldd set routine.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_attr.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 33c8bae49821..90181afe0e28 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -6859,10 +6859,31 @@ lpfc_get_starget_port_name(struct scsi_target *starget)
 static void
 lpfc_set_rport_loss_tmo(struct fc_rport *rport, uint32_t timeout)
 {
+	struct lpfc_rport_data *rdata = rport->dd_data;
+	struct lpfc_nodelist *ndlp = rdata->pnode;
+#if (IS_ENABLED(CONFIG_NVME_FC))
+	struct lpfc_nvme_rport *nrport = NULL;
+#endif
+
 	if (timeout)
 		rport->dev_loss_tmo = timeout;
 	else
 		rport->dev_loss_tmo = 1;
+
+	if (!ndlp || !NLP_CHK_NODE_ACT(ndlp)) {
+		dev_info(&rport->dev, "Cannot find remote node to "
+				      "set rport dev loss tmo, port_id x%x\n",
+				      rport->port_id);
+		return;
+	}
+
+#if (IS_ENABLED(CONFIG_NVME_FC))
+	nrport = lpfc_ndlp_get_nrport(ndlp);
+
+	if (nrport && nrport->remoteport)
+		nvme_fc_set_remoteport_devloss(nrport->remoteport,
+					       rport->dev_loss_tmo);
+#endif
 }
 
 /**
-- 
2.13.7


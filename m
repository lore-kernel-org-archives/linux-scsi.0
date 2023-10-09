Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ADCBE95A9F
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Oct 2023 16:05:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377119AbjJIQFo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Oct 2023 12:05:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377113AbjJIQFk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Oct 2023 12:05:40 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3BCAAC
        for <linux-scsi@vger.kernel.org>; Mon,  9 Oct 2023 09:05:38 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id d9443c01a7336-1c45c45efeeso2364335ad.0
        for <linux-scsi@vger.kernel.org>; Mon, 09 Oct 2023 09:05:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696867538; x=1697472338; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e4uwH4EBz0Ok57QjNGlE5d8xvVvRPv/4sT/KxlUc+rk=;
        b=EuieGNJqjlloaha9bmI1tF3qiyTxuziLIlBwtnjeE4K9nhAc3Tq2K65jIy0zZXdnmK
         RdrUciUMgEOO01pnXYIQbXRCyiIGD8EW6JGUpr7KAckK2I8xJRS2obzZhqUKPyYP9vdw
         4TyJlMkTDO7blSKmiZdXmMra/rgP1mUEnLE/H/atz7gDBeJdDfMO96LO+omTJ5u3V6Jl
         OFCmihyPLy+xSfzSY98f7A4KzwPZsjkjE0xjUyC24y57DONLk/IZGR614I5WXGjZKrzZ
         pjAai8yGfYYk/iD1y0DQhQznDFzcnUB7KjMgIoxEw6JNJVvLIz3IfC5Ae9QQ3HX8YaVT
         IX5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696867538; x=1697472338;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e4uwH4EBz0Ok57QjNGlE5d8xvVvRPv/4sT/KxlUc+rk=;
        b=MIqJ3LGe+ANu0n+ColnKII6VtVKxw/j4Lap6Zcr/6I0KE+HMQZMwSH9+FeTTnET8YB
         TeZDm+jFZB1kG6z3OwCM0Gd6JTMpdbB9+rVqI+CJqxAl3nsI+wuGUVc+Dfly9bIpXKus
         q3anwNRDov3SFVxlT9IcSTXcfoZztKsq0itzV1Zko+FM63V0asiys1e2Eqh9p+g0KOrJ
         ZZEf2BPP/z2M7Z3sPDljAHyLK3Fnkmpy5jJuAp75SkiUHXvQVj2RBMt78h3UKBfDxUIJ
         lI1Ryrd4eGaA3bMeLlYk5qjatPF4QpDukbIsh3UNTx1VdE09Zhp2LkF40azRKlwQSdKf
         FIQA==
X-Gm-Message-State: AOJu0YxKBpV68D/YqeXSqAqFJJXqA60ruG375cAvwY3GqYE9sXZQo4vT
        YFLdtXu2mkv8tfG5fROh5Ne2N0bZRdk=
X-Google-Smtp-Source: AGHT+IHoZwdb50BuDO1GBJGpe37Vk3rYFlwIGjUSt10zlPfYLBRLPklAGj+P6MGJpoEk5843rkk6pA==
X-Received: by 2002:a17:902:e80a:b0:1c4:1e65:1e5e with SMTP id u10-20020a170902e80a00b001c41e651e5emr18063615plg.0.1696867538262;
        Mon, 09 Oct 2023 09:05:38 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id l13-20020a170902d34d00b001bb9f104328sm9793418plk.146.2023.10.09.09.05.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Oct 2023 09:05:38 -0700 (PDT)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, justin.tee@broadcom.com,
        Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 4/6] lpfc: Validate ELS LS_ACC completion payload
Date:   Mon,  9 Oct 2023 09:18:10 -0700
Message-Id: <20231009161812.97232-5-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20231009161812.97232-1-justintee8345@gmail.com>
References: <20231009161812.97232-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

A WCQE success completion status does not guarantee valid LS_ACC receipt
for ELS commands.  So, introduce a small helper routine that validates ELS
LS_ACC frames in ELS cmpl routines.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 54e47f268235..f9627eddab08 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -131,6 +131,15 @@ lpfc_els_chk_latt(struct lpfc_vport *vport)
 	return 1;
 }
 
+static bool lpfc_is_els_acc_rsp(struct lpfc_dmabuf *buf)
+{
+	struct fc_els_ls_acc *rsp = buf->virt;
+
+	if (rsp && rsp->la_cmd == ELS_LS_ACC)
+		return true;
+	return false;
+}
+
 /**
  * lpfc_prep_els_iocb - Allocate and prepare a lpfc iocb data structure
  * @vport: pointer to a host virtual N_Port data structure.
@@ -1107,6 +1116,8 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	prsp = list_get_first(&pcmd->list, struct lpfc_dmabuf, list);
 	if (!prsp)
 		goto out;
+	if (!lpfc_is_els_acc_rsp(prsp))
+		goto out;
 	sp = prsp->virt + sizeof(uint32_t);
 
 	/* FLOGI completes successfully */
@@ -2119,6 +2130,10 @@ lpfc_cmpl_els_plogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		/* Good status, call state machine */
 		prsp = list_entry(cmdiocb->cmd_dmabuf->list.next,
 				  struct lpfc_dmabuf, list);
+		if (!prsp)
+			goto out;
+		if (!lpfc_is_els_acc_rsp(prsp))
+			goto out;
 		ndlp = lpfc_plogi_confirm_nport(phba, prsp->virt, ndlp);
 
 		sp = (struct serv_parm *)((u8 *)prsp->virt +
@@ -3445,6 +3460,8 @@ lpfc_cmpl_els_disc_cmd(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		prdf = (struct lpfc_els_rdf_rsp *)prsp->virt;
 		if (!prdf)
 			goto out;
+		if (!lpfc_is_els_acc_rsp(prsp))
+			goto out;
 
 		for (i = 0; i < ELS_RDF_REG_TAG_CNT &&
 			    i < be32_to_cpu(prdf->reg_d1.reg_desc.count); i++)
@@ -4043,6 +4060,9 @@ lpfc_cmpl_els_edc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			edc_rsp->acc_hdr.la_cmd,
 			be32_to_cpu(edc_rsp->desc_list_len));
 
+	if (!lpfc_is_els_acc_rsp(prsp))
+		goto out;
+
 	/*
 	 * Payload length in bytes is the response descriptor list
 	 * length minus the 12 bytes of Link Service Request
@@ -11339,6 +11359,9 @@ lpfc_cmpl_els_fdisc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	prsp = list_get_first(&pcmd->list, struct lpfc_dmabuf, list);
 	if (!prsp)
 		goto out;
+	if (!lpfc_is_els_acc_rsp(prsp))
+		goto out;
+
 	sp = prsp->virt + sizeof(uint32_t);
 	fabric_param_changed = lpfc_check_clean_addr_bit(vport, sp);
 	memcpy(&vport->fabric_portname, &sp->portName,
-- 
2.38.0


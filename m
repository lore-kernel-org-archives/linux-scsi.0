Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02C61C4332F
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Nov 2022 18:37:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231509AbiKHShA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Nov 2022 13:37:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231535AbiKHSg5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Nov 2022 13:36:57 -0500
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E830E4FFBE
        for <linux-scsi@vger.kernel.org>; Tue,  8 Nov 2022 10:36:54 -0800 (PST)
Received: by mail-qt1-x82c.google.com with SMTP id s4so9159459qtx.6
        for <linux-scsi@vger.kernel.org>; Tue, 08 Nov 2022 10:36:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XfKGQ6tkV2EHrD93bGwJXjE+fCbML8I53FC3zQiNvIM=;
        b=YHqvfkkRDzXUMvugbQLlDDj/wM6nksU5zQTcjaz2P7tGTqnzS3+NUQ1jXJDbKswIQY
         cFBJlSr6Gh5wiSHu1ab17WdQb1MKOm2GzL1G4YzDd7oVRZ08ULG+hwhtQu5a3EJIsmKy
         OaCfUcCSLpH0N9jzexxCm4q6E80yS8FElPJPE8R8RxpDRIZIX3NTY38TzSOxKwoXr5gL
         uMiX4+JNUSMxLBUlgSs+K+AVe19W4qrxyPbsrFm4UqJmS7Ok7ED8qNTQY5JNqmHmjYbZ
         fx0vZhGYufFaSo/XA200TYV8P9cUo3tn2tgzKilvw5rk0j2HLxEjYyUOcHmIO9z48OOo
         qSxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XfKGQ6tkV2EHrD93bGwJXjE+fCbML8I53FC3zQiNvIM=;
        b=tZfS49/9sScms+Wlnx+NqFVKEbgXUZrag7Z9TM5QhyLLgq9bMLNeZKDe2HdrSW0y00
         91EOSirheJHSFao9ItGg2+lluaMo1D+P7ceflPF/6l9pAFuRVoZD93+vR+KCflJm0ln6
         aU+1rvWzoSHexJam1qPOPw+5PNGNUjXKJRmuqffLYFhss7XaNk0yDM4xrBIRLfjbZd/r
         72+aMQNtTl2XIG11benL5+plqbgT9Jq2MWFjgr/Hyqlc1jpDJPvBe215hx1/Kmw5trQ6
         7r+jvfU7UzygDTNd3POkEg66GQpnofPtvxVduwzT/EWpbRXsh3NnwAbFoOSzT4PI79zE
         sWMw==
X-Gm-Message-State: ANoB5pkTmcfLXYBbC3s3DSS1V56tzUwShunNdOzWzR2JRxF9ptfOb4gc
        aJE63x88q3AUOARMUmJh9vKfumVrXkQ=
X-Google-Smtp-Source: AA0mqf7KprH01M+PRusa+xxKG0eT+4V2gSYNsnxj7TAqFfRJm40tDOyPUo20yWKwaRPF+mUFFn3tTA==
X-Received: by 2002:a05:622a:8004:b0:3a5:8a36:77b6 with SMTP id jr4-20020a05622a800400b003a58a3677b6mr9538800qtb.591.1667932613800;
        Tue, 08 Nov 2022 10:36:53 -0800 (PST)
Received: from mail-lvn-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id l21-20020a37f915000000b006fa9d101775sm9864423qkj.33.2022.11.08.10.36.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 10:36:52 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Colin Ian King <colin.i.king@gmail.com>
Subject: [PATCH v2] scsi: lpfc: remove redundant pointer lp
Date:   Tue,  8 Nov 2022 10:36:20 -0800
Message-Id: <20221108183620.93978-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From:   Colin Ian King <colin.i.king@gmail.com>

Pointer lp is being initialized and incremented but the result
is never read. The pointer is redundant and can be removed.

Once lp is removed, pcmd is not longer used. So removed pcmd as well

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>

---
lp removal by Colin left as is.
I added the pcmd mod on top of it.
---
 drivers/scsi/lpfc/lpfc_els.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 2b03210264bb..9326340d4226 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -9172,15 +9172,10 @@ static int
 lpfc_els_rcv_farpr(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 		   struct lpfc_nodelist  *ndlp)
 {
-	struct lpfc_dmabuf *pcmd;
-	uint32_t *lp;
 	uint32_t did;
 
 	did = get_job_els_rsp64_did(vport->phba, cmdiocb);
-	pcmd = cmdiocb->cmd_dmabuf;
-	lp = (uint32_t *)pcmd->virt;
 
-	lp++;
 	/* FARP-RSP received from DID <did> */
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
 			 "0600 FARP-RSP received from DID x%x\n", did);
-- 
2.35.3


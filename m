Return-Path: <SRS0=AwsL=WE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.3 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BF7CC433FF
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Aug 2019 01:35:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1106A21873
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Aug 2019 01:35:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TCdvOseK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730635AbfHHBfg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Aug 2019 21:35:36 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:38894 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730547AbfHHBff (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Aug 2019 21:35:35 -0400
Received: by mail-pg1-f193.google.com with SMTP id z14so5885027pga.5;
        Wed, 07 Aug 2019 18:35:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=XHTR5NSwh6qJEaM7kQMot3a3W/2ZoOK2f1AQRl8NIV8=;
        b=TCdvOseK31vtX0p79HT9maPmO35WTcRU30DN2pyeKWQQ3nmlByXEvh1eRlKTTjmkxJ
         rGsii1qk5NomZARlMT2TYwrtYX8y+7W2qiMZaaRpjm0lPASW5//wmiB1u7RLe48AkIx8
         i9NHhQQMK1U0kUE8ZnINwXMT+7f1NjIqKKqJXg2cGcv59fqib+M73FkpuLhd7GwJ19/E
         GdaXwqK34ZEW9bevXmGccgM253b8H5klFTE36BPaOJbGUhGT0gOBnrPPla/V8aDMUGxR
         /TV2A+FbQPkZgh2msNjj23aA4d1JvvHdkvPMNvRePbgO1BbF6RdCLkcUzqEJFNIZJkGg
         qpvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=XHTR5NSwh6qJEaM7kQMot3a3W/2ZoOK2f1AQRl8NIV8=;
        b=LkvTjaYNFdM/xvQgf/Qshq0QMigRGXkhRk/bhUMPDylBq8zKzwImy182lDgidttIGi
         PSucuMjYksJ6rawYn9eOYR3T5ZzorNyLzsHKUV6Ja00GfN7AOFNmBoQ82KRJ7mInZ84G
         xRqAInJhoK/m/oRV017J/W7m33dGCEQHUhN2GXCZz7urSOFZMyFGWxKAKt4MHB2A9BYA
         7EY4Jw4y4RGfnJan7K0t9eoXNQS/KYuqFrpwhL4nGxINiR/0iN8uqUBoZHw7TCoCfssO
         upD/bCPN9/Hx51Vp8v6Tk4kgMZN4Fd8PTTOhZn+INDB5APf/ecSm68Gb6l3+65q8TCei
         6iUw==
X-Gm-Message-State: APjAAAUgXwLM9TS3vz+zB6n8cGg7TvmyyPm11msYF8uj+cbmQyyn048H
        gKKRcJrNIehH8WMNpKHX0Oo=
X-Google-Smtp-Source: APXvYqyJs7OgkOhs8pdDx2fVACEnIZ6CsFLm3EF0WdMYGn6M8JxvRhVae6ZLtGRimHLQrFiV1FCfZg==
X-Received: by 2002:a17:90a:bb94:: with SMTP id v20mr1368420pjr.88.1565228134994;
        Wed, 07 Aug 2019 18:35:34 -0700 (PDT)
Received: from hfq-skylake.ipads-lab.se.sjtu.edu.cn ([202.120.40.82])
        by smtp.googlemail.com with ESMTPSA id g66sm90979523pfb.44.2019.08.07.18.35.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Aug 2019 18:35:34 -0700 (PDT)
From:   Fuqian Huang <huangfq.daxian@gmail.com>
Cc:     James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fuqian Huang <huangfq.daxian@gmail.com>
Subject: [PATCH] scsi: lpfc: remove redundant code
Date:   Thu,  8 Aug 2019 09:35:25 +0800
Message-Id: <20190808013525.13681-1-huangfq.daxian@gmail.com>
X-Mailer: git-send-email 2.11.0
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20190808013525.qTcAPjTyptUX1TX-lX-F9Q9r5BIyft2w0Esnv3ZUKUg@z>

Remove the redundant initialization code.

Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>
---
 drivers/scsi/lpfc/lpfc_bsg.c | 1 -
 drivers/scsi/lpfc/lpfc_sli.c | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index b7216d694bff..5f66a2da2599 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -1571,7 +1571,6 @@ lpfc_issue_ct_rsp(struct lpfc_hba *phba, struct bsg_job *job, uint32_t tag,
 		"2722 Xmit CT response on exchange x%x Data: x%x x%x x%x\n",
 		icmd->ulpContext, icmd->ulpIoTag, tag, phba->link_state);
 
-	ctiocb->iocb_cmpl = NULL;
 	ctiocb->iocb_flag |= LPFC_IO_LIBDFC;
 	ctiocb->vport = phba->pport;
 	ctiocb->context1 = dd_data;
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index f9e6a135d656..156224c14cc7 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -17445,7 +17445,6 @@ lpfc_sli4_seq_abort_rsp(struct lpfc_vport *vport,
 	icmd->ulpContext = phba->sli4_hba.rpi_ids[ndlp->nlp_rpi];
 	ctiocb->context1 = lpfc_nlp_get(ndlp);
 
-	ctiocb->iocb_cmpl = NULL;
 	ctiocb->vport = phba->pport;
 	ctiocb->iocb_cmpl = lpfc_sli4_seq_abort_rsp_cmpl;
 	ctiocb->sli4_lxritag = NO_XRI;
-- 
2.11.0


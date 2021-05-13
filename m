Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9C57C433B4
	for <linux-scsi@archiver.kernel.org>; Thu, 13 May 2021 22:20:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6E526135A
	for <linux-scsi@archiver.kernel.org>; Thu, 13 May 2021 22:20:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232158AbhEMWVs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 May 2021 18:21:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbhEMWVs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 May 2021 18:21:48 -0400
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A98AC061574;
        Thu, 13 May 2021 15:20:38 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id 69-20020a9d0a4b0000b02902ed42f141e1so14734360otg.2;
        Thu, 13 May 2021 15:20:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=GMlhfNe9OuK5ao6yNTyWd+dXsrsvlKaRxQzzWwVbZY0=;
        b=JBL/8+5PHkRqgu5c5u1z1TkHfb3t2YSFXgQ7Wfx+qgFBEe+RYcy1BfwOu9U4vlQneN
         OENSbd+nYkwH1e6/HtvWTAn12C/l/JPPBPK7SX2bbsGVXMoWmXni927qlqTl51anXs7V
         zHCQH4XX6m5lOIi9/jna8SZ/gSiQmhFGuQVSvAlDKW5A7i8G6PrWgnObBIrrlA3XhTOj
         wXiuFdvxdx6NvrslK6QQh5IsQC2A1ij65452D7bB9wDzW9m68Kw906KBJqzvmGSuNU2x
         v87sYfNrFLJocZA65xwpgTFAo2IqPd8VVh4xJvp2R4ytkMc2z5jnB+uOi3aW8m12KCrj
         93kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=GMlhfNe9OuK5ao6yNTyWd+dXsrsvlKaRxQzzWwVbZY0=;
        b=iSLkKvibUUMxhd0luLwYUVcZdYzB+iDsRXzROAT3xslH+qqz8KeHu0LBDVgh5Cw4RY
         K4n0yMO9ZDb/umJrATWt/ElYFwleIfPW0xw8QGb5Gc8phpElhFgFhzaKP7ZlwxmI0sFq
         7LECcT18oCz67qFe80rAR24TvJIGrOUbRUaJCf90zquoQTVoPFrjIYTiv2rFAuubcfxn
         ZPXmlFaTW4q6mF1bGCNTDmyJasGfN/XXsARf0nylkZy8C0U5GjOkHS/Y7jbjijKpX2/R
         rjUY6H3iOtSO6YspiSWGxoqH1d8SBTiWwUKeIP20ZYlnToqTDOBybDMS2DHhsN8kySu/
         FP0Q==
X-Gm-Message-State: AOAM532IzSWyKrEhf/IDcXUNeA43l1VRADH+JGGFNlpVgXRODq0BFoKh
        lJ/Q+oxyGarPKollstCzS4k=
X-Google-Smtp-Source: ABdhPJyeP0ycuKUPi1unlzcjxlwKUQneE52uRLAmNXPfIrF3EEZ1dDKHQZhMWLiQMFutUkL2S5/l4Q==
X-Received: by 2002:a9d:470e:: with SMTP id a14mr3089427otf.236.1620944436883;
        Thu, 13 May 2021 15:20:36 -0700 (PDT)
Received: from fedora ([187.252.198.239])
        by smtp.gmail.com with ESMTPSA id 7sm928066oti.30.2021.05.13.15.20.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 15:20:36 -0700 (PDT)
Date:   Thu, 13 May 2021 17:20:32 -0500
From:   Nigel Christian <nigel.l.christian@gmail.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc:     linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] scsi: be2iscsi: Remove redundant initialization
Message-ID: <YJ2mMHNqAgTNVVj+@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The nested for loop variables i and j in beiscsi_free_mem() are
initialized twice. The values outside of the loops are redundant
and can be removed. 

Addresses-Coverity: ("Unused value")
Signed-off-by: Nigel Christian <nigel.l.christian@gmail.com>
---
 drivers/scsi/be2iscsi/be_main.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 22cf7f4b8d8c..c15cc6c164d9 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -3858,8 +3858,6 @@ static void beiscsi_free_mem(struct beiscsi_hba *phba)
 	int i, j;
 
 	mem_descr = phba->init_mem;
-	i = 0;
-	j = 0;
 	for (i = 0; i < SE_MEM_MAX; i++) {
 		for (j = mem_descr->num_elements; j > 0; j--) {
 			dma_free_coherent(&phba->pcidev->dev,
-- 
2.31.1


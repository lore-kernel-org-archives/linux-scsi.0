Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED2BDC4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 31 Oct 2023 18:59:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234067AbjJaS7O (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 31 Oct 2023 14:59:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233231AbjJaS7O (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Oct 2023 14:59:14 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D8C5E6
        for <linux-scsi@vger.kernel.org>; Tue, 31 Oct 2023 11:59:12 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1cc703d2633so1011635ad.0
        for <linux-scsi@vger.kernel.org>; Tue, 31 Oct 2023 11:59:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698778751; x=1699383551; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nrT4bHXx1zsvU/xTx5lFQNU8eF2+RrfLfBhFNKJAd2Y=;
        b=itb6n2PzSc2gKhk1Zy4MnzY1c0u9KU6HN3cvL4oyEaZIVK7wMbsZBMDidcTQoICIaD
         5tNe7nWolSbKbMWQAdHmduZ9ImBQCzZnVIXepvfKGBEyIIsg05aFEiAnVGpyb4wtHfHx
         ZERRECn7Dvr/SU5aZNQrc7yEF3X6EiLhjuu4lAbegTYGM0jeCf6h6QVqdGddcKdgkK5e
         A9LDJ8xtgSVhACv3JxJernLw5aXyGjJWIQofGwpauVMNV7oq9b+b+XJePSgRHqSSuDTV
         FV2BwA0/THnBzyKBMGxjByaeZc3xKjpr3Gjsm3GVhU37ih5lIkm2YKX6ZLfUTklmow/O
         7v8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698778751; x=1699383551;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nrT4bHXx1zsvU/xTx5lFQNU8eF2+RrfLfBhFNKJAd2Y=;
        b=MTo1QiUXBxIAxOH5F1ssmA2Gt2BTIfWcBNpgEknD3DxglXSW+VrQhmwnLU+XswQNWH
         BsXlJlOC77vJr4ATZ+OQTG+CEMpNugTwRjo6AQTlX+g7LYLfcS32LYZL3x7jMU2M4jRe
         6jgtEPMe5rTEn0AZYKBRn5xazLyeMLdVkEZT2IYEmpuJhS36pXhnp1fWNtM35OmsIY0+
         wU0XawitUm6Z2NUTKh8rsFb1Shez6jDgz3uYaqDKGlGaWRdpU9Sm1lo6aW6lvyoYjMeB
         2/upHw4FLoiQVZIBC/NyuX8RuMiwfCsjJkAOvrayCxbJoQuAskxslFcGsR+RVuPDNkwe
         HgQQ==
X-Gm-Message-State: AOJu0YyhdGJ5FpMSvpZg5YMKkij8GE58+T7wR2XuUBul2DnQdwbuChGa
        R7exW6u7a97YdEgXbn4imCJHi5M+ZEg=
X-Google-Smtp-Source: AGHT+IG4EbG4oqgac7fFf7iOmsEjel/U1N/ofVEvlw9lTjGAXUC4GGJVJUghDabEcHGMzeZ4YOIqcw==
X-Received: by 2002:a17:902:f213:b0:1c4:1cd3:8062 with SMTP id m19-20020a170902f21300b001c41cd38062mr14098511plc.2.1698778751419;
        Tue, 31 Oct 2023 11:59:11 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id bh6-20020a170902a98600b001c9d6923e7dsm1628657plb.222.2023.10.31.11.59.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 31 Oct 2023 11:59:10 -0700 (PDT)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, justin.tee@broadcom.com,
        Justin Tee <justintee8345@gmail.com>,
        Dan Carpenter <dan.carpenter@linaro.org>
Subject: [PATCH 3/9] lpfc: Fix list_entry null check warning in lpfc_cmpl_els_plogi
Date:   Tue, 31 Oct 2023 12:12:18 -0700
Message-Id: <20231031191224.150862-4-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20231031191224.150862-1-justintee8345@gmail.com>
References: <20231031191224.150862-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Smatch called out a warning for null checking a ptr that is assigned by
list_entry.  list_entry does not return null and, if the list is empty,
can return an invalid ptr.  Thus, the !psrp check does not execute
properly.

 drivers/scsi/lpfc/lpfc_els.c:2133 lpfc_cmpl_els_plogi()
 warn: list_entry() does not return NULL 'prsp'

Replace list_entry with list_get_first, which does a list_empty check
before returning the first entry.

Fixes: a3c3c0a806f1 ("scsi: lpfc: Validate ELS LS_ACC completion payload")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/linux-scsi/01b7568f-4ab4-4d56-bfa6-9ecc5fc261fe@moroto.mountain/
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index f9627eddab08..0829fe6ddff8 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -2128,8 +2128,8 @@ lpfc_cmpl_els_plogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 						NLP_EVT_DEVICE_RM);
 	} else {
 		/* Good status, call state machine */
-		prsp = list_entry(cmdiocb->cmd_dmabuf->list.next,
-				  struct lpfc_dmabuf, list);
+		prsp = list_get_first(&cmdiocb->cmd_dmabuf->list,
+				      struct lpfc_dmabuf, list);
 		if (!prsp)
 			goto out;
 		if (!lpfc_is_els_acc_rsp(prsp))
-- 
2.38.0


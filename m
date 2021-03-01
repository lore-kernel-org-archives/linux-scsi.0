Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9C14C4361B
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 17:29:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB82B65265
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 17:29:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238486AbhCAR20 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Mar 2021 12:28:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238043AbhCARWE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Mar 2021 12:22:04 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A75AC061226
        for <linux-scsi@vger.kernel.org>; Mon,  1 Mar 2021 09:18:40 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id o6so12323325pjf.5
        for <linux-scsi@vger.kernel.org>; Mon, 01 Mar 2021 09:18:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IjUbAWwWhScaH7yKq5wxf6zMxzi8dszri+xAN4MOVgQ=;
        b=EFrmzOwrlLKq/FGkUbfWlWK7vL5Plerg1B+OzG86rpAn0vQLBJYSz9bVQN8rTO4fW8
         MM5rTHih5twLD3mAYvc4ZXHFJBfllUim4YoBYU2K3fW14ug1+So7tZKFW16JjeEJyYpj
         WNbYLf7u6sx/sFgvI1GXecE9qKR1ZE3FlfUq9L76gFPnkXO+rl2J93YJcL2ptcFKH5dW
         xOEXNsRecM4E9UN9PKFCtdZ0l7/NCuTdKpwphB9k3Vl9nLPVlc55jB+pGelkpLuxxVqj
         L4fSvZ9EkpqVT9O4us6HT+dfNCqy0mHFl2FG3jwnyrjvQkTuMwi5bHcOSdRL9CVlzRR6
         rIZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IjUbAWwWhScaH7yKq5wxf6zMxzi8dszri+xAN4MOVgQ=;
        b=cIIhEhkXtGyA6+axCI5yAfDD2eoW2JtXa9xWUaxrv+dr3yf4Tfq7TMoAFPC+QBE/sW
         z/ex9dJYDE81GfjGrItakMNwyapqIa7Yh8i7hoRWQJX3hqDEnhT36/+gCB2YpFDIFHKM
         ki5mwTtHHJ7z+tpTYeZhQKz3zAR/O0du2xMEsLIhuqOjFS/Qst6/lj11iiAtmguggRcI
         JysrHUJ8bNQ5e632ZESKZmOmVbaOu1YSva3sayiFom/UTI9NlktMaA+hFCfmaAQnU4aa
         mG8rCQlGygTiqfRVUnfC7bCUYJAmUHXalBLjUAiW0d3PsVMBuZdz/94/SEvBqeyixRqs
         JHBg==
X-Gm-Message-State: AOAM5336JLygiEoyEwOSGpT1Dsgt9kl2VynWOxs0ATnfd3HWB9ouGnJD
        AXqni36YoTN+9BvbiXpwP0liTLA0r2M=
X-Google-Smtp-Source: ABdhPJwFrR/EH3Y52kgmO/1vLpQMd4vtOozYsGofNbOhHheuSBejlCjFEThUVQeKTiTeVfMr5f+oUQ==
X-Received: by 2002:a17:902:c952:b029:e4:89ad:fae2 with SMTP id i18-20020a170902c952b02900e489adfae2mr11307004pla.14.1614619119705;
        Mon, 01 Mar 2021 09:18:39 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id t19sm10133602pgj.8.2021.03.01.09.18.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 09:18:39 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH v2 18/22] lpfc: Change wording of invalid pci reset log message
Date:   Mon,  1 Mar 2021 09:18:17 -0800
Message-Id: <20210301171821.3427-19-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210301171821.3427-1-jsmart2021@gmail.com>
References: <20210301171821.3427-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Message 8347 Invalid device found log message is logged when an LPe12000
adapter is installed.  The log message is supposed to indicate an
unsupported pci reset adapter rather than an invalid device.

Change the wording to: Incapable PCI reset device.

Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 97178b30074b..36c8e17553aa 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -5012,7 +5012,7 @@ lpfc_check_pci_resettable(struct lpfc_hba *phba)
 			break;
 		default:
 			lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-					"8347 Invalid device found: "
+					"8347 Incapable PCI reset device: "
 					"0x%04x\n", ptr->device);
 			return -EBADSLT;
 		}
-- 
2.26.2


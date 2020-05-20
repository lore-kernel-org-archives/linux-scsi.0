Return-Path: <SRS0=Yj8A=7C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 557ACC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 20 May 2020 18:59:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 369FE207D8
	for <linux-scsi@archiver.kernel.org>; Wed, 20 May 2020 18:59:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LMx+SdcV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbgETS7z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 May 2020 14:59:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726548AbgETS7y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 May 2020 14:59:54 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A78AC061A0E;
        Wed, 20 May 2020 11:59:53 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id u1so3487317wmn.3;
        Wed, 20 May 2020 11:59:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fnshiy6ihG9QhaGP6naqQpz00mp02JHtZheI8F1kYaM=;
        b=LMx+SdcVWNgrCI/SwL9uv/KpzlE4nNYpyDC/Qs7GCtcpfMqszET3vUOSHYZm+a7TsB
         kCrRw4lPadNsy8pHZ5KYrPz8pgw6MKPiE9HYHPivG4fHIEQty7nYzEwEvQqTZGd23ZHU
         mKHJf+EIof99d3ATX3LwiH5lc8Q65OyANQT6gDDp9HrefEI+p/uAIjmDUaZSUCifdB4H
         HLcK573YuYicChl3CkLBGuESoFktARC7HkR1uLhe5Irc/DlglckvI/CB+Ci5v0O8PKW2
         DWzaZtyWHa2VFVx5MOPi7U/rPyejQYbORcyQ1r8ktBdvcaOMuWN1z0873Vn8OnfbrTTy
         XTTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fnshiy6ihG9QhaGP6naqQpz00mp02JHtZheI8F1kYaM=;
        b=aGvYDm80CUft1kQZJ+9Xoc6rPrSb7WdgRUFZ2wFfG+FXj2H6toC558CEo67fPNW7+m
         Vm62WFswO7JXWSgtCgyYyvXaV8sCfDm9XA7ruWVIdJyast6Gw0fDQgTCM70gG8zF88X0
         BVYPKao2mMDGxxDX8pQW3U5RpnKT4KuOD+3mdp63b49t2RIgxaQ0ju3H97DRhSSf1+1N
         x7A1k8LNyQsQuFrMYSX+QRS6Su+9Xc+1WplbXiAm9deloZktIicMouvTRFfeGeM8O2Lq
         JSAwmYjvi6o4Kpp7LNrOqGwsebxK9PsUcceXr5WSSQoJS/vChlUZ7XVIO2wQr7/wPZFp
         +bAQ==
X-Gm-Message-State: AOAM531lLLZC8b9ZHEmNx+w+HDordXFMusnTZeZ4LzFvu1qG4E3+lcS3
        HkW8OxRXGXAu670HXhPOlC4=
X-Google-Smtp-Source: ABdhPJxTXt+BUKcH00voKpAxp/kIhKxbelcXyVkcM2PQ+e7817YIs0PeHaSR8i7UnQp3Yhugozz8pw==
X-Received: by 2002:a7b:c8d2:: with SMTP id f18mr5658325wml.174.1590001192003;
        Wed, 20 May 2020 11:59:52 -0700 (PDT)
Received: from localhost.localdomain.localdomain (ip68-5-85-189.oc.oc.cox.net. [68.5.85.189])
        by smtp.gmail.com with ESMTPSA id c19sm3896483wrb.89.2020.05.20.11.59.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 May 2020 11:59:51 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-nvme@lists.infradead.org
Cc:     linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org,
        paul.ely@broadcom.com, hare@suse.de, jejb@linux.ibm.com,
        axboe@kernel.dk, martin.petersen@oracle.com, hch@infradead.org,
        dan.carpenter@oracle.com, James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 3/3] lpfc: Fix return value in __lpfc_nvme_ls_abort
Date:   Wed, 20 May 2020 11:59:29 -0700
Message-Id: <20200520185929.48779-4-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200520185929.48779-1-jsmart2021@gmail.com>
References: <20200520185929.48779-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

A static checker reported the following issue:
  drivers/scsi/lpfc/lpfc_nvmet.c:1366 lpfc_nvmet_ls_abort()
  warn: 'ret' can be either negative or positive

The comment indicates a non-zero value indicates error in the
form of -Exxx, but the code is returning "1".

Fix the code to return -EINVAL to be compliant to comment.

Fixes: e96a22b0b7c2 ("lpfc: Refactor Send LS Abort support")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_nvme.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 21bbccf0dc31..b46ba70f78da 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -895,7 +895,7 @@ __lpfc_nvme_ls_abort(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_NVME_DISC | LOG_NVME_ABTS,
 			 "6213 NVMEx LS REQ Abort: Unable to locate req x%p\n",
 			 pnvme_lsreq);
-	return 1;
+	return -EINVAL;
 }
 
 static int
-- 
2.26.1


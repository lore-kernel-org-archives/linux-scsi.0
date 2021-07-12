Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 585B2C07E99
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jul 2021 22:31:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32DAA61206
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jul 2021 22:31:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230156AbhGLWej (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Jul 2021 18:34:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229931AbhGLWej (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Jul 2021 18:34:39 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 410FCC0613DD;
        Mon, 12 Jul 2021 15:31:49 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id ga14so22641144ejc.6;
        Mon, 12 Jul 2021 15:31:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=MGeh56W62eK1hUI+wy5/PVDZC2f+e5pmmh2hY+I14MU=;
        b=oJicI6Ljl/8N/RW0B4Eu9269AvWk4254+CzE0a4WGx5wtvY3E8Vx8EJ/MS/GhOxryQ
         NLttzDoJk9UgSGhzcr36D8fWlYHw97avl/GraTym/HIDBDk3Ne3/9AdJmuKsiDYAfxnl
         hSQCKahrdzclSvCNsxLVjD72H8cFWjr9XfO/AHK8ZuZyluccREAIEFvN9q7CiOS6rKTz
         XWLV1QLaa5rQjqQQf33rNkumMnnAbluFCQvw4NjnbYOtFuc4QzNfLdNRoGa+odXHTijW
         6EJtMzXhr02tur8eEcLWNwDEBipaENuJ61vNQv/MGcUHADyaupbyP1ClKhiVAL7hXWOI
         FXsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=MGeh56W62eK1hUI+wy5/PVDZC2f+e5pmmh2hY+I14MU=;
        b=c1o7dAjeGD7/GFUnmYUuWS9QWj8q/sevsZlDVHkWFytAuFg80CFqt2At+zpJiBb2q1
         bLCd7SzkLaLpAE6vdPodAo842rIsHlwdZTNQg9C/0y6qbQScalhLv9zWqhcF2PKGTMSo
         KZNYPHIBc1q+REt6K8lY/vYfapPZFK/AytUlnSIVXd3aoWa9dcUA1V8DVowXpAGZSNP5
         VsTW5LPfJc3kQ8GVBMLSixZzR27GNdbjFCYuVsokFT9yySyf4wxO/+DKkbN/aGtCgbLG
         6T/lB44qjxH3JsCTR1eggt4TBKX4KPpXaIKQGKKh/sOBGsLJ2/u2Dyd1J9glaufvWZnV
         UjvQ==
X-Gm-Message-State: AOAM531PiUFyALwrDi8IIr9kHcrj/1WITTI9vCWV+MXXMqn2F2aZ6w1c
        bB/cDzBaxE3FLDJZ3QdiYys=
X-Google-Smtp-Source: ABdhPJxAQ65E7/Z1XJF0zPj61Opgml2i+SdNLtYbIuP+q5zDubFfPAKIAuP4LC4zfXEL7VmByDDpLw==
X-Received: by 2002:a17:907:1c9f:: with SMTP id nb31mr1579177ejc.342.1626129107896;
        Mon, 12 Jul 2021 15:31:47 -0700 (PDT)
Received: from pc ([196.235.212.194])
        by smtp.gmail.com with ESMTPSA id z10sm2560398ejg.3.2021.07.12.15.31.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 15:31:47 -0700 (PDT)
Date:   Mon, 12 Jul 2021 23:31:44 +0100
From:   Salah Triki <salah.triki@gmail.com>
To:     aacraid@microsemi.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] replace if with max()
Message-ID: <20210712223144.GA1829295@pc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Replace if with max() in order to make code more clean.

Signed-off-by: Salah Triki <salah.triki@gmail.com>
---
 drivers/scsi/aacraid/aachba.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index 46b8dffce2dd..330224f08fd3 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -485,8 +485,8 @@ int aac_get_containers(struct aac_dev *dev)
 	if (status != -ERESTARTSYS)
 		aac_fib_free(fibptr);
 
-	if (maximum_num_containers < MAXIMUM_NUM_CONTAINERS)
-		maximum_num_containers = MAXIMUM_NUM_CONTAINERS;
+	maximum_num_containers = max(maximum_num_containers, MAXIMUM_NUM_CONTAINERS);
+
 	if (dev->fsa_dev == NULL ||
 		dev->maximum_num_containers != maximum_num_containers) {
 
-- 
2.25.1


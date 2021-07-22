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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2964AC6377D
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 17:32:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01F96611C1
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 17:32:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbhGVQvn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Jul 2021 12:51:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbhGVQvm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Jul 2021 12:51:42 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0567BC061575;
        Thu, 22 Jul 2021 10:32:17 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id a80-20020a1c98530000b0290245467f26a4so123485wme.0;
        Thu, 22 Jul 2021 10:32:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=MGeh56W62eK1hUI+wy5/PVDZC2f+e5pmmh2hY+I14MU=;
        b=G2MfvDi+mldKJYf+TVgjnyifVOvpHLgB2k53AwkYamHiyXHmTyDKLFUqTs5h+Rjgih
         Ta6rD4sn6WlPpTiVGr7NRzzwluKUNaKFLMwQHO8BP1xvmOOPPsP7oL4EToNgTigVtjF6
         mmy94+NOd83orVDahHQ5/jcHeU2R7B4DqwkryrTjhk4e9HFWcLwRmvtVjENy+OGu9eQ4
         kgB+g09tUj9vLVXf7wtakZ0MoN+Uz0ykHlaJBRciwVVg1mlbGQUS2DS8yozi3cMervOV
         /HB9T2CvTlmxOAZsvAg/yLU20bdjjFSGHgUGkU+vn0098j6JuiUzqYMzgbQgPoqyO5Ej
         fjIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=MGeh56W62eK1hUI+wy5/PVDZC2f+e5pmmh2hY+I14MU=;
        b=pNz/34ccGFEbSMTdJtE1hDzPqBgEfFtnti0p/KweBd+5ub9PO5Uep+iYOWlRhg4qHc
         WhvJk8wq0Udz+0zDTsfvAV2nLg8hDNPUdVR9LvU8RlHREIIOr2ed2jg80J2s+v1Rt36x
         FAAxQX3i2J2CqBuznfd5Qe935tyOidK3iM9wtniP4dlXvIPLHdF1TYlU6/IX3+yMNRFF
         VjhbBxo5qM60RTXWW80207F7zcoDYObi3GprZ3FWo85HWj+wSQKHFx1R17QbIDF/Gd3Q
         TF1qvcqHAizR8GREPKzeuCsPSprqH1H+8NqoyUKRsRgA3j+b2GSyqTCGS9vPW/P+TI7S
         29oQ==
X-Gm-Message-State: AOAM530m8IhcFxmYg8b8hwTopIFzsGg/SnbJTTq0iaGb16wJPtxefD4X
        YWZtYprqZIG8w+zKubLv/yE=
X-Google-Smtp-Source: ABdhPJzPAk/FJIkSAcuG4mS2521g3bfenS4eHybiHNRXIWhmRNWD/n8ikjjB4Hf45Zzdb+Yj3blavw==
X-Received: by 2002:a7b:c041:: with SMTP id u1mr636335wmc.95.1626975135612;
        Thu, 22 Jul 2021 10:32:15 -0700 (PDT)
Received: from pc ([196.235.233.206])
        by smtp.gmail.com with ESMTPSA id z17sm17018074wrr.35.2021.07.22.10.32.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jul 2021 10:32:15 -0700 (PDT)
Date:   Thu, 22 Jul 2021 18:32:12 +0100
From:   Salah Triki <salah.triki@gmail.com>
To:     aacraid@microsemi.com, "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        gregkh@linuxfoundation.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RESEND] scsi: aacraid: aachba: replace if with max()
Message-ID: <20210722173212.GA5685@pc>
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


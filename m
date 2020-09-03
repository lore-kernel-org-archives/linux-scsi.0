Return-Path: <SRS0=xo/b=CM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B749C433E2
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 15:29:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 34BC92072A
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 15:29:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="uhYwIN2a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728566AbgICP3L (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Sep 2020 11:29:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728446AbgICP2r (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Sep 2020 11:28:47 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B7F1C061244;
        Thu,  3 Sep 2020 08:28:47 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id e11so5608034wme.0;
        Thu, 03 Sep 2020 08:28:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OnIkX7rxg+ctJcVWRv3lpkXGv5XLsLWj9CB5s4zIv08=;
        b=uhYwIN2a/HWgD4LA8wl/lOsUUfZSY2RS8+WxUiUiIlkV+gGpBf6uzgy70WXmgbtvcG
         CtZhcl85NHxBFKeovA8X5vLdh+ctFqTzUd5bDDuePtDMy1GfCV+5iG5kiTI5/CnM8qV9
         NM/vaEvQafotc00gBn//LqOzUQyOfFynXgTBvyAX5XMKDwjQlgejRLG9xZ7L0pa7OliY
         Sfvsa3Arxl66zBprfiAEQU1+I9FfM2ghAl+rKBLoMHZtawoaUlpTT+iJbK+Lw/rdVLSR
         F1zLsvUHycIQCfWHsg1bKYgFt1Dt/O6gA8wibHwxpDBoelpZture7QYbevKKp19tRyWO
         Xbkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OnIkX7rxg+ctJcVWRv3lpkXGv5XLsLWj9CB5s4zIv08=;
        b=geLN8UR04YC82zji+3KzhLwvwA2AkMmzyc/lSsh7E97Y26MfefYHMeNE+T3ecYMmCb
         ZM4Tc/w23wVMJAL90Lza1JS7Fo/GZ1R3e8hyDmiOKFQmM5DQHrxiJSyE5TydksCdE5Zg
         IGTmKGFppauLUZpaPEjfNZG8SQh4loskuwuaL1lyW/R3cyMf0OBoUUR9p3tZROQgrTPZ
         eghVVfU1F24yuevdZXZdSvL5GMdyE853dG7NEHoMFpPra7bKB0Cez7xxIK81HGZtWeb7
         gv0QlmRvVI0LeqJHYEjVG6kEbempHEV/XD3DhXP4KoaX/p4xM1BU3a961I0j6CmOoWPm
         cekw==
X-Gm-Message-State: AOAM531QF69MNegb/C9rUu1n3659xn5vmktUA7YlD0pAjOVImajEr8qL
        uGbdVbk4XuW818oEdj/18Tg=
X-Google-Smtp-Source: ABdhPJw6Oip3THDVYlyv7zwXpwOXFLZJr+401RI7fsrk9ZuaEexkdskyMvOJBrzvWXBxbkxq8BGopw==
X-Received: by 2002:a1c:3886:: with SMTP id f128mr3051184wma.121.1599146925667;
        Thu, 03 Sep 2020 08:28:45 -0700 (PDT)
Received: from localhost.localdomain (cpc83661-brig20-2-0-cust443.3-3.cable.virginm.net. [82.28.105.188])
        by smtp.gmail.com with ESMTPSA id 32sm5750210wrh.18.2020.09.03.08.28.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2020 08:28:45 -0700 (PDT)
From:   Alex Dewar <alex.dewar90@gmail.com>
Cc:     Alex Dewar <alex.dewar90@gmail.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH RFC 2/3] scsi: mpt: Replace a few uses of GFP_ATOMIC with GFP_KERNEL
Date:   Thu,  3 Sep 2020 16:28:31 +0100
Message-Id: <20200903152832.484908-3-alex.dewar90@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200903152832.484908-1-alex.dewar90@gmail.com>
References: <20200903152832.484908-1-alex.dewar90@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

None of the relevant functions are called from an atomic context, so
allocate memory with GFP_KERNEL to give a better chance of allocating
memory.

Signed-off-by: Alex Dewar <alex.dewar90@gmail.com>
---
 drivers/message/fusion/mptbase.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index b7136257b455..85fd9c3721ec 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -4254,14 +4254,14 @@ initChainBuffers(MPT_ADAPTER *ioc)
 	 */
 	if (ioc->ReqToChain == NULL) {
 		sz = ioc->req_depth * sizeof(int);
-		mem = kmalloc(sz, GFP_ATOMIC);
+		mem = kmalloc(sz, GFP_KERNEL);
 		if (mem == NULL)
 			return -1;
 
 		ioc->ReqToChain = (int *) mem;
 		dinitprintk(ioc, printk(MYIOC_s_DEBUG_FMT "ReqToChain alloc  @ %p, sz=%d bytes\n",
 			 	ioc->name, mem, sz));
-		mem = kmalloc(sz, GFP_ATOMIC);
+		mem = kmalloc(sz, GFP_KERNEL);
 		if (mem == NULL)
 			return -1;
 
@@ -4328,7 +4328,7 @@ initChainBuffers(MPT_ADAPTER *ioc)
 
 	sz = num_chain * sizeof(int);
 	if (ioc->ChainToChain == NULL) {
-		mem = kmalloc(sz, GFP_ATOMIC);
+		mem = kmalloc(sz, GFP_KERNEL);
 		if (mem == NULL)
 			return -1;
 
@@ -5283,7 +5283,7 @@ mpt_GetScsiPortSettings(MPT_ADAPTER *ioc, int portnum)
 		int	 sz;
 		u8	*mem;
 		sz = MPT_MAX_SCSI_DEVICES * sizeof(int);
-		mem = kmalloc(sz, GFP_ATOMIC);
+		mem = kmalloc(sz, GFP_KERNEL);
 		if (mem == NULL)
 			return -EFAULT;
 
-- 
2.28.0


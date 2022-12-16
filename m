Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E626AC4332F
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Dec 2022 10:31:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbiLPKbW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 16 Dec 2022 05:31:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbiLPKbV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Dec 2022 05:31:21 -0500
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ED74A9
        for <linux-scsi@vger.kernel.org>; Fri, 16 Dec 2022 02:31:20 -0800 (PST)
Received: by mail-lf1-x12f.google.com with SMTP id c1so2806396lfi.7
        for <linux-scsi@vger.kernel.org>; Fri, 16 Dec 2022 02:31:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bell-sw-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ujLcEs9OZfxXjj4LGeopcn3nQj+r8roHK6DbvG+ywu0=;
        b=kSUTaLL90Ia11hSaKByOUcrBlJHALRPJiWh6stR50HEcpjSQkK3MWWtxujJ/Y2kUZO
         9LbcPM5yAvcwynndf04lKvy5RRWojemK0xbskHrGD4ax0UqiI4+qOJX8P0t9mLRV3VPS
         QvzMJD/01q4rPw8CyIHy/8TCs3T+rT3YKgf7MnAzPt8sMYqwF1wz/oePhQlXk2u4VVtE
         CxqMiWOR8yIxAINp2cW0DAvzWBv1k3O0LPCcc3kCMrYeGjOk8l21JSl6wKC6D7PP5f6n
         ZV8jcUuVorkMSL/MkZgkoyso87bT+0XCcu7BWWZFWWmqQ3FkmJK/WWkm6O1GD63/2lib
         kBWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ujLcEs9OZfxXjj4LGeopcn3nQj+r8roHK6DbvG+ywu0=;
        b=2SQLsU/afYwaamRNCE5H7dZqzrRDVgK7Z1J9Lj81nGtoqc1HOXjOJBGUI1JRuxQC4f
         pTnAZYJv/Dm10nA5guIt8OQ1Kxy8kGZKFJcePh75uShPPd1EBQNe4XUnOZB5f2LiCHpz
         bs8si3LwLfaE35julvrTa04KAlw/QKeZVz9E1/pWJUcA7E2br0Ah35KnEDH2QeYHCzov
         ED4iIJts4KKHYc3R9QV8WTo4dGflT8mjJxorLH2UEYqHWFTyzq+yP+02gx/dpWImaS75
         KyxEYR682CShrN0NOf/vFeyPgLk/xc/3T5ZtkquakNs7pXQUV/JLupvmkkP2eL+IRmZk
         NBhQ==
X-Gm-Message-State: ANoB5pnRzEFYVzzJmuve8vLYxwzwGnvGvEdRdapq+pZkFTu3GG1ZtrmY
        6CAFY9ECiIKK6sy6H0D1G8Y4N0dcj9RDdao=
X-Google-Smtp-Source: AA0mqf4OSZbtItzojYkfU49CsDr2agq9fakGwrErwr2H++kZqrZ01Aum+fmIzcrPDz2Wuxbz9t10tQ==
X-Received: by 2002:a05:6512:487:b0:4b5:936e:69df with SMTP id v7-20020a056512048700b004b5936e69dfmr8433736lfq.53.1671186678383;
        Fri, 16 Dec 2022 02:31:18 -0800 (PST)
Received: from localhost.localdomain ([95.161.223.113])
        by smtp.gmail.com with ESMTPSA id e14-20020a05651236ce00b004b58500383bsm180164lfs.272.2022.12.16.02.31.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Dec 2022 02:31:16 -0800 (PST)
From:   Alexey Kodanev <aleksei.kodanev@bell-sw.com>
To:     linux-scsi@vger.kernel.org
Cc:     Alexey Kodanev <aleksei.kodanev@bell-sw.com>
Subject: [PATCH] scsi: fnic: drop unnecessary NULL check in is_fnic_fip_flogi_reject()
Date:   Fri, 16 Dec 2022 13:30:39 +0300
Message-Id: <20221216103039.202774-1-aleksei.kodanev@bell-sw.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

    if (desc->fip_dtype == FIP_DT_FLOGI) {
        ...
        els = (struct fip_encaps *)desc;
        fh = (struct fc_frame_header *)(els + 1);

'fh' can't be NULL here after shifting a valid pointer 'desc'.

Detected using the static analysis tool - Svace.
Signed-off-by: Alexey Kodanev <aleksei.kodanev@bell-sw.com>
---
 drivers/scsi/fnic/fnic_fcs.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_fcs.c b/drivers/scsi/fnic/fnic_fcs.c
index 79ddfaaf71a4..acf593467012 100644
--- a/drivers/scsi/fnic/fnic_fcs.c
+++ b/drivers/scsi/fnic/fnic_fcs.c
@@ -337,9 +337,6 @@ static inline int is_fnic_fip_flogi_reject(struct fcoe_ctlr *fip,
 		els = (struct fip_encaps *)desc;
 		fh = (struct fc_frame_header *)(els + 1);
 
-		if (!fh)
-			return 0;
-
 		/*
 		 * ELS command code, reason and explanation should be = Reject,
 		 * unsupported command and insufficient resource
-- 
2.25.1


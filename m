Return-Path: <SRS0=Zq1p=ZJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12B53C432C0
	for <linux-scsi@archiver.kernel.org>; Sun, 17 Nov 2019 18:14:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D223D2084C
	for <linux-scsi@archiver.kernel.org>; Sun, 17 Nov 2019 18:14:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=umn.edu header.i=@umn.edu header.b="YSAzwdKl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726069AbfKQSOl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 17 Nov 2019 13:14:41 -0500
Received: from mta-p7.oit.umn.edu ([134.84.196.207]:57716 "EHLO
        mta-p7.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726047AbfKQSOl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 17 Nov 2019 13:14:41 -0500
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Sun, 17 Nov 2019 13:14:40 EST
Received: from localhost (unknown [127.0.0.1])
        by mta-p7.oit.umn.edu (Postfix) with ESMTP id 5EDF3989
        for <linux-scsi@vger.kernel.org>; Sun, 17 Nov 2019 18:07:58 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p7.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p7.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id j1BBiKURF8kN for <linux-scsi@vger.kernel.org>;
        Sun, 17 Nov 2019 12:07:58 -0600 (CST)
Received: from mail-yb1-f197.google.com (mail-yb1-f197.google.com [209.85.219.197])
        (using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p7.oit.umn.edu (Postfix) with ESMTPS id 3484A1B3
        for <linux-scsi@vger.kernel.org>; Sun, 17 Nov 2019 12:07:58 -0600 (CST)
Received: by mail-yb1-f197.google.com with SMTP id 63so11809121ybv.11
        for <linux-scsi@vger.kernel.org>; Sun, 17 Nov 2019 10:07:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=rMpew6zjYt8BPuA5TZf/KmQkS9FbG3A+IGOU7KV/r/s=;
        b=YSAzwdKlPw8jVl+9ukfREsB6qTIq9HzlTnyIAkpxF5MZLdjE3vVJkhtRt1Ki6gfbgX
         nlnuj1bmxllbk7oSuG6eHo7sMUAjbNjwwXZmIXy9oy3fSor9X4Sdc8+qtJoWFAm+AQAG
         Fbib6TmCw+iyq6UnDx8HMQv1mIf0o5QIrRMyndcXkvykkfmeH+L8wk2kc/bSiud/YISm
         LmnJyRyGuwdD0hZDF3XpW3K7KL/n8RE1vaanwkHV5/rt9jEedJQJNFGnggEDazJ5DVSN
         XiZtcVVEvS/l03SsDpqpiD/o6yiiUkivEPeJHdYqN1CWc6MTsbilNvyQB99z+Db0/jku
         HQHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=rMpew6zjYt8BPuA5TZf/KmQkS9FbG3A+IGOU7KV/r/s=;
        b=FBDae+7saEKARSMT2qoSat589mug6rY1zgaLACLXQ3mzgX1IZ6Pm5xBsTKVP384Hlk
         /82SWQWyuoN9QDvtC7fEXas5s9jPWYOg8jQSigKjYMNnji1F+t/VWZ6PBrQeAfAv7zGp
         yvhSlhjC5RIpImc7LLEL6qPO8gQwVfvqLqbUw0HGRW5XBg6Z0tjG4g0BMIYzAcKNsZ+a
         nMLW1OswrOES5a0VHanjRefoqGgYuBNSTxJzYgD5hggxx7zVyA7uyLEOETim7rTHXrdp
         4dh9nd5CG3cUPnHzAQvxQ3oaQGRsxyoFOj3pVczSS7ZMW96bzGds/+QFQzn0tAflSR3z
         WQRg==
X-Gm-Message-State: APjAAAUVu/KisXoyQZDWpFmgN30P3DlByRJ7Z8ZqG+nWZrMlm42fsUsm
        y/qM0iG8R5NLuDSADN6LnLffBqhSeG05yd9j/2QjxV/MdTJui5OwDYOnhRHu4CrakZlyO/iYtcK
        tE+CstY8Qc69+QJdHtxm6Jn8+Gw==
X-Received: by 2002:a0d:e1c5:: with SMTP id k188mr17317123ywe.470.1574014077667;
        Sun, 17 Nov 2019 10:07:57 -0800 (PST)
X-Google-Smtp-Source: APXvYqz6mHLu72MhlrM+7cXvK++5H4c+YI4TXvAKytt9EKyUjBcaA4OHjW1IFsudo+oMSTzW8UfANA==
X-Received: by 2002:a0d:e1c5:: with SMTP id k188mr17317105ywe.470.1574014077419;
        Sun, 17 Nov 2019 10:07:57 -0800 (PST)
Received: from cs-u-syssec1.dtc.umn.edu (cs-u-syssec1.cs.umn.edu. [128.101.106.66])
        by smtp.gmail.com with ESMTPSA id l1sm8019506ywh.9.2019.11.17.10.07.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Nov 2019 10:07:57 -0800 (PST)
From:   Aditya Pakki <pakki001@umn.edu>
To:     pakki001@umn.edu
Cc:     kjlu@umn.edu, Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: megaraid_mbox: change the error level of crit to warning
Date:   Sun, 17 Nov 2019 12:07:52 -0600
Message-Id: <20191117180752.3974-1-pakki001@umn.edu>
X-Mailer: git-send-email 2.17.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In megaraid_alloc_cmd_packets(), incorrect mbox alignment and other
out of memory failures are processed similarly. The patch makes the
error logging consistent by replacing KERN_CRIT with KERN_WARNING.

Signed-off-by: Aditya Pakki <pakki001@umn.edu>
---
 drivers/scsi/megaraid/megaraid_mbox.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
index f6ac819e6e96..5595a7655c54 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -1046,7 +1046,7 @@ megaraid_alloc_cmd_packets(adapter_t *adapter)
 
 		// make sure the mailbox is aligned properly
 		if (ccb->mbox_dma_h & 0x0F) {
-			con_log(CL_ANN, (KERN_CRIT
+			con_log(CL_ANN, (KERN_WARNING
 				"megaraid mbox: not aligned on 16-bytes\n"));
 
 			goto out_teardown_dma_pools;
-- 
2.17.1


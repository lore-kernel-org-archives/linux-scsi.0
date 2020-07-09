Return-Path: <SRS0=/8H4=AU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13BA7C433DF
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 17:46:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E186B2078B
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 17:46:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="GYXOd0wu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728537AbgGIRqM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Jul 2020 13:46:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728511AbgGIRqK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jul 2020 13:46:10 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E62BBC08E806
        for <linux-scsi@vger.kernel.org>; Thu,  9 Jul 2020 10:46:09 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id b6so3271616wrs.11
        for <linux-scsi@vger.kernel.org>; Thu, 09 Jul 2020 10:46:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uh7jTGgLUvWvRRLhz59nl6r+4sZq+HqjUUSpbbMrHCY=;
        b=GYXOd0wuBdczRMDN8s4/gPG4FoikNnntxhvE9lW59BFIBaqDL0riZHtrvYndU5j0sb
         MI2Eo17OXvq3mZsgzVgUpaDeZUmsA1qmK7WYoNNLymEeFc8UiadW0tG9kPub/HdLK9Up
         FcmkaK6f/9m+tUGl0f05ctArSBCO03IfxgI3Baav58gqtvTkpBPq4MdCn8f6t64Nysok
         BvTJeWctmB4J1MVBxMatEZaZg7NNOuoQFlhkfaSdEdvWDF38eoUK22acWfs2H0dnTy+8
         aKnX049/CB9vBU2RrN7xEg4XbsL98iNbVo1TSCGUcheVpIuhOKz2TX1c96AGIBZQZ/Kc
         wIPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uh7jTGgLUvWvRRLhz59nl6r+4sZq+HqjUUSpbbMrHCY=;
        b=OjgfFhQ4qZURl6kzT9C5P0LKSbbM7R+7q67tFctUxZXtibpLL+66A13W7ovvpLlx3G
         iAIldTKXtRvL72IvWdB2oi+FIAwTWJxx4jD0wZUNqEkcEQz0sV2i5JO4XFx6NKY/mPGT
         JoZ2DYQqavUUAbQz4nD+fK5nrga1OkDvvh6pLaJLLAM9oljhuDGiJm0fnCkHuEjJdOiN
         DEeOaMc/LU1/RijXGsnjZAofFf8pTzXve/yLbfECdblpqz0CN4Rwnw1fV+m6GwIH2QJL
         uwdKvIwE//IZ6PGwblf3ANDTVrl+1jaDzWltAqrluMeAv+Q4Eubw6s+9VzDCT6F42oD8
         BHIQ==
X-Gm-Message-State: AOAM5336pLmigq+4FvC0f06Qx58kcvBb7bcmdTSFURwMq2+iIpI3aY6Y
        7Y58zvaYj/iSYcwsCgM1ff9oOw==
X-Google-Smtp-Source: ABdhPJxACLMpIJZt5g0hYREZmQbq3DJLBCYVgAeJEiXGAWTaTqUizXTHoI1c/Tx39b6IYs5ELoTGsw==
X-Received: by 2002:adf:dd83:: with SMTP id x3mr70095952wrl.292.1594316768677;
        Thu, 09 Jul 2020 10:46:08 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.206])
        by smtp.gmail.com with ESMTPSA id f15sm6063854wrx.91.2020.07.09.10.46.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2020 10:46:07 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "PMC-Sierra, Inc" <aacraid@pmc-sierra.com>
Subject: [PATCH 09/24] scsi: aacraid: rx: Fill in the very parameter descriptions for rx_sync_cmd()
Date:   Thu,  9 Jul 2020 18:45:41 +0100
Message-Id: <20200709174556.7651-10-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200709174556.7651-1-lee.jones@linaro.org>
References: <20200709174556.7651-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

... and document aac_rx_ioremap() 'dev' param.

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/aacraid/rx.c:156: warning: Function parameter or member 'p2' not described in 'rx_sync_cmd'
 drivers/scsi/aacraid/rx.c:156: warning: Function parameter or member 'p3' not described in 'rx_sync_cmd'
 drivers/scsi/aacraid/rx.c:156: warning: Function parameter or member 'p4' not described in 'rx_sync_cmd'
 drivers/scsi/aacraid/rx.c:156: warning: Function parameter or member 'p5' not described in 'rx_sync_cmd'
 drivers/scsi/aacraid/rx.c:156: warning: Function parameter or member 'p6' not described in 'rx_sync_cmd'
 drivers/scsi/aacraid/rx.c:156: warning: Function parameter or member 'status' not described in 'rx_sync_cmd'
 drivers/scsi/aacraid/rx.c:156: warning: Function parameter or member 'r1' not described in 'rx_sync_cmd'
 drivers/scsi/aacraid/rx.c:156: warning: Function parameter or member 'r2' not described in 'rx_sync_cmd'
 drivers/scsi/aacraid/rx.c:156: warning: Function parameter or member 'r3' not described in 'rx_sync_cmd'
 drivers/scsi/aacraid/rx.c:156: warning: Function parameter or member 'r4' not described in 'rx_sync_cmd'
 drivers/scsi/aacraid/rx.c:156: warning: Excess function parameter 'ret' description in 'rx_sync_cmd'
 drivers/scsi/aacraid/rx.c:450: warning: Function parameter or member 'dev' not described in 'aac_rx_ioremap'

Cc: Adaptec OEM Raid Solutions <aacraid@microsemi.com>
Cc: "PMC-Sierra, Inc" <aacraid@pmc-sierra.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/aacraid/rx.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/aacraid/rx.c b/drivers/scsi/aacraid/rx.c
index 3dea348bd25d2..cdccf9abcdc40 100644
--- a/drivers/scsi/aacraid/rx.c
+++ b/drivers/scsi/aacraid/rx.c
@@ -144,7 +144,16 @@ static void aac_rx_enable_interrupt_message(struct aac_dev *dev)
  *	@dev: Adapter
  *	@command: Command to execute
  *	@p1: first parameter
- *	@ret: adapter status
+ *	@p2: second parameter
+ *	@p3: third parameter
+ *	@p4: forth parameter
+ *	@p5: fifth parameter
+ *	@p6: sixth parameter
+ *	@status: adapter status
+ *	@r1: first return value
+ *	@r2: second return value
+ *	@r3: third return value
+ *	@r4: forth return value
  *
  *	This routine will send a synchronous command to the adapter and wait 
  *	for its	completion.
@@ -443,6 +452,7 @@ static int aac_rx_deliver_message(struct fib * fib)
 
 /**
  *	aac_rx_ioremap
+ *	@dev: adapter
  *	@size: mapping resize request
  *
  */
-- 
2.25.1


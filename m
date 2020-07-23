Return-Path: <SRS0=JunS=BC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F01B4C433E1
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jul 2020 12:26:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CAD30206D7
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jul 2020 12:26:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="JuFdS5y7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729010AbgGWMZX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Jul 2020 08:25:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728985AbgGWMZU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Jul 2020 08:25:20 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2675C0619DC
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2020 05:25:19 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id f7so4995154wrw.1
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2020 05:25:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=euKwHTd5nmGQirdNec0wmJhbD/rOPWNyEyTyNJ+qI+A=;
        b=JuFdS5y710xg7RFc7xoZiCn3DzeYwplfD9eeT3fvU2DpPlQMshxBMlcev/VDriTtJJ
         lKufu0zDWWI/ezb59IYeT/E+7wBz15on/r6th+k5L/Za/YFBwe9mI6wtT3PSaU+s2T4G
         myg2wIS9618YPDyhloZNL2Shbjd+1eEqJswxvbHS0/zjY7xN5toWF1RZNhmbgURGYfQx
         kw6ANS46TLW3b31RdSdoX6gKzbPQ0T0n4/1CWWeM9GPx31A5eNNnvRyK+AHP8ml3YamA
         6yAD7+vqbH+BOwdtHWk3Jbm36PhITyiTmBYNHVleZfKr/ZjjTHFRPNqhR1fS3xHhDtm/
         pvLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=euKwHTd5nmGQirdNec0wmJhbD/rOPWNyEyTyNJ+qI+A=;
        b=skdbGjxnmBZrqSzMGJahbDLyCl0zUs1qd0piR99LfWffVL2pOPJK3XF+phwH3QxlNl
         QRa0RL0qwALAApkfY+C3QH4Edwto/OzKdMO84H0u4kob49uvhmDaSJTL7p41O/jMDslV
         ZxBVWT4co65WDSejL2GHwJBnTpD/Y50Y8EPdnzzADo9SlcCdyU+I7Yx4EwEynaJwtrkK
         ai8ctxIziR8DGs4yPpeCOhF3TA18aNeG/QJ+A4FBtk+OMzMEaleAdIMVrAE9OIZjx7iM
         /RvsaPSIGWqjy7mGpbW9nShC6rhZ8GVz5K9FRzmpKiJC5PUEdGc8c3p+LMetzwtE5Wpg
         iPVQ==
X-Gm-Message-State: AOAM5316Y92LMYZaJL2xWyvK5sVeTLdum1FW5RP9frrfVFCGryBK6PO/
        lbOsUbi1/DtjORGz5PscyYtoUg==
X-Google-Smtp-Source: ABdhPJzSBVHJ88f6m8bQEuFIRyRwgvryu7g4a5wAFl3g7lEWHef74sdfGzIDj1FOc+h2tgj3hX3Itg==
X-Received: by 2002:adf:ec8b:: with SMTP id z11mr3736372wrn.51.1595507118682;
        Thu, 23 Jul 2020 05:25:18 -0700 (PDT)
Received: from localhost.localdomain ([2.27.167.73])
        by smtp.gmail.com with ESMTPSA id j5sm3510651wma.45.2020.07.23.05.25.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2020 05:25:18 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 24/40] scsi: csiostor: csio_rnode: Add missing description for csio_rnode_fwevt_handler()'s 'fwevt' param
Date:   Thu, 23 Jul 2020 13:24:30 +0100
Message-Id: <20200723122446.1329773-25-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200723122446.1329773-1-lee.jones@linaro.org>
References: <20200723122446.1329773-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/csiostor/csio_rnode.c:869: warning: Function parameter or member 'fwevt' not described in 'csio_rnode_fwevt_handler'

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/csiostor/csio_rnode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/csiostor/csio_rnode.c b/drivers/scsi/csiostor/csio_rnode.c
index e9c3b045f5875..713e13adf4dcc 100644
--- a/drivers/scsi/csiostor/csio_rnode.c
+++ b/drivers/scsi/csiostor/csio_rnode.c
@@ -862,7 +862,7 @@ csio_rnode_devloss_handler(struct csio_rnode *rn)
 /**
  * csio_rnode_fwevt_handler - Event handler for firmware rnode events.
  * @rn:		rnode
- *
+ * @fwevt:	firmware event to handle
  */
 void
 csio_rnode_fwevt_handler(struct csio_rnode *rn, uint8_t fwevt)
-- 
2.25.1


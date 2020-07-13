Return-Path: <SRS0=+RX4=AY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12A20C433E8
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 07:48:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E21072076D
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 07:48:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="NrLIaKrf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729027AbgGMHqy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jul 2020 03:46:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725818AbgGMHqx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jul 2020 03:46:53 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AD6CC08C5DF
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 00:46:53 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id 22so12326127wmg.1
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 00:46:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zj88WzcC8Hp115aJ2vlTY+pxEWRybRaihV1rme1nf/Q=;
        b=NrLIaKrfsALs500eqVYpgsTXCnYflEJf0bWehrQs5JqkPeaGMXY8hmZBUbXqoSUxZJ
         6gq7pJ9Vlqqs9yP6gIj+JmDIBW0wyEV86+7gZMzIK3E5PrsT8f2ga+lyg7MvuwzTwywJ
         vg66404HWx02HC5FGvbu4Q+jayo3Z3JM6Llq/Nsf/JftOx+Nf3qyjJ+5HMlQH6NXf0nT
         kbf0k1k1BOrtrv/k9im25OZn/Arpn+AJhSefVJ1250HFOAZ9zNfzOF0Q7kVIeL/omgSS
         uDdxRAENXmSU9ZSFW8c29IIAuNdoIOqfXa5xkGQYv73vd8sca/j9NXxTsBXF1rkjDIzP
         dTMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zj88WzcC8Hp115aJ2vlTY+pxEWRybRaihV1rme1nf/Q=;
        b=eeK2t3llv680P8pgQsMxJFvRI1+DIsHC8DpGs/bNM+M1QzoBtuWjN1v8wtP5dA19k3
         GPzoPQHcyIgeFKHLMaQpSh3kzJtn0+htbGvOzQ01i/0N82sNRqLSzae3FR0IXAnQc/Vk
         d5GhzBIyBkCClhdmyQB97q1bXftI4KdUkg75kNEmKWdXy6/h5BisY5aK3kaDFgpRZCDK
         iEB/6UAAytfAtqH8UepGRGNc1IergtyCrXwTYC/YejSUs3kvvXemgpySt0YKf5Zfn4Xl
         riKKSZAZ5lwiKvqFJvmh+A3g/4uyMjbJYBDwR2aVl8hkyaAW52cMX+g0Gx9H9MIFNjDC
         jgYA==
X-Gm-Message-State: AOAM531nSjQR+NF5QSNiK8qvLheMpDPl1tvIN4AYJ+tEORwl5WoWVjay
        7VRCx31fhRlmeuElPz69R+Jwcw==
X-Google-Smtp-Source: ABdhPJwhGrfFBxrN2i138O0/wK4hYr0wQdvW0/FJpEjLSG2gLA9lrrOoikudA3ahcEeO5O0pFIHlCQ==
X-Received: by 2002:a7b:cd07:: with SMTP id f7mr16879487wmj.115.1594626412253;
        Mon, 13 Jul 2020 00:46:52 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.6])
        by smtp.gmail.com with ESMTPSA id k11sm25142488wrd.23.2020.07.13.00.46.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 00:46:51 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH v2 04/29] scsi: fcoe: fcoe: Fix various kernel-doc infringements
Date:   Mon, 13 Jul 2020 08:46:20 +0100
Message-Id: <20200713074645.126138-5-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200713074645.126138-1-lee.jones@linaro.org>
References: <20200713074645.126138-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

A couple of headers make no attempt to document their associated function
parameters.  Others looks as if they are suffering with a little bitrot.

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/fcoe/fcoe.c:654: warning: Function parameter or member 'lport' not described in 'fcoe_netdev_features_change'
 drivers/scsi/fcoe/fcoe.c:654: warning: Function parameter or member 'netdev' not described in 'fcoe_netdev_features_change'
 drivers/scsi/fcoe/fcoe.c:2039: warning: Function parameter or member 'ctlr_dev' not described in 'fcoe_ctlr_mode'
 drivers/scsi/fcoe/fcoe.c:2039: warning: Excess function parameter 'cdev' description in 'fcoe_ctlr_mode'
 drivers/scsi/fcoe/fcoe.c:2144: warning: Function parameter or member 'fcoe' not described in 'fcoe_dcb_create'
 drivers/scsi/fcoe/fcoe.c:2144: warning: Excess function parameter 'netdev' description in 'fcoe_dcb_create'
 drivers/scsi/fcoe/fcoe.c:2144: warning: Excess function parameter 'port' description in 'fcoe_dcb_create'
 drivers/scsi/fcoe/fcoe.c:2627: warning: Function parameter or member 'lport' not described in 'fcoe_elsct_send'
 drivers/scsi/fcoe/fcoe.c:2627: warning: Function parameter or member 'did' not described in 'fcoe_elsct_send'
 drivers/scsi/fcoe/fcoe.c:2627: warning: Function parameter or member 'fp' not described in 'fcoe_elsct_send'
 drivers/scsi/fcoe/fcoe.c:2627: warning: Function parameter or member 'op' not described in 'fcoe_elsct_send'
 drivers/scsi/fcoe/fcoe.c:2627: warning: Function parameter or member 'resp' not described in 'fcoe_elsct_send'
 drivers/scsi/fcoe/fcoe.c:2627: warning: Function parameter or member 'arg' not described in 'fcoe_elsct_send'
 drivers/scsi/fcoe/fcoe.c:2627: warning: Function parameter or member 'timeout' not described in 'fcoe_elsct_send'

Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/fcoe/fcoe.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index cb41d166e0c0f..0f9274960dc6b 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -645,7 +645,7 @@ static int fcoe_lport_config(struct fc_lport *lport)
 	return 0;
 }
 
-/**
+/*
  * fcoe_netdev_features_change - Updates the lport's offload flags based
  * on the LLD netdev's FCoE feature flags
  */
@@ -2029,7 +2029,7 @@ static int fcoe_ctlr_enabled(struct fcoe_ctlr_device *cdev)
 
 /**
  * fcoe_ctlr_mode() - Switch FIP mode
- * @cdev: The FCoE Controller that is being modified
+ * @ctlr_dev: The FCoE Controller that is being modified
  *
  * When the FIP mode has been changed we need to update
  * the multicast addresses to ensure we get the correct
@@ -2136,9 +2136,7 @@ static bool fcoe_match(struct net_device *netdev)
 
 /**
  * fcoe_dcb_create() - Initialize DCB attributes and hooks
- * @netdev: The net_device object of the L2 link that should be queried
- * @port: The fcoe_port to bind FCoE APP priority with
- * @
+ * @fcoe:   The new FCoE interface
  */
 static void fcoe_dcb_create(struct fcoe_interface *fcoe)
 {
@@ -2609,7 +2607,7 @@ static void fcoe_logo_resp(struct fc_seq *seq, struct fc_frame *fp, void *arg)
 	fc_lport_logo_resp(seq, fp, lport);
 }
 
-/**
+/*
  * fcoe_elsct_send - FCoE specific ELS handler
  *
  * This does special case handling of FIP encapsualted ELS exchanges for FCoE,
-- 
2.25.1


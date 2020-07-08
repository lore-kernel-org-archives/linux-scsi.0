Return-Path: <SRS0=1cZD=AT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0410C433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 12:04:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F00220775
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 12:04:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="J5+Dp0He"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729196AbgGHMEn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jul 2020 08:04:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728637AbgGHMCd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jul 2020 08:02:33 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97DCBC08C5DC
        for <linux-scsi@vger.kernel.org>; Wed,  8 Jul 2020 05:02:31 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id z2so26408658wrp.2
        for <linux-scsi@vger.kernel.org>; Wed, 08 Jul 2020 05:02:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zj88WzcC8Hp115aJ2vlTY+pxEWRybRaihV1rme1nf/Q=;
        b=J5+Dp0HeyJVdvuXj8D7pcksR0L060RA13hVnHzmEuUSfmb+fExnpI95v2doAH5bgpM
         AerHZM65Y5A43lh6M1KxDXUEp7uKPcGChM5mNKuVi3J2s/d1jP9qF2+s6bEzGns8Gpbd
         Jmgw64cyc8ozeKeyLOd/7/FBN6QkujrHYgO05n3G7zRfFHGttwVLyAcKDQ529LKnV+3x
         BhFTJvTjrVfGMyRGZIzRGNg3ZHzByWbBxAmtupuVxhxMyhn+R5C6bbj7VYoBDPNzAJ9P
         TxkzDB4rciwtDU4q+WjZF/2KbEI/vScIQhTbz7KWw5oVcW1vCF4ORMZ6LQZA1UHiwD23
         atzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zj88WzcC8Hp115aJ2vlTY+pxEWRybRaihV1rme1nf/Q=;
        b=X4y+/6TPiPc4LjKujM0JVucolykGJ+pM7b/IS44T1y1Ce7xWC1dfDvcqkO5Fysgb2f
         +NGNYAX6HwO+VqBo/JGE1ZRk8bohYDhAPib4u6XYQHwW/RwBQMgqTDXTqMYiWWk8Mq/X
         eX6eKt3LNEYHOLzKI6daLni8FDOGhThVoIcqQ5i2TyDcPdC7Cu3iVCHlEG07ugsSCTjo
         GBkJ7GA2Bm3xV9FHbT1QSmGozZ9vfZP6p8bo2VNXtAEslpKa6vNO7Jg8J66jARIMo8Xf
         /mehlACNcCcxRnsNKYNeCyqsW7IFrO6TTfZbvEpiAj3lTPPrhnQsAbMG6H+2w9akKkuA
         rnZA==
X-Gm-Message-State: AOAM531u9Sr+b5QlL8czBf4Wlp01itlz9tW9mIo3fNbaHM+q7dVkzPKx
        l+KCmpSq6OJLy/q2tCGANCaQCA==
X-Google-Smtp-Source: ABdhPJzFvogyw5VWz9I19SIiKvctbL6YjQ+TmzjgqYE/dMgQrN6HrKQRPWUWFjUPI3aluSHxpvZBkA==
X-Received: by 2002:adf:82e1:: with SMTP id 88mr37661923wrc.376.1594209750242;
        Wed, 08 Jul 2020 05:02:30 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.206])
        by smtp.gmail.com with ESMTPSA id m62sm3964997wmm.42.2020.07.08.05.02.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 05:02:29 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 04/30] scsi: fcoe: fcoe: Fix various kernel-doc infringements
Date:   Wed,  8 Jul 2020 13:01:55 +0100
Message-Id: <20200708120221.3386672-5-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200708120221.3386672-1-lee.jones@linaro.org>
References: <20200708120221.3386672-1-lee.jones@linaro.org>
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


Return-Path: <SRS0=1cZD=AT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC53CC433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 12:04:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B01D020772
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 12:04:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="l3TBC6Ja"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729030AbgGHMEa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jul 2020 08:04:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729022AbgGHMCh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jul 2020 08:02:37 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78776C08C5DC
        for <linux-scsi@vger.kernel.org>; Wed,  8 Jul 2020 05:02:36 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id b6so48659899wrs.11
        for <linux-scsi@vger.kernel.org>; Wed, 08 Jul 2020 05:02:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=46IKHC7Ib+3RpYilksHo0J0tVnpqASiueOx9DpvscBA=;
        b=l3TBC6JaAs3Oj5T2ANAgmLhjgaFoSm80oROvJAm6eo+aJXW4c5H1FV+nwjp8n5QqOd
         dqM919EV90o7+ViXKxLMIJ8sIANeJnkGz3rSX2oVxho73Bdi3kpXbtgyuJn6TZHYl6OU
         ELwLqKf9lDeo3NMCDMwB8y6oUKob9loOnZGFcO8NNNvw/GA4SCDot7K84wmf7Rs3ZSj1
         OnQa+edYrzHvpoXDfrchTC6A5neZP4SFlhSdYPMLN/inQ5RsiVFDxS467VFD5gc9Zyec
         w5FHNoMNTJtToJA73nkBxmRy2EQcegrcyCGt2ZnSzB6Hj4F/K1hIimrXAz5EKsoPseaI
         zxLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=46IKHC7Ib+3RpYilksHo0J0tVnpqASiueOx9DpvscBA=;
        b=Mxs2X2xxweuoaridWCt/lKqkbiSPTzSxOB2vhjsVNFYleux+6cileIt9Nkipi5BRf7
         apWREz2uTr5yKgU+aYGGAUMzeq8fl19rFSqkLYpWwWa6z4ca0mhLyXUh7HjC0ceHbUYw
         XAk34q1rvAnKnAT4iQEJuzNb+ByTyCaXeATqKhDSe84TD9hhPkf5dQ9aM6kicgJMxDMz
         jY+cT68hB0XnOp2D0s/PLmIFIZ9VmYqkZscjpbv3SReaSRlrteZWTjw2Eb++HqDZEMXI
         AETuVu5W/CESCTixNyQ3wnwwvsPRQclyL9xDe1+uVJCvmYSt2UyXTKNIkzM5Qai13qEF
         7zkw==
X-Gm-Message-State: AOAM532sU7BLcqWdje+UsRUngghxV27mOoRuLQF0xu2r1jJLT1PzAQw1
        WonMlGLUeT5hWhWcoBnQ10kOX3/1qn4=
X-Google-Smtp-Source: ABdhPJx7400FkBTJjZF37J5652hYPclvA4b+wU9dUR9dX0IU/91BKTSabo6ymiYYSVoXlFRmC05wxw==
X-Received: by 2002:adf:e948:: with SMTP id m8mr59727341wrn.398.1594209755159;
        Wed, 08 Jul 2020 05:02:35 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.206])
        by smtp.gmail.com with ESMTPSA id m62sm3964997wmm.42.2020.07.08.05.02.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 05:02:34 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        QLogic-Storage-Upstream@qlogic.com,
        Prakash Gollapudi <bprakash@broadcom.com>
Subject: [PATCH 07/30] scsi: bnx2fc: bnx2fc_fcoe: Repair a range of kerneldoc issues
Date:   Wed,  8 Jul 2020 13:01:58 +0100
Message-Id: <20200708120221.3386672-8-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200708120221.3386672-1-lee.jones@linaro.org>
References: <20200708120221.3386672-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From bitrotted and missing function parameters to misuse of kerneldoc format.

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/bnx2fc/bnx2fc_fcoe.c:1082: warning: Function parameter or member 'lport' not described in 'bnx2fc_update_src_mac'
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c:1082: warning: Function parameter or member 'addr' not described in 'bnx2fc_update_src_mac'
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c:1082: warning: Excess function parameter 'fip' description in 'bnx2fc_update_src_mac'
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c:1082: warning: Excess function parameter 'old' description in 'bnx2fc_update_src_mac'
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c:1082: warning: Excess function parameter 'new' description in 'bnx2fc_update_src_mac'
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c:1670: warning: Function parameter or member 'netdev' not described in 'bnx2fc_destroy'
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c:1670: warning: Excess function parameter 'buffer' description in 'bnx2fc_destroy'
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c:1670: warning: Excess function parameter 'kp' description in 'bnx2fc_destroy'
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c:2108: warning: Function parameter or member 'netdev' not described in 'bnx2fc_disable'
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c:2236: warning: Function parameter or member 'netdev' not described in 'bnx2fc_enable'
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c:2529: warning: Function parameter or member 'dev' not described in 'bnx2fc_ulp_exit'
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c:2962: warning: cannot understand function prototype: 'struct scsi_host_template bnx2fc_shost_template = '
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c:2996: warning: cannot understand function prototype: 'struct cnic_ulp_ops bnx2fc_cnic_cb = '

Cc: QLogic-Storage-Upstream@qlogic.com
Cc: Prakash Gollapudi <bprakash@broadcom.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 0e33324e16f51..5cdeeb3539fdc 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -1071,9 +1071,8 @@ static int bnx2fc_fip_recv(struct sk_buff *skb, struct net_device *dev,
 /**
  * bnx2fc_update_src_mac - Update Ethernet MAC filters.
  *
- * @fip: FCoE controller.
- * @old: Unicast MAC address to delete if the MAC is non-zero.
- * @new: Unicast MAC address to add.
+ * @lport: The local port
+ * @addr: Location of data to copy
  *
  * Remove any previously-set unicast MAC filter.
  * Add secondary FCoE MAC address filter for our OUI.
@@ -1659,8 +1658,7 @@ static void __bnx2fc_destroy(struct bnx2fc_interface *interface)
 /**
  * bnx2fc_destroy - Destroy a bnx2fc FCoE interface
  *
- * @buffer: The name of the Ethernet interface to be destroyed
- * @kp:     The associated kernel parameter
+ * @netdev: The net device that the FCoE interface is on
  *
  * Called from sysfs.
  *
@@ -2101,7 +2099,7 @@ static int __bnx2fc_disable(struct fcoe_ctlr *ctlr)
 	return 0;
 }
 
-/**
+/*
  * Deperecated: Use bnx2fc_enabled()
  */
 static int bnx2fc_disable(struct net_device *netdev)
@@ -2229,7 +2227,7 @@ static int __bnx2fc_enable(struct fcoe_ctlr *ctlr)
 	return 0;
 }
 
-/**
+/*
  * Deprecated: Use bnx2fc_enabled()
  */
 static int bnx2fc_enable(struct net_device *netdev)
@@ -2523,7 +2521,7 @@ static struct bnx2fc_hba *bnx2fc_hba_lookup(struct net_device
 /**
  * bnx2fc_ulp_exit - shuts down adapter instance and frees all resources
  *
- * @dev		cnic device handle
+ * @dev:	cnic device handle
  */
 static void bnx2fc_ulp_exit(struct cnic_dev *dev)
 {
@@ -2956,7 +2954,7 @@ static struct device_attribute *bnx2fc_host_attrs[] = {
 	NULL,
 };
 
-/**
+/*
  * scsi_host_template structure used while registering with SCSI-ml
  */
 static struct scsi_host_template bnx2fc_shost_template = {
@@ -2989,7 +2987,7 @@ static struct libfc_function_template bnx2fc_libfc_fcn_templ = {
 	.rport_event_callback	= bnx2fc_rport_event_handler,
 };
 
-/**
+/*
  * bnx2fc_cnic_cb - global template of bnx2fc - cnic driver interface
  *			structure carrying callback function pointers
  */
-- 
2.25.1


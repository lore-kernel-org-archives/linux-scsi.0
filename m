Return-Path: <SRS0=+RX4=AY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B6D3C433E5
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 07:47:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4935220674
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 07:47:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="UT/KqFlQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729127AbgGMHq7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jul 2020 03:46:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728968AbgGMHq5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jul 2020 03:46:57 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58927C08C5DF
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 00:46:56 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id q5so14681367wru.6
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 00:46:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=46IKHC7Ib+3RpYilksHo0J0tVnpqASiueOx9DpvscBA=;
        b=UT/KqFlQctUmY/pNcFBEOafFqDtMcA7/9vkx7Wqrs7RRk0llnbIkGAqXk9sEnMJ00g
         SMB9lfqGksTUMxUCcokmxIiS9cDznVvrBWKPA348XvPktO7L56fBxGIq+DANwobtrLSy
         DqgVKR9o6ivlPGAMkamBRupiWUk1D70rz0j2SQ0QkbvTq5kbPdY3gzyHnxUNPvELZ1Aw
         6NNUuJpKjmf5QkST0ElUelDarLnSdsoh2y6ecJiozSvH7dDLLbQcL3WmwFOwOHlH3VRK
         rd0NN0DVlEAHLbBhwSErui5TBNN+k7jzscvFEEf+EZ/f+cNXYgbhqHtZZ+J1V6Lf8dE/
         V7HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=46IKHC7Ib+3RpYilksHo0J0tVnpqASiueOx9DpvscBA=;
        b=WURlv2NcmbPpNVVT8MPKPY0+vbcBN991utIepDPplg6ZDmSM3bhTVw5N9DtqUxclkB
         dhVJl3K66KgWKs4NqkKyEYy/bNNYgKkiEuWJTLEi0L/8hofTSKVJqRBla41sBbHkC+Hw
         u6JNXl0BGLIHS7a/YoL2IZvc2v2kKrDPUVavjfWKN2CLWhomvBuCQVa/ZwTLioa7M8Yj
         K49WPRJSqbyq6+Wd9ISri7ba6LvZ8eqO2clQoSO13+K3oKSGn2Dg5TLmY7SyBO9iKOQE
         Uehkz5wIgc9brzXY8d9vtjLZjbELHzthmHf1+lYkpFB/PmiLQNbMMB9PVWCNyevYywz7
         0P/Q==
X-Gm-Message-State: AOAM532FOFUK6Z1bBUQo/KQkPVOddJtyY9pD2MEkuhAoJm5vgOOKVeNZ
        zVCybtzYL/SQzbcr9n2WrUPoHw==
X-Google-Smtp-Source: ABdhPJxZsYg9zx4ErkFsvVFOkfiz5VmARakKKJRsfWXVkhn9WCgva1C6LKcDdZxk9HGJms3B89xDwQ==
X-Received: by 2002:adf:f10a:: with SMTP id r10mr47129504wro.406.1594626415050;
        Mon, 13 Jul 2020 00:46:55 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.6])
        by smtp.gmail.com with ESMTPSA id k11sm25142488wrd.23.2020.07.13.00.46.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 00:46:54 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        QLogic-Storage-Upstream@qlogic.com,
        Prakash Gollapudi <bprakash@broadcom.com>
Subject: [PATCH v2 07/29] scsi: bnx2fc: bnx2fc_fcoe: Repair a range of kerneldoc issues
Date:   Mon, 13 Jul 2020 08:46:23 +0100
Message-Id: <20200713074645.126138-8-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200713074645.126138-1-lee.jones@linaro.org>
References: <20200713074645.126138-1-lee.jones@linaro.org>
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


Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FA72C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 09:14:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F375264D5D
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 09:14:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231168AbhCQJNq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 05:13:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230270AbhCQJNI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 05:13:08 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00855C06175F
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 02:13:07 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id e9so997036wrw.10
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 02:13:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OhnfyqYrE6nzlDYMaUSwKVkj3wHq5/inwlljmfMJr4g=;
        b=oq6gMGCp+1IVUkver2pNGwBGb3YllnTbfUJkhd4e/S22gLbOJfKgwWopVR7taYr4rY
         speAS2+XKik7crtgBRXoHF0u+v2DwNnbtwgE861pRWY0VYGyjasQymLvYB9XdXEK7BKy
         HFzh4j7v+6zEsMyFSaZXpGUORnP0BuOF848awJj8D0HXqFyPkrYAwVOHhtIvH4WsFbYE
         2VKsw2+x+jGeOY3uPStF3ytb5FhKwNGK62JOhzozqwsZf9Z56lxNXVmamNVpWPkTFRge
         xh2Wq4UpZR8kP15BB7JsvuSULmWakv7A71/D9FvGhfJVHULDYo5XEF7MFm9sMIsYwGX5
         fxTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OhnfyqYrE6nzlDYMaUSwKVkj3wHq5/inwlljmfMJr4g=;
        b=efH+z1poCi0VJbR8yVYTDcfQEpv+7NH7KMwNjKtQFpdGjqIsGROQWNJdegAXKs8jsT
         92KA15nDVwIVpBwnMKvncGrQHjWnQDwTi3iPvxSs6KyiBYF2KwnmEvrTKYSVXKmFg0j8
         xfRVWpkra/eLFkxd8ysOi1ikaduWjeVhoOFvnRTScJJxSIwsHoDmzkx41XzSrMaxq9sY
         cFz2/kTT4BnIS4CaHcz2IGqpsGsUWtsTYIsmw6Dn7GjPf+Hdv6U08Y877eRmJOCEr+1J
         aqeQ/PkEq0HxJTdlGbrPdkTbbL13xoA/Ey4BqoSlT7jQ1ASsH5ntWv1tGRmZoec3vFRV
         Nnyg==
X-Gm-Message-State: AOAM533nmgCcOBiDkCuVkp75McivR7Cd6p1njmjD8ZPqw57He4aKuTCa
        sneLuAUiCmzXPPig/x+wFCKpTA==
X-Google-Smtp-Source: ABdhPJzGuIHZOWjyik7s5yrY/9dH+VjuHojh9hDyqx1Bk//CXXvlEVeeh4LL4gLAAwY8bvO5/x0Z2g==
X-Received: by 2002:adf:8341:: with SMTP id 59mr3205749wrd.130.1615972386718;
        Wed, 17 Mar 2021 02:13:06 -0700 (PDT)
Received: from dell.default ([91.110.221.194])
        by smtp.gmail.com with ESMTPSA id e18sm12695886wru.73.2021.03.17.02.13.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 02:13:06 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 26/36] scsi: isci: remote_device: Fix a bunch of doc-rot issues
Date:   Wed, 17 Mar 2021 09:12:20 +0000
Message-Id: <20210317091230.2912389-27-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210317091230.2912389-1-lee.jones@linaro.org>
References: <20210317091230.2912389-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/isci/remote_device.c:299: warning: Function parameter or member 'ihost' not described in 'isci_remote_device_not_ready'
 drivers/scsi/isci/remote_device.c:299: warning: Function parameter or member 'idev' not described in 'isci_remote_device_not_ready'
 drivers/scsi/isci/remote_device.c:299: warning: Function parameter or member 'reason' not described in 'isci_remote_device_not_ready'
 drivers/scsi/isci/remote_device.c:299: warning: Excess function parameter 'isci_host' description in 'isci_remote_device_not_ready'
 drivers/scsi/isci/remote_device.c:299: warning: Excess function parameter 'isci_device' description in 'isci_remote_device_not_ready'
 drivers/scsi/isci/remote_device.c:1015: warning: Function parameter or member 'idev' not described in 'sci_remote_device_destruct'
 drivers/scsi/isci/remote_device.c:1015: warning: Excess function parameter 'remote_device' description in 'sci_remote_device_destruct'
 drivers/scsi/isci/remote_device.c:1249: warning: Function parameter or member 'iport' not described in 'sci_remote_device_construct'
 drivers/scsi/isci/remote_device.c:1249: warning: Function parameter or member 'idev' not described in 'sci_remote_device_construct'
 drivers/scsi/isci/remote_device.c:1249: warning: Excess function parameter 'sci_port' description in 'sci_remote_device_construct'
 drivers/scsi/isci/remote_device.c:1249: warning: Excess function parameter 'sci_dev' description in 'sci_remote_device_construct'
 drivers/scsi/isci/remote_device.c:1275: warning: Function parameter or member 'iport' not described in 'sci_remote_device_da_construct'
 drivers/scsi/isci/remote_device.c:1275: warning: Function parameter or member 'idev' not described in 'sci_remote_device_da_construct'
 drivers/scsi/isci/remote_device.c:1311: warning: Function parameter or member 'iport' not described in 'sci_remote_device_ea_construct'
 drivers/scsi/isci/remote_device.c:1311: warning: Function parameter or member 'idev' not described in 'sci_remote_device_ea_construct'
 drivers/scsi/isci/remote_device.c:1453: warning: Function parameter or member 'idev' not described in 'sci_remote_device_start'
 drivers/scsi/isci/remote_device.c:1453: warning: Excess function parameter 'remote_device' description in 'sci_remote_device_start'
 drivers/scsi/isci/remote_device.c:1513: warning: Function parameter or member 'ihost' not described in 'isci_remote_device_alloc'
 drivers/scsi/isci/remote_device.c:1513: warning: Function parameter or member 'iport' not described in 'isci_remote_device_alloc'
 drivers/scsi/isci/remote_device.c:1513: warning: expecting prototype for This function builds the isci_remote_device when a libsas dev_found message(). Prototype was for isci_remote_device_alloc() instead
 drivers/scsi/isci/remote_device.c:1558: warning: Function parameter or member 'ihost' not described in 'isci_remote_device_stop'
 drivers/scsi/isci/remote_device.c:1558: warning: Function parameter or member 'idev' not described in 'isci_remote_device_stop'
 drivers/scsi/isci/remote_device.c:1558: warning: Excess function parameter 'isci_host' description in 'isci_remote_device_stop'
 drivers/scsi/isci/remote_device.c:1558: warning: Excess function parameter 'isci_device' description in 'isci_remote_device_stop'
 drivers/scsi/isci/remote_device.c:1592: warning: Function parameter or member 'dev' not described in 'isci_remote_device_gone'
 drivers/scsi/isci/remote_device.c:1592: warning: Excess function parameter 'domain_device' description in 'isci_remote_device_gone'
 drivers/scsi/isci/remote_device.c:1614: warning: Function parameter or member 'dev' not described in 'isci_remote_device_found'
 drivers/scsi/isci/remote_device.c:1614: warning: Excess function parameter 'domain_device' description in 'isci_remote_device_found'

Cc: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/isci/remote_device.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/isci/remote_device.c b/drivers/scsi/isci/remote_device.c
index b1276f7e49c89..866950a02965d 100644
--- a/drivers/scsi/isci/remote_device.c
+++ b/drivers/scsi/isci/remote_device.c
@@ -288,8 +288,9 @@ enum sci_status isci_remote_device_terminate_requests(
 * isci_remote_device_not_ready() - This function is called by the ihost when
 *    the remote device is not ready. We mark the isci device as ready (not
 *    "ready_for_io") and signal the waiting proccess.
-* @isci_host: This parameter specifies the isci host object.
-* @isci_device: This parameter specifies the remote device
+* @ihost: This parameter specifies the isci host object.
+* @idev: This parameter specifies the remote device
+* @reason: Reason to switch on
 *
 * sci_lock is held on entrance to this function.
 */
@@ -1000,7 +1001,7 @@ static void sci_remote_device_initial_state_enter(struct sci_base_state_machine
 
 /**
  * sci_remote_device_destruct() - free remote node context and destruct
- * @remote_device: This parameter specifies the remote device to be destructed.
+ * @idev: This parameter specifies the remote device to be destructed.
  *
  * Remote device objects are a limited resource.  As such, they must be
  * protected.  Thus calls to construct and destruct are mutually exclusive and
@@ -1236,8 +1237,8 @@ static const struct sci_base_state sci_remote_device_state_table[] = {
 
 /**
  * sci_remote_device_construct() - common construction
- * @sci_port: SAS/SATA port through which this device is accessed.
- * @sci_dev: remote device to construct
+ * @iport: SAS/SATA port through which this device is accessed.
+ * @idev: remote device to construct
  *
  * This routine just performs benign initialization and does not
  * allocate the remote_node_context which is left to
@@ -1256,7 +1257,7 @@ static void sci_remote_device_construct(struct isci_port *iport,
 					       SCIC_SDS_REMOTE_NODE_CONTEXT_INVALID_INDEX);
 }
 
-/**
+/*
  * sci_remote_device_da_construct() - construct direct attached device.
  *
  * The information (e.g. IAF, Signature FIS, etc.) necessary to build
@@ -1294,7 +1295,7 @@ static enum sci_status sci_remote_device_da_construct(struct isci_port *iport,
 	return SCI_SUCCESS;
 }
 
-/**
+/*
  * sci_remote_device_ea_construct() - construct expander attached device
  *
  * Remote node context(s) is/are a global resource allocated by this
@@ -1439,7 +1440,7 @@ enum sci_status isci_remote_device_resume_from_abort(
  * sci_remote_device_start() - This method will start the supplied remote
  *    device.  This method enables normal IO requests to flow through to the
  *    remote device.
- * @remote_device: This parameter specifies the device to be started.
+ * @idev: This parameter specifies the device to be started.
  * @timeout: This parameter specifies the number of milliseconds in which the
  *    start operation should complete.
  *
@@ -1501,10 +1502,11 @@ static enum sci_status isci_remote_device_construct(struct isci_port *iport,
 }
 
 /**
+ * isci_remote_device_alloc()
  * This function builds the isci_remote_device when a libsas dev_found message
  *    is received.
- * @isci_host: This parameter specifies the isci host object.
- * @port: This parameter specifies the isci_port connected to this device.
+ * @ihost: This parameter specifies the isci host object.
+ * @iport: This parameter specifies the isci_port connected to this device.
  *
  * pointer to new isci_remote_device.
  */
@@ -1549,8 +1551,8 @@ void isci_remote_device_release(struct kref *kref)
 /**
  * isci_remote_device_stop() - This function is called internally to stop the
  *    remote device.
- * @isci_host: This parameter specifies the isci host object.
- * @isci_device: This parameter specifies the remote device.
+ * @ihost: This parameter specifies the isci host object.
+ * @idev: This parameter specifies the remote device.
  *
  * The status of the ihost request to stop.
  */
@@ -1585,8 +1587,7 @@ enum sci_status isci_remote_device_stop(struct isci_host *ihost, struct isci_rem
 /**
  * isci_remote_device_gone() - This function is called by libsas when a domain
  *    device is removed.
- * @domain_device: This parameter specifies the libsas domain device.
- *
+ * @dev: This parameter specifies the libsas domain device.
  */
 void isci_remote_device_gone(struct domain_device *dev)
 {
@@ -1606,7 +1607,7 @@ void isci_remote_device_gone(struct domain_device *dev)
  *    device is discovered. A remote device object is created and started. the
  *    function then sleeps until the sci core device started message is
  *    received.
- * @domain_device: This parameter specifies the libsas domain device.
+ * @dev: This parameter specifies the libsas domain device.
  *
  * status, zero indicates success.
  */
-- 
2.27.0


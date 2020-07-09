Return-Path: <SRS0=/8H4=AU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FE34C433DF
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 17:47:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06EAF207DD
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 17:47:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="BJrbKWjh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728555AbgGIRqN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Jul 2020 13:46:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728525AbgGIRqL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jul 2020 13:46:11 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A68BC08E85B
        for <linux-scsi@vger.kernel.org>; Thu,  9 Jul 2020 10:46:11 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id o2so2758718wmh.2
        for <linux-scsi@vger.kernel.org>; Thu, 09 Jul 2020 10:46:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9wNqiWDnOoV7Tq3fUIjX7bWnfvj892xNMMafz42JpFQ=;
        b=BJrbKWjhzBBh3RMZVhYHcaOZZkUTOhhAMuZGWd99TPgvncnZcAR2gQzAJUhbxHvzaT
         vcDPLIjTG4BsY5JKOHabnqPAt2Tlq7bfhTLjnzZMe90hTRY6Of+nYm4bZ2xnOnfoL9zq
         P80f+Yfz3QD4K4PmO+myZ3I+siGXxnKFoN6Bm5c0nchOvxQeRyFdvYcPto1Mjzzifhbe
         Jp7vU+Hse0BH2ZUv+/K3SkD/RH/mg77jH4Yg5PC38+OcX1D6RwEk3AFudbPG/k/mCR6j
         hP6wGblrlsnEUpLTL/b7jMih86Q03Fbd4TgLEXrDtJ/WOdRqhArvb8EkisYH1ubMMjF4
         NAbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9wNqiWDnOoV7Tq3fUIjX7bWnfvj892xNMMafz42JpFQ=;
        b=iHVSJ2b6BvWqZEWpzytD1PJerKo1z7NmZOKJ/9HzTPJTXP9GOiW5SrPFgtITZpMS6l
         bN2NQYGWzWriYWQbKqFgPqeztQQ+nU8atrJnL+sG9MfsM/F0VNuASXrnxTStqUNmDgAG
         E1+0X4i6Pfs+kexoCWS69DV+dybRrdjfkqcAkvUAgY+eBVkzCjjh/b3BMRYegRM90I8O
         mAe09ywIYrXzV2I57UVyvJiYnW261IUvPSp9rJYrmJfM3OPi8NgOqnmzGkzCANRDuMkl
         aQoNE3QwEjs3C46MDIQquX0djnK9rt3fQbJSyUxJormt9XyGTOXK+4PEjlldZDK5o9zS
         DWXg==
X-Gm-Message-State: AOAM5326aYjCKBB9HTX+pv3DTI2/WeoJ/g1C0KeDoIfu61fGHkwzEYL8
        lHmMm/YG8IQ7n5e6YERDeCJNqA==
X-Google-Smtp-Source: ABdhPJxFseAbX3st95FnBDylPbgmEJ0aAnhpaK4jDdiDZ+mDaVs7FVhKs/xQXYj6E8zHeXcxQP4S3Q==
X-Received: by 2002:a7b:ce87:: with SMTP id q7mr1169747wmj.39.1594316769822;
        Thu, 09 Jul 2020 10:46:09 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.206])
        by smtp.gmail.com with ESMTPSA id f15sm6063854wrx.91.2020.07.09.10.46.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2020 10:46:09 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Jack Wang <jinpu.wang@cloud.ionos.com>
Subject: [PATCH 10/24] scsi: pm8001: pm8001_ctl: Provide descriptions for the many undocumented 'attr's
Date:   Thu,  9 Jul 2020 18:45:42 +0100
Message-Id: <20200709174556.7651-11-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200709174556.7651-1-lee.jones@linaro.org>
References: <20200709174556.7651-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

... even if they are completely unused.

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/pm8001/pm8001_ctl.c:56: warning: Function parameter or member 'attr' not described in 'pm8001_ctl_mpi_interface_rev_show'
 drivers/scsi/pm8001/pm8001_ctl.c:81: warning: Function parameter or member 'attr' not described in 'controller_fatal_error_show'
 drivers/scsi/pm8001/pm8001_ctl.c:100: warning: Function parameter or member 'attr' not described in 'pm8001_ctl_fw_version_show'
 drivers/scsi/pm8001/pm8001_ctl.c:130: warning: Function parameter or member 'attr' not described in 'pm8001_ctl_ila_version_show'
 drivers/scsi/pm8001/pm8001_ctl.c:155: warning: Function parameter or member 'attr' not described in 'pm8001_ctl_inactive_fw_version_show'
 drivers/scsi/pm8001/pm8001_ctl.c:181: warning: Function parameter or member 'attr' not described in 'pm8001_ctl_max_out_io_show'
 drivers/scsi/pm8001/pm8001_ctl.c:204: warning: Function parameter or member 'attr' not described in 'pm8001_ctl_max_devices_show'
 drivers/scsi/pm8001/pm8001_ctl.c:230: warning: Function parameter or member 'attr' not described in 'pm8001_ctl_max_sg_list_show'
 drivers/scsi/pm8001/pm8001_ctl.c:274: warning: Function parameter or member 'attr' not described in 'pm8001_ctl_sas_spec_support_show'
 drivers/scsi/pm8001/pm8001_ctl.c:303: warning: Function parameter or member 'attr' not described in 'pm8001_ctl_host_sas_address_show'
 drivers/scsi/pm8001/pm8001_ctl.c:322: warning: Function parameter or member 'attr' not described in 'pm8001_ctl_logging_level_show'
 drivers/scsi/pm8001/pm8001_ctl.c:355: warning: Function parameter or member 'attr' not described in 'pm8001_ctl_aap_log_show'
 drivers/scsi/pm8001/pm8001_ctl.c:390: warning: Function parameter or member 'attr' not described in 'pm8001_ctl_ib_queue_log_show'
 drivers/scsi/pm8001/pm8001_ctl.c:423: warning: Function parameter or member 'attr' not described in 'pm8001_ctl_ob_queue_log_show'
 drivers/scsi/pm8001/pm8001_ctl.c:454: warning: Function parameter or member 'attr' not described in 'pm8001_ctl_bios_version_show'
 drivers/scsi/pm8001/pm8001_ctl.c:492: warning: Function parameter or member 'attr' not described in 'event_log_size_show'
 drivers/scsi/pm8001/pm8001_ctl.c:510: warning: Function parameter or member 'attr' not described in 'pm8001_ctl_iop_log_show'
 drivers/scsi/pm8001/pm8001_ctl.c:548: warning: Function parameter or member 'attr' not described in 'pm8001_ctl_fatal_log_show'
 drivers/scsi/pm8001/pm8001_ctl.c:566: warning: Function parameter or member 'attr' not described in 'non_fatal_log_show'
 drivers/scsi/pm8001/pm8001_ctl.c:609: warning: Function parameter or member 'attr' not described in 'pm8001_ctl_gsm_log_show'

Cc: Jack Wang <jinpu.wang@cloud.ionos.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/pm8001/pm8001_ctl.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
index 3c9f42779dd02..a5f3c702ada9f 100644
--- a/drivers/scsi/pm8001/pm8001_ctl.c
+++ b/drivers/scsi/pm8001/pm8001_ctl.c
@@ -47,6 +47,7 @@
 /**
  * pm8001_ctl_mpi_interface_rev_show - MPI interface revision number
  * @cdev: pointer to embedded class device
+ * @attr: device attribute (unused)
  * @buf: the buffer returned
  *
  * A sysfs 'read-only' shost attribute.
@@ -72,6 +73,7 @@ DEVICE_ATTR(interface_rev, S_IRUGO, pm8001_ctl_mpi_interface_rev_show, NULL);
 /**
  * controller_fatal_error_show - check controller is under fatal err
  * @cdev: pointer to embedded class device
+ * @attr: device attribute (unused)
  * @buf: the buffer returned
  *
  * A sysfs 'read only' shost attribute.
@@ -121,6 +123,7 @@ static DEVICE_ATTR(fw_version, S_IRUGO, pm8001_ctl_fw_version_show, NULL);
 /**
  * pm8001_ctl_ila_version_show - ila version
  * @cdev: pointer to embedded class device
+ * @attr: device attribute (unused)
  * @buf: the buffer returned
  *
  * A sysfs 'read-only' shost attribute.
@@ -146,6 +149,7 @@ static DEVICE_ATTR(ila_version, 0444, pm8001_ctl_ila_version_show, NULL);
 /**
  * pm8001_ctl_inactive_fw_version_show - Inacative firmware version number
  * @cdev: pointer to embedded class device
+ * @attr: device attribute (unused)
  * @buf: the buffer returned
  *
  * A sysfs 'read-only' shost attribute.
@@ -172,6 +176,7 @@ DEVICE_ATTR(inc_fw_ver, 0444, pm8001_ctl_inactive_fw_version_show, NULL);
 /**
  * pm8001_ctl_max_out_io_show - max outstanding io supported
  * @cdev: pointer to embedded class device
+ * @attr: device attribute (unused)
  * @buf: the buffer returned
  *
  * A sysfs 'read-only' shost attribute.
@@ -195,6 +200,7 @@ static DEVICE_ATTR(max_out_io, S_IRUGO, pm8001_ctl_max_out_io_show, NULL);
 /**
  * pm8001_ctl_max_devices_show - max devices support
  * @cdev: pointer to embedded class device
+ * @attr: device attribute (unused)
  * @buf: the buffer returned
  *
  * A sysfs 'read-only' shost attribute.
@@ -221,6 +227,7 @@ static DEVICE_ATTR(max_devices, S_IRUGO, pm8001_ctl_max_devices_show, NULL);
  * pm8001_ctl_max_sg_list_show - max sg list supported iff not 0.0 for no
  * hardware limitation
  * @cdev: pointer to embedded class device
+ * @attr: device attribute (unused)
  * @buf: the buffer returned
  *
  * A sysfs 'read-only' shost attribute.
@@ -265,6 +272,7 @@ show_sas_spec_support_status(unsigned int mode, char *buf)
 /**
  * pm8001_ctl_sas_spec_support_show - sas spec supported
  * @cdev: pointer to embedded class device
+ * @attr: device attribute (unused)
  * @buf: the buffer returned
  *
  * A sysfs 'read-only' shost attribute.
@@ -292,6 +300,7 @@ static DEVICE_ATTR(sas_spec_support, S_IRUGO,
 /**
  * pm8001_ctl_sas_address_show - sas address
  * @cdev: pointer to embedded class device
+ * @attr: device attribute (unused)
  * @buf: the buffer returned
  *
  * This is the controller sas address
@@ -346,6 +355,7 @@ static DEVICE_ATTR(logging_level, S_IRUGO | S_IWUSR,
 /**
  * pm8001_ctl_aap_log_show - aap1 event log
  * @cdev: pointer to embedded class device
+ * @attr: device attribute (unused)
  * @buf: the buffer returned
  *
  * A sysfs 'read-only' shost attribute.
@@ -483,6 +493,7 @@ static DEVICE_ATTR(bios_version, S_IRUGO, pm8001_ctl_bios_version_show, NULL);
 /**
  * event_log_size_show - event log size
  * @cdev: pointer to embedded class device
+ * @attr: device attribute (unused)
  * @buf: the buffer returned
  *
  * A sysfs read  shost attribute.
@@ -501,6 +512,7 @@ static DEVICE_ATTR_RO(event_log_size);
 /**
  * pm8001_ctl_aap_log_show - IOP event log
  * @cdev: pointer to embedded class device
+ * @attr: device attribute (unused)
  * @buf: the buffer returned
  *
  * A sysfs 'read-only' shost attribute.
@@ -538,6 +550,7 @@ static DEVICE_ATTR(iop_log, S_IRUGO, pm8001_ctl_iop_log_show, NULL);
 /**
  ** pm8001_ctl_fatal_log_show - fatal error logging
  ** @cdev:pointer to embedded class device
+ ** @attr: device attribute
  ** @buf: the buffer returned
  **
  ** A sysfs 'read-only' shost attribute.
@@ -557,6 +570,7 @@ static DEVICE_ATTR(fatal_log, S_IRUGO, pm8001_ctl_fatal_log_show, NULL);
 /**
  ** non_fatal_log_show - non fatal error logging
  ** @cdev:pointer to embedded class device
+ ** @attr: device attribute
  ** @buf: the buffer returned
  **
  ** A sysfs 'read-only' shost attribute.
-- 
2.25.1


Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD3E7C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 09:49:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA04464FDA
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 09:49:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233159AbhCLJsd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Mar 2021 04:48:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232987AbhCLJsA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Mar 2021 04:48:00 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FDEBC061764
        for <linux-scsi@vger.kernel.org>; Fri, 12 Mar 2021 01:47:59 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id n11-20020a05600c4f8bb029010e5cf86347so4235274wmq.1
        for <linux-scsi@vger.kernel.org>; Fri, 12 Mar 2021 01:47:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GAfY/sW2GOLPvPNgEyR6W5v2K+OUufqzhLyZshJlkAg=;
        b=Egt3exAmPVcbCgA4NqY5XW32G2K6gk/0mdoD9JTRnOChzQscD1qRoSkHXbZuGLofz/
         2B1+8F0pbC9mczovOxwQz51AM6w1LLnkEwQxBi0cPZC1zhIEfL5DJ79xUOcw4tIGQoc5
         hTIqG8cE1hyNZ86l/IT/umOHDbaRUJM8l9QSGXu4+9EzRT2NnRsIsPjpOsXvkveSCoNq
         CC6SuBW189wCoCUegHAuWgn62prxXzXMZ/cbDq9if50ofuXkJ6zSrEcihdNipgkAy5BK
         HtJwx0WpW/1zvX7N1HPb7SyPM+Q3AN/efuVa9YxxxrAvNta23XEc91nkRB4QFaz4fozo
         umrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GAfY/sW2GOLPvPNgEyR6W5v2K+OUufqzhLyZshJlkAg=;
        b=KI1Ml8Mc7DPZVAlghl3k+i4WZe8keJASqG1VscAXwAqKPpTs+oMJ6BJkPppjNZa0rk
         SffuWIT8OTDhFp1OCIoMmmV6xFQqTM32OS44BBqFFHSI8aL70lxmo44fZbxfb7JDR2op
         Rlywq34FE2BbfCQxJpIChwtU6lNmKH4Jb7mPw7+9My/6CC1L6AgY2kmuK4GZwzKtSsZm
         c8oanHs4ejAAils98Yqu5dT3kPV5fEBDVFm+CUrVVLV4mBuOEgPUNIprWgORh4zRFW3F
         GpXw5HEEHEgucx23Pan2G3fYmWsKLk7ZDsIcv6Sopdt+fm0zjdeoFxCIcmo1OtABe7QC
         xDpw==
X-Gm-Message-State: AOAM532w3rFrbCL7TS/v1rceghdxYkIcHM34AsssYXv56gm3+Hcgn7g7
        y4ZKTP4BQN+Bg2/64Jih9al5uME5OrBbHw==
X-Google-Smtp-Source: ABdhPJy2LUYuQDQsCgd9Z0VwivR/jzGumnZAfhjGkmCBXsAHyuaneyZoFz9aVpb+yo9PZJ5p9lZQPw==
X-Received: by 2002:a1c:7901:: with SMTP id l1mr12471938wme.114.1615542478104;
        Fri, 12 Mar 2021 01:47:58 -0800 (PST)
Received: from dell.default ([91.110.221.204])
        by smtp.gmail.com with ESMTPSA id f7sm1539536wmq.11.2021.03.12.01.47.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 01:47:57 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        MPT-FusionLinux.pdl@avagotech.com,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Subject: [PATCH 09/30] scsi: mpt3sas: mpt3sas_ctl: Fix some kernel-doc misnaming issues
Date:   Fri, 12 Mar 2021 09:47:17 +0000
Message-Id: <20210312094738.2207817-10-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210312094738.2207817-1-lee.jones@linaro.org>
References: <20210312094738.2207817-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/mpt3sas/mpt3sas_ctl.c:463: warning: expecting prototype for mpt3sas_ctl_reset_handler(). Prototype was for mpt3sas_ctl_pre_reset_handler() instead
 drivers/scsi/mpt3sas/mpt3sas_ctl.c:495: warning: expecting prototype for mpt3sas_ctl_reset_handler(). Prototype was for mpt3sas_ctl_clear_outstanding_ioctls() instead
 drivers/scsi/mpt3sas/mpt3sas_ctl.c:512: warning: expecting prototype for mpt3sas_ctl_reset_handler(). Prototype was for mpt3sas_ctl_reset_done_handler() instead
 drivers/scsi/mpt3sas/mpt3sas_ctl.c:2771: warning: expecting prototype for _ ctl_ioctl_compat(). Prototype was for _ctl_ioctl_compat() instead
 drivers/scsi/mpt3sas/mpt3sas_ctl.c:2789: warning: expecting prototype for _ ctl_mpt2_ioctl_compat(). Prototype was for _ctl_mpt2_ioctl_compat() instead
 drivers/scsi/mpt3sas/mpt3sas_ctl.c:3061: warning: expecting prototype for sas_address_show(). Prototype was for host_sas_address_show() instead
 drivers/scsi/mpt3sas/mpt3sas_ctl.c:3682: warning: expecting prototype for diag_trigger_scsi_show(). Prototype was for diag_trigger_mpi_show() instead
 drivers/scsi/mpt3sas/mpt3sas_ctl.c:3941: warning: expecting prototype for sas_ncq_io_prio_show(). Prototype was for sas_ncq_prio_enable_show() instead

Cc: Sathya Prakash <sathya.prakash@broadcom.com>
Cc: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: MPT-FusionLinux.pdl@avagotech.com
Cc: MPT-FusionLinux.pdl@broadcom.com
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/mpt3sas/mpt3sas_ctl.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 44f9a05db94e1..8717412b80794 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -454,7 +454,7 @@ _ctl_verify_adapter(int ioc_number, struct MPT3SAS_ADAPTER **iocpp,
 }
 
 /**
- * mpt3sas_ctl_reset_handler - reset callback handler (for ctl)
+ * mpt3sas_ctl_pre_reset_handler - reset callback handler (for ctl)
  * @ioc: per adapter object
  *
  * The handler for doing any required cleanup or initialization.
@@ -486,7 +486,7 @@ void mpt3sas_ctl_pre_reset_handler(struct MPT3SAS_ADAPTER *ioc)
 }
 
 /**
- * mpt3sas_ctl_reset_handler - clears outstanding ioctl cmd.
+ * mpt3sas_ctl_clear_outstanding_ioctls - clears outstanding ioctl cmd.
  * @ioc: per adapter object
  *
  * The handler for doing any required cleanup or initialization.
@@ -503,7 +503,7 @@ void mpt3sas_ctl_clear_outstanding_ioctls(struct MPT3SAS_ADAPTER *ioc)
 }
 
 /**
- * mpt3sas_ctl_reset_handler - reset callback handler (for ctl)
+ * mpt3sas_ctl_reset_done_handler - reset callback handler (for ctl)
  * @ioc: per adapter object
  *
  * The handler for doing any required cleanup or initialization.
@@ -2759,7 +2759,7 @@ _ctl_mpt2_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 }
 #ifdef CONFIG_COMPAT
 /**
- *_ ctl_ioctl_compat - main ioctl entry point (compat)
+ * _ctl_ioctl_compat - main ioctl entry point (compat)
  * @file: ?
  * @cmd: ?
  * @arg: ?
@@ -2777,7 +2777,7 @@ _ctl_ioctl_compat(struct file *file, unsigned cmd, unsigned long arg)
 }
 
 /**
- *_ ctl_mpt2_ioctl_compat - main ioctl entry point (compat)
+ * _ctl_mpt2_ioctl_compat - main ioctl entry point (compat)
  * @file: ?
  * @cmd: ?
  * @arg: ?
@@ -3045,7 +3045,7 @@ fw_queue_depth_show(struct device *cdev, struct device_attribute *attr,
 static DEVICE_ATTR_RO(fw_queue_depth);
 
 /**
- * sas_address_show - sas address
+ * host_sas_address_show - sas address
  * @cdev: pointer to embedded class device
  * @attr: ?
  * @buf: the buffer returned
@@ -3669,7 +3669,7 @@ static DEVICE_ATTR_RW(diag_trigger_scsi);
 
 
 /**
- * diag_trigger_scsi_show - show the diag_trigger_mpi attribute
+ * diag_trigger_mpi_show - show the diag_trigger_mpi attribute
  * @cdev: pointer to embedded class device
  * @attr: ?
  * @buf: the buffer returned
@@ -3928,7 +3928,7 @@ sas_device_handle_show(struct device *dev, struct device_attribute *attr,
 static DEVICE_ATTR_RO(sas_device_handle);
 
 /**
- * sas_ncq_io_prio_show - send prioritized io commands to device
+ * sas_ncq_prio_enable_show - send prioritized io commands to device
  * @dev: pointer to embedded device
  * @attr: ?
  * @buf: the buffer returned
-- 
2.27.0


Return-Path: <SRS0=+RX4=AY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1EACC433E5
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 08:00:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7AB2A2072D
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 08:00:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="LNK+596w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729227AbgGMIAV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jul 2020 04:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727891AbgGMIAU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jul 2020 04:00:20 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D07D6C061755
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 01:00:19 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id l17so12368321wmj.0
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 01:00:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9wNqiWDnOoV7Tq3fUIjX7bWnfvj892xNMMafz42JpFQ=;
        b=LNK+596wiFxLBRZYC3F2WCxd3yBrWVB60mNv0MBtlthCFvHl0k3mrpfstElNzfoJJz
         WHmLi2aM5SMki9Si9JNY65ttis2g8EM8znHbPSPJ5yM8u6y9/Ehtg6OqIXm2Puw5JPc4
         M3YN4hqJjkoY3Xy/mtzIHEyk4IRp2q/5Mh5FHsIELviGogWzORBJqrE0CExTGyuEHGyL
         Ej7hRxaHaDC/H+g+ZT9r0nJ0fErfDg2ZxziSwaV1I5lA5JG5n2T7rxpIlrY8RWizO7GX
         ruDPRdudAGM8NFNyNw4MzP/3bNPMAqmeC6G1U6kEAC+VUPOMBMcMI8hyRIahDF8fADIU
         vyzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9wNqiWDnOoV7Tq3fUIjX7bWnfvj892xNMMafz42JpFQ=;
        b=eMf/PxWpRjEIbmV7v0ZRZexEMXzIfvIzuDL3LLofYiUHTtID09otz+mtBQ0HGClVPd
         Ep1T1E+HDkpTd+EG1OETltuLDl9AnJhCIxr9P2pnwXrHLzskMEy/9uo3cLHZo4wbl3FJ
         uhrOgPIp8eT9KGclnECJ0UY8G75NpbvmkpC1H3DroLsK47pLmyA0+J1gVdt0aJsXiDmz
         z6PlDGgwRDVXTtuA0oIZtA3ZVtU148zujxt23enLMF/ffzDbCZJ4UtrFU8l5SZdogY+H
         +m73xC0hrwcYEoDD8QnCvYJ4e0KStRiBepXrZrvCmcZoOdp2lnO/VOv0PmkMAbQ63a8b
         gfFQ==
X-Gm-Message-State: AOAM532NyvcQRVhzftdmXgZj3qVnoKKJfWVezkYri6tLSJPmHxEuh9TE
        v1YE0EjHMPyw1wdguIoG8oGgzA==
X-Google-Smtp-Source: ABdhPJzDHlyidV66NHvVR7cEPl19EaNz4Kj79SGPtVrahB4FzdznpE+LAFQjlB6OCqCABxOcAqL4eQ==
X-Received: by 2002:a1c:bc8a:: with SMTP id m132mr16923482wmf.1.1594627218510;
        Mon, 13 Jul 2020 01:00:18 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.6])
        by smtp.gmail.com with ESMTPSA id 33sm24383549wri.16.2020.07.13.01.00.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 01:00:17 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Jack Wang <jinpu.wang@cloud.ionos.com>
Subject: [PATCH v2 10/24] scsi: pm8001: pm8001_ctl: Provide descriptions for the many undocumented 'attr's
Date:   Mon, 13 Jul 2020 08:59:47 +0100
Message-Id: <20200713080001.128044-11-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200713080001.128044-1-lee.jones@linaro.org>
References: <20200713080001.128044-1-lee.jones@linaro.org>
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


Return-Path: <SRS0=19hD=BA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDE4EC433F1
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 16:42:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E3B3207BB
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 16:42:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="xL1cP30E"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730567AbgGUQmP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jul 2020 12:42:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728827AbgGUQmO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jul 2020 12:42:14 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0559FC061794
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2020 09:42:14 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id 88so11571780wrh.3
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2020 09:42:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5j6RcNPu58XwWQQgxDOv1ZbcxCrsGooexxZ/gmLrlrM=;
        b=xL1cP30EALt5ZNjGYk9G+OFcXwArn2GZgrWng0gu+6zPVwjVRoxUrja42IAnVkTwpn
         XgHDeMJ/PRQwBHuxfsY3yyT69VS8CxkCMgsadN8ErJxzHVsPDPfVb+flOZyFoanJCgXt
         rX44gEWaqbtAFMVL2PY1WdOn7ilFpaC2JZnVvJ8jvfY3znZ0sCChXTYk0WWE+o41Y97b
         HonuCXScVeteCYAxZVDplvS3rgNuFfeVELv0gc6by0zNYXcNCdewzbRrT9cvxHMeTVpv
         Q9KFeQTyT3fB5Roojibh6MsDv+ezIity22XlyGSF6RA2lY2zy0WBgLAY7wGfZ7AJ/jhC
         MsHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5j6RcNPu58XwWQQgxDOv1ZbcxCrsGooexxZ/gmLrlrM=;
        b=pROqVwMf4Jgj81cCbevPH9xoeZEAnVf0MncyKcQffIUiPs4utY5sFX5G6MnP5j/DvL
         1l7f77pIfsGHtfEheOUJRw/39KVoTdCGo285BltdP2XLJLT+MUQoE9hLhW8yDA9HGU0M
         kmDd84raJEc+LiygGtiJ7OLPDmdQZwQpRh00zrBCQ4+MaO102zoqpTkki9VDdH7y438j
         AlCfZzAbH0yiORLHz49ZXrI8tU2mJQ6oYxKHtx+LKVLsy8unhpJqEVgVVXTH2ra/eJTr
         DXXOYGGlWnQbJpbYBzki3z0Uxquf91soVJN7PqzIYFWr9EKQUL2C09Ed7b01KlEw7Fyy
         TqyQ==
X-Gm-Message-State: AOAM533ZxLxXT1G2SfIT1LjaKxVUNh2AjN6NMtOC2wGZ672E0Jms6Poy
        XWfabvEmFT9sDgiVhHNgy6HvHg==
X-Google-Smtp-Source: ABdhPJxoVR+411rKfG1YcD3RdRPEBW1F7W9EGimiXdm8hjq2fA/pEmXZ8bo9WCWYWP/gIPxshF4eVw==
X-Received: by 2002:adf:9e8b:: with SMTP id a11mr4950480wrf.309.1595349732713;
        Tue, 21 Jul 2020 09:42:12 -0700 (PDT)
Received: from localhost.localdomain ([2.27.167.94])
        by smtp.gmail.com with ESMTPSA id m4sm3933524wmi.48.2020.07.21.09.42.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2020 09:42:12 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Jack Wang <jinpu.wang@cloud.ionos.com>
Subject: [PATCH 11/40] scsi: pm8001: pm8001_ctl: Add descriptions for unused 'attr' function parameters
Date:   Tue, 21 Jul 2020 17:41:19 +0100
Message-Id: <20200721164148.2617584-12-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200721164148.2617584-1-lee.jones@linaro.org>
References: <20200721164148.2617584-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Clean-up some whitespace issues too whilst we're here.

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/pm8001/pm8001_ctl.c:102: warning: Function parameter or member 'attr' not described in 'pm8001_ctl_fw_version_show'
 drivers/scsi/pm8001/pm8001_ctl.c:331: warning: Function parameter or member 'attr' not described in 'pm8001_ctl_logging_level_show'
 drivers/scsi/pm8001/pm8001_ctl.c:400: warning: Function parameter or member 'attr' not described in 'pm8001_ctl_ib_queue_log_show'
 drivers/scsi/pm8001/pm8001_ctl.c:433: warning: Function parameter or member 'attr' not described in 'pm8001_ctl_ob_queue_log_show'
 drivers/scsi/pm8001/pm8001_ctl.c:464: warning: Function parameter or member 'attr' not described in 'pm8001_ctl_bios_version_show'
 drivers/scsi/pm8001/pm8001_ctl.c:623: warning: Function parameter or member 'attr' not described in 'pm8001_ctl_gsm_log_show'

Cc: Jack Wang <jinpu.wang@cloud.ionos.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/pm8001/pm8001_ctl.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
index a5f3c702ada9f..77c805db27242 100644
--- a/drivers/scsi/pm8001/pm8001_ctl.c
+++ b/drivers/scsi/pm8001/pm8001_ctl.c
@@ -93,6 +93,7 @@ static DEVICE_ATTR_RO(controller_fatal_error);
 /**
  * pm8001_ctl_fw_version_show - firmware version
  * @cdev: pointer to embedded class device
+ * @attr: device attribute (unused)
  * @buf: the buffer returned
  *
  * A sysfs 'read-only' shost attribute.
@@ -322,6 +323,7 @@ static DEVICE_ATTR(host_sas_address, S_IRUGO,
 /**
  * pm8001_ctl_logging_level_show - logging level
  * @cdev: pointer to embedded class device
+ * @attr: device attribute (unused)
  * @buf: the buffer returned
  *
  * A sysfs 'read/write' shost attribute.
@@ -335,6 +337,7 @@ static ssize_t pm8001_ctl_logging_level_show(struct device *cdev,
 
 	return snprintf(buf, PAGE_SIZE, "%08xh\n", pm8001_ha->logging_level);
 }
+
 static ssize_t pm8001_ctl_logging_level_store(struct device *cdev,
 	struct device_attribute *attr, const char *buf, size_t count)
 {
@@ -392,6 +395,7 @@ static DEVICE_ATTR(aap_log, S_IRUGO, pm8001_ctl_aap_log_show, NULL);
 /**
  * pm8001_ctl_ib_queue_log_show - Out bound Queue log
  * @cdev:pointer to embedded class device
+ * @attr: device attribute (unused)
  * @buf: the buffer returned
  * A sysfs 'read-only' shost attribute.
  */
@@ -424,6 +428,7 @@ static DEVICE_ATTR(ib_log, S_IRUGO, pm8001_ctl_ib_queue_log_show, NULL);
 /**
  * pm8001_ctl_ob_queue_log_show - Out bound Queue log
  * @cdev:pointer to embedded class device
+ * @attr: device attribute (unused)
  * @buf: the buffer returned
  * A sysfs 'read-only' shost attribute.
  */
@@ -456,6 +461,7 @@ static DEVICE_ATTR(ob_log, S_IRUGO, pm8001_ctl_ob_queue_log_show, NULL);
 /**
  * pm8001_ctl_bios_version_show - Bios version Display
  * @cdev:pointer to embedded class device
+ * @attr: device attribute (unused)
  * @buf:the buffer returned
  * A sysfs 'read-only' shost attribute.
  */
@@ -615,8 +621,9 @@ static DEVICE_ATTR_RW(non_fatal_count);
 /**
  ** pm8001_ctl_gsm_log_show - gsm dump collection
  ** @cdev:pointer to embedded class device
+ ** @attr: device attribute (unused)
  ** @buf: the buffer returned
- **A sysfs 'read-only' shost attribute.
+ ** A sysfs 'read-only' shost attribute.
  **/
 static ssize_t pm8001_ctl_gsm_log_show(struct device *cdev,
 	struct device_attribute *attr, char *buf)
-- 
2.25.1


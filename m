Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 594E5C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:19:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42A6F610A0
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:19:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235027AbhJGVVg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 17:21:36 -0400
Received: from mail-pg1-f179.google.com ([209.85.215.179]:36736 "EHLO
        mail-pg1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234337AbhJGVVf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 17:21:35 -0400
Received: by mail-pg1-f179.google.com with SMTP id 75so1046558pga.3
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 14:19:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FrysTrRWqfpxxlxiOt57RERG55tTS7+lfWY0NmIIYqA=;
        b=rYAbopXr5dXAFQpkGYoDRPAzt60drEQfjV45hi/xM6yJk8IJr2Uk8tux3nvGry9Rnj
         0VUXavoUMBJl4QdLrAUKxcUyQtsqYGSrp1md33D7ncRQuVJvAMVPsJIAzCDWXJFhDJ4Y
         z+pjAL1mqL29xTyfCvG3wKGNnXqh/97aM+Ld4HmHDzKd48dRDaxOpfd9/ha3ngyHlATn
         uaAzNyhFDGw9ZMwXYKQxc1EimneQUHRpVd9l+rJG/L+w3zHBNT3OmetWvU5XrxyHZK4p
         /Gc9JzNELDNgC+T0hPSGNCy7DEREuunrm4/UTL09i9agc3IOTKlMjcpKEOg802b4fcBs
         Ln3g==
X-Gm-Message-State: AOAM531sVe1T12leMFCHoYHHluvBV8ceYOl4UPl7YHpG0Ji6046YCjLR
        TS43xdJETdp9EtdG8xur1XwbR6lC4lEaoQ==
X-Google-Smtp-Source: ABdhPJxBGAGHVm8xYNgfRtfGqde+NFWQJxBEGp2YfMoqNZmGmxqLlPp0vols+hCtACRgKNCwr906mw==
X-Received: by 2002:a05:6a00:1255:b0:44c:dd49:b39a with SMTP id u21-20020a056a00125500b0044cdd49b39amr96262pfi.66.1633641581245;
        Thu, 07 Oct 2021 14:19:41 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id o2sm243290pgc.47.2021.10.07.14.19.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 14:19:40 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Saurav Kashyap <skashyap@marvell.com>,
        Javed Hasan <jhasan@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 15/46] scsi: bnx2fc: Switch to attribute groups
Date:   Thu,  7 Oct 2021 14:18:21 -0700
Message-Id: <20211007211852.256007-16-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
In-Reply-To: <20211007211852.256007-1-bvanassche@acm.org>
References: <20211007211852.256007-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

struct device supports attribute groups directly but does not support
struct device_attribute directly. Hence switch to attribute groups.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 8863a74e6c57..adf8864bde9c 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -2951,11 +2951,20 @@ bnx2fc_tm_timeout_store(struct device *dev,
 static DEVICE_ATTR(tm_timeout, S_IRUGO|S_IWUSR, bnx2fc_tm_timeout_show,
 	bnx2fc_tm_timeout_store);
 
-static struct device_attribute *bnx2fc_host_attrs[] = {
-	&dev_attr_tm_timeout,
+static struct attribute *bnx2fc_host_attrs[] = {
+	&dev_attr_tm_timeout.attr,
 	NULL,
 };
 
+static const struct attribute_group bnx2fc_host_attr_group = {
+	.attrs = bnx2fc_host_attrs
+};
+
+static const struct attribute_group *bnx2fc_host_attr_groups[] = {
+	&bnx2fc_host_attr_group,
+	NULL
+};
+
 /*
  * scsi_host_template structure used while registering with SCSI-ml
  */
@@ -2977,7 +2986,7 @@ static struct scsi_host_template bnx2fc_shost_template = {
 	.max_sectors		= 0x3fbf,
 	.track_queue_depth	= 1,
 	.slave_configure	= bnx2fc_slave_configure,
-	.shost_attrs		= bnx2fc_host_attrs,
+	.shost_groups		= bnx2fc_host_attr_groups,
 };
 
 static struct libfc_function_template bnx2fc_libfc_fcn_templ = {

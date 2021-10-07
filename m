Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C91E3C4332F
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:19:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF70A610A5
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:19:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240742AbhJGVVx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 17:21:53 -0400
Received: from mail-pf1-f171.google.com ([209.85.210.171]:33718 "EHLO
        mail-pf1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235027AbhJGVVv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 17:21:51 -0400
Received: by mail-pf1-f171.google.com with SMTP id s16so6463473pfk.0
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 14:19:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7DNYpVKkKhZ1JECkgbXVPgTfTtQ+Re0dkc/bKlV/+CY=;
        b=8KDTbfOkpKQ2lw/Tviv+z8jt6Tx3U/wIVeBi/elEX8ScyrLxTOzNH0EzGxLqenPKJU
         ENbEXKxafYN9kT8vjgWtMP1hyuFTl4kqulWiJrg3y2Wx0DAPKak8NkAxrFpgnoNVYRp7
         DO3OHVZRt20dnOCDVpOIZBLE/YcmLNcAxkKCw2BqS26+b3besxVLaDXOxhUL7JeVmSqj
         29t3g641n0XNX/XRdNZ77Msoqa3DkJvT22GifNU9wN69gstOhTgdnj8e3M1Zy0Jui55H
         mLDFLRmz+iEJLUUnixpXQqJhCIbnAyjNEyjNANgJQ6Vfkka8ADBvpdv5wcnH2/NbNdn8
         HbLg==
X-Gm-Message-State: AOAM532+wKUzj6AYSZWQKgXpwsGzb6h975le2wXXquwqmXuONVra1twg
        ORUJx661TKdMDzkkB/CE5WA=
X-Google-Smtp-Source: ABdhPJzdhDUJOPT56suXDpXsXXJfFZHvyVoq21Ng2KqUCpLEqntNYy8gXNkVKDUxxFHQ20qo2v0KzQ==
X-Received: by 2002:a63:615:: with SMTP id 21mr1528025pgg.468.1633641597385;
        Thu, 07 Oct 2021 14:19:57 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id o2sm243290pgc.47.2021.10.07.14.19.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 14:19:56 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        HighPoint Linux Team <linux@highpoint-tech.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 22/46] scsi: hptiop: Switch to attribute groups
Date:   Thu,  7 Oct 2021 14:18:28 -0700
Message-Id: <20211007211852.256007-23-bvanassche@acm.org>
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
 drivers/scsi/hptiop.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/hptiop.c b/drivers/scsi/hptiop.c
index 61cda7b7624f..36595eec291a 100644
--- a/drivers/scsi/hptiop.c
+++ b/drivers/scsi/hptiop.c
@@ -1150,9 +1150,18 @@ static struct device_attribute hptiop_attr_fw_version = {
 	.show = hptiop_show_fw_version,
 };
 
-static struct device_attribute *hptiop_attrs[] = {
-	&hptiop_attr_version,
-	&hptiop_attr_fw_version,
+static struct attribute *hptiop_attrs[] = {
+	&hptiop_attr_version.attr,
+	&hptiop_attr_fw_version.attr,
+	NULL
+};
+
+static const struct attribute_group hptiop_attr_group = {
+	.attrs = hptiop_attrs
+};
+
+static const struct attribute_group *hptiop_attr_groups[] = {
+	&hptiop_attr_group,
 	NULL
 };
 
@@ -1172,7 +1181,7 @@ static struct scsi_host_template driver_template = {
 	.info                       = hptiop_info,
 	.emulated                   = 0,
 	.proc_name                  = driver_name,
-	.shost_attrs                = hptiop_attrs,
+	.shost_groups		    = hptiop_attr_groups,
 	.slave_configure            = hptiop_slave_config,
 	.this_id                    = -1,
 	.change_queue_depth         = hptiop_adjust_disk_queue_depth,

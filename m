Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEAD2C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:20:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7E5B61130
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:20:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240802AbhJGVWp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 17:22:45 -0400
Received: from mail-pg1-f177.google.com ([209.85.215.177]:36834 "EHLO
        mail-pg1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233918AbhJGVWn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 17:22:43 -0400
Received: by mail-pg1-f177.google.com with SMTP id 75so1049473pga.3
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 14:20:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Jz9hpG1PmutAFUR3RBwmJgaEHPLDPR3rqvzKdXRocR4=;
        b=wWfxi/FLyQD7RMJ0A7RXXQeIkpJElVRrJXfWzEwRo67yDekvPvYXCcueyPffW08bBP
         X46xvTPwSbUvv5Ixh+bMMjtvPOGl5asbkcVKST9F01te+9z4S3iKP/pGbgcdnuw8lmsi
         MAOsANxkyXlZxUTwqcJjkpqVizLPv9tVETdwEiN/ZTvYFk8RyWDWYwi2std3zDIH/S8j
         VErvGuqh2zR1oBFFAOfqpUb1/K762GfqofEU1B8ZnyHKTrJXHdijJcFhd28FyLGR+Fxs
         SzFODXGYVeI4E1R+rg+mb2oGdyz25ie+pqja4GZ66IES6t1mdzeIp2aDfj62q+/TVynL
         CjYQ==
X-Gm-Message-State: AOAM532UWrAN35IAzYxtVdwhIwrxsICYuIf2TfhtuJ5JvYo0yE5oERpL
        747+CE8vV4y4HpHDKyl6fEqjqsgF4PIDZg==
X-Google-Smtp-Source: ABdhPJweiSrZHYMIp2EbY3uizQpyciYkvO5ANDCIbnNn5X6jw/5HuX0xTYOd8HRdsTYCmJ5zGU0LKA==
X-Received: by 2002:a65:6648:: with SMTP id z8mr1549979pgv.418.1633641649252;
        Thu, 07 Oct 2021 14:20:49 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id o2sm243290pgc.47.2021.10.07.14.20.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 14:20:48 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH v2 45/46] scsi: usb: Switch to attribute groups
Date:   Thu,  7 Oct 2021 14:18:51 -0700
Message-Id: <20211007211852.256007-46-bvanassche@acm.org>
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
 drivers/usb/storage/scsiglue.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
index e5a971b83e3f..123273c52fc8 100644
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -588,11 +588,20 @@ static ssize_t max_sectors_store(struct device *dev, struct device_attribute *at
 }
 static DEVICE_ATTR_RW(max_sectors);
 
-static struct device_attribute *sysfs_device_attr_list[] = {
-	&dev_attr_max_sectors,
+static struct attribute *usb_sdev_attrs[] = {
+	&dev_attr_max_sectors.attr,
 	NULL,
 };
 
+static const struct attribute_group usb_sdev_attr_group = {
+	.attrs = usb_sdev_attrs
+};
+
+static const struct attribute_group *usb_sdev_attr_groups[] = {
+	&usb_sdev_attr_group,
+	NULL
+};
+
 /*
  * this defines our host template, with which we'll allocate hosts
  */
@@ -653,7 +662,7 @@ static const struct scsi_host_template usb_stor_host_template = {
 	.skip_settle_delay =		1,
 
 	/* sysfs device attributes */
-	.sdev_attrs =			sysfs_device_attr_list,
+	.sdev_groups =			usb_sdev_attr_groups,
 
 	/* module management */
 	.module =			THIS_MODULE

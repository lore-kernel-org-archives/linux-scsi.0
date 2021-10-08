Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB84AC433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 20:25:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D696261073
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 20:25:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242946AbhJHU1c (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Oct 2021 16:27:32 -0400
Received: from mail-pl1-f175.google.com ([209.85.214.175]:38624 "EHLO
        mail-pl1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243024AbhJHU1Z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Oct 2021 16:27:25 -0400
Received: by mail-pl1-f175.google.com with SMTP id x4so6894511pln.5
        for <linux-scsi@vger.kernel.org>; Fri, 08 Oct 2021 13:25:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+/bp3hoiETw2P+T0Y2HtzrA38s9n3zqaqtEphrpxGKM=;
        b=EEf7PfeHgr7/3FXuw6VolXGxySwaRDqB9vuVMsz9NpqOUyq82oPv88fitqvM/1lTaZ
         +bzcWQVn1OJ3JbwlBoQT/l7VsdiX8C3cDFmG4LzGRn9aZMDMdLWsaGy8y1azx2u7aptO
         tJKctGU0mEHJj5cBX3V/KHxgF9APSKP9byS+thazR1YZx84McokkcKWYE1l57/82Zs2o
         /6dwXJDIbiXyAulLLng6ilbZYc6A2UoDrjz95dBgf7vDpCq2ymW/LCAZ7ICfEg/KlF4O
         05pkTPf+F+Qlk6xnuwURg1AeDQZ4ONlClirTSQKP97CYJ80wTjM5fWNhV4CNZFjSD9ty
         gugQ==
X-Gm-Message-State: AOAM533sNJqCrIfZwfpiiga3mfRZqX5EK6z2E1pjDYIVVdc5VtcDao2Q
        wJMq96S/WXz5IsumUW1mzBI=
X-Google-Smtp-Source: ABdhPJycmj5b2RfCx7fxQDyPbT1Dfa+P2lACh3wfi/SkiU8xr24M/2PsLRINgVJX4JRM+skDKArgRw==
X-Received: by 2002:a17:90b:1bcc:: with SMTP id oa12mr13844035pjb.212.1633724729532;
        Fri, 08 Oct 2021 13:25:29 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a8e9:7950:57f8:970])
        by smtp.gmail.com with ESMTPSA id x21sm170858pfa.186.2021.10.08.13.25.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 13:25:29 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH v3 45/46] scsi: usb: Switch to attribute groups
Date:   Fri,  8 Oct 2021 13:23:52 -0700
Message-Id: <20211008202353.1448570-46-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
In-Reply-To: <20211008202353.1448570-1-bvanassche@acm.org>
References: <20211008202353.1448570-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

struct device supports attribute groups directly but does not support
struct device_attribute directly. Hence switch to attribute groups.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/usb/storage/scsiglue.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
index e5a971b83e3f..4e5a928f0368 100644
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -588,11 +588,13 @@ static ssize_t max_sectors_store(struct device *dev, struct device_attribute *at
 }
 static DEVICE_ATTR_RW(max_sectors);
 
-static struct device_attribute *sysfs_device_attr_list[] = {
-	&dev_attr_max_sectors,
+static struct attribute *usb_sdev_attrs[] = {
+	&dev_attr_max_sectors.attr,
 	NULL,
 };
 
+ATTRIBUTE_GROUPS(usb_sdev);
+
 /*
  * this defines our host template, with which we'll allocate hosts
  */
@@ -653,7 +655,7 @@ static const struct scsi_host_template usb_stor_host_template = {
 	.skip_settle_delay =		1,
 
 	/* sysfs device attributes */
-	.sdev_attrs =			sysfs_device_attr_list,
+	.sdev_groups =			usb_sdev_groups,
 
 	/* module management */
 	.module =			THIS_MODULE

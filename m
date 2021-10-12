Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DAA6C433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:37:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB46160F3A
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:36:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236041AbhJLXjB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 19:39:01 -0400
Received: from mail-pj1-f44.google.com ([209.85.216.44]:35386 "EHLO
        mail-pj1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234169AbhJLXi5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Oct 2021 19:38:57 -0400
Received: by mail-pj1-f44.google.com with SMTP id d13-20020a17090ad3cd00b0019e746f7bd4so3077074pjw.0
        for <linux-scsi@vger.kernel.org>; Tue, 12 Oct 2021 16:36:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lIZc4myGIvO1lQfZsYDnY5KKqCZ0WsbuHlQI25Sk/3k=;
        b=UplI3d/+DL2pup8Woc0Twm3yLvlVHtgAUCQSepDYVTkUDpNVb1jXoaMbk3nkom2oTo
         SbQ30Fqyg/qq46eEKaGggBHpsEE8Y4FlXFdPCvrAXltiJ75AC3jy0RqHhC4hy4Wj2nHF
         A6US5jtRmoATd8nH39hMjdeVZ1dvlEV6WuiUHaG5BwTARckfh58TgNQt66M8TDvc4AqM
         tFdMk3vP1teXGzHfSFBKMMqqGMVcZ5kvqSYGqZZnUJ90ruDeu9jrnf81BUvNVyTOIZIf
         bouG5C7tFaoVoVF764HkRHiPeMz5MmHImPlV/+2y9Mo1xYVq0wJkaqIxAf+gUP3zxOFf
         Jh9A==
X-Gm-Message-State: AOAM533ISCUo1SF16u8I8lcLhxq8ynh78jZ5QOV7fxj8VKw9uDvR3JO1
        iMw+rmigOOfbslpJfSpFpSU=
X-Google-Smtp-Source: ABdhPJw+gVtujmUJXcukZcoVsYNBazBhc10yTi720d8alnJU65cq6VoqJsSBMAiclMF1yn96AJUxdg==
X-Received: by 2002:a17:90b:390d:: with SMTP id ob13mr9623573pjb.50.1634081815205;
        Tue, 12 Oct 2021 16:36:55 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:8c1a:acb2:4eff:5d13])
        by smtp.gmail.com with ESMTPSA id pi9sm4336676pjb.31.2021.10.12.16.36.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 16:36:54 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 26/46] scsi: isci: Switch to attribute groups
Date:   Tue, 12 Oct 2021 16:35:38 -0700
Message-Id: <20211012233558.4066756-27-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
In-Reply-To: <20211012233558.4066756-1-bvanassche@acm.org>
References: <20211012233558.4066756-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

struct device supports attribute groups directly but does not support
struct device_attribute directly. Hence switch to attribute groups.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/isci/init.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
index ffd33e5decae..aade707c5553 100644
--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -142,11 +142,13 @@ static ssize_t isci_show_id(struct device *dev, struct device_attribute *attr, c
 
 static DEVICE_ATTR(isci_id, S_IRUGO, isci_show_id, NULL);
 
-static struct device_attribute *isci_host_attrs[] = {
-	&dev_attr_isci_id,
+static struct attribute *isci_host_attrs[] = {
+	&dev_attr_isci_id.attr,
 	NULL
 };
 
+ATTRIBUTE_GROUPS(isci_host);
+
 static struct scsi_host_template isci_sht = {
 
 	.module				= THIS_MODULE,
@@ -173,7 +175,7 @@ static struct scsi_host_template isci_sht = {
 #ifdef CONFIG_COMPAT
 	.compat_ioctl			= sas_ioctl,
 #endif
-	.shost_attrs			= isci_host_attrs,
+	.shost_groups			= isci_host_groups,
 	.track_queue_depth		= 1,
 };
 

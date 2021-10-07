Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF364C433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:20:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D657E610A0
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:20:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240809AbhJGVWV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 17:22:21 -0400
Received: from mail-pg1-f169.google.com ([209.85.215.169]:40663 "EHLO
        mail-pg1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240366AbhJGVWU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 17:22:20 -0400
Received: by mail-pg1-f169.google.com with SMTP id h3so1035226pgb.7
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 14:20:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TFW3fCSqiu4zDVSFNIgjTISJtOE+9vyaQ1ogTut5TTE=;
        b=I0NRnCCM/qOAGG7cFG1h/JArWY1xyB9oL96bX6fUs5KQwQttUyUuMFcIAy64Zg4e43
         6eOeFR9nyB762guR4iOg7ka3Wlti2TBj2LaVkv8ThEf0RMmguhbtrmAdWaJC1O4Qpcq0
         Cdj8/kZjupHZJcbaPgdVRRfbWMvj8BA7iAF4T2YLdlNDfs9F7yorROyUA+BVrkl9+Ra/
         rbyKApnRftfV8q2PdDwunFRoDsB79QPm7cX19ftKxq8rFlK+0MsGHFiqXY6ZGbVwaQoi
         uax2S5vckkQPgOBVo+PS5KZ9l9+lWiWy/5GO1ekkafUa4DlwhBE41f1ecbEePeEbxnqw
         UqSg==
X-Gm-Message-State: AOAM530/iOrvt4HoZP8j5XRW85GElH01Xf9LOx2kaXoEiQ1kG0Xz5kkx
        dGkYy/OuaRiJMqRxeyV2fKM=
X-Google-Smtp-Source: ABdhPJy85nhRPyS+btlTsUeFFV/+VUXJ2Oh76notFUTMij4fQhvJEhxkrkw2RGBM/5NP5qOTJRt2eQ==
X-Received: by 2002:a62:1ac3:0:b0:44b:85d0:5a98 with SMTP id a186-20020a621ac3000000b0044b85d05a98mr6341224pfa.18.1633641626479;
        Thu, 07 Oct 2021 14:20:26 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id o2sm243290pgc.47.2021.10.07.14.20.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 14:20:26 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 34/46] scsi: sym53c500_cs: Switch to attribute groups
Date:   Thu,  7 Oct 2021 14:18:40 -0700
Message-Id: <20211007211852.256007-35-bvanassche@acm.org>
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
 drivers/scsi/pcmcia/sym53c500_cs.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/pcmcia/sym53c500_cs.c b/drivers/scsi/pcmcia/sym53c500_cs.c
index a366ff1a3959..e2d485e0e474 100644
--- a/drivers/scsi/pcmcia/sym53c500_cs.c
+++ b/drivers/scsi/pcmcia/sym53c500_cs.c
@@ -652,11 +652,20 @@ static struct device_attribute SYM53C500_pio_attr = {
 	.store = SYM53C500_store_pio,
 };
 
-static struct device_attribute *SYM53C500_shost_attrs[] = {
-	&SYM53C500_pio_attr,
+static struct attribute *SYM53C500_shost_attrs[] = {
+	&SYM53C500_pio_attr.attr,
 	NULL,
 };
 
+static const struct attribute_group SYM53C500_shost_attr_group = {
+	.attrs = SYM53C500_shost_attrs
+};
+
+static const struct attribute_group *SYM53C500_shost_groups[] = {
+	&SYM53C500_shost_attr_group,
+	NULL
+};
+
 /*
 *  scsi_host_template initializer
 */
@@ -671,7 +680,7 @@ static struct scsi_host_template sym53c500_driver_template = {
      .can_queue			= 1,
      .this_id			= 7,
      .sg_tablesize		= 32,
-     .shost_attrs		= SYM53C500_shost_attrs
+     .shost_groups		= SYM53C500_shost_groups
 };
 
 static int SYM53C500_config_check(struct pcmcia_device *p_dev, void *priv_data)

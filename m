Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 323B5C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:37:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0DFEF60E54
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:37:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236054AbhJLXjQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 19:39:16 -0400
Received: from mail-pj1-f45.google.com ([209.85.216.45]:51156 "EHLO
        mail-pj1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236216AbhJLXjP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Oct 2021 19:39:15 -0400
Received: by mail-pj1-f45.google.com with SMTP id k23so847286pji.0
        for <linux-scsi@vger.kernel.org>; Tue, 12 Oct 2021 16:37:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=o/KCwi6Jatb0W2TFXLG/+J51xr3UgQp4E1sK00H0/tY=;
        b=n/p0vvL8ez4dh3a2FEsFupH/JoN7bsnlJBrZziG/bbgEpfPj5z9/NKIp0gShVhJ6rw
         gOi8iv4eVkryZUObdwFfcT7qmbl0Lw3IhqZ7y2T1hpvUFCNtO6y3sb2042LAZmgOS6ta
         X7FJxwiLDK2iIcEyclpDRAhlmZ2QhU6HbFZHlPDctLqsGKfrAnGN0oKUHyu18AXtP62I
         4tGJtOTcgB5+nzDJHJByKIRd8aXNECwg6rDh5MfL8sbNg9kjpvm6Anch3cpc1WgZ6S73
         jxSyVohJWUMfywXqFL5vlvf3WlU60NnyjKoll7vctp2BzkI0zGjW+fmCquCxrGkGQzeb
         bHEQ==
X-Gm-Message-State: AOAM532PKUNzSa3A9/zTTq8VnZLbDKxDq8WpSn+98+Qth63y5HUKoNVv
        kJfUO9POxlgzOSOmAM26i8Q=
X-Google-Smtp-Source: ABdhPJzn44/KAVjo0SGbW+f3APwHroDTlnRYnVBaniCOlKDd6y40v2uMCnJt9DZrtXNt8lW+r8At3w==
X-Received: by 2002:a17:90a:191a:: with SMTP id 26mr9701595pjg.79.1634081832569;
        Tue, 12 Oct 2021 16:37:12 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:8c1a:acb2:4eff:5d13])
        by smtp.gmail.com with ESMTPSA id pi9sm4336676pjb.31.2021.10.12.16.37.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 16:37:12 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 34/46] scsi: sym53c500_cs: Switch to attribute groups
Date:   Tue, 12 Oct 2021 16:35:46 -0700
Message-Id: <20211012233558.4066756-35-bvanassche@acm.org>
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
 drivers/scsi/pcmcia/sym53c500_cs.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/pcmcia/sym53c500_cs.c b/drivers/scsi/pcmcia/sym53c500_cs.c
index a366ff1a3959..873d1121113a 100644
--- a/drivers/scsi/pcmcia/sym53c500_cs.c
+++ b/drivers/scsi/pcmcia/sym53c500_cs.c
@@ -652,11 +652,13 @@ static struct device_attribute SYM53C500_pio_attr = {
 	.store = SYM53C500_store_pio,
 };
 
-static struct device_attribute *SYM53C500_shost_attrs[] = {
-	&SYM53C500_pio_attr,
+static struct attribute *SYM53C500_shost_attrs[] = {
+	&SYM53C500_pio_attr.attr,
 	NULL,
 };
 
+ATTRIBUTE_GROUPS(SYM53C500_shost);
+
 /*
 *  scsi_host_template initializer
 */
@@ -671,7 +673,7 @@ static struct scsi_host_template sym53c500_driver_template = {
      .can_queue			= 1,
      .this_id			= 7,
      .sg_tablesize		= 32,
-     .shost_attrs		= SYM53C500_shost_attrs
+     .shost_groups		= SYM53C500_shost_groups
 };
 
 static int SYM53C500_config_check(struct pcmcia_device *p_dev, void *priv_data)

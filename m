Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C482EC433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 20:25:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AAB5D610E7
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 20:25:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242698AbhJHU1L (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Oct 2021 16:27:11 -0400
Received: from mail-pl1-f175.google.com ([209.85.214.175]:43739 "EHLO
        mail-pl1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242880AbhJHU1G (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Oct 2021 16:27:06 -0400
Received: by mail-pl1-f175.google.com with SMTP id y1so6835726plk.10
        for <linux-scsi@vger.kernel.org>; Fri, 08 Oct 2021 13:25:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=o/KCwi6Jatb0W2TFXLG/+J51xr3UgQp4E1sK00H0/tY=;
        b=CsIXn0LVaDuIGk5mo/JdkW+REGF4nCNTiDZNeiCxHcNgbUXH/bRoBzrms9guB6kYec
         McPz9vEKMS6VE6aWx2phlea2EGSX6H/zIvgIZHa1OWiOHuGOEz1gWhH7Y7GPA9ucMPZA
         O+TOL4HEjckUbZVxZb9t/uDBm8dETfNu8ofeRdUfvFDTXFcDDLY1JAAOGk0WS3cBa5D8
         NTVsgpzVRGYQGCnpFFQsSwwssI7SQNnKQ0RPKB4RsOAXpvku7yAlfPJY8rmwHPP+73at
         UCJRC7IH4itR4LmnKSpTkxRhOvruwkGScsfFXt0JYyzdstP3HTsoVlbyYI5RM/1qAvZ2
         HBgg==
X-Gm-Message-State: AOAM530j/nA3gD6kT9tYYmFxGaFVurX4ZZhvSsbDGhD7prRyBdn22vKV
        5oVckaIRisNWupCR7H/tNk4=
X-Google-Smtp-Source: ABdhPJx2+A2r7Nc/Wf/kuB/OC7QZ03J+ssH6gnCRduD7OvTwsdZyVc6/P60Iy1TmBLFjgK1Q9PT5OA==
X-Received: by 2002:a17:902:db0e:b0:13e:f4d3:84c with SMTP id m14-20020a170902db0e00b0013ef4d3084cmr11132866plx.2.1633724710339;
        Fri, 08 Oct 2021 13:25:10 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a8e9:7950:57f8:970])
        by smtp.gmail.com with ESMTPSA id x21sm170858pfa.186.2021.10.08.13.25.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 13:25:09 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 34/46] scsi: sym53c500_cs: Switch to attribute groups
Date:   Fri,  8 Oct 2021 13:23:41 -0700
Message-Id: <20211008202353.1448570-35-bvanassche@acm.org>
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

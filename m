Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC90EC4332F
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 20:24:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA988610E5
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 20:24:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242410AbhJHU0C (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Oct 2021 16:26:02 -0400
Received: from mail-pg1-f177.google.com ([209.85.215.177]:38448 "EHLO
        mail-pg1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242293AbhJHU0A (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Oct 2021 16:26:00 -0400
Received: by mail-pg1-f177.google.com with SMTP id s75so4159436pgs.5
        for <linux-scsi@vger.kernel.org>; Fri, 08 Oct 2021 13:24:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4mdX3hkvfoYoF2fIUrn8m6GML1XzKXIEX378yasu53k=;
        b=s2ZcP35XRFnOWfMdjKbOjahN/MKhUbFyQ2zvhua5UInJJo4qcZcyp7KWZSlpYQUkDz
         qYkEnzF2fvBpMqiSt3LPrC8cRDPp+reRoP9swcANYm3Evo8rwg4L8qxA/HshxwDGohKi
         5KKu4iQVdrgHP2PQMGaKYNovK2eAL7S3TQj3DFquBJfa0WnMILrBCW6GvXL8/IGPAawU
         tlwxB/IbmO7wLs38aW5YQ1KOVi3gnBWKZ9XuA4+3PR8VTiKnrCxqOcgc14HR4qU9Vm/Q
         tqUiZI8AfVf6TYAG1Vb2J0iOQCFXsA1NJu53jNxh/agUi7FwqsVHsNgJfxONPZw3E88e
         ptNQ==
X-Gm-Message-State: AOAM53323f23cztNJDNUlKlvD876DJu6v41txFgRBFOxwfzWCzOpjh4V
        bakZTmrqGTe6/XhESE1fCac=
X-Google-Smtp-Source: ABdhPJyEfTnMyPebJBxHqS+So5tumw9pv3ucLnGx9/rYIkd5rIJuL9+/P7wZX4NA2n6z7pzlM4zg7g==
X-Received: by 2002:a62:5297:0:b0:3f4:263a:b078 with SMTP id g145-20020a625297000000b003f4263ab078mr12284853pfb.20.1633724644541;
        Fri, 08 Oct 2021 13:24:04 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a8e9:7950:57f8:970])
        by smtp.gmail.com with ESMTPSA id x21sm170858pfa.186.2021.10.08.13.24.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 13:24:03 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH v3 03/46] firewire: sbp2: Switch to attribute groups
Date:   Fri,  8 Oct 2021 13:23:10 -0700
Message-Id: <20211008202353.1448570-4-bvanassche@acm.org>
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
 drivers/firewire/sbp2.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/firewire/sbp2.c b/drivers/firewire/sbp2.c
index 4d5054211550..c2a9d7d0bd1e 100644
--- a/drivers/firewire/sbp2.c
+++ b/drivers/firewire/sbp2.c
@@ -1578,11 +1578,13 @@ static ssize_t sbp2_sysfs_ieee1394_id_show(struct device *dev,
 
 static DEVICE_ATTR(ieee1394_id, S_IRUGO, sbp2_sysfs_ieee1394_id_show, NULL);
 
-static struct device_attribute *sbp2_scsi_sysfs_attrs[] = {
-	&dev_attr_ieee1394_id,
+static struct attribute *sbp2_scsi_sysfs_attrs[] = {
+	&dev_attr_ieee1394_id.attr,
 	NULL
 };
 
+ATTRIBUTE_GROUPS(sbp2_scsi_sysfs);
+
 static struct scsi_host_template scsi_driver_template = {
 	.module			= THIS_MODULE,
 	.name			= "SBP-2 IEEE-1394",
@@ -1595,7 +1597,7 @@ static struct scsi_host_template scsi_driver_template = {
 	.sg_tablesize		= SG_ALL,
 	.max_segment_size	= SBP2_MAX_SEG_SIZE,
 	.can_queue		= 1,
-	.sdev_attrs		= sbp2_scsi_sysfs_attrs,
+	.sdev_groups		= sbp2_scsi_sysfs_groups,
 };
 
 MODULE_AUTHOR("Kristian Hoegsberg <krh@bitplanet.net>");

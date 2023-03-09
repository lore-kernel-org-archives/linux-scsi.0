Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87E67C61DA4
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 19:31:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbjCITbU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 14:31:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbjCITah (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 14:30:37 -0500
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 847AE28D08
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 11:29:46 -0800 (PST)
Received: by mail-pj1-f54.google.com with SMTP id p3-20020a17090ad30300b0023a1cd5065fso2966346pju.0
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2023 11:29:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678390186;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uNBZEXnuNLSbR6kjSK5gewVoRiq0PJ3JQYeI9QvkyZY=;
        b=ITzLtpIC/nT2xhlpmC87uxdeg7lRr460mJdoEkzp8V6hejxJXp23QWnbYf/fhpezEL
         fjpJsKWPNrFwpM9xGTwWWN55cOe8bowO3Ff1o5yNb8k0273I6JtiuXIaeU8iMRX/FIT0
         xJ7Ni+QZ2nd2M9NrktuKIEm3gWaCDd4u7BVizUcAzB2mOcTgg/I+ucAhKQhU7fGB3J18
         RvHJVxdn9rktkF0LIVAv9oN5tN49h6Z5pFrEpX31HcYdCqVJvWJwBEC/2y9soORB3SiL
         Vz9xD22ENWOfm/0TBeS2O6buxqfWdAjrsZtqDkk1TzwM/X0t9WrJiqBrvWl5IhYHBJ8j
         d7SQ==
X-Gm-Message-State: AO0yUKUBYtvCnl6UmaMJ6+4L2WxM+OBSDfEwfL0FzloRyYEDChMc+B2r
        V5lezlTcThTLedmcJ2kQexc=
X-Google-Smtp-Source: AK7set9Q5gFa04jyvDVBh5OKCDvue7sfNTyjMYnl+zBL4+KUdagRaOMo5YIHceMBKArVcJmAqfGoWw==
X-Received: by 2002:a05:6a20:8e28:b0:c6:6fef:545c with SMTP id y40-20020a056a208e2800b000c66fef545cmr25279696pzj.21.1678390185951;
        Thu, 09 Mar 2023 11:29:45 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bf9f:35c8:4915:cb24])
        by smtp.gmail.com with ESMTPSA id j24-20020a62b618000000b0058d8f23af26sm11570955pff.157.2023.03.09.11.29.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 11:29:45 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Finn Thain <fthain@linux-m68k.org>
Subject: [PATCH v2 62/82] scsi: pcmcia-sym53c500: Declare SCSI host template const
Date:   Thu,  9 Mar 2023 11:25:54 -0800
Message-Id: <20230309192614.2240602-63-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
In-Reply-To: <20230309192614.2240602-1-bvanassche@acm.org>
References: <20230309192614.2240602-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it explicit that the SCSI host template is not modified.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/pcmcia/sym53c500_cs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/pcmcia/sym53c500_cs.c b/drivers/scsi/pcmcia/sym53c500_cs.c
index 5d7dfefd6f6c..278c78d066c4 100644
--- a/drivers/scsi/pcmcia/sym53c500_cs.c
+++ b/drivers/scsi/pcmcia/sym53c500_cs.c
@@ -668,7 +668,7 @@ ATTRIBUTE_GROUPS(SYM53C500_shost);
 /*
 *  scsi_host_template initializer
 */
-static struct scsi_host_template sym53c500_driver_template = {
+static const struct scsi_host_template sym53c500_driver_template = {
      .module			= THIS_MODULE,
      .name			= "SYM53C500",
      .info			= SYM53C500_info,
@@ -702,7 +702,7 @@ SYM53C500_config(struct pcmcia_device *link)
 	int ret;
 	int irq_level, port_base;
 	struct Scsi_Host *host;
-	struct scsi_host_template *tpnt = &sym53c500_driver_template;
+	const struct scsi_host_template *tpnt = &sym53c500_driver_template;
 	struct sym53c500_data *data;
 
 	dev_dbg(&link->dev, "SYM53C500_config\n");

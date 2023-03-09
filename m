Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF6D2C61DA4
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 19:28:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230427AbjCIT2X (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 14:28:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230165AbjCIT2G (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 14:28:06 -0500
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D73255A0
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 11:28:04 -0800 (PST)
Received: by mail-pg1-f175.google.com with SMTP id h31so1714856pgl.6
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2023 11:28:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678390084;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vZ5GgqrDyGWwIxYM6EGxbvTY6mYY1oAJ1o0rPWwJtYA=;
        b=NI2KHP0vO8hOkX6iU+UwUjTawPleWOXw4H/7YIeSlifrVQ3APz9HORpseUhDhTmsaK
         6fTswa0NaLDgH78GqrYc9Iee7E1883KLh6BGw+W6Rus9CA3Ier2wzyTFKZRyEp0MUCR0
         FpcbqQgKjXWasLQ5O1GcqC9TBPNKT0VqophPqghgZ95WaZy3fHdeP5ejMxpji2bUF+Rb
         sw/wLamMDxbfQo93G2h/xnU1+qgEENMq+IYtpUQpj/yc5UvklRPAE6XYWZx3puZyU5bu
         i4qhMLOIbPWFmBp5qMScPSDayqvAWJAkqGf9dQqsdzKlkpBmowyo4rzzf4xl5AvdYabP
         sPGw==
X-Gm-Message-State: AO0yUKVbCxRM3nKRPkaHxESecsg6Hm2jvlewBBwJntUvRJtO6UGV+uqK
        cQin8n3WQW9hCUqlbc5ajJvmlVAxdjn4BQ==
X-Google-Smtp-Source: AK7set9IYxbBnryhxpWvUntjjR70iML94TmaeWjpef8QApw/Ijxm317ubrI9/jy5A2J3l/cx2n9/5g==
X-Received: by 2002:a62:2586:0:b0:5d3:81b4:db5c with SMTP id l128-20020a622586000000b005d381b4db5cmr2901972pfl.4.1678390084278;
        Thu, 09 Mar 2023 11:28:04 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bf9f:35c8:4915:cb24])
        by smtp.gmail.com with ESMTPSA id j24-20020a62b618000000b0058d8f23af26sm11570955pff.157.2023.03.09.11.28.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 11:28:03 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Russell King <linux@armlinux.org.uk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 26/82] scsi: eesox: Declare SCSI host template const
Date:   Thu,  9 Mar 2023 11:25:18 -0800
Message-Id: <20230309192614.2240602-27-bvanassche@acm.org>
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
 drivers/scsi/arm/eesox.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/arm/eesox.c b/drivers/scsi/arm/eesox.c
index 6f374af9f45f..b3ec7635bc72 100644
--- a/drivers/scsi/arm/eesox.c
+++ b/drivers/scsi/arm/eesox.c
@@ -473,7 +473,7 @@ static ssize_t eesoxscsi_store_term(struct device *dev, struct device_attribute
 static DEVICE_ATTR(bus_term, S_IRUGO | S_IWUSR,
 		   eesoxscsi_show_term, eesoxscsi_store_term);
 
-static struct scsi_host_template eesox_template = {
+static const struct scsi_host_template eesox_template = {
 	.module				= THIS_MODULE,
 	.show_info			= eesoxscsi_show_info,
 	.write_info			= eesoxscsi_set_proc_info,

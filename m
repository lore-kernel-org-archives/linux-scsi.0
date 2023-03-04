Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC47CC61DA4
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Mar 2023 00:32:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229883AbjCDAcw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 19:32:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbjCDAcm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 19:32:42 -0500
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3063C6A1F3
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2023 16:32:42 -0800 (PST)
Received: by mail-pl1-f177.google.com with SMTP id ky4so4557878plb.3
        for <linux-scsi@vger.kernel.org>; Fri, 03 Mar 2023 16:32:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677889962;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dtvaziFz+alOfUQZbNe+VAlPBd5fDCw1fGTb/wB6Zxw=;
        b=mCkcrBJAQe6NDGHRqqPlUuBJ+bQcqIPRz3qwYj6nSrrzBsirf0EgIjIOWRbp6WtFO2
         hU/RtIgCJc98sA5nW0uhiUQFojZQIAOHoac/T8uUBUq6e4Du8mF32zWyWnOC0t6toLMC
         0LsYFfRjD3nQco8i1dAXveJTTDogMfRXRAzLPASvbDhR1Ft8RuziTEYthhyj3AtZ/dqy
         2O7KhX9W/5cA5F7p3dxBGXPJTU68jo6Uti63fLHbo5D9ccBTPQg26GKZObfWbxEEGhPg
         agINbdFF/QdxKXUtCuxxuRwIBl9+O19Z1KUp4HMQNWGjMe+SIEFParBakoFdVPZALG+X
         KT9Q==
X-Gm-Message-State: AO0yUKXzBWuZ9EvSU7U7Hqr5YoX3HeKHZC9M6zN4aA824TMzle0YE2LL
        OlCNHHtn8+XcJP9FMXEokt8=
X-Google-Smtp-Source: AK7set8dlpSWeDcuI9Z6JW28QEkIsoNw5oyZ50TZIi8QiJNbDC+qgaIENU6RK5gQFrHXkc2Z4kX84g==
X-Received: by 2002:a17:902:c412:b0:19c:be03:d18b with SMTP id k18-20020a170902c41200b0019cbe03d18bmr5140538plk.22.1677889961859;
        Fri, 03 Mar 2023 16:32:41 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:efb8:1cdc:a06f:1b53])
        by smtp.gmail.com with ESMTPSA id kk15-20020a170903070f00b00189743ed3b6sm2071078plb.64.2023.03.03.16.32.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 16:32:40 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Russell King <linux@armlinux.org.uk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 28/81] scsi: powertec: Declare SCSI host template const
Date:   Fri,  3 Mar 2023 16:30:10 -0800
Message-Id: <20230304003103.2572793-29-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
In-Reply-To: <20230304003103.2572793-1-bvanassche@acm.org>
References: <20230304003103.2572793-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it explicit that the SCSI host template is not modified.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/arm/powertec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/arm/powertec.c b/drivers/scsi/arm/powertec.c
index 7586d2a03812..3b5991427886 100644
--- a/drivers/scsi/arm/powertec.c
+++ b/drivers/scsi/arm/powertec.c
@@ -279,7 +279,7 @@ powertecscsi_store_term(struct device *dev, struct device_attribute *attr, const
 static DEVICE_ATTR(bus_term, S_IRUGO | S_IWUSR,
 		   powertecscsi_show_term, powertecscsi_store_term);
 
-static struct scsi_host_template powertecscsi_template = {
+static const struct scsi_host_template powertecscsi_template = {
 	.module				= THIS_MODULE,
 	.show_info			= powertecscsi_show_info,
 	.write_info			= powertecscsi_set_proc_info,

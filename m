Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E1D7C61DA3
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Mar 2023 00:32:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbjCDAcu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 19:32:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229888AbjCDAck (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 19:32:40 -0500
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 422926A1DE
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2023 16:32:38 -0800 (PST)
Received: by mail-pj1-f50.google.com with SMTP id h17-20020a17090aea9100b0023739b10792so3937965pjz.1
        for <linux-scsi@vger.kernel.org>; Fri, 03 Mar 2023 16:32:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677889958;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vZ5GgqrDyGWwIxYM6EGxbvTY6mYY1oAJ1o0rPWwJtYA=;
        b=y7eXx3klMOvM3NHOcAHScfGHGyxwJQeBDMfZYxcWA18zyG15std9uM7Xe6KexhMI72
         TqjxFgCXNC4UGE1u6vEMkg9nY0gdMb2vD49XhdM+cqUX8t3K9vezngkh1nX6EADAdwhM
         VVzFSThZE9hH4WSUsNoTCOv6ELxeO/zNCA1poaxTjdsxI0QN3Q5oJ0bhQc8WgJesoJ5w
         M/9+lMUEmKCuyN8hNtL5cPAjAxVgo2JOtOh13B8o6VYXIljty0gxSjYFNMQ5YTAQL09e
         o20S5HEeGhtfY85zW4RY/e7LKYkqoHW6S4VLaAeMVFSTH+6DgCJBB4dwyi4K9aVSsPf8
         9oCw==
X-Gm-Message-State: AO0yUKUkvItngQWdLAYqE9nw73apiGNpVC6T78/G5hdRl0JpshKdHROh
        XJlHx+xoDH4lvFiFgEx9cQ0=
X-Google-Smtp-Source: AK7set/dDypiC/uSqaqnPJoJ04L+zczVpKjN2XFiROhVbmFyng2Q2KldjrQi94fckl1jqEhQnevzOw==
X-Received: by 2002:a17:902:9f8e:b0:19d:7c2:3a47 with SMTP id g14-20020a1709029f8e00b0019d07c23a47mr3302052plq.67.1677889957725;
        Fri, 03 Mar 2023 16:32:37 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:efb8:1cdc:a06f:1b53])
        by smtp.gmail.com with ESMTPSA id kk15-20020a170903070f00b00189743ed3b6sm2071078plb.64.2023.03.03.16.32.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 16:32:36 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Russell King <linux@armlinux.org.uk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 26/81] scsi: eesox: Declare SCSI host template const
Date:   Fri,  3 Mar 2023 16:30:08 -0800
Message-Id: <20230304003103.2572793-27-bvanassche@acm.org>
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

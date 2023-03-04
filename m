Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD43BC64EC4
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Mar 2023 00:35:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbjCDAfZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 19:35:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbjCDAev (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 19:34:51 -0500
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65F60AD32
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2023 16:34:17 -0800 (PST)
Received: by mail-pj1-f46.google.com with SMTP id kb15so4379633pjb.1
        for <linux-scsi@vger.kernel.org>; Fri, 03 Mar 2023 16:34:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677890053;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T6GsPg2I0LZ32kZN7a19j6uU3awmr2LjY8FTtu+c/bA=;
        b=XqRIEqDjKH2OGuB+6IyPyHHLy1kv26EW14c1rkWQSauZOU4zhb86+RoOy01Dh46Evl
         0wfwzFq7b3ChBq4HgzlKg9bSJYXQSGMM5Yo+hM/KikrkOmM2jWbrXvLxBsY40zKHcFiH
         gDz4pT8N+3llF8OQ01+xpjdrYxNWj/1QZpasB9F7g9WPANGKc6Awk0p3TcCV0lPNkOss
         C3TTWpKBg5ET+MFPIKTBx40LSWJQoYI8/klbiLF44ztljr9I/Wu+TcgY2dewy7ONoxOb
         3kY+X5QKCGOjG4I25+L1BmkJqqYG4anERXw1K7QiByvOERDIy6y2hmTNr1dZZjhMUpaP
         V6Dg==
X-Gm-Message-State: AO0yUKW93oxHEx61LMk/EqM+tQGPOMr/lgUS/vdI0vWNU7pV+WsxjeK2
        gXlfKnf2cLbGm00bG8FnO/vqNRUnRUTXwA==
X-Google-Smtp-Source: AK7set96nZHXBR3gO03DplByYMf2T5LI8QJHTqRKBAQ5ymE52e0cO5xLdTJyLewQRj7ffhcx9aWJug==
X-Received: by 2002:a17:902:8307:b0:19c:fa22:e98e with SMTP id bd7-20020a170902830700b0019cfa22e98emr3183717plb.33.1677890053463;
        Fri, 03 Mar 2023 16:34:13 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:efb8:1cdc:a06f:1b53])
        by smtp.gmail.com with ESMTPSA id kk15-20020a170903070f00b00189743ed3b6sm2071078plb.64.2023.03.03.16.34.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 16:34:12 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 62/81] scsi: pcmcia-pm8001: Declare SCSI host template const
Date:   Fri,  3 Mar 2023 16:30:44 -0800
Message-Id: <20230304003103.2572793-63-bvanassche@acm.org>
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
 drivers/scsi/pm8001/pm8001_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 7e589fe3e010..8b9490011e36 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -96,7 +96,7 @@ static void pm8001_map_queues(struct Scsi_Host *shost)
 /*
  * The main structure which LLDD must register for scsi core.
  */
-static struct scsi_host_template pm8001_sht = {
+static const struct scsi_host_template pm8001_sht = {
 	.module			= THIS_MODULE,
 	.name			= DRV_NAME,
 	.proc_name		= DRV_NAME,

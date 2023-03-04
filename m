Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A50AC61DA3
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Mar 2023 00:32:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbjCDAcV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 19:32:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbjCDAcM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 19:32:12 -0500
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 965A26A1D0
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2023 16:32:11 -0800 (PST)
Received: by mail-pl1-f171.google.com with SMTP id p20so4493606plw.13
        for <linux-scsi@vger.kernel.org>; Fri, 03 Mar 2023 16:32:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677889931;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/+RYutzjDsUywQB4KXngUgj4Hi0F5p617CUW9BmtH8E=;
        b=R44FWXwI/JeLprz08FzujDBDhg1YU7NEhEb1VSKWjPHePIA91HmxfCs/N1FrRyIH6F
         E5yamwKwJg82ECXcQv1jS3nFwk8Ey6SEXd0iGA073l3FZBW3Wta/963QIP1IeXB88Fl3
         Z4FQCurLi9CoTgymsECV2HzL5q6DGFLf3nqT7hYomaxCXmjDRDH8QnJU1anyg1DO20Ki
         gs/kml4zNDM6YDnCFzndd3PFHntkbJst/kqqqp1tv3w+4n1zhXQyedV+dwkUrPDaL/P+
         VeqXq8JNaX2tiQKVoJLwV89XFty7MFtrHYo31CeXn87bbRCPmdQ+BEWe4JswCVPB5R/F
         jujQ==
X-Gm-Message-State: AO0yUKX4/qDOX/ZHPG0buZAEwFwf5sWk61JgtFFg+Ulv0Mc6Wt4TypVm
        BZO4oqve1OZOkTSD1347JSMKP7lskxo36A==
X-Google-Smtp-Source: AK7set86mv02kqKjyJPtHFHhwJLee/rLw/c7NRzu8eSfHD2Wl1aL98m1KZ64H0bgTOKKmsYn7BrldQ==
X-Received: by 2002:a17:902:b68a:b0:19e:98fe:856b with SMTP id c10-20020a170902b68a00b0019e98fe856bmr1871114pls.24.1677889931107;
        Fri, 03 Mar 2023 16:32:11 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:efb8:1cdc:a06f:1b53])
        by smtp.gmail.com with ESMTPSA id kk15-20020a170903070f00b00189743ed3b6sm2071078plb.64.2023.03.03.16.32.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 16:32:10 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "Juergen E. Fischer" <fischer@norbit.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 18/81] scsi: aha152x: Declare SCSI host template const
Date:   Fri,  3 Mar 2023 16:30:00 -0800
Message-Id: <20230304003103.2572793-19-bvanassche@acm.org>
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
 drivers/scsi/aha152x.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index caeebfb67149..055adb349b0e 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -400,7 +400,7 @@ MODULE_DEVICE_TABLE(isapnp, id_table);
 
 #endif /* !AHA152X_PCMCIA */
 
-static struct scsi_host_template aha152x_driver_template;
+static const struct scsi_host_template aha152x_driver_template;
 
 /*
  * internal states of the host
@@ -2946,7 +2946,7 @@ static int aha152x_adjust_queue(struct scsi_device *device)
 	return 0;
 }
 
-static struct scsi_host_template aha152x_driver_template = {
+static const struct scsi_host_template aha152x_driver_template = {
 	.module				= THIS_MODULE,
 	.name				= AHA152X_REVID,
 	.proc_name			= "aha152x",

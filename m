Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66775C61DA4
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Mar 2023 00:33:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbjCDAdb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 19:33:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbjCDAdM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 19:33:12 -0500
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80F3E234DB
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2023 16:33:01 -0800 (PST)
Received: by mail-pl1-f172.google.com with SMTP id p6so4605599plf.0
        for <linux-scsi@vger.kernel.org>; Fri, 03 Mar 2023 16:33:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677889981;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ldCwiaYTLduiQcwSYGjGWFRviZrHcq79whkQrMLz5c8=;
        b=3lLHpvvHQ2FtKbeTHghS/zcx4B7FP+EHrdLkmxgOnpmLafPSVw1krmgbRxNlZgqnDv
         deWCsIZDZikygri6J9Zaymg5PBf17jrtz864skIg8o6Qrq2rU+Bo+JKC5qs/Mi9u8KAH
         9GdO+1meiyC4z0JbVcWQy14jXxB+hDeN9x7j0/QFz+4HUPIitUeS0JTD3JLe/LX5HiCC
         AGVl0GdiJSNxP1CbvoMnn+mX3xdREhafEWPApn/4BFkmwdpSINygPDT/QxuuVEh4LxgZ
         96DjvNOJTlxnC/C1Mgq7sr6Ovs/qn/6nEeWsHXoNNUvFuHOYDy/qQEE1g2mNGFcbg0kE
         EfHw==
X-Gm-Message-State: AO0yUKXfZqwU9tGAZBncSXEffLqSKf9BMdWYexGlpBmHecZmAhTyi6p4
        i2ZSDUOcdmkDBhe/nyzrP9Wqz/q/ROtipQ==
X-Google-Smtp-Source: AK7set9bgFi6+Z0hFgUu+cWoRQyYQUpppgA5ErQUFhmKeF9aJ49rAnvp8cSARl5T2G5aGZl3g8R+bg==
X-Received: by 2002:a17:903:1112:b0:19c:f1bd:e915 with SMTP id n18-20020a170903111200b0019cf1bde915mr4539967plh.25.1677889980840;
        Fri, 03 Mar 2023 16:33:00 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:efb8:1cdc:a06f:1b53])
        by smtp.gmail.com with ESMTPSA id kk15-20020a170903070f00b00189743ed3b6sm2071078plb.64.2023.03.03.16.32.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 16:32:59 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 35/81] scsi: fcoe: Declare SCSI host template const
Date:   Fri,  3 Mar 2023 16:30:17 -0800
Message-Id: <20230304003103.2572793-36-bvanassche@acm.org>
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
 drivers/scsi/fcoe/fcoe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 38774a272e62..f1429f270170 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -260,7 +260,7 @@ static struct fc_function_template fcoe_vport_fc_functions = {
 	.bsg_request = fc_lport_bsg_request,
 };
 
-static struct scsi_host_template fcoe_shost_template = {
+static const struct scsi_host_template fcoe_shost_template = {
 	.module = THIS_MODULE,
 	.name = "FCoE Driver",
 	.proc_name = FCOE_NAME,

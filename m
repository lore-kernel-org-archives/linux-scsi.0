Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18C84C61DA4
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Mar 2023 00:33:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbjCDAdR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 19:33:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229956AbjCDAc5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 19:32:57 -0500
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D62D246A9
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2023 16:32:55 -0800 (PST)
Received: by mail-pj1-f41.google.com with SMTP id kb15so4377615pjb.1
        for <linux-scsi@vger.kernel.org>; Fri, 03 Mar 2023 16:32:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677889975;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k9EbEznef8iJjMvb3ab9roSVdm2qWqXIE3r6q0CuMcY=;
        b=uwwBdQLbhi/jd+dd6h0Lkbfqz95ZwvWz7GNk9eoCUppM3b6z1kLsIyukG+KnimfhDm
         X7WVcieBuFHK7YjrnzGaKKCwaq7AYL7klZix6R99erKNEEsGbD/1di+KoMOxO3sTa/WT
         MLNyQfLER5P1Cx4dt8JMsBku3A9w5Wm4HfRxkbilVk6FJxjC1G5CSbPh+/w8DPclUWRh
         gdXVXVDRIRZ/1h4OI2OWFNxVdz4fds9WVK6xFtTc4EaNm3JqxbNAYJfNRFfWOdZOkMUj
         kaImWHZiuFd3bg1th4pl5/Wv44YJ4xOz7y5WFt1+Sjj1o4jdam3BtE1Qr5Go8HtY1nHI
         CPtA==
X-Gm-Message-State: AO0yUKXJdYlDYhS/j4dVetOy7RoVQ6c+vjG28LLtneNvJQRLVbtk8oJv
        yDuIKGAIZj/VWqXWi3DWjNMv/ZORQcSvuw==
X-Google-Smtp-Source: AK7set+3qwcaa/6720XQ22e/l7xeg59o4jyjfgevVCgSzf89nlzDx0pCkNKkBsS8ojeq5KUA7p3+Kg==
X-Received: by 2002:a17:903:230a:b0:19a:7217:32a9 with SMTP id d10-20020a170903230a00b0019a721732a9mr3550025plh.26.1677889975265;
        Fri, 03 Mar 2023 16:32:55 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:efb8:1cdc:a06f:1b53])
        by smtp.gmail.com with ESMTPSA id kk15-20020a170903070f00b00189743ed3b6sm2071078plb.64.2023.03.03.16.32.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 16:32:54 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        James Smart <james.smart@broadcom.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 32/81] scsi: elx: efct: Declare SCSI host template const
Date:   Fri,  3 Mar 2023 16:30:14 -0800
Message-Id: <20230304003103.2572793-33-bvanassche@acm.org>
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
 drivers/scsi/elx/efct/efct_xport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/elx/efct/efct_xport.c b/drivers/scsi/elx/efct/efct_xport.c
index 9495cedcc0b9..cf4dced20b8b 100644
--- a/drivers/scsi/elx/efct/efct_xport.c
+++ b/drivers/scsi/elx/efct/efct_xport.c
@@ -10,7 +10,7 @@
 static struct dentry *efct_debugfs_root;
 static atomic_t efct_debugfs_count;
 
-static struct scsi_host_template efct_template = {
+static const struct scsi_host_template efct_template = {
 	.module			= THIS_MODULE,
 	.name			= EFCT_DRIVER_NAME,
 	.supported_mode		= MODE_TARGET,

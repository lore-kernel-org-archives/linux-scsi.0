Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 600E1C61DA3
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Mar 2023 00:33:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbjCDAdl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 19:33:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229976AbjCDAdP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 19:33:15 -0500
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B79C2202A
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2023 16:33:03 -0800 (PST)
Received: by mail-pj1-f50.google.com with SMTP id cp7-20020a17090afb8700b0023756229427so7883422pjb.1
        for <linux-scsi@vger.kernel.org>; Fri, 03 Mar 2023 16:33:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677889983;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JCDnsBDyD5KdL/cOWwSjhVPjFE5ySWXB1GfjV8JeIjI=;
        b=kTAsmflUZZbObRTIUUiuk6RbsHgGpQC0DwpiH5WwWfWoOJTbxzm9PgAT+WBTFNp28d
         2QF6qM/MMc3FXCcncrBBw+dzhSYQ3S/T+gHnUKw5D0wLknY8+RoKr5tfZ3taMM/WXFg5
         czVhvtqr9NM21OCp4BmBwBnm8vsv1yUymYQ1kax43/SribCMetSYOV3WBU4v5iuDtW44
         VcvYctMW5o2y1+vMD+2cESsapp/zUkjUSeHM0xEytFZlijIm+PTF40cP0FNFU40lrcNg
         uaAia216b2dUkYQ5ETtzJkR7TmXXHvX2YigGGrXPNICvTp+6eirpX5wGfii6UcRMVFat
         4Epw==
X-Gm-Message-State: AO0yUKXCLII22bege3vfuEI9rW7t/LWblYn5QlHmRdDL3q+Kp4NV2h8u
        8VGG2QU4ePGdwYmKrzgy4i9JBk/O88tcAA==
X-Google-Smtp-Source: AK7set+sPaFGX5jXwOx6YE9UUiNbNjUOWiG8OFNW19Avvj5XxWm8ruDRBFh3a8sXAnfh3yzOt1Q3kA==
X-Received: by 2002:a17:902:cec1:b0:19c:a86d:b34e with SMTP id d1-20020a170902cec100b0019ca86db34emr4667183plg.4.1677889982691;
        Fri, 03 Mar 2023 16:33:02 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:efb8:1cdc:a06f:1b53])
        by smtp.gmail.com with ESMTPSA id kk15-20020a170903070f00b00189743ed3b6sm2071078plb.64.2023.03.03.16.33.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 16:33:02 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Satish Kharat <satishkh@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 36/81] scsi: fnic: Declare host template const
Date:   Fri,  3 Mar 2023 16:30:18 -0800
Message-Id: <20230304003103.2572793-37-bvanassche@acm.org>
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
 drivers/scsi/fnic/fnic_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index 1077110ab273..984bc5fc55e2 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -95,7 +95,7 @@ static int fnic_slave_alloc(struct scsi_device *sdev)
 	return 0;
 }
 
-static struct scsi_host_template fnic_host_template = {
+static const struct scsi_host_template fnic_host_template = {
 	.module = THIS_MODULE,
 	.name = DRV_NAME,
 	.queuecommand = fnic_queuecommand,

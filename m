Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37552C61DA4
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Mar 2023 00:35:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbjCDAfX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 19:35:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbjCDAet (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 19:34:49 -0500
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7627976C
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2023 16:34:15 -0800 (PST)
Received: by mail-pl1-f179.google.com with SMTP id a2so4552018plm.4
        for <linux-scsi@vger.kernel.org>; Fri, 03 Mar 2023 16:34:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677890055;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C5gBIhC8WBeIKUevKHd/72SKoMXkdl9EMvIEJ27ZMNk=;
        b=NCJkGh+FGraofB56T6s5vAqgMeI9LrwtSEYSpgntYO1Z4v/NuBc3EaZxcUZVSIRjot
         c5uTG6aRAXjwk30zqO7F2UwjjhtW0NJ5WBOBg8r/yVGj8ULEbk5gaGtmFmnzZpxOufeq
         mYQV8qGnc/fBi3mTmn5hLshiU5TWlMaljmzZcmeH7PRDqJqx9v5A8fxNqWf5MImrGzIu
         vr5aher4QrZJPHw9HkWt00fX7HHNiXIEaSw6oAzHWpGmQsb5+YA4ATgvoZXPrUF2wq9V
         sO6UqJe5B8L8f8nOxyBYRNp4E9GY6FFYgNB0Bd3p87C59j7xDcQgCzv/5JcH2g5PfVrw
         jijQ==
X-Gm-Message-State: AO0yUKXO4Li4mRB3jaRpfRvfKIytN/jt9S3dsTUh2G2SmL6Mp7LeJqmA
        crrxc0/XiSLs8+zHFARg0vw=
X-Google-Smtp-Source: AK7set+WaJ2OthC+c2QNYTZ6TJ4A2qlFYUR23I9BlSYJQcVVUfOVPLeYAfPy+SNvUvAaTy8SveAQDg==
X-Received: by 2002:a17:902:e752:b0:19e:748c:d419 with SMTP id p18-20020a170902e75200b0019e748cd419mr3903653plf.46.1677890055254;
        Fri, 03 Mar 2023 16:34:15 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:efb8:1cdc:a06f:1b53])
        by smtp.gmail.com with ESMTPSA id kk15-20020a170903070f00b00189743ed3b6sm2071078plb.64.2023.03.03.16.34.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 16:34:14 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 63/81] scsi: pmcraid: Declare SCSI host template const
Date:   Fri,  3 Mar 2023 16:30:45 -0800
Message-Id: <20230304003103.2572793-64-bvanassche@acm.org>
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
 drivers/scsi/pmcraid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 836ddc476764..23c5230dbed4 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -3611,7 +3611,7 @@ static struct attribute *pmcraid_host_attrs[] = {
 ATTRIBUTE_GROUPS(pmcraid_host);
 
 /* host template structure for pmcraid driver */
-static struct scsi_host_template pmcraid_host_template = {
+static const struct scsi_host_template pmcraid_host_template = {
 	.module = THIS_MODULE,
 	.name = PMCRAID_DRIVER_NAME,
 	.queuecommand = pmcraid_queuecommand,

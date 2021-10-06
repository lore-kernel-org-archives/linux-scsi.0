Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BD86C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Oct 2021 21:55:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 502AA61245
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Oct 2021 21:55:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbhJFV5A (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Oct 2021 17:57:00 -0400
Received: from mail-pl1-f174.google.com ([209.85.214.174]:39518 "EHLO
        mail-pl1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234328AbhJFV46 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Oct 2021 17:56:58 -0400
Received: by mail-pl1-f174.google.com with SMTP id c4so2583931pls.6
        for <linux-scsi@vger.kernel.org>; Wed, 06 Oct 2021 14:55:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=X2LDzuXWkO3VJfvEFuPd00v1A4BaExhhDv0gMYyHNX4=;
        b=4CyDRAtxlDZAT6x/AbHW/ZdMoNtsVNRXi0X6fAZFFcqwwMXRoFClnLFoOnk3RCMnoh
         GuHvNrA4z8etiVoKDrMmi0Pi+e+UmQq972mJdXXGGYfijyqF+hcOd13ExfEXfOvLlULF
         WAPn6xh4yF5cZGAwqEZeKHwYqtQDgj/K9Seob+937flvwP9cC52SxqPZ8BS39xTKS9W0
         wbT//KshylE0137jni+I/0jFpMZpmpd4+x3pKPpkI6M8I2++7huXxFI/8fClreGLS3Fc
         NFw9wBjH4EA4O1beiAJ3vRWvR1tb2aHCqLz4B1i/A8WIX8T8cG0yPjKnvMzAuImS4VO7
         y8SA==
X-Gm-Message-State: AOAM53129kS99hsuB1nw/67yX1MBwYS/eOOFoILVX6Ix/L6fjvG5rj2+
        UKJ8WLn7myxJZOX/fnbRj9Y=
X-Google-Smtp-Source: ABdhPJxvMr7gxWPMWUlpGcqGyWyXdZ8CXS4Cu7FdNx3x/kyTJdYsskWKsh3AfTtiAwfqmj+280sz3g==
X-Received: by 2002:a17:903:11cd:b0:13e:596c:d9a7 with SMTP id q13-20020a17090311cd00b0013e596cd9a7mr319022plh.37.1633557305705;
        Wed, 06 Oct 2021 14:55:05 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:7a81:1c54:a610:d139])
        by smtp.gmail.com with ESMTPSA id x7sm5902586pjl.55.2021.10.06.14.55.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 14:55:05 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Dan Williams <dan.j.williams@intel.com>,
        Hannes Reinecke <hare@suse.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Martin Kepplinger <martin.kepplinger@puri.sm>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 2/3] scsi: sd: Rename sd_resume() into sd_resume_system()
Date:   Wed,  6 Oct 2021 14:54:52 -0700
Message-Id: <20211006215453.3318929-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.800.g4c38ced690-goog
In-Reply-To: <20211006215453.3318929-1-bvanassche@acm.org>
References: <20211006215453.3318929-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch does not change any functionality but makes the next patch in
this series easier to read.

Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Martin Kepplinger <martin.kepplinger@puri.sm>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sd.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 78ebccd9d106..d61b096562d3 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -109,7 +109,7 @@ static int  sd_remove(struct device *);
 static void sd_shutdown(struct device *);
 static int sd_suspend_system(struct device *);
 static int sd_suspend_runtime(struct device *);
-static int sd_resume(struct device *);
+static int sd_resume_system(struct device *);
 static int sd_resume_runtime(struct device *);
 static void sd_rescan(struct device *);
 static blk_status_t sd_init_command(struct scsi_cmnd *SCpnt);
@@ -602,9 +602,9 @@ static struct class sd_disk_class = {
 
 static const struct dev_pm_ops sd_pm_ops = {
 	.suspend		= sd_suspend_system,
-	.resume			= sd_resume,
+	.resume			= sd_resume_system,
 	.poweroff		= sd_suspend_system,
-	.restore		= sd_resume,
+	.restore		= sd_resume_system,
 	.runtime_suspend	= sd_suspend_runtime,
 	.runtime_resume		= sd_resume_runtime,
 };
@@ -3682,6 +3682,11 @@ static int sd_resume(struct device *dev)
 	return ret;
 }
 
+static int sd_resume_system(struct device *dev)
+{
+	return sd_resume(dev);
+}
+
 static int sd_resume_runtime(struct device *dev)
 {
 	struct scsi_disk *sdkp = dev_get_drvdata(dev);

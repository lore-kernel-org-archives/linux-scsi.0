Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8D5DC64EC4
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 19:27:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230301AbjCIT1z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 14:27:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230161AbjCIT1m (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 14:27:42 -0500
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69FC8EBAD8
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 11:27:37 -0800 (PST)
Received: by mail-pg1-f176.google.com with SMTP id 132so1693928pgh.13
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2023 11:27:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678390057;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NCdcj3LpvEBy9di6orhMZ8/sN2tsh1WV92aSckv+nIs=;
        b=jvan02aD4MyIkUVOWzlYiUuE/mTbB9YsfHivqYSQu1VlavL+4cqYWkqlGQOnCBhPum
         4zpciIExMMEYiqZfiXKCpt4p0kLzunAZDfe4dpL6O4k2WGEvncfGQbM2MOCl4KpsHfkN
         CATatahGPz93yU1mCalm6P4dXjafUwbJM9Z9ZwTH0kGWzp8kFHb/1khLPmncsT2ppDNZ
         8PorT3ilv2XbQUCkBj5oEjqWUEIA6IPfel1DLz4/PLDlOpa0t5p9yki0/zRbY35lfHhK
         4m5YHBnMvUvv4q/SFMgSU14XM46HdFO7Iui1R5WXYfakxBe+Aa8uZfhjYDlfEGEWqL1F
         e14g==
X-Gm-Message-State: AO0yUKVe6G7sVgEfZ+ScFOVIazHeQm08A9TripO3L5K0zywj2qisyCp8
        8hlxaq2P/mQXeoVdu/XWNu4=
X-Google-Smtp-Source: AK7set+olxdamLeR/yluzvoeFHuR37FaMQX6IdIyS+UNDSvRaFvqd9mV/dil42K3sThylZ8rZ8aW5g==
X-Received: by 2002:a62:3182:0:b0:617:bce6:f033 with SMTP id x124-20020a623182000000b00617bce6f033mr14088855pfx.14.1678390056849;
        Thu, 09 Mar 2023 11:27:36 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bf9f:35c8:4915:cb24])
        by smtp.gmail.com with ESMTPSA id j24-20020a62b618000000b0058d8f23af26sm11570955pff.157.2023.03.09.11.27.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 11:27:36 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 19/82] scsi: aha1542: Declare SCSI host template const
Date:   Thu,  9 Mar 2023 11:25:11 -0800
Message-Id: <20230309192614.2240602-20-bvanassche@acm.org>
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
 drivers/scsi/aha1542.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index 552ca95157da..9503996c6325 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -737,7 +737,8 @@ static void aha1542_set_bus_times(struct Scsi_Host *sh, int bus_on, int bus_off,
 }
 
 /* return non-zero on detection */
-static struct Scsi_Host *aha1542_hw_init(struct scsi_host_template *tpnt, struct device *pdev, int indx)
+static struct Scsi_Host *aha1542_hw_init(const struct scsi_host_template *tpnt,
+					 struct device *pdev, int indx)
 {
 	unsigned int base_io = io[indx];
 	struct Scsi_Host *sh;
@@ -1031,7 +1032,7 @@ static int aha1542_exit_cmd_priv(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
 	return 0;
 }
 
-static struct scsi_host_template driver_template = {
+static const struct scsi_host_template driver_template = {
 	.module			= THIS_MODULE,
 	.proc_name		= "aha1542",
 	.name			= "Adaptec 1542",

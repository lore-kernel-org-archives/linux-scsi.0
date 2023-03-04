Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 338BEC61DA4
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Mar 2023 00:32:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbjCDAc3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 19:32:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbjCDAcO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 19:32:14 -0500
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98C8A6A1C8
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2023 16:32:13 -0800 (PST)
Received: by mail-pl1-f180.google.com with SMTP id p6so4604468plf.0
        for <linux-scsi@vger.kernel.org>; Fri, 03 Mar 2023 16:32:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677889933;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NCdcj3LpvEBy9di6orhMZ8/sN2tsh1WV92aSckv+nIs=;
        b=z08IfWsbwgYmbODIAUz8z5Qhm/EpRgop4sgW710Xa7F7RboCXBOB9I4Yu0eYnVx8Rd
         AsYyMBAdEN3yupH1tMzuOd9Y2Yd87CUkqpqdIl9x7fdIusFvSzAjnFH39ZsfBcU3DoOH
         M/W0DAa/60KnPlWO+Vu/84oZc2ah06ahkS8ua1JFsmpheKrk5/cmeTyAyY3BQm2DZgeV
         csir2JVyf5i4OdhvFDYgRCp+7HnQyexvgHK9U0X1q1G1FFnzAcnIJJI0ppQ9TdHcO2SU
         VQmAAE73Gi24F3oiB1U35O3LylKijaX30MhCbOjJWVPvFXXdU9qJ2ocY6spAvVKyejin
         7+fw==
X-Gm-Message-State: AO0yUKXwI/G960HRylFkVlEo3nWUOW5XbLo5SzuaYE5SJzqf1AzF3jix
        LISDTa6niniWYHvyGHRoA6w=
X-Google-Smtp-Source: AK7set+eSjlB930of6GaKhGV/kZhsMp5mJEmmaUL5q5VJdjxj83+Cqjpqw/6D52UqzA96liCKYGL3w==
X-Received: by 2002:a17:90b:3a82:b0:237:c5cc:15bf with SMTP id om2-20020a17090b3a8200b00237c5cc15bfmr3649980pjb.13.1677889933056;
        Fri, 03 Mar 2023 16:32:13 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:efb8:1cdc:a06f:1b53])
        by smtp.gmail.com with ESMTPSA id kk15-20020a170903070f00b00189743ed3b6sm2071078plb.64.2023.03.03.16.32.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 16:32:12 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 19/81] scsi: aha1542: Declare SCSI host template const
Date:   Fri,  3 Mar 2023 16:30:01 -0800
Message-Id: <20230304003103.2572793-20-bvanassche@acm.org>
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

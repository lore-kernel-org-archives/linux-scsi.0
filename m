Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38058C61DA4
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Mar 2023 00:34:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbjCDAe6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 19:34:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbjCDAeY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 19:34:24 -0500
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E687765457
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2023 16:33:59 -0800 (PST)
Received: by mail-pl1-f173.google.com with SMTP id i10so4516224plr.9
        for <linux-scsi@vger.kernel.org>; Fri, 03 Mar 2023 16:33:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677890027;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X5og9in4ZDwqfZwJ0CvUxtEC6V3f2+08GwjGlKQ+E7A=;
        b=EtpjH+EpwbfL1gmAuuXzW5ujnc7C+v80UjfbGUCqq1bkFJ9L4QasbcDO9yNYcBhxpY
         4Xk+EpevivhrfnxK4ZiEIP719KzyAX5RLkq+xYlcRbXRy+77mtx57nBv8Zw5Hy4W0eTF
         8jLlD7PAcOnoRLz4hxBOt10gv6UEN2ArwDjcY0m9tgfULWa+paubwT3+8DmhsWopIjro
         r1NewkTa+P7r3LXRMBoej4A1ZnUf0P/xygqfYyf3+BrqIjF9eDqCZYkP6tovQMvcVsnV
         +l/U8YgOqrodfnHuIPpiL4AePD+j08phlQRE+TMI9omrp80rlq/+ZeZTFQmkrihn/1WR
         uF4g==
X-Gm-Message-State: AO0yUKXVSIfCg8h5gZ98+ypMzHxxZ4KB2CLpRfPieAZZIKq2Zy6ZYa7R
        8RsNAFcYUpf21+4/Rk1VzbA=
X-Google-Smtp-Source: AK7set/EqEp/gUm+ay6dji/e8HsOgNQYoJ4nAtiyLScRty1++6DUFwTLlGeFRg9weCHj5ubyke6I6Q==
X-Received: by 2002:a17:903:2344:b0:19b:64bb:d546 with SMTP id c4-20020a170903234400b0019b64bbd546mr3838785plh.18.1677890027308;
        Fri, 03 Mar 2023 16:33:47 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:efb8:1cdc:a06f:1b53])
        by smtp.gmail.com with ESMTPSA id kk15-20020a170903070f00b00189743ed3b6sm2071078plb.64.2023.03.03.16.33.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 16:33:46 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 54/81] scsi: mpt3sas: Declare SCSI host template const
Date:   Fri,  3 Mar 2023 16:30:36 -0800
Message-Id: <20230304003103.2572793-55-bvanassche@acm.org>
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
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 8e24ebcebfe5..7e4a97c61873 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -11926,7 +11926,7 @@ static void scsih_map_queues(struct Scsi_Host *shost)
 }
 
 /* shost template for SAS 2.0 HBA devices */
-static struct scsi_host_template mpt2sas_driver_template = {
+static const struct scsi_host_template mpt2sas_driver_template = {
 	.module				= THIS_MODULE,
 	.name				= "Fusion MPT SAS Host",
 	.proc_name			= MPT2SAS_DRIVER_NAME,
@@ -11964,7 +11964,7 @@ static struct raid_function_template mpt2sas_raid_functions = {
 };
 
 /* shost template for SAS 3.0 HBA devices */
-static struct scsi_host_template mpt3sas_driver_template = {
+static const struct scsi_host_template mpt3sas_driver_template = {
 	.module				= THIS_MODULE,
 	.name				= "Fusion MPT SAS Host",
 	.proc_name			= MPT3SAS_DRIVER_NAME,

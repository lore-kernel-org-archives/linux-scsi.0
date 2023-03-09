Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03116C64EC4
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 19:31:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbjCITbW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 14:31:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230165AbjCITai (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 14:30:38 -0500
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18605F98FF
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 11:29:48 -0800 (PST)
Received: by mail-pg1-f174.google.com with SMTP id 132so1697104pgh.13
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2023 11:29:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678390188;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T6GsPg2I0LZ32kZN7a19j6uU3awmr2LjY8FTtu+c/bA=;
        b=18oqnGnpe7PEoAGH2jK9l4nNCEL4KVVUquD19HYe3O9TPRERzQKiA172mVn62qlQK6
         sf9RzYnsrD7olYahtfOtfB6HB4xAUor2og9Ba1cavTvBXdatU/InQEfeN7rHA+NtPi2d
         xJtVh/kgQteCjkSNnoKfLgNGxq9G6PktzlrqnsuN9xUrNa3pniCVJSw8o57xslC9+tI4
         OyL7B5Qehf8MYcsbYbNcmK11yvQlsfuQmiK0One3EbrdrpKkykQkKRHV/Y/NEvx35W4v
         NumBORXuzAMb3vjxunbUTf+FWyIyGIgg5pgQGZaW1NUxBc6OonR3+axcBb+EAa+Jo8/k
         v6Xw==
X-Gm-Message-State: AO0yUKWXkGQIiyaf+e4V0BQ6dfSPdCeJPKpiTLOrute638yukSuP9mdk
        pzVMazRHK8bK/Mv33qKxbXg=
X-Google-Smtp-Source: AK7set+vS0Z3h7W4Ka11Rv6FefNhw8D5wkHV1kJbDfSNoI/1o//Kk+5mq+1g1Avoa+BPNnkRoxcHLw==
X-Received: by 2002:aa7:9f1a:0:b0:5df:5310:e2f9 with SMTP id g26-20020aa79f1a000000b005df5310e2f9mr16388839pfr.22.1678390187654;
        Thu, 09 Mar 2023 11:29:47 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bf9f:35c8:4915:cb24])
        by smtp.gmail.com with ESMTPSA id j24-20020a62b618000000b0058d8f23af26sm11570955pff.157.2023.03.09.11.29.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 11:29:46 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 63/82] scsi: pcmcia-pm8001: Declare SCSI host template const
Date:   Thu,  9 Mar 2023 11:25:55 -0800
Message-Id: <20230309192614.2240602-64-bvanassche@acm.org>
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

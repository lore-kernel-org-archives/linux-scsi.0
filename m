Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87320C61DA4
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 19:27:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbjCIT1e (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 14:27:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbjCIT1U (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 14:27:20 -0500
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 926B9EBAD9
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 11:27:19 -0800 (PST)
Received: by mail-pl1-f175.google.com with SMTP id ky4so3128144plb.3
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2023 11:27:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678390039;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fMZZSzHNKzDNL64pOw/gqMY4JB5yYVuh2s/FZomE/a4=;
        b=NhMQRk22sQuuWuNdJcUyJ6ULBd4roQJ6fpQlWF4xutpmdGL07Uv5asVrkK55XDc6jI
         wAwSHihFb9pHT46Coa3KuO5BQJfsY3cufTaYpYUaoN3fpJgVEoQRmH0kmhj9TjW5rwbY
         BUzsUN1taXitkGG/TFUjg5eB4BRz9laCdqmltPQX4bO44i58oik6DWKhLvKIsW5r/30y
         3VS9citZotZajvIlaeEIaQeIQLjH4YL7a2vGzz32RvaW77psqWCgA4BtRWZtXP6pJKuJ
         eBwgbCgHTL9TCcAEig10n0HJSwoFSno9Hef+WKM8PCGHgubOccq+0T17rXJCqDV0f2vo
         dHMg==
X-Gm-Message-State: AO0yUKV7YWO8gXiRMkSgSsotIIFATqV5KvT7qGvBZ1SADRsidbMk4vyc
        WjtEcuu9Icso8zEKtgHV/VU=
X-Google-Smtp-Source: AK7set9UylP3pgiaMwkrV8lf6ilyNgO+S5lRzgGjz/TiHbFArhUR5BLT79fS1oEkXP3VKi+O5bNI0Q==
X-Received: by 2002:a05:6a20:6712:b0:cb:ec3d:4783 with SMTP id q18-20020a056a20671200b000cbec3d4783mr20342466pzh.21.1678390039029;
        Thu, 09 Mar 2023 11:27:19 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bf9f:35c8:4915:cb24])
        by smtp.gmail.com with ESMTPSA id j24-20020a62b618000000b0058d8f23af26sm11570955pff.157.2023.03.09.11.27.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 11:27:18 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Adam Radford <aradford@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 09/82] scsi: 3w-9xxx: Declare SCSI host template const
Date:   Thu,  9 Mar 2023 11:25:01 -0800
Message-Id: <20230309192614.2240602-10-bvanassche@acm.org>
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
 drivers/scsi/3w-9xxx.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index 6cb9cca9565b..38d20a69ee12 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -1976,8 +1976,7 @@ static int twa_slave_configure(struct scsi_device *sdev)
 	return 0;
 } /* End twa_slave_configure() */
 
-/* scsi_host_template initializer */
-static struct scsi_host_template driver_template = {
+static const struct scsi_host_template driver_template = {
 	.module			= THIS_MODULE,
 	.name			= "3ware 9000 Storage Controller",
 	.queuecommand		= twa_scsi_queue,

Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDF04C61DA3
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Mar 2023 00:32:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbjCDAcF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 19:32:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjCDAcD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 19:32:03 -0500
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C1B96A1C2
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2023 16:31:53 -0800 (PST)
Received: by mail-pj1-f50.google.com with SMTP id h11-20020a17090a2ecb00b00237c740335cso3914298pjs.3
        for <linux-scsi@vger.kernel.org>; Fri, 03 Mar 2023 16:31:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677889913;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2Jr0GWxZyL6QllWqRWX7nuqLmySxeOxEBlDiVuqz0TM=;
        b=VgqpfFg5y48o2CNWIZfLAMEpEDAb7Cs5OrbHlWnCuPA1mY94FfX/C7ijwnbc7YkfLb
         05JbuHwbQXtu3iCpllLupvmWxf2WzZYybDJZfYz6iGo0jo4N9BrKPdr1IpmFJAKFivvY
         Gt21P+PXTaGwlHDQX7p7z7lezyjAOOox+V+jnbTVgyTAbJqISlfq0NuDpScCbpzz9hhn
         SCwqUyUY5P0GhvuOz7ar/vWRhJKwSEXdxdsdyNySjfsCloh/lP6g0o+g6YzCZ5cwH7on
         pysTDJTaxQjXVqVs9k+SWXWDAfjmSGgEMejeOwkZdrIYfia6rXHKVf49g5kbAmYx02O0
         4b7w==
X-Gm-Message-State: AO0yUKVuEBEkwTpw3iW+QqhUJwqyykvzB1Wk9sqjnQc5qQFOsjXeP8CO
        ldy3UXM4TqqsEEWbuCRjaXE=
X-Google-Smtp-Source: AK7set+ZZMpkXwzVrK6aV/dLR4xlM5OKAu7RM1v8GpMPKUKagO1pnANYpusQLxz3wo0EzrvVv+gWDQ==
X-Received: by 2002:a17:902:aa81:b0:19c:be03:d1bd with SMTP id d1-20020a170902aa8100b0019cbe03d1bdmr3103602plr.30.1677889912703;
        Fri, 03 Mar 2023 16:31:52 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:efb8:1cdc:a06f:1b53])
        by smtp.gmail.com with ESMTPSA id kk15-20020a170903070f00b00189743ed3b6sm2071078plb.64.2023.03.03.16.31.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 16:31:51 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Steffen Maier <maier@linux.ibm.com>,
        Benjamin Block <bblock@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
Subject: [PATCH 08/81] scsi: zfcp: Declare SCSI host template const
Date:   Fri,  3 Mar 2023 16:29:50 -0800
Message-Id: <20230304003103.2572793-9-bvanassche@acm.org>
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
 drivers/s390/scsi/zfcp_scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index 3dbf4b21d127..b2a8cd792266 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -418,7 +418,7 @@ static int zfcp_scsi_sysfs_host_reset(struct Scsi_Host *shost, int reset_type)
 
 struct scsi_transport_template *zfcp_scsi_transport_template;
 
-static struct scsi_host_template zfcp_scsi_host_template = {
+static const struct scsi_host_template zfcp_scsi_host_template = {
 	.module			 = THIS_MODULE,
 	.name			 = "zfcp",
 	.queuecommand		 = zfcp_scsi_queuecommand,

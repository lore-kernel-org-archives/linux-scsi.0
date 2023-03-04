Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A018CC61DA4
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Mar 2023 00:36:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230004AbjCDAgO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 19:36:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbjCDAfb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 19:35:31 -0500
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 134EB10AAF
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2023 16:34:54 -0800 (PST)
Received: by mail-pl1-f176.google.com with SMTP id a2so4552969plm.4
        for <linux-scsi@vger.kernel.org>; Fri, 03 Mar 2023 16:34:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677890093;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7GTKZi+0YaNTIlpwS+iAgVwMbfw4PFSVQQ5YHhFSUO0=;
        b=aqcaMlHt4WIp4mfnJhmRxq7l/VwSf+ZjB1sknKsO1ikxV2cOPwEHpuOmdBuSbrDnWQ
         aiM3qo1H/4i20rTW5UxYcM0OR5lIgdYT4qoemS+2iQBMz4rzdq+zJuYnWK813LRfMs05
         lc6cwYH3QXW4vpyj6UCaFCsolsNwl0tKDZYj/yZSfeP782uKKnQ1d1XZVjAmH+dOe2/5
         tC6f2MobHHB8h0Dkt6VC+7dLf1jheU9V/mXRznR4P4Csja3HXAxwLlgqwfAcCkJcfYDu
         h4VVBKa8CLC6jVaqO72vEU0xwjnvsz9IiXQf6FUkpjNlX5FYjjPtLvYDqZMq0qCI0MAy
         i/tw==
X-Gm-Message-State: AO0yUKWi8bD0S8WuDtMcOVu/2xihEW2jBxWH4dS1JjrgjaUpwlwlz5sx
        mfQ7UMv261dwl10qVn5BLQhPAdbM50Xnng==
X-Google-Smtp-Source: AK7set9EjbL84WHQ+vE7eqo2+lXA/uSErXyqfTGQ+WpwDeHmVlhSwWK1HpruU8YKq9Nw3RGx3e19bA==
X-Received: by 2002:a17:903:230e:b0:19c:c961:ac15 with SMTP id d14-20020a170903230e00b0019cc961ac15mr4219964plh.0.1677890093519;
        Fri, 03 Mar 2023 16:34:53 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:efb8:1cdc:a06f:1b53])
        by smtp.gmail.com with ESMTPSA id kk15-20020a170903070f00b00189743ed3b6sm2071078plb.64.2023.03.03.16.34.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 16:34:52 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Mike Christie <michael.chritie@oracle.com>
Subject: [PATCH 78/81] scsi: target: tcm-loop: Declare SCSI host template const
Date:   Fri,  3 Mar 2023 16:31:00 -0800
Message-Id: <20230304003103.2572793-79-bvanassche@acm.org>
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
 drivers/target/loopback/tcm_loop.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 139031ccb700..e5f029b296e4 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -298,7 +298,7 @@ static int tcm_loop_target_reset(struct scsi_cmnd *sc)
 	return FAILED;
 }
 
-static struct scsi_host_template tcm_loop_driver_template = {
+static const struct scsi_host_template tcm_loop_driver_template = {
 	.show_info		= tcm_loop_show_info,
 	.proc_name		= "tcm_loopback",
 	.name			= "TCM_Loopback",

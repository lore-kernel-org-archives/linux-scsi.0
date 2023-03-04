Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDA84C61DA3
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Mar 2023 00:35:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbjCDAfb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 19:35:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229951AbjCDAey (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 19:34:54 -0500
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A96F1814A
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2023 16:34:19 -0800 (PST)
Received: by mail-pl1-f179.google.com with SMTP id ky4so4560299plb.3
        for <linux-scsi@vger.kernel.org>; Fri, 03 Mar 2023 16:34:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677890059;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QCUTz96ttO7BBzk0AXfn/jV+9cMIEMPMqVz2OjaeEz8=;
        b=5navhC6oM97F18FQWTKtVN4WoWsa6DpfP8E3P4a+nbRMQut7n3Xy42kMBZxgBCZ2O6
         m1gfw3sG0xtYZqnU32QebTZ5BFvMyK6MZdghpV+7+xcsaDH/in6+dlQqVwR6RvFptuc1
         mArL02YRzsY1CrxCg5/w4FkmHTgHnUfzsMMCL5UdSEhWD9RK1okIcdVvsWFDoty5uxop
         hILE/XnhjsrwBwivpQrEezWlELEUNTAVOD3SGB+tM09e1Nwz4mwA97GgVHVtZGJ6+yH4
         VU0uAspJsUQ6MexWzMk2mrVszVm+T8eLlmiM/ORM9YfFsIYd10ae0cv3ZUfPFU650DvQ
         TdEw==
X-Gm-Message-State: AO0yUKXeJZtytCPK3k4dJmRCMgTyLydDRtwEQLCSd6wRYsVVGQ9tM1b7
        BDLfO3UOzf8SIqVnuzM9ubc=
X-Google-Smtp-Source: AK7set+vBWoDPtkdBfCNHaLTuJzApW2eEU30YLi7I5ACHurXFgmR58pTErWBS0InCZlIsO3AffFTMQ==
X-Received: by 2002:a17:902:ee89:b0:19a:841f:56 with SMTP id a9-20020a170902ee8900b0019a841f0056mr3409029pld.20.1677890058771;
        Fri, 03 Mar 2023 16:34:18 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:efb8:1cdc:a06f:1b53])
        by smtp.gmail.com with ESMTPSA id kk15-20020a170903070f00b00189743ed3b6sm2071078plb.64.2023.03.03.16.34.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 16:34:18 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Geoff Levand <geoff@infradead.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 65/81] scsi: ps3rom: Declare SCSI host template const
Date:   Fri,  3 Mar 2023 16:30:47 -0800
Message-Id: <20230304003103.2572793-66-bvanassche@acm.org>
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
 drivers/scsi/ps3rom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ps3rom.c b/drivers/scsi/ps3rom.c
index 2b80cab70333..90495a832f34 100644
--- a/drivers/scsi/ps3rom.c
+++ b/drivers/scsi/ps3rom.c
@@ -323,7 +323,7 @@ static irqreturn_t ps3rom_interrupt(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
-static struct scsi_host_template ps3rom_host_template = {
+static const struct scsi_host_template ps3rom_host_template = {
 	.name =			DEVICE_NAME,
 	.slave_configure =	ps3rom_slave_configure,
 	.queuecommand =		ps3rom_queuecommand,

Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C607AC64EC4
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 19:32:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230476AbjCITcZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 14:32:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231156AbjCITbj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 14:31:39 -0500
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BF70FCF92
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 11:30:30 -0800 (PST)
Received: by mail-pf1-f170.google.com with SMTP id cp12so2202459pfb.5
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2023 11:30:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678390229;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7GTKZi+0YaNTIlpwS+iAgVwMbfw4PFSVQQ5YHhFSUO0=;
        b=Vn3r2ZCRVqa2f0yCoJRAFDa/jLLjqadrg5H6F7ujbYXVQznWDQvxDAW6CSWzMNtBfu
         FJJXA2nvAAmhZcG2JWxdKewKD/Zckd6nJmI5SNO2ldC8wHiHXcCO36QjDfF9+xZCVQ4D
         EJH1agOqwWgQuutA4xIMDY1bxr3Ixzkducxxtduz0sv0wZuXca4d1nk0GhBPu3JHf9CD
         zltKdBYBmjpuqg6JRDSb84Z49mSn3AzdCSb8qj1v4W8stvoep8EpmiY4PhRVC7tHnwBE
         B0QSMCK0iDY7XBMuT4482rZyw0OaalhBvdzuUvQ+DhfG8yvCM/w3Bu42dYYyh1eGHMO3
         ErJw==
X-Gm-Message-State: AO0yUKXC8vzdOkS78HX1OpYMKAEvFB2Qj227lCOR9fMYNhtHbS/6Djjt
        Gd+fOZDkOSWXv4BRI1XHg/8=
X-Google-Smtp-Source: AK7set/Zvh8kaBzxsRfHXsSBpKf/0wQMESSwe4EXTiyNmf0xp6f5zkQMruFebEig9mvTm20pi5z7Sw==
X-Received: by 2002:a62:7b0c:0:b0:61d:e8bb:1cb0 with SMTP id w12-20020a627b0c000000b0061de8bb1cb0mr4608594pfc.1.1678390229654;
        Thu, 09 Mar 2023 11:30:29 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bf9f:35c8:4915:cb24])
        by smtp.gmail.com with ESMTPSA id j24-20020a62b618000000b0058d8f23af26sm11570955pff.157.2023.03.09.11.30.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 11:30:29 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Mike Christie <michael.christie@oracle.com>,
        Yang Yingliang <yangyingliang@huawei.com>
Subject: [PATCH v2 79/82] scsi: target: tcm-loop: Declare SCSI host template const
Date:   Thu,  9 Mar 2023 11:26:11 -0800
Message-Id: <20230309192614.2240602-80-bvanassche@acm.org>
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

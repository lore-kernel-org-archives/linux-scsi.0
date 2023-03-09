Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D791DC64EC4
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 19:29:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230446AbjCIT3Q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 14:29:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231153AbjCIT2j (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 14:28:39 -0500
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C01E82343
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 11:28:32 -0800 (PST)
Received: by mail-pg1-f174.google.com with SMTP id q189so1706693pga.9
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2023 11:28:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678390112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nGX3sCfP9S9SbUwoJVF9uNLn7ct4AxiUrRAsNV4NPzM=;
        b=aSI6YWIp1wV47IhIVJSmH4JtpfYsQIp5C7C6dx+9Jal97Sqipk4Uic6pTPBNKQAH0W
         rz/BDHjC9PGHdyrhAOCMkHSnDFv+H3n4rlpNntFd3IRiBDXYW/OVBtmMeXcr3kj6Y1XL
         DuwY7Q8de8+Q2GTe9WvehsHI8jDxBxxBA9Qy1P+j8z2La7hZpDq/nywSn9P/P7FRYOXt
         vDWqC/t8JEGbfFeW3gCPwkVt9rsYcKVzyClWJhBphUycDE48rtsoCpNWR68plxj8pajn
         2wJds3n+S4LirxgsH7H1JaWoSS297YL2wIpBqAlizAoQxkAEWy0o3HUMuWdUg0Z4GLFj
         mzyw==
X-Gm-Message-State: AO0yUKU8o3F2P7ORf7cgQwZ43uJGn365WRHr2yLSLppjszF3giWOixA+
        9HVtSEwoA5FjEfuReNAvKhY=
X-Google-Smtp-Source: AK7set9mnmWa3xnYLJpagKqDnHIEWH4JcGTGxIYoGretC5Fy+PBNvQWRWd2xolbb/+0X4YiK5Ig7mQ==
X-Received: by 2002:a62:1ad4:0:b0:5cf:4755:66d9 with SMTP id a203-20020a621ad4000000b005cf475566d9mr16433331pfa.24.1678390111696;
        Thu, 09 Mar 2023 11:28:31 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bf9f:35c8:4915:cb24])
        by smtp.gmail.com with ESMTPSA id j24-20020a62b618000000b0058d8f23af26sm11570955pff.157.2023.03.09.11.28.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 11:28:30 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Saurav Kashyap <skashyap@marvell.com>,
        Javed Hasan <jhasan@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 37/82] scsi: qedf: Declare host template const
Date:   Thu,  9 Mar 2023 11:25:29 -0800
Message-Id: <20230309192614.2240602-38-bvanassche@acm.org>
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
 drivers/scsi/qedf/qedf_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 35e16600fc63..e7f2560b9f7d 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -979,7 +979,7 @@ static int qedf_slave_configure(struct scsi_device *sdev)
 	return 0;
 }
 
-static struct scsi_host_template qedf_host_template = {
+static const struct scsi_host_template qedf_host_template = {
 	.module 	= THIS_MODULE,
 	.name 		= QEDF_MODULE_NAME,
 	.this_id 	= -1,

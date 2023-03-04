Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DF59C61DA4
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Mar 2023 00:34:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229988AbjCDAeu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 19:34:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229987AbjCDAeO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 19:34:14 -0500
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FA656A437
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2023 16:33:52 -0800 (PST)
Received: by mail-pl1-f174.google.com with SMTP id i5so4559154pla.2
        for <linux-scsi@vger.kernel.org>; Fri, 03 Mar 2023 16:33:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677890023;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dAdiI8QeHjoUkeBCYpg9C4zi1sFNt3WL7fHduN+tVF4=;
        b=fBZj3icTSLOQvRSRqOQuCzHoQFaiNU7CfchN+M9Zp5q8XprVUVWRCSLz0+hdmZcoO/
         rizB+mLivMGg8igKaUbhjcSICf8O91hrzI0dVrzNkAtsmJVyO+JZ0UJ8UwDR9evpsmwj
         PgakEmnu6AnCUpdtintlylYUmY5QLOs1ClNfSeig2ZKWGpcSewW2uB1cFLoia74E9S2l
         PGlN9zkz1lMcJ/lGATf8HPt/iZKP/1ao490K47IbIROtu4bBI/0UHGkW1ORocBZswLjO
         0aQh4Kg4xq1QFAYaaAdbc3Yry+iODQ5aCsEnUrEdK8XFdxXHQpis34ZHO1DShtTCT96J
         /Emw==
X-Gm-Message-State: AO0yUKVs0iZUN0PNMcp4rfoYG6Egce6yf8gAgbDTb3g+I1rnMTtC/bv2
        GuPTiFdxmMPYYNJnb2F3MDs=
X-Google-Smtp-Source: AK7set+tZDbmuin26vA9fHpYh9rEm72a3QK6OEkjlDy7xuT4SdgmpdR7awHEKF1ZFccWCZ4oMAdEzA==
X-Received: by 2002:a17:902:8a90:b0:19b:33c0:4097 with SMTP id p16-20020a1709028a9000b0019b33c04097mr3487915plo.27.1677890023569;
        Fri, 03 Mar 2023 16:33:43 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:efb8:1cdc:a06f:1b53])
        by smtp.gmail.com with ESMTPSA id kk15-20020a170903070f00b00189743ed3b6sm2071078plb.64.2023.03.03.16.33.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 16:33:42 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 52/81] scsi: mesh: Declare SCSI host template const
Date:   Fri,  3 Mar 2023 16:30:34 -0800
Message-Id: <20230304003103.2572793-53-bvanassche@acm.org>
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
 drivers/scsi/mesh.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mesh.c b/drivers/scsi/mesh.c
index 84b541a57b7b..e276583c590c 100644
--- a/drivers/scsi/mesh.c
+++ b/drivers/scsi/mesh.c
@@ -1830,7 +1830,7 @@ static int mesh_shutdown(struct macio_dev *mdev)
 	return 0;
 }
 
-static struct scsi_host_template mesh_template = {
+static const struct scsi_host_template mesh_template = {
 	.proc_name			= "mesh",
 	.name				= "MESH",
 	.queuecommand			= mesh_queue,

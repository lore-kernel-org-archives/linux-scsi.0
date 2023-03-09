Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB6CBC6FD19
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 19:27:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230148AbjCIT1i (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 14:27:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbjCIT11 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 14:27:27 -0500
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A778EE293
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 11:27:25 -0800 (PST)
Received: by mail-pg1-f180.google.com with SMTP id q189so1705089pga.9
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2023 11:27:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678390045;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Wvru8kVY2I3MSun55wPTjy7EC406KfhAV63CSzUeJMc=;
        b=Y7xOv2fxWTbbv97BjyArrYpK3r9XGpw9QabHL0BSmnypkLX9MaLaFo+4d7vbDzT1V5
         5pR/mjSQCOdzOn1D70ssThgYHHqol80P5XEbYo2j5Or/b8+hdLTbzUrZdnLEraXr4uNf
         KRF0qoRBYu5mw4DuEw5wa6DJrmM4WO8r/bYw++Eal60L5eaPXriagWKDT1GtmWdskv3r
         oMs50gyLFug+2J8Ki+uqF5S65qhuCHfceX+3VgPtBR84XxB+vO7tNnmBHz2kiPlPnfFn
         oWJaBr8Ehuqf3DbaFKoz85l26LPl8sIz1LJXSh0+/t0+6OOkaqb7MdLgMVKDFH4GSa70
         JYjQ==
X-Gm-Message-State: AO0yUKXnT3LbvArOrxDxHi6qF8RywVBX3doYksSzolixaRIAeiavPAbh
        02JlQ4beAlU/slvvTuPklqc=
X-Google-Smtp-Source: AK7set96jNrlLocDv2+vzdLKJ2Px0Pzxz2BgBEbmhaQydywEWWc5aGppOLSzE50MbzxeaOEYmlai3A==
X-Received: by 2002:a62:17d0:0:b0:5e2:da34:4aad with SMTP id 199-20020a6217d0000000b005e2da344aadmr19835630pfx.27.1678390044701;
        Thu, 09 Mar 2023 11:27:24 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bf9f:35c8:4915:cb24])
        by smtp.gmail.com with ESMTPSA id j24-20020a62b618000000b0058d8f23af26sm11570955pff.157.2023.03.09.11.27.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 11:27:23 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Khalid Aziz <khalid@gonehiking.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 12/82] scsi: BusLogic: Declare SCSI host template const
Date:   Thu,  9 Mar 2023 11:25:04 -0800
Message-Id: <20230309192614.2240602-13-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
In-Reply-To: <20230309192614.2240602-1-bvanassche@acm.org>
References: <20230309192614.2240602-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it explicit that the SCSI host template is not modified.

Acked-by: Khalid Aziz <khalid@gonehiking.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/BusLogic.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
index f7b7ffda1161..72ceaf650b0d 100644
--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
@@ -54,7 +54,7 @@
 #define FAILURE (-1)
 #endif
 
-static struct scsi_host_template blogic_template;
+static const struct scsi_host_template blogic_template;
 
 /*
   blogic_drvr_options_count is a count of the number of BusLogic Driver
@@ -3663,7 +3663,7 @@ static int __init blogic_parseopts(char *options)
   Get it all started
 */
 
-static struct scsi_host_template blogic_template = {
+static const struct scsi_host_template blogic_template = {
 	.module = THIS_MODULE,
 	.proc_name = "BusLogic",
 	.write_info = blogic_write_info,

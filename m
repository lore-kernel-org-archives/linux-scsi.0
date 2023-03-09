Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68FA4C61DA4
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 19:31:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbjCITbz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 14:31:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbjCITbC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 14:31:02 -0500
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBB9867801
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 11:30:01 -0800 (PST)
Received: by mail-pg1-f181.google.com with SMTP id 16so1697809pge.11
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2023 11:30:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678390201;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KrCJy7oKZ0NcxdBtk/yFFeEQwBZTbtLM0nNDWv0I1ic=;
        b=CCQvMDrq4vNSL6C3HAsSFv5d9dNUOdyBTEpBAa59/FVHj+90WAysGwo8uRdRMSKikG
         PNULEWziv9VWXCJLZlp2dB05hzvcsCh8OJKx2pH8aSVPB5Uh8SdVLMinLBlTSUuJJO/A
         w4rf6xZBwZN4aQ3RNIj/glhzUMfy4xYNycOafy/ynnYX2FW+IXkSaR9azbyRYg0OJbSY
         x3aJnfIX/Tvm4C/iqLtXMY91LZabt6P8RJDjfWPiNr7tMNa52nHeMHhCv2Ccpf4cnQPW
         bnPBKK4G+f7I0sTQDojAOQ3a3EL5bYUBSeKq9g/z0FQMPqnASwBXbv3bGXhYWllshsQW
         4GzQ==
X-Gm-Message-State: AO0yUKWUh5DiC4aqDRsyupiQ0pBm8yknM2x+fz6tgYmUCx6f1DjxQ1AS
        NudE/RGk5wQxhfoAPmf0uBQ=
X-Google-Smtp-Source: AK7set+/ygbTh1gaa2qtr4DSUnCH7cflnR2+b5PTy1G1b959BuhRG3suXmgAOHiv1c5NZyim4Y6mTg==
X-Received: by 2002:a62:1dc8:0:b0:5a8:a250:bc16 with SMTP id d191-20020a621dc8000000b005a8a250bc16mr17347957pfd.3.1678390201245;
        Thu, 09 Mar 2023 11:30:01 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bf9f:35c8:4915:cb24])
        by smtp.gmail.com with ESMTPSA id j24-20020a62b618000000b0058d8f23af26sm11570955pff.157.2023.03.09.11.29.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 11:30:00 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Don Brace <don.brace@microchip.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 71/82] scsi: smartpqi: Declare SCSI host template const
Date:   Thu,  9 Mar 2023 11:26:03 -0800
Message-Id: <20230309192614.2240602-72-bvanassche@acm.org>
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
 drivers/scsi/smartpqi/smartpqi_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 49a8f91810b6..03de97cd72c2 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -7403,7 +7403,7 @@ static struct attribute *pqi_sdev_attrs[] = {
 
 ATTRIBUTE_GROUPS(pqi_sdev);
 
-static struct scsi_host_template pqi_driver_template = {
+static const struct scsi_host_template pqi_driver_template = {
 	.module = THIS_MODULE,
 	.name = DRIVER_NAME_SHORT,
 	.proc_name = DRIVER_NAME_SHORT,

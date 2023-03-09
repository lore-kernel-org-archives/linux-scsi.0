Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CFB1C61DA4
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 19:29:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbjCIT3j (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 14:29:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230163AbjCIT2v (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 14:28:51 -0500
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 804CFE253C
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 11:28:49 -0800 (PST)
Received: by mail-pj1-f47.google.com with SMTP id kb15so3074641pjb.1
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2023 11:28:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678390129;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=px+VcymeEwEDAGjtrWl3/YMfcdfrocZHJayOmxP7gJo=;
        b=12rkPTuUkDgLu8fOqFzJJst7V1KdmkDjbHOQZz+O+F6ej5joJEpzzalYuDAnwevnJA
         V0OHoXGizeTymFVpWjBZVE7cfyGZFLtYJVI0vSWZFh2LCBk3SGpEgZ1MCtvUNhndbHth
         0gnwrY207woUZ/O7IuREPrwKHz14E45V2TGXVFQSZ1SybBqawDtI80wQC2fGmKsvLtlC
         lyrGreJTZokvvSd98AWN+qhzDD9f/CP6wGUVNLIv0FxnGesRSkOVTbcpJQlbTQV/J6Wi
         /9Euk1f7z1fVv423ie8q/q2o9T7KQY9zG6zmlGQcr3mpEv6cDjfENyJibaxnBmvSfBZP
         xs4Q==
X-Gm-Message-State: AO0yUKX8wqdLip5kyiFTmfFoMKiRCHEoQ3xvIjCuiKbtyxrb/6KeQ6tK
        qTLIJwqZCmpP/XrCLZcR2EY=
X-Google-Smtp-Source: AK7set9EHhL8B6f9aOYBZvxde6CLmNM+DzVChyMJm2ChtirP4WcPrpev7a8WcrEDNAZhqkALrJjKbg==
X-Received: by 2002:a05:6a20:1443:b0:d0:15c9:4e68 with SMTP id a3-20020a056a20144300b000d015c94e68mr14774869pzi.62.1678390128857;
        Thu, 09 Mar 2023 11:28:48 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bf9f:35c8:4915:cb24])
        by smtp.gmail.com with ESMTPSA id j24-20020a62b618000000b0058d8f23af26sm11570955pff.157.2023.03.09.11.28.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 11:28:48 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Brian King <brking@linux.vnet.ibm.com>,
        Brian King <brking@us.ibm.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 47/82] scsi: ipr: Declare SCSI host template const
Date:   Thu,  9 Mar 2023 11:25:39 -0800
Message-Id: <20230309192614.2240602-48-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
In-Reply-To: <20230309192614.2240602-1-bvanassche@acm.org>
References: <20230309192614.2240602-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it explicit that the SCSI host template is not modified.

Acked-by: Brian King <brking@linux.vnet.ibm.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ipr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index c74053f0b72f..4d3c280a7360 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -6736,7 +6736,7 @@ static const char *ipr_ioa_info(struct Scsi_Host *host)
 	return buffer;
 }
 
-static struct scsi_host_template driver_template = {
+static const struct scsi_host_template driver_template = {
 	.module = THIS_MODULE,
 	.name = "IPR",
 	.info = ipr_ioa_info,

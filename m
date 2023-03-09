Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA358C742A7
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 19:27:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbjCIT1f (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 14:27:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbjCIT1W (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 14:27:22 -0500
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47CF4EABA2
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 11:27:21 -0800 (PST)
Received: by mail-pl1-f175.google.com with SMTP id i3so3105425plg.6
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2023 11:27:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678390041;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wlyhrjS/HEDGCdAm7rlCI5/1sqj4pYqwf5Yq1hTnrno=;
        b=DWUgwqvz4DdJ2lZeGNy0CLlyFYYsOtZwqM4UXuSdNh9ndH2Ghgwc3UNzJHvOa1CY5X
         kHUcFQToz71HkrV2YlpDZXY8fzlLLV8idXV580ogHV8X9DSXZZ/1gFkdFk5lk51lZaVJ
         HIsoYGFJiszGuy7GZ5UKsR2K5WnXxfYOE55trFrfJHVlzYaXBkuQ+uoHSGlDiBB/92Jd
         jVPPwGvptzoDHwjDI1VQ+zY5EiL8CR8h+H7OJ1++K05dPSMotDgPyO7Vo/t4MfX5ji6J
         6wRhDLCDf2eKneJxtLY6P392SpPNVpJyBnVZlcJv/DQov8fXJvifJrC4p9xrCZqp2OpM
         /1Yg==
X-Gm-Message-State: AO0yUKXe+n9SqGs01p6qWITl0roRqUkfW/CaPR15RDMGh+DfDhOTvzl+
        WuzbJvlP6VLiZuRGCBAj7lo=
X-Google-Smtp-Source: AK7set/b6/sqd2eE/gjU8cJm1xQUM3yOTMDP+YlWMtwkWWtlPw1ZhTdyQuRubbD5cCDGBd00jl9SDQ==
X-Received: by 2002:a05:6a20:4c92:b0:cd:42cf:6e03 with SMTP id fq18-20020a056a204c9200b000cd42cf6e03mr3114429pzb.26.1678390040778;
        Thu, 09 Mar 2023 11:27:20 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bf9f:35c8:4915:cb24])
        by smtp.gmail.com with ESMTPSA id j24-20020a62b618000000b0058d8f23af26sm11570955pff.157.2023.03.09.11.27.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 11:27:20 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Adam Radford <aradford@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 10/82] scsi: 3w-sas: Declare SCSI host template const
Date:   Thu,  9 Mar 2023 11:25:02 -0800
Message-Id: <20230309192614.2240602-11-bvanassche@acm.org>
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
 drivers/scsi/3w-sas.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/3w-sas.c b/drivers/scsi/3w-sas.c
index f41c93454f0c..55989eaa2d9f 100644
--- a/drivers/scsi/3w-sas.c
+++ b/drivers/scsi/3w-sas.c
@@ -1530,8 +1530,7 @@ static int twl_slave_configure(struct scsi_device *sdev)
 	return 0;
 } /* End twl_slave_configure() */
 
-/* scsi_host_template initializer */
-static struct scsi_host_template driver_template = {
+static const struct scsi_host_template driver_template = {
 	.module			= THIS_MODULE,
 	.name			= "3w-sas",
 	.queuecommand		= twl_scsi_queue,

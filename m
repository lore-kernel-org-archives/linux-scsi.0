Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 931FFC742A7
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 19:28:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230161AbjCIT2R (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 14:28:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230434AbjCIT2E (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 14:28:04 -0500
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADE7912F32
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 11:28:01 -0800 (PST)
Received: by mail-pf1-f172.google.com with SMTP id y10so2192788pfi.8
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2023 11:28:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678390081;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kH268M7KVsr02fjw5NLBwrnT+cyJ3HjwvjHBuiPtPhM=;
        b=jc0skgEEhv5iqFteeTAOvlywqWzRm4uDoNTbOYhutDqTsDV7A5L71xZaXrtGwe5O63
         lXsUOpGjJJaT5I0pRgunI0gORNKo248aXtjnFADeU34JOjIu9kKiYjw3OpYVqfwBhu3i
         TskH9H/0/iPZiyJHDhKM2GX37zNR5duEWLFh2uf+ZlzOL9KnHhAj941mRZPb3WIPjLgk
         sMv/Izu0wUNT/h8bwym//2EsHstqiZ5yhqVoo+Xsb5tlkVnM+mTYaTxmfy5bOhmY6D3e
         QIkn3cFsp5duvJiBVNyW5rvw4rzrFeAz7GMt4k0opg2mdocdNzd/AMLfyKt3C4ZQdfpY
         rsIQ==
X-Gm-Message-State: AO0yUKUARtVuk/vq0dGhJoZcdOwsZHepSt9u+KWPfZNZa05g9QPbYSG+
        NBZ0gxIMJXEE+iocJF1uhmI=
X-Google-Smtp-Source: AK7set8h4dp7RAXmVkBXj3IRpvLCHSwA9t20Vxo1kCkGfuAvU2SloIriYrOJwCFHN2uw53Q4SD120A==
X-Received: by 2002:aa7:9510:0:b0:5a8:cf20:e35f with SMTP id b16-20020aa79510000000b005a8cf20e35fmr17175266pfp.28.1678390080794;
        Thu, 09 Mar 2023 11:28:00 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bf9f:35c8:4915:cb24])
        by smtp.gmail.com with ESMTPSA id j24-20020a62b618000000b0058d8f23af26sm11570955pff.157.2023.03.09.11.27.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 11:28:00 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 24/82] scsi: aha1740: Declare SCSI host template const
Date:   Thu,  9 Mar 2023 11:25:16 -0800
Message-Id: <20230309192614.2240602-25-bvanassche@acm.org>
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
 drivers/scsi/aha1740.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aha1740.c b/drivers/scsi/aha1740.c
index 134255751819..3d18945abaf7 100644
--- a/drivers/scsi/aha1740.c
+++ b/drivers/scsi/aha1740.c
@@ -543,7 +543,7 @@ static int aha1740_eh_abort_handler (struct scsi_cmnd *dummy)
 	return SUCCESS;
 }
 
-static struct scsi_host_template aha1740_template = {
+static const struct scsi_host_template aha1740_template = {
 	.module           = THIS_MODULE,
 	.proc_name        = "aha1740",
 	.show_info        = aha1740_show_info,

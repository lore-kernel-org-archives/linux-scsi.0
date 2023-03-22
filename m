Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77467C6FD1C
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Mar 2023 19:58:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230503AbjCVT6l (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Mar 2023 15:58:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230270AbjCVT5w (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Mar 2023 15:57:52 -0400
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2335F5BCA4
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:57:32 -0700 (PDT)
Received: by mail-pj1-f54.google.com with SMTP id p3-20020a17090a74c300b0023f69bc7a68so15746856pjl.4
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:57:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679515051;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nGX3sCfP9S9SbUwoJVF9uNLn7ct4AxiUrRAsNV4NPzM=;
        b=47rNcLH1ZX52sTNTOlIbisKj9jumQgtDXdvXB4PfYT5cp5xrXgGBmq2HaaSC7Q6d7Q
         kFDjV5ykw0hy7lIXbrKYAzEKGP7L2sEC9E5XhK8mQvRwTm2AYcTtKghjRMrmbb4J18ym
         4s8/iWgE4mBTHBzpsd+T3GrrLJyDXaLAT1iQ3FmZvGSZgo/ns2FHA+T4s4ux+metltYR
         KCKIxYiHii5VpPayQqk+zlu/Ipgc7opb/aTqfO8G/TGET9Bul6QEFJi8NJYIzXw6UstC
         wRPs75Binnlq+SVoFOg4EpPuQ6AgUSIPXfy2VrOkV/RdjDW1c86MxtfS8M++bMPjOfQ0
         R5mA==
X-Gm-Message-State: AO0yUKWuwNm+pGOqP7jtquDOgGTHE4t4mvEYKF0tmIvWpxtJ56aQCElw
        LtO/Qp6nFawZ96g1LbHxbPM=
X-Google-Smtp-Source: AK7set9Zi/HiEGX8CvgX7qJjqfzYobd7ZrkirPLaCDS8/AAwZ2VMZCG9IU3KFbQ9/PWR1QzBAWsvUw==
X-Received: by 2002:a17:90b:17c9:b0:23d:31c3:c98d with SMTP id me9-20020a17090b17c900b0023d31c3c98dmr5458070pjb.15.1679515051484;
        Wed, 22 Mar 2023 12:57:31 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ad4e:d902:f46f:5b50])
        by smtp.gmail.com with ESMTPSA id g2-20020a17090adac200b00233cde36909sm13574815pjx.21.2023.03.22.12.57.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 12:57:30 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Saurav Kashyap <skashyap@marvell.com>,
        Javed Hasan <jhasan@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 37/80] scsi: qedf: Declare host template const
Date:   Wed, 22 Mar 2023 12:54:32 -0700
Message-Id: <20230322195515.1267197-38-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
In-Reply-To: <20230322195515.1267197-1-bvanassche@acm.org>
References: <20230322195515.1267197-1-bvanassche@acm.org>
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

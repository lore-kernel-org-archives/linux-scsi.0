Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D385C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Oct 2021 14:33:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20A58610A1
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Oct 2021 14:33:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbhJTOfc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Oct 2021 10:35:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbhJTOfc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Oct 2021 10:35:32 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6F87C06161C;
        Wed, 20 Oct 2021 07:33:17 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id 21so16254960plo.13;
        Wed, 20 Oct 2021 07:33:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=u5DOSeHOTZkZZGLPLKG3YA5D+MxgiJ7IvT74eqMUdzw=;
        b=HzuNKj/Mo6lAcoORCX1FT11zc2x+2AFTBDIOP1iv/agUSbtHcKhtP7H5k4Y+ErSPXO
         COTzAd9fT0AEzLNM/AELcAZWfOq597E88L2Ohm9Asmy/IGsVsZT5Kvm1xc5eaWZ0nbWb
         6YAiIABRtMvBDosZPcxUtpFY6g0R86HCkUL8y/JFN4vE0D2aAerboa0oeCukNQHpLuG7
         tV2bn/vRPJSP6s3WQ7e6Naksyx11pbUe1gmhuVO7ttuG/TZMr8DFoNSSSbkLdbG4UIvC
         aDkCZK4vC0Ma1ByjaZr4KaQmj1hAChZdGjzWQsjGVHM/Io06QS2axKhmoUIYtdrVVdGg
         klHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=u5DOSeHOTZkZZGLPLKG3YA5D+MxgiJ7IvT74eqMUdzw=;
        b=x4feP+91VS9e5pfrhPkyST4PzLWmKz9GvP1lff58a35qTqOP3R6HOIoeBRDJWihOuP
         rN3H5ZgaXO14JVfYvIQS3J9pU8l6AOVc1IXT24fKPTaL3Pq24R79Z4IBZF0OmqNiPCCI
         2GtLhlQnlzSIJM4uL8BFk1JwXdom4d7+DSlkWJKi8wVCS9Ek6F7+OCqGCzG9UB5r8DJ2
         SQ7Jvh9mpID+rjqy0LPMdKNiI9/ttYumMLCYNNCuUpN/sG7u1ZOl/HimPYqBFnpPIvB2
         oSDYTBbR/Vu2osXJTtTfq6bEYNz+eSMx02efsI6JGNXYXKmkZHlbKkBReKOWiiJWZ2Cw
         +sVA==
X-Gm-Message-State: AOAM531ygqFUCIJIe1RyGIj/UqzWRu468GiWY7qDvnKIRYUtVsX3mBrQ
        usr+tNetycOVT6BDt4G8MA==
X-Google-Smtp-Source: ABdhPJw/xwo1EfpCHxX+UNPaVbn1dkiEDSMWBET0zrkkMENfrZ7XpE3j5GRdx+H2HNI+rN5AwuG5hA==
X-Received: by 2002:a17:90b:30d6:: with SMTP id hi22mr8001207pjb.4.1634740397380;
        Wed, 20 Oct 2021 07:33:17 -0700 (PDT)
Received: from vultr.guest ([107.191.53.97])
        by smtp.gmail.com with ESMTPSA id j9sm2512018pji.20.2021.10.20.07.33.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Oct 2021 07:33:16 -0700 (PDT)
From:   Zheyu Ma <zheyuma97@gmail.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        skashyap@marvell.com, jhasan@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zheyu Ma <zheyuma97@gmail.com>
Subject: [PATCH] scsi: qedf: Fix return values of the probe function
Date:   Wed, 20 Oct 2021 14:33:08 +0000
Message-Id: <1634740388-27238-1-git-send-email-zheyuma97@gmail.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

qedf_set_fcoe_pf_param() propagates the return value to the probe
function __qedf_probe() and then hits local_pci_probe().

During the process of driver probing, the probe function should return < 0
for failure, otherwise, the kernel will treat value > 0 as success.

Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
---
 drivers/scsi/qedf/qedf_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 42d0d941dba5..52f2a52bea2c 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -3161,14 +3161,14 @@ static int qedf_set_fcoe_pf_param(struct qedf_ctx *qedf)
 
 	if (!qedf->p_cpuq) {
 		QEDF_ERR(&(qedf->dbg_ctx), "dma_alloc_coherent failed.\n");
-		return 1;
+		return -ENOMEM;
 	}
 
 	rval = qedf_alloc_global_queues(qedf);
 	if (rval) {
 		QEDF_ERR(&(qedf->dbg_ctx), "Global queue allocation "
 			  "failed.\n");
-		return 1;
+		return rval;
 	}
 
 	/* Calculate SQ PBL size in the same manner as in qedf_sq_alloc() */
-- 
2.17.6


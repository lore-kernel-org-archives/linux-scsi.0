Return-Path: <SRS0=1cZD=AT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E9B0C433DF
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 12:04:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B38820739
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 12:04:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="XHAfQtf1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729188AbgGHME2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jul 2020 08:04:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729030AbgGHMCi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jul 2020 08:02:38 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 019E9C08E6DC
        for <linux-scsi@vger.kernel.org>; Wed,  8 Jul 2020 05:02:38 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id q15so2725702wmj.2
        for <linux-scsi@vger.kernel.org>; Wed, 08 Jul 2020 05:02:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CbDIhrckRx3GTebLwLuoUtbus6UaS40hQs+7mAaRUqY=;
        b=XHAfQtf1JAQ5VA4lD8a5M0K9xIEd3wjQPYeGkZpVYIRFvwsEfXYnoQAXMbZeDaNi/O
         UBvXSfjuqJ9gC8B812sv6P0z4WSeIudvXNXDXCkvejh6R152xb26L8EP9bpqk96d3aS5
         cZvqL0wKjmJA8/HKXKXROPFgujX96fI5EFnhYgDtgPfdPd+2CUCGhZPbkpbxbCxfhajA
         3w77tgKuLqsqzrz1zQQwWO4PKL50RqAf82qafFw1mDlPd4PYX/A9sygzDpIOpFTSsiSs
         Kj+5LNN0qfQODixhXraXYrqsM9HMVEm8TZPNr9Q3QtxcO3cq5TBB6x5u2fqy38JhPgUd
         CEiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CbDIhrckRx3GTebLwLuoUtbus6UaS40hQs+7mAaRUqY=;
        b=moLE3iTyoNoMsDPtjulzTHtIBn6Aa6YP1XpDARG6ia/fRvgrmBsIH5FI8GAO/VHM/5
         nCEjWkoFTe0vpFv47O0E7TJwYjMSCYWDwPjqHmGoMoWTea2GoYXe8H65Piqo8Ur8da/c
         4BwWX3iP512CxDhI9qbm1AS6HmaoGCFcqfNIrwhiwdUCJJFLNKaEO3s3if96y/tiMJND
         TIjq6VU7FSNQHNra4/z8tdpTIejFm6HNzi1HgzvoGYJWbDiMHQg/KRcGjFeOEzPeV8bV
         PXAR53Wl6PLzl9TFdmbsSRx2pJEwXAON3B06OUxj2Ai/JZ9ImqFAwPdSJnd9J3gSVx9d
         GXUQ==
X-Gm-Message-State: AOAM530aUj2mIpCZWt7utyRKXk4EOWE78Qg9W8CDN7EY/MxYapR3f3oh
        6OFe99czv+G7k26LitoMcipGpg==
X-Google-Smtp-Source: ABdhPJy+HB17Q9P1mrRKVGT2FF3j0WmBBb+fLX/6I25X987iIeI1ppamW0cma4BCMtp1nwaoLxHKaA==
X-Received: by 2002:a1c:1fc2:: with SMTP id f185mr8954863wmf.0.1594209756344;
        Wed, 08 Jul 2020 05:02:36 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.206])
        by smtp.gmail.com with ESMTPSA id m62sm3964997wmm.42.2020.07.08.05.02.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 05:02:35 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        QLogic-Storage-Upstream@cavium.com
Subject: [PATCH 08/30] scsi: qedf: qedf_main: Demote obvious misuse of kerneldoc to standard comment blocks
Date:   Wed,  8 Jul 2020 13:01:59 +0100
Message-Id: <20200708120221.3386672-9-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200708120221.3386672-1-lee.jones@linaro.org>
References: <20200708120221.3386672-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

No attempt has been made to document either of the demoted functions here.

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/qedf/qedf_main.c:1027: warning: Function parameter or member 'lport' not described in 'qedf_xmit'
 drivers/scsi/qedf/qedf_main.c:1027: warning: Function parameter or member 'fp' not described in 'qedf_xmit'
 drivers/scsi/qedf/qedf_main.c:1426: warning: Function parameter or member 'lport' not described in 'qedf_rport_event_handler'
 drivers/scsi/qedf/qedf_main.c:1426: warning: Function parameter or member 'rdata' not described in 'qedf_rport_event_handler'
 drivers/scsi/qedf/qedf_main.c:1426: warning: Function parameter or member 'event' not described in 'qedf_rport_event_handler'

Cc: QLogic-Storage-Upstream@cavium.com
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/qedf/qedf_main.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 36b1ca2dadbb5..a77a74fad6a7e 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -1019,9 +1019,8 @@ static int qedf_xmit_l2_frame(struct qedf_rport *fcport, struct fc_frame *fp)
 	return rc;
 }
 
-/**
+/*
  * qedf_xmit - qedf FCoE frame transmit function
- *
  */
 static int qedf_xmit(struct fc_lport *lport, struct fc_frame *fp)
 {
@@ -1415,7 +1414,7 @@ static void qedf_cleanup_fcport(struct qedf_ctx *qedf,
 	kref_put(&rdata->kref, fc_rport_destroy);
 }
 
-/**
+/*
  * This event_callback is called after successful completion of libfc
  * initiated target login. qedf can proceed with initiating the session
  * establishment.
-- 
2.25.1


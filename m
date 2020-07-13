Return-Path: <SRS0=+RX4=AY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8B5AC433E4
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 07:46:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5AA220674
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 07:46:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Dgdv43SM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729107AbgGMHq6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jul 2020 03:46:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729085AbgGMHq5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jul 2020 03:46:57 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7768AC061755
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 00:46:57 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id a6so14659796wrm.4
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 00:46:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CbDIhrckRx3GTebLwLuoUtbus6UaS40hQs+7mAaRUqY=;
        b=Dgdv43SMguTbFfpAEBrGAMFtotvNXSMP4bcEVucw8MOl/jsg7uMMgAe8AQXfW3dk2j
         Mf2ROLifHH1Vr3gSBOFKsCZ25nrUuOMaIBLZyItBlBHNZ7hC3RCd7ue5F+kjuCvW+PGD
         tSlROBZdMCQIL8T3OY3Is5S0gX7ZyuEXZI1uCCoygGC4g/7sG7lNkkRbba7uDZuudODp
         sTWYN4RJr/u+Mjd41GbT52bHNLEi8SlaiuWkLnpbB2/X9mufq8Gi5mjY1ryxPjCdqNe2
         ngHRRdC73MUn5Q6BpVu/Dsbk+ICGMc+aJVOYQjydWVsOzdBHdM3gIdBqz3mwFbevoVDz
         ts6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CbDIhrckRx3GTebLwLuoUtbus6UaS40hQs+7mAaRUqY=;
        b=MGB+Pi030sLWbBmP4JS0ahT3/PIDWDx9OHAhxyqb3ZjWkKCwEqMhz0IOwYDReP7+mq
         RhntzAjbeAVWoVEbQDDmdXxbno8VxNy3WfOyxgb5THo/SyGNejtjEXx8cikT5+zPuHWU
         xkOzupJ6HQ0JPvJxlyoKxq+PpRuPWqn2wfgHOvfX5V8t3rACERC+6xUEiAgD+PNZM4d0
         cToTasjrIRtWvN+wbQDVHOO6wuLVU3YoWTKoFPP6OCX8vExHNSpYxBJNYftc1NbZohP/
         z2+Jt5W/6paxgLIbG4Fvzym0QtfdGQdaKSP1BzpgF2RqHiDBVezdFOLKPPz90j3KsXUM
         ejKQ==
X-Gm-Message-State: AOAM531CTo4ZM/y8dLNQTWC4bPScSReo+PrmqDnmh//iadGaewSskS2t
        z5nzfLaRB0HOVLpXEvBCmaGtUQ==
X-Google-Smtp-Source: ABdhPJxNjGlKKAba0B1VMYG/5vUA34uYc5xVMQo7SYVX64LCfQfLFDRbnQ3uxd7YvKo9aYvgj1yRpw==
X-Received: by 2002:a5d:658a:: with SMTP id q10mr78336227wru.220.1594626416215;
        Mon, 13 Jul 2020 00:46:56 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.6])
        by smtp.gmail.com with ESMTPSA id k11sm25142488wrd.23.2020.07.13.00.46.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 00:46:55 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        QLogic-Storage-Upstream@cavium.com
Subject: [PATCH v2 08/29] scsi: qedf: qedf_main: Demote obvious misuse of kerneldoc to standard comment blocks
Date:   Mon, 13 Jul 2020 08:46:24 +0100
Message-Id: <20200713074645.126138-9-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200713074645.126138-1-lee.jones@linaro.org>
References: <20200713074645.126138-1-lee.jones@linaro.org>
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


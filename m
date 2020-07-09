Return-Path: <SRS0=/8H4=AU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84F0CC433E0
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 17:46:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62533207DD
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 17:46:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="MWd5ju4J"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728733AbgGIRqy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Jul 2020 13:46:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728626AbgGIRqU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jul 2020 13:46:20 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C841DC08C5DC
        for <linux-scsi@vger.kernel.org>; Thu,  9 Jul 2020 10:46:19 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id f18so2758572wml.3
        for <linux-scsi@vger.kernel.org>; Thu, 09 Jul 2020 10:46:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bOkk/AOE4a1rIKIblem9cC9W1YA+YYErwB4kADkbA6U=;
        b=MWd5ju4JbdHMiJUX5GcVnX00rN3Hc3hTaDiVr7AuBgNidF2+dd4GO9vqUV1Qh46wyy
         6KEyEo8a2wrrsboXdmxrShxWKCO00TCzZfMh548C3SPpvGr2YZBdtP1Ria0ltI6PaUbJ
         A8X0QIzFq/GapHaUwFRvoweJ/fwptLu+HspTiL4q0k7W5KRaER1SwytpXR3UFxJVz15T
         xHcejeaN3b+kVJMloB9uHu+wZP+G0tLsMeSOK0OZVTvXQPf/GYp3LUdiL2v1RwY/4VMh
         Vl+ZWXughSux3xb5Y4EeAAUBv+uU6xLGI3+CNWu8pXlcuT1HJ1+Sq0NiJR2jr9km1aZW
         rItA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bOkk/AOE4a1rIKIblem9cC9W1YA+YYErwB4kADkbA6U=;
        b=RVDRSswjgEbPx6xP2rg0kzfIZ0SIvR8+qPncwOxm9SQkZltZDIR7ZVp0aCgMnYFyOc
         QTXr0NS1+dcmRXOmOsyMM1l+BkN42Afe3ZG9mxoqpA1jXHP7RmqpfTiugiQ7DRhVsOow
         E7263uCjySIaY3qFcX/+ZPGUmvz2a+LmBpHKBrpch6aGPW3vB2v344T4R1Yo9hxBeuGP
         J/YZ4akumaY2BBS1/zipqCMVrZnUFXETrJ0VKs0612K29IICE/jHTKTem5BTj1L5bwkv
         3AO0czfskciL94DNUmY7c863w0B9n+QZA8ZuLrrhkfzQfyxYpZXjnrCx14qNBPOZMNVP
         7cCw==
X-Gm-Message-State: AOAM532tWBM0N+PhxosBEuD6CeqgEgAZ78c/D+/zE2sYH2whZkCtla2i
        wgU3iEfhwXMWJDFmUfKRKme5jA==
X-Google-Smtp-Source: ABdhPJwpHmcDVcdQIAxODuM83/Qe1cHAicnMGlPXU41DMaChsw91V85OdaqnzLc7pB10PbgeRRRlMQ==
X-Received: by 2002:a1c:7f82:: with SMTP id a124mr1054657wmd.132.1594316778528;
        Thu, 09 Jul 2020 10:46:18 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.206])
        by smtp.gmail.com with ESMTPSA id f15sm6063854wrx.91.2020.07.09.10.46.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2020 10:46:17 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Subbu Seetharaman <subbu.seetharaman@broadcom.com>,
        Ketan Mukadam <ketan.mukadam@broadcom.com>,
        Jitendra Bhivare <jitendra.bhivare@broadcom.com>,
        linux-drivers@broadcom.com
Subject: [PATCH 17/24] scsi: be2iscsi: be_iscsi: Fix API/documentation slip
Date:   Thu,  9 Jul 2020 18:45:49 +0100
Message-Id: <20200709174556.7651-18-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200709174556.7651-1-lee.jones@linaro.org>
References: <20200709174556.7651-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

And add descriptions for a couple of missing function parameters.

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/be2iscsi/be_iscsi.c:38: warning: Function parameter or member 'ep' not described in 'beiscsi_session_create'
 drivers/scsi/be2iscsi/be_iscsi.c:173: warning: Function parameter or member 'is_leading' not described in 'beiscsi_conn_bind'
 drivers/scsi/be2iscsi/be_iscsi.c:998: warning: Function parameter or member 'beiscsi_ep' not described in 'beiscsi_free_ep'
 drivers/scsi/be2iscsi/be_iscsi.c:998: warning: Excess function parameter 'ep' description in 'beiscsi_free_ep'
 drivers/scsi/be2iscsi/be_iscsi.c:1039: warning: Function parameter or member 'non_blocking' not described in 'beiscsi_open_conn'
 drivers/scsi/be2iscsi/be_iscsi.c:1135: warning: Function parameter or member 'shost' not described in 'beiscsi_ep_connect'
 drivers/scsi/be2iscsi/be_iscsi.c:1135: warning: Excess function parameter 'scsi_host' description in 'beiscsi_ep_connect'
 drivers/scsi/be2iscsi/be_iscsi.c:1236: warning: Function parameter or member 'beiscsi_ep' not described in 'beiscsi_conn_close'
 drivers/scsi/be2iscsi/be_iscsi.c:1236: warning: Excess function parameter 'ep' description in 'beiscsi_conn_close'

Cc: Subbu Seetharaman <subbu.seetharaman@broadcom.com>
Cc: Ketan Mukadam <ketan.mukadam@broadcom.com>
Cc: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Cc: linux-drivers@broadcom.com
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/be2iscsi/be_iscsi.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index 2058d50d62e12..fe10575bce7f0 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -27,6 +27,7 @@ extern struct iscsi_transport beiscsi_iscsi_transport;
 
 /**
  * beiscsi_session_create - creates a new iscsi session
+ * @ep: pointer to iscsi ep
  * @cmds_max: max commands supported
  * @qdepth: max queue depth supported
  * @initial_cmdsn: initial iscsi CMDSN
@@ -164,6 +165,7 @@ beiscsi_conn_create(struct iscsi_cls_session *cls_session, u32 cid)
  * @cls_session: pointer to iscsi cls session
  * @cls_conn: pointer to iscsi cls conn
  * @transport_fd: EP handle(64 bit)
+ * @is_leading: indicate if this is the session leading connection (MCS)
  *
  * This function binds the TCP Conn with iSCSI Connection and Session.
  */
@@ -992,7 +994,7 @@ static void beiscsi_put_cid(struct beiscsi_hba *phba, unsigned short cid)
 
 /**
  * beiscsi_free_ep - free endpoint
- * @ep:	pointer to iscsi endpoint structure
+ * @beiscsi_ep: pointer to device endpoint struct
  */
 static void beiscsi_free_ep(struct beiscsi_endpoint *beiscsi_ep)
 {
@@ -1027,9 +1029,10 @@ static void beiscsi_free_ep(struct beiscsi_endpoint *beiscsi_ep)
 
 /**
  * beiscsi_open_conn - Ask FW to open a TCP connection
- * @ep:	endpoint to be used
+ * @beiscsi_ep: pointer to device endpoint struct
  * @src_addr: The source IP address
  * @dst_addr: The Destination  IP address
+ * @non_blocking: blocking or non-blocking call
  *
  * Asks the FW to open a TCP connection
  */
@@ -1123,7 +1126,7 @@ static int beiscsi_open_conn(struct iscsi_endpoint *ep,
 
 /**
  * beiscsi_ep_connect - Ask chip to create TCP Conn
- * @scsi_host: Pointer to scsi_host structure
+ * @shost: Pointer to scsi_host structure
  * @dst_addr: The IP address of Target
  * @non_blocking: blocking or non-blocking call
  *
@@ -1228,7 +1231,7 @@ static void beiscsi_flush_cq(struct beiscsi_hba *phba)
 
 /**
  * beiscsi_conn_close - Invalidate and upload connection
- * @ep: The iscsi endpoint
+ * @beiscsi_ep: pointer to device endpoint struct
  *
  * Returns 0 on success,  -1 on failure.
  */
-- 
2.25.1


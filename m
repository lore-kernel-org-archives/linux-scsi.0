Return-Path: <SRS0=JunS=BC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16CADC43457
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jul 2020 12:26:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBEF222B43
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jul 2020 12:26:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Us3D32gP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729041AbgGWMZ2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Jul 2020 08:25:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729032AbgGWMZ1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Jul 2020 08:25:27 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CE8CC0619E6
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2020 05:25:26 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id 9so4774084wmj.5
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2020 05:25:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Y7MiQFR4MfIftYnbJz642q1pbyBNEj9l/lt1l++SzIE=;
        b=Us3D32gPY+JYnXjK++12vZVZDsA2wXNOc9+OYP8A3BePDPwztRgB5/Z/8IAizc97X8
         nKosVGZ9N+dVKncBJjX433ecd0HYtaZ0zTUjtqgi2JAWtEIHEjrSDa1JZQCVzqMYHExW
         2fTUrUmz7ey6c01MHFuKqbLY5uBwj3NKh+7F0pIrL0RsdKuXIpxlS7EvGmsa4P24aGWZ
         avIAkIAnxjVTvxYIF4cX3zHHwfitNVezEEnnRyzFNOsn1wXfCanvLpbtR7F6MP4gGsLK
         VeSUgNdufmcTSewKqZD1d1f91zqBK2q13hmqogTzrClLfFGeT1nYIgIt4KeVDJlreBKM
         SWsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Y7MiQFR4MfIftYnbJz642q1pbyBNEj9l/lt1l++SzIE=;
        b=uPplsrHHn0vjGNQ85EmbcyL0/UuVmIIl9nt/5cvsP1LQ0XJJNTqQcI61xD1sXkl02y
         /Q5S38IKuGx1l+9zuqRFDyaJAQtGKKsZvbgzViJuu6kXXkKa9ivwp3NyyerB+BYRckG9
         gYOqgczXiob3J++gb3RoMEBjCx6avJNyuIKDHZ31zUPJaV77VTwkGBaBvn48MjPpm3vV
         nF5EqFOYSQI338aiIZjS0uJRAJGdb6MhMR8JD8AWhB6G9DvhjWObDnovYIvrLu1/zR2o
         MZApzjUrqsywpmtbhlR4V+rY3mkqci1wwwgWopti08Hzcbisqv4YwBwKmkn5wLjTcEpK
         TpDg==
X-Gm-Message-State: AOAM531XQPsOPlbqxShidpXBfIPIciZ4x/LA2Z17o7OwmyQ+VrNTZPLt
        y7Y/BdTiAMUJwTlfMSM15aCAJpc3CL8=
X-Google-Smtp-Source: ABdhPJxyBGe1nMpgAfryelJs043nAKgZqFOm/9SzGkYtuj/ijflWgyidPoOtx4LGTcj4cCrr53AX1Q==
X-Received: by 2002:a1c:750a:: with SMTP id o10mr4120196wmc.165.1595507125085;
        Thu, 23 Jul 2020 05:25:25 -0700 (PDT)
Received: from localhost.localdomain ([2.27.167.73])
        by smtp.gmail.com with ESMTPSA id j5sm3510651wma.45.2020.07.23.05.25.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2020 05:25:24 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        QLogic-Storage-Upstream@qlogic.com,
        Anil Veerabhadrappa <anilgv@broadcom.com>,
        Eddie Wai <eddie.wai@broadcom.com>
Subject: [PATCH 29/40] scsi: bnx2i: bnx2i_iscsi: Add, remove and edit some function parameter descriptions
Date:   Thu, 23 Jul 2020 13:24:35 +0100
Message-Id: <20200723122446.1329773-30-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200723122446.1329773-1-lee.jones@linaro.org>
References: <20200723122446.1329773-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/bnx2i/bnx2i_iscsi.c:241: warning: Function parameter or member 'bnx2i_conn' not described in 'bnx2i_bind_conn_to_iscsi_cid'
 drivers/scsi/bnx2i/bnx2i_iscsi.c:241: warning: Excess function parameter 'conn' description in 'bnx2i_bind_conn_to_iscsi_cid'
 drivers/scsi/bnx2i/bnx2i_iscsi.c:470: warning: Excess function parameter 'cmd' description in 'bnx2i_destroy_cmd_pool'
 drivers/scsi/bnx2i/bnx2i_iscsi.c:595: warning: Function parameter or member 'cls_session' not described in 'bnx2i_drop_session'
 drivers/scsi/bnx2i/bnx2i_iscsi.c:595: warning: Excess function parameter 'hba' description in 'bnx2i_drop_session'
 drivers/scsi/bnx2i/bnx2i_iscsi.c:595: warning: Excess function parameter 'session' description in 'bnx2i_drop_session'
 drivers/scsi/bnx2i/bnx2i_iscsi.c:1290: warning: Function parameter or member 'ep' not described in 'bnx2i_session_create'
 drivers/scsi/bnx2i/bnx2i_iscsi.c:1979: warning: Function parameter or member 'bnx2i_ep' not described in 'bnx2i_ep_tcp_conn_active'
 drivers/scsi/bnx2i/bnx2i_iscsi.c:1979: warning: Excess function parameter 'ep' description in 'bnx2i_ep_tcp_conn_active'
 drivers/scsi/bnx2i/bnx2i_iscsi.c:2178: warning: Function parameter or member 'shost' not described in 'bnx2i_nl_set_path'
 drivers/scsi/bnx2i/bnx2i_iscsi.c:2178: warning: Function parameter or member 'params' not described in 'bnx2i_nl_set_path'
 drivers/scsi/bnx2i/bnx2i_iscsi.c:2178: warning: Excess function parameter 'buf' description in 'bnx2i_nl_set_path'

Cc: QLogic-Storage-Upstream@qlogic.com
Cc: Anil Veerabhadrappa <anilgv@broadcom.com>
Cc: Eddie Wai <eddie.wai@broadcom.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/bnx2i/bnx2i_iscsi.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index 0b28d44d35738..a9ffd89ec2c85 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -228,7 +228,7 @@ static void bnx2i_setup_cmd_wqe_template(struct bnx2i_cmd *cmd)
 /**
  * bnx2i_bind_conn_to_iscsi_cid - bind conn structure to 'iscsi_cid'
  * @hba:	pointer to adapter instance
- * @conn:	pointer to iscsi connection
+ * @bnx2i_conn:	pointer to iscsi connection
  * @iscsi_cid:	iscsi context ID, range 0 - (MAX_CONN - 1)
  *
  * update iscsi cid table entry with connection pointer. This enables
@@ -463,7 +463,6 @@ static int bnx2i_alloc_bdt(struct bnx2i_hba *hba, struct iscsi_session *session,
  * bnx2i_destroy_cmd_pool - destroys iscsi command pool and release BD table
  * @hba:	adapter instance pointer
  * @session:	iscsi session pointer
- * @cmd:	iscsi command structure
  */
 static void bnx2i_destroy_cmd_pool(struct bnx2i_hba *hba,
 				   struct iscsi_session *session)
@@ -582,8 +581,7 @@ static void bnx2i_free_mp_bdt(struct bnx2i_hba *hba)
 
 /**
  * bnx2i_drop_session - notifies iscsid of connection error.
- * @hba:	adapter instance pointer
- * @session:	iscsi session pointer
+ * @cls_session:	iscsi cls session pointer
  *
  * This notifies iscsid that there is a error, so it can initiate
  * recovery.
@@ -1277,7 +1275,7 @@ static int bnx2i_task_xmit(struct iscsi_task *task)
 
 /**
  * bnx2i_session_create - create a new iscsi session
- * @cmds_max:		max commands supported
+ * @ep:		pointer to iscsi endpoint
  * @qdepth:		scsi queue depth to support
  * @initial_cmdsn:	initial iscsi CMDSN to be used for this session
  *
@@ -1971,7 +1969,7 @@ static int bnx2i_ep_poll(struct iscsi_endpoint *ep, int timeout_ms)
 
 /**
  * bnx2i_ep_tcp_conn_active - check EP state transition
- * @ep:		endpoint pointer
+ * @bnx2i_ep:		endpoint pointer
  *
  * check if underlying TCP connection is active
  */
@@ -2014,9 +2012,9 @@ static int bnx2i_ep_tcp_conn_active(struct bnx2i_endpoint *bnx2i_ep)
 }
 
 
-/*
+/**
  * bnx2i_hw_ep_disconnect - executes TCP connection teardown process in the hw
- * @ep:		TCP connection (bnx2i endpoint) handle
+ * @bnx2i_ep:		TCP connection (bnx2i endpoint) handle
  *
  * executes  TCP connection teardown process
  */
@@ -2171,8 +2169,8 @@ static void bnx2i_ep_disconnect(struct iscsi_endpoint *ep)
 
 /**
  * bnx2i_nl_set_path - ISCSI_UEVENT_PATH_UPDATE user message handler
+ * @shost:	scsi host pointer
  * @buf:	pointer to buffer containing iscsi path message
- *
  */
 static int bnx2i_nl_set_path(struct Scsi_Host *shost, struct iscsi_path *params)
 {
-- 
2.25.1


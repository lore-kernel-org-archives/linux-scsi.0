Return-Path: <SRS0=JunS=BC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 206F2C43459
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jul 2020 12:25:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F0EA82086A
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jul 2020 12:25:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="rooYXweM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729162AbgGWMZt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Jul 2020 08:25:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729130AbgGWMZj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Jul 2020 08:25:39 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76C3FC0619E2
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2020 05:25:39 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id 184so5023403wmb.0
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2020 05:25:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=m3mDnqSN+OOOTdmOXToIz9SwiUgUMLzbR5Yna7FHQ8M=;
        b=rooYXweMoSfvNUEFwqDddlh0k+h7mXrYANm1pHQMha0hxF4CfAHMhYrlhKwN8cfE2F
         jEsJYbcBqxFZrDqIbtmyuOj9LMfpPPg2uVl8FSnvPYTiQEORXFNwUewOBXmCIQxvAgt8
         wIPUwbxyJq1JjjudqgEqcW8YlORJOqA52XqT454/xaTZy1wmfSivdgBpmCy49zQDSLyn
         xpFy7CJItOrmsDByW8eVSMmlOhh5RmUaDCn/wAGJwERbu4yn/ESYc3SeCgEgllYwTgMy
         RPDYKboBND6viaKyfFK0PXCEpJBaoIFM/Szhrfx46SMZWl5AZfnkKwJ5qi4tm/OdFP3D
         zv0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m3mDnqSN+OOOTdmOXToIz9SwiUgUMLzbR5Yna7FHQ8M=;
        b=doNQFV5Wee+v8FN7wWo4uxB5MG5u5HD1PhGelYpGXvgz5UTRy2cpNUzhrirfsBkONS
         dh1MIHYZYvjd40J1BuB973cIizoMFSbtsk23zBi760UW1XVFqaIemm9eMM4pWocbMObq
         jkegp6Hn+M8OJQ+q322YD+pnAfVchYBQjTiBpNf81yEC4KfrC2LKPueAxDcajGxCHdRI
         IkH2vCFmJH7lDywVFf5efs/wYMfoRZeNvJQtFfsPYfGx+iENYvQE8YFvGuncVqK1hG+3
         R4OSeiW1GHy5zr4o4j7wr6Ldc3wqJFP/VkTlOTu1KJLv/4ZGbTQhJzK+tLAucAC0Hf8g
         iqLQ==
X-Gm-Message-State: AOAM530p/fykMqMNvrjChqTF6xzUEDJD4N7wIl+z7dW4hC3GuNdafaTw
        8uZn+0Dd8UCzXS/l59C4pX0DSQ==
X-Google-Smtp-Source: ABdhPJz21F1hF0w8d/uGaxTFpi0mKtSscG/cstIbgprrV8ExxIOCeRxWE3/C74m+Haof5yb1KXRJqA==
X-Received: by 2002:a1c:7717:: with SMTP id t23mr3870714wmi.75.1595507138244;
        Thu, 23 Jul 2020 05:25:38 -0700 (PDT)
Received: from localhost.localdomain ([2.27.167.73])
        by smtp.gmail.com with ESMTPSA id j5sm3510651wma.45.2020.07.23.05.25.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2020 05:25:37 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        QLogic-Storage-Upstream@qlogic.com,
        Anil Veerabhadrappa <anilgv@broadcom.com>,
        Eddie Wai <eddie.wai@broadcom.com>
Subject: [PATCH 39/40] scsi: bnx2i: bnx2i_iscsi: Add parameter description and rename another
Date:   Thu, 23 Jul 2020 13:24:45 +0100
Message-Id: <20200723122446.1329773-40-lee.jones@linaro.org>
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

 drivers/scsi/bnx2i/bnx2i_iscsi.c:1288: warning: Function parameter or member 'cmds_max' not described in 'bnx2i_session_create'
 drivers/scsi/bnx2i/bnx2i_iscsi.c:2176: warning: Function parameter or member 'params' not described in 'bnx2i_nl_set_path'
 drivers/scsi/bnx2i/bnx2i_iscsi.c:2176: warning: Excess function parameter 'buf' description in 'bnx2i_nl_set_path'

Cc: QLogic-Storage-Upstream@qlogic.com
Cc: Anil Veerabhadrappa <anilgv@broadcom.com>
Cc: Eddie Wai <eddie.wai@broadcom.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/bnx2i/bnx2i_iscsi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index a9ffd89ec2c85..fdd446765311a 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -1276,6 +1276,7 @@ static int bnx2i_task_xmit(struct iscsi_task *task)
 /**
  * bnx2i_session_create - create a new iscsi session
  * @ep:		pointer to iscsi endpoint
+ * @cmds_max:		user specified maximum commands
  * @qdepth:		scsi queue depth to support
  * @initial_cmdsn:	initial iscsi CMDSN to be used for this session
  *
@@ -2170,7 +2171,7 @@ static void bnx2i_ep_disconnect(struct iscsi_endpoint *ep)
 /**
  * bnx2i_nl_set_path - ISCSI_UEVENT_PATH_UPDATE user message handler
  * @shost:	scsi host pointer
- * @buf:	pointer to buffer containing iscsi path message
+ * @params:	pointer to buffer containing iscsi path message
  */
 static int bnx2i_nl_set_path(struct Scsi_Host *shost, struct iscsi_path *params)
 {
-- 
2.25.1


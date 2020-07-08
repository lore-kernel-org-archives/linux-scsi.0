Return-Path: <SRS0=1cZD=AT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94E17C433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 12:03:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71B192065C
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 12:03:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="fMHkSCgx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729180AbgGHMDB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jul 2020 08:03:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729175AbgGHMC7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jul 2020 08:02:59 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F7BDC08E81E
        for <linux-scsi@vger.kernel.org>; Wed,  8 Jul 2020 05:02:59 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id k6so48695772wrn.3
        for <linux-scsi@vger.kernel.org>; Wed, 08 Jul 2020 05:02:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Hh5XWPq04WZIcyTw2TRmdhHW7NgKe3Z7t0gHGNMmsgU=;
        b=fMHkSCgxQ7hkuTaPlS/0D/KZJXqyBjHse5sLtImExlRx9Oy4hwhjNM+Ddp/0FTKdIc
         x6vWyX9nuSVFdk61OuqRqpUT5TQplqlJBM4lD/BJUXURVh6Sv9HGEI8DCLo1rPS/nigH
         pfU08yofXgOMQdbqj5htuW7eO3ZZt4PCiBQZlpp6lLEpFsuoOPIQcdy88/eSCUBMO0Lc
         ZbwtJ5VOukEyfhnz/4sULiAJJnoqbLo1pk/RiL7xG3OwrycGEaxmxsB5lQn+gVy8kWW9
         RLap/i3pUfK5jYxp7RjQtMDgV9wLzL3ny13wl1ObZUE6u7VWF36yNSnX+o/wi3dDvoM0
         Rszg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Hh5XWPq04WZIcyTw2TRmdhHW7NgKe3Z7t0gHGNMmsgU=;
        b=E/H4hPS7WeScpiR+MD06nS4RS0t+L/+AyRENXo1ncDs1IGjg0FyRAu9QE2o9M34Tfr
         cIYVN0yXAkBgFzYE39vyGn2dCDJ/QaevJn/z20OBiDAfPTpeg2O0A0T1oeIDqIB81YRj
         ke4PfoN4N32AWuIN5ppAoXtwBZcEC84ZBLixXC8wrm+wvpOdS7Iv8c1jfIQCBFGy+oMc
         MnnfJQQ1uYXiefTRYXTKiRxmMmaupip2ataCPndQew3HzCd1jji+ZmOCf3WdUo+Eh5Bj
         Q1/b1oRlnSsZLK/n9zbzHpp6QrNXQEj9CMXMWsd2oQY96P8xhRxhVLtZvCszdq5HJyLm
         vBvA==
X-Gm-Message-State: AOAM530hYGT1OL6yhe4RA5bOCSPjnAYd4SaJeVQj4tJdmcirNI8YZMk4
        F8o7RU/yBYHMo79WmIudekZznA==
X-Google-Smtp-Source: ABdhPJxJEBS1dYfw5wGdrR6htHKpeIzczomGy3iuyGyh+g0AUlw04I6l/CsnT5O7u4aEH6AxSwnX7Q==
X-Received: by 2002:a5d:540d:: with SMTP id g13mr54127802wrv.380.1594209778177;
        Wed, 08 Jul 2020 05:02:58 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.206])
        by smtp.gmail.com with ESMTPSA id m62sm3964997wmm.42.2020.07.08.05.02.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 05:02:57 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        QLogic-Storage-Upstream@cavium.com
Subject: [PATCH 23/30] scsi: qedf: qedf_debugfs: Demote obvious misuse of kerneldoc to standard comment blocks
Date:   Wed,  8 Jul 2020 13:02:14 +0100
Message-Id: <20200708120221.3386672-24-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200708120221.3386672-1-lee.jones@linaro.org>
References: <20200708120221.3386672-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

No attempt has been made to document any of the demoted functions here.

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/qedf/qedf_debugfs.c:25: warning: Function parameter or member 'qedf' not described in 'qedf_dbg_host_init'
 drivers/scsi/qedf/qedf_debugfs.c:25: warning: Function parameter or member 'dops' not described in 'qedf_dbg_host_init'
 drivers/scsi/qedf/qedf_debugfs.c:25: warning: Function parameter or member 'fops' not described in 'qedf_dbg_host_init'
 drivers/scsi/qedf/qedf_debugfs.c:25: warning: Excess function parameter 'pf' description in 'qedf_dbg_host_init'
 drivers/scsi/qedf/qedf_debugfs.c:51: warning: Function parameter or member 'qedf_dbg' not described in 'qedf_dbg_host_exit'
 drivers/scsi/qedf/qedf_debugfs.c:51: warning: Excess function parameter 'pf' description in 'qedf_dbg_host_exit'
 drivers/scsi/qedf/qedf_debugfs.c:64: warning: Function parameter or member 'drv_name' not described in 'qedf_dbg_init'

Cc: QLogic-Storage-Upstream@cavium.com
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/qedf/qedf_debugfs.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_debugfs.c b/drivers/scsi/qedf/qedf_debugfs.c
index b88bed9bb1338..a3ed681c8ce3f 100644
--- a/drivers/scsi/qedf/qedf_debugfs.c
+++ b/drivers/scsi/qedf/qedf_debugfs.c
@@ -14,10 +14,9 @@
 
 static struct dentry *qedf_dbg_root;
 
-/**
+/*
  * qedf_dbg_host_init - setup the debugfs file for the pf
- * @pf: the pf that is starting up
- **/
+ */
 void
 qedf_dbg_host_init(struct qedf_dbg_ctx *qedf,
 		    const struct qedf_debugfs_ops *dops,
@@ -42,10 +41,9 @@ qedf_dbg_host_init(struct qedf_dbg_ctx *qedf,
 	}
 }
 
-/**
+/*
  * qedf_dbg_host_exit - clear out the pf's debugfs entries
- * @pf: the pf that is stopping
- **/
+ */
 void
 qedf_dbg_host_exit(struct qedf_dbg_ctx *qedf_dbg)
 {
@@ -56,9 +54,9 @@ qedf_dbg_host_exit(struct qedf_dbg_ctx *qedf_dbg)
 	qedf_dbg->bdf_dentry = NULL;
 }
 
-/**
+/*
  * qedf_dbg_init - start up debugfs for the driver
- **/
+ */
 void
 qedf_dbg_init(char *drv_name)
 {
@@ -68,9 +66,9 @@ qedf_dbg_init(char *drv_name)
 	qedf_dbg_root = debugfs_create_dir(drv_name, NULL);
 }
 
-/**
+/*
  * qedf_dbg_exit - clean out the driver's debugfs entries
- **/
+ */
 void
 qedf_dbg_exit(void)
 {
-- 
2.25.1


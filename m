Return-Path: <SRS0=9eMh=27=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2081EC33CA2
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Jan 2020 12:45:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E9F4B20842
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Jan 2020 12:45:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b5XsA7DT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728192AbgAJMpP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Jan 2020 07:45:15 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:39390 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727753AbgAJMpP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Jan 2020 07:45:15 -0500
Received: by mail-pl1-f195.google.com with SMTP id g6so827438plp.6;
        Fri, 10 Jan 2020 04:45:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XiQjNY1xMxvJGSxUkChVfHVoiKMHp1TNrNrHF4ZFhmk=;
        b=b5XsA7DThL8r6GGH8yPwhCzBc8/TOhXIH1LFctpB2xpxTiR2m72+DbZJ4RtRFyln2a
         R5kta/LHKYotlALlWC9m9aS4lpRaY4viIDvfvqGRFmqxLHQ0VTSriLeoZY6+dArcDqd+
         2PoXgtCFBShumyyuigvCh+HKK8Iq/Rj9X3HRq+lgU/PY3u+ulxf9UL+c0FH4QAtLMQVZ
         pPMkMYmcYk8nUKGWbibfOyJwXC84jGJtcztcbjlhVl2h3AzUUPirGRUux2xBRYn4uYnT
         /d66fzJAl+k/KVeQI0RZyWY1OvFTbbbqGUATb/IrsIfmnj8rVC8t0JJ76P4h7slQguPU
         aMdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XiQjNY1xMxvJGSxUkChVfHVoiKMHp1TNrNrHF4ZFhmk=;
        b=XjJCI87axMXXGn9D5TAAwT8DPoNFdXIvc8oH2pKUqMFPhF9AWTxbFoP394eIxrm5kA
         2mzC4XV5cBFlN0uHpElqTzwV7mkmVy20V1LOD08kIhMO3nj0qki4GvFICbrS9ojGo/iJ
         I0BS4ej9DhxXpR2QRx7cLMvVZ9zsA0cSIgAy3IRhrgPmMQaHySSytXRmwBEPdPeLU1NX
         +Th+katQbhpKFlQ38+/JfsN2YnT59je22YUL49uQbrgKoyHsW78e1c/en1QAr5QT0eOC
         n02SGdYxcZFBXgS82RPdOiRdv+ccUplkuZXcsCkCCr8TmZueYfMff77jlQr3DaUPtOGO
         r4lw==
X-Gm-Message-State: APjAAAUKrebU84e9zsK1JLMMgb/jp68gDxNZR/wFsmUTMhmf+MKKBHk2
        IvIgugjQ5bDQn/gtkxX1LNs=
X-Google-Smtp-Source: APXvYqxXTdVEHBTBnbbB8JYku5LMrEpUI+NVX8F4bBlQ/zEjWRWUV7IiVO3ufElg/4V2oMKi0xiB4g==
X-Received: by 2002:a17:90a:3a86:: with SMTP id b6mr4553372pjc.96.1578660314074;
        Fri, 10 Jan 2020 04:45:14 -0800 (PST)
Received: from localhost.localdomain ([103.211.17.220])
        by smtp.googlemail.com with ESMTPSA id d3sm2764724pfn.113.2020.01.10.04.45.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2020 04:45:13 -0800 (PST)
From:   Amol Grover <frextrite@gmail.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Joel Fernandes <joel@joelfernandes.org>,
        Madhuparna Bhowmik <madhuparnabhowmik04@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Amol Grover <frextrite@gmail.com>
Subject: [PATCH 2/3] drivers: target: target_core_tpg: Pass lockdep expression to RCU lists
Date:   Fri, 10 Jan 2020 18:14:05 +0530
Message-Id: <20200110124403.27882-2-frextrite@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200110124403.27882-1-frextrite@gmail.com>
References: <20200110124403.27882-1-frextrite@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

tpg->tpg_lun_hlist is traversed with hlist_for_each_entry_rcu
outside an RCU read-side critical section but under the
protection of tpg->tpg_lun_mutex.

Hence, add the corresponding lockdep expression to the list traversal
primitive to silence false-positive lockdep warnings, and
harden RCU lists.

Add macro for the corresponding lockdep expression to make the code
clean and concise.

Signed-off-by: Amol Grover <frextrite@gmail.com>
---
 drivers/target/target_core_tpg.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index d24e0a3ba3ff..bc1c5dda81bf 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -30,6 +30,9 @@
 #include "target_core_pr.h"
 #include "target_core_ua.h"
 
+#define tpg_lun_mutex_held() \
+	lockdep_is_held(&tpg->tpg_lun_mutex)
+
 extern struct se_device *g_lun0_dev;
 
 /*	__core_tpg_get_initiator_node_acl():
@@ -110,12 +113,12 @@ void core_tpg_add_node_to_devs(
 	struct se_device *dev;
 
 	mutex_lock(&tpg->tpg_lun_mutex);
-	hlist_for_each_entry_rcu(lun, &tpg->tpg_lun_hlist, link) {
+	hlist_for_each_entry_rcu(lun, &tpg->tpg_lun_hlist, link,
+							tpg_lun_mutex_held()) {
 		if (lun_orig && lun != lun_orig)
 			continue;
 
-		dev = rcu_dereference_check(lun->lun_se_dev,
-					    lockdep_is_held(&tpg->tpg_lun_mutex));
+		dev = rcu_dereference_check(lun->lun_se_dev, tpg_lun_mutex_held());
 		/*
 		 * By default in LIO-Target $FABRIC_MOD,
 		 * demo_mode_write_protect is ON, or READ_ONLY;
-- 
2.24.1


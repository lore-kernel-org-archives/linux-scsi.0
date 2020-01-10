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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44C19C282DD
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Jan 2020 17:06:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1BCBA20661
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Jan 2020 17:06:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PhVSeVrU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727541AbgAJRGy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Jan 2020 12:06:54 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:43599 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727450AbgAJRGy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Jan 2020 12:06:54 -0500
Received: by mail-pf1-f196.google.com with SMTP id x6so1411478pfo.10;
        Fri, 10 Jan 2020 09:06:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RLhr45RoJXGQnRV7JLJiMgVzO70txR/YEjrlTrJZ7UY=;
        b=PhVSeVrUyIEGCIorTk8g5xUdqi3u78wH6knFhMtFpTNOa+M4lr0CexHagEdTL5gqf3
         0DSO32la9P0eBJg1TXyyVISeZC05NauRTHdkIlPlDaymiS1VIz9VZ7sSbltdjLcuTpUf
         c30cU8CFWJutf2Kx2Xr93irsNQX6ob8dZ/Y6nrmY8v7so71X2wluwCduV+Cter7skqas
         kH4o3SCNxBX9ENxLpjpSRhI23oagm5BETD95hYV9q+CjVoDwzjtcw2KataUsE2gW1myk
         h3L0GOAooqvtsqowNn+hoJhYA2DkFJvf8YHz3rJbZFH9Wd/W2vMw5eKMw7r1s6auOW1U
         /uWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RLhr45RoJXGQnRV7JLJiMgVzO70txR/YEjrlTrJZ7UY=;
        b=crTzepiZGnKtzUeZh6mlSpzTywRcHRZMpFFl/3gx6aVjIhqSEpe1efvIgsdsUP/nr6
         rx+a76MTrDBGRyeYn3Wg0qpzex9U5/iZnvZ2pZNBqe7dLpdgFmVYxZjUD3HjyA235wQg
         uR2rI4238Dj5DcDltvlTUZy9yRxQXKbv0CGF3R2NvsRv5y+VN/ByXC8yCN8sG5dsidu/
         ts0xSsl/TUlVCFNU3RAL7v8zlceOXReKNXfi7wR33HXf46tuzodCppznbC4JQBA3IGbm
         WoTQHS+WgS5vWUqFdjXEb5syMpAnPqpqvf/+eVrzJ0DyRf6T7fx3B2v0kaX5SlkCfxlI
         EPfg==
X-Gm-Message-State: APjAAAVRzJ2WkWS8qvc4FSetHOvb7sqySYO+y7R4qr2aVjbM+E1pn4WK
        bmwpon+7a83PD69vSwd3x2E=
X-Google-Smtp-Source: APXvYqxuHWRKp9D0rnGlVT2CZw2phPRFzBx8WfA6+qaKzw02yVbJKcn0hKB09/wXvEzK3YOcEn8u9g==
X-Received: by 2002:a63:214e:: with SMTP id s14mr5503825pgm.428.1578676012989;
        Fri, 10 Jan 2020 09:06:52 -0800 (PST)
Received: from localhost.localdomain ([103.211.17.220])
        by smtp.googlemail.com with ESMTPSA id x4sm3613268pff.143.2020.01.10.09.06.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2020 09:06:52 -0800 (PST)
From:   Amol Grover <frextrite@gmail.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Joel Fernandes <joel@joelfernandes.org>,
        Madhuparna Bhowmik <madhuparnabhowmik04@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Amol Grover <frextrite@gmail.com>
Subject: [PATCH v2 2/3] drivers: target: target_core_tpg: Pass lockdep expression to RCU lists
Date:   Fri, 10 Jan 2020 22:35:58 +0530
Message-Id: <20200110170558.23466-2-frextrite@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200110170558.23466-1-frextrite@gmail.com>
References: <20200110170558.23466-1-frextrite@gmail.com>
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
index d24e0a3ba3ff..0d89b738ca6e 100644
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
+				 tpg_lun_mutex_held()) {
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


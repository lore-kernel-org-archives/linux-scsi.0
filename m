Return-Path: <SRS0=Mkh6=3G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2CDEC33CB7
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 13:40:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 99116214AF
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 13:40:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j15iXKGq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbgAQNkR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Jan 2020 08:40:17 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:38248 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726861AbgAQNkQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Jan 2020 08:40:16 -0500
Received: by mail-pl1-f194.google.com with SMTP id f20so9891272plj.5;
        Fri, 17 Jan 2020 05:40:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RlKM/XYrBa3kEOwzCqWtgXvilXlmKMO+nK4gGJZhPfg=;
        b=j15iXKGqjYlNBJ1O5MSIPLWXuL/l4gus32mS8VNjxmISFECRxV5UZEPyHvRH6yoQLO
         uO4qX4SvAMVnuN+JxcDHCmJ6Gsp6dOhvkk929w+ntR8qY+Ztw8hObJ2GNudF+tkNALDA
         l+RMK5xSjtCPuFAtz8/lE4mOWThFWTjgw8BmcUHvZbZctPRvyg4ef2fRfrCRwb3LjY1w
         LMN1l7RF/4hgRpgYwrTI8doJZzjLMIc0u0EROorqpVdYkUaoj/Wj39EYG3zCIa07R2QV
         5Eg2S48eXDdQYhiXyVafm2Cc3tx6lssLzMDuY9Xy3ylGnJLts8EvE+LxOtEmk9OFwL9l
         8r0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RlKM/XYrBa3kEOwzCqWtgXvilXlmKMO+nK4gGJZhPfg=;
        b=I2ZD380EUxxUM38G4u0IKcJKFOg/RrWFE90njIz3/LuejcyR0URddtVz/PW9OOCLB/
         6VoUGl5vpfhAUtf98f18eu+X0b1diacw4aqZD9nugXqe/GvhSytUL6CaRwZ8FIyyr0Pl
         206vYeUGFt9P5OZkecB2X5xn/QX83IKFg8kIY54cOgjYQPb4B6WG/DYK7mf1Hgx2PYp1
         yt+b5QUCflvVqyzaPtLNvYSJQqxyjIcz7Pm8iTu1vcx6QbQ2mGeTAwWPGFVAoQji6Eet
         wlknV3Onqyri/pysbI5z6vbtAV4X8QNwB8jfI4P4+gLOv+fF5MNBKfDZ8BAE8k3T8eyr
         CxJA==
X-Gm-Message-State: APjAAAXAwDwyVfXOTJhudCxzzxm47g63nDsJtQm25O3v1QgSkYluqSSP
        G4UbC0P22P+MWxyoAO10WTc=
X-Google-Smtp-Source: APXvYqzxmaDfnD4G85RlkpYrpXtxDrj9FaouwSSrEYObW8QCM4XIkoNSNpMzFf8n3qW5tBKyql+dKg==
X-Received: by 2002:a17:902:8d8a:: with SMTP id v10mr28505346plo.90.1579268416120;
        Fri, 17 Jan 2020 05:40:16 -0800 (PST)
Received: from localhost.localdomain ([103.211.17.168])
        by smtp.googlemail.com with ESMTPSA id s18sm29522422pfh.179.2020.01.17.05.40.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2020 05:40:15 -0800 (PST)
From:   Amol Grover <frextrite@gmail.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Joel Fernandes <joel@joelfernandes.org>,
        Madhuparna Bhowmik <madhuparnabhowmik04@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Amol Grover <frextrite@gmail.com>
Subject: [PATCH v3 1/3] drivers: target: target_core_device: Pass lockdep expression to RCU lists
Date:   Fri, 17 Jan 2020 19:08:53 +0530
Message-Id: <20200117133854.32550-1-frextrite@gmail.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

nacl->lun_entry_hlist is traversed with hlist_for_each_entry_rcu
outside an RCU read-side critical section but under the
protection of nacl->lun_entry_mutex.

Hence, add the corresponding lockdep expression to the list traversal
primitive to silence false-positive lockdep warnings, and
harden RCU lists.

Signed-off-by: Amol Grover <frextrite@gmail.com>
---
v3:
- Remove rcu_read_lock_held() from lockdep expression since it is
  implicitly checked for.
- Remove unintended macro usage.

v2:
- Fix sparse error
  CHECK: Alignment should match open parenthesis

 drivers/target/target_core_device.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 2d19f0e332b0..306c626183d5 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -247,7 +247,8 @@ void core_free_device_list_for_node(
 	struct se_dev_entry *deve;
 
 	mutex_lock(&nacl->lun_entry_mutex);
-	hlist_for_each_entry_rcu(deve, &nacl->lun_entry_hlist, link) {
+	hlist_for_each_entry_rcu(deve, &nacl->lun_entry_hlist, link,
+				 lockdep_is_held(&nacl->lun_entry_mutex)) {
 		struct se_lun *lun = rcu_dereference_check(deve->se_lun,
 					lockdep_is_held(&nacl->lun_entry_mutex));
 		core_disable_device_list_for_node(lun, deve, nacl, tpg);
@@ -276,7 +277,8 @@ struct se_dev_entry *target_nacl_find_deve(struct se_node_acl *nacl, u64 mapped_
 {
 	struct se_dev_entry *deve;
 
-	hlist_for_each_entry_rcu(deve, &nacl->lun_entry_hlist, link)
+	hlist_for_each_entry_rcu(deve, &nacl->lun_entry_hlist, link,
+				 lockdep_is_held(&nacl->lun_entry_mutex))
 		if (deve->mapped_lun == mapped_lun)
 			return deve;
 
@@ -460,7 +462,8 @@ void core_clear_lun_from_tpg(struct se_lun *lun, struct se_portal_group *tpg)
 	list_for_each_entry(nacl, &tpg->acl_node_list, acl_list) {
 
 		mutex_lock(&nacl->lun_entry_mutex);
-		hlist_for_each_entry_rcu(deve, &nacl->lun_entry_hlist, link) {
+		hlist_for_each_entry_rcu(deve, &nacl->lun_entry_hlist, link,
+					 lockdep_is_held(&nacl->lun_entry_mutex)) {
 			struct se_lun *tmp_lun = rcu_dereference_check(deve->se_lun,
 					lockdep_is_held(&nacl->lun_entry_mutex));
 
-- 
2.24.1


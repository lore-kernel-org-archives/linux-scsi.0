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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C480C33CA2
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Jan 2020 12:45:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 42FD720838
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Jan 2020 12:45:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="vYN1KwOD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728048AbgAJMpA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Jan 2020 07:45:00 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:36301 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727753AbgAJMpA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Jan 2020 07:45:00 -0500
Received: by mail-pf1-f195.google.com with SMTP id x184so1107860pfb.3;
        Fri, 10 Jan 2020 04:45:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zHdRnTZJjcN2zvUamZ1G4RdksTFXX4xdkIF3BaNA6s0=;
        b=vYN1KwODkuLwoJBLCz+Dts31AwF9BgZlEnoJjsl4ZuH5wuSA4lytftMrkJQ9Y1LVVn
         kOOZmOnYt8I+8te7xUnJ6aJkUj0LK0clSL5yTYOaJzSPqm6Urt8wWTx9OxOtSsFiE1D6
         BpDp6ET4ApCD8FiK2JKLsWx0iZVNJ9zfIvn2C+JUhrp4Lc48lp+C2+s5lybjjn2F4Zv5
         XigX4O22jYy9aAhFQQHCWMA9AicRg9qEBwbjuStCu51rPAv9jTo3qziLul6HCftfRSDL
         vJ34xmC1Kre5k8uefnmDLn+Mz/jYhLmzT3TpP2GgeQrDtht5YOS7d/6T5w2x8yPzq72A
         n6Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zHdRnTZJjcN2zvUamZ1G4RdksTFXX4xdkIF3BaNA6s0=;
        b=DVuvO2fXLASH93TsghiYAc+EQRJURCgknDA2hsKw2X8Ri3Obg9xDyrBzHOuLKfG8+i
         i0i5ydrCewofNcDfQ/wx5CXMYQ83R4GInWmL51WPqQLVURKliseS7N1/lUxUsp7+Z+zW
         Oghpm+jCd59W+xZX5HHJheAmhuX/cxxSnWMGlstwNOQbwXjBOhfOm+8TywvImsKu3m8M
         jau0fZScNMMKMRgGr+RfT/REnz1OAaf5HHAcxdJK5AXr1a1oC9183VP8VL7y1x8EAZ7P
         wGV0V0VWvBSh9N2MlvKn7Jf//OPvdT5Nr8bfXdT99ZUzURa2IBBlWgOUsLPKtoIV6r+d
         zIbA==
X-Gm-Message-State: APjAAAUMLz64uu++MZkfK7i59mzLt3drHs4zpciNcgh7/NMjjWyf2Lax
        g1AqyE/so3Zmv+5unAIPTYE=
X-Google-Smtp-Source: APXvYqwsz2ALkDAVbByjWYV7EWu7XtAQh5kTGDka+88oUueTAZ6ddpkiHOT3dPiym7rxZysPhqqMuA==
X-Received: by 2002:aa7:824d:: with SMTP id e13mr3848868pfn.247.1578660299863;
        Fri, 10 Jan 2020 04:44:59 -0800 (PST)
Received: from localhost.localdomain ([103.211.17.220])
        by smtp.googlemail.com with ESMTPSA id d3sm2764724pfn.113.2020.01.10.04.44.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2020 04:44:59 -0800 (PST)
From:   Amol Grover <frextrite@gmail.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Joel Fernandes <joel@joelfernandes.org>,
        Madhuparna Bhowmik <madhuparnabhowmik04@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Amol Grover <frextrite@gmail.com>
Subject: [PATCH 1/3] drivers: target: target_core_device: Pass lockdep expression to RCU lists
Date:   Fri, 10 Jan 2020 18:14:03 +0530
Message-Id: <20200110124403.27882-1-frextrite@gmail.com>
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

Add macro for the corresponding lockdep expression to make the code
clean and concise.

Signed-off-by: Amol Grover <frextrite@gmail.com>
---
 drivers/target/target_core_device.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 2d19f0e332b0..2d1277a83916 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -36,6 +36,9 @@
 #include "target_core_pr.h"
 #include "target_core_ua.h"
 
+#define lun_entry_mutex_held() \
+	lockdep_is_held(&nacl->lun_entry_mutex)
+
 static DEFINE_MUTEX(device_mutex);
 static LIST_HEAD(device_list);
 static DEFINE_IDR(devices_idr);
@@ -247,9 +250,10 @@ void core_free_device_list_for_node(
 	struct se_dev_entry *deve;
 
 	mutex_lock(&nacl->lun_entry_mutex);
-	hlist_for_each_entry_rcu(deve, &nacl->lun_entry_hlist, link) {
+	hlist_for_each_entry_rcu(deve, &nacl->lun_entry_hlist, link,
+							lun_entry_mutex_held()) {
 		struct se_lun *lun = rcu_dereference_check(deve->se_lun,
-					lockdep_is_held(&nacl->lun_entry_mutex));
+							lun_entry_mutex_held());
 		core_disable_device_list_for_node(lun, deve, nacl, tpg);
 	}
 	mutex_unlock(&nacl->lun_entry_mutex);
@@ -276,7 +280,8 @@ struct se_dev_entry *target_nacl_find_deve(struct se_node_acl *nacl, u64 mapped_
 {
 	struct se_dev_entry *deve;
 
-	hlist_for_each_entry_rcu(deve, &nacl->lun_entry_hlist, link)
+	hlist_for_each_entry_rcu(deve, &nacl->lun_entry_hlist, link,
+				rcu_read_lock_held() || lun_entry_mutex_held())
 		if (deve->mapped_lun == mapped_lun)
 			return deve;
 
@@ -339,7 +344,7 @@ int core_enable_device_list_for_node(
 	orig = target_nacl_find_deve(nacl, mapped_lun);
 	if (orig && orig->se_lun) {
 		struct se_lun *orig_lun = rcu_dereference_check(orig->se_lun,
-					lockdep_is_held(&nacl->lun_entry_mutex));
+							lun_entry_mutex_held());
 
 		if (orig_lun != lun) {
 			pr_err("Existing orig->se_lun doesn't match new lun"
@@ -460,9 +465,10 @@ void core_clear_lun_from_tpg(struct se_lun *lun, struct se_portal_group *tpg)
 	list_for_each_entry(nacl, &tpg->acl_node_list, acl_list) {
 
 		mutex_lock(&nacl->lun_entry_mutex);
-		hlist_for_each_entry_rcu(deve, &nacl->lun_entry_hlist, link) {
+		hlist_for_each_entry_rcu(deve, &nacl->lun_entry_hlist, link,
+							lun_entry_mutex_held()) {
 			struct se_lun *tmp_lun = rcu_dereference_check(deve->se_lun,
-					lockdep_is_held(&nacl->lun_entry_mutex));
+							lun_entry_mutex_held());
 
 			if (lun != tmp_lun)
 				continue;
-- 
2.24.1


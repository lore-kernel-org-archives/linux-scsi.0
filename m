Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F7E3C001B0
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Jul 2023 12:14:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233832AbjGZMOe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Jul 2023 08:14:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233760AbjGZMOd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Jul 2023 08:14:33 -0400
X-Greylist: delayed 603 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 26 Jul 2023 05:14:31 PDT
Received: from mta-04.yadro.com (mta-04.yadro.com [89.207.88.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE55B1996;
        Wed, 26 Jul 2023 05:14:30 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-04.yadro.com 3C4A6C0007
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-04;
        t=1690372545; bh=ICN7tlynP85fwkGe9KVycdQY4u70ICUlf+EORDl5EIw=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
        b=bczdRjMddyXzkQuWL/AsiPqaJfeoVSyD0OJpjAKj66M86aA//PpOFPGvHASN7auH9
         zer/xACHr4Zc+rhlYrYfKMtOJtBfptBKd9coUmJdEWntvRBCK4dNuYatGv1h497qug
         0KpRUIc+jwydR9YGAdSEHfqcDanWxiqAcMM1r6b93IK952yeAAjPdVxcstf03lvDlG
         mvM96EvU4r0hpZewVPMI2322rLkGtQvnKMBIo8b0D6p+FnWLdQMcVM99doIpjC+I+0
         2palc68AB1XHguekOVJBXzAysBdwuqQZeCcIKtLqdZlWJR6JGyHIJDaBd0fqzjHIoI
         yBARvZ4E0e0rA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-03;
        t=1690372545; bh=ICN7tlynP85fwkGe9KVycdQY4u70ICUlf+EORDl5EIw=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
        b=kgAf1yfwXgT6MIKUqV++OCVOTbrD1twg8LiONZktZPAoH3yJuCij6BrDOe5i6Bxy7
         4ObMJvJvO9PcvJRVyq5H8ybiewaeeu/0MyRKJREEEDTPUu/MVP8iVCxXEq3IAHBgCE
         Umy9lCZ/M56EHzVY4YPnk/q9ISo3qtu4zkl1AZ8bwbCJij4NQDxqayy0+b7TXvP2Dd
         SRfak+jepgXnFh7mraJ/pFrd89z1DogbUKPNqOwiT4ubjqOTz0SjmhzxcERgeyhHef
         HihSMmU3JJ16gO8fzh3sD1Kifw1uDgpBC/OZe3bPPWKTva5ZLEZ0TjNP/uTmpFCbmO
         pnei4RtweErwQ==
From:   Anastasia Kovaleva <a.kovaleva@yadro.com>
To:     <martin.petersen@oracle.com>, <michael.christie@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>,
        <linux@yadro.com>
Subject: [RFC PATCH 1/3] target: core: Initial work on improving SCSI target logs
Date:   Wed, 26 Jul 2023 14:55:07 +0300
Message-ID: <20230726115509.357-2-a.kovaleva@yadro.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230726115509.357-1-a.kovaleva@yadro.com>
References: <20230726115509.357-1-a.kovaleva@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-ClientProxiedBy: T-EXCH-10.corp.yadro.com (172.17.11.60) To
 T-EXCH-09.corp.yadro.com (172.17.11.59)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Introduce the new logging wrapper.

Signed-off-by: Anastasia Kovaleva <a.kovaleva@yadro.com>
---
 include/target/target_core_base.h | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 159567359bbb..ba8c05dc3d54 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -11,6 +11,31 @@
 
 #define TARGET_CORE_VERSION		"v5.0"
 
+/*
+ * Unified target core logs
+ */
+#define target_sess_log(lvl, sess, fmt, ...) pr_##lvl("target " TARGET_PREFIX " (%s -> %d): " fmt, \
+		(sess)->se_node_acl->initiatorname, (sess)->se_tpg->tpg_rtpi, ##__VA_ARGS__)
+#define target_cmd_log(lvl, cmd, fmt, ...) pr_##lvl("target " TARGET_PREFIX " (%s -> %d/%lld): " fmt, \
+		(cmd)->se_sess->se_node_acl->initiatorname, (cmd)->se_lun->lun_tpg->tpg_rtpi, \
+		(cmd)->orig_fe_lun, ##__VA_ARGS__)
+#define target_log(lvl, fmt, ...) pr_##lvl("target " TARGET_PREFIX ": " fmt, ##__VA_ARGS__)
+
+#define target_sess_debug(sess, fmt, ...) target_sess_log(debug, sess, fmt, ##__VA_ARGS__)
+#define target_sess_info(sess, fmt, ...)  target_sess_log(info, sess, fmt, ##__VA_ARGS__)
+#define target_sess_warn(sess, fmt, ...)  target_sess_log(warn, sess, fmt, ##__VA_ARGS__)
+#define target_sess_err(sess, fmt, ...)   target_sess_log(err, sess, fmt, ##__VA_ARGS__)
+
+#define target_cmd_debug(cmd, fmt, ...) target_cmd_log(debug, cmd, fmt, ##__VA_ARGS__)
+#define target_cmd_info(cmd, fmt, ...)  target_cmd_log(info, cmd, fmt, ##__VA_ARGS__)
+#define target_cmd_warn(cmd, fmt, ...)  target_cmd_log(warn, cmd, fmt, ##__VA_ARGS__)
+#define target_cmd_err(cmd, fmt, ...)   target_cmd_log(err, cmd, fmt, ##__VA_ARGS__)
+
+#define target_debug(fmt, ...) target_log(debug, fmt, ##__VA_ARGS__)
+#define target_info(fmt, ...)  target_log(info, fmt, ##__VA_ARGS__)
+#define target_warn(fmt, ...)  target_log(warn, fmt, ##__VA_ARGS__)
+#define target_err(fmt, ...)   target_log(err, fmt, ##__VA_ARGS__)
+
 /*
  * Maximum size of a CDB that can be stored in se_cmd without allocating
  * memory dynamically for the CDB.
-- 
2.40.1


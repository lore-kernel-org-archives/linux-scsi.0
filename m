Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B834C433E9
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Feb 2021 21:40:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B7BC64E2F
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Feb 2021 21:40:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbhBTVkO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 20 Feb 2021 16:40:14 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:44367 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbhBTVkK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 20 Feb 2021 16:40:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1613857209; x=1645393209;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=dkPKjCBqGhzrj49JVwhxDItCZsnR/tu5CdenH05pm8E=;
  b=M1JlQLa3lDh2tR4hHZx9tCfk5PoCH2usSHpWIDdFT695lE1nlUY+MEMg
   cQrVY4Fcgv7pFzf52yLfXzjxK+r9bu38h+DwTJ0DaGdqw+aw0ICm2h97y
   qCo7SlZGlC7/2q/r35yP1RqTXTrk8TCspVbEpCkB0Uza5CMob6PhfE5oq
   oSyuzhoB+HWt63LtdLBdEgsviEd+BnxrBwn9mAMlLRjj1sYe/tv5IVPsY
   ery1TxRRYeSfOZkT6hnwzuVyrDFFthSYMW/TlbOiScOHPpLU5CTqOfDxC
   zbdE6ZbEDB3gDlc1k1oUELpnbXwU24HZxxGJ1Qg5McUx3GfctuRqnwYvG
   Q==;
IronPort-SDR: 94lvgYRGsvKJLBHzidWcMceV23gEf6Xp04TsnyfNfeuTg48+l9zrdkFc3R4oLtR+BX5pDd0LVG
 fzQvNUqzIHHdLfLeibxFLafqzaUZdNR6NoRkz+qGVFikiA8QQWeaV2O9Utw8q/2ZpiRjkk+eaE
 P4pgLiFU0QGQABqGJ6dEriJPw7Xi1oMTv36okhXpmIpudR34pFad6kXgOyckX+50Z0QTmDv5Je
 nV15rQOl/SV4lC0QqUjbDIa7vSR+PLum0IXH7arcBXDDSBAaq9J1Du9bB36JDvxn/ir+TABSBn
 iww=
X-IronPort-AV: E=Sophos;i="5.81,193,1610380800"; 
   d="scan'208";a="164901599"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 21 Feb 2021 05:39:04 +0800
IronPort-SDR: y6RkL/9nZxV2k01TSdjcZOJEo80dexmWhZXTJYomUh72F1nEsbQ4Kj7umhoxgZwf5il4wsd6Ex
 yDk85E+q1E93nBmo+MPk+DUVZcaejFprFGxuQa7xkGnQ6QpDf20cfobyRzwzEReeOe3lKovYSk
 Q9XwLFDLhIgssgKqJEsQUKRw4Uvt9AhkAivXJOx1/dJj3sBJ0gx8/HppwIhxHDSKUChmnboYJX
 Ewmz9yvf5+GGS0YnU7l/gwo7sgrSQS04nvd1KgqYHaUWudrKVCGTGblFJDYMYj/RY9nkVno3ad
 m9dgR1+wQrYAfoBhxcZJmGfs
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2021 13:20:38 -0800
IronPort-SDR: Q3LpWj3g9+0qMJKlrnZHsIrMzpmnQQhLrgveo6+dMRZ472AO4pvaDRP4eFk3nPxLsJk6kRVRJV
 fXKq1lyAwHOHey1yPbd/p8crcaLuVhhI6IvZbu5370ETxtOtjDv8d5J5lbvqJvVFWZZzY5E2g/
 Ib/pg1Yqs1C8RL/N+5kIwXqoThh+N0aP4eaS5xC31i4pTu8I+suV90r/lkmbpLuQJ2P32g0r9/
 dlDjpkufCe17WuyxvCepVyxWdgLqTSmzq3FrMZzj5lkpUaWxcbYSx50vCKY/l35I8lj3AWe0b1
 P6c=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
  by uls-op-cesaip02.wdc.com with ESMTP; 20 Feb 2021 13:39:04 -0800
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     martin.petersen@oracle.com, hare@suse.de, jejb@linux.ibm.com,
        mlombard@redhat.com, michael.christie@oracle.com,
        houpu@bytedance.com,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [RFC PATCH 12/24] target/iscsi: remove the memset with declare-init
Date:   Sat, 20 Feb 2021 13:39:02 -0800
Message-Id: <20210220213902.6875-1-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.22.1.dirty
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 drivers/target/iscsi/iscsi_target_configfs.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
index 0fa1d57b26fa..f4a24fa5058e 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -161,14 +161,13 @@ static struct se_tpg_np *lio_target_call_addnptotpg(
 	char *str, *str2, *ip_str, *port_str;
 	struct sockaddr_storage sockaddr = { };
 	int ret;
-	char buf[MAX_PORTAL_LEN + 1];
+	char buf[MAX_PORTAL_LEN + 1] = { };
 
 	if (strlen(name) > MAX_PORTAL_LEN) {
 		pr_err("strlen(name): %d exceeds MAX_PORTAL_LEN: %d\n",
 			(int)strlen(name), MAX_PORTAL_LEN);
 		return ERR_PTR(-EOVERFLOW);
 	}
-	memset(buf, 0, MAX_PORTAL_LEN + 1);
 	snprintf(buf, MAX_PORTAL_LEN + 1, "%s", name);
 
 	str = strstr(buf, "[");
-- 
2.22.1


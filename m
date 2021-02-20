Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78A95C433DB
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Feb 2021 21:39:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5228464ED6
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Feb 2021 21:39:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbhBTVju (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 20 Feb 2021 16:39:50 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:39682 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229905AbhBTVjs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 20 Feb 2021 16:39:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1613857311; x=1645393311;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=UzfZSkl2ERUTQxd8Z1s7Xi8Ud/dhl5VaL2EVyOdZxNE=;
  b=eX41LTQ9mokped35dFKljFQKSd2owubNFUqtkh9oiyyCc2qBjXtPys0r
   KwOqHB9YZSNOHQKZKXlBNchFdSzVYo04srZwDb1tDs0K80QNeoV5E/iAs
   pCooSHgIRTv+wQCYJzY4Ylhb7Pf6vruSJehKYZA1p4gsanngGJt+ULFHc
   A56OUW0Pwkwu5UTcypiBPabyDTR1qn84Nd0F2/cGrdfixKTh9ZbPbJ+Qs
   SzimfyHwqFVd8gCCLzNSkLwaNYCAVj18DdQl/R8x0NkDjpitqxyDlk69g
   pOklOKm/1ifi1KWt2guaz/XNVCeUcSncyFE5aohFywIpwdGe5CT8VTWLG
   w==;
IronPort-SDR: G7OEb3CALMr/T8GZbznBpIXt1qy5S5bWD5km4yQf51KH3QQntiwXC+BfLP95GeaQst5Qqguhb2
 S0O88hUbMomPlxjECC5MgIwpy4aJJPYtm5M36y8+hhvysQ71zJfkc7NScIJQfYW5Ld4YYeWW9U
 s6jlcyihe97DCQcWhygsgu6qhRUjVmI/9ZFlUM7exoo6xI4M0bDb823/TlscbS1T8glkOUH+fU
 AQqtLxdNSwI3ZbyEfMvrh6dwEQkpexgU/h1Wo3+6vaVKM+SeT9Zgt0m3itEzBKmbtrydTMfAKv
 QxM=
X-IronPort-AV: E=Sophos;i="5.81,193,1610380800"; 
   d="scan'208";a="264605647"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 21 Feb 2021 05:39:56 +0800
IronPort-SDR: x3EzsZodpZuOV9dKSNy5VaiC8DUkoo0WvtSJhC+JoObFCNLZ+Hw/GbyUr58ZBPy6J0ftLZL9U7
 B6cdVvqAtYyK0+drpSOW5v12EGJlBu/AD+iHY+7hSSjLquJ+R87vv9GJvq1YXqDUGGA19z+mlk
 jiD4/HYyk1XM4Fu9sujwLXRDpu43fApuxR/Ll2doXd3cYHZkaTDFtJQEARACV42tY6CI7ZTGs+
 ETBVMLSkG5E4TsezCl6CSFWPRVS8lBhu/f5kxoiiH+2FqTLE4yuajyCYMKii7cU7VqqF+vsYvL
 lsYtYoUftHFkXMK+7bG0hZ6S
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2021 13:20:05 -0800
IronPort-SDR: sms1MttXnuy8nmA7KlNL+oQnw5RE6SdaQWB4XRnNjyS6eY2TYUSinkWrAfgLNANZjDRtSMP54p
 1rsS8KDq6yPQ6lGna2AoHkxu6+ca6GZ/xHHyiVQuQ7Yey/wri4c7EFJe+mTiXqiRqK68Haz3sm
 Zuq10LQ3DNoDDLcfbvYtJuBJm1kkJNJghrmOffqYdaBvBU6N3iR6jjhCLdYQcnd+zAwCBatOpS
 eIE3IXQ9tUJzOskybYmF9fztIhNNSPDThoKn640ZtqWcwZuQDzJP3qA5XTLuKtJEyYffUSwAFl
 XnQ=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
  by uls-op-cesaip02.wdc.com with ESMTP; 20 Feb 2021 13:38:32 -0800
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     martin.petersen@oracle.com, hare@suse.de, jejb@linux.ibm.com,
        mlombard@redhat.com, michael.christie@oracle.com,
        houpu@bytedance.com,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [RFC PATCH 09/24] target/stat: remove unsed macro
Date:   Sat, 20 Feb 2021 13:38:30 -0800
Message-Id: <20210220213830.6743-1-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.22.1.dirty
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 drivers/target/iscsi/iscsi_target_stat.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target_stat.c b/drivers/target/iscsi/iscsi_target_stat.c
index 35e75a3569c9..cce3a827059e 100644
--- a/drivers/target/iscsi/iscsi_target_stat.c
+++ b/drivers/target/iscsi/iscsi_target_stat.c
@@ -28,7 +28,6 @@
 /* Instance Attributes Table */
 #define ISCSI_INST_NUM_NODES		1
 #define ISCSI_INST_DESCR		"Storage Engine Target"
-#define ISCSI_INST_LAST_FAILURE_TYPE	0
 #define ISCSI_DISCONTINUITY_TIME	0
 
 #define ISCSI_NODE_INDEX		1
-- 
2.22.1


Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99ED9C433DB
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Feb 2021 21:40:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7375A64ED6
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Feb 2021 21:40:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbhBTVkn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 20 Feb 2021 16:40:43 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:43906 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbhBTVkm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 20 Feb 2021 16:40:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1613857242; x=1645393242;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=t+uWJ2/u6p0oAIiWW+m/7/RLXqMtQsWSoqAEYSXfJYg=;
  b=I1MgMyYFmyVQLWb9Y8cUR+0kFlXqoeZfD+ZlSBh/5IUKHj4pGkt9mqzW
   34ljelkWJWNBvcLBTxpcy38sRmZb7nhMs13kV9Vh9tp8IpWVsx3tZDSEs
   vrIG/ctiSJOPK4KmLYucIqunmqKpo05/5dt1AmwxWaQZjm9QOf71bopKA
   0Xe0cSelnB3mXvKKJ2E0ycEShK+3O1DhbAzyQHg1WvbSxOlAtddWIUVnd
   XxTGr6XIfHjEB6KUmYqGI+BlDe2Q3oAuPEWFTRP+0/+cdKawQ8n7Bz5m+
   EyWcdk2ieZFNW8XhT+vsH5QegPavkt8E5BZoqtv1gqgurEgExwFbmOzEF
   w==;
IronPort-SDR: /3HNxwWcmf6Wn05ncdWmVTBDSxbmNXqo7ZiI7QI/obufQpN+mTIPUubv1Cjh73Yhx2SxWOEXY8
 cQg7naSpA2v0uSCk+rzVOBZV2VrOYHBk4wulFGNmXiLAGLrLAzhmMwFKsEzYFshOSYdQOaJVQv
 F6vjpOqW+VESS4foFT2JKkxqpkYqdhI9erNZJLeaGhrjKTW5S8mIhEw+AXf6goUFjO2brtqT/I
 wZwSpwJpvqu/ssbQsCTjFCn4w7l6vnPAvmo5vcSnefbDt2cae+SDBFqTTkn4gekMObaKwnziw7
 8ss=
X-IronPort-AV: E=Sophos;i="5.81,193,1610380800"; 
   d="scan'208";a="161591293"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 21 Feb 2021 05:39:37 +0800
IronPort-SDR: Hdi/VKpx0kvYO9QrHAzxMmmkRLUzb/6IjpZ7jW3wjqVuOZ9PjCyU98Q5NhjKHr8jpnCYrTE5RV
 oV931X5cWDb6cjyVInEDBMCB2FQegqh6MMGjZmQZpFC9EE9EteNmjq3XK3gZ7Nb+jDS2b/UBf5
 54HQdwbaagzDsvjfDJViP85URZebxzNo5iZeBCCgYydkcH8WdXBOhPjPPqetixH7Ff0eJ2mv86
 KlziyBh7oBPPv0FTPaQpVLBJgtJUvHmfZYJ/0nTxxZQeNElJX0FcdfflJO0N0um34YKUH76Orl
 poSH8aNdamQ7BjbGyX+teBLl
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2021 13:21:10 -0800
IronPort-SDR: ielavNkhAPhZ4LbGkQoEqArFC5Bm3wi9CMlYNoFR372SpX0hSzlatwI2EtWljX69cEREXCvOi8
 U70zakfTbJL5io0KyZTXPTyUm8YHa4inDHr3Q9xsoSfmgnzLsn2OOGl/ZqYyJv5gEewY15GA/e
 G6jAzZ4X4sA2234BBuX53TSXLs3q/RmasiFj4Kcowm2/zXzKgOGJ4aK85OVLxTIB5G0RgsY2cs
 qBuudkVtsAGUxul+9vgu/jVHVG/oiLXGBcMqaJM81PrLZ1Xa8yfAy0aaCVt9ZRJrQKYSOI8XCP
 z1I=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
  by uls-op-cesaip02.wdc.com with ESMTP; 20 Feb 2021 13:39:37 -0800
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     martin.petersen@oracle.com, hare@suse.de, jejb@linux.ibm.com,
        mlombard@redhat.com, michael.christie@oracle.com,
        houpu@bytedance.com,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [RFC PATCH 15/24] target/configfs: remove the memset with declare-init
Date:   Sat, 20 Feb 2021 13:39:35 -0800
Message-Id: <20210220213935.7026-1-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.22.1.dirty
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 drivers/target/target_core_configfs.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 4c60334a1e9f..315791b5554a 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -2283,7 +2283,7 @@ static ssize_t target_dev_alua_lu_gp_store(struct config_item *item,
 	struct se_hba *hba = dev->se_hba;
 	struct t10_alua_lu_gp *lu_gp = NULL, *lu_gp_new = NULL;
 	struct t10_alua_lu_gp_member *lu_gp_mem;
-	unsigned char buf[LU_GROUP_NAME_BUF];
+	unsigned char buf[LU_GROUP_NAME_BUF] = { };
 	int move = 0;
 
 	lu_gp_mem = dev->dev_alua_lu_gp_mem;
@@ -2294,7 +2294,6 @@ static ssize_t target_dev_alua_lu_gp_store(struct config_item *item,
 		pr_err("ALUA LU Group Alias too large!\n");
 		return -EINVAL;
 	}
-	memset(buf, 0, LU_GROUP_NAME_BUF);
 	memcpy(buf, page, count);
 	/*
 	 * Any ALUA logical unit alias besides "NULL" means we will be
-- 
2.22.1


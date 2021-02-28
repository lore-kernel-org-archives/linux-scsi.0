Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 750FBC433E0
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Feb 2021 05:59:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D33B64E54
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Feb 2021 05:59:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230258AbhB1F7x (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 28 Feb 2021 00:59:53 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:36622 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230235AbhB1F7w (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Feb 2021 00:59:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614492696; x=1646028696;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vXAxN9MI62o8rzI8RxdTpG+7QbGBO45tb1tY17jlbrA=;
  b=RLFBF9uw9IzXbdI7pLoG2wb1Uvj++lm22wT3HHUwVamc+ouCcLW1BaE3
   54GUUbSxqRUcbCUAB/LWIg1xuHwHnSyS+r3fDqsxszH1kdw45H8hLHFhO
   5LZKG347d3uWvdbK/rQarDqUMS05yCdkm7yuoo1fHUx/hVrjRvoBYXgCt
   wWj9cfvggX6F0mstcJ+D4GeIxUjfOf4cTqItfTnr0c2YrBaB1NuueminC
   GLR74SDT/bY5fDTgW4b1zJBCpO/UWGICB4LB/23Cbg1QhGnEosUIXQPoS
   PS6xiFyMwyzBQOrXwkPZgONE05GsbpqotSGcz0ssgv2/6st0N92LU/mqX
   Q==;
IronPort-SDR: isxWMgOGj72Ft+c+iPOEZMhV7jqRZJnleR+AkhAFYIvgHxuPfrvKZB02O+Up2Lzt6iM3AcsIFs
 LlCp16jaTSQx2VkSRsKOtPYnSA3fjZ2PR0GwgL+YgEQZkpQxNJQnVHdjG4wZg/CECcnQGMymD5
 NELLEbw178flxDuwMSIgTNdnA5QZ7r3VfHZkQwHUrFrOhTbkcO3CJWVza4ftgTNZvIqxa/aLy+
 WQnAs0QLI6SIsB1d+1GMeqU6Umyft8W6nmdYCzysGUEKaRH6MVt+oOe+qtEChJXcIvtxHZYxMd
 OKA=
X-IronPort-AV: E=Sophos;i="5.81,211,1610380800"; 
   d="scan'208";a="265236109"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 28 Feb 2021 14:09:57 +0800
IronPort-SDR: dk0V30zFNCZIsK9q3X0OLldThY6E+pzYLKwhDXqKxSqMY+DtQWIbW4+rdKnLKD7LXKzqzi+M3I
 tJTcfC/vdEjLsWHS3s2Pzb0v5mgXPZuPu+r2g5JEalAdi0dG60ckYBY/ta+ygNkbEp0qzSbEGP
 5/Rq5eXecpTzFvxNPuL67nhxd+u8DvLblMaVlXv2AHjFn0ymWPxcroDPTPIr4D7MnBESqP1MQq
 OoG2HIwZC2Em8G1Vikoyn+UNxxvuu8rGnqqsGqqRyA5UoCbqkaRVd8yWuFbcUhD+qtepWH3tA/
 EvXI0qiCyVAoi0DJGTMnUXAl
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2021 21:40:05 -0800
IronPort-SDR: mPJJyq0aBsbsbuh1AqP7rtu1M/g+jB0syfjksUEaZ9/6wOR+FcZFn4rnYgCZA8bFIp43NOiuYQ
 YJ82RTp67xt5cZQCH9My5pZB+yVc7jID/uzII1wtbdLZKD+zDUGdGETkgIF110VOBAdlESGaPQ
 5DnyFLy84m0kkxWvFrlgm7V1YTT03i8m/QdaOgoL4ljd2LviM0/2C/a0FlQhBOTyvkiEKk0mTC
 AvgCZAL4PA6ZHR9Iwne37nADzLg2S8/99YiyAh7wHcfRcFL+uJx0jyJaMlOqbqjbi3U9j0PXYf
 /kA=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
  by uls-op-cesaip01.wdc.com with ESMTP; 27 Feb 2021 21:58:46 -0800
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     martin.petersen@oracle.com, hare@suse.de, jejb@linux.ibm.com,
        mlombard@redhat.com, michael.christie@oracle.com,
        bvanassche@acm.org, houpu@bytedance.com,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH 12/23] target/iscsi: remove the memset with declare-init
Date:   Sat, 27 Feb 2021 21:56:34 -0800
Message-Id: <20210228055645.22253-13-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.22.1.dirty
In-Reply-To: <20210228055645.22253-1-chaitanya.kulkarni@wdc.com>
References: <20210228055645.22253-1-chaitanya.kulkarni@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Instead of initializing the array with memset, use declare init pattern
that is present under the kernel tree in other drivers so we can remove
the memset call.

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


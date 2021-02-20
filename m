Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81C07C433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Feb 2021 21:40:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C8BE64ED5
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Feb 2021 21:40:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbhBTVke (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 20 Feb 2021 16:40:34 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:27352 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbhBTVkb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 20 Feb 2021 16:40:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1613857230; x=1645393230;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=dqM2HQr2l4cxWrynRndAoqxwrtYoG17Hxl0h/8YR+eU=;
  b=BKUQqxlcOJcvW7ciPANWJAF/MgxENZADxFg63yNL0INQ10BtJfN0xcit
   C/6EbsDRRU9OayAp8wshrTV3wCHyWaFMwTyoBWbvDPXRqq/xoc8PATMtl
   BQk9WWTwcgiHFvkyt+XDH8c1t97Cd+Nl3J6Oa0oSoKzQk8VAocWkDcLje
   mWOsNYRDhXaXpXzL+fYnW9C7p6mc+xNFpN8sSntJtW4rlJ0qDiHJIb6kM
   +VqdM5o8t8lxNiqd0rcctYO6gCrRUr8OIFnon2EUsl3AWv63K4HfC0Yg5
   z8ZZmsfVtlzJi73lqg2OU13E+kcm5dCRlZZA2biJW3s0baML6BBs5TlnM
   w==;
IronPort-SDR: lQCOvhhgKK/2ZWgkYDHZW+z7LSJgHq50KqzZjpydQ6ZqCMLj/KQt289WXhWJiK1he9ZQYxESa0
 tAUfGpO6KwlD2AVXGIBl1edTBi1qenhyLfmHMZbAIzQ6hfOK6CNmQS0wHiZrnaNyoBh+lxFWmr
 d9wDXc8EXIsdnsupF/LD7va3YntW7F88i69K63QsF3+4vWoYekP4YfWQ9qYqE5kFaDYZYAhWxe
 YNZGsdxW3WaGlbvVE9Cdx4VHL/c556/bwP1RQXYJcdSs46vfd1uLBuX54iecXhNFUL9YCTu+6K
 8fc=
X-IronPort-AV: E=Sophos;i="5.81,193,1610380800"; 
   d="scan'208";a="164901605"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 21 Feb 2021 05:39:25 +0800
IronPort-SDR: Br8CvKxU5swh3uW6r2FtXuKXUCNXxzsoHa5y8sVImCRo1cDtp7ECI5eeFCKtWWdJDdTo97Ybry
 BuqOA+BLMcqJGmeKAFasi4j7KN+MNXUwjd05tRBCAlK0DXLRFEyn305liCh1j1C2cooAuBYbS8
 AFpWRWCqJb/tPwg16DhD64TLcAgD8JVi0UaS+n0sEyl7v/qNMf9HqO8oIcZnVqTfMYlEfRb0RP
 fPz3g8ojOgY1IW5Vy+pWAUwLEHDkd0+BCJeSJcbZNrTuE12a1c9nTk2yaLAL3bkzE3KoG1zGRM
 wNNeY1NIJukvwhn9ITpBBOlY
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2021 13:20:59 -0800
IronPort-SDR: V2wKsOcVXO//1IBjFlqIQ3xtlSEb1f2RbqB5tVmCNn+u+fHWsot5isA/Gi+jJU13EJ/Acnc/WO
 cXAYseNIBJdmWIpPjbFNw9QKGso4HQ6xdKUvB2ZhpeQRO2RVa1lHXsKcz2N5XxZajy4SwCmA5m
 3qATWfvImVu2piB49iIrsrKEpC5qizmSg0Lw/1IoBr9eriqxJWmHv2K5asyLhpEAtnCdMytE9D
 EE6qitiRq5rQNOTaJr9Doy5FsWzIWNj4D8DLXpCU2yc3NKxMgwtdnLTyg77/iawzcc5aGNglCz
 yAA=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
  by uls-op-cesaip02.wdc.com with ESMTP; 20 Feb 2021 13:39:26 -0800
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     martin.petersen@oracle.com, hare@suse.de, jejb@linux.ibm.com,
        mlombard@redhat.com, michael.christie@oracle.com,
        houpu@bytedance.com,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [RFC PATCH 14/24] target/configfs: remove the memset with declare-init
Date:   Sat, 20 Feb 2021 13:39:24 -0800
Message-Id: <20210220213924.6982-1-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.22.1.dirty
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 drivers/target/target_core_configfs.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 56ea47f5cda9..4c60334a1e9f 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -1555,11 +1555,9 @@ static ssize_t target_wwn_vpd_protocol_identifier_show(struct config_item *item,
 {
 	struct t10_wwn *t10_wwn = to_t10_wwn(item);
 	struct t10_vpd *vpd;
-	unsigned char buf[VPD_TMP_BUF_SIZE];
+	unsigned char buf[VPD_TMP_BUF_SIZE] = { };
 	ssize_t len = 0;
 
-	memset(buf, 0, VPD_TMP_BUF_SIZE);
-
 	spin_lock(&t10_wwn->t10_vpd_lock);
 	list_for_each_entry(vpd, &t10_wwn->t10_vpd_list, vpd_list) {
 		if (!vpd->protocol_identifier_set)
-- 
2.22.1


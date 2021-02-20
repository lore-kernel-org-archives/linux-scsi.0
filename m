Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16286C433E6
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Feb 2021 21:40:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E25A064E92
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Feb 2021 21:40:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbhBTVk3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 20 Feb 2021 16:40:29 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:24626 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbhBTVk1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 20 Feb 2021 16:40:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1613857227; x=1645393227;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=H3opKqGZj2Y8gtgBowEc22imX9Y3dUijt/HPzs/xKP8=;
  b=o98e+HvfCUVDVsTfl3bMVG9PkS/y//g51lk2H4omzDdQ6ga3SjLYQfbK
   So4p84ib3JmSj2VOup7/C/u7fvs7nPikQyLFVU1/ZDCa4AaWu4agaP8H2
   whZrC6eEzjw3+h791Gfm501WjM+6zGV+6paIIG53qhejyYnb9Mwb+jCZo
   VLT1JJTc0htMRqHlN0IkZ3efG8Zg3fKlAq581VtGR1IwdTTFKdkdB/rtw
   TDAb+EZjzeV0AXgQa5Ek9ttd01St4f3FJ7PI0PotXdj/OJT42Q/2VrUIw
   OUCwkm9ElC7VUHaxr0Z9PevEsZgOeNVvr4PmXjw21dEYqpXbh9rF/Zyd2
   A==;
IronPort-SDR: F1Ky4sF0USnKJVBAv9+HrRoqV+3e/HwtUhK+B386XVrgc69J7gnKBZkjCLrwvXoGhvY0sRdO2W
 OUcWnoSodI+aehqLiBkl9gK+awiiOc5tUYSkzAl8veMhZ3hMimYIzTibvH87eOVZGBx/5XRkCr
 OpPotsVfjqutmjJCmT+dGC6pPO/0QZyjuSzne/jPScEbWxfrC/d7Kn7g97VgYi1Po3tkPhwcyU
 hRzjcBiGyFIlQA0MyhPP7NWf1bAC8NDTQmdSk2f0lEn/kQWiUKs/0XEjYhZsMt3O2eJlVsikNV
 yPA=
X-IronPort-AV: E=Sophos;i="5.81,193,1610380800"; 
   d="scan'208";a="270954978"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 21 Feb 2021 05:39:47 +0800
IronPort-SDR: dzecAQDbbxB1u9vrWbkRSo1QUUkOnGUlcr+R29DhgVEFAnBlJGk46j6njFni7bbn3oWRoUSTAS
 w+DtukmEWa6jA4V20OOODs18SgVQqbT5sjz8/9+SAJwR9I2TzP2kxjp6e4tAZxbXdCXXb8YgLF
 zd8BWEAtp6BFR9i/OBwxErrFkbNqIbh4M1pyoKbWx1l+eY/KsOTAaJ+lZw0zCu1Qo4AdSBy55h
 w5hFRi0zirE8DCAXNVSN14DuNOUlRFhIyLmHongX9pxTnjScmS2SWNc6xTIua5R93LYszMMoNG
 yw0csABVBGW4vg2LazOdLtBb
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2021 13:23:10 -0800
IronPort-SDR: RuioXGs6dp+B+/pvSUB0+g1Nye4NJHJpDc2PuHINnVLWYO+J789+0fpe2HPv31y7P28/+pzfzt
 KTU3yuI6/fsWYRSxybhEoXrrj1enLipTJetQi3CQrj+16MqpikkZ9JpN71QtlMAmO6bErJTGc2
 O+wAihPpFURPTchNMQZfCuqO/46nmD9VeZ9YsR0hsP5jDWBaLFNZO+MiRXszIJv/rdDuo1zLdu
 SRaVEkLsGDlKF36KId1ZSliESrA54H6y67tX5ifeBB7pEhlDzGkauGws4kvseJOJULjCArY2i7
 5AU=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
  by uls-op-cesaip02.wdc.com with ESMTP; 20 Feb 2021 13:39:47 -0800
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     martin.petersen@oracle.com, hare@suse.de, jejb@linux.ibm.com,
        mlombard@redhat.com, michael.christie@oracle.com,
        houpu@bytedance.com,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [RFC PATCH 16/24] target/configfs: remove the memset with declare-init
Date:   Sat, 20 Feb 2021 13:39:46 -0800
Message-Id: <20210220213946.7070-1-chaitanya.kulkarni@wdc.com>
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
index 315791b5554a..ca5b083d2958 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -1660,9 +1660,7 @@ static ssize_t target_core_dev_pr_show_spc3_res(struct se_device *dev,
 {
 	struct se_node_acl *se_nacl;
 	struct t10_pr_registration *pr_reg;
-	char i_buf[PR_REG_ISID_ID_LEN];
-
-	memset(i_buf, 0, PR_REG_ISID_ID_LEN);
+	char i_buf[PR_REG_ISID_ID_LEN] = { };
 
 	pr_reg = dev->dev_pr_res_holder;
 	if (!pr_reg)
-- 
2.22.1


Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E0F9C433E6
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Feb 2021 21:42:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 289FA64ED5
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Feb 2021 21:42:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbhBTVlu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 20 Feb 2021 16:41:50 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:61325 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230024AbhBTVlr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 20 Feb 2021 16:41:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1613857306; x=1645393306;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=2x0mJTAFudYLvb9g2HDJPH8JbRdupRGSp/jjFKHtNc4=;
  b=kdywml/7siRGW8ud48JlHtCNGUkaHoHvx0ODTxEdZYcPpeGq4yk8rZdh
   Rkt4JTTRMSk/uLGGXW3viQdwM/0q7ukCROAQLgsNeXEP1lUSHBftDqV8T
   linCJwlEovuOCvpKCbWT/EdVVpSJ+CKpuNgcE6hyua6h75UGpXZynVHwt
   74WYQjgnW8SI6n8Mlaluj1jTWngtJPNlc5lngq8ZGS+YCqGGAEBOnE90r
   LZiU3pTfjHVDDmzkKg2EgGbGqolcjCoVuNGBy+Ox1Ezy9q9OJ4RCh732X
   9jS32nV6ecRYbzPGtP2CoEu0DjtE2pPYlu3RPvY6WkldSjuXT2IhnmN3p
   w==;
IronPort-SDR: 8xnmLJQpNrhBhItyE6zflUPdvTQIGTQ8YcSXnUHbi51awkx2/yr+snosoIFaMBIWXe1MR9h0as
 dqNb6N++x4VrES1eocL/5Bg6vBDie6OJeq9sczjTOn15lGsV7MLIEnzHVQgaSenTT5MP8XLWy+
 HLc0fVMZo4B5dVuBNxcqsEkjD+ZpJA0XhtTPZcYbil8ueHEnvZFhn6K5xbHuJ5KbSRaavkg01E
 n6uBRs4zfxFiMnV7VkGpWHTepyzxmftb5XcdTUyCN6ELZbyD7axmq+sJfuIPTdzPnygx/r0uQX
 MH0=
X-IronPort-AV: E=Sophos;i="5.81,193,1610380800"; 
   d="scan'208";a="270955008"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 21 Feb 2021 05:40:41 +0800
IronPort-SDR: PDzbXjjufeD/vlytU8Mg4oPzz0q38wX0KEj9QFEPMLoS2/m2wa+vcN/5HoYPfYh8L+/VElr1Q3
 yryk4Z1lNbik9JcL97l6z2aTFQ1Y2e9DwH5Fenrx603XXwPw6Z4Bvi5XrEuqgjkH19P1szISEs
 2Cz7yG+zVsokMXtNJrMuaGHHdzG2FQcpYSwk/33AZcU2yQMvseV4r+vi8E1rP+tEKQmKgC+IvD
 ObGb5KYm3RWIcymSXnsxBAxaFbRmitW31hZ5etFIhjuVLGWqyYANtKShKiRhLDOulRb6aJQ+ww
 DoNj0HUvumB2bf5ScC/L2kvv
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2021 13:24:04 -0800
IronPort-SDR: LW4eJkghoij1CcAnYKcCWJi4mLVgxp5cyTQuPWgmIGHFEgf0qqYsTPeUSP5rR+JOjKjCwIZ3CW
 Eh0a5dM9PvVJWdFePCxh2N5KGeL/GuaXjKc7YSXCFemArXfS33fJ4qsOWvIPKKBeyuXKZS60Va
 SJQtf8XBAH6FNdStCkOv5ryisEQ/umQNWZH/FxyfpZ7zHmUQd8sZFphU+g4mloNRkv19FWHU98
 FTWaLKcKwb/4EG51d2PBgzuvdmsb76Pb+1Ibs+qH2uwLsoOR7hfQlTZ4TM+ejaMLJQVvoqCHHj
 EmI=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
  by uls-op-cesaip02.wdc.com with ESMTP; 20 Feb 2021 13:40:42 -0800
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     martin.petersen@oracle.com, hare@suse.de, jejb@linux.ibm.com,
        mlombard@redhat.com, michael.christie@oracle.com,
        houpu@bytedance.com,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [RFC PATCH 21/24] target/pr: remove the memset with declare-init
Date:   Sat, 20 Feb 2021 13:40:40 -0800
Message-Id: <20210220214040.7337-1-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.22.1.dirty
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 drivers/target/target_core_pr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 942b93d12295..3644d2642929 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -1202,10 +1202,10 @@ static struct t10_pr_registration *core_scsi3_locate_pr_reg(
 	struct se_session *sess)
 {
 	struct se_portal_group *tpg = nacl->se_tpg;
-	unsigned char buf[PR_REG_ISID_LEN], *isid_ptr = NULL;
+	unsigned char buf[PR_REG_ISID_LEN] = { };
+	unsigned char *isid_ptr = NULL;
 
 	if (tpg->se_tpg_tfo->sess_get_initiator_sid != NULL) {
-		memset(&buf[0], 0, PR_REG_ISID_LEN);
 		tpg->se_tpg_tfo->sess_get_initiator_sid(sess, &buf[0],
 					PR_REG_ISID_LEN);
 		isid_ptr = &buf[0];
-- 
2.22.1


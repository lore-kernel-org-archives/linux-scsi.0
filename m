Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0392C43331
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Feb 2021 21:41:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8AC4764E92
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Feb 2021 21:41:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbhBTVli (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 20 Feb 2021 16:41:38 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:16763 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230017AbhBTVlg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 20 Feb 2021 16:41:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1613857295; x=1645393295;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=rivaMoXvEXjyk/pEn822tjwPBz6E11qXaMBR8eM9koo=;
  b=igu4W7WoMtDL/bMZ1AwDnEGgk6V5KmXcyww+ziqHkmXsaGTZsqIb1qWN
   v5u7BiKNeXN2cg2je7wTMk53FNUSMnIC2z9tbbr6CX3mYhzuwc1xhQ+4t
   xYlosIQS0kbHhKtAhU6GBbx0bLgm7eOIROz0qA0C3N6U70kE8fSDfcVgd
   aXikehbRWMx+FpOtNPrn0vKaV0IBb3P5Sbmo6eYZKORMHg6L8Ga/eJjGg
   Jd7S+f6RnlfNdhh0sIS2u2H531K9DafN0BX17mAtoaPDbqejiEOWD6nRP
   r4guxBHBrTTLh/d1o1dUwtwKB2ylSl0H5DrXI+pcKHSDFVc+qH5rX6Gr6
   g==;
IronPort-SDR: jLcQPRKMGAhhZjyc8pDnoLhuULm+M5oBrc7+tHExqUd1GJTF+JBdifHifRgdlrZAeT9v3RXwyJ
 1aE31pZ1gv81sVRb7RWIU+wgv2MyURY8Ikfme0wmIedLC0avIBI4+D/b+SkaBuACPH/ci7N5dl
 PpBLs8DrQ2U1m8mlrBlF8Z7oACOrEaVHAsOEXIu1KpdInrSlPiJt/PKjDvbZpBe+70fWDk2VNY
 r+NY/w+RGowlhc11MAuBy/5XOcUtJ4vtKrh8wkq9pyD0rB0fofYyAUtEUsg1qqgiYDssfkOBF5
 PvI=
X-IronPort-AV: E=Sophos;i="5.81,193,1610380800"; 
   d="scan'208";a="160432975"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 21 Feb 2021 05:40:30 +0800
IronPort-SDR: jKuPQaUqY2xloNufQQEWq1RFTW1TbzJpQCBS6pgmT0/f2S7eLO34afqrtdbEvEBWB+4KIGrOHT
 dofFeKTjsQTbZM+C9BxHFRKl2qgvVo/dYe/l4MnlPqF6T9Wxr4DdofNdzYW7Ku6RGtv8VeY7Q/
 so7bEQirUhhQWuBjISKb04Ez09hKDbsn5tMekVp/8rKPCXOXi1N1lJI14gi7ruyYfZYZk4VVGJ
 sDAxZF4eHAo7C2D+6HwE+Fxa0hLYEOK4Um5+qwWIMHl++1IiJtmzjfoDYPmy8A01Zd5RXgYzJt
 tHEdhxraq+rhsgcybS4GO+41
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2021 13:23:53 -0800
IronPort-SDR: L/89aeBMb96HQsm74I/8f1ByKOCiGpXFUAPKsxXccFriLmJ+jRXbsnb756xPPWCNMd1BPZ5ct/
 wDYww1OnENChouJQuwHM3Ic9oF8T9BgkVeyWKqLIFNKKOH7LOvbFFeV/1AMSlmkg2t2IlXIJQX
 2VR92xak12VLdaBWqKm+SgKY6LHxoulbi2KjXrjPA9yk4GScGBh0Ia2Y/McENfClBznCjJZQRq
 fQKnxkVS2KvvuvWqr68K+YxIDCXhxmZKlLEhS1pMQ2XmRqXv1LaM6BPEIpDrav7P5aDVZp6Ney
 GrM=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
  by uls-op-cesaip02.wdc.com with ESMTP; 20 Feb 2021 13:40:31 -0800
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     martin.petersen@oracle.com, hare@suse.de, jejb@linux.ibm.com,
        mlombard@redhat.com, michael.christie@oracle.com,
        houpu@bytedance.com,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [RFC PATCH 20/24] target/pr: remove the memset with declare-init
Date:   Sat, 20 Feb 2021 13:40:29 -0800
Message-Id: <20210220214029.7293-1-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.22.1.dirty
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 drivers/target/target_core_pr.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 14db5e568f22..942b93d12295 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -928,12 +928,10 @@ static int __core_scsi3_check_aptpl_registration(
 {
 	struct t10_pr_registration *pr_reg, *pr_reg_tmp;
 	struct t10_reservation *pr_tmpl = &dev->t10_pr;
-	unsigned char i_port[PR_APTPL_MAX_IPORT_LEN];
-	unsigned char t_port[PR_APTPL_MAX_TPORT_LEN];
+	unsigned char i_port[PR_APTPL_MAX_IPORT_LEN] = { };
+	unsigned char t_port[PR_APTPL_MAX_TPORT_LEN] = { };
 	u16 tpgt;
 
-	memset(i_port, 0, PR_APTPL_MAX_IPORT_LEN);
-	memset(t_port, 0, PR_APTPL_MAX_TPORT_LEN);
 	/*
 	 * Copy Initiator Port information from struct se_node_acl
 	 */
-- 
2.22.1


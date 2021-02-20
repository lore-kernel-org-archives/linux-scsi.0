Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC66FC433E6
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Feb 2021 21:41:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A512264E2F
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Feb 2021 21:41:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbhBTVlG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 20 Feb 2021 16:41:06 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:16730 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229983AbhBTVlE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 20 Feb 2021 16:41:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1613857263; x=1645393263;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=HBxVB6qCGQ11GplGDmSfQDtFEQ7HBcmHy4k41+SDWxg=;
  b=Yu2cOkDjbre7d36mdbf3uOmge+bVW8AL7A/I/ElJGidDFQtnTNppnGxx
   a8iNsEVUm6M3faN1/RZP1HsIRCXgYrMnRosO1tQkEcsPI/UDdObhfF82s
   hP3gCWdHSqfWeheXLFPccPGz/FGiv2JHEIGRLUmv9dXd0pTIQk53scCGx
   X0hgc/Aa034uOuIrAeHY93okvw/x64TMPNBMO+9VgLkN41pUg9uDcAJ8P
   1lzLex5DCrbBnM/Dl2jv2TujQewdQKsDdzDa3nmb4hCEslWNYh3EWbjx9
   ivGbLLwHcir2kAIsRLV9YsAk+DOnx/wS4MTEAEVRsz9iI+uz6iYnniuSK
   Q==;
IronPort-SDR: PCtgZK+NMBlrH/mSXB7H2WTfp8trRz0sIflgkWXiLtPfMbh9TeCDEfZxvNrPK6b6vD79Hzelp7
 nz7t91PVMRfOVfNOktb04xCzlZtNDlHC7TmWYGmIlsFwzM+p06pII4TZ0kLvMYtf08ubgK5CsD
 0hySj8lgifio1bGRu4FT0tP3+d5NtjcP1rTJfElolrQYRASUL/+jGHdah+KxQ+HY13EvsqDbvM
 Z6UslzX6J/26nOLBrYs0+kXx6eZDnuEGU0QIZg96/CNkwlpxedANismFR98YPBlGsVMigJRTTy
 X/4=
X-IronPort-AV: E=Sophos;i="5.81,193,1610380800"; 
   d="scan'208";a="160432961"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 21 Feb 2021 05:39:58 +0800
IronPort-SDR: u1CN8RMe28PzjjPKXMHjnYBd2G6LlTTxNZbhIc43cVqxw7keLn0xt2xl3SnAuSzVsCJP5b5otV
 tnpeVzDc/R0MEHnfL9y4EbUX+N/Hd7nLnn18qutKL2l3IMO1sR0GrpWIAEhSTNmhMCAa+rZh+c
 oh/N88LGwcmkfY8aUQORG4OvWmSJUp4DS/4FNxV/+kwBHM9hHXLaV8p5+Om7v5ejv7NRyCEEsy
 HKOEnLpr2Vq+GlS4Q2z0Z7doAIMEUTog78jnGrUFa8llNB+cZugCr/6wvpIR5+RUOJmXyXw8IE
 TEVtiBIv//fSUoJqPqafeMmb
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2021 13:21:32 -0800
IronPort-SDR: OmzJfykDTQHGPrumUjLTPUSFIwqw3v75yRTVc1pwNF599H+Fe2yoiThvChDz/rMY/TuNli9psn
 n3S53Ja5PEZP9PI/Gvnf7wI7E6VXKB/U26hdRCGkpvXaowGku+uLf7r8FX3hLGYFgSwLbijRNp
 q9XH0Ju2bpAmdI2Muuo+1UGjeZ/ZAM5Ih5NQVxprenzOzVy5sTiGcJGzxt4ywz829ZxapHc7NS
 QV3S/Q2C6xACvo0dw5/r3izg3ngOZ5NqE8oQjVpbzNP6cB+AeDSni5GfUgWKSBPOdReU0gGnXq
 iIg=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
  by uls-op-cesaip02.wdc.com with ESMTP; 20 Feb 2021 13:39:58 -0800
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     martin.petersen@oracle.com, hare@suse.de, jejb@linux.ibm.com,
        mlombard@redhat.com, michael.christie@oracle.com,
        houpu@bytedance.com,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [RFC PATCH 17/24] target/configfs: remove the memset with declare-init
Date:   Sat, 20 Feb 2021 13:39:57 -0800
Message-Id: <20210220213957.7114-1-chaitanya.kulkarni@wdc.com>
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
index ca5b083d2958..0ec9fe1ebade 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -2609,9 +2609,7 @@ static ssize_t target_lu_gp_members_show(struct config_item *item, char *page)
 	struct se_hba *hba;
 	struct t10_alua_lu_gp_member *lu_gp_mem;
 	ssize_t len = 0, cur_len;
-	unsigned char buf[LU_GROUP_NAME_BUF];
-
-	memset(buf, 0, LU_GROUP_NAME_BUF);
+	unsigned char buf[LU_GROUP_NAME_BUF] = { };
 
 	spin_lock(&lu_gp->lu_gp_lock);
 	list_for_each_entry(lu_gp_mem, &lu_gp->lu_gp_mem_list, lu_gp_mem_list) {
-- 
2.22.1


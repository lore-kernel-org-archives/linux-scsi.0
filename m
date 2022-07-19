Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C4FDC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jul 2022 07:15:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233707AbiGSHPp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Jul 2022 03:15:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbiGSHPo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jul 2022 03:15:44 -0400
Received: from mail-m963.mail.126.com (mail-m963.mail.126.com [123.126.96.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 13CB11EC76
        for <linux-scsi@vger.kernel.org>; Tue, 19 Jul 2022 00:15:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=IPRF8
        X0ztDGObHLVCkGePyjLMr/L2a0cDtBeYFcrkBY=; b=fARr1+tWln0kwuZ0WGyzC
        ZwVYKS9IHji6hDH/IYWqg8iWTuuio5YgqUoOnSGaHxG+SDYBbkEBj/MRrGDguzZ6
        hL9oLOgta4FDIN7/6m1L4tTuDNNCK/3FisNCkGQjrPXs4P/xb/daq1v9+UYg8mZD
        +NSGUuHr27ne/0a1ClLRDs=
Received: from localhost.localdomain (unknown [124.16.139.61])
        by smtp8 (Coremail) with SMTP id NORpCgDXdYISWtZitwSDIA--.1514S2;
        Tue, 19 Jul 2022 15:15:31 +0800 (CST)
From:   Liang He <windhl@126.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com, beanhuo@micron.com,
        bvanassche@acm.org, avri.altman@wdc.com,
        linux-scsi@vger.kernel.org, windhl@126.com
Subject: [PATCH v3] ufs: host: ufshcd-pltfrm: Hold reference returned by  of_parse_phandle()
Date:   Tue, 19 Jul 2022 15:15:29 +0800
Message-Id: <20220719071529.1081166-1-windhl@126.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: NORpCgDXdYISWtZitwSDIA--.1514S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Zry5XrWxKw1DWr4rtFW8WFg_yoW8AF13pF
        WFk398Ar4xKFyagFWjy3WUG3s3Kr48GrWUCrZFk34Svrs2qayfX3WkKFyYk3Z5JFyfZ3W8
        tF4FyFn5Ga12yFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UxgA7UUUUU=
X-Originating-IP: [124.16.139.61]
X-CM-SenderInfo: hzlqvxbo6rjloofrz/1tbiuBpDF2JVkbf5tAABsr
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In ufshcd_populate_vreg(), we should hold the reference returned by
of_parse_phandle() and then use it to call of_node_put() for refcount
balance.

Fixes: aa4976130934 ("ufs: Add regulator enable support")
Signed-off-by: Liang He <windhl@126.com>
---
 changelog:

 v3: fix indentation problem and use 'ret parse_np != NULL'
 v2: change helper name
 v1: fix holding bug

 Here we also change the indentation of original 'ufshcd_populate_vreg()'

 drivers/ufs/host/ufshcd-pltfrm.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/host/ufshcd-pltfrm.c b/drivers/ufs/host/ufshcd-pltfrm.c
index e7332cc65b1f..173aea8e9997 100644
--- a/drivers/ufs/host/ufshcd-pltfrm.c
+++ b/drivers/ufs/host/ufshcd-pltfrm.c
@@ -108,9 +108,20 @@ static int ufshcd_parse_clock_info(struct ufs_hba *hba)
 	return ret;
 }
 
+static bool phandle_exists(const struct device_node *np,
+			   const char *phandle_name, int index)
+{
+	struct device_node *parse_np = of_parse_phandle(np, phandle_name, index);
+
+	if (parse_np)
+		of_node_put(parse_np);
+
+	return parse_np != NULL;
+}
+
 #define MAX_PROP_SIZE 32
 static int ufshcd_populate_vreg(struct device *dev, const char *name,
-		struct ufs_vreg **out_vreg)
+				struct ufs_vreg **out_vreg)
 {
 	char prop_name[MAX_PROP_SIZE];
 	struct ufs_vreg *vreg = NULL;
@@ -122,7 +133,7 @@ static int ufshcd_populate_vreg(struct device *dev, const char *name,
 	}
 
 	snprintf(prop_name, MAX_PROP_SIZE, "%s-supply", name);
-	if (!of_parse_phandle(np, prop_name, 0)) {
+	if (!phandle_exists(np, prop_name, 0)) {
 		dev_info(dev, "%s: Unable to find %s regulator, assuming enabled\n",
 				__func__, prop_name);
 		goto out;
-- 
2.25.1


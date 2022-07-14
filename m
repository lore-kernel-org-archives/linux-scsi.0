Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 585C0C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Jul 2022 06:25:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231337AbiGNGZe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Jul 2022 02:25:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbiGNGZc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jul 2022 02:25:32 -0400
X-Greylist: delayed 1854 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 13 Jul 2022 23:25:30 PDT
Received: from m15112.mail.126.com (m15112.mail.126.com [220.181.15.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BBCAACE03
        for <linux-scsi@vger.kernel.org>; Wed, 13 Jul 2022 23:25:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=7xeg2
        It69vev28YpRbCSc9ZzsINbiExknAK2m0FfCT8=; b=Pg/PPw2HzVYpDgR2vaSRI
        xfIw0Ns1zYgfIsewHrD0WeKlfwkSGx94QQZWrGlsBbPdiYqDwAmbXhcUqObHqz/O
        kjNkohC4TtPB7o2KLJ5iZIbfbP+cU/49EcKFX2hxSsww4wyK3trIWQGhLmxDzDSJ
        C0v33efnrMybPNljumCMtk=
Received: from localhost.localdomain (unknown [124.16.139.61])
        by smtp2 (Coremail) with SMTP id DMmowAAnMwaHr89ipt1OEw--.289S2;
        Thu, 14 Jul 2022 13:54:16 +0800 (CST)
From:   Liang He <windhl@126.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com, windhl@126.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH] ufs: host: ufschd-pltfrm: Hold reference returned by of_parse_phandle()
Date:   Thu, 14 Jul 2022 13:54:13 +0800
Message-Id: <20220714055413.373449-1-windhl@126.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DMmowAAnMwaHr89ipt1OEw--.289S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Zry5XrWxKw1DAryUKr17KFg_yoW8WFWrpF
        WY93yYyr4xKF4I9FWxA3WUG3sakw4xGrWUCa92ka4Syrs7Xa47X3WkKFy5C3WrGryfX3W8
        tFsYyF18Wan7tFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0z__MakUUUUU=
X-Originating-IP: [124.16.139.61]
X-CM-SenderInfo: hzlqvxbo6rjloofrz/1tbiuAg+F2JVkW3rygAAsz
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In ufshcd_populate_vreg(), we should hold the reference returned by
of_parse_phandle() and then use it to call of_node_put() for refcount
balance.

Fixes: aa4976130934 ("ufs: Add regulator enable support")
Signed-off-by: Liang He <windhl@126.com>
---

 We add a helper to check the return value of_parse_phandle() as we
do not need the reference, otherwise we need to declare a device_node 
in ufshcd_populate_vreg().

 drivers/ufs/host/ufshcd-pltfrm.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/host/ufshcd-pltfrm.c b/drivers/ufs/host/ufshcd-pltfrm.c
index e7332cc65b1f..2cb409d9ed3d 100644
--- a/drivers/ufs/host/ufshcd-pltfrm.c
+++ b/drivers/ufs/host/ufshcd-pltfrm.c
@@ -108,6 +108,21 @@ static int ufshcd_parse_clock_info(struct ufs_hba *hba)
 	return ret;
 }
 
+static bool is_of_parse_phandle(const struct device_node *np,
+						const char *phandle_name,
+						int index)
+{
+	struct device_node *parse_np = of_parse_phandle(np, phandle_name, index);
+	bool ret = false;
+
+	if (parse_np) {
+		ret = true;
+		of_node_put(parse_np);
+	}
+
+	return ret;
+}
+
 #define MAX_PROP_SIZE 32
 static int ufshcd_populate_vreg(struct device *dev, const char *name,
 		struct ufs_vreg **out_vreg)
@@ -122,7 +137,7 @@ static int ufshcd_populate_vreg(struct device *dev, const char *name,
 	}
 
 	snprintf(prop_name, MAX_PROP_SIZE, "%s-supply", name);
-	if (!of_parse_phandle(np, prop_name, 0)) {
+	if (!is_of_parse_phandle(np, prop_name, 0)) {
 		dev_info(dev, "%s: Unable to find %s regulator, assuming enabled\n",
 				__func__, prop_name);
 		goto out;
-- 
2.25.1


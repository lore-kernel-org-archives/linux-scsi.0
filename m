Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FCFDC46467
	for <linux-scsi@archiver.kernel.org>; Sun, 15 Jan 2023 11:05:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbjAOLFy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 15 Jan 2023 06:05:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbjAOLFw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 15 Jan 2023 06:05:52 -0500
Received: from mail.nfschina.com (unknown [42.101.60.237])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8A67C166
        for <linux-scsi@vger.kernel.org>; Sun, 15 Jan 2023 03:05:51 -0800 (PST)
Received: from localhost (unknown [127.0.0.1])
        by mail.nfschina.com (Postfix) with ESMTP id 1D3BD1A00A17;
        Sun, 15 Jan 2023 19:06:08 +0800 (CST)
X-Virus-Scanned: amavisd-new at nfschina.com
Received: from mail.nfschina.com ([127.0.0.1])
        by localhost (localhost.localdomain [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ObRwR4Gd_Wok; Sun, 15 Jan 2023 19:06:07 +0800 (CST)
Received: from localhost.localdomain (unknown [219.141.250.2])
        (Authenticated sender: junming@nfschina.com)
        by mail.nfschina.com (Postfix) with ESMTPA id 4C4AA1A0098D;
        Sun, 15 Jan 2023 19:06:07 +0800 (CST)
From:   shijm <junming@nfschina.com>
To:     Corbet@lwn.net
Cc:     linux-scsi@vger.kernel.org, shijm <junming@nfschina.com>
Subject: [PATCH] Documentation: add exception capture function
Date:   Sun, 15 Jan 2023 19:05:35 +0800
Message-Id: <20230115110535.5597-1-junming@nfschina.com>
X-Mailer: git-send-email 2.11.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add exception capture function

Signed-off-by: shijm <junming@nfschina.com>
---
 Documentation/target/tcm_mod_builder.py | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/target/tcm_mod_builder.py b/Documentation/target/tcm_mod_builder.py
index 54492aa813b9..5b28d50ed80f 100755
--- a/Documentation/target/tcm_mod_builder.py
+++ b/Documentation/target/tcm_mod_builder.py
@@ -29,8 +29,9 @@ def tcm_mod_create_module_subdir(fabric_mod_dir_var):
 		return 1
 
 	print "Creating fabric_mod_dir: " + fabric_mod_dir_var
-	ret = os.mkdir(fabric_mod_dir_var)
-	if ret:
+    try:
+	    ret = os.mkdir(fabric_mod_dir_var)
+	except:
 		tcm_mod_err("Unable to mkdir " + fabric_mod_dir_var)
 
 	return
-- 
2.18.2


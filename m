Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EAF6C43217
	for <linux-scsi@archiver.kernel.org>; Sat, 26 Nov 2022 11:14:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbiKZLOE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 26 Nov 2022 06:14:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbiKZLNf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 26 Nov 2022 06:13:35 -0500
Received: from smtp.smtpout.orange.fr (smtp-30.smtpout.orange.fr [80.12.242.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D83019008
        for <linux-scsi@vger.kernel.org>; Sat, 26 Nov 2022 03:13:32 -0800 (PST)
Received: from pop-os.home ([86.243.100.34])
        by smtp.orange.fr with ESMTPA
        id yt7gosMV5gfI9yt7hoiV8F; Sat, 26 Nov 2022 12:13:30 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sat, 26 Nov 2022 12:13:30 +0100
X-ME-IP: 86.243.100.34
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: libfc: Include the correct header
Date:   Sat, 26 Nov 2022 12:13:27 +0100
Message-Id: <960f34418358f0c35e645aa2cf7e0ec7fe6b60b9.1669461197.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This file does not use rcu, so there is no point in including
<linux/rculist.h>.

The dependency has been removed in commit fa519f701d27 ("scsi: libfc: fixup
'sleeping function called from invalid context'")
It turned a list_for_each_entry_rcu() into a list_for_each_entry().

So just #include <linux/list.h> now.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/scsi/libfc/fc_disc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
index 0f32ded246d0..384f48ff64d7 100644
--- a/drivers/scsi/libfc/fc_disc.c
+++ b/drivers/scsi/libfc/fc_disc.c
@@ -24,7 +24,7 @@
 #include <linux/slab.h>
 #include <linux/err.h>
 #include <linux/export.h>
-#include <linux/rculist.h>
+#include <linux/list.h>
 
 #include <asm/unaligned.h>
 
-- 
2.34.1


From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 19/21] tcm_fc: init/exit functions should not be protected by "#ifdef MODULE"
Date: Wed, 17 Aug 2011 23:17:23 +0000
Message-ID: <1313623045-15916-20-git-send-email-nab@linux-iscsi.org>
References: <1313623045-15916-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:58354 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754617Ab1HQXms (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Aug 2011 19:42:48 -0400
In-Reply-To: <1313623045-15916-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Roland Dreier <roland@purestorage.com>

From: Roland Dreier <roland@purestorage.com>

There's no need for the #ifdef protection when building into the kernel,
and in fact we need the module_init() for the initialization function to
be called.

Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/tcm_fc/tfc_conf.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/target/tcm_fc/tfc_conf.c b/drivers/target/tcm_fc/tfc_conf.c
index 8781d1e..520a8ba 100644
--- a/drivers/target/tcm_fc/tfc_conf.c
+++ b/drivers/target/tcm_fc/tfc_conf.c
@@ -655,9 +655,7 @@ static void __exit ft_exit(void)
 	synchronize_rcu();
 }
 
-#ifdef MODULE
 MODULE_DESCRIPTION("FC TCM fabric driver " FT_VERSION);
 MODULE_LICENSE("GPL");
 module_init(ft_init);
 module_exit(ft_exit);
-#endif /* MODULE */
-- 
1.7.6


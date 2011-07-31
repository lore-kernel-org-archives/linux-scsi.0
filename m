From: Jesper Juhl <jj@chaosbits.net>
Subject: [PATCH] Fix leak in
 drivers/target/iscsi/iscsi_target_parameters.c::iscsi_copy_param_list()
Date: Mon, 1 Aug 2011 00:28:13 +0200 (CEST)
Message-ID: <alpine.LNX.2.00.1108010017030.28695@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from swampdragon.chaosbits.net ([90.184.90.115]:10572 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997Ab1GaW2P (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 31 Jul 2011 18:28:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Andy Grover <agrover@redhat.com>, Roland Dreier <roland@kernel.org>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

We leak memory if the allocations for 'new_param->name' or 'new_param->value' fail.
We also do a lot of variable assignments that are completely pointless
if the allocations fail.
So, let's move the allocations before the assignments and also make
sure that we free whatever was allocated to one if the allocation for
another fails.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/target/iscsi/iscsi_target_parameters.c |   26 ++++++++++-------------
 1 files changed, 11 insertions(+), 15 deletions(-)

 compile tested only

diff --git a/drivers/target/iscsi/iscsi_target_parameters.c b/drivers/target/iscsi/iscsi_target_parameters.c
index 252e246..c708092 100644
--- a/drivers/target/iscsi/iscsi_target_parameters.c
+++ b/drivers/target/iscsi/iscsi_target_parameters.c
@@ -572,6 +572,17 @@ int iscsi_copy_param_list(
 			goto err_out;
 		}
 
+		new_param->name = kmalloc(strlen(param->name) + 1, GFP_KERNEL);
+		new_param->value = kmalloc(strlen(param->value) + 1, GFP_KERNEL);
+		if (!new_param->name || !new_param->value) {
+			kfree(new_param->value);
+			kfree(new_param->name);
+			kfree(new_param);
+			pr_err("Unable to allocate memory for parameter "
+				"name/value.\n");
+			goto err_out;
+		}
+
 		new_param->set_param = param->set_param;
 		new_param->phase = param->phase;
 		new_param->scope = param->scope;
@@ -580,21 +591,6 @@ int iscsi_copy_param_list(
 		new_param->use = param->use;
 		new_param->type_range = param->type_range;
 
-		new_param->name = kzalloc(strlen(param->name) + 1, GFP_KERNEL);
-		if (!new_param->name) {
-			pr_err("Unable to allocate memory for"
-				" parameter name.\n");
-			goto err_out;
-		}
-
-		new_param->value = kzalloc(strlen(param->value) + 1,
-				GFP_KERNEL);
-		if (!new_param->value) {
-			pr_err("Unable to allocate memory for"
-				" parameter value.\n");
-			goto err_out;
-		}
-
 		memcpy(new_param->name, param->name, strlen(param->name));
 		new_param->name[strlen(param->name)] = '\0';
 		memcpy(new_param->value, param->value, strlen(param->value));
-- 
1.7.6

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.


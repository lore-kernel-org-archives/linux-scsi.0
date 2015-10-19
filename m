From: Luis de Bethencourt <luisbg@osg.samsung.com>
Subject: [PATCH] iscsi-target: return -ENOMEM instead of -1 in case of failed kmalloc()
Date: Mon, 19 Oct 2015 21:18:24 +0100
Message-ID: <1445285904-31247-1-git-send-email-luisbg@osg.samsung.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:35519 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752870AbbJSUS3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Oct 2015 16:18:29 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: nab@linux-iscsi.org, cvubrugier@fastmail.fm, sagig@mellanox.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, Luis de Bethencourt <luisbg@osg.samsung.com>

Smatch complains about returning hard coded error codes, silence this
warning.

drivers/target/iscsi/iscsi_target_parameters.c:211 iscsi_create_default_params() warn: returning -1 instead of -ENOMEM is sloppy

Signed-off-by: Luis de Bethencourt <luisbg@osg.samsung.com>
---

Hi,

This doesn't change the functionality. It is just about using the more specific
errno. And at the same time silencing smatch.

Thanks,
Luis

 drivers/target/iscsi/iscsi_target_parameters.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_parameters.c b/drivers/target/iscsi/iscsi_target_parameters.c
index 51d1734..2cbea2a 100644
--- a/drivers/target/iscsi/iscsi_target_parameters.c
+++ b/drivers/target/iscsi/iscsi_target_parameters.c
@@ -208,7 +208,7 @@ int iscsi_create_default_params(struct iscsi_param_list **param_list_ptr)
 	if (!pl) {
 		pr_err("Unable to allocate memory for"
 				" struct iscsi_param_list.\n");
-		return -1 ;
+		return -ENOMEM;
 	}
 	INIT_LIST_HEAD(&pl->param_list);
 	INIT_LIST_HEAD(&pl->extra_response_list);
@@ -578,7 +578,7 @@ int iscsi_copy_param_list(
 	param_list = kzalloc(sizeof(struct iscsi_param_list), GFP_KERNEL);
 	if (!param_list) {
 		pr_err("Unable to allocate memory for struct iscsi_param_list.\n");
-		return -1;
+		return -ENOMEM;
 	}
 	INIT_LIST_HEAD(&param_list->param_list);
 	INIT_LIST_HEAD(&param_list->extra_response_list);
@@ -629,7 +629,7 @@ int iscsi_copy_param_list(
 
 err_out:
 	iscsi_release_param_list(param_list);
-	return -1;
+	return -ENOMEM;
 }
 
 static void iscsi_release_extra_responses(struct iscsi_param_list *param_list)
@@ -729,7 +729,7 @@ static int iscsi_add_notunderstood_response(
 	if (!extra_response) {
 		pr_err("Unable to allocate memory for"
 			" struct iscsi_extra_response.\n");
-		return -1;
+		return -ENOMEM;
 	}
 	INIT_LIST_HEAD(&extra_response->er_list);
 
@@ -1370,7 +1370,7 @@ int iscsi_decode_text_input(
 	tmpbuf = kzalloc(length + 1, GFP_KERNEL);
 	if (!tmpbuf) {
 		pr_err("Unable to allocate %u + 1 bytes for tmpbuf.\n", length);
-		return -1;
+		return -ENOMEM;
 	}
 
 	memcpy(tmpbuf, textbuf, length);
-- 
2.5.1


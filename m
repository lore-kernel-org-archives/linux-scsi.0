From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 07/21] iscsi-target: forever loop bug in iscsit_attach_ooo_cmdsn()
Date: Wed, 17 Aug 2011 23:17:11 +0000
Message-ID: <1313623045-15916-8-git-send-email-nab@linux-iscsi.org>
References: <1313623045-15916-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:58319 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234Ab1HQXm1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Aug 2011 19:42:27 -0400
In-Reply-To: <1313623045-15916-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Dan Carpenter <error27@gmail.com>

From: Dan Carpenter <error27@gmail.com>

This patch fixes a forever loop bug in iscsit_attach_ooo_cmdsn()
while walking sess->sess_ooo_cmdsn_list when the received
CmdSN is less than the tail of the list.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/iscsi/iscsi_target_erl1.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_erl1.c b/drivers/target/iscsi/iscsi_target_erl1.c
index 9806507..c4c68da 100644
--- a/drivers/target/iscsi/iscsi_target_erl1.c
+++ b/drivers/target/iscsi/iscsi_target_erl1.c
@@ -834,7 +834,7 @@ static int iscsit_attach_ooo_cmdsn(
 			 */
 			list_for_each_entry(ooo_tmp, &sess->sess_ooo_cmdsn_list,
 						ooo_list) {
-				while (ooo_tmp->cmdsn < ooo_cmdsn->cmdsn)
+				if (ooo_tmp->cmdsn < ooo_cmdsn->cmdsn)
 					continue;
 
 				list_add(&ooo_cmdsn->ooo_list,
-- 
1.7.6


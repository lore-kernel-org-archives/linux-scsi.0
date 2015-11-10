From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 4.1] target-core: fix return without a value
Date: Tue, 10 Nov 2015 13:32:10 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1511101329001.18857@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45032 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751535AbbKJScN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Nov 2015 13:32:13 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nicholas Bellinger <nab@linux-iscsi.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-stable@vger.kernel.org
Cc: Martin Svec <martin.svec@zoner.cz>, Alex Gorbachev <ag@iss-integration.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

Fix the warning drivers/target/target_core_pr.c:332:3: warning: 'return'
with no value, in function returning non-void [-Wreturn-type]

The patch 35afa65642a9a88c81913377b93a3a66220f8b9d committed to 4.1.11
adds a check if device_list is NULL. The patch adds a return statement
without a value to the function core_scsi3_pr_seq_non_holder that returns
int.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/target/target_core_pr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-4.1.13/drivers/target/target_core_pr.c
===================================================================
--- linux-4.1.13.orig/drivers/target/target_core_pr.c	2015-10-23 18:25:26.000000000 +0200
+++ linux-4.1.13/drivers/target/target_core_pr.c	2015-11-10 19:22:07.000000000 +0100
@@ -329,7 +329,7 @@ static int core_scsi3_pr_seq_non_holder(
 			 * RESERVATION CONFLICT on some CDBs */
 
 	if (!se_sess->se_node_acl->device_list)
-		return;
+		return -EINVAL;
 
 	se_deve = se_sess->se_node_acl->device_list[cmd->orig_fe_lun];
 	/*

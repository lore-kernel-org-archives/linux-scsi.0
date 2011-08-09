From: Dan Carpenter <error27@gmail.com>
Subject: [patch] target: use after free in error handling
Date: Tue, 9 Aug 2011 15:30:07 +0300
Message-ID: <20110809123006.GJ7659@shale.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:57906 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125Ab1HIMcP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Aug 2011 08:32:15 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Andy Grover <agrover@redhat.com>, Roland Dreier <roland@kernel.org>, Christoph Hellwig <hch@lst.de>, "open list:TARGET SUBSYSTEM" <linux-scsi@vger.kernel.org>, "open list:TARGET SUBSYSTEM" <target-devel@vger.kernel.org>, kernel-janitors@vger.kernel.org

iscsit_release_cmd() frees the memory that "se_cmd" was pointing to
so this is a use after free bug.  Also "se_cmd" is non-null here so I
removed the unneeded null check.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index a1acb01..bea5c29 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -297,9 +297,8 @@ struct iscsi_cmd *iscsit_allocate_se_cmd_for_tmr(
 
 	return cmd;
 out:
+	transport_free_se_cmd(se_cmd);
 	iscsit_release_cmd(cmd);
-	if (se_cmd)
-		transport_free_se_cmd(se_cmd);
 	return NULL;
 }
 

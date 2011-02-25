From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 01/14] target: Fix memory leak on error path in pscsi_alloc_task
Date: Fri, 25 Feb 2011 11:49:53 -0800
Message-ID: <1298663406-5118-2-git-send-email-nab@linux-iscsi.org>
References: <1298663406-5118-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm9.bullet.mail.sp2.yahoo.com ([98.139.91.79]:43891 "HELO
	nm9.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932644Ab1BYTuR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Feb 2011 14:50:17 -0500
In-Reply-To: <1298663406-5118-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Roland Dreier <rolandd@cisco.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

From: Roland Dreier <rolandd@cisco.com>

If allocation of pt->pscsi_cdb fails, we need to free the just-allocated
pt or else it will be leaked.

Signed-off-by: Roland Dreier <rolandd@cisco.com>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_pscsi.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index f2a0847..f596cb7 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -817,6 +817,7 @@ pscsi_alloc_task(struct se_cmd *cmd)
 		if (!(pt->pscsi_cdb)) {
 			printk(KERN_ERR "pSCSI: Unable to allocate extended"
 					" pt->pscsi_cdb\n");
+			kfree(pt);
 			return NULL;
 		}
 	} else
-- 
1.7.4.1


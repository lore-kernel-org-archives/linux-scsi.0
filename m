From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 04/24] target: Fix memory leak on error path
Date: Sat, 29 Jan 2011 10:36:04 -0800
Message-ID: <1296326184-16664-5-git-send-email-nab@linux-iscsi.org>
References: <1296326184-16664-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm26-vm0.bullet.mail.ac4.yahoo.com ([98.139.52.242]:32072 "HELO
	nm26-vm0.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754278Ab1A2SgV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Jan 2011 13:36:21 -0500
In-Reply-To: <1296326184-16664-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Roland Dreier <rolandd@cisco.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

From: Roland Dreier <rolandd@cisco.com>

If allocation of pt->pscsi_cdb fails, we need to free the just-allocated
pt or else it will be leaked.

Signed-off-by: Roland Dreier <rolandd@cisco.com>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
(cherry picked from commit 7c4f4d0521c34596d7cb613d530a83538a0f9add)
(cherry picked from commit dea3bdb0081940ca9e2d435c19e00ddb623e9a4c)
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
1.7.3.5


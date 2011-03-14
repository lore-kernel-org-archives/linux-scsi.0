From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 01/21] target: Fix memory leak on error path in pscsi_alloc_task
Date: Mon, 14 Mar 2011 04:05:55 -0700
Message-ID: <1300100775-10012-2-git-send-email-nab@linux-iscsi.org>
References: <1300100775-10012-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1300100775-10012-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Boaz Harrosh <bharrosh@panasas.com>, Joel Becker <jlbec@evilplan.org>, Stephen Rothwell <sfr@canb.auug.org.au>, Douglas Gilbert <dgilbert@interlog.com>, Roland Dreier <rolandd@cisco.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

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

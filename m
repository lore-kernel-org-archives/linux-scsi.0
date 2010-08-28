From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 2/3] tcm: Remove struct se_subsystem_api->do_sync_cache()
Date: Fri, 27 Aug 2010 23:53:57 -0700
Message-ID: <1282978438-16947-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Tejun Heo <teheo@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

There is really no good reason to have two ->do_sync_cache_range() and
->do_sync_cache() callers, so this patch drops the latter.  It removes it
from struct se_subsystem_api and updates transport_generic_synchronize_cache()
to assume the underlying TCM subsystem will know the different when an explict
LBA + Number of Blocks Range is received with SYNCHRONIZE_CACHE emulation,
compared to the SYNCHRONIZE_CACHE of the entire device.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |   21 +++------------------
 include/target/target_core_transport.h |    7 -------
 2 files changed, 3 insertions(+), 25 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index a81b402..3761c0a 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -5195,24 +5195,9 @@ static int transport_generic_synchronize_cache(struct se_cmd *cmd)
 {
 	struct se_device *dev = cmd->se_dev;
 	/*
-	 * Determine if we will be flushing the entire device.
-	 */
-	if ((T_TASK(cmd)->t_task_lba == 0) && (cmd->data_length == 0)) {
-		if (TRANSPORT(dev)->do_sync_cache == NULL) {
-			printk(KERN_ERR "TRANSPORT(dev)->do_sync_cache is NULL\n");
-			return PYX_TRANSPORT_LU_COMM_FAILURE;
-		}
-		/*
-		 * The TCM subsystem plugin is expected to handle the
-		 * completion of the SYNCHRONIZE_CACHE op emulation
-		 */
-		TRANSPORT(dev)->do_sync_cache(cmd);
-		return 0;
-	}
-	/*
-	 * Otherwise we are flushing a specific range of LBAs.  The
-	 * ->do_sync_cache_range() caller is expected to handle any
-	 * LBA -> offset conversion.
+	 * We may be flushing the entire cache or only a specific
+	 * range of LBAs.  The ->do_sync_cache_range() caller is expected
+	 * to handle any LBA -> offset conversion.
 	 */
 	if (TRANSPORT(dev)->do_sync_cache_range == NULL) {
 		printk(KERN_ERR "TRANSPORT(dev)->do_sync_cache_range is NULL\n");
diff --git a/include/target/target_core_transport.h b/include/target/target_core_transport.h
index fa59ed7..2eb8f31 100644
--- a/include/target/target_core_transport.h
+++ b/include/target/target_core_transport.h
@@ -418,13 +418,6 @@ struct se_subsystem_api {
 	 */
 	int (*do_tmr)(struct se_cmd *cmd);
 	/*
-	 * do_sync_cache():
-	 *
-	 * Notify subsystem backstore when a SYNCHRONIZE_CACHE has been
-	 * received with WriteCache=1
-	 */
-	void (*do_sync_cache)(struct se_cmd *);
-	/*
 	 * do_sync_cache_range():
 	 *
 	 * Notify subsystem backstore when a SYNCHRONIZE_CACHE w/ explict
-- 
1.5.6.5

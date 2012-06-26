From: Mike Snitzer <snitzer@redhat.com>
Subject: [RESEND PATCH 3/3] dm mpath: add ability to disable
	partition creation
Date: Tue, 26 Jun 2012 14:32:05 -0400
Message-ID: <1340735525-21083-4-git-send-email-snitzer@redhat.com>
References: <1340735525-21083-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1340735525-21083-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: James Bottomley <jbottomley@parallels.com>
Cc: dm-devel@redhat.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

When multipath devices are being used as disks for VM Guests any
partition scanning / setup should be done within the VM Guest, not from
host.  So we need to a mechanism to switch off partition scanning and
creation via kpartx.

The new 'no_partitions' feature serves as a notifier to kpartx to _not_
create partitions on these multipath devices.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Reviewed-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
 drivers/md/dm-mpath.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 4dd3f59..115ad9e 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -86,6 +86,7 @@ struct multipath {
 	unsigned queue_if_no_path:1;	/* Queue I/O if last path fails? */
 	unsigned saved_queue_if_no_path:1; /* Saved state during suspension */
 	unsigned use_default_hw_handler:1; /* Use attached device handler */
+	unsigned no_partitions:1;	/* Avoid partition scanning */
 
 	unsigned pg_init_retries;	/* Number of times to retry pg_init */
 	unsigned pg_init_count;		/* Number of times pg_init called */
@@ -772,7 +773,7 @@ static int parse_features(struct dm_arg_set *as, struct multipath *m)
 	const char *arg_name;
 
 	static struct dm_arg _args[] = {
-		{0, 6, "invalid number of feature args"},
+		{0, 7, "invalid number of feature args"},
 		{1, 50, "pg_init_retries must be between 1 and 50"},
 		{0, 60000, "pg_init_delay_msecs must be between 0 and 60000"},
 	};
@@ -798,6 +799,11 @@ static int parse_features(struct dm_arg_set *as, struct multipath *m)
 			continue;
 		}
 
+		if (!strcasecmp(arg_name, "no_partitions")) {
+			m->no_partitions = 1;
+			continue;
+		}
+
 		if (!strcasecmp(arg_name, "pg_init_retries") &&
 		    (argc >= 1)) {
 			r = dm_read_arg(_args + 1, as, &m->pg_init_retries, &ti->error);
@@ -1382,7 +1388,8 @@ static int multipath_status(struct dm_target *ti, status_type_t type,
 		DMEMIT("%u ", m->queue_if_no_path +
 			      (m->pg_init_retries > 0) * 2 +
 			      (m->pg_init_delay_msecs != DM_PG_INIT_DELAY_DEFAULT) * 2 +
-			      m->use_default_hw_handler);
+			      m->use_default_hw_handler +
+			      m->no_partitions);
 		if (m->queue_if_no_path)
 			DMEMIT("queue_if_no_path ");
 		if (m->pg_init_retries)
@@ -1391,6 +1398,8 @@ static int multipath_status(struct dm_target *ti, status_type_t type,
 			DMEMIT("pg_init_delay_msecs %u ", m->pg_init_delay_msecs);
 		if (m->use_default_hw_handler)
 			DMEMIT("default_hw_handler ");
+		if (m->no_partitions)
+			DMEMIT("no_partitions ");
 	}
 
 	if (!m->hw_handler_name || type == STATUSTYPE_INFO)
-- 
1.7.4.4

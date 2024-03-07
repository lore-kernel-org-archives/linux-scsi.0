Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8419E23769
	for <linux-scsi@vger.kernel.org>; Thu,  7 Mar 2024 20:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709843439; cv=none; b=uKZAXwP2Pq9SZrUcRfPoaEBw/xG3mObOeMoRl6W1QeHKOgXWuV5gVI9P/9Bjb9VW41RdJ06ACpD4oN4XFS8PmB9fak5lJyAl0yUm7OynhOumzGrUzbUb2JcKoRbbwH/nyoSC96/8qzFc99YZ1h1/CXq4zTC6AmMr9u6rK7PaC1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709843439; c=relaxed/simple;
	bh=69EgRrLizmuwufflrgKN8hzoWh/Pqn4roEz2bfTSW3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZlrAIqkhZvK3zHptcc59CjJHncYN9CYO3Bes9P+DoBjmiEwUlAgksHZP4Z3xPloMC9ZRmcYODEnXg+ERlzjgke6IMhgCnfO/wg42Mgx4vPgneaT2Zw89PhgMu18en+PlbIT3SNm68Rp6feJo6Z74CzBJwiSgRDWYRlvEDQsiY3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=zk4Z+SgL; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="zk4Z+SgL"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4TrLXX6d7Wz6Cl44w;
	Thu,  7 Mar 2024 20:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1709843427; x=1712435428; bh=j42KF
	b2bzHN8DAUn6WygrBcH8l3UFtNmhf0vJk0cVrc=; b=zk4Z+SgL/Tis1V4UlaS10
	bH5fn73lYX2Nrp41Ylersgib7f5dpbEWysUbFqHa9lnOOI6R0pjgN4ZOBkT9VUt9
	hIyDRAEDyh6nTFYFe00yFjtIoD89+CdEeBWVq4ROTCCP0kiHZ2xCKEzY0mu7B3ba
	woL1rC6E62S0kJGrA01btQtDAfsAVuJkVSoox2xNGVzxwPvdebFZKWU9I+JQPYkQ
	KLTw45RZdWAB/SHthv7F1VMNipRw1YbRblyWwKEXyv8BppcEq2wKZDXjdy7uSZS5
	mZOtCiZaqb0CGgW2SmScuACWRYvX6lElFyxnM8JX0xTf5dsBeqCfJAT6FXCMBxcL
	Q==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id VqfpkgHU0-QN; Thu,  7 Mar 2024 20:30:27 +0000 (UTC)
Received: from bvanassche-linux.mtv.corp.google.com (unknown [104.132.1.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4TrLXL2Zvjz6Cl2L2;
	Thu,  7 Mar 2024 20:30:26 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Douglas Gilbert <dgilbert@interlog.com>,
	John Garry <john.g.garry@oracle.com>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 3/4] scsi: scsi_debug: Simplify command handling
Date: Thu,  7 Mar 2024 12:30:06 -0800
Message-ID: <20240307203015.870254-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
In-Reply-To: <20240307203015.870254-1-bvanassche@acm.org>
References: <20240307203015.870254-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Simplify command handling by moving struct sdebug_defer into the
private SCSI command data instead of allocating it separately. The only
functional change is that aborting a SCSI command now fails and is
retried at a later time if the completion handler can't be cancelled.

See also commit 1107c7b24ee3 ("scsi: scsi_debug: Dynamically allocate
sdebug_queued_cmd"; v6.4).

Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: John Garry <john.g.garry@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_debug.c | 140 +++++++-------------------------------
 1 file changed, 26 insertions(+), 114 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 7a0b7402b715..1597156cb573 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -253,11 +253,6 @@ static const char *sdebug_version_date =3D "20210520=
";
=20
 #define SDEB_XA_NOT_IN_USE XA_MARK_1
=20
-static struct kmem_cache *queued_cmd_cache;
-
-#define TO_QUEUED_CMD(scmd)  ((void *)(scmd)->host_scribble)
-#define ASSIGN_QUEUED_CMD(scmnd, qc) { (scmnd)->host_scribble =3D (void =
*) qc; }
-
 /* Zone types (zbcr05 table 25) */
 enum sdebug_z_type {
 	ZBC_ZTYPE_CNV	=3D 0x1,
@@ -398,16 +393,9 @@ struct sdebug_defer {
 	enum sdeb_defer_type defer_t;
 };
=20
-struct sdebug_queued_cmd {
-	/* corresponding bit set in in_use_bm[] in owning struct sdebug_queue
-	 * instance indicates this slot is in use.
-	 */
-	struct sdebug_defer sd_dp;
-	struct scsi_cmnd *scmd;
-};
-
 struct sdebug_scsi_cmd {
 	spinlock_t   lock;
+	struct sdebug_defer sd_dp;
 };
=20
 static atomic_t sdebug_cmnd_count;   /* number of incoming commands */
@@ -559,8 +547,6 @@ static int sdebug_add_store(void);
 static void sdebug_erase_store(int idx, struct sdeb_store_info *sip);
 static void sdebug_erase_all_stores(bool apart_from_first);
=20
-static void sdebug_free_queued_cmd(struct sdebug_queued_cmd *sqcp);
-
 /*
  * The following are overflow arrays for cdbs that "hit" the same index =
in
  * the opcode_info_arr array. The most time sensitive (or commonly used)=
 cdb
@@ -5332,10 +5318,9 @@ static u32 get_tag(struct scsi_cmnd *cmnd)
 /* Queued (deferred) command completions converge here. */
 static void sdebug_q_cmd_complete(struct sdebug_defer *sd_dp)
 {
-	struct sdebug_queued_cmd *sqcp =3D container_of(sd_dp, struct sdebug_qu=
eued_cmd, sd_dp);
+	struct sdebug_scsi_cmd *sdsc =3D container_of(sd_dp, typeof(*sdsc), sd_=
dp);
+	struct scsi_cmnd *scp =3D (struct scsi_cmnd *)sdsc - 1;
 	unsigned long flags;
-	struct scsi_cmnd *scp =3D sqcp->scmd;
-	struct sdebug_scsi_cmd *sdsc;
 	bool aborted;
=20
 	if (sdebug_statistics) {
@@ -5346,7 +5331,7 @@ static void sdebug_q_cmd_complete(struct sdebug_def=
er *sd_dp)
=20
 	if (!scp) {
 		pr_err("scmd=3DNULL\n");
-		goto out;
+		return;
 	}
=20
 	sdsc =3D scsi_cmd_priv(scp);
@@ -5354,19 +5339,16 @@ static void sdebug_q_cmd_complete(struct sdebug_d=
efer *sd_dp)
 	aborted =3D sd_dp->aborted;
 	if (unlikely(aborted))
 		sd_dp->aborted =3D false;
-	ASSIGN_QUEUED_CMD(scp, NULL);
=20
 	spin_unlock_irqrestore(&sdsc->lock, flags);
=20
 	if (aborted) {
 		pr_info("bypassing scsi_done() due to aborted cmd, kicking-off EH\n");
 		blk_abort_request(scsi_cmd_to_rq(scp));
-		goto out;
+		return;
 	}
=20
 	scsi_done(scp); /* callback to mid level */
-out:
-	sdebug_free_queued_cmd(sqcp);
 }
=20
 /* When high resolution timer goes off this function is called. */
@@ -5648,50 +5630,32 @@ static void scsi_debug_slave_destroy(struct scsi_=
device *sdp)
 	sdp->hostdata =3D NULL;
 }
=20
-/* Returns true if the queued command memory should be freed by the call=
er. */
-static bool stop_qc_helper(struct sdebug_defer *sd_dp,
-			   enum sdeb_defer_type defer_t)
+/* Returns true if it is safe to complete @cmnd. */
+static bool scsi_debug_stop_cmnd(struct scsi_cmnd *cmnd)
 {
+	struct sdebug_scsi_cmd *sdsc =3D scsi_cmd_priv(cmnd);
+	struct sdebug_defer *sd_dp =3D &sdsc->sd_dp;
+	enum sdeb_defer_type defer_t =3D READ_ONCE(sd_dp->defer_t);
+
+	lockdep_assert_held(&sdsc->lock);
+
 	if (defer_t =3D=3D SDEB_DEFER_HRT) {
 		int res =3D hrtimer_try_to_cancel(&sd_dp->hrt);
=20
 		switch (res) {
-		case 0: /* Not active, it must have already run */
 		case -1: /* -1 It's executing the CB */
 			return false;
+		case 0: /* Not active, it must have already run */
 		case 1: /* Was active, we've now cancelled */
 		default:
 			return true;
 		}
 	} else if (defer_t =3D=3D SDEB_DEFER_WQ) {
-		/* The caller must free qcmd if cancellation succeeds. */
-		return cancel_work(&sd_dp->ew.work);
-	} else if (defer_t =3D=3D SDEB_DEFER_POLL) {
-		return true;
+		/* Retry aborting later if the completion handler is running. */
+		return cancel_work(&sd_dp->ew.work) ||
+			!work_pending(&sd_dp->ew.work);
 	}
=20
-	return false;
-}
-
-
-static bool scsi_debug_stop_cmnd(struct scsi_cmnd *cmnd)
-{
-	enum sdeb_defer_type l_defer_t;
-	struct sdebug_defer *sd_dp;
-	struct sdebug_scsi_cmd *sdsc =3D scsi_cmd_priv(cmnd);
-	struct sdebug_queued_cmd *sqcp =3D TO_QUEUED_CMD(cmnd);
-
-	lockdep_assert_held(&sdsc->lock);
-
-	if (!sqcp)
-		return false;
-	sd_dp =3D &sqcp->sd_dp;
-	l_defer_t =3D READ_ONCE(sd_dp->defer_t);
-	ASSIGN_QUEUED_CMD(cmnd, NULL);
-
-	if (stop_qc_helper(sd_dp, l_defer_t))
-		sdebug_free_queued_cmd(sqcp);
-
 	return true;
 }
=20
@@ -5706,6 +5670,8 @@ static bool scsi_debug_abort_cmnd(struct scsi_cmnd =
*cmnd)
=20
 	spin_lock_irqsave(&sdsc->lock, flags);
 	res =3D scsi_debug_stop_cmnd(cmnd);
+	if (res)
+		WRITE_ONCE(sdsc->sd_dp.defer_t, SDEB_DEFER_NONE);
 	spin_unlock_irqrestore(&sdsc->lock, flags);
=20
 	return res;
@@ -5783,7 +5749,7 @@ static int scsi_debug_abort(struct scsi_cmnd *SCpnt=
)
 		return FAILED;
 	}
=20
-	return SUCCESS;
+	return ok ? SUCCESS : FAILED;
 }
=20
 static bool scsi_debug_stop_all_queued_iter(struct request *rq, void *da=
ta)
@@ -6056,33 +6022,6 @@ static bool inject_on_this_cmd(void)
=20
 #define INCLUSIVE_TIMING_MAX_NS 1000000		/* 1 millisecond */
=20
-
-void sdebug_free_queued_cmd(struct sdebug_queued_cmd *sqcp)
-{
-	if (sqcp)
-		kmem_cache_free(queued_cmd_cache, sqcp);
-}
-
-static struct sdebug_queued_cmd *sdebug_alloc_queued_cmd(struct scsi_cmn=
d *scmd)
-{
-	struct sdebug_queued_cmd *sqcp;
-	struct sdebug_defer *sd_dp;
-
-	sqcp =3D kmem_cache_zalloc(queued_cmd_cache, GFP_ATOMIC);
-	if (!sqcp)
-		return NULL;
-
-	sd_dp =3D &sqcp->sd_dp;
-
-	hrtimer_init(&sd_dp->hrt, CLOCK_MONOTONIC, HRTIMER_MODE_REL_PINNED);
-	sd_dp->hrt.function =3D sdebug_q_cmd_hrt_complete;
-	INIT_WORK(&sd_dp->ew.work, sdebug_q_cmd_wq_complete);
-
-	sqcp->scmd =3D scmd;
-
-	return sqcp;
-}
-
 /* Complete the processing of the thread that queued a SCSI command to t=
his
  * driver. It either completes the command by calling cmnd_done() or
  * schedules a hr timer or work queue then returns 0. Returns
@@ -6099,7 +6038,6 @@ static int schedule_resp(struct scsi_cmnd *cmnd, st=
ruct sdebug_dev_info *devip,
 	struct sdebug_scsi_cmd *sdsc =3D scsi_cmd_priv(cmnd);
 	unsigned long flags;
 	u64 ns_from_boot =3D 0;
-	struct sdebug_queued_cmd *sqcp;
 	struct scsi_device *sdp;
 	struct sdebug_defer *sd_dp;
=20
@@ -6131,12 +6069,7 @@ static int schedule_resp(struct scsi_cmnd *cmnd, s=
truct sdebug_dev_info *devip,
 		}
 	}
=20
-	sqcp =3D sdebug_alloc_queued_cmd(cmnd);
-	if (!sqcp) {
-		pr_err("%s no alloc\n", __func__);
-		return SCSI_MLQUEUE_HOST_BUSY;
-	}
-	sd_dp =3D &sqcp->sd_dp;
+	sd_dp =3D &sdsc->sd_dp;
=20
 	if (polled)
 		ns_from_boot =3D ktime_get_boottime_ns();
@@ -6184,7 +6117,6 @@ static int schedule_resp(struct scsi_cmnd *cmnd, st=
ruct sdebug_dev_info *devip,
=20
 				if (kt <=3D d) {	/* elapsed duration >=3D kt */
 					/* call scsi_done() from this thread */
-					sdebug_free_queued_cmd(sqcp);
 					scsi_done(cmnd);
 					return 0;
 				}
@@ -6197,13 +6129,11 @@ static int schedule_resp(struct scsi_cmnd *cmnd, =
struct sdebug_dev_info *devip,
 		if (polled) {
 			spin_lock_irqsave(&sdsc->lock, flags);
 			sd_dp->cmpl_ts =3D ktime_add(ns_to_ktime(ns_from_boot), kt);
-			ASSIGN_QUEUED_CMD(cmnd, sqcp);
 			WRITE_ONCE(sd_dp->defer_t, SDEB_DEFER_POLL);
 			spin_unlock_irqrestore(&sdsc->lock, flags);
 		} else {
 			/* schedule the invocation of scsi_done() for a later time */
 			spin_lock_irqsave(&sdsc->lock, flags);
-			ASSIGN_QUEUED_CMD(cmnd, sqcp);
 			WRITE_ONCE(sd_dp->defer_t, SDEB_DEFER_HRT);
 			hrtimer_start(&sd_dp->hrt, kt, HRTIMER_MODE_REL_PINNED);
 			/*
@@ -6227,13 +6157,11 @@ static int schedule_resp(struct scsi_cmnd *cmnd, =
struct sdebug_dev_info *devip,
 			sd_dp->issuing_cpu =3D raw_smp_processor_id();
 		if (polled) {
 			spin_lock_irqsave(&sdsc->lock, flags);
-			ASSIGN_QUEUED_CMD(cmnd, sqcp);
 			sd_dp->cmpl_ts =3D ns_to_ktime(ns_from_boot);
 			WRITE_ONCE(sd_dp->defer_t, SDEB_DEFER_POLL);
 			spin_unlock_irqrestore(&sdsc->lock, flags);
 		} else {
 			spin_lock_irqsave(&sdsc->lock, flags);
-			ASSIGN_QUEUED_CMD(cmnd, sqcp);
 			WRITE_ONCE(sd_dp->defer_t, SDEB_DEFER_WQ);
 			schedule_work(&sd_dp->ew.work);
 			spin_unlock_irqrestore(&sdsc->lock, flags);
@@ -7587,12 +7515,6 @@ static int __init scsi_debug_init(void)
 	hosts_to_add =3D sdebug_add_host;
 	sdebug_add_host =3D 0;
=20
-	queued_cmd_cache =3D KMEM_CACHE(sdebug_queued_cmd, SLAB_HWCACHE_ALIGN);
-	if (!queued_cmd_cache) {
-		ret =3D -ENOMEM;
-		goto driver_unreg;
-	}
-
 	sdebug_debugfs_root =3D debugfs_create_dir("scsi_debug", NULL);
 	if (IS_ERR_OR_NULL(sdebug_debugfs_root))
 		pr_info("%s: failed to create initial debugfs directory\n", __func__);
@@ -7619,8 +7541,6 @@ static int __init scsi_debug_init(void)
=20
 	return 0;
=20
-driver_unreg:
-	driver_unregister(&sdebug_driverfs_driver);
 bus_unreg:
 	bus_unregister(&pseudo_lld_bus);
 dev_unreg:
@@ -7636,7 +7556,6 @@ static void __exit scsi_debug_exit(void)
=20
 	for (; k; k--)
 		sdebug_do_remove_host(true);
-	kmem_cache_destroy(queued_cmd_cache);
 	driver_unregister(&sdebug_driverfs_driver);
 	bus_unregister(&pseudo_lld_bus);
 	root_device_unregister(pseudo_primary);
@@ -8018,7 +7937,6 @@ static bool sdebug_blk_mq_poll_iter(struct request =
*rq, void *opaque)
 	struct sdebug_defer *sd_dp;
 	u32 unique_tag =3D blk_mq_unique_tag(rq);
 	u16 hwq =3D blk_mq_unique_tag_to_hwq(unique_tag);
-	struct sdebug_queued_cmd *sqcp;
 	unsigned long flags;
 	int queue_num =3D data->queue_num;
 	ktime_t time;
@@ -8034,13 +7952,7 @@ static bool sdebug_blk_mq_poll_iter(struct request=
 *rq, void *opaque)
 	time =3D ktime_get_boottime();
=20
 	spin_lock_irqsave(&sdsc->lock, flags);
-	sqcp =3D TO_QUEUED_CMD(cmd);
-	if (!sqcp) {
-		spin_unlock_irqrestore(&sdsc->lock, flags);
-		return true;
-	}
-
-	sd_dp =3D &sqcp->sd_dp;
+	sd_dp =3D &sdsc->sd_dp;
 	if (READ_ONCE(sd_dp->defer_t) !=3D SDEB_DEFER_POLL) {
 		spin_unlock_irqrestore(&sdsc->lock, flags);
 		return true;
@@ -8050,8 +7962,6 @@ static bool sdebug_blk_mq_poll_iter(struct request =
*rq, void *opaque)
 		spin_unlock_irqrestore(&sdsc->lock, flags);
 		return true;
 	}
-
-	ASSIGN_QUEUED_CMD(cmd, NULL);
 	spin_unlock_irqrestore(&sdsc->lock, flags);
=20
 	if (sdebug_statistics) {
@@ -8060,8 +7970,6 @@ static bool sdebug_blk_mq_poll_iter(struct request =
*rq, void *opaque)
 			atomic_inc(&sdebug_miss_cpus);
 	}
=20
-	sdebug_free_queued_cmd(sqcp);
-
 	scsi_done(cmd); /* callback to mid level */
 	(*data->num_entries)++;
 	return true;
@@ -8376,8 +8284,12 @@ static int scsi_debug_queuecommand(struct Scsi_Hos=
t *shost,
 static int sdebug_init_cmd_priv(struct Scsi_Host *shost, struct scsi_cmn=
d *cmd)
 {
 	struct sdebug_scsi_cmd *sdsc =3D scsi_cmd_priv(cmd);
+	struct sdebug_defer *sd_dp =3D &sdsc->sd_dp;
=20
 	spin_lock_init(&sdsc->lock);
+	hrtimer_init(&sd_dp->hrt, CLOCK_MONOTONIC, HRTIMER_MODE_REL_PINNED);
+	sd_dp->hrt.function =3D sdebug_q_cmd_hrt_complete;
+	INIT_WORK(&sd_dp->ew.work, sdebug_q_cmd_wq_complete);
=20
 	return 0;
 }

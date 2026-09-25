Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E9B73672A8
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 18:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790361057; cv=none; b=nQwl7enIcyeBI38FAq9EaEeM75fUdhN2K8DqGKPALWq9aJYNiZMFONSeaJbLJcAK3OsrAGYlEARoI9OEIOKKcArDZ+Fzo48iod8TeaOLRHNWWULWlnJX/YCQIF8rbe3NNiLGPBbwrg/yTA2eesodiqB1FZtnycJDMn228nQJ5wU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790361057; c=relaxed/simple;
	bh=ZMFXO/XLjSOwo1uz1G47KlXiPu1wkyY0oFkDAM2aBaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YRu3d2Uzj2s4v9fAQ4BxcoCDn1jq23b470e+QkS4uOJHpruhlr5vbwOOJ4UJ9ktkm1EVGBwEjvjlTnHzRRZnfxzqZ7vP9yiB5c05VFHSrn+8bRtq6AlN0h2Nh81StIi2FrHGRjvT1B9D9UEse3C8iPuENXb/BpWmO16CHjhN5lU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=IiBGU0Zy; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="IiBGU0Zy"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hrzmH39cGz1XM5kY;
	Fri, 25 Sep 2026 18:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1790361040; x=1792953041; bh=uTkiI
	Ng+j3rc3J9zD4R5DNw6bW+7iTiTvHvhtAIMckA=; b=IiBGU0ZyPed3vLgjz+gm0
	BDn87tgv8GDEHMjBbim22KZCGDjiAz1+Y6aXhPI6l7KskbJ4I8edZYiePnVd+1uD
	/AdejjzaMSbYwAd/HJ3YCSJb5M9YbpPCOi+7jpblkyvi7qokqT9vXFqwOQQ4KJkO
	2nk1ENblDaD9xrmMEXPpkOn77zNzcJzVbhIOZfHxYIlj/O7H2jQSquMUfgYDWRru
	Ll8+PNKFT26TWklUwN5jVOzAuL6dpgpcTTT6rCjyU9jyYgBsY0VKSXVq0TloicX3
	Vsv8i0OgkfSj5T8dV/ltnJZXCsqUvp3ojAzEXIpsi2t6XQ2u3LdEYDTtrEXO71WH
	Q==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id QD9Iqsq2X8Jc; Fri, 25 Sep 2026 18:30:40 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hrzlx2nWxz1XM5kW;
	Fri, 25 Sep 2026 18:30:37 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hannes Reinecke <hare@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Colin Ian King <colin.i.king@gmail.com>
Subject: [PATCH v4 20/54] scsi: csiostor: Pass the hw pointer directly to several functions
Date: Fri, 25 Sep 2026 11:25:58 -0700
Message-ID: <f6e8b86640799a70cfb161210048ca4570bad03d.1790360262.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
In-Reply-To: <cover.1790360262.git.bvanassche@acm.org>
References: <cover.1790360262.git.bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Pass the struct csio_hw pointer directly to csio_scsi_cleanup_io_q(),
csio_scsi_abort_io_q(), csio_scsim_cleanup_io(), and
csio_scsim_cleanup_io_lnode() instead of passing the struct csio_scsim
pointer. Update all callers and header declarations accordingly.

Prepare the csiostor driver for enabling compiler-based lock context
analysis. No functionality has been changed.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/csiostor/csio_attr.c  |  4 ++--
 drivers/scsi/csiostor/csio_hw.c    |  8 ++++---
 drivers/scsi/csiostor/csio_rnode.c |  3 +--
 drivers/scsi/csiostor/csio_scsi.c  | 38 +++++++++++++-----------------
 drivers/scsi/csiostor/csio_scsi.h  |  7 +++---
 5 files changed, 28 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/csiostor/csio_attr.c b/drivers/scsi/csiostor/cs=
io_attr.c
index 9f021a7f78bd..7fddb98e1024 100644
--- a/drivers/scsi/csiostor/csio_attr.c
+++ b/drivers/scsi/csiostor/csio_attr.c
@@ -630,7 +630,7 @@ csio_vport_delete(struct fc_vport *fc_vport)
 	/* Quiesce ios and send remove event to lnode */
 	scsi_block_requests(shost);
 	spin_lock_irq(&hw->lock);
-	csio_scsim_cleanup_io_lnode(csio_hw_to_scsim(hw), ln);
+	csio_scsim_cleanup_io_lnode(hw, ln);
 	csio_lnode_close(ln);
 	spin_unlock_irq(&hw->lock);
 	scsi_unblock_requests(shost);
@@ -655,7 +655,7 @@ csio_vport_disable(struct fc_vport *fc_vport, bool di=
sable)
 		/* Quiesce ios and send stop event to lnode */
 		scsi_block_requests(shost);
 		spin_lock_irq(&hw->lock);
-		csio_scsim_cleanup_io_lnode(csio_hw_to_scsim(hw), ln);
+		csio_scsim_cleanup_io_lnode(hw, ln);
 		csio_lnode_stop(ln);
 		spin_unlock_irq(&hw->lock);
 		scsi_unblock_requests(shost);
diff --git a/drivers/scsi/csiostor/csio_hw.c b/drivers/scsi/csiostor/csio=
_hw.c
index df9f81f29950..d8ed326dc602 100644
--- a/drivers/scsi/csiostor/csio_hw.c
+++ b/drivers/scsi/csiostor/csio_hw.c
@@ -92,7 +92,8 @@ static void csio_hw_mbm_cleanup(struct csio_hw *);
 static void csio_hws_uninit(struct csio_hw *, enum csio_hw_ev);
 static void csio_hws_configuring(struct csio_hw *, enum csio_hw_ev);
 static void csio_hws_initializing(struct csio_hw *, enum csio_hw_ev);
-static void csio_hws_ready(struct csio_hw *, enum csio_hw_ev);
+static void csio_hws_ready(struct csio_hw *, enum csio_hw_ev)
+	__must_hold(&hw->lock);
 static void csio_hws_quiescing(struct csio_hw *, enum csio_hw_ev);
 static void csio_hws_quiesced(struct csio_hw *, enum csio_hw_ev);
 static void csio_hws_resetting(struct csio_hw *, enum csio_hw_ev);
@@ -2879,6 +2880,7 @@ csio_hws_initializing(struct csio_hw *hw, enum csio=
_hw_ev evt)
  */
 static void
 csio_hws_ready(struct csio_hw *hw, enum csio_hw_ev evt)
+	__must_hold(&hw->lock)
 {
 	/* Remember the event */
 	hw->evtflag =3D evt;
@@ -2897,9 +2899,9 @@ csio_hws_ready(struct csio_hw *hw, enum csio_hw_ev =
evt)
 		/* cleanup all outstanding cmds */
 		if (evt =3D=3D CSIO_HWE_HBA_RESET ||
 		    evt =3D=3D CSIO_HWE_PCIERR_DETECTED)
-			csio_scsim_cleanup_io(csio_hw_to_scsim(hw), false);
+			csio_scsim_cleanup_io(hw, false);
 		else
-			csio_scsim_cleanup_io(csio_hw_to_scsim(hw), true);
+			csio_scsim_cleanup_io(hw, true);
=20
 		csio_hw_intr_disable(hw);
 		csio_hw_mbm_cleanup(hw);
diff --git a/drivers/scsi/csiostor/csio_rnode.c b/drivers/scsi/csiostor/c=
sio_rnode.c
index 713e13adf4dc..46d82802a5d4 100644
--- a/drivers/scsi/csiostor/csio_rnode.c
+++ b/drivers/scsi/csiostor/csio_rnode.c
@@ -586,8 +586,7 @@ __csio_unreg_rnode(struct csio_rnode *rn)
=20
 	/* Cleanup I/Os that were waiting for rnode to unregister */
 	if (cmpl)
-		csio_scsi_cleanup_io_q(csio_hw_to_scsim(hw), &tmp_q);
-
+		csio_scsi_cleanup_io_q(hw, &tmp_q);
 }
=20
 /***********************************************************************=
******/
diff --git a/drivers/scsi/csiostor/csio_scsi.c b/drivers/scsi/csiostor/cs=
io_scsi.c
index 0114e70e9884..b1473e1f514f 100644
--- a/drivers/scsi/csiostor/csio_scsi.c
+++ b/drivers/scsi/csiostor/csio_scsi.c
@@ -1150,15 +1150,14 @@ csio_scsi_cmpl_handler(struct csio_hw *hw, void *=
wr, uint32_t len,
=20
 /*
  * csio_scsi_cleanup_io_q - Cleanup the given queue.
- * @scm: SCSI module.
+ * @hw: HW module.
  * @q: Queue to be cleaned up.
  *
  * Called with lock held. Has to exit with lock held.
  */
-void
-csio_scsi_cleanup_io_q(struct csio_scsim *scm, struct list_head *q)
+void csio_scsi_cleanup_io_q(struct csio_hw *hw, struct list_head *q)
 {
-	struct csio_hw *hw =3D scm->hw;
+	struct csio_scsim *scm =3D csio_hw_to_scsim(hw);
 	struct csio_ioreq *ioreq;
 	struct list_head *tmp, *next;
 	struct scsi_cmnd *scmnd;
@@ -1215,7 +1214,7 @@ csio_abrt_cls(struct csio_ioreq *ioreq, struct scsi=
_cmnd *scmnd)
=20
 /*
  * csio_scsi_abort_io_q - Abort all I/Os on given queue
- * @scm: SCSI module.
+ * @hw: HW module.
  * @q: Queue to abort.
  * @tmo: Timeout in ms
  *
@@ -1229,10 +1228,9 @@ csio_abrt_cls(struct csio_ioreq *ioreq, struct scs=
i_cmnd *scmnd)
  * of this function has to ensure that the number of I/os to be aborted
  * is finite enough to not cause lock-held-for-too-long issues.
  */
-static int
-csio_scsi_abort_io_q(struct csio_scsim *scm, struct list_head *q, uint32=
_t tmo)
+static int csio_scsi_abort_io_q(struct csio_hw *hw, struct list_head *q,
+				uint32_t tmo)
 {
-	struct csio_hw *hw =3D scm->hw;
 	struct list_head *tmp, *next;
 	int count =3D DIV_ROUND_UP(tmo, CSIO_SCSI_ABORT_Q_POLL_MS);
 	struct scsi_cmnd *scmnd;
@@ -1264,15 +1262,14 @@ csio_scsi_abort_io_q(struct csio_scsim *scm, stru=
ct list_head *q, uint32_t tmo)
=20
 /*
  * csio_scsim_cleanup_io - Cleanup all I/Os in SCSI module.
- * @scm: SCSI module.
+ * @hw: HW module.
  * @abort: abort required.
  * Called with lock held, should exit with lock held.
  * Can sleep when waiting for I/Os to complete.
  */
-int
-csio_scsim_cleanup_io(struct csio_scsim *scm, bool abort)
+int csio_scsim_cleanup_io(struct csio_hw *hw, bool abort)
 {
-	struct csio_hw *hw =3D scm->hw;
+	struct csio_scsim *scm =3D csio_hw_to_scsim(hw);
 	int rv =3D 0;
 	int count =3D DIV_ROUND_UP(60 * 1000, CSIO_SCSI_ABORT_Q_POLL_MS);
=20
@@ -1293,13 +1290,13 @@ csio_scsim_cleanup_io(struct csio_scsim *scm, boo=
l abort)
=20
 	/* Else abort */
 	if (abort) {
-		rv =3D csio_scsi_abort_io_q(scm, &scm->active_q, 30000);
+		rv =3D csio_scsi_abort_io_q(hw, &scm->active_q, 30000);
 		if (rv =3D=3D 0)
 			return rv;
 		csio_dbg(hw, "Some I/O aborts timed out, cleaning up..\n");
 	}
=20
-	csio_scsi_cleanup_io_q(scm, &scm->active_q);
+	csio_scsi_cleanup_io_q(hw, &scm->active_q);
=20
 	CSIO_DB_ASSERT(list_empty(&scm->active_q));
=20
@@ -1308,16 +1305,15 @@ csio_scsim_cleanup_io(struct csio_scsim *scm, boo=
l abort)
=20
 /*
  * csio_scsim_cleanup_io_lnode - Cleanup all I/Os of given lnode.
- * @scm: SCSI module.
+ * @hw: HW module
  * @lnode: lnode
  *
  * Called with lock held, should exit with lock held.
  * Can sleep (with dropped lock) when waiting for I/Os to complete.
  */
-int
-csio_scsim_cleanup_io_lnode(struct csio_scsim *scm, struct csio_lnode *l=
n)
+int csio_scsim_cleanup_io_lnode(struct csio_hw *hw, struct csio_lnode *l=
n)
 {
-	struct csio_hw *hw =3D scm->hw;
+	struct csio_scsim *scm =3D csio_hw_to_scsim(hw);
 	struct csio_scsi_level_data sld;
 	int rv;
 	int count =3D DIV_ROUND_UP(60 * 1000, CSIO_SCSI_ABORT_Q_POLL_MS);
@@ -1347,10 +1343,10 @@ csio_scsim_cleanup_io_lnode(struct csio_scsim *sc=
m, struct csio_lnode *ln)
 	csio_dbg(hw, "Some I/Os pending on ln:%p, aborting them..\n", ln);
=20
 	/* I/Os are pending, abort them */
-	rv =3D csio_scsi_abort_io_q(scm, &ln->cmpl_q, 30000);
+	rv =3D csio_scsi_abort_io_q(hw, &ln->cmpl_q, 30000);
 	if (rv !=3D 0) {
 		csio_dbg(hw, "Some I/O aborts timed out, cleaning up..\n");
-		csio_scsi_cleanup_io_q(scm, &ln->cmpl_q);
+		csio_scsi_cleanup_io_q(hw, &ln->cmpl_q);
 	}
=20
 	CSIO_DB_ASSERT(list_empty(&ln->cmpl_q));
@@ -2194,7 +2190,7 @@ csio_eh_lun_reset_handler(struct scsi_cmnd *cmnd)
 	spin_lock_irq(&hw->lock);
 	csio_scsi_gather_active_ios(scsim, &sld, &local_q);
=20
-	retval =3D csio_scsi_abort_io_q(scsim, &local_q, 30000);
+	retval =3D csio_scsi_abort_io_q(hw, &local_q, 30000);
 	spin_unlock_irq(&hw->lock);
=20
 	/* Aborts may have timed out */
diff --git a/drivers/scsi/csiostor/csio_scsi.h b/drivers/scsi/csiostor/cs=
io_scsi.h
index 39dda3c88f0d..610aae12be8a 100644
--- a/drivers/scsi/csiostor/csio_scsi.h
+++ b/drivers/scsi/csiostor/csio_scsi.h
@@ -338,10 +338,9 @@ csio_scsi_close(struct csio_ioreq *ioreq)
 	return ioreq->drv_status;
 }
=20
-void csio_scsi_cleanup_io_q(struct csio_scsim *, struct list_head *);
-int csio_scsim_cleanup_io(struct csio_scsim *, bool abort);
-int csio_scsim_cleanup_io_lnode(struct csio_scsim *,
-					  struct csio_lnode *);
+void csio_scsi_cleanup_io_q(struct csio_hw *, struct list_head *);
+int csio_scsim_cleanup_io(struct csio_hw *, bool abort);
+int csio_scsim_cleanup_io_lnode(struct csio_hw *, struct csio_lnode *);
 struct csio_ioreq *csio_scsi_cmpl_handler(struct csio_hw *, void *, uint=
32_t,
 					  struct csio_fl_dma_buf *,
 					  void *, uint8_t **);

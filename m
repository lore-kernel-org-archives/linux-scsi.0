Received: from lamorak.hansenpartnership.com (lamorak.hansenpartnership.com [198.37.111.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA07333E345;
	Sun, 18 Oct 2026 14:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.37.111.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792334340; cv=none; b=RPXiDuATK/tcsUvnKBhQ97yxmeqoTpS/AE7aR0CuSSms8Y3OEuCLXpDzYbRYLNpf4LtnuqspepbbZ4arJ/k2AMBPP+yDNGkE7BvykcuW6/J8o2gM9P92EGQcPYUuXWLXz7PVFUHaWOnh0sEQUJvMoDcZf8C/xfcg8UT3nymPT9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792334340; c=relaxed/simple;
	bh=oi9m4jPq2+AoXao2VaSnuAwJWqVZ1aRm/DhlWXrljxw=;
	h=Message-ID:Subject:From:To:Cc:Date:Content-Type:MIME-Version; b=QtJVnf20AKOZ5uVNx5u3sBTz8+eb8ZtJCh2kMJFiVIxgEaDnV8miQ0+1h/rQM9YRtOluhBxG7JT5usR9JF8noiSxRyYKVew90XdSuZB/XXH2MSIuK55tNfaa6Yig8gxruye1MreBF44Nh6kD3TBgzGkFyO7J5NaPocF8UZSmaJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=Hlshf/pI; arc=none smtp.client-ip=198.37.111.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="Hlshf/pI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1792334336;
	bh=oi9m4jPq2+AoXao2VaSnuAwJWqVZ1aRm/DhlWXrljxw=;
	h=Message-ID:Subject:From:To:Date:From;
	b=Hlshf/pIvGrwqj4Id+v+pU2mohhIAJakAVkKpLGhwCIFjae/q4s3TjC+fqfAOw/F3
	 uck4GFqofmGJ00TQarGgryGT6J0MZgd6F3zcCH98PYARX8/mX/Xkd3nhUajM/kLR0t
	 RAuHaZRFVeUrPTcnEkp3gaU4bkwKiTyxYw6Oa1vQ=
Received: from lingrow.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4300:d341::8309])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lamorak.hansenpartnership.com (Postfix) with ESMTPSA id A85C81C0415;
	Sun, 18 Oct 2026 10:38:56 -0400 (EDT)
Message-ID: <6a4bfcdc8e60669d95abb70bdaa07b87154c9a95.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 7.3-rc7+
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds
	 <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel
	 <linux-kernel@vger.kernel.org>
Date: Sun, 18 Oct 2026 10:38:55 -0400
Autocrypt: addr=James.Bottomley@HansenPartnership.com;
 keydata=mQENBE58FlABCADPM714lRLxGmba4JFjkocqpj1/6/Cx+IXezcS22azZetzCXDpm2MfNE
 lecY3qkFjfnoffQiw5rrOO0/oRSATOh8+2fmJ6el7naRbDuh+i8lVESfdlkoqX57H5R8h/UTIp6gn
 1mpNlxjQv6QSZbl551zQ1nmkSVRbA5TbEp4br5GZeJ58esmYDCBwxuFTsSsdzbOBNthLcudWpJZHU
 RfMc0ew24By1nldL9F37AktNcCipKpC2U0NtGlJjYPNSVXrCd1izxKmO7te7BLP+7B4DNj1VRnaf8
 X9+VIApCi/l4Kdx+ZR3aLTqSuNsIMmXUJ3T8JRl+ag7kby/KBp+0OpotABEBAAG0N0phbWVzIEJvd
 HRvbWxleSA8SmFtZXMuQm90dG9tbGV5QEhhbnNlblBhcnRuZXJzaGlwLmNvbT6JAVgEEwEIAEICGw
 MGCwkIBwMCBhUIAgkKCwQWAgMBAh4BAheAAhkBFiEE1WBuc8i0YnG+rZrfgUrkfCFIVNYFAml2ZBI
 FCS3GUMIACgkQgUrkfCFIVNZKjQf/deRzlXZClKxTC/Ee2yEPqqS7mm/INUA49KdQQ5oIhSxkUBy0
 9J4qjMIo5F8ZFkFTqikBqeL35LKu7O7rn8WETfX8Bxvos3HUsl3jHo34DES4MUFIpoQPgtiLRGwLb
 K0cVCAArR2u2qj4ABmTRrs1I1kvdjEw6gatOuXtEe/j5O2fvfzTq9GBr0Q3n2IAsFXi4hLlx6VPE8
 tyWUZ8BWJKtih3JAeUiXFvASL3McV0rV9RnU0VbjEQEhSE7PMYhWpnDC9AyBb0lXJllQRvC3NSkUB
 8KVQgNNxRPss0WE/nBoZ4dFA42jTyzTz8lNylxZoAWV7WJb3QxVg4oCodRVrxxrQhSmFtZXMgQm90
 dG9tbGV5IDxqZWpiQGtlcm5lbC5vcmc+iQFVBBMBCAA/AhsDBgsJCAcDAgYVCAIJCgsEFgIDAQIeA
 QIXgBYhBNVgbnPItGJxvq2a34FK5HwhSFTWBQJgS5mYBQkbNYS9AAoJEIFK5HwhSFTWBpwIAL5Bk3
 5FB34U6iHmDzzgdCbxLTs43T/YQyJpcGIvopBvnI/fDY8oSG6Df64/O6B+1R+A8TDp6ZG5ysUWnCC
 6GuIaEHemBYkitMPglR6+sGCMQY7O0mlsPvdssvKK1KI9Bno4VU6ogaF2qVzefSqg1Djmf/DcsxWP
 rI/jdJ8FB5AYR2rjIdDFc+zRdAJuavo1/anyY2wgpFh/3R8IOYAEfWV9nGgYkf9+tA4EIn1sxE0I3
 L5oW2N3mbyRrkzuBwO8ztMCwqEPk7moWzhokcZqMXiAIahaZdkashJC+s2X2RZSGCy+g+pvY5NN4B
 BVG5XwLgVBqbHMTcxE0fbmPqz+q6O0LEphbWVzIEJvdHRvbWxleSA8amVqYkBoYW5zZW5wYXJ0bmV
 yc2hpcC5jb20+iQFXBBMBCABBFiEE1WBuc8i0YnG+rZrfgUrkfCFIVNYFAmODZ5ACGwMFCRs1hL0F
 CwkIBwICIgIGFQoJCAsCBBYCAwECHgcCF4AACgkQgUrkfCFIVNZu0Af/TzvL2/NdgAcw9uN3x60H8
 jc4QUq14VpxcFEFEMpcj1morkX/G93V+56HBBaXZj+yK8PhxIA/SIz+sU7C/0YvKuvzakP8ZX/7WJ
 e32SOUtjfr/VTaqjIBzNj6OxLvZpmNbBw7s6DwhhNpHOWqJ/1ml+PtDRDV71IB58yVqQjp1xlNKVl
 ZppcJ5908EJzsFnRIVjiQiDSKoppqB2BCibBbrWcln7CiWMyOC/cco6SIn6twH+f7+aivJ3xGcOE2
 a9gBKF5rNi9TBoX9oyPmshv/TDmnohsVrH7AYXlGYfZTk15SWEiROh1QX8/uD9wl/gcIv5EDUpT/F
 L2jzOsA5663bw==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

The following changes since commit 469fa055664bfd8717b087a80d59c03055789c17=
:

  scsi: ufs: core: Decouple CQ sweep from request iterator in MCQ (2026-10-=
05 22:05:13 -0400)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git/ tags/scsi-=
fixes

for you to fetch changes up to ec6b083915e8146e147314a5f4f1285d07b57bfc:

  scsi: bsg: Pass reply_len to bsg_setup_queue() to fit UFS ARPMB replies (=
2026-10-14 22:14:52 -0400)

----------------------------------------------------------------
All fixes in drivers (or the tape ULD) and one core fix to bsg (the
block ioctl equivalent of sg_io).  The biggest is the race in auth
updates fix in iscsi configfs, but the next biggest one is in bsg but
the generic pieces of that are mostly threading reply_len.

----------------------------------------------------------------
Laurence Oberman (2):
      scsi: st: Save the visited block for the partition the drive is in
      scsi: st: Fix use-after-free race between st_remove() and st_open()

Linfeng Sun (1):
      scsi: target: iscsi: Fix race in discovery auth updates

Stanley Jhu (1):
      scsi: bsg: Pass reply_len to bsg_setup_queue() to fit UFS ARPMB repli=
es

Xingui Yang (1):
      scsi: libsas: Fix SMP IO deadlock during HA resume

Yehyeong Lee (4):
      scsi: xen/scsifront: Check for a NULL shadow entry on a backend respo=
nse
      scsi: libiscsi: Reject a negative task index from parse_pdu_itt
      scsi: libiscsi: Validate the ITT reflected in a Reject PDU
      scsi: libiscsi: Validate the task named by a management response

Yu Zhang (1):
      scsi: target: Disable interrupts while holding delayed_cmd_lock

 block/bsg-lib.c                              | 13 ++++++++++---
 drivers/scsi/libiscsi.c                      | 14 ++++++++------
 drivers/scsi/libsas/sas_expander.c           | 14 ++++++++++++--
 drivers/scsi/mpi3mr/mpi3mr_app.c             |  2 +-
 drivers/scsi/scsi_transport_fc.c             |  6 ++++--
 drivers/scsi/scsi_transport_iscsi.c          |  2 +-
 drivers/scsi/scsi_transport_sas.c            |  6 ++++--
 drivers/scsi/st.c                            | 18 ++++++++++++------
 drivers/scsi/xen-scsifront.c                 |  1 +
 drivers/target/iscsi/iscsi_target_configfs.c | 26 +++++++++++++++++++-----=
--
 drivers/target/target_core_transport.c       |  8 ++++----
 drivers/ufs/core/ufs_bsg.c                   |  2 +-
 include/linux/bsg-lib.h                      |  3 ++-
 13 files changed, 79 insertions(+), 36 deletions(-)

---

diff --git a/block/bsg-lib.c b/block/bsg-lib.c
index 895db30a7033..536cee4430a7 100644
--- a/block/bsg-lib.c
+++ b/block/bsg-lib.c
@@ -23,11 +23,14 @@ struct bsg_set {
 	struct bsg_device	*bd;
 	bsg_job_fn		*job_fn;
 	bsg_timeout_fn		*timeout_fn;
+	unsigned int		reply_len;
 };
=20
 static int bsg_transport_sg_io_fn(struct request_queue *q, struct sg_io_v4=
 *hdr,
 		bool open_for_write, unsigned int timeout)
 {
+	struct bsg_set *bset =3D
+		container_of(q->tag_set, struct bsg_set, tag_set);
 	struct bsg_job *job;
 	struct request *rq;
 	struct bio *bio;
@@ -50,7 +53,7 @@ static int bsg_transport_sg_io_fn(struct request_queue *q=
, struct sg_io_v4 *hdr,
 	reply =3D job->reply;
 	memset(job, 0, sizeof(*job));
 	job->reply =3D reply;
-	job->reply_len =3D SCSI_SENSE_BUFFERSIZE;
+	job->reply_len =3D bset->reply_len;
 	job->dd_data =3D job + 1;
=20
 	job->request_len =3D hdr->request_len;
@@ -301,9 +304,10 @@ static blk_status_t bsg_queue_rq(struct blk_mq_hw_ctx =
*hctx,
 static int bsg_init_rq(struct blk_mq_tag_set *set, struct request *req,
 		       unsigned int hctx_idx, int numa_node)
 {
+	struct bsg_set *bset =3D container_of(set, struct bsg_set, tag_set);
 	struct bsg_job *job =3D blk_mq_rq_to_pdu(req);
=20
-	job->reply =3D kzalloc(SCSI_SENSE_BUFFERSIZE, GFP_KERNEL);
+	job->reply =3D kzalloc(bset->reply_len, GFP_KERNEL);
 	if (!job->reply)
 		return -ENOMEM;
 	return 0;
@@ -358,10 +362,12 @@ static const struct blk_mq_ops bsg_mq_ops =3D {
  * @job_fn: bsg job handler
  * @timeout: timeout handler function pointer
  * @dd_job_size: size of LLD data needed for each job
+ * @reply_len: size of the reply buffer needed for each job
  */
 struct request_queue *bsg_setup_queue(struct device *dev, const char *name=
,
 		struct queue_limits *lim, bsg_job_fn *job_fn,
-		bsg_timeout_fn *timeout, int dd_job_size)
+		bsg_timeout_fn *timeout, int dd_job_size,
+		unsigned int reply_len)
 {
 	struct bsg_set *bset;
 	struct blk_mq_tag_set *set;
@@ -374,6 +380,7 @@ struct request_queue *bsg_setup_queue(struct device *de=
v, const char *name,
=20
 	bset->job_fn =3D job_fn;
 	bset->timeout_fn =3D timeout;
+	bset->reply_len =3D reply_len;
=20
 	set =3D &bset->tag_set;
 	set->ops =3D &bsg_mq_ops;
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 5cbc51899de0..5bfdb30b9088 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1142,13 +1142,15 @@ static int iscsi_handle_reject(struct iscsi_conn *c=
onn, struct iscsi_hdr *hdr,
 			spin_unlock(&conn->session->frwd_lock);
 			spin_lock(&conn->session->back_lock);
 		} else {
-			struct iscsi_task *task;
+			struct iscsi_task *task =3D NULL;
 			/*
 			 * Our nop as ping got dropped. We know the target
 			 * and transport are ok so just clean up
 			 */
-			task =3D iscsi_itt_to_task(conn, rejected_pdu.itt);
-			if (!task) {
+			if (!iscsi_verify_itt(conn, rejected_pdu.itt))
+				task =3D iscsi_itt_to_task(conn, rejected_pdu.itt);
+			if (!task || task->state =3D=3D ISCSI_TASK_FREE ||
+			    task->sc) {
 				iscsi_conn_printk(KERN_ERR, conn,
 						 "Invalid pdu reject. Could "
 						 "not lookup rejected task.\n");
@@ -1191,7 +1193,7 @@ struct iscsi_task *iscsi_itt_to_task(struct iscsi_con=
n *conn, itt_t itt)
 		session->tt->parse_pdu_itt(conn, itt, &i, NULL);
 	else
 		i =3D get_itt(itt);
-	if (i >=3D session->cmds_max)
+	if (i < 0 || i >=3D session->cmds_max)
 		return NULL;
=20
 	return session->cmds[i];
@@ -1284,7 +1286,7 @@ int __iscsi_complete_pdu(struct iscsi_conn *conn, str=
uct iscsi_hdr *hdr,
 	case ISCSI_OP_SCSI_TMFUNC_RSP:
 	case ISCSI_OP_NOOP_IN:
 		task =3D iscsi_itt_to_task(conn, hdr->itt);
-		if (!task)
+		if (!task || task->state =3D=3D ISCSI_TASK_FREE || task->sc)
 			return ISCSI_ERR_BAD_ITT;
 		break;
 	default:
@@ -1384,7 +1386,7 @@ int iscsi_verify_itt(struct iscsi_conn *conn, itt_t i=
tt)
 		return ISCSI_ERR_BAD_ITT;
 	}
=20
-	if (i >=3D session->cmds_max) {
+	if (i < 0 || i >=3D session->cmds_max) {
 		iscsi_conn_printk(KERN_ERR, conn,
 				  "received invalid itt index %u (max cmds "
 				   "%u.\n", i, session->cmds_max);
diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_e=
xpander.c
index 811c9eb4fef1..26c2099c28b9 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -62,7 +62,11 @@ static int smp_execute_task_sg(struct domain_device *dev=
,
 		to_sas_internal(dev->port->ha->shost->transportt);
 	struct sas_ha_struct *ha =3D dev->port->ha;
=20
-	pm_runtime_get_sync(ha->dev);
+	/*
+	 * Non-blocking: a sync resume here would deadlock against
+	 * sas_drain_work() during HA resume.
+	 */
+	pm_runtime_get_noresume(ha->dev);
 	mutex_lock(&dev->ex_dev.cmd_mutex);
 	for (retry =3D 0; retry < 3; retry++) {
 		if (test_bit(SAS_DEV_GONE, &dev->state)) {
@@ -135,7 +139,7 @@ static int smp_execute_task_sg(struct domain_device *de=
v,
 		}
 	}
 	mutex_unlock(&dev->ex_dev.cmd_mutex);
-	pm_runtime_put_sync(ha->dev);
+	pm_runtime_put(ha->dev);
=20
 	BUG_ON(retry =3D=3D 3 && task !=3D NULL);
 	sas_free_task(task);
@@ -2222,6 +2226,11 @@ void sas_smp_handler(struct bsg_job *job, struct Scs=
i_Host *shost,
 		goto out;
 	}
=20
+	/* The host may have autosuspended, resume it here. */
+	ret =3D pm_runtime_resume_and_get(dev->port->ha->dev);
+	if (ret)
+		goto out;
+
 	ret =3D smp_execute_task_sg(dev, job->request_payload.sg_list,
 			job->reply_payload.sg_list);
 	if (ret >=3D 0) {
@@ -2229,6 +2238,7 @@ void sas_smp_handler(struct bsg_job *job, struct Scsi=
_Host *shost,
 		rcvlen =3D job->reply_payload.payload_len - ret;
 		ret =3D 0;
 	}
+	pm_runtime_put(dev->port->ha->dev);
=20
 out:
 	bsg_job_done(job, ret, rcvlen);
diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_=
app.c
index 1353a8ff9c85..094490713d69 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -3053,7 +3053,7 @@ void mpi3mr_bsg_init(struct mpi3mr_ioc *mrioc)
 	}
=20
 	q =3D bsg_setup_queue(bsg_dev, dev_name(bsg_dev), &lim,
-			mpi3mr_bsg_request, NULL, 0);
+			mpi3mr_bsg_request, NULL, 0, SCSI_SENSE_BUFFERSIZE);
 	if (IS_ERR(q)) {
 		ioc_err(mrioc, "%s: bsg registration failed\n",
 		    dev_name(bsg_dev));
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport=
_fc.c
index 173ed6373f04..b66365a382c7 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -4345,7 +4345,8 @@ fc_bsg_hostadd(struct Scsi_Host *shost, struct fc_hos=
t_attrs *fc_host)
 	scsi_init_limits(shost, &lim);
 	lim.max_segments =3D min_not_zero(lim.max_segments, i->f->max_bsg_segment=
s);
 	q =3D bsg_setup_queue(dev, bsg_name, &lim, fc_bsg_dispatch,
-			fc_bsg_job_timeout, i->f->dd_bsg_size);
+			fc_bsg_job_timeout, i->f->dd_bsg_size,
+			SCSI_SENSE_BUFFERSIZE);
 	if (IS_ERR(q)) {
 		dev_err(dev,
 			"fc_host%d: bsg interface failed to initialize - setup queue\n",
@@ -4378,7 +4379,8 @@ fc_bsg_rportadd(struct Scsi_Host *shost, struct fc_rp=
ort *rport)
 	scsi_init_limits(shost, &lim);
 	lim.max_segments =3D min_not_zero(lim.max_segments, i->f->max_bsg_segment=
s);
 	q =3D bsg_setup_queue(dev, dev_name(dev), &lim, fc_bsg_dispatch_prep,
-				fc_bsg_job_timeout, i->f->dd_bsg_size);
+				fc_bsg_job_timeout, i->f->dd_bsg_size,
+				SCSI_SENSE_BUFFERSIZE);
 	if (IS_ERR(q)) {
 		dev_err(dev, "failed to setup bsg queue\n");
 		return PTR_ERR(q);
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transp=
ort_iscsi.c
index 8aa76f813bcd..b50ff8a1d0a9 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -1545,7 +1545,7 @@ iscsi_bsg_host_add(struct Scsi_Host *shost, struct is=
csi_cls_host *ihost)
 	snprintf(bsg_name, sizeof(bsg_name), "iscsi_host%d", shost->host_no);
 	scsi_init_limits(shost, &lim);
 	q =3D bsg_setup_queue(dev, bsg_name, &lim, iscsi_bsg_host_dispatch, NULL,
-			0);
+			0, SCSI_SENSE_BUFFERSIZE);
 	if (IS_ERR(q)) {
 		shost_printk(KERN_ERR, shost, "bsg interface failed to "
 			     "initialize - no request queue\n");
diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transpor=
t_sas.c
index d689b9ed08a6..a825966f60e5 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -199,7 +199,8 @@ static int sas_bsg_initialize(struct Scsi_Host *shost, =
struct sas_rphy *rphy)
=20
 	if (rphy) {
 		q =3D bsg_setup_queue(&rphy->dev, dev_name(&rphy->dev), NULL,
-				sas_smp_dispatch, NULL, 0);
+				sas_smp_dispatch, NULL, 0,
+				SCSI_SENSE_BUFFERSIZE);
 		if (IS_ERR(q))
 			return PTR_ERR(q);
 		rphy->q =3D q;
@@ -208,7 +209,8 @@ static int sas_bsg_initialize(struct Scsi_Host *shost, =
struct sas_rphy *rphy)
=20
 		snprintf(name, sizeof(name), "sas_host%d", shost->host_no);
 		q =3D bsg_setup_queue(&shost->shost_gendev, name, NULL,
-				sas_smp_dispatch, NULL, 0);
+				sas_smp_dispatch, NULL, 0,
+				SCSI_SENSE_BUFFERSIZE);
 		if (IS_ERR(q))
 			return PTR_ERR(q);
 		to_sas_host_attrs(shost)->q =3D q;
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index f1c3c4946637..a757646c8dc6 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -3217,14 +3217,20 @@ static int set_location(struct scsi_tape *STp, unsi=
gned int block, int partition
 	    partition >=3D ST_NBR_PARTITIONS)
 		return (-EINVAL);
 	if (partition !=3D STp->partition) {
-		if (get_location(STp, &blk, &p, 1))
+		/*
+		 * Save the location for the partition the drive reports,
+		 * not for STp->partition: after a reset STp->partition may
+		 * not match the partition the drive is in.
+		 */
+		if (get_location(STp, &blk, &p, 1) ||
+		    p < 0 || p >=3D ST_NBR_PARTITIONS)
 			STps->last_block_valid =3D 0;
 		else {
-			STps->last_block_valid =3D 1;
-			STps->last_block_visited =3D blk;
+			STp->ps[p].last_block_valid =3D 1;
+			STp->ps[p].last_block_visited =3D blk;
 			DEBC_printk(STp, "Visited block %d for "
 				    "partition %d saved.\n",
-				    blk, STp->partition);
+				    blk, p);
 		}
 	}
=20
@@ -4509,11 +4515,11 @@ static void st_remove(struct scsi_device *SDp)
 	remove_cdevs(tpnt);
=20
 	mutex_lock(&st_ref_mutex);
-	kref_put(&tpnt->kref, scsi_tape_release);
-	mutex_unlock(&st_ref_mutex);
 	spin_lock(&st_index_lock);
 	idr_remove(&st_index_idr, index);
 	spin_unlock(&st_index_lock);
+	kref_put(&tpnt->kref, scsi_tape_release);
+	mutex_unlock(&st_ref_mutex);
 }
=20
 /**
diff --git a/drivers/scsi/xen-scsifront.c b/drivers/scsi/xen-scsifront.c
index 989bcaee42ca..aa44a233eac8 100644
--- a/drivers/scsi/xen-scsifront.c
+++ b/drivers/scsi/xen-scsifront.c
@@ -367,6 +367,7 @@ static void scsifront_do_response(struct vscsifrnt_info=
 *info,
 	struct vscsifrnt_shadow *shadow;
=20
 	if (ring_rsp->rqid >=3D VSCSIIF_MAX_REQS ||
+	    !info->shadow[ring_rsp->rqid] ||
 	    !info->shadow[ring_rsp->rqid]->inflight) {
 		scsifront_set_error(info, "illegal rqid returned by backend!");
 		return;
diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/=
iscsi/iscsi_target_configfs.c
index 704ec94383c3..e1aa0af52c65 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -1306,17 +1306,24 @@ static ssize_t iscsi_disc_enforce_discovery_auth_st=
ore(struct config_item *item,
 		return -EINVAL;
 	}
=20
+	if (iscsit_get_tpg(discovery_tpg) < 0)
+		return -EINVAL;
+
 	param =3D iscsi_find_param_from_key(AUTHMETHOD,
 				discovery_tpg->param_list);
-	if (!param)
-		return -EINVAL;
+	if (!param) {
+		err =3D -EINVAL;
+		goto out;
+	}
=20
 	if (op) {
 		/*
 		 * Reset the AuthMethod key to CHAP.
 		 */
-		if (iscsi_update_param_value(param, CHAP) < 0)
-			return -EINVAL;
+		if (iscsi_update_param_value(param, CHAP) < 0) {
+			err =3D -EINVAL;
+			goto out;
+		}
=20
 		discovery_tpg->tpg_attrib.authentication =3D 1;
 		iscsit_global->discovery_acl.node_auth.enforce_discovery_auth =3D 1;
@@ -1327,8 +1334,10 @@ static ssize_t iscsi_disc_enforce_discovery_auth_sto=
re(struct config_item *item,
 		/*
 		 * Reset the AuthMethod key to CHAP,None
 		 */
-		if (iscsi_update_param_value(param, "CHAP,None") < 0)
-			return -EINVAL;
+		if (iscsi_update_param_value(param, "CHAP,None") < 0) {
+			err =3D -EINVAL;
+			goto out;
+		}
=20
 		discovery_tpg->tpg_attrib.authentication =3D 0;
 		iscsit_global->discovery_acl.node_auth.enforce_discovery_auth =3D 0;
@@ -1337,7 +1346,10 @@ static ssize_t iscsi_disc_enforce_discovery_auth_sto=
re(struct config_item *item,
 			" Discovery TPG\n");
 	}
=20
-	return count;
+	err =3D count;
+out:
+	iscsit_put_tpg(discovery_tpg);
+	return err;
 }
=20
 CONFIGFS_ATTR(iscsi_disc_, enforce_discovery_auth);
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target=
_core_transport.c
index dcfe94594916..67c046549192 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2359,7 +2359,7 @@ void target_do_delayed_work(struct work_struct *work)
 	struct se_device *dev =3D container_of(work, struct se_device,
 					     delayed_cmd_work);
=20
-	spin_lock(&dev->delayed_cmd_lock);
+	spin_lock_irq(&dev->delayed_cmd_lock);
 	while (!dev->ordered_sync_in_progress) {
 		struct se_cmd *cmd;
=20
@@ -2380,12 +2380,12 @@ void target_do_delayed_work(struct work_struct *wor=
k)
 		dev->ordered_sync_in_progress =3D true;
=20
 		list_del(&cmd->se_delayed_node);
-		spin_unlock(&dev->delayed_cmd_lock);
+		spin_unlock_irq(&dev->delayed_cmd_lock);
=20
 		__target_execute_cmd(cmd, true);
-		spin_lock(&dev->delayed_cmd_lock);
+		spin_lock_irq(&dev->delayed_cmd_lock);
 	}
-	spin_unlock(&dev->delayed_cmd_lock);
+	spin_unlock_irq(&dev->delayed_cmd_lock);
 }
=20
 static void transport_complete_ordered_sync(struct se_cmd *cmd)
diff --git a/drivers/ufs/core/ufs_bsg.c b/drivers/ufs/core/ufs_bsg.c
index 7a66917b3fc0..156637dd76c8 100644
--- a/drivers/ufs/core/ufs_bsg.c
+++ b/drivers/ufs/core/ufs_bsg.c
@@ -258,7 +258,7 @@ int ufs_bsg_probe(struct ufs_hba *hba)
 		goto out;
=20
 	q =3D bsg_setup_queue(bsg_dev, dev_name(bsg_dev), NULL, ufs_bsg_request,
-			NULL, 0);
+			NULL, 0, sizeof(struct ufs_rpmb_reply));
 	if (IS_ERR(q)) {
 		ret =3D PTR_ERR(q);
 		device_del(bsg_dev);
diff --git a/include/linux/bsg-lib.h b/include/linux/bsg-lib.h
index 14fa93268630..a697246feeac 100644
--- a/include/linux/bsg-lib.h
+++ b/include/linux/bsg-lib.h
@@ -66,7 +66,8 @@ void bsg_job_done(struct bsg_job *job, int result,
 		  unsigned int reply_payload_rcv_len);
 struct request_queue *bsg_setup_queue(struct device *dev, const char *name=
,
 		struct queue_limits *lim, bsg_job_fn *job_fn,
-		bsg_timeout_fn *timeout, int dd_job_size);
+		bsg_timeout_fn *timeout, int dd_job_size,
+		unsigned int reply_len);
 void bsg_remove_queue(struct request_queue *q);
 void bsg_job_put(struct bsg_job *job);
 int __must_check bsg_job_get(struct bsg_job *job);

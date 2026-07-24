Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E06035028D
	for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2026 18:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784917249; cv=none; b=HfxXLAswcglHlDvVLXHnxTn+381F2BUvahrlMbDAcksv+23ecuKxnhFdiQxMcI6DLvzLrPLuZJTkuXszBDBqYNhHyNjwD7KmH/kk3fKrfiBh+XjVegmgGmpL32W8iWKkCS9KMVdkYZ4Ekw8kvqcxWLdgRj3gzoZS7MPAAsNwI6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784917249; c=relaxed/simple;
	bh=YVJ9RSmrfm07qFl7RDQ/ER+9uFiwQaItAcvyT/UGuwA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ngVFEIZR2ibkvGEKkbwEY8Yes75TSgrOCce0kRUBuHwMcUmt59p/Yx1le5aUjez/oHphGiREvVts2glMEpZ3QqqVpyFWjT3bLvVAWWh/UHNDqaH2PKBYcyrgEfoJ97BaJy2EOycr/RRkUH5v1r9mwOZxKI4IgilTP2fU1xJfFek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e+/X6Qsn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e+/X6Qsn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C5771F000E9;
	Fri, 24 Jul 2026 18:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784917248;
	bh=gTiJE+a/IkFHNjJxHAdla4pKrp0H2NY21ruRCs768TQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=e+/X6Qsnlk8TT84tb58qNIqIZCAPheUzxVbb3mGOozUVV3PnRXPA+Cl69OooW5Nhj
	 goSnswOmZewMMIYW1+58GngZWCS9aTj/s3vtFG0NAFkD5GqoYRLmwG50m9ZGH5Lc5Q
	 EVvwoLH1xvs/+21CSVQ8BGkOgfKjyJ6AO54/ysY3rgp7RdGMQumh5pgWtwaOWEcPoI
	 gRq3s1okDNzvZcJ39dh5N9IzYM0E8QYEkbW59ygN360fQz8s+1K8S5dgFavzlJZEw1
	 +CwN8yl2Dotywea2Ri8VqNrCCwg0Av4PohpihAT3ba+x+JBFeZNSUJrb9fzuJYjObl
	 MXBqi5yAhp3kQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 06/13] scsi: fnic: Add the NVMe/FC transport path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Karan Tilak Kumar" <kartilak@cisco.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260724174811.5118-7-kartilak@cisco.com>
References: <20260724174811.5118-1-kartilak@cisco.com>
 <20260724174811.5118-7-kartilak@cisco.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 24 Jul 2026 18:20:47 +0000
Message-Id: <20260724182048.0C5771F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 11 potential issue=
(s) to consider:

New issues:
- [High] The NVMe FC transport template `nvfnic_port` omits the mandatory `=
.ls_req` callback, causing `nvme_fc_register_localport()` to unconditionall=
y fail and preventing NVMe initialization.
- [High] NVMe I/O completion and ITMF handlers are completely disconnected =
from the CQ polling loop, causing all NVMe I/Os to hang indefinitely.
- [High] The `ls_req_timer` in `struct nvfnic_ls_req` is armed without ever=
 being initialized.
- [High] Concurrent execution of `nvfnic_delete_tport` results in stack cor=
ruption, double free, and use-after-free of the `tport` structure.
- [High] A TOCTOU race between abort WQ enqueue and fast completions causes=
 IO requests to permanently hang.
- [High] `tport->ls_req_list` is not initialized with `INIT_LIST_HEAD()`, c=
ausing a kernel panic when iterated.
- [High] `ls_req` is left on `tport->ls_req_list` during abort, leading to =
Use-After-Free and list corruption when `tport` is freed.
- [High] Timeout during local port unregistration leads to a use-after-free=
 of the `nv_tmpl` and `fnic` structures.
- [Medium] `fnic_queue_wq_copy_desc_itmf` leaks uninitialized descriptor me=
mory to firmware when `lun` is NULL.

Pre-existing issues:
- [High] Dropping a spinlock inside a `list_for_each_entry_safe` loop inval=
idates the safe iteration, leading to list corruption and kernel panic.
- [High] The driver incorrectly uses a shared struct member (`fnic->lock_fl=
ags`) for saving CPU-local IRQ state during `spin_lock_irqsave`.
--

--- Patch [6]: [PATCH v6 06/13] scsi: fnic: Add the NVMe/FC transport path =
---
commit 320b83a04180e41753d3bc332a151c194da1ab86
Author: Karan Tilak Kumar <kartilak@cisco.com>
Subject: scsi: fnic: Add the NVMe/FC transport path

This commit introduces the NVMe over FC transport path for the fnic driver.
It adds logic for local-port and remote-port registration, I/O submission,
tag management, completion handling, and cleanup operations.

Closes: https://lore.kernel.org/oe-kbuild-all/202605280430.wTYAqI3A-lkp@int=
el.com/
Closes: https://lore.kernel.org/oe-kbuild-all/202605280619.pmobiDWp-lkp@int=
el.com/
Closes: https://lore.kernel.org/oe-kbuild-all/202605280519.Jd4fmgAZ-lkp@int=
el.com/

> diff --git a/drivers/scsi/fnic/fnic_fcs.c b/drivers/scsi/fnic/fnic_fcs.c
> --- a/drivers/scsi/fnic/fnic_fcs.c
> +++ b/drivers/scsi/fnic/fnic_fcs.c
[ ... ]
> @@ -1020,6 +1019,8 @@ void fnic_delete_fcp_tports(struct fnic *fnic)
>  		fnic_del_tport_timer_sync(fnic, tport);
>  		if (IS_FNIC_FCP_INITIATOR(fnic))
>  			fnic_fdls_remove_tport(&fnic->iport, tport, flags);
> +		else if (IS_FNIC_NVME_INITIATOR(fnic))
> +			nvfnic_delete_tport(&fnic->iport, tport, flags);

[Severity: High]
This is a pre-existing issue, but does dropping the spinlock inside the
list_for_each_entry_safe() loop corrupt the list?

In fnic_delete_fcp_tports(), the loop holds fnic_lock and calls
nvfnic_delete_tport(), which explicitly drops fnic_lock. If a concurrent
task frees the cached next pointer while the lock is dropped, the loop will
dereference freed memory when it resumes.

[ ... ]
> diff --git a/drivers/scsi/fnic/fnic_nvme.c b/drivers/scsi/fnic/fnic_nvme.c
> new file mode 100644
> --- /dev/null
> +++ b/drivers/scsi/fnic/fnic_nvme.c
[ ... ]
> +void nvfnic_fcpio_nvme_fast_cmpl_handler(struct fnic *fnic,
> +				       struct fcpio_fw_req *desc)
> +{
[ ... ]
> +	if (io_req->cmd_state =3D=3D FNIC_IOREQ_ABTS_PENDING) {
> +		/*
> +		 * set the FNIC_IO_DONE so that this doesn't get
> +		 * flagged as 'out of order' if it was not aborted
> +		 */
> +		io_req->cmd_flags |=3D FNIC_IO_DONE;
> +		io_req->cmd_flags |=3D FNIC_IO_ABTS_PENDING;

[Severity: High]
Will this sequence cause an I/O request to hang permanently?

In nvfnic_fcpio_nvme_fast_cmpl_handler(), if the IO state is
FNIC_IOREQ_ABTS_PENDING, the completion is discarded. If nvfnic_fcpio_abort=
()
then fails to enqueue the abort (for example, if the WQ is full), it restor=
es
the state back to FNIC_IOREQ_CMD_PENDING and returns. Since the hardware
completion was already dropped, the I/O would remain pending forever.

[ ... ]
> +void nvfnic_local_port_delete(struct nvme_fc_local_port *lport)
> +{
> +	struct fnic_iport_s *iport =3D (struct fnic_iport_s *) lport->private;
> +	struct fnic *fnic =3D iport->fnic;
> +	unsigned long flags =3D 0;
> +
> +	FNIC_NVME_DBG(KERN_INFO, fnic, "lport delete 0x%x\n",
> +		      iport->fcid);
> +
> +	spin_lock_irqsave(&fnic->fnic_lock, flags);

[Severity: High]
Could a timeout during unload lead to a use-after-free here?

If the wait_for_completion_timeout() in nvfnic_nvme_unload() expires, the
driver frees iport->nv_tmpl and eventually the fnic structure. However, if
the NVMe midlayer later invokes the localport_delete callback
(nvfnic_local_port_delete()), it will dereference the freed iport and fnic
memory and attempt to acquire the freed fnic_lock.

[ ... ]
> +void
> +nvfnic_cleanup_tport_io(struct fnic *fnic, struct fnic_tport_s *tport)
> +{
> +	unsigned long flags;
> +	struct nvfnic_ls_req *nvfnic_ls_req, *next;
> +	struct nvmefc_ls_req *lsreq;
> +	uint16_t oxid;
> +	LIST_HEAD(done_reqs);
> +
> +	spin_lock_irqsave(&fnic->fnic_lock, flags);
> +	list_for_each_entry_safe(nvfnic_ls_req, next,
> +				 &(tport->ls_req_list), list) {
> +		lsreq =3D nvfnic_ls_req->ls_req;
> +		if (!lsreq || (lsreq->private =3D=3D NULL)) {
> +			FNIC_NVME_DBG(KERN_INFO, fnic,
> +				"fnic_cleanup_tport_io lsreq NULL\n");
> +			continue;
> +		}
> +		if (nvfnic_ls_req->state =3D=3D FNIC_LS_REQ_CMD_ABTS_STARTED) {
> +			FNIC_NVME_DBG(KERN_INFO, fnic,
> +				"fnic_cleanup_tport_io lsreq abort started\n");
> +			continue;
> +		}

[Severity: High]
Does skipping list_del_init() for aborting requests lead to a use-after-free
of the tport?

If the request state is FNIC_LS_REQ_CMD_ABTS_STARTED, the continue statement
skips removing the request from tport->ls_req_list. Once the tport is freed,
the subsequent abort completion or timeout callback will call list_del() on
nvfnic_ls_req->list, corrupting the freed tport memory.

[ ... ]
> +void
> +nvfnic_terminate_tport_ls_reqs(struct fnic *fnic, struct fnic_tport_s *t=
port)
> +{
> +	struct nvmefc_ls_req *lsreq;
> +	struct nvfnic_ls_req *nvfnic_ls_req, *next;
> +	int count =3D 0;
> +	uint16_t oxid;
> +	LIST_HEAD(done_reqs);
> +
> +	spin_lock_irqsave(&fnic->fnic_lock, fnic->lock_flags);

[Severity: High]
This is a pre-existing issue, but does using the shared fnic->lock_flags
corrupt CPU-local IRQ state?

Calling spin_lock_irqsave(&fnic->fnic_lock, fnic->lock_flags) overwrites the
shared structure member. If multiple CPUs contend for this lock, they will
overwrite each other's saved IRQ states, leading to an incorrect state
restoration upon unlock.

> +	list_for_each_entry_safe(nvfnic_ls_req, next,
> +		&(tport->ls_req_list), list) {

[Severity: High]
Will iterating this list trigger a kernel panic?

The tport structure is allocated with kzalloc(), but tport->ls_req_list is
never initialized with INIT_LIST_HEAD(). When list_for_each_entry_safe()
executes, it will dereference a NULL next pointer.

[ ... ]
> +struct
> +nvme_fc_port_template nvfnic_port =3D {
> +	.localport_delete =3D nvfnic_local_port_delete,
> +	.remoteport_delete =3D nvfnic_remote_port_delete,
> +	.create_queue =3D nvfnic_create_queue,
> +	.delete_queue =3D NULL,
> +	.ls_req =3D NULL,

[Severity: High]
Does the omitted ls_req callback cause the local port registration to always
fail?

The nvfnic_port template explicitly sets .ls_req to NULL. When
nvfnic_add_lport() calls nvme_fc_register_localport(), the NVMe transport
validates the presence of the ls_req callback and will unconditionally retu=
rn
-EINVAL if it is missing. This prevents NVMe initialization entirely.

[ ... ]
> +void nvfnic_nvme_unload(struct fnic *fnic)
> +{
> +	int ret =3D 0;
> +	struct fnic_iport_s *iport =3D &fnic->iport;
> +	unsigned long flags;
> +	unsigned int time_wait =3D  FNIC_NVME_LPORT_REMOVE_WAIT;
> +	unsigned int time_remain;
> +	DECLARE_COMPLETION_ONSTACK(nvme_lport_unreg_done);
[ ... ]
> +			time_remain =3D wait_for_completion_timeout(
> +				fnic->nvme_lport_unreg_done,
> +				msecs_to_jiffies(time_wait));
> +			if (!time_remain) {
> +				FNIC_NVME_DBG(KERN_ERR, fnic,
> +					      "Local port removal timed out\n");
> +				WARN_ON(1);
> +			}
> +			iport->flags &=3D ~FNIC_LPORT_NVME_REGISTERED;
> +			kfree(iport->nv_tmpl);

[Severity: High]
Could a timeout here lead to a use-after-free?

If the wait_for_completion_timeout() in nvfnic_nvme_unload() expires, the
driver frees iport->nv_tmpl and eventually the fnic structure. However, if
the NVMe midlayer later invokes the localport_delete callback
(nvfnic_local_port_delete()), it will dereference the freed iport and fnic
memory and attempt to acquire the freed fnic_lock.

[ ... ]
> +void nvfnic_ls_req_abort(struct nvme_fc_local_port *lport,
> +		   struct nvme_fc_remote_port *rport,
> +		   struct nvmefc_ls_req *lsreq)
> +{
[ ... ]
> +	/* Mark the state and flags */
> +	nvfnic_ls_req->state =3D FNIC_LS_REQ_CMD_ABTS_PENDING;
> +	timeout =3D FNIC_LS_REQ_TMO_MSECS(lsreq->timeout);
> +	mod_timer(&nvfnic_ls_req->ls_req_timer,
> +		  round_jiffies(jiffies + msecs_to_jiffies(timeout)));

[Severity: High]
Could arming this timer trigger a kernel panic?

In nvfnic_ls_req_abort(), mod_timer() is called on
nvfnic_ls_req->ls_req_timer. However, timer_setup() is never called for this
timer during the request's lifecycle. Calling mod_timer() on an uninitializ=
ed
timer structure leads to list corruption.

[ ... ]
> +void nvfnic_delete_tport(struct fnic_iport_s *iport,
> +						struct fnic_tport_s *tport,
> +						unsigned long flags)
> +{
[ ... ]
> +	if (!(tport->flags & FNIC_FDLS_NVME_REGISTERED)) {
> +		FNIC_NVME_DBG(KERN_ERR, fnic,
> +			"0x%x: tport: 0x%x not registered. Freeing\n",
> +		    iport->fcid, tport->fcid);
> +		list_del(&tport->links);
> +		kfree(tport);
> +		return;
> +	}
> +
> +	tport->tport_del_done =3D &tm_done;

[Severity: High]
Is it possible for concurrent teardown paths to corrupt the stack and
double-free the tport?

The FNIC_FDLS_NVME_REGISTERED flag is checked but never cleared. If called
concurrently, both threads will assign their local stack address of tm_done
to tport->tport_del_done. If the second thread fails in
nvme_fc_unregister_remoteport(), it will free the tport and return, while
the first thread is still waiting on the completion using the freed tport.

> +
> +	tport->flags |=3D FNIC_FDLS_TPORT_DELETED;
> +	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
> +	ret =3D nvme_fc_unregister_remoteport(tport->nv_rport);

[Severity: High]
This is a pre-existing issue, but does dropping the spinlock here corrupt t=
he
list iteration in the caller?

In fnic_delete_fcp_tports(), a list_for_each_entry_safe() loop holds
fnic_lock and calls nvfnic_delete_tport(). By explicitly dropping fnic_lock
here, if a concurrent task frees the cached next pointer while the lock is
dropped, the loop will dereference freed memory when it resumes.

[ ... ]
> diff --git a/drivers/scsi/fnic/fnic_res.h b/drivers/scsi/fnic/fnic_res.h
> --- a/drivers/scsi/fnic/fnic_res.h
> +++ b/drivers/scsi/fnic/fnic_res.h
> @@ -126,7 +126,8 @@ static inline void fnic_queue_wq_copy_desc_itmf(struc=
t vnic_wq_copy *wq,
>  	desc->u.itmf.tm_req =3D tm_req;       /* SCSI Task Management request */
>  	desc->u.itmf.t_tag =3D tm_id;         /* tag of fcpio to be aborted */
>  	desc->u.itmf._resvd =3D 0;
> -	memcpy(desc->u.itmf.lun, lun, LUN_ADDRESS);  /* LUN address */
> +	if (lun)
> +		memcpy(desc->u.itmf.lun, lun, LUN_ADDRESS);  /* LUN address */
>  	desc->u.itmf._resvd1 =3D 0;
>  	hton24(desc->u.itmf.d_id, d_id);    /* FC vNIC only: Target D_ID */

[Severity: Medium]
Does skipping the memcpy when lun is NULL leak uninitialized memory to the
firmware?

If lun is NULL, the 8-byte lun array in the descriptor is not zeroed. Becau=
se
vnic_wq_copy_next_desc() returns memory directly from the ring buffer, this
leaks whatever residual data was previously in the descriptor.

[ ... ]
> diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
> --- a/drivers/scsi/fnic/fnic_scsi.c
> +++ b/drivers/scsi/fnic/fnic_scsi.c

[Severity: High]
Are the newly added NVMe completion handlers unreachable from the completion
queue polling loop?

When the hardware completes an NVMe I/O, fnic_fcpio_cmpl_handler() processes
the CQ entry. Because there are no switch cases for FCPIO_NVME_ERSP_HW_CMPL
or FCPIO_NVME_ERSP_FW_CMPL, they hit the default case and are discarded.
Consequently, NVMe commands are never completed back to the midlayer, causi=
ng
I/Os to hang indefinitely.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260724174811.5118=
-1-kartilak@cisco.com?part=3D6

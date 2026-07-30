Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F97947605F
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 23:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785453552; cv=none; b=MWA0911p/BvPIbPxFfTOG+BhHmL/zMxoayqbAAjJC6LMxHNPVbcMuiYLg2awWvMGupsFmAzfEwNpfLMw4GOU6YPOZlRNVA697pVUNvlsvFh9w44/iv1PWyvNCMeIsGtMATG25gU7bqMJRdkbzyAvEpwvkOq+AsL3xCblNtuUf/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785453552; c=relaxed/simple;
	bh=Gc3X/bVE1grEAxolF01w/U5nhhGlQrlgJdhBWNF0S20=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Wxx78yJ44G8SRLpngScNVC5C6wauBCYwYs5GCkXS/XqI3USch0LFt56WjzX2LygMT2otlhnoncFIAJRT9NQ75CVrF3mtr6li5jIANGwFdDXhEpYzwLvYMp32O6OSEuzraT5d2TeIlY9g426c8SY7g0KzWKbxKlRWW82BqQ/rwWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wsg670Ac; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wsg670Ac"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93A0A1F00A3A;
	Thu, 30 Jul 2026 23:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785453551;
	bh=umbr4O4ugisMbZGVpFrbrgOrPLElwVBIy5vOwu4PuhE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Wsg670AcqV4Y/MT0UdV4Obzf1kRJIqRUBmmNw8ViPDjaSfQs1FqRIm+oS/CJ9q2Pl
	 NYaZE0vSjfogTdzme+0HTecFvdNEZjsDFFqCAprVzSnV9BVTI7zyeUD+Qv1m2ZVFT0
	 Njvc7Wv7oJ/kTNiRtaJoGnDxHiSM3rzDSb4JULRQyOnw2+ueD+KvHFzvGe5FSu4ALG
	 w2rzfzkiKGPGkC0PMGmJTBfPfYGV4VtutoFNRzHJ52ZPlSqzILBqQbcRzN5bhbDHbs
	 tMNiEj6GUc0GplvgaGfQ2l3PbJ0ii050hL9VXBAc+q06SJuQ5dnJzKTILozJF5laWV
	 hhs3K7TNNXuRg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 22/57] scsi: csiostor: Enable lock context analysis
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bart Van Assche" <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <b277d54df1ff40479d78f95edbd9450f6dfefb7c.1785451174.git.bvanassche@acm.org>
References: <cover.1785451174.git.bvanassche@acm.org>
 <b277d54df1ff40479d78f95edbd9450f6dfefb7c.1785451174.git.bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 30 Jul 2026 23:19:10 +0000
Message-Id: <20260730231910.93A0A1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:

New issues:
- [Low] The lock context analysis annotations are incomplete and inconsiste=
nt, which will trigger false-positive lock warnings during compilation with=
 CONTEXT_ANALYSIS :=3D y.

Pre-existing issues:
- [Critical] I/O request structs (`ioreq`) are returned to the freelist on =
abort timeout, leading to use-after-free and data corruption if the firmwar=
e later completes the aborted I/O.
- [High] Unsafe use of list_for_each_safe over shared queues across lock dr=
ops, leading to infinite loops or use-after-free if an interrupt completes =
the 'next' I/O.
- [High] Self-deadlock in management request cleanup due to locking assumpt=
ions exposed by the newly added annotations.
- [High] Iterating over rnodes with `list_for_each_safe` while triggering s=
tate machine changes that drop the lock allows concurrent modification of t=
he rnode list, invalidating the iterator.
--

--- Patch [22]: [PATCH v3 22/57] scsi: csiostor: Enable lock context analys=
is ---
commit 46f9827cf6cee915a530068e489202f662954317
Author: Bart Van Assche <bvanassche@acm.org>

scsi: csiostor: Enable lock context analysis

This commit enables lock context analysis for the csiostor driver. It appli=
es
the __must_hold() annotation to various hardware, logical node, remote node,
and SCSI functions that require specific locks to be held by the caller.

> diff --git a/drivers/scsi/csiostor/csio_hw.c b/drivers/scsi/csiostor/csio=
_hw.c
> index df9f81f299505..4b4d3c42667fa 100644
> --- a/drivers/scsi/csiostor/csio_hw.c
> +++ b/drivers/scsi/csiostor/csio_hw.c

[ ... ]

> @@ -3883,6 +3893,7 @@ csio_free_evt(struct csio_hw *hw, struct csio_evt_m=
sg *evt_entry)
> =20
>  void
>  csio_evtq_flush(struct csio_hw *hw)
> +	__must_hold(&hw->lock)
>  {

[Severity: Low]
Does adding this annotation cause static analysis warnings for unannotated
callers? For example, csio_hws_ready() is not annotated but calls this
function, which might trigger warnings when CONTEXT_ANALYSIS :=3D y is enab=
led.

>  	uint32_t count;
>  	count =3D 30;

[ ... ]

> @@ -4142,6 +4153,7 @@ csio_mgmt_tmo_handler(struct timer_list *t)
> =20
>  static void
>  csio_mgmtm_cleanup(struct csio_mgmtm *mgmtm)
> +	__must_hold(&mgmtm->hw->lock)
>  {

[Severity: High]
This is a pre-existing issue, but could this management request cleanup
lead to a self-deadlock?

When csio_mgmtm_cleanup() iterates over mgmtm->active_q:

list_for_each(tmp, &mgmtm->active_q) {
        ...
        if (io_req->io_cbfn) {
                io_req->wr_status =3D -ETIMEDOUT;
                io_req->io_cbfn(mgmtm->hw, io_req);
        }

It invokes the completion callback with hw->lock held. If the callback is
csio_ln_fdmi_rhba_cbfn(), it unconditionally attempts to acquire hw->lock:

spin_lock_irqsave(&hw->lock, flags);
if (csio_ln_mgmt_submit_req(fdmi_req, csio_ln_fdmi_rhba_cbfn,

Will this cause the CPU to deadlock on the same lock?

>  	struct csio_hw *hw =3D mgmtm->hw;
>  	struct csio_ioreq *io_req;

[ ... ]

> diff --git a/drivers/scsi/csiostor/csio_rnode.c b/drivers/scsi/csiostor/c=
sio_rnode.c
> index 713e13adf4dcc..74ef1e858cf39 100644
> --- a/drivers/scsi/csiostor/csio_rnode.c
> +++ b/drivers/scsi/csiostor/csio_rnode.c

[ ... ]

> @@ -563,6 +564,7 @@ __csio_reg_rnode(struct csio_rnode *rn)
> =20
>  static void
>  __csio_unreg_rnode(struct csio_rnode *rn)
> +	__must_hold(&csio_lnode_to_hw(csio_rnode_to_lnode(rn))->lock)
>  {

[Severity: Low]
Will this trigger a static analysis failure due to unresolved pointer
aliasing? The lock being asserted here is
csio_lnode_to_hw(csio_rnode_to_lnode(rn))->lock, but this function calls
csio_scsi_cleanup_io_q() which expects scm->hw->lock. Does this need an
__assume_ctx_lock() workaround to prove they are the same lock?

[Severity: High]
This is a pre-existing issue, but does dropping the lock in this function
invalidate iterators in higher-level state machine handlers?

For example, csio_post_event_rns() iterates over rnodes using
list_for_each_safe(). If an event like CSIO_RNFE_DOWN causes the state
machine to call __csio_unreg_rnode(), the lock is temporarily dropped here:

spin_unlock_irq(&hw->lock);
csio_unreg_rnode(rn);
spin_lock_irq(&hw->lock);

During this window, if an incoming firmware event on another CPU (like a
LOGO) transitions the 'next' rnode to an uninitialized state and frees its
memory via csio_put_rnode(), will the list_for_each_safe() loop in
csio_post_event_rns() access the freed 'next' pointer when it resumes?

>  	struct csio_lnode *ln =3D csio_rnode_to_lnode(rn);
>  	struct csio_hw *hw =3D csio_lnode_to_hw(ln);

[ ... ]

> diff --git a/drivers/scsi/csiostor/csio_scsi.c b/drivers/scsi/csiostor/cs=
io_scsi.c
> index b1de615cf3162..b74fed463640e 100644
> --- a/drivers/scsi/csiostor/csio_scsi.c
> +++ b/drivers/scsi/csiostor/csio_scsi.c
> @@ -1157,6 +1157,7 @@ csio_scsi_cmpl_handler(struct csio_hw *hw, void *wr=
, uint32_t len,
>   */
>  void
>  csio_scsi_cleanup_io_q(struct csio_scsim *scm, struct list_head *q)
> +	__must_hold(&scm->hw->lock)
>  {

[Severity: High]
This is a pre-existing issue, but can the list_for_each_safe() loop in this
function lead to an infinite loop or use-after-free?

When iterating over the queue:

list_for_each_safe(tmp, next, q) {
        ioreq =3D (struct csio_ioreq *)tmp;
        csio_scsi_drvcleanup(ioreq);
        list_del_init(&ioreq->sm.sm_list);
        scmnd =3D csio_scsi_cmnd(ioreq);
        spin_unlock_irq(&hw->lock);

If a firmware completion interrupt occurs while hw->lock is dropped,
can the ISR process the 'next' I/O request, remove it, and return it to
the freelist, causing the loop to resume iterating through the freelist?

>  	struct csio_hw *hw =3D scm->hw;
>  	struct csio_ioreq *ioreq;

[ ... ]

> @@ -1316,6 +1319,7 @@ csio_scsim_cleanup_io(struct csio_scsim *scm, bool =
abort)
>   */
>  int
>  csio_scsim_cleanup_io_lnode(struct csio_scsim *scm, struct csio_lnode *l=
n)
> +	__must_hold(&scm->hw->lock)
>  {

[Severity: Critical]
This is a pre-existing issue, but does cleaning up I/O queues after an
abort timeout risk memory corruption and use-after-free?

If csio_scsi_abort_io_q() times out, it falls back to cleaning up:

rv =3D csio_scsi_abort_io_q(scm, &ln->cmpl_q, 30000);
if (rv !=3D 0) {
        csio_dbg(hw, "Some I/O aborts timed out, cleaning up..\n");
        csio_scsi_cleanup_io_q(scm, &ln->cmpl_q);
}

This returns the pending ioreq structures to the driver's freelist. If the
firmware later completes the aborted I/O, the ISR extracts the old ioreq
pointer and overwrites its status:

ioreq =3D (struct csio_ioreq *)((uintptr_t)
                 (((struct fw_scsi_read_wr *)tempwr)->cookie));
ioreq->wr_status =3D status;

Could this overwrite memory if the ioreq was reallocated for a new SCSI
command since generation counters do not appear to be validated?

>  	struct csio_hw *hw =3D scm->hw;
>  	struct csio_scsi_level_data sld;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1785451174.gi=
t.bvanassche@acm.org?part=3D22

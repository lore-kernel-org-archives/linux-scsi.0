Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9EE53A83BF
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 23:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785452973; cv=none; b=ixONqEU9JGfqcxfBJ9N6FK/IhceRFVMZoUraUHDPEQp9YqIsHLke9d+Gd7TZzRo8YyE7wNpjy/LxtoJPE+23RasX5OcnV+s49jQuKbinvEogis9Yv7/7Xo72ad1qOkQn4CP4yeNMheh7dCvDXvJNap0ypXUCA7rQllfubzvrfKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785452973; c=relaxed/simple;
	bh=UFoSd9QAPNfILa3zTu6TSnfJmgPnlr6ffm4SL73BuPg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=EUqNKMiOMF7yy4gOFPUQzrd91oufgpbdkj1ZYbveZZbidTLcIRkW5Aa0DpxasrPcoVWvN23Fgq7OfaTkM7sZzYStVdzG7s82NjBs38w77xAhWhRPjGrmxJc/Us5fUyUjS0aiu+53/+liXbw+RU7JUHmb0XYYrYqb7khyoTXQkVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Colfaw+2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Colfaw+2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8AAE1F000E9;
	Thu, 30 Jul 2026 23:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785452971;
	bh=jUZWuAYf4jHlteCFuwmvgwLk7HOI29DSgzaBw/daD+w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Colfaw+27nLUbWGfl9xBYaKea5nT3VFVHyEY4xSBwXXxKeBaZiF97r6MhLc0Jpaw5
	 v2sEwGmR193CVkQQuxKsOncOR2O2SS9zFn21ZtXt4msZOESQEfBsFpLoCWOEC2nR5G
	 nfK2tDfmsRfCvFbr84h2latno++wORKXYwWpjjjGlc2Cr91dGFNj3kyb8KDGeoaHr0
	 iiss339wkdx8MpUEuOt3HZxZuq/jwCehhvZvj8pqEawYltwcz/asFa6IOnwosmso1w
	 6DzzAJayOyiMy9g9EJTMsY5eWP2IzId8wjJKTVd6WzAv2g7GicbzwD64SOGPH0Hfou
	 odEEu4KYct8tQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 38/57] scsi: lpfc: Prepare for enabling lock context
 analysis
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bart Van Assche" <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <d7f69e9511ca5b79b64f48b1e54fb417db4d294f.1785451174.git.bvanassche@acm.org>
References: <cover.1785451174.git.bvanassche@acm.org>
 <d7f69e9511ca5b79b64f48b1e54fb417db4d294f.1785451174.git.bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 30 Jul 2026 23:09:31 +0000
Message-Id: <20260730230931.A8AAE1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:

Pre-existing issues:
- [High] An AB-BA lock inversion exists between `lpfc_cmd->buf_lock` and `p=
hba->hbalock`, which can cause a hard deadlock.
- [High] Race condition in timer callback `lpfc_els_timeout_handler` leadin=
g to use-after-free on module unload.
- [High] List corruption due to missing lock protection for SLI ring lists =
in `lpfc_els_abort` and `lpfc_els_flush_cmd`.
- [High] Concurrent FCP abort requests will hang for the full timeout durat=
ion due to unshared wait queues.
--

--- Patch [38]: [PATCH v3 38/57] scsi: lpfc: Prepare for enabling lock cont=
ext analysis ---
commit 7e811dc5ed08a4e45843970fc90d7859310944e2
Author: Bart Van Assche <bvanassche@acm.org>

scsi: lpfc: Prepare for enabling lock context analysis

Annotate the functions that perform conditional locking with
__context_unsafe().

> diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
> index 52fc5058976d9..45e7f147b1636 100644
> --- a/drivers/scsi/lpfc/lpfc_els.c
> +++ b/drivers/scsi/lpfc/lpfc_els.c
> @@ -9597,6 +9597,7 @@ lpfc_els_timeout(struct timer_list *t)
>   **/
>  void
>  lpfc_els_timeout_handler(struct lpfc_vport *vport)
> +	__context_unsafe(conditional locking)
>  {
>  	struct lpfc_hba  *phba =3D vport->phba;

[Severity: High]
This isn't a bug introduced by this patch, but is there a race condition
here during module unload?=20

Looking at the bottom of lpfc_els_timeout_handler(), the code checks for=20
FC_UNLOADING before calling mod_timer():

    if (!test_bit(FC_UNLOADING, &phba->pport->load_flag))
        mod_timer(&vport->els_tmofunc, ...);

If the teardown thread sets the FC_UNLOADING flag immediately after this
check is evaluated, the callback will re-arm the timer. Even if
timer_delete_sync() is used during teardown, the callback re-arms the timer
before exiting, which can cause the timer to fire on freed memory and lead
to a use-after-free crash.

> @@ -9719,6 +9720,7 @@ lpfc_els_timeout_handler(struct lpfc_vport *vport)
>   **/
>  void
>  lpfc_els_flush_cmd(struct lpfc_vport *vport)
> +	__context_unsafe(conditional locking)
>  {
>  	LIST_HEAD(abort_list);

[Severity: High]
This is a pre-existing issue, but can list corruption occur here during ELS
command flushes?=20

In lpfc_els_flush_cmd(), this code moves piocb->list from txcmplq to
cancel_list:

    spin_lock_irqsave(&phba->hbalock, iflags);
    list_del_init(&piocb->dlist);
    if (mbx_tmo_err || !(phba->sli.sli_flag & LPFC_SLI_ACTIVE))
        list_move_tail(&piocb->list, &cancel_list);

For SLI4, is holding only hbalock sufficient, or does it also require=20
pring->ring_lock to safely modify the txcmplq, preventing kernel panics=20
during linked list traversal?

> diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_=
nportdisc.c
> index 9c449055a55e6..79e5e876c879e 100644
> --- a/drivers/scsi/lpfc/lpfc_nportdisc.c
> +++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
> @@ -220,6 +220,7 @@ lpfc_check_elscmpl_iocb(struct lpfc_hba *phba, struct=
 lpfc_iocbq *cmdiocb,
>   */
>  void
>  lpfc_els_abort(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp)
> +	__context_unsafe(conditional locking)
>  {
>  	LIST_HEAD(abort_list);

[Severity: High]
This isn't a bug introduced by this patch, but does this list modification
lack lock protection?=20

In lpfc_els_abort(), list_del_init() modifies the active txcmplq without
holding any locks:

    if (retval && test_bit(FC_UNLOADING, &phba->pport->load_flag)) {
        list_del_init(&iocb->list);
        list_add_tail(&iocb->list, &drv_cmpl_list);
    }

Could this lead to list corruption during error recovery scenarios?

> diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
> index f2cab134af7f1..6c3fd3c33c535 100644
> --- a/drivers/scsi/lpfc/lpfc_scsi.c
> +++ b/drivers/scsi/lpfc/lpfc_scsi.c
> @@ -5520,6 +5520,7 @@ void lpfc_vmid_vport_cleanup(struct lpfc_vport *vpo=
rt)
>   **/
>  static int
>  lpfc_abort_handler(struct scsi_cmnd *cmnd)
> +	__context_unsafe(conditional locking)
>  {
>  	struct Scsi_Host  *shost =3D cmnd->device->host;

[Severity: High]
This is a pre-existing issue, but does this locking order create an AB-BA
deadlock?=20

In lpfc_abort_handler(), lpfc_cmd->buf_lock is acquired followed by=20
phba->hbalock:

    spin_lock_irqsave(&lpfc_cmd->buf_lock, flags);
    spin_lock(&phba->hbalock);

In lpfc_sli_abort_taskmgmt(), the thread acquires phba->hbalock first,=20
iterates over commands, and attempts to acquire lpfc_cmd->buf_lock. Could=20
concurrent SCSI aborts and device resets freeze storage operations?

[Severity: High]
This is also a pre-existing issue, but can concurrent FCP abort requests
hang here?

In lpfc_abort_handler(), if a second thread attempts to abort the same=20
command, it detects LPFC_DRIVER_ABORTED and jumps to wait_for_cmpl:

wait_for_cmpl:
    wait_event_timeout(waitq, (lpfc_cmd->pCmd !=3D cmnd),
                       secs_to_jiffies(2*vport->cfg_devloss_tmo));

It then sleeps on its private, on-stack waitq. Because the completion=20
handler only knows about the first thread's wait queue, won't the second=20
thread block unconditionally for the full duration of the timeout?

> diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
> index 62a30a92b7927..c76d62e8907c1 100644
> --- a/drivers/scsi/lpfc/lpfc_sli.c
> +++ b/drivers/scsi/lpfc/lpfc_sli.c

[ ... ]

> @@ -12871,6 +12872,7 @@ lpfc_sli_abort_iocb(struct lpfc_vport *vport, u16=
 tgt_id, u64 lun_id,
>  int
>  lpfc_sli_abort_taskmgmt(struct lpfc_vport *vport, struct lpfc_sli_ring *=
pring,
>  			uint16_t tgt_id, uint64_t lun_id, lpfc_ctx_cmd cmd)
> +	__context_unsafe(conditional locking)
>  {
>  	struct lpfc_hba *phba =3D vport->phba;

[Severity: High]
This isn't a bug introduced by this patch, but as mentioned above, does this
lock ordering conflict with lpfc_abort_handler()?=20

In lpfc_sli_abort_taskmgmt(), phba->hbalock is acquired before
lpfc_cmd->buf_lock:

    spin_lock_irqsave(&phba->hbalock, iflags);
    ...
    lpfc_cmd =3D container_of(iocbq, struct lpfc_io_buf, cur_iocbq);
    spin_lock(&lpfc_cmd->buf_lock);

This is the reverse of the order in lpfc_abort_handler(). Can this lead to=
=20
a hard deadlock during concurrent I/O timeouts?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1785451174.gi=
t.bvanassche@acm.org?part=3D38

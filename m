From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH v4 2/3] cxlflash: Superpipe support
Date: Wed, 12 Aug 2015 12:02:43 -0500
Message-ID: <DF020506-1BBA-4B56-A7DD-CBA2DCF6E370@linux.vnet.ibm.com>
References: <1439226588-7886-1-git-send-email-mrochs@linux.vnet.ibm.com> <20150812001835.Horde.5HNx0-z3d-8S7prwORBg_A1@ltc.linux.ibm.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2102\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:51450 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753492AbbHLRCw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Aug 2015 13:02:52 -0400
Received: from /spool/local
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Wed, 12 Aug 2015 11:02:52 -0600
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id 84C61C9007B
	for <linux-scsi@vger.kernel.org>; Wed, 12 Aug 2015 12:53:51 -0400 (EDT)
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t7CH2kMD52887702
	for <linux-scsi@vger.kernel.org>; Wed, 12 Aug 2015 17:02:46 GMT
Received: from d01av01.pok.ibm.com (localhost [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t7CH2i9n026092
	for <linux-scsi@vger.kernel.org>; Wed, 12 Aug 2015 13:02:46 -0400
In-Reply-To: <20150812001835.Horde.5HNx0-z3d-8S7prwORBg_A1@ltc.linux.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: wenxiong@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, nab@linux-iscsi.org, brking@linux.vnet.ibm.com, hch@infradead.org, mikey@neuling.org, imunsie@au1.ibm.com, dja@ozlabs.au.ibm.com, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

Hi Wendy,

Thanks for reviewing. Comments inline below.


-matt

> On Aug 11, 2015, at 11:18 PM, wenxiong@linux.vnet.ibm.com wrote:
> Quoting "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>:
>> +struct ctx_info *get_context(struct cxlflash_cfg *cfg, u64 rctxid,
>> +			     void *arg, enum ctx_ctrl ctx_ctrl)
>> +{
>> +	struct ctx_info *ctxi =3D NULL;
>> +	struct lun_access *lun_access =3D NULL;
>> +	struct file *file =3D NULL;
>> +	struct llun_info *lli =3D arg;
>> +	u64 ctxid =3D DECODE_CTXID(rctxid);
>> +	int rc;
>> +	pid_t pid =3D current->tgid, ctxpid =3D 0;
>> +
>> +	if (ctx_ctrl & CTX_CTRL_FILE) {
>> +		lli =3D NULL;
>> +		file =3D (struct file *)arg;
>> +	}
>> +
>> +	if (ctx_ctrl & CTX_CTRL_CLONE)
>> +		pid =3D current->parent->tgid;
>> +
>> +	if (likely(ctxid < MAX_CONTEXT)) {
>> +retry:
>> +		rc =3D mutex_lock_interruptible(&cfg->ctx_tbl_list_mutex);
>> +		if (rc)
>> +			goto out;
>> +
>=20
> if (mutex_lock_interruptible(&cfg->ctx_tbl_list_mutex))
>       goto out;
> or  return ctxi;

I=E2=80=99d like to keep the goto out so we can capture what is being r=
eturned
under a common trace that exists at =E2=80=98out=E2=80=99.

>=20
>> +		ctxi =3D cfg->ctx_tbl[ctxid];
>> +		if (ctxi)
>> +			if ((file && (ctxi->file !=3D file)) ||
>> +			    (!file && (ctxi->ctxid !=3D rctxid)))
>> +				ctxi =3D NULL;
>> +
>=20
> Should you combine two =E2=80=9Cif" to one "if"?

The logic in this routine is fairly complex. I intentionally structured
the conditional clauses in an effort to maximize the ease of quickly
comprehending what is taking place without polluting the code with
a lot of comments.

If you feel very strongly about this being a necessary fix and one that
would improve the quick comprehension of what is taking place than
I would be willing to consider changing this, but I feel it=E2=80=99s m=
ost clear
as is currently written.

>=20
>> +		if ((ctx_ctrl & CTX_CTRL_ERR) ||
>> +		    (!ctxi && (ctx_ctrl & CTX_CTRL_ERR_FALLBACK)))
>> +			ctxi =3D find_error_context(cfg, rctxid, file);
>> +		if (!ctxi) {
>> +			mutex_unlock(&cfg->ctx_tbl_list_mutex);
>> +			goto out;
>> +		}
>> +
>> +		/*
>> +		 * Need to acquire ownership of the context while still under
>> +		 * the table/list lock to serialize with a remove thread. Use
>> +		 * the 'try' to avoid stalling the table/list lock for a single
>> +		 * context.
>> +		 */
>> +		rc =3D mutex_trylock(&ctxi->mutex);
>> +		mutex_unlock(&cfg->ctx_tbl_list_mutex);
>> +		if (!rc)
>> +			goto retry;
>> +
>> +		if (ctxi->unavail)
>> +			goto denied;
>> +
>> +		ctxpid =3D ctxi->pid;
>> +		if (likely(!(ctx_ctrl & CTX_CTRL_NOPID)))
>> +			if (pid !=3D ctxpid)
>> +				goto denied;
>=20
> Should you combine above two =E2=80=9Cif" to one "if"?

Same response as above.

>> +	spin_lock(&gli->slock);
>> +	if (gli->mode =3D=3D MODE_NONE)
>> +		gli->mode =3D mode;
>> +	else if (gli->mode !=3D mode) {
>> +		pr_err("%s: LUN operating in mode %d, requested mode %d\n",
>> +		       __func__, gli->mode, mode);
>> +		rc =3D -EINVAL;
>> +		goto out;
>> +	}
>> +
>> +	gli->users++;
>> +	WARN_ON(gli->users <=3D 0);
>=20
> Does =E2=80=9Cgli->users" have upper limit?

No.

>> +void cxlflash_lun_detach(struct glun_info *gli)
>> +{
>> +	spin_lock(&gli->slock);
>> +	WARN_ON(gli->mode =3D=3D MODE_NONE);
>> +	if (--gli->users =3D=3D 0)
>> +		gli->mode =3D MODE_NONE;
>> +	pr_debug("%s: gli->users=3D%u\n", __func__, gli->users);
>> +	WARN_ON(gli->users < 0);
>=20
> do you like to add a pr_debug(=E2=80=A6.) here?

I don=E2=80=99t quite follow what you mean. Are you suggesting to use a
pr_debug instead of a WARN?

These are intentionally made to be WARNs as they are indicative of
a driver bug and the data provided by the warn will help in tracking
down the root cause of the bug.

>> +
>> +out:
>> +	if (unlock_ctx)
>> +		mutex_unlock(&ctxi->mutex);
>=20
> Should =E2=80=9Cmutex_lock(&ctxi->mutex);" in the same function?

This is something that Mikey Neuling also commented on. The mutex
is obtained in get_context(). Mikey made a suggestion that I=E2=80=99m =
going
to implement that will replace these with a =E2=80=98put_context=E2=80=99=
 routine.

>> +	size =3D (MAX_RHT_PER_CONTEXT * sizeof(*ctxi->rht_lun));
>> +	size +=3D sizeof(*ctxi);
>> +
>=20
> Combine above two lines code into one line code?

These allocations are now broken up, so this doesn=E2=80=99t exist anym=
ore
as you=E2=80=99ll see in v5.

>=20
>> +	tmp =3D kzalloc(size, GFP_KERNEL);
>> +	if (unlikely(!tmp)) {
>> +		pr_err("%s: Unable to allocate context! (%ld)\n",
>> +		       __func__, size);
>> +		goto out;
>> +	}
>> +
>> +	rhte =3D (struct sisl_rht_entry *)get_zeroed_page(GFP_KERNEL);
>> +	if (unlikely(!rhte)) {
>> +		pr_err("%s: Unable to allocate RHT!\n", __func__);
>> +		goto err;
>> +	}
>> +
>> +	ctxi =3D (struct ctx_info *)tmp;
>> +	tmp +=3D sizeof(*ctxi);
>> +	ctxi->rht_lun =3D (struct llun_info **)tmp;
>=20
> Combine above two lines code into one line code?

Same comment, this has changed in v5.

>=20
>> +	ctxi->rht_start =3D rhte;
>> +	ctxi->rht_perms =3D perms;
>> +
>> +	ctxi->ctrl_map =3D &afu->afu_map->ctrls[ctxid].ctrl;
>> +	ctxi->ctxid =3D ENCODE_CTXID(ctxi, ctxid);
>> +	ctxi->lfd =3D adap_fd;
>> +	ctxi->pid =3D current->tgid; /* tgid =3D pid */
>> +	ctxi->ctx =3D ctx;
>> +	ctxi->file =3D file;
>> +	mutex_init(&ctxi->mutex);
>> +	INIT_LIST_HEAD(&ctxi->luns);
>> +	INIT_LIST_HEAD(&ctxi->list); /* initialize for list_empty() */
>> +
>> +	atomic_inc(&cfg->num_user_contexts);
>> +	mutex_lock(&ctxi->mutex);
>> +out:
>=20
> Is it ok to call =E2=80=9Cmutex_lock(&ctxi->mutex);" in the function =
which calling create_context"?

Yes, by design, we have it such that the context exits create_context()
and get_context() with its mutex held.

>> +static int cxlflash_manage_lun(struct scsi_device *sdev,
>> +			       struct dk_cxlflash_manage_lun *manage)
>> +{
>> +	int rc =3D 0;
>> +	struct llun_info *lli =3D NULL;
>> +	u64 flags =3D manage->hdr.flags;
>> +	u32 chan =3D sdev->channel;
>> +
>> +	lli =3D lookup_lun(sdev, manage->wwid);
>> +	pr_debug("%s: ENTER: WWID =3D %016llX%016llX, flags =3D %016llX li=
 =3D %p\n",
>> +		 __func__, get_unaligned_le64(&manage->wwid[0]),
>> +		 get_unaligned_le64(&manage->wwid[8]),
>> +		 manage->hdr.flags, lli);
>> +	if (unlikely(!lli)) {
>> +		rc =3D -ENOMEM;
>> +		goto out;
>> +	}
>> +
>=20
> Move pr_debug(=E2=80=A6) under if leg?

This debug print is strategically placed to inform us when
this routine is called, what was passed to it, and what we
were able to find using the passed parameters. If we moved
it to an error condition, we would lose that valuable debug
information in good path.

>> +static int check_state(struct cxlflash_cfg *cfg)
>> +{
>> +	int rc =3D 0;
>> +
>> +retry:
>> +	switch (cfg->state) {
>> +	case STATE_LIMBO:
>> +		pr_debug("%s: Limbo, going to wait...\n", __func__);
>> +		rc =3D wait_event_interruptible(cfg->limbo_waitq,
>> +					      cfg->state !=3D STATE_LIMBO);
>> +		if (unlikely(rc))
>> +			goto out;
>> +		goto retry;
>> +	case STATE_FAILTERM:
>> +		pr_debug("%s: Failed/Terminating!\n", __func__);
>> +		rc =3D -ENODEV;
>> +		goto out;
>=20
> changed =E2=80=9Cgoto out" to "break"?

Sure, will change to a =E2=80=98break=E2=80=99.

>> +static int cxlflash_afu_recover(struct scsi_device *sdev,
>> +				struct dk_cxlflash_recover_afu *recover)
>> +{
>> +	struct cxlflash_cfg *cfg =3D (struct cxlflash_cfg *)sdev->host->ho=
stdata;
>> +	struct llun_info *lli =3D sdev->hostdata;
>> +	struct afu *afu =3D cfg->afu;
>> +	struct ctx_info *ctxi =3D NULL;
>> +	struct mutex *mutex =3D &cfg->ctx_recovery_mutex;
>> +	u64 ctxid =3D DECODE_CTXID(recover->context_id),
>> +	    rctxid =3D recover->context_id;
>> +	long reg;
>> +	int lretry =3D 20; /* up to 2 seconds */
>> +	int rc =3D 0;
>> +
>> +	atomic_inc(&cfg->recovery_threads);
>> +	rc =3D mutex_lock_interruptible(mutex);
>> +	if (rc)
>> +		goto out;
>=20
> change it to "if (mutex_lock_interruptible(mutex))":, If fails here, =
why need to unlock_mutex(mutex) in "out:"? How about just return error?

We need to jump through =E2=80=98out' to clean up the recovery threads =
accounting.

>=20
>> +
>> +	pr_debug("%s: reason 0x%016llX rctxid=3D%016llX\n", __func__,
>> +		 recover->reason, rctxid);
>> +
>> +retry:
>> +	/* Ensure that this process is attached to the context */
>> +	ctxi =3D get_context(cfg, rctxid, lli, CTX_CTRL_ERR_FALLBACK);
>> +	if (unlikely(!ctxi)) {
>> +		pr_err("%s: Bad context! (%llu)\n", __func__, ctxid);
>> +		rc =3D -EINVAL;
>> +		goto out;
>> +	}
>> +
>> +	if (ctxi->err_recovery_active) {
>> +retry_recover:
>> +		rc =3D recover_context(cfg, ctxi);
>> +		if (unlikely(rc)) {
>> +			pr_err("%s: Recovery failed for context %llu (rc=3D%d)\n",
>> +			       __func__, ctxid, rc);
>> +			if ((rc =3D=3D -ENODEV) &&
>> +			    ((atomic_read(&cfg->recovery_threads) > 1) ||
>> +			     (lretry--))) {
>> +				pr_debug("%s: Going to try again!\n", __func__);
>> +				mutex_unlock(mutex);
>> +				msleep(100);
>> +				rc =3D mutex_lock_interruptible(mutex);
>> +				if (rc)
>> +					goto out;
>=20
> Same here

Ditto.

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

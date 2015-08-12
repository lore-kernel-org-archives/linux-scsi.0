From: Michael Neuling <mikey@neuling.org>
Subject: Re: [PATCH v4 2/3] cxlflash: Superpipe support
Date: Wed, 12 Aug 2015 13:54:35 +1000
Message-ID: <1439351675.28873.57.camel@neuling.org>
References: <1439226588-7886-1-git-send-email-mrochs@linux.vnet.ibm.com>
	 <1439270596.5081.58.camel@neuling.org>
	 <164CACE9-6195-4F1C-AA23-779FFF7D9DF8@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:34055 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932265AbbHLDyi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Aug 2015 23:54:38 -0400
In-Reply-To: <164CACE9-6195-4F1C-AA23-779FFF7D9DF8@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, brking@linux.vnet.ibm.com, wenxiong@linux.vnet.ibm.com, hch@infradead.org, imunsie@au1.ibm.com, dja@ozlabs.au.ibm.com, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>


> >> +		pr_debug("%s: Wait for user context to quiesce...\n", __func__)=
;
> >> +		wake_up_all(&cfg->limbo_waitq);
> >> +		ssleep(1);
> >=20
> > Why 1 sec and why in a loop?  Can=E2=80=99t you poll/wait for compl=
etion somewhere?
>=20
> This routine is called when the device is being removed and we need t=
o stall until
> the user contexts are made aware of removal [by marking them in error=
] and have
> completely gone away [there are no longer any contexts in our table o=
r list].
>=20
> The 1 second sleep is simply to give the users time to cleanup once t=
hey see
> the notification. We can make it a larger/smaller value or remove it =
entirely, but
> I felt that since this is not a hot path there was no reason to perfo=
rm a busy-wait
> style of loop here and yield to someone else.
>=20
> As for the completion/poll, I did consider that but couldn=E2=80=99t =
come up with a clean
> way of implementing given how we designed the notification/cleanup me=
chanism
> (really just a failed recovery). We can certainly look at doing that =
as an
> enhancement in the future.

Does the API allow this flexibility in the future?

>=20
> >> +	if (likely(ctxid < MAX_CONTEXT)) {
> >> +retry:
> >> +		rc =3D mutex_lock_interruptible(&cfg->ctx_tbl_list_mutex);
> >> +		if (rc)
> >> +			goto out;
> >> +
> >> +		ctxi =3D cfg->ctx_tbl[ctxid];
> >> +		if (ctxi)
> >> +			if ((file && (ctxi->file !=3D file)) ||
> >> +			    (!file && (ctxi->ctxid !=3D rctxid)))
> >> +				ctxi =3D NULL;
> >> +
> >> +		if ((ctx_ctrl & CTX_CTRL_ERR) ||
> >> +		    (!ctxi && (ctx_ctrl & CTX_CTRL_ERR_FALLBACK)))
> >> +			ctxi =3D find_error_context(cfg, rctxid, file);
> >> +		if (!ctxi) {
> >> +			mutex_unlock(&cfg->ctx_tbl_list_mutex);
> >> +			goto out;
> >> +		}
> >> +
> >> +		/*
> >> +		 * Need to acquire ownership of the context while still under
> >> +		 * the table/list lock to serialize with a remove thread. Use
> >> +		 * the 'try' to avoid stalling the table/list lock for a single
> >> +		 * context.
> >> +		 */
> >> +		rc =3D mutex_trylock(&ctxi->mutex);
> >> +		mutex_unlock(&cfg->ctx_tbl_list_mutex);
> >> +		if (!rc)
> >> +			goto retry;
> >=20
> > Please just create a loop rather than this goto retry.
>=20
> Okay.
>=20
> >> +	rhte_checkin(ctxi, rhte);
> >> +	cxlflash_lun_detach(gli);
> >> +
> >> +out:
> >> +	if (unlock_ctx)
> >> +		mutex_unlock(&ctxi->mutex);
> >=20
> > Where is the matching lock for this?
>=20
> One of the main design points of our context serialization strategy i=
s that
> any context returned from get_context() has been fully validated, wil=
l not
> be removed from under you, and _is holding the context mutex_. Thus
> for each of these mutex_unlock(ctxi) you see at the bottom of externa=
l
> entry points, the mutex was obtained in get_context().

Should we have something like put_context() that does this?  So there i=
s
matching calls to get/put_context

>=20
> >> +	char *tmp =3D NULL;
> >> +	size_t size;
> >> +	struct afu *afu =3D cfg->afu;
> >> +	struct ctx_info *ctxi =3D NULL;
> >> +	struct sisl_rht_entry *rhte;
> >> +
> >> +	size =3D (MAX_RHT_PER_CONTEXT * sizeof(*ctxi->rht_lun));
> >> +	size +=3D sizeof(*ctxi);
> >> +
> >> +	tmp =3D kzalloc(size, GFP_KERNEL);
> >=20
> > Just do two allocs. One for ctxi and one for rht_lun.  This is over=
ly
> > complicated.
>=20
> I disagree that it=E2=80=99s overly complicated. The intention here w=
as to get this
> stuff together to avoid multiple function calls and possibly help out=
 perf-wise
> via locality. That said, I=E2=80=99m not opposed to performing multip=
le allocations.

I'm not sure I buy it's a performance issue on create_context().  How
often are you calling that?  Doesn't that do a lot of things other than
just this?

Anyway if you want to do that, that's ok I guess, but you need to
document why and what you're doing.=20

> Look for this in v5.
>=20
> >=20
> >> +	if (unlikely(!tmp)) {
> >> +		pr_err("%s: Unable to allocate context! (%ld)\n",
> >> +		       __func__, size);
> >> +		goto out;
> >> +	}
> >> +
> >> +	rhte =3D (struct sisl_rht_entry *)get_zeroed_page(GFP_KERNEL);
> >> +	if (unlikely(!rhte)) {
> >> +		pr_err("%s: Unable to allocate RHT!\n", __func__);
> >> +		goto err;
> >> +	}
> >> +
> >> +	ctxi =3D (struct ctx_info *)tmp;
> >> +	tmp +=3D sizeof(*ctxi);
> >> +	ctxi->rht_lun =3D (struct llun_info **)tmp;
> >=20
> > Yuck=E2=80=A6 just do two allocs rather than this throbbing.
>=20
> You got it.
>=20
> >> +out:
> >> +	if (unlock_ctx)
> >> +		mutex_unlock(&ctxi->mutex);
> >=20
> > Where is the matching lock for this?
>=20
> See earlier comment about get_context().
>=20
> >> +	if (likely(ctxi))
> >> +		mutex_unlock(&ctxi->mutex);
> >=20
> > Where is the matching lock for this?
>=20
> Ditto.
>=20
> >> +	file =3D cxl_get_fd(ctx, &cfg->cxl_fops, &fd);
> >=20
> > You should create a new fops for each call here.  We write the fops=
 to fill it
> > out.  I think it=E2=80=99ll work as you have now but it's a bit dod=
gy.
>=20
> Are you saying that instead of having a single fops for the device, e=
ach of our
> context=E2=80=99s should have an fops that we pass here?
>=20
> >> +	list_add(&lun_access->list, &ctxi->luns);
> >> +	mutex_unlock(&ctxi->mutex);
> >=20
> > Where is the matching lock for this?
>=20
> Just like with get_context(), we leave create_context() with the mute=
x held.
>=20
> >> +	rc =3D cxlflash_lun_attach(gli, MODE_PHYSICAL);
> >> +	if (unlikely(rc)) {
> >> +		dev_err(dev, "%s: Failed to attach to LUN! (PHYSICAL)\n",
> >=20
> > Is this going to spam the console from userspace?  Same below.
>=20
> With a well-behaved application it shouldn=E2=80=99t We can certainly=
 look at moving
> to a debug if you feel it=E2=80=99s likely that someone would use thi=
s to spam the
> console.
>=20
> >> +	struct cxlflash_cfg *cfg =3D (struct cxlflash_cfg *)sdev->host->=
hostdata;
> >> +	struct afu *afu =3D cfg->afu;
> >> +	struct dk_cxlflash_hdr *hdr;
> >> +	char buf[MAX_CXLFLASH_IOCTL_SZ];
> >=20
> > why is buf not just a =E2=80=9Cunion cxlflash_ioctls"?
>=20
> Because I wanted you to have to look up this define? ;)

:-P

> In all seriousness, we originally had this define as a stand-alone va=
lue (it
> wasn=E2=80=99t tied to the union). When I implemented the union, I fi=
gured the define
> was more self-descriptive in what we were trying to convey. I=E2=80=99=
ll change it
> over to the union in v5.
>=20
> >> +	hdr =3D (struct dk_cxlflash_hdr *)&buf;
> >> +	if (hdr->version !=3D 0) {
> >> +		pr_err("%s: Version %u not supported for %s\n",
> >> +		       __func__, hdr->version, decode_ioctl(cmd));
> >> +		rc =3D -EINVAL;
> >> +		goto cxlflash_ioctl_exit;
> >> +	}
> >=20
> > Do you advertise this version anywhere?  Users just have to call it=
 and fail?
>=20
> We don=E2=80=99t. We can add a version define to the exported ioctl h=
eader.

It needs to be exported dynamically by the kernel.  Not the headers.
Think new software on old kernel and visa versa.

>=20
> > You should check hdr->flags are zero incase some new userspace trie=
s to set
> > them.  Same for hdr->rsvd.
>=20
> We can=E2=80=99t do that for the flags because those they are used fo=
r some of the ioctls.
> The reserved=E2=80=99s however _can_ be checked under the version 0 c=
lause.

OK

> > Also, can you do these checks earlier.  It seems you've already don=
e a bunch of
> > stuff before here.
>=20
> From a runtime perspective, we haven=E2=80=99t actually done that muc=
h prior to the version
> check. I suppose we could put the check earlier but I don=E2=80=99t l=
ike the idea of touching
> data that hasn=E2=80=99t been copied in. So we would need to copy in =
just the header, then
> check the version. Then if it=E2=80=99s valid, copy in the rest. At s=
ome point later on if/when more
> versions are supported we might need to do something like this, but I=
 think it seems a
> bit silly to do that now.

Ok.

> >> +#define DK_CXLFLASH_ATTACH		CXL_IOWR(0x80, dk_cxlflash_attach)
> >> +#define DK_CXLFLASH_USER_DIRECT		CXL_IOWR(0x81, dk_cxlflash_udire=
ct)
> >> +#define DK_CXLFLASH_RELEASE		CXL_IOWR(0x84, dk_cxlflash_release)
> >> +#define DK_CXLFLASH_DETACH		CXL_IOWR(0x85, dk_cxlflash_detach)
> >> +#define DK_CXLFLASH_VERIFY		CXL_IOWR(0x86, dk_cxlflash_verify)
> >> +#define DK_CXLFLASH_RECOVER_AFU		CXL_IOWR(0x88, dk_cxlflash_recov=
er_afu)
> >> +#define DK_CXLFLASH_MANAGE_LUN		CXL_IOWR(0x89, dk_cxlflash_manage=
_lun)
> >=20
> > I'm not sure I'd leave these sparse.  What happens if the vlun patc=
hes don't
> > get in?
>=20
> I do agree with you. I had wanted to keep them like this as their ord=
ering matched
> closer with how they are expected to be used. That said, I=E2=80=99m =
okay with moving
> them around to avoid the sparseness.

YEah, plus it breaks your table in the ioctl

Mikey
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

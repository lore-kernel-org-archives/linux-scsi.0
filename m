From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH v4 2/3] cxlflash: Superpipe support
Date: Tue, 11 Aug 2015 16:51:46 -0500
Message-ID: <164CACE9-6195-4F1C-AA23-779FFF7D9DF8@linux.vnet.ibm.com>
References: <1439226588-7886-1-git-send-email-mrochs@linux.vnet.ibm.com> <1439270596.5081.58.camel@neuling.org>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2102\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:48544 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753564AbbHKVvt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Aug 2015 17:51:49 -0400
Received: from /spool/local
	by e33.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Tue, 11 Aug 2015 15:51:49 -0600
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id 6E8CA19D804C
	for <linux-scsi@vger.kernel.org>; Tue, 11 Aug 2015 15:42:44 -0600 (MDT)
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t7BLorr336110422
	for <linux-scsi@vger.kernel.org>; Tue, 11 Aug 2015 14:50:53 -0700
Received: from d03av03.boulder.ibm.com (localhost [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t7BLpjS0001804
	for <linux-scsi@vger.kernel.org>; Tue, 11 Aug 2015 15:51:47 -0600
In-Reply-To: <1439270596.5081.58.camel@neuling.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Neuling <mikey@neuling.org>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, brking@linux.vnet.ibm.com, wenxiong@linux.vnet.ibm.com, hch@infradead.org, imunsie@au1.ibm.com, dja@ozlabs.au.ibm.com, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

> On Aug 11, 2015, at 12:23 AM, Michael Neuling <mikey@neuling.org> wro=
te:
>=20
> Some comments inline

Thanks for reviewing, responses below.

> On Mon, 2015-08-10 at 12:09 -0500, Matthew R. Ochs wrote:
>> Add superpipe supporting infrastructure to device driver for the IBM=
 CXL
>> Flash adapter. This patch allows userspace applications to take adva=
ntage
>> of the accelerated I/O features that this adapter provides and bypas=
s the
>> traditional filesystem stack.
>>=20
>> Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
>> Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
>> ---
>> Documentation/ioctl/ioctl-number.txt |    1 +
>> Documentation/powerpc/cxlflash.txt   |  297 +++++
>> drivers/scsi/cxlflash/Makefile       |    2 +-
>> drivers/scsi/cxlflash/common.h       |   19 +
>> drivers/scsi/cxlflash/main.c         |   21 +-
>> drivers/scsi/cxlflash/superpipe.c    | 2206 ++++++++++++++++++++++++=
++++++++++
>> drivers/scsi/cxlflash/superpipe.h    |  127 ++
>> include/uapi/scsi/Kbuild             |    1 +
>> include/uapi/scsi/cxlflash_ioctl.h   |  139 +++
>> 9 files changed, 2810 insertions(+), 3 deletions(-)
>> create mode 100644 Documentation/powerpc/cxlflash.txt
>> create mode 100644 drivers/scsi/cxlflash/superpipe.c
>> create mode 100644 drivers/scsi/cxlflash/superpipe.h
>> create mode 100644 include/uapi/scsi/cxlflash_ioctl.h
>>=20
>> diff --git a/Documentation/ioctl/ioctl-number.txt b/Documentation/io=
ctl/ioctl-number.txt
>> index fdd35bf..67273e1 100644
>> --- a/Documentation/ioctl/ioctl-number.txt
>> +++ b/Documentation/ioctl/ioctl-number.txt
>> @@ -315,6 +315,7 @@ Code  Seq#(hex)	Include File		Comments
>> 0xC0	00-0F	linux/usb/iowarrior.h
>> 0xC9	00-0F	uapi/cxl-memcpy.h       Reserved for non-upstream prototy=
pe
>=20
> This above doesn't exist upstream.  Make sure your patch applies to a
> clean tree.

My mistake. Will fix in v5.

>> +
>> +DK_CXLFLASH_USER_VIRTUAL
>> +------------------------
>> +    This ioctl is responsible for transitioning the LUN to virtual =
mode
>> +    of access and configuring the AFU for virtual access from user =
space
>> +    on a per-context basis. Additionally, the block size and last l=
ogical
>> +    block address (LBA) are returned to the user.
>> +
>> +    As mentioned previously, when operating in user space access mo=
de,
>> +    LUNs may be accessed in whole or in part. Only one mode is allo=
wed
>> +    at a time and if one mode is active (outstanding references exi=
st),
>> +    requests to use the LUN in a different mode are denied.
>> +
>> +    The AFU is configured for virtual access from user space by add=
ing
>> +    an entry to the AFU's resource handle table. The index of the e=
ntry
>> +    is treated as a resource handle that is returned to the user. T=
he
>> +    user is then able to use the handle to reference the LUN during=
 I/O.
>> +
>> +    By default, the virtual LUN is created with a size of 0. The us=
er
>> +    would need to use the DK_CXLFLASH_VLUN_RESIZE ioctl to adjust t=
he grow
>> +    the virtual LUN to a desired size. To avoid having to perform t=
his
>> +    resize for the initial creation of the virtual LUN, the user ha=
s the
>> +    option of specifying a size as part of the DK_CXLFLASH_USER_VIR=
TUAL
>> +    ioctl, such that when success is returned to the user, the
>> +    resource handle that is provided is already referencing provisi=
oned
>> +    storage. This is reflected by the last LBA being a non-zero val=
ue.
>=20
>=20
> This should be in the vlun patch.

Okay.

>> +DK_CXLFLASH_VLUN_RESIZE
>> +-----------------------
>> +    This ioctl is responsible for resizing a previously created vir=
tual
>> +    LUN and will fail if invoked upon a LUN that is not in virtual
>> +    mode. Upon success, an updated last LBA is returned to the user
>> +    indicating the new size of the virtual LUN associated with the
>> +    resource handle.
>> +
>> +    The partitioning of virtual LUNs is jointly mediated by the cxl=
flash
>> +    driver and the AFU. An allocation table is kept for each LUN th=
at is
>> +    operating in the virtual mode and used to program a LUN transla=
tion
>> +    table that the AFU references when provided with a resource han=
dle.
>=20
> All this vlun discussion would be in the next patch not this superpip=
e patch.

Ditto, will do.

>> +DK_CXLFLASH_RELEASE
>> +-------------------
>> +    This ioctl is responsible for releasing a previously obtained
>> +    reference to either a physical or virtual LUN. This can be
>> +    thought of as the inverse of the DK_CXLFLASH_USER_DIRECT or
>> +    DK_CXLFLASH_USER_VIRTUAL ioctls. Upon success, the resource han=
dle
>> +    is no longer valid and the entry in the resource handle table i=
s
>> +    made available to be used again.
>> +
>> +    As part of the release process for virtual LUNs, the virtual LU=
N
>> +    is first resized to 0 to clear out and free the translation tab=
les
>> +    associated with the virtual LUN reference.
>=20
> Looks like file_ops release calls these functions anyway.  So why do =
we need
> this?

This is required because a user may hold multiple resource handles
per context and may wish to release some of those resource handles
while not relinquishing all of them (which would occur [along with the
context too] when using the file_ops release). In short, this release
is the opposite of user_virtual/user_physical.

>=20
>> +DK_CXLFLASH_DETACH
>> +------------------
>> +    This ioctl is responsible for unregistering a context with the
>> +    cxlflash driver and release outstanding resources that were
>> +    not explicitly released via the DK_CXLFLASH_RELEASE ioctl. Upon
>> +    success, all "tokens" which had been provided to the user from =
the
>> +    DK_CXLFLASH_ATTACH onward are no longer valid.
>=20
> Why split this between detach and release?  Can you reused a released=
 context?

They are for =E2=80=98undoing=E2=80=99 different things. The release is=
 for freeing resource
handles while detach is for freeing contexts. A user may wish to alloca=
te
a context only once but create/free resources associated with that cont=
ext
many times without ever freeing the context.
=20
>> +DK_CXLFLASH_CLONE
>> +-----------------
>> +    This ioctl is responsible for cloning a previously created
>> +    context to a more recently created context. It exists solely to
>> +    support maintaining user space access to storage after a proces=
s
>> +    forks. Upon success, the child process (which invoked the ioctl=
)
>> +    will have access to the same LUNs via the same resource handle(=
s)
>> +    and fd2 as the parent, but under a different context.
>> +
>> +    Context sharing across processes is not supported with CXL and
>> +    therefore each fork must be met with establishing a new context
>> +    for the child process. This ioctl simplifies the state manageme=
nt
>> +    and playback required by a user in such a scenario. When a proc=
ess
>> +    forks, child process can clone the parents context by first cre=
ating
>> +    a context (via DK_CXLFLASH_ATTACH) and then using this ioctl to
>> +    perform the clone from the parent to the child.
>> +
>> +    The clone itself is fairly simple. The resource handle and lun
>> +    translation tables are copied from the parent context to the ch=
ild's
>> +    and then synced with the AFU.
>=20
> This should be in the vlun patch.

Okay.

> Also, should be called DK_CXLFLASH_VLUN_CLONE to be consisten with VL=
UN_RESIZE

Sure, we can accommodate that.

>> +
>> +DK_CXLFLASH_VERIFY
>> +------------------
>> +    This ioctl is used to detect various changes such as the capaci=
ty of
>> +    the disk changing, the number of LUNs visible changing, etc. In=
 cases
>> +    where the changes affect the application (such as a LUN resize)=
, the
>> +    cxlflash driver will report the changed state to the applicatio=
n.
>>=20
>=20
> This needs a broader description.  Verify exactly what?

The user calls in when they want to validate that a LUN hasn=E2=80=99t =
been changed
in response to a check condition. As the user is operating out of band =
from
the kernel, they will see these types of events without our knowledge. =
When
encountered, the user=E2=80=99s architected behavior is to call in to t=
his ioctl, indicating
what they want to verify and passing along any appropriate information.=
 For
now, we only support verifying a LUN change (ie: size different) with s=
ense data.

Will include these types of details here in v5.

>> +DK_CXLFLASH_RECOVER_AFU
>> +-----------------------
>> +    This ioctl is used to drive recovery (if such an action is warr=
anted)
>> +    of a specified user context. Any state associated with the user=
 context
>> +    is re-established upon successful recovery.
>=20
> Why would I call this?  What scenario?

User contexts are put into an error condition when the device needs to =
be
reset or is terminating. Users are notified of this error condition by =
seeing
all 0xF=E2=80=99s on an MMIO read. Upon encountering this, the architec=
ted behavior
for a user is to call into this ioctl to recover their context. A user =
may also
call into this ioctl at any time to check if the device is operating no=
rmally.
If a failure is returned from this ioctl, the user is expected to grace=
fully
clean up their context via release/detach ioctls. Until they do, the co=
ntext
they hold is not relinquished. The user may also optionally exit the pr=
ocess
at which time the context/resources they held will be freed as part of =
the
release fop.

Will include these types of details here in v5.

>> +
>> +DK_CXLFLASH_MANAGE_LUN
>> +----------------------
>> +    This ioctl is used to switch a LUN from a mode where it is avai=
lable
>> +    for file-system access (legacy), to a mode where it is set asid=
e for
>> +    exclusive user space access (superpipe). In case a LUN is visib=
le
>> +    across multiple ports and adapters, this ioctl is used to uniqu=
ely
>> +    identify each LUN by its World Wide Node Name (WWNN).
>=20
> Should this be called something specific?  DK_CXLFLASH_SUPERPIPE_MODE=
?

We intentionally gave this ioctl a somewhat vague/broader name as we ma=
y use it
to perform more actions than simply enabling/disabling superpipe mode i=
n the future.

>> +	atomic_t recovery_threads;
>> +	struct mutex ctx_recovery_mutex;
>> +	struct mutex ctx_tbl_list_mutex;
>> +	struct ctx_info *ctx_tbl[MAX_CONTEXT];
>=20
> MAX_CONTEXT=3D512.  This is pretty big!

It is. But then again, it=E2=80=99s much better than when we started an=
d had an array
of struct ctx_info. We can possibly look at coming up with a more dynam=
ic
solution in the future if memory footprint is of great concern. Right n=
ow I
think our footprint is pretty good overall.

>> +/**
>> + * lookup_lun() - find or create a local LUN information structure
>> + * @sdev:	SCSI device associated with LUN.
>> + * @wwid:	WWID associated with LUN.
>> + *
>> + * When a local LUN is not found and a global LUN is also not found=
, both
>> + * a global LUN and local LUN are created. The global LUN is added =
to the
>> + * global list and the local LUN is returned.
>> + *
>> + * Return: Found/Allocated local lun_info structure on success, NUL=
L on failure
>> + */
>> +static struct llun_info *lookup_lun(struct scsi_device *sdev, u8 *w=
wid)
>=20
> Should this been lookup_and_create_lun()?  lookup_lun() does somethin=
g quite
> different to lookup_local() despite being named simlarly.

Ben Herrenschmidt had a similar comment. We=E2=80=99re going to look at=
 renaming these.

>> +/**
>> + * cxlflash_term_luns() - Delete all entries from local lun list, f=
ree.
>> + * @cfg:	Internal structure associated with the host.
>> + */
>> +void cxlflash_term_luns(struct cxlflash_cfg *cfg)
>=20
> This just does local luns?

Will look at renaming this.

>> +/**
>> + * cxlflash_stop_term_user_contexts() - stops/terminates known user=
 contexts
>> + * @cfg:	Internal structure associated with the host.
>> + *
>> + * When the host needs to go down, all users must be quiesced and t=
heir
>> + * memory freed. This is accomplished by putting the contexts in er=
ror
>> + * state which will notify the user and let them 'drive' the teardo=
wn.
>> + * Meanwhile, this routine camps until all user contexts have been =
removed.
>> + */
>> +void cxlflash_stop_term_user_contexts(struct cxlflash_cfg *cfg)
>> +{
>> +	int i, found;
>> +
>> +	cxlflash_mark_contexts_error(cfg);
>> +
>> +	while (true) {
>> +		found =3D false;
>> +
>> +		for (i =3D 0; i < MAX_CONTEXT; i++)
>> +			if (cfg->ctx_tbl[i]) {
>> +				found =3D true;
>> +				break;
>> +			}
>> +
>> +		if (!found && list_empty(&cfg->ctx_err_recovery))
>> +			return;
>> +
>> +		pr_debug("%s: Wait for user context to quiesce...\n", __func__);
>> +		wake_up_all(&cfg->limbo_waitq);
>> +		ssleep(1);
>=20
> Why 1 sec and why in a loop?  Can=E2=80=99t you poll/wait for complet=
ion somewhere?

This routine is called when the device is being removed and we need to =
stall until
the user contexts are made aware of removal [by marking them in error] =
and have
completely gone away [there are no longer any contexts in our table or =
list].

The 1 second sleep is simply to give the users time to cleanup once the=
y see
the notification. We can make it a larger/smaller value or remove it en=
tirely, but
I felt that since this is not a hot path there was no reason to perform=
 a busy-wait
style of loop here and yield to someone else.

As for the completion/poll, I did consider that but couldn=E2=80=99t co=
me up with a clean
way of implementing given how we designed the notification/cleanup mech=
anism
(really just a failed recovery). We can certainly look at doing that as=
 an
enhancement in the future.

>> +	if (likely(ctxid < MAX_CONTEXT)) {
>> +retry:
>> +		rc =3D mutex_lock_interruptible(&cfg->ctx_tbl_list_mutex);
>> +		if (rc)
>> +			goto out;
>> +
>> +		ctxi =3D cfg->ctx_tbl[ctxid];
>> +		if (ctxi)
>> +			if ((file && (ctxi->file !=3D file)) ||
>> +			    (!file && (ctxi->ctxid !=3D rctxid)))
>> +				ctxi =3D NULL;
>> +
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
>=20
> Please just create a loop rather than this goto retry.

Okay.

>> +	rhte_checkin(ctxi, rhte);
>> +	cxlflash_lun_detach(gli);
>> +
>> +out:
>> +	if (unlock_ctx)
>> +		mutex_unlock(&ctxi->mutex);
>=20
> Where is the matching lock for this?

One of the main design points of our context serialization strategy is =
that
any context returned from get_context() has been fully validated, will =
not
be removed from under you, and _is holding the context mutex_. Thus
for each of these mutex_unlock(ctxi) you see at the bottom of external
entry points, the mutex was obtained in get_context().

>> +	char *tmp =3D NULL;
>> +	size_t size;
>> +	struct afu *afu =3D cfg->afu;
>> +	struct ctx_info *ctxi =3D NULL;
>> +	struct sisl_rht_entry *rhte;
>> +
>> +	size =3D (MAX_RHT_PER_CONTEXT * sizeof(*ctxi->rht_lun));
>> +	size +=3D sizeof(*ctxi);
>> +
>> +	tmp =3D kzalloc(size, GFP_KERNEL);
>=20
> Just do two allocs. One for ctxi and one for rht_lun.  This is overly
> complicated.

I disagree that it=E2=80=99s overly complicated. The intention here was=
 to get this
stuff together to avoid multiple function calls and possibly help out p=
erf-wise
via locality. That said, I=E2=80=99m not opposed to performing multiple=
 allocations.

Look for this in v5.

>=20
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
> Yuck=E2=80=A6 just do two allocs rather than this throbbing.

You got it.

>> +out:
>> +	if (unlock_ctx)
>> +		mutex_unlock(&ctxi->mutex);
>=20
> Where is the matching lock for this?

See earlier comment about get_context().

>> +	if (likely(ctxi))
>> +		mutex_unlock(&ctxi->mutex);
>=20
> Where is the matching lock for this?

Ditto.

>> +	file =3D cxl_get_fd(ctx, &cfg->cxl_fops, &fd);
>=20
> You should create a new fops for each call here.  We write the fops t=
o fill it
> out.  I think it=E2=80=99ll work as you have now but it's a bit dodgy=
=2E

Are you saying that instead of having a single fops for the device, eac=
h of our
context=E2=80=99s should have an fops that we pass here?

>> +	list_add(&lun_access->list, &ctxi->luns);
>> +	mutex_unlock(&ctxi->mutex);
>=20
> Where is the matching lock for this?

Just like with get_context(), we leave create_context() with the mutex =
held.

>> +	rc =3D cxlflash_lun_attach(gli, MODE_PHYSICAL);
>> +	if (unlikely(rc)) {
>> +		dev_err(dev, "%s: Failed to attach to LUN! (PHYSICAL)\n",
>=20
> Is this going to spam the console from userspace?  Same below.

With a well-behaved application it shouldn=E2=80=99t We can certainly l=
ook at moving
to a debug if you feel it=E2=80=99s likely that someone would use this =
to spam the
console.

>> +	struct cxlflash_cfg *cfg =3D (struct cxlflash_cfg *)sdev->host->ho=
stdata;
>> +	struct afu *afu =3D cfg->afu;
>> +	struct dk_cxlflash_hdr *hdr;
>> +	char buf[MAX_CXLFLASH_IOCTL_SZ];
>=20
> why is buf not just a =E2=80=9Cunion cxlflash_ioctls"?

Because I wanted you to have to look up this define? ;)

In all seriousness, we originally had this define as a stand-alone valu=
e (it
wasn=E2=80=99t tied to the union). When I implemented the union, I figu=
red the define
was more self-descriptive in what we were trying to convey. I=E2=80=99l=
l change it
over to the union in v5.

>> +	hdr =3D (struct dk_cxlflash_hdr *)&buf;
>> +	if (hdr->version !=3D 0) {
>> +		pr_err("%s: Version %u not supported for %s\n",
>> +		       __func__, hdr->version, decode_ioctl(cmd));
>> +		rc =3D -EINVAL;
>> +		goto cxlflash_ioctl_exit;
>> +	}
>=20
> Do you advertise this version anywhere?  Users just have to call it a=
nd fail?

We don=E2=80=99t. We can add a version define to the exported ioctl hea=
der.

> You should check hdr->flags are zero incase some new userspace tries =
to set
> them.  Same for hdr->rsvd.

We can=E2=80=99t do that for the flags because those they are used for =
some of the ioctls.
The reserved=E2=80=99s however _can_ be checked under the version 0 cla=
use.

> Also, can you do these checks earlier.  It seems you've already done =
a bunch of
> stuff before here.

=46rom a runtime perspective, we haven=E2=80=99t actually done that muc=
h prior to the version
check. I suppose we could put the check earlier but I don=E2=80=99t lik=
e the idea of touching
data that hasn=E2=80=99t been copied in. So we would need to copy in ju=
st the header, then
check the version. Then if it=E2=80=99s valid, copy in the rest. At som=
e point later on if/when more
versions are supported we might need to do something like this, but I t=
hink it seems a
bit silly to do that now.

>=20
>> +
>> +	rc =3D do_ioctl(sdev, (void *)&buf);
>> +	if (likely(!rc))
>> +		if (unlikely(copy_to_user(arg, &buf, size))) {
>> +			pr_err("%s: copy_to_user() fail! "
>> +			       "size=3D%lu cmd=3D%d (%s) arg=3D%p\n",
>> +			       __func__, size, cmd, decode_ioctl(cmd), arg);
>> +			rc =3D -EFAULT;
>> +		}
>> +
>> +	/* fall through to exit */
>> +
>> +cxlflash_ioctl_exit:
>> +	if (unlikely(rc && known_ioctl))
>> +		pr_err("%s: ioctl %s (%08X) on dev(%d/%d/%d/%llu) "
>> +		       "returned rc %d\n", __func__,
>> +		       decode_ioctl(cmd), cmd, shost->host_no,
>> +		       sdev->channel, sdev->id, sdev->lun, rc);
>> +	else
>> +		pr_debug("%s: ioctl %s (%08X) on dev(%d/%d/%d/%llu) "
>> +			 "returned rc %d\n", __func__, decode_ioctl(cmd),
>> +			 cmd, shost->host_no, sdev->channel, sdev->id,
>> +			 sdev->lun, rc);
>> +	return rc;
>> +}
>> +
>=20
> git am complains about this trailing new line.

Consider it removed then.

>> +#define DK_CXLFLASH_ATTACH		CXL_IOWR(0x80, dk_cxlflash_attach)
>> +#define DK_CXLFLASH_USER_DIRECT		CXL_IOWR(0x81, dk_cxlflash_udirect=
)
>> +#define DK_CXLFLASH_RELEASE		CXL_IOWR(0x84, dk_cxlflash_release)
>> +#define DK_CXLFLASH_DETACH		CXL_IOWR(0x85, dk_cxlflash_detach)
>> +#define DK_CXLFLASH_VERIFY		CXL_IOWR(0x86, dk_cxlflash_verify)
>> +#define DK_CXLFLASH_RECOVER_AFU		CXL_IOWR(0x88, dk_cxlflash_recover=
_afu)
>> +#define DK_CXLFLASH_MANAGE_LUN		CXL_IOWR(0x89, dk_cxlflash_manage_l=
un)
>=20
> I'm not sure I'd leave these sparse.  What happens if the vlun patche=
s don't
> get in?

I do agree with you. I had wanted to keep them like this as their order=
ing matched
closer with how they are expected to be used. That said, I=E2=80=99m ok=
ay with moving
them around to avoid the sparseness.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

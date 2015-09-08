From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH v6 2/3] cxlflash: Superpipe support
Date: Tue, 8 Sep 2015 11:48:52 -0500
Message-ID: <D0422C89-61B1-48FC-8D69-4DC3D3B6548F@linux.vnet.ibm.com>
References: <1439520463-56798-1-git-send-email-mrochs@linux.vnet.ibm.com> <55DE3D30.6000505@linux.vnet.ibm.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2102\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e17.ny.us.ibm.com ([129.33.205.207]:59729 "EHLO
	e17.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454AbbIHQtt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Sep 2015 12:49:49 -0400
Received: from /spool/local
	by e17.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Tue, 8 Sep 2015 12:49:48 -0400
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id 6EF2AC9003E
	for <linux-scsi@vger.kernel.org>; Tue,  8 Sep 2015 12:40:50 -0400 (EDT)
Received: from d01av05.pok.ibm.com (d01av05.pok.ibm.com [9.56.224.195])
	by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t88GncPG58785862
	for <linux-scsi@vger.kernel.org>; Tue, 8 Sep 2015 16:49:46 GMT
Received: from d01av05.pok.ibm.com (localhost [127.0.0.1])
	by d01av05.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t88GnBJX027227
	for <linux-scsi@vger.kernel.org>; Tue, 8 Sep 2015 12:49:13 -0400
In-Reply-To: <55DE3D30.6000505@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, wenxiong@linux.vnet.ibm.com, mikey@neuling.org, dja@ozlabs.au.ibm.com, benh@kernel.crashing.org, hch@infradead.org, imunsie@au1.ibm.com, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

Brian,

Thanks for reviewing. Comments inline below. We=92ll try to address mos=
t
of these in the 4.3 rc phase. =20


-matt

> On Aug 26, 2015, at 5:26 PM, Brian King <brking@linux.vnet.ibm.com> w=
rote:
>=20
> Hi Matt,
>=20
> Some comments below. I'm happy to see this one get merged as-is, as l=
ong as
> these issues can get addressed in a follow on patch.
>=20
> Reviewed-by: Brian King <brking@linux.vnet.ibm.com>
>=20
> On 08/13/2015 09:47 PM, Matthew R. Ochs wrote:
>> +/**
>> + * cxlflash_term_global_luns() - frees resources associated with gl=
obal LUN list
>> + */
>> +void cxlflash_term_global_luns(void)
>> +{
>> +	struct glun_info *gli, *temp;
>> +
>> +	mutex_lock(&global.mutex);
>> +	list_for_each_entry_safe(gli, temp, &global.gluns, list) {
>> +		list_del(&gli->list);
>> +		kfree(gli);
>=20
> Comments below regarding refcounting this.

Okay.

>> +	}
>> +	mutex_unlock(&global.mutex);
>> +}
>> +
>> +/**
>> + * cxlflash_manage_lun() - handles LUN management activities
>> + * @sdev:	SCSI device associated with LUN.
>> + * @manage:	Manage ioctl data structure.
>> + *
>> + * This routine is used to notify the driver about a LUN's WWID and=
 associate
>> + * SCSI devices (sdev) with a global LUN instance. Additionally it =
serves to
>> + * change a LUN's operating mode: legacy or superpipe.
>> + *
>> + * Return: 0 on success, -errno on failure
>> + */
>> +int cxlflash_manage_lun(struct scsi_device *sdev,
>> +			struct dk_cxlflash_manage_lun *manage)
>> +{
>> +	int rc =3D 0;
>> +	struct llun_info *lli =3D NULL;
>> +	u64 flags =3D manage->hdr.flags;
>> +	u32 chan =3D sdev->channel;
>> +
>> +	lli =3D find_and_create_lun(sdev, manage->wwid);
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
>> +	if (flags & DK_CXLFLASH_MANAGE_LUN_ENABLE_SUPERPIPE) {
>> +		if (lli->newly_created)
>> +			lli->port_sel =3D CHAN2PORT(chan);
>> +		else
>> +			lli->port_sel =3D BOTH_PORTS;
>> +		/* Store off lun in unpacked, AFU-friendly format */
>> +		lli->lun_id[chan] =3D lun_to_lunid(sdev->lun);
>> +		sdev->hostdata =3D lli;
>> +	} else if (flags & DK_CXLFLASH_MANAGE_LUN_DISABLE_SUPERPIPE) {
>> +		if (lli->parent->mode !=3D MODE_NONE)
>> +			rc =3D -EBUSY;
>> +		else
>> +			sdev->hostdata =3D NULL;
>=20
> I don't see any locking in this function. What if you had two process=
es calling
> this ioctl at the same time with different parameters? Could we get i=
nto a strange
> state?

There is a lock taken inside the find_and_create_lun() routine, so we=92=
re protected there
in terms of deriving a local lun reference. However we should extend th=
at outside as well
to protect the local lun updates that are made after obtaining the refe=
rence.

>> @@ -2439,6 +2470,9 @@ static int __init init_cxlflash(void)
>>  */
>> static void __exit exit_cxlflash(void)
>> {
>> +	cxlflash_term_global_luns();
>> +	cxlflash_free_errpage();
>=20
> Both these functions free up memory. I'm concerned that memory could =
still be in use.
> You probably need to add some refcounting to your global objects so y=
ou know when you
> can free them up. kref is your friend.

I don=92t think there=92s an issue if we put these after the call to pc=
i_unregister_driver() as that
will tear down any remaining users of this global memory. That said, I =
do agree with the value
of kref and we will look into using it for the global luns and other ob=
jects. The error page I view
as more of a =91allocate once and leave it=92 type of object due to the=
 fact that it is relied upon in
error paths.

>=20
>> +
>> 	pci_unregister_driver(&cxlflash_driver);
>> }
>>=20
>> diff --git a/drivers/scsi/cxlflash/sislite.h b/drivers/scsi/cxlflash=
/sislite.h
>> index bf5d399..66b8891 100644
>> --- a/drivers/scsi/cxlflash/sislite.h
>> +++ b/drivers/scsi/cxlflash/sislite.h
>> @@ -409,7 +409,10 @@ struct sisl_lxt_entry {
>>=20
>> };
>>=20
>> -/* Per the SISlite spec, RHT entries are to be 16-byte aligned */
>> +/*
>> + * RHT - Resource Handle Table
>> + * Per the SISlite spec, RHT entries are to be 16-byte aligned
>> + */
>> struct sisl_rht_entry {
>> 	struct sisl_lxt_entry *lxt_start;
>> 	u32 lxt_cnt;
>=20
>> +/**
>> + * cxlflash_stop_term_user_contexts() - stops/terminates known user=
 contexts
>> + * @cfg:	Internal structure associated with the host.
>> + *
>> + * When the host needs to go down, all users must be quiesced and t=
heir
>> + * memory freed. This is accomplished by putting the contexts in er=
ror
>> + * state which will notify the user and let them 'drive' the tear-d=
own.
>> + * Meanwhile, this routine camps until all user contexts have been =
removed.
>=20
> Can you clarify this a bit more? What if the user ignores this notifi=
cation?
> Perhaps the process has been sent a SIGSTOP or the process is misbeha=
ved.
> Will we ever exit this loop? Are we actually dependent on the user pr=
ocess to
> do something to exit this loop?

The =92notification=92 the user receives will be their inability to fun=
ction. So the user
could ignore but they won=92t be able to make any forward progress unti=
l they
recover.

If the process goes away we are notified (release() called on exit) and=
 will take
the appropriate cleanup actions. In such a case the loop would exit.

We have discussed a timeout approach in the past for the case where the=
 user
never comes back but were unable to arrive at a value or the best manne=
r in
which to tell the user they=92re being permanently removed. We can have=
 those
discussions again and look at arriving at something safer.

>> +static int read_cap16(struct scsi_device *sdev, struct llun_info *l=
li)
>> +{
>> +	struct cxlflash_cfg *cfg =3D (struct cxlflash_cfg *)sdev->host->ho=
stdata;
>> +	struct device *dev =3D &cfg->dev->dev;
>> +	struct glun_info *gli =3D lli->parent;
>> +	u8 *cmd_buf =3D NULL;
>> +	u8 *scsi_cmd =3D NULL;
>> +	u8 *sense_buf =3D NULL;
>> +	int rc =3D 0;
>> +	int result =3D 0;
>> +	int retry_cnt =3D 0;
>> +	u32 tout =3D (MC_DISCOVERY_TIMEOUT * HZ);
>=20
> Looks like you are using only a 5 second timeout for this. sd.c uses =
30 seconds.=20
> 5 might be a bit on the short side.

Okay, will look at using a larger value.

>=20
>> +
>> +/**
>> + * cxlflash_lun_detach() - detaches a user from a LUN and resets th=
e LUN's mode
>> + * @gli:	LUN to detach.
>> + */
>> +void cxlflash_lun_detach(struct glun_info *gli)
>> +{
>> +	mutex_lock(&gli->mutex);
>> +	WARN_ON(gli->mode =3D=3D MODE_NONE);
>> +	if (--gli->users =3D=3D 0)
>> +		gli->mode =3D MODE_NONE;
>=20
> It looks like the only place you free this struct glun_info object is=
 when your
> module gets unloaded. Would be nice if it got freed up when it was no=
 longer in
> use, but to do this will require some re-work on how you manage refer=
ence counting
> in this object. You probably also want to use a kref to manage the ob=
ject lifetime
> rather than inventing your own.

I think you=92re misinterpreting this code a bit.

This routine (and its counterpart - =91attach=92) keep track of how a k=
nown, existing
LUN is being used: either directly (user-mediated physical access) or v=
irtually
(kernel-mediated virtual access). One of the key design points required=
 to support
the virtual LUN feature is that a LUN cannot be accessed simultaneously=
 by users
with differing usage mode requirements. A user with direct access could=
 simply
overwrite storage provisioned for a user with virtual access. Thus, the=
 =91user=92 count
going to 0 is not indicative of the LUN going away, but rather returnin=
g to a neutral
state. We=92ll take a look at how we could migrate this logic to a kref=
=2E

With regard to actually freeing the global lun object when it=92s no lo=
nger in use, we
will investigate how to best implement this.

>> +	/* Reset the file descriptor to indicate we're on a close() thread=
 */
>> +	ctxi->lfd =3D -1;
>> +	detach.context_id =3D ctxi->ctxid;
>> +	list_for_each_entry_safe(lun_access, t, &ctxi->luns, list)
>> +		_cxlflash_disk_detach(lun_access->sdev, ctxi, &detach);
>=20
> I think you have a potential oops here. If you have a user context cr=
eated for
> an scsi device, you then delete the scsi device via sysfs, then, if t=
here is any
> way to go down this path, which I would hope there is, otherwise you =
have a
> different issue, then you may pass an sdev pointer that now points to=
 freed memory.

Yes, agree there is an issue here.

>=20
> There are a couple possible ways you could solve this.
>=20
> 1. It might work to use scsi_get_device / scsi_put_device to get / pu=
t a reference to the scsi device
>   for each user context associated with it.
> 2. The other option would be to implement a slave_destroy function an=
d have it kill off
>   any open user contexts.

Will likely go with option 1 (prototype looks promising).

>> +		list_for_each_entry(lun_access, &ctxi->luns, list)
>> +			if (lun_access->lli =3D=3D lli) {
>> +				dev_dbg(dev, "%s: Already attached!\n",
>> +					__func__);
>> +				rc =3D -EINVAL;
>> +				goto out;
>> +			}
>> +	}
>> +
>> +	lun_access =3D kzalloc(sizeof(*lun_access), GFP_KERNEL);
>> +	if (unlikely(!lun_access)) {
>=20
> You can ditch the unlikely throughout all your ioctls. ioctls are not=
 a performance path.

We=92ll look at cutting some of these back, although I think many of th=
em make sense
where they=92re at and aren=92t hurting anything.

>> +out_attach:
>> +	attach->hdr.return_flags =3D 0;
>> +	attach->context_id =3D ctxi->ctxid;
>> +	attach->block_size =3D gli->blk_len;
>> +	attach->mmio_size =3D sizeof(afu->afu_map->hosts[0].harea);
>> +	attach->last_lba =3D gli->max_lba;
>> +	attach->max_xfer =3D (sdev->host->max_sectors * 512) / gli->blk_le=
n;
>=20
> Would be better to use a literal instead of a magic number here.

Agreed, will change.

>> +	/* Test if in error state */
>> +	reg =3D readq_be(&afu->ctrl_map->mbox_r);
>=20
> By the time this read completes, pdev->error_state is already set to =
pci_channel_io_frozen. If that
> is not the case here, we need to fix that. You should be able to just=
 use pci_channel_offline(pdev) here
> and not need any delay.

The delay is in place because we=92re waiting for our own internal stat=
e machine
to catch up (flipped to RESET in the EEH error_detected() callback. If =
we can
find a way to integrate the pci_channel_offline() check to avoid the sl=
ight delay
without over complicating things I=92d be open to adopting that, howeve=
r I don=92t
see much of an issue with taking a short break here.

I=92ll also add that when we adopted this, there was a bug in the CXL v=
phb
services where they are not propagating the error_state. I believe that=
 was
fixed in the upstreamed CXL EEH code.

>=20
>> +	if (reg =3D=3D -1) {
>> +		dev_dbg(dev, "%s: MMIO read fail! Wait for recovery...\n",
>> +			__func__);
>> +		mutex_unlock(&ctxi->mutex);
>> +		ctxi =3D NULL;
>> +		ssleep(1);
>> +		rc =3D check_state(cfg);
>> +		if (unlikely(rc))
>> +			goto out;
>> +		goto retry;
>> +	}
>> +
>> +	dev_dbg(dev, "%s: MMIO working, no recovery required!\n", __func__=
);
>> +out:


>> +/* Chunk size parms: note sislite minimum chunk size is
>> +   0x10000 LBAs corresponding to a NMASK or 16.
>> +*/
>> +#define MC_CHUNK_SIZE     (1 << MC_RHT_NMASK)	/* in LBAs */
>> +
>> +#define MC_DISCOVERY_TIMEOUT 5  /* 5 secs */
>=20
> Seems like the only place you use this is for the read capacity you i=
ssue,
> so MC_READ_CAP timeout might be more accurate.

This name was a holdover from when the timeout was used in
various places. Will change it now that its scope is well-defined.

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH v4 2/3] cxlflash: Superpipe support
Date: Wed, 12 Aug 2015 12:05:05 -0500
Message-ID: <38EC3DE3-C49C-406F-BC55-C5BC78F23293@linux.vnet.ibm.com>
References: <1439226588-7886-1-git-send-email-mrochs@linux.vnet.ibm.com> <1439270596.5081.58.camel@neuling.org> <164CACE9-6195-4F1C-AA23-779FFF7D9DF8@linux.vnet.ibm.com> <1439351675.28873.57.camel@neuling.org>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2102\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:53194 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753733AbbHLRFL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Aug 2015 13:05:11 -0400
Received: from /spool/local
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Wed, 12 Aug 2015 11:05:11 -0600
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id 4408438C8026
	for <linux-scsi@vger.kernel.org>; Wed, 12 Aug 2015 13:05:08 -0400 (EDT)
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t7CH58a751773576
	for <linux-scsi@vger.kernel.org>; Wed, 12 Aug 2015 17:05:08 GMT
Received: from d01av02.pok.ibm.com (localhost [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t7CH54hH030399
	for <linux-scsi@vger.kernel.org>; Wed, 12 Aug 2015 13:05:08 -0400
In-Reply-To: <1439351675.28873.57.camel@neuling.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Neuling <mikey@neuling.org>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, brking@linux.vnet.ibm.com, wenxiong@linux.vnet.ibm.com, hch@infradead.org, imunsie@au1.ibm.com, dja@ozlabs.au.ibm.com, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

> On Aug 11, 2015, at 10:54 PM, Michael Neuling <mikey@neuling.org> wro=
te:
>=20
>=20
>>>> +		pr_debug("%s: Wait for user context to quiesce...\n", __func__)=
;
>>>> +		wake_up_all(&cfg->limbo_waitq);
>>>> +		ssleep(1);
>>>=20
>>> Why 1 sec and why in a loop?  Can=E2=80=99t you poll/wait for compl=
etion somewhere?
>>=20
>> This routine is called when the device is being removed and we need =
to stall until
>> the user contexts are made aware of removal [by marking them in erro=
r] and have
>> completely gone away [there are no longer any contexts in our table =
or list].
>>=20
>> The 1 second sleep is simply to give the users time to cleanup once =
they see
>> the notification. We can make it a larger/smaller value or remove it=
 entirely, but
>> I felt that since this is not a hot path there was no reason to perf=
orm a busy-wait
>> style of loop here and yield to someone else.
>>=20
>> As for the completion/poll, I did consider that but couldn=E2=80=99t=
 come up with a clean
>> way of implementing given how we designed the notification/cleanup m=
echanism
>> (really just a failed recovery). We can certainly look at doing that=
 as an
>> enhancement in the future.
>=20
> Does the API allow this flexibility in the future?

Yes, I believe it is flexible enough where it could allow for this.

>>=20
>>>> +	rhte_checkin(ctxi, rhte);
>>>> +	cxlflash_lun_detach(gli);
>>>> +
>>>> +out:
>>>> +	if (unlock_ctx)
>>>> +		mutex_unlock(&ctxi->mutex);
>>>=20
>>> Where is the matching lock for this?
>>=20
>> One of the main design points of our context serialization strategy =
is that
>> any context returned from get_context() has been fully validated, wi=
ll not
>> be removed from under you, and _is holding the context mutex_. Thus
>> for each of these mutex_unlock(ctxi) you see at the bottom of extern=
al
>> entry points, the mutex was obtained in get_context().
>=20
> Should we have something like put_context() that does this?  So there=
 is
> matching calls to get/put_context

Yes, this is a really good idea (I wish I=E2=80=99d thought of it ;)) t=
hat will make for
better code. Look for it in v5!

>=20
>>=20
>>>> +	char *tmp =3D NULL;
>>>> +	size_t size;
>>>> +	struct afu *afu =3D cfg->afu;
>>>> +	struct ctx_info *ctxi =3D NULL;
>>>> +	struct sisl_rht_entry *rhte;
>>>> +
>>>> +	size =3D (MAX_RHT_PER_CONTEXT * sizeof(*ctxi->rht_lun));
>>>> +	size +=3D sizeof(*ctxi);
>>>> +
>>>> +	tmp =3D kzalloc(size, GFP_KERNEL);
>>>=20
>>> Just do two allocs. One for ctxi and one for rht_lun.  This is over=
ly
>>> complicated.
>>=20
>> I disagree that it=E2=80=99s overly complicated. The intention here =
was to get this
>> stuff together to avoid multiple function calls and possibly help ou=
t perf-wise
>> via locality. That said, I=E2=80=99m not opposed to performing multi=
ple allocations.
>=20
> I'm not sure I buy it's a performance issue on create_context().  How
> often are you calling that?  Doesn't that do a lot of things other th=
an
> just this?
>=20
> Anyway if you want to do that, that's ok I guess, but you need to
> document why and what you=E2=80=99re doing.

We=E2=80=99ve already made the change to perform multiple allocations a=
nd
are =E2=80=98okay=E2=80=99 with that.

>>>> +	hdr =3D (struct dk_cxlflash_hdr *)&buf;
>>>> +	if (hdr->version !=3D 0) {
>>>> +		pr_err("%s: Version %u not supported for %s\n",
>>>> +		       __func__, hdr->version, decode_ioctl(cmd));
>>>> +		rc =3D -EINVAL;
>>>> +		goto cxlflash_ioctl_exit;
>>>> +	}
>>>=20
>>> Do you advertise this version anywhere?  Users just have to call it=
 and fail?
>>=20
>> We don=E2=80=99t. We can add a version define to the exported ioctl =
header.
>=20
> It needs to be exported dynamically by the kernel.  Not the headers.
> Think new software on old kernel and visa versa.

Okay, will look into this.

>>>> +#define DK_CXLFLASH_ATTACH		CXL_IOWR(0x80, dk_cxlflash_attach)
>>>> +#define DK_CXLFLASH_USER_DIRECT		CXL_IOWR(0x81, dk_cxlflash_udire=
ct)
>>>> +#define DK_CXLFLASH_RELEASE		CXL_IOWR(0x84, dk_cxlflash_release)
>>>> +#define DK_CXLFLASH_DETACH		CXL_IOWR(0x85, dk_cxlflash_detach)
>>>> +#define DK_CXLFLASH_VERIFY		CXL_IOWR(0x86, dk_cxlflash_verify)
>>>> +#define DK_CXLFLASH_RECOVER_AFU		CXL_IOWR(0x88, dk_cxlflash_recov=
er_afu)
>>>> +#define DK_CXLFLASH_MANAGE_LUN		CXL_IOWR(0x89, dk_cxlflash_manage=
_lun)
>>>=20
>>> I'm not sure I'd leave these sparse.  What happens if the vlun patc=
hes don't
>>> get in?
>>=20
>> I do agree with you. I had wanted to keep them like this as their or=
dering matched
>> closer with how they are expected to be used. That said, I=E2=80=99m=
 okay with moving
>> them around to avoid the sparseness.
>=20
> Yeah, plus it breaks your table in the ioctl

Right. We had originally thought about adding reserved placeholders to
avoid the breakage in the ioctl table but have gone ahead and just reor=
dered.

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

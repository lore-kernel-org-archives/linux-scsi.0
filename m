Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32D2F335BA5
	for <linux-scsi@vger.kernel.org>; Thu,  4 Sep 2025 18:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757009176; cv=none; b=jVeNiQI1x0BxJqy3dqTT0yLwIP76GQA4m+QdMPB6lXEePVoFKKZL42cbzmxISqUldc2QaKjzC4GV8hArkfIZ0GxkXjqqm6WIbuqQIOwMopGRK+6ff4Lz57ouOqCi+tyC0+lRWIkNd4PexXxmexD42LVJ3JJ8n+IgNxXoUugdhAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757009176; c=relaxed/simple;
	bh=uuPIjEaR/kJ4cQ/V6qHiqDtLPlnck4iEGKM3LLytRvg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=j80NiGYbdEu1pAcGAW4SWEpUp+u1GuXrZ67FY6mLiKnx3NHPYzdkWEo1MeBHYmMq69tYZsryi0x6amhqizvcoUHs/Gq3yntN77ugSXvUsIVtv8EZa0X4qBlK3qNh8GT8Y4CeAmHrwstUtlhCj2Pzapd6gdtMJSmgLbr2rQlOItM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=duO8kbRB; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="duO8kbRB"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cHnTp6VcPzlgqVV;
	Thu,  4 Sep 2025 18:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1757009163; x=1759601164; bh=OC8qCaiETXgjdhM+/T7KUFHL
	jN3c+WQdu4cCTEjIn0I=; b=duO8kbRBYGZlvUl6TXGdc6cazQUrAxD0QWMSXysw
	yiqBl4gl29qfyMf3fOjZdyGGVahG+HlOjl1yjaP53a9TKLWNCuJ5J9fBZox8X/1T
	BVfhZPo19xtDrUOq77+xG7dTB+CBcjWrJw16UYpschlXZsf/pO7sWRT8T+MMyCCs
	7lqQXos+mGObdMbA7cpPF0sHbtvmOOIKxDDA2MDvjgWo2QURtYHeX492BdYfstQd
	t8MlHjH6/Vt8wMmXP12PW4W+U6TH2RR0xm5eoNjqeYgEl9y7hm05dWzXotx0qERx
	EbyqAPLO9idoF+tI0Bl6+cMIs6fTesdcuU1p51C90DdjiQ==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id XP4NDU6OPPWY; Thu,  4 Sep 2025 18:06:03 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cHnTh1CGlzlgn8k;
	Thu,  4 Sep 2025 18:05:59 +0000 (UTC)
Message-ID: <ff39215f-3900-426b-a273-60c7ebe83c82@acm.org>
Date: Thu, 4 Sep 2025 11:05:58 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 02/26] scsi: core: Support allocating a pseudo SCSI
 device
To: John Garry <john.g.garry@oracle.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250827000816.2370150-1-bvanassche@acm.org>
 <20250827000816.2370150-3-bvanassche@acm.org>
 <5070296c-5fd2-4698-88f2-0870caab051f@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <5070296c-5fd2-4698-88f2-0870caab051f@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 9/4/25 2:29 AM, John Garry wrote:
> On 27/08/2025 01:06, Bart Van Assche wrote:
>> --- a/drivers/scsi/scsi_scan.c
>> +++ b/drivers/scsi/scsi_scan.c
>> @@ -365,7 +365,7 @@ static struct scsi_device *scsi_alloc_sdev(struct=20
>> scsi_target *starget,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 scsi_sysfs_device_initialize(sdev);
>=20
> is the pseudo sdev visible in sysfs?

Pseudo SCSI devices are not visible in sysfs.=20
scsi_sysfs_device_initialize() does not make a SCSI device visible in=20
sysfs - it initializes multiple data structures and also includes some
code that is important but not related to sysfs visibility. As an
example, the dev_set_name() calls in that function initialize names that
are used by SCSI tracing code.

>> @@ -1077,7 +1077,7 @@ static int scsi_add_lun(struct scsi_device=20
>> *sdev, unsigned char *inq_result,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 else if (*bflags & BLIST_MAX_1024)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 lim.max_hw_sect=
ors =3D 1024;
>> -=C2=A0=C2=A0=C2=A0 if (hostt->sdev_configure)
>> +=C2=A0=C2=A0=C2=A0 if (!scsi_device_is_pseudo_dev(sdev) && hostt->sde=
v_configure)
>=20
> we also have an sdev_configure check later for calling=20
> scsi_realloc_sdev_budget_map() (not shown) - should we have that call=20
> (to scsi_realloc_sdev_budget_map())?

No, since the budget map is not used for pseudo SCSI devices. I will
make sure that scsi_realloc_sdev_budget_map() is not called for pseudo
SCSI devices.

>=20
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D hostt->=
sdev_configure(sdev, &lim);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret) {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 queue_limits_ca=
ncel_update(sdev->request_queue);
>=20
> should we really be updating the queue limits (not shown) for the pseud=
o=20
> sdev?

As far as I can tell the queue limit update calls in scsi_scan.c are
only relevant if BLIST_MAX_512 and/or BLIST_MAX_1024 have been set.=20
These flags are not set for pseudo SCSI devices and hence updating the
queue limits for pseudo SCSI devices is not necessary.

> don't we already have a pointer to pseudo_sdev in shost->pseudo_sdev?
>=20
>> +=C2=A0=C2=A0=C2=A0 if (pseudo_sdev)
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __scsi_remove_device(pseud=
o_sdev);

Indeed. Let's use that pointer here.

> can we do better than jumping backwards? Maybe
>=20
>=20
>  =C2=A0=C2=A0=C2=A0=C2=A0sdev =3D scsi_alloc_sdev(starget, U64_MAX, NUL=
L);
>  =C2=A0=C2=A0=C2=A0=C2=A0if (!sdev) {
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 scsi_target_reap(starget);
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto put_target;
>=20
>  =C2=A0=C2=A0=C2=A0=C2=A0}

I will include this change.

>> +}
>> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
>> index 169af7d47ce7..f1d509f74f17 100644
>> --- a/drivers/scsi/scsi_sysfs.c
>> +++ b/drivers/scsi/scsi_sysfs.c
>> @@ -1406,6 +1406,8 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev=
)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int error;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct scsi_target *starget =3D sdev->s=
dev_target;
>> +=C2=A0=C2=A0=C2=A0 WARN_ON_ONCE(scsi_device_is_pseudo_dev(sdev));
>=20
> should we also error out?

That sounds good to me.

> Can we seem to be able to call this from scsi_add_lun() - is that prope=
r?

It's a bug that should be fixed. I didn't hit that code path because I=20
only tested asynchronous scanning. I will include a fix when I repost=20
this patch.

Thanks,

Bart.

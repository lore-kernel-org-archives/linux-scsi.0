Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5040E1A26B;
	Sat, 15 Nov 2025 14:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763218064; cv=none; b=FOeEZfUWs5u5jZA74bsBhk8Rxm0rGuZ1WoW4PT7EHEVta5wQNZql+UdPHkVT90l7kTbk4xFFHOdDy1zdwT+11hCO9M9HdA16d/xaVxuzBaXqL+7a3HZoBJXUT+67dxiKJSp7nYNHBWRhs6UcSgDPQfAoafNXERcd32XmM3Fqf9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763218064; c=relaxed/simple;
	bh=DtVyaocamF2XnHxHLcNkdPTZQRdWJJI2TADaZM6pXtY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hCDjAnf+Ms6zxzEwAsLnAbFRYRSBCMQQlTxws97fk6T17+NLPEuVF8qvXNnv38DkFC58dSV/y0GUq2nW5gqrBMiyceHIMi2NXQb1VLo2A6qFk1OEanx1CqKhX5elrns5Xirj59mGyRqb/JHOjTpqTUBXxGCHE1/6vdDqlYTnr7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=l6MxPW0a; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="l6MxPW0a"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4d7xgd1WVXzltBJT;
	Sat, 15 Nov 2025 14:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1763218058; x=1765810059; bh=P79j1cgziIJPVcPKfQEwOesX
	/bPDlpX0tbV4vXwm4WQ=; b=l6MxPW0aePAfrp2o2mjju8qBN90oTH+PqZcArpCb
	WAkT0uGL7GVcTdRQyLi4UyXVfjJwR5b5sUQQYQq2bNbqzox3Xkm3hb2EaD2U6Jqx
	ht+KtTcFwh9Yp/HhZzVtJ33KiRJI33Gl8Zb/VuVuga+3PHPjAQWYxdOkMf4Sm8BA
	7zwYeU8NfpbusibdhUzRqSf3796yk4D+j4oZS9b9T8Ev+Q+qoneuzr6fs1XmYCFr
	kChjNSN2roK/mB7bco69dIhuX9bohTAPf+7ackUUmP0OROSiwUO7OR3SrS33dtsM
	1gPWpXgSa3J+9IpQAFsuMh/r3pRZuxhXydQuMVCUaw5S/Q==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id fwZL1N8fSYWH; Sat, 15 Nov 2025 14:47:38 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4d7xgF3j3YzltKNx;
	Sat, 15 Nov 2025 14:47:20 +0000 (UTC)
Message-ID: <d5185412-d49b-425f-85c5-54f0974818f1@acm.org>
Date: Sat, 15 Nov 2025 06:47:18 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFT v2] driver/scsi/mpi3mr: Fix build warning for
 mpi3mr_start_watchdog
To: =?UTF-8?Q?Bart=C5=82omiej_Kubik?= <kubik.bartlomiej@gmail.com>
Cc: sathya.prakash@broadcom.com, kashyap.desai@broadcom.com,
 sumit.saxena@broadcom.com, sreekanth.reddy@broadcom.com,
 martin.petersen@oracle.com, mpi3mr-linuxdrv.pdl@broadcom.com,
 linux-scsi@vger.kernel.org, skhan@linuxfoundation.org, khalid@kernel.org,
 david.hunter.linux@gmail.com,
 linux-kernel-mentees@lists.linuxfoundation.org, linux-kernel@vger.kernel.org
References: <20251028145534.95457-1-kubik.bartlomiej@gmail.com>
 <562fa035-c732-4bfc-8439-2279d029f72a@acm.org>
 <CAPqLRf1-zb3v2hMDexM4zCtAtr+yzwQdeSrkzssfo0rkmLo=mA@mail.gmail.com>
 <CAPqLRf2eyK2bRess785AB6C2+Mj4U1CGyT6n4spkJy+_gNc9-A@mail.gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <CAPqLRf2eyK2bRess785AB6C2+Mj4U1CGyT6n4spkJy+_gNc9-A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 11/15/25 6:31 AM, Bart=C5=82omiej Kubik wrote:
>>> diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mp=
i3mr_fw.c
>>> index 8fe6e0bf342e..18b176e358c5 100644
>>> --- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
>>> +++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
>>> @@ -2879,8 +2879,7 @@ void mpi3mr_start_watchdog(struct mpi3mr_ioc *m=
rioc)
>>>
>>>        INIT_DELAYED_WORK(&mrioc->watchdog_work, mpi3mr_watchdog_work)=
;
>>>        snprintf(mrioc->watchdog_work_q_name,
>>> -         sizeof(mrioc->watchdog_work_q_name), "watchdog_%s%d", mrioc=
->name,
>>> -         mrioc->id);
>>> +         sizeof(mrioc->watchdog_work_q_name), "watchdog_%s", mrioc->=
name);
>>>        mrioc->watchdog_work_q =3D alloc_ordered_workqueue(
>>>                "%s", WQ_MEM_RECLAIM, mrioc->watchdog_work_q_name);
>>>        if (!mrioc->watchdog_work_q) {
>> Leaving out mrioc->id from the workqueue name seems like an unacceptab=
le
>> behavior change to me.
>=20
> Add twice the same ID one after one. Is it not a mistake ??
> If mrioc->name has that same ID at the end.
>=20
> sprintf(mrioc->name, "%s%d", mrioc->driver_name, mrioc->id)
>=20
> watchdog_work_q_name is built from mrioc->name which has this ID at the=
 end.
> If I see correctly, if mrioc->id will be 1 then  watchdog_work_q_name
> will look like
> watchdog_mpi3mr11, but I think it should be watchdog_mpi3mr1, or am I m=
issing
> something??

I'm not sure - I'm not familiar myself with the mpi3mr driver. I will
let someone who is familiar with this driver comment on this.

Thanks,

Bart.

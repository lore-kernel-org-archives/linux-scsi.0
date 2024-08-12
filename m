Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E2FB16C854
	for <linux-scsi@vger.kernel.org>; Mon, 12 Aug 2024 20:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723494601; cv=none; b=lPOw0KZYUmJ5FqZlMTkh/n/QIhYE7iClqbnzYPMixG1Ip5SwkcMqwI3pBHOAjZm5oB4d8PKsfIW6jsmNSbffw6YS0FvpmlsJRinrtYiTLjhUS9MQ928/J/OeDbEVEGn2cymD8QODfN/GISRd+rTVkKDdDEdUGhN6/NnVg4fzw/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723494601; c=relaxed/simple;
	bh=tyq6t1VZnnJjLtHizymBoNN1tee0CdvsTxPK4a2sBSE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fC338jXdQzhABePBJsRRg0hMGW63N6mPOWqkgZSZUOoNtvi5M2/kYe2pShLSTDgNA48Gh8W+R1fcei8ugdcXnfytZl4VsV28P8U27S+fk+IUo5S1FQAXf2wQSltxrgiznRG0l16tkV3CdWCaUqeZgED9/GpQIlWzp10eyDPcSiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=TbyM/DIJ; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="TbyM/DIJ"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4WjR2t5wxrzlgVnF;
	Mon, 12 Aug 2024 20:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1723494595; x=1726086596; bh=DM0L1aEr5RMFeUJxuwJtPXX5
	RssdqhZRar4x/nVJKIY=; b=TbyM/DIJrfI6QKp8k9G4/ycas6aTAUWhPMFV55zk
	ItFygj+IxLJxZHHpazQ4xUFkMKpfWauwSVJhnOs76M9/YhGj0PAEZg2kydoxfl/f
	Fn27sNCixyjjolKT2V2g5vT8QsqKUb4kZ8nsnhaNn1Mo8LqHq7Rvbzwa1qbjfsfE
	+rjVZx5xINSNlp5p0IDxicGZ8e7T8bbcIoW3QwiA6zHKevx+8sKV6i6LobtML7ku
	MIU6jsftb+U4XsE2j3uFncpdoE0d5UqDYKLQXaoR+BBtGCnzQBwSxXM2SMZt7GPS
	dyRmsLnHAl1Hzf2iLtSLS5OMyoCnkE/JP8QkAPX1Yxgkcg==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id S2vSQ1O0YHTV; Mon, 12 Aug 2024 20:29:55 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4WjR2q2YvBzlgTGW;
	Mon, 12 Aug 2024 20:29:55 +0000 (UTC)
Message-ID: <43d83d78-9ae3-4dbe-98f5-9e9736442782@acm.org>
Date: Mon, 12 Aug 2024 13:29:54 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 4/5] Driver core: platform: Add
 devm_platform_get_irqs_affinity()
To: John Garry <john.g.garry@oracle.com>, lenb@kernel.org, rjw@rjwysocki.net,
 gregkh@linuxfoundation.org, tglx@linutronix.de, maz@kernel.org
Cc: linux-scsi@vger.kernel.org
References: <1606905417-183214-1-git-send-email-john.garry@huawei.com>
 <1606905417-183214-5-git-send-email-john.garry@huawei.com>
 <1d8d8bcc-e70e-45d1-b722-4931d2a65ae0@acm.org>
 <2839fb1b-0547-42e2-9f85-8acf43a2545d@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <2839fb1b-0547-42e2-9f85-8acf43a2545d@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 8/12/24 3:46 AM, John Garry wrote:
> On 09/08/2024 19:11, Bart Van Assche wrote:
>> On 12/2/20 2:36 AM, John Garry wrote:
>>> +=C2=A0=C2=A0=C2=A0 for (i =3D 0; i < nvec; i++) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int irq =3D platform_get_=
irq(dev, i);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (irq < 0) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 r=
et =3D irq;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 g=
oto err_free_devres;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ptr->irq[i] =3D irq;
>>> +=C2=A0=C2=A0=C2=A0 }
>>
>> (replying to an email from four years ago)
>>
>> Why does this function call platform_get_irq(dev, i) instead of
>> platform_get_irq(dev, affd->pre_vectors + i)? Is there perhaps somethi=
ng
>> about the hisi_sas driver that I'm missing? I'm asking this because th=
is
>> function would be useful for UFS controller drivers if the
>> affd->pre_vectors offset would be added when calling platform_get_irq(=
).
>>
> int devm_platform_get_irqs_affinity(struct platform_device *dev,
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct irq_affinity *affd,
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned int minvec,
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned int maxvec,
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int **irqs)
>=20
>=20
> Function devm_platform_get_irqs_affinity() gets the irq number for a=20
> total between @minvec and @maxvec interrupts, and fills them into @irqs=
=20
> arg. It does not just get the interrupts for index @minvec to @maxvec o=
nly.
>=20
> For context, as I remember, hisi_sas v2 hw has 128 interrupts lines.=20
> Interrupts index [96, 112) are completion queue interrupts, which we=20
> want to spread over all CPUs. See interrupt_init_v2_hw() in that driver=
=20
> for how the control interrupts, like phy up/down, are used.

Hi John,

In interrupt_init_v2_hw() and also elsewhere in the hisi_sas_v2_hw.c
source file I see that the CQ interrupts start at offset 96. However,
devm_platform_get_irqs_affinity() passes the arguments 0..(num_cqs-1) to
platform_get_irq(). Shouldn't that function pass arguments in the range
96..(96+num_cqs-1) to platform_get_irq() since that is the CQ interrupt
range for this storage controller? My understanding is that the
devm_platform_get_irqs_affinity() call from hisi_sas_v2_hw.c will affect
the affinity of the interrupts 0..(num_cqs-1) instead of the interrupts
in the range 96..(96+num_cqs-1). Isn't that wrong?

Thanks,

Bart.

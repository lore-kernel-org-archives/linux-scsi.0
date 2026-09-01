Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 947373DCD90
	for <linux-scsi@vger.kernel.org>; Tue,  1 Sep 2026 18:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788286659; cv=none; b=JIJjoaAsWmSAmMv4ulMrr41xkQ5giQOSqvLcy3YXF/CVoxgYzH56ZIB15y0YJYyzy9QJUEM3AfJCRT7BIvu5w/BnxII2QXIpXHk77mrKWUwFdeR5OLB2CZ9F794ExreLnWKN9NAapYepW3hriXj+pUCNNspVERqp707f8dYWV2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788286659; c=relaxed/simple;
	bh=1iKNo9aTrkI/ZBfUcFbQxwkyvTFXukruIeUudGX1SOo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tlmUXiR3orQUXthfyqTfSV8pw8eL4cBVANm6ku9IR6LdGEUnHIVKTNHjbkfoPS1p/qG43d/LFYZ9okUvuRb8ZY/1aYx6DCsm55mWbHvXlY0qIP29Kkbe7Jvm46F9vlCc6S8F2IAvqv+EXqg71OKlfnKYWoWX6q/9BuiyZdGKwmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=A8pjWwZF; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="A8pjWwZF"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4hZDc0651rzlfq9P;
	Tue,  1 Sep 2026 18:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1788286654; x=1790878655; bh=1iKNo9aTrkI/ZBfUcFbQxwky
	vTFXukruIeUudGX1SOo=; b=A8pjWwZFDXAxM7noQt1Re3xPOe3a3/WYC+qUBuz/
	Spu/SH9ZdTkOIaIp80q0AZs8co938A84FYAMZaaEcX8Qg+XHjs4MDQ2MyWkUO9Ts
	+tZI0rc++SdRT/8D9Z6WiwIbfIqcBuEaUAYs1sk1lvZrU5MvYSUpsle82C3E9jC2
	dh8o2/CGaR2Y/THnJBj3q2YZTR8bvNvrVkJ5BcfR65AWFpD+vyGounjouztAcyIq
	ALhwGblg9R+HThew1uPZjYyiWxSPYd8s/w4TybWlnZiRcZ1gu2KmXl7pY0ao/dyE
	6XRhzJsk0DEb4T5DxWJDyhZKj2+G/ZBnUdsTyFhDELQGXA==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ej9gxk_ZyUpz; Tue,  1 Sep 2026 18:17:34 +0000 (UTC)
Received: from [100.80.227.50] (unknown [104.135.182.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4hZDbx03ngzlfvq7;
	Tue,  1 Sep 2026 18:17:32 +0000 (UTC)
Message-ID: <fc05556d-e81f-4039-b62a-d8327bcf6d5b@acm.org>
Date: Tue, 1 Sep 2026 11:17:32 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: core: Rework the DEF_SCSI_QCMD() implementation
To: John Garry <john.g.garry@oracle.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>
References: <7d904551041c58fd2cda31f82cf3e7b246e6550a.1788214709.git.bvanassche@acm.org>
 <b003c0c1-ba99-403d-b3c9-3670dd7d027c@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <b003c0c1-ba99-403d-b3c9-3670dd7d027c@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 9/1/26 1:04 AM, John Garry wrote:
> On 31/08/2026 23:19, Bart Van Assche wrote:
>> In DEF_SCSI_QCMD(), make the following changes:
>> =C2=A0=C2=A0 - Assign cmd->device->host to shost because func_name##_l=
ck()
>> =C2=A0=C2=A0=C2=A0=C2=A0 implementations will be annotated with
>> =C2=A0=C2=A0=C2=A0=C2=A0 __must_hold(&cmd->device->host->host_lock). T=
his change prepares for
>=20
> Why not annotate with __must_hold(&host->host_lock)? That is what we do=
=20
> in scsi_host_set_state().

Because the host pointer is not in the argument list of functions like
blogic_qcmd_lck(). Do you perhaps want me to pass the SCSI host pointer
as an argument to blogic_qcmd_lck()? This could be done by open-coding
DEF_SCSI_QCMD() in the BusLogic driver.

> It would help the maintainer to mention that this conflicts with my=20
> host_lock patch

I will wait with posting a new version of this patch until your
host_lock patch has been merged.

Thanks,

Bart.

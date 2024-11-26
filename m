Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7998B1CEAC7;
	Tue, 26 Nov 2024 13:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732629004; cv=none; b=fg3oY5rO8LcN+pNp4px82vGcwuWrqdkgj525Lo09Z+aljdSOUn+PVewdNE/DXKu1KwCeUCvAaopAiZjMQS4wpaHucnJFVMKuWxWifpovwKODdAASkdRaaQliyUzVwUkssyu30rPcurdcutGIbtRQwCH9APhyJADGvX920fVKzCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732629004; c=relaxed/simple;
	bh=LDHKlvSWEbzHB5vUhCPiMjAvRh/HoM1F8Ra5jPRv8G4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NF2L4PReZEF/rKEKKIw5Xbbkfje38cqsS5nqmTPmWZG/VCsJ3XNIdUwL06/orIrwBedifso9CMT5Nlk/BH4NygEfYPqKg5Bp8PzYp2acg/1DctfX3EvmVoMI6HYGbaaUsyAMMWU+IUmRXEZ7YJKvrjnLqTOrfEmSfK/Zhx6nY9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=OJjBfNEB; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="OJjBfNEB"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XyP8T6K1QzlgVXv;
	Tue, 26 Nov 2024 13:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1732628997; x=1735220998; bh=LDHKlvSWEbzHB5vUhCPiMjAv
	Rh/HoM1F8Ra5jPRv8G4=; b=OJjBfNEBslumokxQFw1dfLQb8NXjU+aVp+D3qSML
	YB64gfylUqbxQkDErbzUNySWz6Dun0eCXO9c5nfPCyxj5g03th/gV1rsBdS0dPZZ
	YGSRKJDN7YkWgMG2scpW0LdXb9oEPQJDOOifKr17r1NalOHGVZUO9I37VEhroaIL
	bRoGb1M8Z60+EwvkcMRrUA/fRuHAg3z4lXgYX0QqPOsZuccUpKG20gu13euudLz2
	D1CUMC9jVdGqdI1cDv4ggffGjcDdxkN3D5RrpRcp2msZsVym0v718+2ueRDLJac+
	U2F6e5SS75jZjRtj+t6Js3dD8vTNKpyolgB24iw3j4hTDA==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id YunbblsNHGzo; Tue, 26 Nov 2024 13:49:57 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XyP8K3vpBzlgTWG;
	Tue, 26 Nov 2024 13:49:53 +0000 (UTC)
Message-ID: <ed22e2ea-bf28-4eba-bfb1-afe9f79dc3b7@acm.org>
Date: Tue, 26 Nov 2024 05:49:50 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: Don't wait for completion of in-flight requests
To: John Garry <john.g.garry@oracle.com>, Qiang Ma <maqianga@uniontech.com>,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 axboe@kernel.dk, dwagner@suse.de, ming.lei@redhat.com, hare@suse.de
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20241126115008.31272-1-maqianga@uniontech.com>
 <7c95b86b-68a0-41f8-a09c-3cb4b06fe61a@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <7c95b86b-68a0-41f8-a09c-3cb4b06fe61a@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 11/26/24 4:21 AM, John Garry wrote:
> On 26/11/2024 11:50, Qiang Ma wrote:
>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>> index adee6f60c966..0a2d5d9327fc 100644
>> --- a/drivers/scsi/scsi_lib.c
>> +++ b/drivers/scsi/scsi_lib.c
>> @@ -2065,7 +2065,7 @@ int scsi_mq_setup_tags(struct Scsi_Host *shost)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 tag_set->queue_depth =3D shost->can_que=
ue;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 tag_set->cmd_size =3D cmd_size;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 tag_set->numa_node =3D dev_to_node(shos=
t->dma_dev);
>> -=C2=A0=C2=A0=C2=A0 tag_set->flags =3D BLK_MQ_F_SHOULD_MERGE;
>> +=C2=A0=C2=A0=C2=A0 tag_set->flags =3D BLK_MQ_F_SHOULD_MERGE | BLK_MQ_=
F_STACKING;
>=20
> This should not be set for all SCSI hosts. Some SCSI hosts rely on=20
> bf0beec0607d.

Are there any SCSI hosts for which it is safe to set this flag? To me
the above change looks like a hack that should not be merged at all. Did
I perhaps overlook something?

Thanks,

Bart.


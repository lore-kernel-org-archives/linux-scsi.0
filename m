Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A23AD1F91C7
	for <linux-scsi@vger.kernel.org>; Thu,  4 Sep 2025 17:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757005261; cv=none; b=dP7KwxcNUNc1VK7ZTpOIPg3Foon/Cb0377pLfTci40I70h/+k06USLK/o+aVzinPJZXt6H4hJ8ctVGMTM9a2Q5dKRnCO7dfcpcGpcsCHRVd+ShyF6dHWVoob/m5fHiUP0vXkgVXcr3Zgo8zLZH2xc1wh/OvXjR6TfVx8ww4YBE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757005261; c=relaxed/simple;
	bh=h6MIfyanpDDzgEowEjCyGyUco9sX7Un2PYQDDTRq6q0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iALm/2XGL+poCMR025q2bxxtyeNkMAbjkF8H0geYzLle+VHutNEFavw0mg3aI7tk1osU8Vx/ryPPWVBDcFyHSFqQm+6j/NrBISC7Ma5sBgZRY9H8EFZA7bTF5A5Oa7MYSmFRERsnqNg2K+/rLDZSsJtZDmO74Lmtjni/b8++nvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=lntnBwJ2; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="lntnBwJ2"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cHm2d6SFXzm174m;
	Thu,  4 Sep 2025 17:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1757005254; x=1759597255; bh=dBzoCGOXdpzpSExjZrwHxUi0
	VIsXMeOzGzB54GqWaIY=; b=lntnBwJ2uQ5pTSQYu13R6wbxy+nd9slV7c5raZeo
	zd+e31qurlS7Pkx2eLGNenS+TSHy/ihRkbQ/BYvl+kt8em9Vl2pbrzSRbrPY4fOo
	YxJh4zbu0Tc79ofoi8+sk5WTBT9hJb2rHITtG4VFbiWrf95Jr377GzLoMyQh0XxL
	QapUcCF/luTRVIEmnA6GDlSTSBIu0zh/atpg2h4Atwgo43AV4sJpOMjbWYYVa+hM
	wKKGVdzuHGR5p5bOBhhbuy61+ATEDvnPbg35TXjHLgJt5/iMVifYLeIIgASg683h
	9TN6/5VKv/bfdkudnaEBZq+skj8T+T6xMxr891CNTDsoIg==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 0wifKFnP1SoX; Thu,  4 Sep 2025 17:00:54 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cHm2T0Bnlzm174k;
	Thu,  4 Sep 2025 17:00:46 +0000 (UTC)
Message-ID: <71cb48b8-cfdb-4089-8bab-cdd33eb5c77f@acm.org>
Date: Thu, 4 Sep 2025 10:00:45 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 01/26] scsi: core: Support allocating reserved commands
To: John Garry <john.g.garry@oracle.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250827000816.2370150-1-bvanassche@acm.org>
 <20250827000816.2370150-2-bvanassche@acm.org>
 <b5d5b534-6c65-4136-8bf5-74f472f660c1@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <b5d5b534-6c65-4136-8bf5-74f472f660c1@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 9/4/25 1:49 AM, John Garry wrote:
> On 27/08/2025 01:06, Bart Van Assche wrote:
>> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
>> index cc5d05dc395c..d7091f625faf 100644
>> --- a/drivers/scsi/hosts.c
>> +++ b/drivers/scsi/hosts.c
>> @@ -499,6 +499,9 @@ struct Scsi_Host *scsi_host_alloc(const struct=20
>> scsi_host_template *sht, int priv
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 else
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 shost->dma_boun=
dary =3D 0xffffffff;
>> +=C2=A0=C2=A0=C2=A0 if (sht->nr_reserved_cmds)
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 shost->nr_reserved_cmds =3D=
 sht->nr_reserved_cmds;
>=20
> small comment: shost->nr_reserved_cmds is always zero-init'ed, so this=20
> could be simply:
>=20
>  =C2=A0=C2=A0=C2=A0=C2=A0shost->nr_reserved_cmds =3D sht->nr_reserved_c=
mds;

Agreed. I will include this change when I repost this patch series.

>> +=C2=A0=C2=A0=C2=A0 /*
>> +=C2=A0=C2=A0=C2=A0=C2=A0 * Number of reserved commands to allocate, i=
f any.
>> +=C2=A0=C2=A0=C2=A0=C2=A0 */
>> +=C2=A0=C2=A0=C2=A0 unsigned int nr_reserved_cmds;
>=20
> nit: maybe co-locate with can_queue

That sounds good to me. I will include this change and also the spelling=20
fix for "calculate".

Thanks,

Bart.

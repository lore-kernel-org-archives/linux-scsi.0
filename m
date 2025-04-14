Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 006C11F3BB4
	for <linux-scsi@vger.kernel.org>; Mon, 14 Apr 2025 21:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744667979; cv=none; b=LFkG4egG36mqw6ueSwGeqEidFV8U3++UqMlWUqZSU7w18gx7+yPjGV0ZB0e9aFYD86EdI0tE6BWFx8zW7yTFfPX4IpNK5eu8mOQ5QPsnz8U2nO1ZkuyzPWNyk1fqeCcGP4gxdsBzfeUEgVn7K0adCpJph7cBnWIYoxnW5k0gqAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744667979; c=relaxed/simple;
	bh=VviKuZ88luExcLkgsypyjXCIbnxACh93hCOym45lesE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uc4Vai32Rt/DPIUlMulWZznQSjCXaX+JyATJOW0kvqJJ/lLcLHEZfweZPOBwMW+eIb0SoG3rcGHAVyMH5avBacP+GoRl1ECFJGI1GF9Zc8l+spIflvwGpqARUJHJ1JmUe0Oo6ACz9EtzNGeiXwIkg+JMUH4+gXGfNnKT/rXzb3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=pATB71vl; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="pATB71vl"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4Zc1RC5g8pzm0ySX;
	Mon, 14 Apr 2025 21:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1744667974; x=1747259975; bh=VviKuZ88luExcLkgsypyjXCI
	bnxACh93hCOym45lesE=; b=pATB71vlB7MfEFfCVZNn2vKsuT5GzsjpxbfhhUr5
	Uy7X9v4hAfg48Jbvzx4uU3Sond4SvV4tVM3ABfO1f/O2PK4ziqMB1aroHN/me7kA
	fHNBXuFqC40Ek//heLUPjWOxtzyawHpTFPhMmRPr070em++ylRKk39uCILYF6b6J
	EFEGQUR1CGZnAx2Tr6UXQIVF3Xr3L/Ly5cPPWB6COguhaqRK2aoZQq71O/Gv9M96
	FgiYGOY9p59cl/yjvUV+WnklcmBEl2r5mD3Z4/g4iGg+V5BroR3mH1LGHOrRVb+e
	kOs8T7nYcDsWaCSxiO6UZo3SO8f2MAB+tnDfDbbMSexZhw==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id kpkXvYttN3Ej; Mon, 14 Apr 2025 21:59:34 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4Zc1R73pJRzm0yV3;
	Mon, 14 Apr 2025 21:59:30 +0000 (UTC)
Message-ID: <be43323d-b1be-4bfe-8fb4-33f9b09e93d9@acm.org>
Date: Mon, 14 Apr 2025 14:59:29 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/24] scsi: core: Implement reserved command handling
To: John Garry <john.g.garry@oracle.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250403211937.2225615-1-bvanassche@acm.org>
 <20250403211937.2225615-5-bvanassche@acm.org>
 <3c2fe290-5e24-4985-833c-24d8b80b98b7@oracle.com>
 <e1cc3f08-e7e0-4eea-82a8-c5d2e7618238@acm.org>
 <bff407bb-ed99-42b1-bfc8-05b8aa76957c@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <bff407bb-ed99-42b1-bfc8-05b8aa76957c@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable


On 4/4/25 10:34 AM, John Garry wrote:
> Now I see this in 23/24:
>=20
> +/*
> + * Convert a block layer tag into a SCSI command pointer. This functio=
n is
> + * called once per I/O completion path and is also called from error=20
> paths.
> + */
> +static inline struct scsi_cmnd *ufshcd_tag_to_cmd(struct ufs_hba *hba,=
=20
> u32 tag)
> +{
> +=C2=A0=C2=A0=C2=A0 struct blk_mq_tags *tags =3D hba->host->tag_set.tag=
s[0];
> +=C2=A0=C2=A0=C2=A0 struct request *rq;
> +
> +=C2=A0=C2=A0=C2=A0 /*
> +=C2=A0=C2=A0=C2=A0=C2=A0 * Use .static_rqs[] for reserved commands bec=
ause blk_mq_get_tag()
> +=C2=A0=C2=A0=C2=A0=C2=A0 * is not called for reserved commands by the =
UFS driver.
> +=C2=A0=C2=A0=C2=A0=C2=A0 */
> +=C2=A0=C2=A0=C2=A0 rq =3D tag < UFSHCD_NUM_RESERVED ? tags->static_rqs=
[tag] :
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 blk_mq_tag_to_rq(tags, t=
ag);
> +
> +=C2=A0=C2=A0=C2=A0 if (WARN_ON_ONCE(!rq))
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return NULL;
> +
> +=C2=A0=C2=A0=C2=A0 return blk_mq_rq_to_pdu(rq);
> +}
> +
>=20
> Do you really think that it is ok that anything outside the block layer=
=20
> should be referencing tags->static_rqs[] directly?
>=20
> Even using blk_mq_alloc_request() would seem better than that.

Hi John,

There is a challenge: a request queue must exist before
blk_mq_alloc_request() is called because the first argument of that
function is a request queue pointer. Creating a request queue by
calling __scsi_add_device() is not appropriate because
__scsi_add_device() submits SCSI commands to a SCSI device and
submitting SCSI commands to a UFS device must only happen after the
initial device management commands have been sent.

The only solution I see is to call blk_mq_init_queue() directly from the
UFS driver and to pass that request queue to blk_mq_alloc_request() when
allocating device management commands.

Bart.



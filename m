Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA1A32DFA41
	for <linux-scsi@vger.kernel.org>; Tue, 15 Apr 2025 17:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744737679; cv=none; b=t/347HGU6oseBJk0ukzPp+FuRi19CYVsVhvbEburEsvhkwFv985aC0Xj00rJqKC0+kByp2+VDufkDp4DfMtqoB2FCLI6ZEYau4QlmmWfs7nszIRLrPgumKEUkLAlcSRsYrEuj1uXB5S60o2kJEgTTBeGpxUhn1LgK9WWUjraiXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744737679; c=relaxed/simple;
	bh=7lA4ADjqOdUxH6aAcUqkaNOfS704nygOFDtUqmOoQ6k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Nin0OM5M1YoEipDQGt7dwmHk7E9svKrNkyP9xMC4PAxAJRIxZqk90oSxBB1U/bgMpONU+F9V/B2HEUApPYMbNbX9+ndxs29pEjt6rXux1owD0LhjQsXCYcHZuBJPXUf6SBghI9dChzv3IOW7HXfBPDQn+g6/GfI0BxzMHGkBf2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=zwFLb7jA; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="zwFLb7jA"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4ZcWCV5tmYzm287L;
	Tue, 15 Apr 2025 17:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1744737669; x=1747329670; bh=QfsDwbBKng8n4n8iUnWFGAqX
	y/EXz+d5xdDSC+MeG+I=; b=zwFLb7jAYK2S+lfNuUoy5RH6riZgGeU/7qfEYKFz
	/KzQODado/iqfr8gM0LLgi0wMwVDt9jVcY4T3/UP26wqsORKIInSZ9HIns+Fn54s
	ChVohJau5Krwzn0eY32kbQnGHdG7I81mza9CetXdVOiyh4OI1nlyhbGLd/VtFtuz
	AcrhM6ewr06bsqtdeQvD1SMUcxMbYuk0DOBqTh7Vs0Zh7XVlXhM+d20/gCwmWLz9
	WXUtJU6bt2To/4eQa7olL7ZCWibriTvM+yXN7pmexPbC9sjhr7jLPcyrKoMtiUcY
	fxozNHPWhli0dC1kiBQqQgQeawVhUs4Ev2Jq1gWPckmQBw==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id sqoSPAujuU6C; Tue, 15 Apr 2025 17:21:09 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4ZcWCP4yXQzm240y;
	Tue, 15 Apr 2025 17:21:04 +0000 (UTC)
Message-ID: <27e5c0e9-a042-45e3-9852-31adb966b781@acm.org>
Date: Tue, 15 Apr 2025 10:21:03 -0700
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

Using blk_mq_tag_to_rq() to translate a tag of a reserved
request into a request pointer only works after the block layer has
set tags->rqs[tag_of_reserved_request] first. That pointer is set by
blk_mq_get_driver_tag(). blk_mq_get_driver_tag() is called by the
block layer code that submits a request to a block driver. Hence, to
ensure that blk_mq_get_driver_tag() is called for reserved requests
the reserved requests would have to pass through scsi_queue_rq().
For reserved requests sdev =3D=3D NULL as explained in a previous email.
There are many statements in the SCSI command submission and completion
path in which it is assumed that sdev !=3D NULL. I don't think that the
SCSI maintainer (Martin) would agree with adding "if (sdev)" statements
in many places in the SCSI core.

Letting UFS reserved requests being processed by another function than
scsi_queue_rq() doesn't seem feasible to me either. Although it is easy
to create an additional request queue for reserved requests, that
request queue shares its tag set with the SCSI host and hence also the
request submission function. From scsi_host.h:

struct Scsi_Host {
	struct blk_mq_tag_set	tag_set;
	[ ... ]
};

 From blk-mq.h:

struct blk_mq_tag_set {
	const struct blk_mq_ops	*ops;
	[ ... ]
};

Unless someone comes up with an elegant proposal, I will keep the
approach where ufshcd_tag_to_cmd() handles reserved tags and regular
tags differently.

It should be possible to do this without referencing tags->static_rqs[]
directly from the UFS driver.

Bart.

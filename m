Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A873235FF4A
	for <linux-scsi@vger.kernel.org>; Wed,  7 Jan 2026 18:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767811127; cv=none; b=sPlMzt+36DhaiThIzDjF2txKz3oMnCFT1feaTfBBVPu7URHzyCqQIe4MbtZJXQii/0vdSTl0bUCncY2wayb9CvTRErk2UlkyQgz1btf9iSFnrwGJ56R8YM9ZIAG+3pqqDFCW1hlLGW4y4HC/dUXga9NIeT+nxomOA5fX88O+pgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767811127; c=relaxed/simple;
	bh=3xSkOatfagobSg/HA059Xow/doYWKNgnbPuzVhfaSJM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oMnQOFvw9p2yL1hIhmm+CmDGFnD/+699bgjbCuC48qH3sSyy34LUGbWyA8xxcUbyZEkopo6uPtJkyP73DbT9a50n1i6kWk71lEz1dmFo95l6ndD7afUMOW6IP3QmCwJ0NZgXJHSui6MPSYTPQ5pclFZFWKyTtVNwMHF5POc9ZNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=fail smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=BkyTP4IV; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="BkyTP4IV"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4dmcHk4Hkgzllvdh;
	Wed,  7 Jan 2026 18:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1767811121; x=1770403122; bh=3xSkOatfagobSg/HA059Xow/
	doYWKNgnbPuzVhfaSJM=; b=BkyTP4IVEXc1vvXkm9+kYpCPb7HsnnvpwLBkT9c/
	+FZ3VOBHq51V5dHkkl7cFEhQY2AargMhLmfAcIXhT64kf9jyLdvJNbTyTcAcw1Vr
	7NjpOxe/izzoF0CMiCSYxOWKqOJ4sHMeOob403ZK0cmVeMvGRUp7Gdtg23OMyksI
	ceM7pOKPZmUFtRw3VKN5y8Z2uDiMEJecRz97xdMaOnvalnwRSR1pWmUAJX0YOwlG
	WYvSTXWvsNj3HyTE+fswf8V23almvLNdqm8OBWzRqo7QpOFutY/mceY5mQqx2m3a
	+/v7ALKbD23k9f6AZwJwNiVe5CWFRGmGneCrZbVOY3crfw==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id lCtN4-UoRPkr; Wed,  7 Jan 2026 18:38:41 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4dmcHh4nDYzlkSBG;
	Wed,  7 Jan 2026 18:38:40 +0000 (UTC)
Message-ID: <c5b9bf3f-cad7-47b1-b000-661e7ec87a9c@acm.org>
Date: Wed, 7 Jan 2026 10:38:39 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] scsi: core: Revert "Fix a regression triggered by
 scsi_host_busy()"
To: John Garry <john.g.garry@oracle.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20260107174753.3089238-1-bvanassche@acm.org>
 <20260107174753.3089238-3-bvanassche@acm.org>
 <e820c7d7-f11d-4fab-a505-11b1fcc33d3b@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <e820c7d7-f11d-4fab-a505-11b1fcc33d3b@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 1/7/26 11:06 AM, John Garry wrote:
> On 07/01/2026 17:47, Bart Van Assche wrote:
>> Revert commit a0b7780602b1 ("scsi: core: Fix a regression triggered by
>> scsi_host_busy()") because all scsi_host_busy() calls now happen after
>> the corresponding SCSI host has been added.
>>
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>> ---
>> =C2=A0 drivers/scsi/hosts.c | 6 +++---
>> =C2=A0 1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
>> index 196479cbfe6e..f1dd71a2d89d 100644
>> --- a/drivers/scsi/hosts.c
>> +++ b/drivers/scsi/hosts.c
>> @@ -626,9 +626,9 @@ int scsi_host_busy(struct Scsi_Host *shost)
>> =C2=A0 {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int cnt =3D 0;
>> -=C2=A0=C2=A0=C2=A0 if (shost->tag_set.ops)
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 blk_mq_tagset_busy_iter(&s=
host->tag_set,
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 scsi_host_check_in_flight, =
&cnt);
>> +=C2=A0=C2=A0=C2=A0 WARN_ON_ONCE(!shost->tag_set.ops);
>=20
> If shost->tag_set.ops =3D=3D NULL, then we will detect it like before,=20
> right? If so, I don't think that it is required.

There may be drivers left that I overlooked and that call
scsi_host_busy() before the SCSI host has been added. Emitting a
kernel warning is more user-friendly than letting users figure out
why blk_mq_tagset_busy_iter() crashes.

Thanks,

Bart.

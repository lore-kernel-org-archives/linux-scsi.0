Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C635472074
	for <linux-scsi@vger.kernel.org>; Tue, 13 Oct 2026 20:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791924375; cv=none; b=mKnNccAEj+NR/ibOqpD98i+P7WBvjA+iLBfi/JpVJJPDR2zwHcS9otQ4j3b+Xg5ztGehOjYE9EQgQsJHhoygdrWEzSUvkU+/hLN/MPvv7dafU16nfX9b2ipn+HIBuE/+zRiDj4fqQ/5454fcQ67gSgcf5m65HXAAJTrZXiqdYm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791924375; c=relaxed/simple;
	bh=Xw4bMVF+cbhUmRBiNS4731cYkYIE4/YPnvK5Onr/TKo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UW7PVBahhx+ppC/8J13Nhu8vZkUEUeSROFJTwJjpk4ucq9w/8BYD36tuYOvTWBA/4GF67u/scqPiJ+9Tv4SI3jZkoIwxcBQ4/UIT4/volcdb5poWv24uFotv81mFkkdY17HdoWjon3WX1wxnwfeN24ZufT0iIUBReawvdAv00Bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Ya4DeVYo; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Ya4DeVYo"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4j45w411MgzlfvpK;
	Tue, 13 Oct 2026 20:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1791924370; x=1794516371; bh=Xw4bMVF+cbhUmRBiNS4731cY
	kYIE4/YPnvK5Onr/TKo=; b=Ya4DeVYohdehMHUnDgSX7gkCnbK3AFXsOpvbVFc5
	my9ktAkBWKrZSL/eL6nsjaV0H93+tl/0JCGq4y/NJh0nzG2ByJZIuKuyk2wdcPLM
	6Ir1UINlWOhywli+mBS6tTMKBcTzjF9cnUVaXWNFaOMj1RFaT/8kvEPoB66ayabm
	QrJGoj/VaAOiIBo3KeN84KT+C7EFWmy1hgzCcapShfWbnoL1XhR6mE+Rxatr4aDa
	A/Sn6cHIA2IyccM44UVowKl59xFAN92L80G5xYoJRTeVV6jj1XEndciW0eIXhubc
	k06OE2y01EX5qVEmufLh3Q1sksSMlwBzUjetItmwrD+EbQ==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id R4SU7N83IoS8; Tue, 13 Oct 2026 20:46:10 +0000 (UTC)
Received: from [IPV6:2a00:79e0:2ed2:d:46f9:948:aeed:5df3] (unknown [104.135.182.43])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4j45w16fGHzlfvpH;
	Tue, 13 Oct 2026 20:46:09 +0000 (UTC)
Message-ID: <27b49f4a-a8b9-46d5-b304-612c0f80a44c@acm.org>
Date: Tue, 13 Oct 2026 13:46:09 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 4/8] scsi: scsi_debug: Split resp_read_dt0()
To: John Garry <john.garry@linux.dev>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>
References: <cover.1791499174.git.bvanassche@acm.org>
 <5336162520371fc22ebde7bd4080a9465908dd2a.1791499174.git.bvanassche@acm.org>
 <6bd7fafe-23b0-41f5-bfa8-5cbfd1ce38a6@linux.dev>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <6bd7fafe-23b0-41f5-bfa8-5cbfd1ce38a6@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 10/12/26 10:18 AM, John Garry wrote:
> On 10/8/26 23:42, Bart Van Assche wrote:
>=20
> Reviewed-by: John Garry <john.garry@linux.dev>
>=20
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D __resp_read_dt0(sc=
p, sip, lba, num, ei_lba, &scsi_status);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sdeb_meta_read_unlock(sip)=
;
>> +=C2=A0=C2=A0=C2=A0 } else {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D __resp_read_dt0(sc=
p, sip, lba, num, ei_lba, &scsi_status);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> -=C2=A0=C2=A0=C2=A0 ret =3D do_device_access(sip, scp, 0, lba, num, 0,=
 false, false);
>> -=C2=A0=C2=A0=C2=A0 if (meta_data_locked)
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sdeb_meta_read_unlock(sip)=
;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (unlikely(ret =3D=3D -1))
>=20
> I think that ret < 0 is a better check, but this is pre-existing code=20
> and this is not too important.
Hi John,

I will include the proposed change when I repost this patch series.

Thanks,

Bart.

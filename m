Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EADC63C65FD
	for <linux-scsi@vger.kernel.org>; Wed, 23 Sep 2026 19:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790192352; cv=none; b=SNdSxpcN6DAMifVAV0okCnM//v7t92/XoUkVlLjGFfcasd6ddZ8waLd9yBUnHjqDNlQngotPT318/5QEAvklkbLb776Z1aSiaKsE18QhbMp2WPh74VTGbaPhBlhextTiupqv8Ea0L/T9A9nJw20+2xp0zC+6uWeQSKzAzNjssZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790192352; c=relaxed/simple;
	bh=2vox78kU2JaIk5WvNSMd4SiNkFVxT0mSIivLQt2qjAw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jWtNfOZMPHnlZlBcVumxpv9NnE9Vt5vPuY4a+cp2GhOlkIPTvIJLTK9UyB/w0yGVJNMgbRj+CQKLdeRRIof+4palNq2Vh1x8BfxxNk9AmpQPJ0rGuSEB7mWyXBFbfXrzeD9TAKUFp4HEIeqKqlbotawbD4shUs4Vmd7TtHA8Cqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=tnL+UD1x; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="tnL+UD1x"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4hqnMy2qx8zlfvpG;
	Wed, 23 Sep 2026 19:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1790192348; x=1792784349; bh=2vox78kU2JaIk5WvNSMd4SiN
	kFVxT0mSIivLQt2qjAw=; b=tnL+UD1xh+9RKq21SOAMdspcrFEe2YlGN/WSUC1r
	4bk6/6wZGWMJkm7qJGo1G/WlJh7hienmn0Dg9SwrA9N6v4xkA9y11tccLoGH/2VR
	C0ER/sxdo39L/MZW902XzeZoUA8+N2jQlx+rY9V9EeQ/LZieAaZFpMW+3pjIqFi6
	HuaGYOJuxQb+fv8Os+JzSyQcOrGnvwMnfh0nnRwrvkMY6arL2j5W55zQyn1LtnIe
	xoEAx+d5TGI0j0fUi/NcjzsCqlDhjUUyx1fgvaiB7EnZIF/6eKAfiQTyz8UU1jLc
	fTFG2s/tEjr3RBCFGHFMC2dylqwxiEX8zeIDrgsaKfPgIA==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id fSY1Rs1hOOvx; Wed, 23 Sep 2026 19:39:08 +0000 (UTC)
Received: from [100.80.231.125] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4hqnMt59XTzlfvpN;
	Wed, 23 Sep 2026 19:39:06 +0000 (UTC)
Message-ID: <5c96a2c7-160a-4862-a0f8-cace955f1f32@acm.org>
Date: Wed, 23 Sep 2026 12:39:05 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/7] scsi: scsi_debug: Fix a locking bug in
 resp_write_same()
To: John Garry <john.garry@linux.dev>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>
References: <cover.1790119506.git.bvanassche@acm.org>
 <295c14b6d2d011597284f09f7a3de42a49e08863.1790119506.git.bvanassche@acm.org>
 <41890e94-10da-4b99-af6d-35106b88f026@linux.dev>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <41890e94-10da-4b99-af6d-35106b88f026@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 9/23/26 12:37 AM, John Garry wrote:
>> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
>> index 6941809dfdb7..b854102e6caa 100644
>> --- a/drivers/scsi/scsi_debug.c
>> +++ b/drivers/scsi/scsi_debug.c
>> @@ -5402,7 +5402,7 @@ static int resp_write_same(struct scsi_cmnd=20
>> *scp, u64 lba, u32 num,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (-1 =3D=3D ret) {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D DID_ERR=
OR << 16;
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto out;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto unlock;
>=20
> at @unlock we lose the error code in ret - is that intentional?
It's a bug. I will fix this issue and the Sashiko complaints and I will
review these changes myself carefully before I repost this patch series.

Thanks,

Bart.

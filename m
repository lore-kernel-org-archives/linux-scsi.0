Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 756FB1CF282
	for <linux-scsi@vger.kernel.org>; Thu, 22 Aug 2024 17:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724346186; cv=none; b=C0o5c+7VqAS7sZrw6EpApR/lrNrno0PJZxCFhTLN9dfhVrxJfXRlCDoqWfbHBJbv+y7eM5t3URmFwbS50e78b/fEC1LYp0Of9po6+EW0z5ylUtE3HTQ1w+0IA17/YxGo/TbCTVwyX+cX37giqS4rdkvQeBEJWaeLNpSFIJtnfpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724346186; c=relaxed/simple;
	bh=M0OcK3NeG2FCkWHRjHtEpoDhJPsRqgN7sJ2Ma8Fmy2w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AFkGDEdrjjp/kUcAlBapXO9PyrdjrT1I7BJxIAKUXnhiRnbUyOWUFrIjIqRzaVsJzSzOc1AD7xAOrM7zCJKX3/2u7qM2YouDVIaSoPfe14LA4Ew3kKLRYfZ+Zzk1yffxOvSHumo1ZZeNcx2VDezImJ7z8GLBMHOwVX1prDmvPK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=y2p0aCA/; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="y2p0aCA/"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WqTzW5yJ3z6ClY9B;
	Thu, 22 Aug 2024 17:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1724346180; x=1726938181; bh=ESa/0hMTpBUGqmRSunIMKmjG
	AidTAqYHJ8d5SWsxhnY=; b=y2p0aCA/64ZwsalyhiVJyfdG5t7ndLwuXUOKVo8+
	5MTVj4B2Gz0BZv9JcAbi75iP7ClonrvdF+9Zb7G00GDSpmjH5oydu5v4BS4MBCzH
	6RFMp9n7c9PSqLJ/3RlrYSjbB5QmhVNcNLF+eLScoZQ7LEm/f+U/FJwS5UvH2e60
	AWUmpgD7a9p2ezUKzmNwNGb5cCdSI9RgtZ96VdKVAoYjC3rZYCNBSkDdd1QgKPDK
	z/wi5VXUN6JhxX6lqGs6Js3C3h1VqOi8mIr7ERotRGi8UZfZjF3aNYlVYttcxd6d
	9FgS3qJe40NV7EGelH+YDg7/zXGaep9EU3QhsrptD/Nm/w==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id oNMzrXVtHODm; Thu, 22 Aug 2024 17:03:00 +0000 (UTC)
Received: from [IPV6:2a00:79e0:2e14:8:2767:7e57:9a00:979d] (unknown [104.135.204.81])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WqTzQ1Fnzz6ClY98;
	Thu, 22 Aug 2024 17:02:57 +0000 (UTC)
Message-ID: <3dd5c574-97ce-46cb-a925-9074973e8afb@acm.org>
Date: Thu, 22 Aug 2024 10:02:55 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] scsi: ufs: core: Make ufshcd_uic_cmd_compl() easier
 to read
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>,
 "avri.altman@wdc.com" <avri.altman@wdc.com>,
 "beanhuo@micron.com" <beanhuo@micron.com>,
 "ahalaney@redhat.com" <ahalaney@redhat.com>,
 "manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>
References: <20240821182923.145631-1-bvanassche@acm.org>
 <20240821182923.145631-2-bvanassche@acm.org>
 <50e21f3e873c19da78b108b0352a8aa6cf95907e.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <50e21f3e873c19da78b108b0352a8aa6cf95907e.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 8/21/24 10:34 PM, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> For example, consider the following complex conditional expression:
>=20
> if (a =3D=3D b && c > d || e < f && g !=3D h)

Hi Peter,

As you may know, the above is not allowed in Linux kernel code. I'm
not sure this has been written down anywhere formally. The C compilers
supported by the Linux kernel emit a warning about expressions like the
above and Linux kernel code should be warning-free.

I agree with you that code readability is important. However, I think
that it's important for Linux kernel developers to make themselves
familiar with expressions like (a & b && ...) since this style is common
in the Linux kernel. Do you agree that the data below shows that not
surrounding binary and expressions with parentheses is common in Linux
kernel code?

$ git grep -nHE 'if.*&&[^()&]*&[^&]|if.*[^&]&[^&()]*&&' | wc -l
    2548

Thanks,

Bart.

Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 738E2548E0
	for <linux-scsi@vger.kernel.org>; Thu, 30 May 2024 18:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717095559; cv=none; b=c4eE45rSzO0TYcV/O26xbjhEIrmP1DijOUieiv1Lyv6FZNnJq3eexn0rKJX4xFgnZdZ7Qaaa7kBxRoALxu73A+X8SINUYqEfq0Lve6kWmh47yuJIzYnxWaHdm3UByKozPtPbguC5l6Llh+22ZMqlR5Czs2uHC2k/wi+l8o+hRmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717095559; c=relaxed/simple;
	bh=VTqHT7oYJlSqwg8FURtqlrfH0ykyc2OxKMgLGp7cMvE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=prn5dFwzUMVkw1itS/DPu1+weLfLE10ltMPFhObtnx0eLxdl7+6YkYw9NnaaWf6vQlSjkiVlCX8AJs9sC59Kw2hHkZVu4npEnyp5oYBADFlyuoLvsTNw/8X5AlgGkEQjFuCVEYgdN94zPQJyJO8alhLdKq48gU2O3WvqA0MxNjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=EGYnhQv6; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="EGYnhQv6"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4VqwXN69JFz6Cnk9V;
	Thu, 30 May 2024 18:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1717095553; x=1719687554; bh=VTqHT7oYJlSqwg8FURtqlrfH
	0ykyc2OxKMgLGp7cMvE=; b=EGYnhQv6/h2XNFtEAiveJpvDfiEUlEpfLWPgphSE
	B6cL3NDEMtudjgy70rKgYufYsivsGHhTCiKhAGMQeiU5VBYs49B2bVtsmPT1AsFK
	Wmozb8JPuMGX+/8Nv58R/QOF23MnmqW2s/vkS2z8ME1R8cQK26W2w9yTNEBL9XEF
	8eiqxYcabniNHyR3OqNR8i5hTuz3WQcicT0MTXIw+kzC6c/oMNsRN/konuc2TqIL
	StKalJ/AL/sa5gQYJZ9tcGosxWu7To42V7z0eQtfx+TqYXJ/KfQ4a60479al5q1N
	pqx1QdjHvZCkruewMx3hF36X+F9dmqWwMFyMeE2LMb1Omg==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id iPOCb4As8z1T; Thu, 30 May 2024 18:59:13 +0000 (UTC)
Received: from [100.96.154.26] (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4VqwXJ5Jtcz6Cnk9T;
	Thu, 30 May 2024 18:59:12 +0000 (UTC)
Message-ID: <1c6eac0c-da65-4828-b70d-25d171cc369a@acm.org>
Date: Thu, 30 May 2024 11:59:11 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: mpi3mr: Fix a format specifier
To: John Garry <john.g.garry@oracle.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Tomas Henzl <thenzl@redhat.com>,
 Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
 Kashyap Desai <kashyap.desai@broadcom.com>,
 Sumit Saxena <sumit.saxena@broadcom.com>,
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20240529205226.3146936-1-bvanassche@acm.org>
 <02e43478-7012-4cad-a865-d01f080bac1d@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <02e43478-7012-4cad-a865-d01f080bac1d@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 5/30/24 00:24, John Garry wrote:
> On 29/05/2024 21:52, Bart Van Assche wrote:
>> Fix the following compiler warning when building a 32-bit kernel:
>>
>> ./include/linux/kern_levels.h:5:25: error: format =E2=80=98%lu=E2=80=99=
 expects argument of type =E2=80=98long unsigned int=E2=80=99, but argume=
nt 4 has type =E2=80=98unsigned int=E2=80=99 [-Werror=3Dformat=3D]
>> drivers/scsi/mpi3mr/mpi3mr_transport.c:1367:25: note: in expansion of =
macro =E2=80=98ioc_warn=E2=80=99
>> =C2=A0 1367 |=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 ioc_warn(mrioc, "skipping port %u, max allowed value is %lu\=
n",
>=20
> see https://lore.kernel.org/linux-scsi/20240514-mpi3mr-fix-wformat-v1-1=
-f1ad49217e5e@kernel.org/ from two weeks ago.

Interesting to see that this patch has been posted before. I had not yet =
noticed
Nathan's patch - I only checked the master branch and Martin's for-next b=
ranch
before I posted this patch.

Bart.


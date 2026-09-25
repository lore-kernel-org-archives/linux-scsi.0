Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE432368D51
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 15:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790351715; cv=none; b=iB/AKBNGJAGgDkNCemgKoQ6Bt0+5MHvgSIW1k9TBfwZ2Ui1DC3IAUfKiIQmDovPmmAx3rpYzY30CD+9WdYtVU9Zpqb+8rVnn63eDpgTf2CVhk9g92B8Ltc7Ef1eSgLfLdO1mLCvCzaJKi4/051/kOmys0hSHpbhzVyAJkZWzZ1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790351715; c=relaxed/simple;
	bh=tpTAJZaPtT8NXxCsmBzlEsNrfQNDAEfvbfnEt5mXJXU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MavrRhLNQ+pCsZqWkvTsIYBJ+NSxpQMHSvmg9i0ThFatE8/qO3Gx0N5gNXd0k6pikIs02LH+ODO5WVNZn6rRRANnmMe6L4Q3r0lMZ2YwxQz/lWpXSMkhzx1Es7GHIvdh9VvsbywHWVNh+aY0NwW9IEcwOXLjoAHerjKGvEF1/Wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=vtj4FDtD; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="vtj4FDtD"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hrwJd0lG6z1XM4Tl;
	Fri, 25 Sep 2026 15:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1790351709; x=1792943710; bh=w7n0xox+15MP9/0Rna1Jmv/W
	8Aa5mLOcGq1c88HwmjA=; b=vtj4FDtDmhGMjnwYCyFkefGP+5J/KL9f/tFC70KS
	a3jep9JX+Pw7qvgrSgcG/Pf2h3uZR9jtwc19he8PqriRaB26/IK0CokQCiFLpPfo
	FUTGoP4gRfQMsJQTKreUgTPle+W/iyVg12XI5mO9oCIhLGM/WdKbAGjIXuSFxLXC
	1WXn3WwDwppW8ZAiN10U0ImFGJCZoRRc0MswGo6nZwyCw3iIku7b+m/hL0eilk+Q
	kCCZLTcV8+WMWm5LZ34WYcC7EY57qIgSY9advSyVFAs60KOxwF+SvSOzVs33gkCm
	FxsiHvEWL9KyHvGXEUGgsvm3P3RGvSU/lSSEbaHXnkwysw==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id DdJdzYkRIVWF; Fri, 25 Sep 2026 15:55:09 +0000 (UTC)
Received: from [100.80.231.125] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hrwJX512Kz1XM4Sx;
	Fri, 25 Sep 2026 15:55:08 +0000 (UTC)
Message-ID: <08ca7fe8-a767-412d-9e51-716de27748fb@acm.org>
Date: Fri, 25 Sep 2026 08:55:07 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 6/7] scsi: scsi_debug: Improve lock context annotations
To: John Garry <john.garry@linux.dev>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, John Garry <john.g.garry@oracle.com>,
 Christoph Hellwig <hch@lst.de>
References: <cover.1790290089.git.bvanassche@acm.org>
 <68c72eed87c663b4b99f63af71971c718166d3c8.1790290090.git.bvanassche@acm.org>
 <1fa5a1b7-f35f-49b9-8d87-dd4e0aa3bf68@linux.dev>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <1fa5a1b7-f35f-49b9-8d87-dd4e0aa3bf68@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 9/25/26 2:15 AM, John Garry wrote:
> On 9/24/26 23:54, Bart Van Assche wrote:
>> =C2=A0 static inline void
>> =C2=A0 sdeb_data_lock(struct sdeb_store_info *sip, bool atomic)
>> +=C2=A0=C2=A0=C2=A0 __acquires(&sip->macc_data_lck)
>=20
> Is this proper?
>=20
> sdeb_data_lock() can call sdeb_data_read_lock(), and=20
> sdeb_data_read_lock() uses __acquires_shared().
>=20
> Indeed, but functions which sdeb_data_lock() call already have lock=20
> context annotations, so I wonder if this annotation is even needed.
>=20
>> +=C2=A0=C2=A0=C2=A0 __context_unsafe(/*conditional locking*/)

Hi John,

Some annotations are needed. If I remove both annotations Clang reports
the following warnings:

drivers/scsi/scsi_debug.c:4168:3: error: rwlock 'sip->macc_data_lck' is=20
acquired exclusively and shared in the same scope=20
[-Werror,-Wthread-safety-analysis]
  4168 |                 sdeb_data_write_lock(sip);
       |                 ^
drivers/scsi/scsi_debug.c:4170:3: note: the other acquisition of rwlock=20
'sip->macc_data_lck' is here
  4170 |                 sdeb_data_read_lock(sip);
       |                 ^
drivers/scsi/scsi_debug.c:4171:1: error: rwlock 'sip->macc_data_lck' is=20
still held at the end of function [-Werror,-Wthread-safety-analysis]
  4171 | }
       | ^
drivers/scsi/scsi_debug.c:4168:3: note: rwlock acquired here
  4168 |                 sdeb_data_write_lock(sip);
       |                 ^
drivers/scsi/scsi_debug.c:4177:3: error: releasing rwlock=20
'sip->macc_data_lck' that was not held [-Werror,-Wthread-safety-analysis]
  4177 |                 sdeb_data_write_unlock(sip);
       |                 ^
drivers/scsi/scsi_debug.c:4179:3: error: releasing rwlock=20
'sip->macc_data_lck' that was not held [-Werror,-Wthread-safety-analysis]
  4179 |                 sdeb_data_read_unlock(sip);
       |                 ^

Thanks,

Bart.

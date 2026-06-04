Received: from fgw23-4.mail.saunalahti.fi (fgw23-4.mail.saunalahti.fi [62.142.5.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A167E37CD2B
	for <linux-scsi@vger.kernel.org>; Thu,  4 Jun 2026 19:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.142.5.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780602166; cv=none; b=RR6XNLqvOjJpa5NbRww0TLtQATu88AjgGmsyIZUomK/ehA6UTLOQf5mQ3jR1bjuUA0768TSby+o8AqQJgcLe4GLfTiKrRMtYPUtub7tYPw4uukXiHNMvfnLoPivholdHfkqlbYbtFlrII8RPp5aDuZoVajuD9z/rOCcLo38UudU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780602166; c=relaxed/simple;
	bh=3+Rmw5EryJdYC61KHhQySTMMBQfEpZk1RqVwPts4GGo=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=AY0FpAQYzcuZJFG9wPeRXKTdds2rdv+/0qOH/bO9e7kqsFhgEOqj+pSNilNOdSHulfAN/QETrq/kl//smXBRylpoBiLqi1R5esGhkj2xqhwuhZkTI75r7m0EVplGAwtpfYNG1nekwUrbYlGjSPOOi5WdBGRgk4O1W5I56onrm0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=kolumbus.fi; spf=pass smtp.mailfrom=kolumbus.fi; dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b=Fx7sHgmx; arc=none smtp.client-ip=62.142.5.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b="Fx7sHgmx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=kolumbus.fi; s=elisa1;
	h=to:references:message-id:content-transfer-encoding:cc:date:in-reply-to:from:
	 subject:mime-version:content-type:from:to:cc:reply-to:subject:date:in-reply-to:
	 references:list-archive:list-subscribe:list-unsubscribe:content-type:
	 content-transfer-encoding:message-id;
	bh=q3eFp/pQYS72R28wqdYmwEwrPf7BZnjQN8KVpBafd1c=;
	b=Fx7sHgmxwf2BYqxq9e7RJW8m3dHC3Kl2T+Hrx6bofEISSqOP8j1SZk8bjOY4FMIgqOc3QCiwfgPSs
	 OCm+zIkiuiYNbEY4U38OBuCdctOKAho+ucelF6VHyt4QbLzgYc4sRfiIEBAasBXEPIiWEgpFQWdCmO
	 jgvB4dflVP3n3rUklEVZ83Vf+ARbeyQziINQZGe2PumA5g+/rcZ9XBRdqYXpJ/QXvrj4bYNimBzoP0
	 4I4j5DudfjZIP/+hOwP8LWzV6/F4mvMULWbqQbZs2eV6XkvOXwV5c3jEhTUC3rZCG7i01Rt55pkG4j
	 AweSiR4D+hQf3W7KL5N4zhB1Udl5bYQ==
Received: from smtpclient.apple (91-158-174-119.elisa-laajakaista.fi [91.158.174.119])
	by fgw23.mail.saunalahti.fi (Halon) with ESMTPSA
	id 626b5ecb-604d-11f1-9b5e-005056bdfda7;
	Thu, 04 Jun 2026 22:41:30 +0300 (EEST)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH v2] scsi: scsi_debug: fix one-partition tape setup bounds
From: =?utf-8?B?IkthaSBNw6RraXNhcmEgKEtvbHVtYnVzKSI=?= <kai.makisara@kolumbus.fi>
In-Reply-To: <c56802d9d3f05635c5b126687d0351a647801a77.camel@HansenPartnership.com>
Date: Thu, 4 Jun 2026 22:41:20 +0300
Cc: Samuel Moelius <sam.moelius@trailofbits.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 "open list:SCSI SUBSYSTEM" <linux-scsi@vger.kernel.org>,
 open list <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <EF8E0075-D397-453A-B06F-F2C77067BA53@kolumbus.fi>
References: <20260603235616.124535-1-sam.moelius@trailofbits.com>
 <6d2e78e6a5840f5892e7eb081657b23aa62bc50d.camel@HansenPartnership.com>
 <CAE+C+DbpB6UP29WTNGgrnYqhazEC5=5ErNJiChrDz8sygC_-0w@mail.gmail.com>
 <4A3BD9E5-21E2-40F7-9242-71589477F2EF@kolumbus.fi>
 <c56802d9d3f05635c5b126687d0351a647801a77.camel@HansenPartnership.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
X-Mailer: Apple Mail (2.3864.600.51.1.1)



> On 4. Jun 2026, at 22.29, James Bottomley =
<James.Bottomley@HansenPartnership.com> wrote:
>=20
> On Thu, 2026-06-04 at 22:14 +0300, Kai M=C3=A4kisara (Kolumbus) wrote:
>>=20
>>> On 4. Jun 2026, at 21.33, Samuel Moelius
>>> <sam.moelius@trailofbits.com> wrote:
>>>=20
>>> On Thu, Jun 4, 2026 at 9:38=E2=80=AFAM James Bottomley
>>> <James.Bottomley@hansenpartnership.com> wrote:
>>>>=20
>>>> On Wed, 2026-06-03 at 23:55 +0000, Samuel Moelius wrote:
>>>>> The tape setup path writes partition metadata one element past
>>>>> the
>>>>> allocated tape_blocks array when a one-partition configuration
>>>>> is
>>>>> selected.
>>>>>=20
>>>>> That corrupts adjacent state during device initialization
>>>>> before any
>>>>> command is issued.
>>>>=20
>>>> I still don't get what the actual problem is.  For a single
>>>> partition
>>>> tape I can't see where scsi_debug would actually do anything with
>>>> tape_blocks[1].  What is it that you're seeing when using
>>>> scsi_debug
>>>> that motivates this?
>>>=20
>>> The bug is a kernel OOB write. I can share a PoC if desired. The
>>> PoC
>>> sends this SCSI command through /dev/sgN:
>>>=20
>>> ...
>>=20
>>> Then the bug: it initializes partition 1 even though there is only
>>> one
>>> partition:
>>>=20
>>>    devip->tape_eop[1] =3D part_1_size;
>>>    devip->tape_blocks[1] =3D devip->tape_blocks[0] +
>>>                            devip->tape_eop[0];
>>>    devip->tape_blocks[1]->fl_size =3D TAPE_BLOCK_EOD_FLAG;
>>>=20
>>> Because devip->tape_eop[0] =3D=3D 10000, this computes:
>>>=20
>>>    devip->tape_blocks[1] =3D devip->tape_blocks[0] + 10000
>>>=20
>>> But the allocation has only 10000 elements. So this write is one
>>> element past the allocation.
>>=20
>> OK. The bug is not initialization of the pointer but writing the
>> fl_size using the pointer. Good catch!
>=20
> Isn't the fix actually to allocate an extra block for the EOF:
>=20
> @@ -6648,7 +6648,7 @@ static int scsi_debug_sdev_configure(struct =
scsi_device *sdp,
>        if (sdebug_ptype =3D=3D TYPE_TAPE) {
>                if (!devip->tape_blocks[0]) {
>                        devip->tape_blocks[0] =3D
> -                               kzalloc_objs(struct tape_block, =
TAPE_UNITS);
> +                               kzalloc_objs(struct tape_block, =
TAPE_UNITS + 1);
>                        if (!devip->tape_blocks[0])
>                                return 1;
>=20
> ?
That came into my mind, too. But I considered it a workaround, not a =
real fix.

But after considering the other alternatives and possible problems that =
should be checked,
I think your suggestion is the best way. It solves tha OOB write, but =
does not change the code
paths.

Thanks,
Kai


Received: from fgw20-4.mail.saunalahti.fi (fgw20-4.mail.saunalahti.fi [62.142.5.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75AB214883F
	for <linux-scsi@vger.kernel.org>; Thu,  4 Jun 2026 19:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.142.5.107
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780600498; cv=none; b=dm5BS5NWYcZT1nVkphxqG/Cy66rAkinNTQ4W45yxJW5BUdVqPR+TP2nZ84To2OQJNJg1hs2Euc4PgNRGUh+BfGGw8J1pshahtcpzWfYOJMU/1vtf32CXfbScYIgDf52q00E7K1kt8nXA+7hVycRiwD0VdkmKaTE/UWJHCJHWcHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780600498; c=relaxed/simple;
	bh=EUx02vWcTw+p0rwy3FBeL+59RDqjmCn+7cgADewMYe8=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=ciW/3I7CJn0/55En/G834S+PdrlttaMBWy2DLYVi5DcsMOHB/RrEck/+9V6ioU0ICSnUCTKZocd7IrxoGDcADbV+cltcKiGQieL/St3gUz1nOcV2Tfe0fdDfJp8ARPM8GRHERaMgAQoqkv8MNt0s6ExBiNK7seBRC9PRFxD6MP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=kolumbus.fi; spf=pass smtp.mailfrom=kolumbus.fi; dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b=OAzpl8Ry; arc=none smtp.client-ip=62.142.5.107
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b="OAzpl8Ry"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=kolumbus.fi; s=elisa1;
	h=to:references:message-id:content-transfer-encoding:cc:date:in-reply-to:from:
	 subject:mime-version:content-type:from:to:cc:reply-to:subject:date:in-reply-to:
	 references:list-archive:list-subscribe:list-unsubscribe:content-type:
	 content-transfer-encoding:message-id;
	bh=PDjUtEkw4GIEAYRiw9lwdP4l593RTBsMOLvdDIYZNXk=;
	b=OAzpl8Ry0/QWH197rWLSVI9apV54ONQZfVnHHvcBgWFzUsvWK3MsmQvEkGF9ia8kx2IEs73b9FBFR
	 5xZiqDHk/on3c6fXLj6UwjCS9hHSF46oV+hcA3IAfFjEvDZM+IBAfLKMK8PgGCL0XlVFpE4fJgnYvF
	 d3ekFdLhUlQX5yG4ZApdhVez/bM8IQKYN0gTDr3uJEQ1fV7dXxuelg+nbj26sof0TBFIu0aSmkbOHz
	 n4mQ4VzaKzo0NH0Z8u27C8KjRCRXR5vpiWmkBif002VtyqDf0Uq36vINTNrOdR04HxpGRBSLGjHsVG
	 DpKAZistmCOJX8gW/TfE7iQRsEEhTfQ==
Received: from smtpclient.apple (91-158-174-119.elisa-laajakaista.fi [91.158.174.119])
	by fgw22.mail.saunalahti.fi (Halon) with ESMTPSA
	id a44ffe07-6049-11f1-8e05-005056bdf889;
	Thu, 04 Jun 2026 22:14:43 +0300 (EEST)
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
In-Reply-To: <CAE+C+DbpB6UP29WTNGgrnYqhazEC5=5ErNJiChrDz8sygC_-0w@mail.gmail.com>
Date: Thu, 4 Jun 2026 22:14:32 +0300
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 "open list:SCSI SUBSYSTEM" <linux-scsi@vger.kernel.org>,
 open list <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <4A3BD9E5-21E2-40F7-9242-71589477F2EF@kolumbus.fi>
References: <20260603235616.124535-1-sam.moelius@trailofbits.com>
 <6d2e78e6a5840f5892e7eb081657b23aa62bc50d.camel@HansenPartnership.com>
 <CAE+C+DbpB6UP29WTNGgrnYqhazEC5=5ErNJiChrDz8sygC_-0w@mail.gmail.com>
To: Samuel Moelius <sam.moelius@trailofbits.com>
X-Mailer: Apple Mail (2.3864.600.51.1.1)


> On 4. Jun 2026, at 21.33, Samuel Moelius <sam.moelius@trailofbits.com> =
wrote:
>=20
> On Thu, Jun 4, 2026 at 9:38=E2=80=AFAM James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
>>=20
>> On Wed, 2026-06-03 at 23:55 +0000, Samuel Moelius wrote:
>>> The tape setup path writes partition metadata one element past the
>>> allocated tape_blocks array when a one-partition configuration is
>>> selected.
>>>=20
>>> That corrupts adjacent state during device initialization before any
>>> command is issued.
>>=20
>> I still don't get what the actual problem is.  For a single partition
>> tape I can't see where scsi_debug would actually do anything with
>> tape_blocks[1].  What is it that you're seeing when using scsi_debug
>> that motivates this?
>=20
> The bug is a kernel OOB write. I can share a PoC if desired. The PoC
> sends this SCSI command through /dev/sgN:
>=20
> ...

> Then the bug: it initializes partition 1 even though there is only one
> partition:
>=20
>    devip->tape_eop[1] =3D part_1_size;
>    devip->tape_blocks[1] =3D devip->tape_blocks[0] +
>                            devip->tape_eop[0];
>    devip->tape_blocks[1]->fl_size =3D TAPE_BLOCK_EOD_FLAG;
>=20
> Because devip->tape_eop[0] =3D=3D 10000, this computes:
>=20
>    devip->tape_blocks[1] =3D devip->tape_blocks[0] + 10000
>=20
> But the allocation has only 10000 elements. So this write is one
> element past the allocation.

OK. The bug is not initialization of the pointer but writing the fl_size =
using the
pointer. Good catch!

But the patch is not quite correct. If nbr_partitions =3D=3D 2 and =
partition_1_size =3D=3D 0,
it sets tape_nbr_partitions =3D 2 but does not initialize the second =
partition. This
will cause problems.

I think partition_tape() should return -1 if nbr_partitions > 0 && =
part_1_size =3D=3D 0.

All call sites of partition_page() check for error, but the error case =
has never
happened. The code should be checked so that an error return does not =
cause
problems later.

Thanks,
Kai


Received: from fgw20-4.mail.saunalahti.fi (fgw20-4.mail.saunalahti.fi [62.142.5.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21E59261591
	for <linux-scsi@vger.kernel.org>; Tue, 25 Feb 2025 09:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.142.5.107
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740476604; cv=none; b=rX/tiN7Vgne9NgXclHSZ8QnkIMd8Z0rWNTdhxVXElqpKTR431AcJgjNAr6KpS2B5SarFfnE/X9z5yfHgkOpXtBDpUKMwTJsEs2kS8pXweWJOZuurqTtH3Ix23RfULwrm+mV0Hux7lqKdsrhXIzrb/TZwlbmqyBdpxFS5mgxzIdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740476604; c=relaxed/simple;
	bh=6B0qB5/pvSZ5jcD/a3OGepgdBy2JO4/9bJDqujJ6z1g=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=K4BNXXOPP82nZBN2WRDtlF5YMMbhR56XMAGvX1MAN/u0m75PG6NwK2RUzfj5VJnsGFR32+LIHSme5KGmSmgaCUFfgkCv0JCtWr1z+uLnCb1NoBNi7gcExZ2C+10jKsu1e2Xp1U+3T89wjoplhlESrpt5pUfKvoEivwhqMpym4oU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi; spf=pass smtp.mailfrom=kolumbus.fi; dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b=AdLPzF3U; arc=none smtp.client-ip=62.142.5.107
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b="AdLPzF3U"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=kolumbus.fi; s=elisa1;
	h=to:references:message-id:content-transfer-encoding:cc:date:in-reply-to:from:
	 subject:mime-version:content-type:from:to:cc:reply-to:subject:date:in-reply-to:
	 references:list-archive:list-subscribe:list-unsubscribe:content-type:
	 content-transfer-encoding:message-id;
	bh=4HJGFwO7iJWP35BGN8gS4/yzq08A26mPEUXcqi1UmOs=;
	b=AdLPzF3UGEceEUAr5vBH/Juw35neeJ0zqnAhX2lBVUoAdWis+ncEWSrEWRvD47rmpE+YA6pjeGoTF
	 M4RxdvpHUWhXU/FBXOSWK8jE/zrFfx139HlyI6BlLeJWS8YZaDOUZIMotBk7c0KfUkp5HUD3gu+seE
	 YQrnOWRi4t4wk5dRTBmxjnreWspY5fIK5guuIDQpuozHjvObPS+YrwvuITnGS2hDG6fhEpV0VCmQBR
	 G8RJfIsoy95nvogDclZacgoBEG5KJveq25wJzGNmFeEcMbe+Ns9rDkC3drVhmQ81JoYQ8ySB6X7V2f
	 ItggHSqa/aLT5UYNPcpAQAavqiL9New==
Received: from smtpclient.apple (85-156-116-90.elisa-laajakaista.fi [85.156.116.90])
	by fgw20.mail.saunalahti.fi (Halon) with ESMTPSA
	id f03b8702-f35c-11ef-9d7a-005056bd6ce9;
	Tue, 25 Feb 2025 11:43:17 +0200 (EET)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.400.131.1.6\))
Subject: Re: [PATCH] scsi: scsi_debug: fix uninitialized variable use
From: =?utf-8?B?IkthaSBNw6RraXNhcmEgKEtvbHVtYnVzKSI=?= <kai.makisara@kolumbus.fi>
In-Reply-To: <20250225085644.456498-1-arnd@kernel.org>
Date: Tue, 25 Feb 2025 11:43:06 +0200
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 John Meneghini <jmeneghi@redhat.com>,
 Arnd Bergmann <arnd@arndb.de>,
 Bart Van Assche <bvanassche@acm.org>,
 John Garry <john.g.garry@oracle.com>,
 linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <367BED6D-3187-473C-BBF4-EB71A0E1677A@kolumbus.fi>
References: <20250225085644.456498-1-arnd@kernel.org>
To: Arnd Bergmann <arnd@kernel.org>
X-Mailer: Apple Mail (2.3826.400.131.1.6)


> On 25. Feb 2025, at 10.56, Arnd Bergmann <arnd@kernel.org> wrote:
>=20
> From: Arnd Bergmann <arnd@arndb.de>
>=20
> It appears that a typo has made it into the newly added code
>=20
> drivers/scsi/scsi_debug.c:3035:3: error: variable 'len' is =
uninitialized when used here [-Werror,-Wuninitialized]
> 3035 |                 len +=3D resp_compression_m_pg(ap, pcontrol, =
target, devip->tape_dce);
>      |                 ^~~
>=20
> Replace the '+=3D' with the intended '=3D' here.

One more of these ;) The fix is correct. (And now I checked with grep =
that v2 does not have any more of these.)

>=20
> Fixes: e7795366c41d ("scsi: scsi_debug: Add READ BLOCK LIMITS and =
modify LOAD for tapes")

The bug was actually in 568354b24c7d "scsi: scsi_debug: Add compression =
mode page for tapes"

> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Kai M=C3=A4kisara <kai.makisara@kolumbus.fi =
<mailto:kai.makisara@kolumbus.fi>>

> ---
> drivers/scsi/scsi_debug.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 722ee8c067ae..f3e9a63bbf02 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -3032,7 +3032,7 @@ static int resp_mode_sense(struct scsi_cmnd =
*scp,
> case 0xf: /* Compression Mode Page (tape) */
> if (!is_tape)
> goto bad_pcode;
> - len +=3D resp_compression_m_pg(ap, pcontrol, target, =
devip->tape_dce);
> + len =3D resp_compression_m_pg(ap, pcontrol, target, =
devip->tape_dce);
> offset +=3D len;
> break;
> case 0x11: /* Partition Mode Page (tape) */
> --=20
> 2.39.5
>=20
>=20

Thanks,
Kai


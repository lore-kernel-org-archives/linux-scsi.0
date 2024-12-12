Received: from fgw21-4.mail.saunalahti.fi (fgw21-4.mail.saunalahti.fi [62.142.5.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6916F215776
	for <linux-scsi@vger.kernel.org>; Thu, 12 Dec 2024 18:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.142.5.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734028122; cv=none; b=W3jJRQeGBVsHe/bVZblbDLE69HiEOirNKHMxgxsx6qHmfL3QCG19+JhlOUVRPyQQBRYSCx2TOA53RhxZmFuEI4Ct8zxt/7/9HEKQoNCoX39zFec/fvNCMIAOR3z6zpNLwYl5JRmEWU+3fnfXg17GaVwgZLbUVqgg1OZBI7m4PR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734028122; c=relaxed/simple;
	bh=JWKL7zKZUdq1409eCqTiWPFBEbeZUuY4UA4lIc2oeJ4=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=fAtef+ezDkKBjzIuQiuxSbQWj6tYoYip4H5yTtZ2swzTkNFbTyKhSndEOLVf+BjVoOeVL2au55GlecNelkoD52OxAh9yh2Y05/71HKmYu16FAzzqT6sJExVCeurR/z/lAxXBb+b82H6tl2pmVV0Jpp5v/w2IyvKsFyfEuO/6/ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi; spf=pass smtp.mailfrom=kolumbus.fi; dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b=nbN6swmK; arc=none smtp.client-ip=62.142.5.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b="nbN6swmK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=kolumbus.fi; s=elisa1;
	h=to:references:message-id:content-transfer-encoding:cc:date:in-reply-to:from:
	 subject:mime-version:content-type:from:to:cc:reply-to:subject:date:in-reply-to:
	 references:list-archive:list-subscribe:list-unsubscribe:content-type:
	 content-transfer-encoding:message-id;
	bh=uivl0z5FFDfSkYevq3qryosYqbmMXlj94CNoV/foQus=;
	b=nbN6swmKejHZZSODknPEwaPw7R9+PgCvUK9ceHtDnmGjRguOc8r1VOK+XOFkQh4dtHGf3TjVAOmO5
	 zPKJzL9NUC/vtuHLnzC49Hn+nPFel4HSWRnAE6OEq+3FLrGdXpPyI2MTivOc+tFbtzoK83OKHM+cDT
	 Ox2hn7uTfXwz4fQvcOiLMj+r83xGilSf6HdevGjV18cwNtlaW+6bocDlyOaWIl5MxsGP2ubvOfDUeP
	 3cMe9Z2pST9ehk6AvBjnRVIfLjR6BY5Lr13Ssa4MRqSGGR01f0jE9DpiCCHwdAenQYTLoFWUQ90PGw
	 NtCUPTTbKj0nUEycZ0HeVOMhWwXZGHA==
Received: from smtpclient.apple (85-156-116-90.elisa-laajakaista.fi [85.156.116.90])
	by fgw20.mail.saunalahti.fi (Halon) with ESMTPSA
	id bd35d5da-b8b6-11ef-9c13-005056bd6ce9;
	Thu, 12 Dec 2024 20:27:27 +0200 (EET)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.300.87.4.3\))
Subject: Re: [PATCH v2 0/4] scsi: st: scsi_error: More reset patches
From: =?utf-8?B?IkthaSBNw6RraXNhcmEgKEtvbHVtYnVzKSI=?= <kai.makisara@kolumbus.fi>
In-Reply-To: <0c6e699b-8f77-411f-b73d-e6762c6ad286@redhat.com>
Date: Thu, 12 Dec 2024 20:27:16 +0200
Cc: linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com,
 "James.Bottomley@hansenpartnership.com" <James.Bottomley@HansenPartnership.com>,
 loberman@redhat.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <8B3169CC-BD8A-46B5-B9B0-140047A44661@kolumbus.fi>
References: <20241125140301.3912-1-Kai.Makisara@kolumbus.fi>
 <0c6e699b-8f77-411f-b73d-e6762c6ad286@redhat.com>
To: John Meneghini <jmeneghi@redhat.com>
X-Mailer: Apple Mail (2.3826.300.87.4.3)

While doing some detective work, I found a serious problem. So, please =
hold these patches again.
More about the reason below.


> On 11. Dec 2024, at 23.57, John Meneghini <jmeneghi@redhat.com> wrote:
>=20
> Sorry it has taken me so long to get back to this....
>=20
> I've tested these patches with both my tape drive and with scsi_debug =
tape emulation.
>=20
> see:
>=20
>  https://github.com/johnmeneghini/tape_tests
>=20
> All hardware tests are passing and everything is working as expected =
with the tape drive tests, but the power on reset behavior of the =
scsi_debug test is still showing the some strangeness.
>=20
> =
https://github.com/johnmeneghini/tape_tests/blob/master/tape_reset_debug.s=
h
>=20
> Specifically, every time you reload the scsi_debug driver the SCSI mid =
layer clears the POR UA. If I am not mistaken, your intention with =
adding the counters for ua_new_media_ctr and ua_por_ctr to the mid layer =
was to catch these events and report them to the upper layer driver.
>=20
Well, the counters work as designed. The st driver stores reference =
values when the driver
probing the device. This means that the UAs before the probe are missed.

I previously suspected that the first POR UA is caught by scsi scanning =
when it issues
MAINTENANCE_IN to get the supported opcodes. This happens when scanning =
calls
scsi_cdl_check(). However, this function does not do anything if Scsi =
level is less than
SPC-5 (ANSi 7). Scsi_debug claims SPC-5 and so scsi_cdl_check() gets the =
UA
before the st device exists. Your drive probably is reporting a level =
less than SPC-5
and so the UA is not received by the scanning code.

I changed scsi_debug so that it reports SPC-4 (ANSI 6). After this =
change st received
the POR UA. But I had 'mt stsetoptions' in my script and it failed!


The problem is that no driver options for the device can be set before =
something has
been done to clear the blocking. For instance, the stinit tool is a =
recommended method
to set the options based on a configuration file, but it fails.

Note that this problem has existed since commit =
9604eea5bd3ae1fa3c098294f4fc29ad687141ea
(for version 6.6) that added recognition of POR UA as an additional =
method to detect
resets. Nobody seems to have noticed this problem in the "real world". =
(Using
was_reset was not problematic because it caught only resets initiated by =
the midlevel.)

A solution might be to add some more ioctls to the list of allowed =
commands.
But I must think about this a little more.


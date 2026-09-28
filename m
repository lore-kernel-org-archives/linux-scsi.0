Received: from fgw21-4.mail.saunalahti.fi (fgw21-4.mail.saunalahti.fi [62.142.5.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F105124336D
	for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2026 13:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.142.5.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790602054; cv=none; b=GjRVf3ib1/Rgz8WAngHPosERqoem8QpaKivgkaGlmBOmYjFbI1ey/ZxZMFdNnsvEpDaiyslbZH86nKNTWAbpkij6tazBMyYPD1oZmdlimv6USf3R2xc2f8yIn51zBvq3egSFUwtr2V17DMWsCi32MEq5NCO9Qb68ELpswLUrhQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790602054; c=relaxed/simple;
	bh=/2917F5eBWTJVJPKFE5HPORE/ddP+65grNbmztPS4Yk=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=kcAkApsEFvKVF0yyXsXLWTz8/vOm8Wd689MecKgZbehdTL6/nJ5Dmp1j0F6nozeAA8tYFHIsmuqSA+V6XspY/5Br+OlbOchXbjSvPWeJshgpDTKFaaEaqwvx6A8hw3MMNpvZ8tWJwA5YAe/Jia+vSn8ESRihKnwTvNdkX0ygbag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=kolumbus.fi; spf=pass smtp.mailfrom=kolumbus.fi; dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b=qZHnB3RT; arc=none smtp.client-ip=62.142.5.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b="qZHnB3RT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=kolumbus.fi; s=elisa1;
	h=to:references:message-id:content-transfer-encoding:cc:date:in-reply-to:from:
	 subject:mime-version:content-type:from:to:cc:reply-to:subject:date:in-reply-to:
	 references:list-archive:list-subscribe:list-unsubscribe:content-type:
	 content-transfer-encoding:message-id;
	bh=3ZHCvwFpiZpRYvCV8N0NdVC4pNtx0L+kHNelk8IsknY=;
	b=qZHnB3RTSvf+bre7FAbQr7WjSuyAgog557mCMAFwsSvf1uJBv+LPewgMEHsO8ztMz1MzZFvc+lMX7
	 8TEqi5kMWhCKoOHnqB54mfu5sn5JqNFBKVtBixfiaDHPXRPy8XiUmMpRuPZg8f8XSYpf9O1cc/JvAR
	 Mpz0cN2Jv9SE5TXTe9bfRaVrhFWiAUAhtZQ3XYuoq6+DordtNT+gcTRmVBb9RdwG1tlcuAxrb1iFxz
	 MbiP0+OEk5jWB+zo/ss469ql9T+CWrWIXwLy0TyqiaEnySSGgUVkIFycNj0L8ybmE4gjMJ54O2I0GU
	 OrLE9ldhsnsgHiQelZBZp8xt7dlImOg==
Received: from smtpclient.apple (91-158-174-119.elisa-laajakaista.fi [91.158.174.119])
	by fgw23.mail.saunalahti.fi (Halon) with ESMTPSA
	id 2fde11a1-bb40-11f1-b8ae-005056bdfda7;
	Mon, 28 Sep 2026 16:26:18 +0300 (EEST)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.11\))
Subject: Re: [PATCH 0/2] scsi: st: Fix drive settings and position after reset
 recovery with MTLOAD/MTRETEN
From: =?utf-8?B?IkthaSBNw6RraXNhcmEgKEtvbHVtYnVzKSI=?= <kai.makisara@kolumbus.fi>
In-Reply-To: <20260927131019.4188777-1-loberman@redhat.com>
Date: Mon, 28 Sep 2026 16:26:07 +0300
Cc: linux-scsi@vger.kernel.org,
 jmeneghi@redhat.com,
 emilne@redhat.com,
 bgurney@redhat.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <DC732DB9-1C0C-43F4-BE26-861AB8167A83@kolumbus.fi>
References: <20260927131019.4188777-1-loberman@redhat.com>
To: Laurence Oberman <loberman@redhat.com>
X-Mailer: Apple Mail (2.3901.100.1.1.11)

Just a couple of quick notes. I will try to find time to look at the =
changes more thoroughly
later (as a non-maintainer). (And I am happy to see that improvements =
are being made.)

> On 27. Sep 2026, at 16.10, Laurence Oberman <loberman@redhat.com> =
wrote:
>=20
> ...

> 1. Changed block size and density are silently lost
>=20
> ...

>                                                                        =
       scsi_debug reports a new
>   medium after MTRETEN and MTLOAD; the IBM drives do not.  The series
>   was tested against both behaviours.

This is the only place where scsi_debug deliberately does not follow the =
standards.
According to the standard, the drive should not report new medium in =
this case. This
deviation was made to enable testing of this condition somehow. =
(scsi_debug does
not support insertion of a new tape.)

Otherwise scsi_debug should follow the standard as far as features have =
been
implemented. But there may be bugs outside of what has been tested. So, =
if
a real drive and scsi_debug behave differently, scsi_debug maybe wrong.
However, in some cases, alternative behaviours are defined in the =
standard.
scsi_debug has implemented one and it may not be the one the drive is
implementing.

Thanks, Kai


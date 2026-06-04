Received: from fgw21-4.mail.saunalahti.fi (fgw21-4.mail.saunalahti.fi [62.142.5.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5182D2F8BC3
	for <linux-scsi@vger.kernel.org>; Thu,  4 Jun 2026 16:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.142.5.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780589861; cv=none; b=RKhfMz6pNoIrylTRnULKvCngAoXz9rfDNAWEwBWZYR45m12mjlRioemxpUsOn2Xk+DRLGFTdOAyRt3Q/Sn/ap7ri+blCcS2qdnY7F2W5Z8hgiOC+axXpauLC85V0/WAs1BTI7bWLIuB/Xv6AEJtEk98HTwDQ8u2D5pNMRkGlrwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780589861; c=relaxed/simple;
	bh=FRdlQu7BcA8fq7z+3VkzX0Usn5ov6QySs/JHeqtpjyg=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=XjBooExlWLgCUYez6ivSiLa2MtnLwl3J0t+qv1ATtGZcnJ1o/7Wm1i4UgT9aAESNtiZmFimIBS5y6cLmeR0nmR7sFPIS9DM60sew21w2hIGdR0MU6WRu6lepPtou6nH6Ofvct0K/G5pUb8n0AkafTgEDTUOZDq4la7o8jNW64SU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=kolumbus.fi; spf=pass smtp.mailfrom=kolumbus.fi; dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b=NNlMSkWj; arc=none smtp.client-ip=62.142.5.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b="NNlMSkWj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=kolumbus.fi; s=elisa1;
	h=to:references:message-id:content-transfer-encoding:cc:date:in-reply-to:from:
	 subject:mime-version:content-type:from:to:cc:reply-to:subject:date:in-reply-to:
	 references:list-archive:list-subscribe:list-unsubscribe:content-type:
	 content-transfer-encoding:message-id;
	bh=bK4h7to7xUuBQ+q3Gn8w+apjkF3IcoVqBvSnzXuWPbI=;
	b=NNlMSkWjbD6RRY1GWh5VqWzCzcX2qFv7g7KrxcshwizjSZklsTBtTXcyBiBvoKVB/9y3T/MNFHEE8
	 6IIiZvidaEW6y3fZjCWmPEG1nlPix/k9/0CNF/5WzG4hUZSrpmx6H37sFEXNHDBSSdkKoBlnFbz3WX
	 yhtd0Ejl8S89bD7/N33s7GztRUFmp7qj3JW79IhTgnDdX+drPmUxqf044SfHZ0c2ZL+4Qb97Lv7+mo
	 Xw9x5xIux96UxQk8FYHCtsoi5ZRc6PNSolR50k06crz5fjtVUhzL2fv9Usi+dYOewhPPI7KcXbTlwK
	 wRprYmlvplIlZUvAyTE3FoKpOad1dRA==
Received: from smtpclient.apple (91-158-174-119.elisa-laajakaista.fi [91.158.174.119])
	by fgw20.mail.saunalahti.fi (Halon) with ESMTPSA
	id ba1731fc-6030-11f1-9518-005056bd6ce9;
	Thu, 04 Jun 2026 19:16:22 +0300 (EEST)
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
In-Reply-To: <8D712AEA-D91F-4A75-A7B3-FCF44F5823BF@kolumbus.fi>
Date: Thu, 4 Jun 2026 19:16:12 +0300
Cc: Samuel Moelius <sam.moelius@trailofbits.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 "open list:SCSI SUBSYSTEM" <linux-scsi@vger.kernel.org>,
 open list <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <E8A083A7-1A8C-479C-BD40-046A8B01D2B7@kolumbus.fi>
References: <20260603235616.124535-1-sam.moelius@trailofbits.com>
 <6d2e78e6a5840f5892e7eb081657b23aa62bc50d.camel@HansenPartnership.com>
 <8D712AEA-D91F-4A75-A7B3-FCF44F5823BF@kolumbus.fi>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
X-Mailer: Apple Mail (2.3864.600.51.1.1)



> On 4. Jun 2026, at 17.52, Kai M=C3=A4kisara (Kolumbus) =
<kai.makisara@kolumbus.fi> wrote:
>=20
>=20
>=20
>> On 4. Jun 2026, at 16.38, James Bottomley =
<James.Bottomley@HansenPartnership.com> wrote:
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
>>=20
> The code marks partition 1 as EOD and does not corrupt anything. The =
tape has partitions
> until either EOD partition is encountered or TAPE_MAX_PARTITIONS is =
reached. I would
> be very hesitant to remove this initialization.
>=20
I looked more carefully at the code:-) Each partition ends at EOD block. =
But I would still not like
to remove this initialization because, even if it is not necessary, it =
is harmless. There has been a
reason to do the initialization like that at some time. And the code is =
simpler as it is now.

Thanks,
Kai


Received: from fgw23-4.mail.saunalahti.fi (fgw23-4.mail.saunalahti.fi [62.142.5.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FB071B3922
	for <linux-scsi@vger.kernel.org>; Fri, 13 Dec 2024 13:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.142.5.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734095441; cv=none; b=dwu3jjKoHsLcGMo4XokwB9gUQhO9Gho7SNuvPqOgDuthEH+dPzoi+y7Ejjx1ThcLaYsOk6ckVuWFkgiU8GvoI8aZW+CqTiE3V7hDgVCWCCobXTYLTe0z4KQoVgxisiaJK0DmvJGzik4us7l3LOpbyGBwsZXru6jVQublFIm6iYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734095441; c=relaxed/simple;
	bh=vfNfwxnHQJP5jbtjS5adEdI1JrNsx9CYBUZ7fz/mjI4=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=Tpzv6DMj1mwAwy03eN5AJmHhF0hu0B33t3GHh7WYpqh6xJZFf5SpUQsGCjXBTxifPAfYsx6wFSDz3aYwR4AtF9lR15fQFkqLvpWTmWnjcPl4gUOxiyIa5iWFXuMMpkKOvSIshDVdZ7fQ/T4m1OBa+gHmH1pm46eC7rL/OYbAE5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi; spf=pass smtp.mailfrom=kolumbus.fi; dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b=StqFaX4y; arc=none smtp.client-ip=62.142.5.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b="StqFaX4y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=kolumbus.fi; s=elisa1;
	h=to:references:message-id:content-transfer-encoding:cc:date:in-reply-to:from:
	 subject:mime-version:content-type:from:to:cc:reply-to:subject:date:in-reply-to:
	 references:list-archive:list-subscribe:list-unsubscribe:content-type:
	 content-transfer-encoding:message-id;
	bh=vfNfwxnHQJP5jbtjS5adEdI1JrNsx9CYBUZ7fz/mjI4=;
	b=StqFaX4yVVay9Vie8bR7bu60TFJ/iwRGZsUZHvwwMjxJvj8xDo6jLf1699ZgxCc9HczJXJRQHoXx8
	 D4XI2rtTb8e4cs0Dk2OEZKc3OEgff5Lkan7WJMwtTGuMhvyWbizt0+v+DBRYXEnT8wr8KeNSJcs8CI
	 H2oZarY/s5QVO7Wnw8X0ySPDpDYDbrzSD+jd0k2w485hEhA6OqSL3djCUeIJu1J+17HTzQXOmTw2AY
	 94UtCkpWSutmI4DTvEoy+3XRHAt/MBqN3IrU7kVImHYj2UP9TC5iZVzOGlTgRpPS3cAzZrjd9EpW++
	 1PpHTeAS3zp+uSeO+bWmX6H8MOocU+w==
Received: from smtpclient.apple (85-156-116-90.elisa-laajakaista.fi [85.156.116.90])
	by fgw23.mail.saunalahti.fi (Halon) with ESMTPSA
	id 7a657f48-b953-11ef-a138-005056bdfda7;
	Fri, 13 Dec 2024 15:09:26 +0200 (EET)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.300.87.4.3\))
Subject: Re: [PATCH v2 0/4] scsi: st: scsi_error: More reset patches
From: =?utf-8?B?IkthaSBNw6RraXNhcmEgKEtvbHVtYnVzKSI=?= <kai.makisara@kolumbus.fi>
In-Reply-To: <8B3169CC-BD8A-46B5-B9B0-140047A44661@kolumbus.fi>
Date: Fri, 13 Dec 2024 15:09:15 +0200
Cc: linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com,
 "James.Bottomley@hansenpartnership.com" <James.Bottomley@HansenPartnership.com>,
 loberman@redhat.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <964CF609-B7DB-44CF-80A2-2955E73561EF@kolumbus.fi>
References: <20241125140301.3912-1-Kai.Makisara@kolumbus.fi>
 <0c6e699b-8f77-411f-b73d-e6762c6ad286@redhat.com>
 <8B3169CC-BD8A-46B5-B9B0-140047A44661@kolumbus.fi>
To: John Meneghini <jmeneghi@redhat.com>
X-Mailer: Apple Mail (2.3826.300.87.4.3)


> On 12. Dec 2024, at 20.27, Kai M=C3=A4kisara (Kolumbus) =
<kai.makisara@kolumbus.fi> wrote:
>=20
> While doing some detective work, I found a serious problem. So, please =
hold these patches again.
> More about the reason below.
...
> The problem is that no driver options for the device can be set before =
something has
> been done to clear the blocking. For instance, the stinit tool is a =
recommended method
> to set the options based on a configuration file, but it fails.
>=20
> Note that this problem has existed since commit =
9604eea5bd3ae1fa3c098294f4fc29ad687141ea
> (for version 6.6) that added recognition of POR UA as an additional =
method to detect
> resets. Nobody seems to have noticed this problem in the "real world". =
(Using
> was_reset was not problematic because it caught only resets initiated =
by the midlevel.)
>=20
> A solution might be to add some more ioctls to the list of allowed =
commands.
> But I must think about this a little more.

This does not seem to be a promising direction. I think it is better to =
see that the
first test_ready() (called from st_open()) does not set the pos_unknown =
flag.
If there are no objections, I will add this to the next version of the =
patches.

The justification for this solution is that just after the device is =
detected by st,
the position of the tape is known to the user and there is no need to =
prevent,
for instance, writing to the tape.


Received: from fgw21-4.mail.saunalahti.fi (fgw21-4.mail.saunalahti.fi [62.142.5.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E490332C957
	for <linux-scsi@vger.kernel.org>; Fri, 24 Oct 2025 16:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.142.5.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761325093; cv=none; b=Hso+0jXYrR1VZmcY0lHK7fFqsrgK5s+461TNlR8KL85gC4VcotTyyizCqEm1Fj1hZKUkjdc/WX0xDHc0i9P2l7h081ZQnWsZ1zjLZLHk08tfmw5ILptzQ2qe+F5IlcxUQrlerN7i5Pbr0RVSwDENT0qJ59h3qLE4HMhivS3KNCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761325093; c=relaxed/simple;
	bh=3j65ztLGJgwoFPORga8AqHM/g6Nf4GbQRbj9nIBsWNM=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=MEHCF9cLljjNqKDtxL31DaKTYpRTJ6NnJAJFQyrac+pvq8eUdpuGq/g+Vlqp4potkLivF9Ms5UuZOExEmw6rJutjqu7ei1t06QhJbR0FK3ORmpGU9PMY5UK7AEI152ZLa2kPPvV6rnb7vecMi1y9eYXpK9UK4Aa0/0LRemwEH0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi; spf=pass smtp.mailfrom=kolumbus.fi; dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b=NiQ7AjCe; arc=none smtp.client-ip=62.142.5.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b="NiQ7AjCe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=kolumbus.fi; s=elisa1;
	h=to:references:message-id:content-transfer-encoding:cc:date:in-reply-to:from:
	 subject:mime-version:content-type:from:to:cc:reply-to:subject:date:in-reply-to:
	 references:list-archive:list-subscribe:list-unsubscribe:content-type:
	 content-transfer-encoding:message-id;
	bh=3j65ztLGJgwoFPORga8AqHM/g6Nf4GbQRbj9nIBsWNM=;
	b=NiQ7AjCet1y/QQAmaVn+vi8uRamv0A5xZd0Q+bQ+ublnMQnWB8/+agcbceLHii6OHTd0h/S5c2wXs
	 +BFXzfhP0zvQ6j6cMswpkaxuipN0K+zd9tFChZVoHjpZjETuctd8Wwsm0Ic8Qq7gk6q5g7UZpLdnJN
	 SMgJAePBP4IjAZ2yYPpdMHZGQtkd80iAXnYtTYUcOatCe5vhh63lZoKjHGX7TBwEGJa6zmdQ0vOjA4
	 YIjn7BGmK3c4OYiQO2qJUyOlz+Qwy1eLOIkMFnXqo6CHZfq085BqPx+3CrYhzhwVPmBD2rSpcZ+Cbs
	 kkWPKr60a7PK8TgzQTe512/fVQrLlpQ==
Received: from smtpclient.apple (85-156-116-90.elisa-laajakaista.fi [85.156.116.90])
	by fgw21.mail.saunalahti.fi (Halon) with ESMTPSA
	id 743fb26f-b0fa-11f0-99c7-005056bdd08f;
	Fri, 24 Oct 2025 19:56:58 +0300 (EEST)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.100.1.1.5\))
Subject: Re: [PATCH] scsi: st: skip buffer flush for information ioctls when
 there is no buffering
From: =?utf-8?B?IkthaSBNw6RraXNhcmEgKEtvbHVtYnVzKSI=?= <kai.makisara@kolumbus.fi>
In-Reply-To: <CA+-xHTEibYoSbmBN-Qx9OoXo9nb75AQbivOT6Y-FKVUEAEWKRg@mail.gmail.com>
Date: Fri, 24 Oct 2025 19:56:48 +0300
Cc: linux-scsi@vger.kernel.org,
 Laurence Oberman <loberman@redhat.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <D6A381D7-994C-4D75-8FA9-9D2C60AC6862@kolumbus.fi>
References: <20251023140531.5197-1-djeffery@redhat.com>
 <1D000F1D-7FE1-434C-AAB7-DEFF0FDD4106@kolumbus.fi>
 <CA+-xHTEibYoSbmBN-Qx9OoXo9nb75AQbivOT6Y-FKVUEAEWKRg@mail.gmail.com>
To: David Jeffery <djeffery@redhat.com>
X-Mailer: Apple Mail (2.3864.100.1.1.5)


> On 24. Oct 2025, at 18.42, David Jeffery <djeffery@redhat.com> wrote:
>=20
> On Fri, Oct 24, 2025 at 7:58=E2=80=AFAM "Kai M=C3=A4kisara (Kolumbus)"
> <kai.makisara@kolumbus.fi> wrote:
>>=20
...
>> The patch includes a huge jump over most of the code. This makes it
>> a little difficult to understand. I think it would be better to =
handle this
>> condition locally around the call to flush_buffer(). This would make =
it
>> clear to see what this does, without having to check the code being
>> jumped over.
>=20
> If that is your preference, I have no problem with changing it. I =
wasn't
> thrilled with either location.

That is my preference and I wanted to say that. But it is not an =
absolute
requirement.

>=20
>> Another thing is handling the non-empty buffer. Could the patch just
>> skip flush_buffer() unconditionally? I don't like to have code that
>> mysteriously fails in some cases without a clear reason: why can't =
one
>> ask the IDs even if the buffer is not empty?
>=20
> I originally wrote a version which worked this way, but discarded it =
out
> of concern that there may be tape software which expects the current
> behavior and uses some of the ioctls as an overly clever method to
> flush the buffer. The flush behavior has been there a long time so I =
was
> concerned about completely removing it and risking breaking some
> other application.
>=20
> Perhaps my paranoia about changing the behavior is unwarranted. Do
> you think it best to completely ignore any flushing or buffering for =
these
> IDing ioctls?

It is always good to not break existing behavior and I also thought =
about
that. But there are also other, maybe conflicting, aspects, like =
simplification
of code paths and not to provide surprises to those who have not yet
experienced the quirks.

Either behavior is OK for me.

>=20
>> This problem also provides an opportunity to slight cleaning the
>> code by moving handling of pass-through to a new function. The the
>> rest of st_ioctl() would then just concentrate on the MTIOC_* ioctls.
>=20
> st_ioctl is quite the mess with how things are laid out. I can see
> about making a version which moves the handling of generic scsi
> ioctls into its own function instead of adding to st_ioctl's =
complexity.

st_ioctl() has grown a very long time: small bits of code have been
added time after time. One strong motive has been to limit the
testing effort. This is why I nowadays try to look for opportunities
to safe simplification and clarification of the code when something
has to be changed :-)

Thanks, Kai


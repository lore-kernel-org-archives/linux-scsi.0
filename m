Received: from fgw22-4.mail.saunalahti.fi (fgw22-4.mail.saunalahti.fi [62.142.5.109])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A94113D612
	for <linux-scsi@vger.kernel.org>; Fri,  6 Sep 2024 06:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.142.5.109
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725603603; cv=none; b=aoVNay3EJRpRIGGAa5weWQJzgLeap/XcrgddmdMCzoWpVcCwCtNrrCcJ7LjfFDzvfwZvc4mBWR+Ykld9XSaIMnrZiwfZHiKIdFkCrQlENjEccD4MVHZNPpt6DbFEMXszlC4EwQE+AQ093zrJSy6uMjiyqAURMdrfcAFQCiGyGk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725603603; c=relaxed/simple;
	bh=BjBX8BWOtWjmV8D0Coo1ShsRvRxSWaHo7jtVDuA5kZ8=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=NbvOTXbyd+8sckMEJf0KAuWcaTx7nxyZnFx9/dhuvowXx35FZkR9JsVOufZ7POpVHPeP1Aio853oJbazoHln4t5cg0t62qp/WiOK5lx4Y6olRGXN5sCDH7BKlfrFx+u9224bxaT/BO/ahZNYLhBwxdKaYSQ955Six2uMT2/+7ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi; spf=pass smtp.mailfrom=kolumbus.fi; dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b=ekat/gax; arc=none smtp.client-ip=62.142.5.109
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b="ekat/gax"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=kolumbus.fi; s=elisa1;
	h=to:references:message-id:content-transfer-encoding:cc:date:in-reply-to:from:
	 subject:mime-version:content-type:feedback-id:from:to:cc:reply-to:subject:date:
	 in-reply-to:references:list-archive:list-subscribe:list-unsubscribe:
	 content-type:content-transfer-encoding:message-id;
	bh=BjBX8BWOtWjmV8D0Coo1ShsRvRxSWaHo7jtVDuA5kZ8=;
	b=ekat/gaxF6Ke4AilBw2O4NUYKsasvtK02LcC29rtTxG3U552T80CMdVVg5qccag1rgmwGx/OH4sjZ
	 lfGiL4WXAnBM61bmuTYj1ju3jENf9z/fMpU7jiLyZLsgn0UBGDsWLEdJ2uOuBTVGvXciNrEQT25ukU
	 6fkXpa9MrE9iA8qilYRlY2FUAwe73atTtXm4C5wtLDLNLBm9WmhuAtN89rq2sv0wY0Fgn7n0xVHSvW
	 jp1s4a+gu2UKxiJNnb58UzkTBJJRBWqq1p2jZxE5rE7sENbw7voENKcShu0ev7xkSA4gmjCS8hnRwj
	 fr4vgRJfvwblXEVS6SItuhGd7V+kzwg==
Feedback-ID: 5c3835a5:74d1b5:smtpa:elisa
Received: from smtpclient.apple (85-156-116-90.elisa-laajakaista.fi [85.156.116.90])
	by fgw22.mail.saunalahti.fi (Halon) with ESMTPSA
	id 03303125-6c18-11ef-8ed8-005056bdf889;
	Fri, 06 Sep 2024 09:19:47 +0300 (EEST)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3776.700.51\))
Subject: Re: [PATCH] scsi: st: Fix input/output error on empty drive reset
From: =?utf-8?B?IkthaSBNw6RraXNhcmEgKEtvbHVtYnVzKSI=?= <kai.makisara@kolumbus.fi>
In-Reply-To: <20240905173921.10944-1-rrochavi@fnal.gov>
Date: Fri, 6 Sep 2024 09:19:35 +0300
Cc: "James.Bottomley@hansenpartnership.com" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org,
 LKML <linux-kernel@vger.kernel.org>,
 rrochavi@fnal.gov
Content-Transfer-Encoding: quoted-printable
Message-Id: <7E1751DB-16D7-430C-BDAC-CFE3D39EC126@kolumbus.fi>
References: <20240905173921.10944-1-rrochavi@fnal.gov>
To: Rafael Rocha <vidurri@gmail.com>
X-Mailer: Apple Mail (2.3776.700.51)



> On 5. Sep 2024, at 20.39, Rafael Rocha <vidurri@gmail.com> wrote:
>=20
> A previous change was introduced to prevent data loss during a =
power-on reset
> when a tape is present inside the drive. This change set the =
"pos_unknown" flag
> to true to avoid operations that could compromise data by performing =
actions
> from an untracked position. The relevant commit is:
>=20
> Commit: 9604eea5bd3ae1fa3c098294f4fc29ad687141ea
> Subject: scsi: st: Add third-party power-on reset handling
>=20
The pos_unknown flag was introduced to prevent writing and reading from =
an
unknown position (usually when the drive rewinds the tape when the =
device
is reset). This commit added code to catch a case which the midlevel did
not catch.

> As a consequence of this change, a new issue has surfaced: the driver =
now
> returns an "Input/output error" even for empty drives when the drive, =
host, or
> bus is reset. This issue stems from the "flush_buffer" function, which =
first
> checks whether the "pos_unknown" flag is set. If the flag is set, the =
user will
> encounter an "Input/output error" until the tape position is known =
again. This
> behavior differs from the previous implementation, where empty drives =
were not
> affected at system start up time, allowing tape software to send =
commands to
> the driver to retrieve the drive's status and other information.
>=20
> The current behavior prioritizes the "pos_unknown" flag over the =
"ST_NO_TAPE"
> status, leading to issues for software that detects drives during =
system
> startup. This software will receive an "Input/output error" until a =
tape is
> loaded and its position is known.
>=20
> To resolve this, the "ST_NO_TAPE" status should take priority when the =
drive is
> empty, allowing communication with the drive following a power-on =
reset. At the
> same time, the change should continue to protect data by maintaining =
the
> "pos_unknown" flag when the drive contains a tape and its position is =
unknown.

> Signed-off-by: Rafael Rocha <rrochavi@fnal.gov>
>=20
The patch changes the semantics of flush_buffer() slightly. Obviously, =
nothing should
be flushed if position is unknown, but the return code changes when the =
drive is not
ready. This changes the path the code takes after reset if the drive is =
not ready.
I looked at the code and this should not cause problems. So:

Acked-by: Kai M=C3=A4kisara <kai.makisara@kolumbus.fi =
<mailto:kai.makisara@kolumbus.fi>>

As an sdded note: when looking at the code, another possibility might be =
to not
set pos_unknown if (STp->ready !=3D ST_READY), But if your simple change =
is
enough, it is wise not to make more complex changes.

Thanks,
Kai


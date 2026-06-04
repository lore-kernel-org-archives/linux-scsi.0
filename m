Received: from lamorak.hansenpartnership.com (lamorak.hansenpartnership.com [198.37.111.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44464314D06;
	Thu,  4 Jun 2026 19:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.37.111.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780601397; cv=none; b=mJsuYk5dQQmetgK/aw0nRPcOWWCR+Fi6nC88MFTF7VSAedw0u/Iq8puEN+ToEEf4SFpiqIhHhJtDTNr7tfjyO9rBERcVPLUo2Aazxtw3240lKlNB6/RO/XQ/kTJaxAMp0+Jm7de9IHvuGu5KZm0zh8akq8SpJUKwz8PVTOx+Ckc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780601397; c=relaxed/simple;
	bh=H/wOIvawvjVXVPxI/cnukywek+MrG3barlkBXVRwM9o=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bdJCyH/+Q0hHTshPFea1E0Dj4OaSRRHgl7LPyv4oPEqP2EK2LreJwDMa6QgXTMPIauHjMEvKVHjyhzGHERIS86Q9pCc9ITs4eU7QJf2gDKiXjGOwJqHbplHV0bovf1PQ49pzyyBqutoQKR+Ua0ucwjOP5UMOQhXbvOdm47qDzMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=LCDdPl/m; arc=none smtp.client-ip=198.37.111.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="LCDdPl/m"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1780601394;
	bh=H/wOIvawvjVXVPxI/cnukywek+MrG3barlkBXVRwM9o=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
	b=LCDdPl/mDrSaDN5uW+NKzfAWLHJ6lFYUmfW0M232F4Fy/gCXt6ENe8GeoIhmma1JQ
	 /8UcIc5x98HtTWvnuvai+vBsPp/B8eg10VQa4eMn6Bsyge1S+MS53bPE06JZXJ96rz
	 yTtKuRAJi5iFU0dfhxwTXBa0ZOrKadugcyrDA0Xk=
Received: from lingrow.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4300:d341::8c71])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lamorak.hansenpartnership.com (Postfix) with ESMTPSA id E9D9A1C027B;
	Thu, 04 Jun 2026 15:29:53 -0400 (EDT)
Message-ID: <c56802d9d3f05635c5b126687d0351a647801a77.camel@HansenPartnership.com>
Subject: Re: [PATCH v2] scsi: scsi_debug: fix one-partition tape setup bounds
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: "\"Kai" =?ISO-8859-1?Q?M=E4kisara?= "(Kolumbus)\""
	 <kai.makisara@kolumbus.fi>, Samuel Moelius <sam.moelius@trailofbits.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, "open list:SCSI
 SUBSYSTEM" <linux-scsi@vger.kernel.org>, open list
 <linux-kernel@vger.kernel.org>
Date: Thu, 04 Jun 2026 15:29:53 -0400
In-Reply-To: <4A3BD9E5-21E2-40F7-9242-71589477F2EF@kolumbus.fi>
References: <20260603235616.124535-1-sam.moelius@trailofbits.com>
	 <6d2e78e6a5840f5892e7eb081657b23aa62bc50d.camel@HansenPartnership.com>
	 <CAE+C+DbpB6UP29WTNGgrnYqhazEC5=5ErNJiChrDz8sygC_-0w@mail.gmail.com>
	 <4A3BD9E5-21E2-40F7-9242-71589477F2EF@kolumbus.fi>
Autocrypt: addr=James.Bottomley@HansenPartnership.com;
 keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.3 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 2026-06-04 at 22:14 +0300, Kai M=C3=A4kisara (Kolumbus) wrote:
>=20
> > On 4. Jun 2026, at 21.33, Samuel Moelius
> > <sam.moelius@trailofbits.com> wrote:
> >=20
> > On Thu, Jun 4, 2026 at 9:38=E2=80=AFAM James Bottomley
> > <James.Bottomley@hansenpartnership.com> wrote:
> > >=20
> > > On Wed, 2026-06-03 at 23:55 +0000, Samuel Moelius wrote:
> > > > The tape setup path writes partition metadata one element past
> > > > the
> > > > allocated tape_blocks array when a one-partition configuration
> > > > is
> > > > selected.
> > > >=20
> > > > That corrupts adjacent state during device initialization
> > > > before any
> > > > command is issued.
> > >=20
> > > I still don't get what the actual problem is.=C2=A0 For a single
> > > partition
> > > tape I can't see where scsi_debug would actually do anything with
> > > tape_blocks[1].=C2=A0 What is it that you're seeing when using
> > > scsi_debug
> > > that motivates this?
> >=20
> > The bug is a kernel OOB write. I can share a PoC if desired. The
> > PoC
> > sends this SCSI command through /dev/sgN:
> >=20
> > ...
>=20
> > Then the bug: it initializes partition 1 even though there is only
> > one
> > partition:
> >=20
> > =C2=A0=C2=A0 devip->tape_eop[1] =3D part_1_size;
> > =C2=A0=C2=A0 devip->tape_blocks[1] =3D devip->tape_blocks[0] +
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 devip->tape_eop[0];
> > =C2=A0=C2=A0 devip->tape_blocks[1]->fl_size =3D TAPE_BLOCK_EOD_FLAG;
> >=20
> > Because devip->tape_eop[0] =3D=3D 10000, this computes:
> >=20
> > =C2=A0=C2=A0 devip->tape_blocks[1] =3D devip->tape_blocks[0] + 10000
> >=20
> > But the allocation has only 10000 elements. So this write is one
> > element past the allocation.
>=20
> OK. The bug is not initialization of the pointer but writing the
> fl_size using the pointer. Good catch!

Isn't the fix actually to allocate an extra block for the EOF:

@@ -6648,7 +6648,7 @@ static int scsi_debug_sdev_configure(struct scsi_devi=
ce *sdp,
        if (sdebug_ptype =3D=3D TYPE_TAPE) {
                if (!devip->tape_blocks[0]) {
                        devip->tape_blocks[0] =3D
-                               kzalloc_objs(struct tape_block, TAPE_UNITS)=
;
+                               kzalloc_objs(struct tape_block, TAPE_UNITS =
+ 1);
                        if (!devip->tape_blocks[0])
                                return 1;

?

Regards,

James


Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AFF933997
	for <linux-scsi@vger.kernel.org>; Wed,  6 Aug 2025 05:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754459182; cv=none; b=rdjzVgpAVrD5GbiquUa2AvAQPzPDUxHlWSjdGZi1fMPa8n32SYeLZAtr9SzpfxYbAQSXxdUg6sytvUWYDFKQ7gbsSTMzftFbeX1tCqGpsqSDfzseTi2W3Y39QJpMEbArMkR+n+fIP/Nz48VxbFlokK1XUBIjkxCmo4hUM1F1ph4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754459182; c=relaxed/simple;
	bh=okxzfA4ehROgnHZTTGa7DbT14N2ToN6xblvJZauS86s=;
	h=From:To:Cc:In-Reply-To:Subject:Date:Message-ID:MIME-Version:
	 Content-Type:References; b=YIDZ9YF+WOPgquGALDv9Z13Q+NEoshq2l+190rL35NTBRlur1ahuFW/YiJ+rviAqPKXKLpBLI6MvGaD+zEyCJEbFLK1Oo3bVsixaN/4RI4ilxdotnJ9RCbvSOeFX8b3UQcAGVnGl3rUdCDRc0ixuR64BjCFA35nLbYPYFAfGEkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=m4/b0Nmv; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="m4/b0Nmv"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20250806054617epoutp021d6fd3203c3650f24741ee1c9d0ee91e~ZF1OrVxSJ2859828598epoutp02B
	for <linux-scsi@vger.kernel.org>; Wed,  6 Aug 2025 05:46:17 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20250806054617epoutp021d6fd3203c3650f24741ee1c9d0ee91e~ZF1OrVxSJ2859828598epoutp02B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1754459178;
	bh=okxzfA4ehROgnHZTTGa7DbT14N2ToN6xblvJZauS86s=;
	h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
	b=m4/b0NmveHN25uhqHkwPV0Nk9ygtgU+Zf3UGqfLnBm6HAfanMVgVI/61G8MZdrERA
	 5SxEAxrRh8cWQ9KJbcBolbQlFa88SW7KPEo4EoYLJIQSj+BwKSyFjouWmmYOOcXCQE
	 t2DtXPTy4IlpQEh/2Ju/SGn0XxC0osUPOvjQsXyk=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20250806054617epcas5p255ba667ff67703ace638e1e6388274e9~ZF1OHOEFd0123401234epcas5p2D;
	Wed,  6 Aug 2025 05:46:17 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.90]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4bxfRW26z6z6B9mH; Wed,  6 Aug
	2025 05:46:15 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20250806054614epcas5p3407494fd3bf0360c722af9c7c6ada6c5~ZF1LrX9Z32821128211epcas5p3Y;
	Wed,  6 Aug 2025 05:46:14 +0000 (GMT)
Received: from INBRO002756 (unknown [107.122.3.168]) by epsmtip2.samsung.com
	(KnoxPortal) with ESMTPA id
	20250806054612epsmtip21f6922fa6ab9f9435ba827c8073ab5b1~ZF1JdqIk70912409124epsmtip2f;
	Wed,  6 Aug 2025 05:46:12 +0000 (GMT)
From: "Alim Akhtar" <alim.akhtar@samsung.com>
To: "'Manivannan Sadhasivam'" <mani@kernel.org>
Cc: "'Konrad Dybcio'" <konrad.dybcio@oss.qualcomm.com>, "'Krzysztof
 Kozlowski'" <krzk@kernel.org>, "'Ram Kumar Dwivedi'"
	<quic_rdwivedi@quicinc.com>, <avri.altman@wdc.com>, <bvanassche@acm.org>,
	<robh@kernel.org>, <krzk+dt@kernel.org>, <conor+dt@kernel.org>,
	<andersson@kernel.org>, <konradybcio@kernel.org>,
	<James.Bottomley@hansenpartnership.com>, <martin.petersen@oracle.com>,
	<agross@kernel.org>, <linux-arm-msm@vger.kernel.org>,
	<linux-scsi@vger.kernel.org>, <devicetree@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
In-Reply-To: <wpfchmssbrfhcxnoe37agonyc5s7e2onark77dxrlt5jrxxzo2@g57mdqrgj7uk>
Subject: RE: [PATCH 2/3] arm64: dts: qcom: sa8155: Add gear and rate limit
 properties to UFS
Date: Wed, 6 Aug 2025 11:16:11 +0530
Message-ID: <06f301dc0695$6bf25690$43d703b0$@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Content-Language: en-us
Thread-Index: AQKnlt0Ez4U7OU6i7DDtpxZiPKvKiQEsJt2OAdY+bWECqijPQgIPv58TAQlCtSUCbRSB8gJXYzfzAduHMkYBp6Y8EQJl+KeTsiJiETA=
X-CMS-MailID: 20250806054614epcas5p3407494fd3bf0360c722af9c7c6ada6c5
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250805170638epcas5p4cb0cc78c5b5d77072cec547380b9f03d
References: <jogwisri2gs77j5cs3xwyezmfsotnizvlruzzelemdj5xadqh4@loe7fsatoass>
	<CGME20250805170638epcas5p4cb0cc78c5b5d77072cec547380b9f03d@epcas5p4.samsung.com>
	<b235e338-8c16-439b-b7a5-24856893fb5d@oss.qualcomm.com>
	<061b01dc062d$25c47800$714d6800$@samsung.com>
	<i6eyiscdf2554znc4aaglhi22opfgyicif3y7kzjafwsrtdrtm@jjpzak64gdft>
	<061c01dc062f$70ec34b0$52c49e10$@samsung.com>
	<87c37d65-5ab1-4443-a428-dc3592062cdc@oss.qualcomm.com>
	<061d01dc0631$c1766c00$44634400$@samsung.com>
	<3cd33dce-f6b9-4f60-8cb2-a3bf2942a1e5@oss.qualcomm.com>
	<06d201dc0689$9f438200$ddca8600$@samsung.com>
	<wpfchmssbrfhcxnoe37agonyc5s7e2onark77dxrlt5jrxxzo2@g57mdqrgj7uk>



> -----Original Message-----
> From: 'Manivannan Sadhasivam' <mani=40kernel.org>
> Sent: Wednesday, August 6, 2025 10:35 AM
> To: Alim Akhtar <alim.akhtar=40samsung.com>
> Cc: 'Konrad Dybcio' <konrad.dybcio=40oss.qualcomm.com>; 'Krzysztof
> Kozlowski' <krzk=40kernel.org>; 'Ram Kumar Dwivedi'
> <quic_rdwivedi=40quicinc.com>; avri.altman=40wdc.com;
> bvanassche=40acm.org; robh=40kernel.org; krzk+dt=40kernel.org;
> conor+dt=40kernel.org; andersson=40kernel.org; konradybcio=40kernel.org;
> James.Bottomley=40hansenpartnership.com; martin.petersen=40oracle.com;
> agross=40kernel.org; linux-arm-msm=40vger.kernel.org; linux-
> scsi=40vger.kernel.org; devicetree=40vger.kernel.org; linux-
> kernel=40vger.kernel.org
> Subject: Re: =5BPATCH 2/3=5D arm64: dts: qcom: sa8155: Add gear and rate =
limit
> properties to UFS
>=20
> On Wed, Aug 06, 2025 at 09:51:43AM GMT, Alim Akhtar wrote:
>=20
> =5B...=5D
>=20
> > > >> Introducing generic solutions preemptively for problems that are
> > > >> simple in concept and can occur widely is good practice (although
> > > >> it's sometimes hard to gauge whether this is a one-off), as if
> > > >> the issue spreads a generic solution will appear at some point,
> > > >> but we'll have to keep supporting the odd ones as well
> > > >>
> > > > Ok,
> > > > I would prefer if we add a property which sounds like =22poor
> > > > thermal dissipation=22 or =22routing channel loss=22 rather than ad=
ding
> > > > limiting UFS gear
> > > properties.
> > > > Poor thermal design or channel losses are generic enough and can
> > > > happen
> > > on any board.
> > >
> > > This is exactly what I'm trying to avoid through my suggestion - one
> > > board may have poor thermal dissipation, another may have channel
> > > losses, yet another one may feature a special batch of UFS chips
> > > that will set the world on fire if instructed to attempt link
> > > training at gear 7 - they all are causes, as opposed to describing
> > > what needs to happen (i.e. what the hardware must be treated as -
> > > gear N incapable despite what can be discovered at runtime), with
> > > perhaps a comment on the side
> > >
> > But the solution for all possible board problems can't be by limiting G=
ear
> speed.
>=20
> Devicetree properties should precisely reflect how they are relevant to t=
he
> hardware. 'limiting-gear-speed' is self-explanatory that the gear speed i=
s
> getting limited (for a reason), but the devicetree doesn't need to descri=
be
> the
> *reason* itself.
>=20
> > So it should be known why one particular board need to limit the gear.
>=20
> That goes into the description, not in the property name.
>=20
> > I understand that this is a static configuration, where it is already k=
nown
> that board is broken for higher Gear.
> > Can this be achieved by limiting the clock? If not, can we add a board
> specific _quirk_ and let the _quirk_ to be enabled from vendor specific
> hooks?
> >
>=20
> How can we limit the clock without limiting the gears? When we limit the
> gear/mode, both clock and power are implicitly limited.
>=20
Possibly someone need to check with designer of the SoC if that is possible=
 or not.
Did we already tried _quirk_? If not, why not?=20
If the board is so poorly designed and can't take care of the channel loses=
 or heat dissipation etc,
Then I assumed the gear negotiation between host and device should fail for=
 the higher gear=20
and driver can have a re-try logic to re-init / re-try =22power mode change=
=22 at the lower gear. Is that not possible / feasible?



> - Mani
>=20
> --
> =E0=AE=AE=E0=AE=A3=E0=AE=BF=E0=AE=B5=E0=AE=A3=E0=AF=8D=E0=AE=A3=E0=AE=A9=
=E0=AF=8D=20=E0=AE=9A=E0=AE=A4=E0=AE=BE=E0=AE=9A=E0=AE=BF=E0=AE=B5=E0=AE=AE=
=E0=AF=8D=0D=0A=0D=0A

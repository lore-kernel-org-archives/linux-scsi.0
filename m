Received: from mail-yx1-f42.google.com (mail-yx1-f42.google.com [74.125.224.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7218B363094
	for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2026 14:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783954590; cv=pass; b=mBts8iwY/4bT+3vuoTcDZrcnD726yvTnEQSoZ1813XJlI1igOMcszFk47d7HBHMMqmjGe+GL7i5viMeSqsnJvs/ONWJ29AHEFgra3BKUHvt8yJ00jN2JiafcVWnu4AC4vK2wkEsPAXTMJ2+9YMXMZ2G+VN4jc4VPVQCIs1/oEqQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783954590; c=relaxed/simple;
	bh=HdjriIlxFJNKIiAn7v0KH2Y3CfAyVlV91876yNBmwGs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=a1JTQ7tKyZvl6Go4SZdaHwMtq3OMTLyruHLBH0AzenhqprI+zHzoNWVz60zsTMXzcAOnwzEmAiURsOLaiPa8LzHKSvTMPEqJvhREQEj6Su5AGy5JjrhRekHa3Ne3tPh7nvzjUpJv+BDHjq+7FCCXDY5tRh7SMgCeigLDfulTTfQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.tenstorrent.com; spf=pass smtp.mailfrom=tenstorrent.com; dkim=pass (2048-bit key) header.d=tenstorrent.com header.i=@tenstorrent.com header.b=U1+7jsNP; arc=pass smtp.client-ip=74.125.224.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.tenstorrent.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tenstorrent.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=tenstorrent.com header.i=@tenstorrent.com header.b="U1+7jsNP"
Received: by mail-yx1-f42.google.com with SMTP id 956f58d0204a3-664dd23829eso2838848d50.3
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2026 07:56:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783954586; cv=none;
        d=google.com; s=arc-20260327;
        b=BXjezHgU1GLcxpv8yZr0misUf0IrlSQOOaq5LZI982FJYRqxxM/ivGb+dSYyahG9WL
         GhioB5omkezwo19PbULEzqJsp17zz7867s4MK5qyTawjso5kxIeM9X1ZaZrbeKrHxXaK
         mvt1ns/8uSpWqrOkPJbmKr0Sz8dyPPmaimFImxHGDslFyIMAwjN1fkpvUxJcGqNpRRrf
         iP73V+1pVHTaeMouynMzsR1d6g55jYInAc4ZY9EahxgslfYDNcEmz4OOvGAgYHTgAINT
         JtPWmnOvKs9++m5lsRd2MVhvfSx6K5+Xz57DaI8IzzOmzSyMOswNgXNxYDNo2vkE44TQ
         XsEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=8ryOTMNwVpU4ujGUky6ot1LLCqvzzEx6/bFp2CC3uos=;
        fh=L+Fqvteoq5CDJ05Hts+eqRkHqgEPNv5RJkKGXGmsDYc=;
        b=nhi3kzeSVWhg2HJaicJsemMoLwu1JCrsHCIClr9diTOZnqivBVs+BKHrQGfb66ql4z
         PkLUOjbM5+RJ4pha1dy7LUxhco686veO+x0hF7KPWZiMtK6ZwMRSChW8hy54gh4vYqa9
         j+a4yx0CQ6q+jvLZ4bDGMZAYVPATTZipLu09J2PIMhmVhDIvpIabR1rq5o0Gs5WMcIRR
         6bHPegxVJQOBLnJnaatACS6IqGD0cIkheuZ8rUr/MQX+2sig8bfYzpKf4hAomZcAH7sY
         3jLVi6YSJJdHwSu8BKJ+3hVkQK/+klyTLkJ6F50meK10dnP2FUFTCAYEZU4O9VrbWGNf
         CocA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tenstorrent.com; s=google; t=1783954586; x=1784559386; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8ryOTMNwVpU4ujGUky6ot1LLCqvzzEx6/bFp2CC3uos=;
        b=U1+7jsNPnl9UGN/7xW1243BKTycOBzsfZq+fjoB4Y5VcrBsf4Jx9HjpaDe/hTbt7bp
         Q4ueTbCUKUjheUjjc+Y3BnxQ/3rx2tA0SoRHuTryFISsMbPS3D5dx0BOdtuxa9MwiDCs
         FxJaIv85j/OmYV0LG6NezFnW8MQqzpa1Q73/1ZfH7AN6pN/8XbJcx6vXwrke8f4YjU6C
         qP0g3jyGhRGM46KyKmteRPl2cF9MdUnvvzDpLgjmYLeU24L0rwH5PDLO3ENR3R9bwGP2
         nDtGpTeg+BWVhrSBfIx39q+msZONegxVS7BGM/eF5SSOvAjZnJ5K9UnyCdRS0h26iMQn
         ++Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783954586; x=1784559386;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8ryOTMNwVpU4ujGUky6ot1LLCqvzzEx6/bFp2CC3uos=;
        b=lPBT206GFWbP3SJuYKscROm5uiGeRIe4tMi5O2IgaseQMR6YqvYqcTdC7qsn91acw3
         OSUvxqfcmx0CuvXjNlo23FMK0esuOPlHp3ZGquiygMek8mWVU8Vx1PZmWGG5Bh1HO1fb
         xTgfcTSkdEhX1UYPIJw0bN+QmgVq8bULio1cuipFK1zcQr8g+TIKnLyPTBPXsW6CTCTL
         4sJ7BoIk6/6o/+7vJgj0LPa7RQeUxoEpuVO3zPJosi+sBnIxReHw6w2VJznum4IoRm1E
         BQ98sCIRK6+GLBYnjEY37gLriJKGajkZgz8lOrJ6nR0MEWoFRKCfrXcdtR/r2JB0E0v5
         XKkw==
X-Forwarded-Encrypted: i=1; AHgh+RoMSO9yQlNUXFNNyedY5exMTl3BNhXkYAByGtSt4PiFkHhQMHArLbmW0l8TMVLahI8aB7cNsDC8fYjI@vger.kernel.org
X-Gm-Message-State: AOJu0Yx77oevYkAyhpmQAaRA/RRvNELStppfUZv3jUSw40WaXD1dAP8x
	02wM3YOSG/bljXE/+diMIilgISAYXXzJ+rrphOopV0wt/ta8QOn81hN1ARnsfOrXtBS5z00FqOs
	gVy/J2OPEGQmBFhDDZSuR23mZQjxyn2oGXjo4jGwdXA==
X-Gm-Gg: AfdE7cmOIVI1vZfa8XIkwQhkJIgnU5iNHelcGZDkl9I6xwi3M4nxtjaiXbwzcy+Z81M
	RUSXB6uV229cOE0DXt+8s4oMF2tvUCJlwSh7/C67RpMtFGub3fUCkEUlUnztJuKl9+gsLAXmX7P
	MCzvx52eugmy+KavzFtcnOT33HaI8S5MFy5GdpwTiEDewH5QNke3yvCG6WOMNiZdBCD5QnTydP8
	/zsAUGGpNvRpb7uAPJeaFX05J29pL9lxgFUK6Sjs1TvdmxixMAyBH5CprpNRFlezZ0QvVnkXWAd
	wtcGpxQs19DHaFzS68EDFQJ3rrI=
X-Received: by 2002:a05:690e:210d:b0:664:8e4e:66fe with SMTP id
 956f58d0204a3-667d7b003e7mr4788212d50.12.1783954586457; Mon, 13 Jul 2026
 07:56:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260702-08-k3-ufs-support-v1-0-1a64a3ab128f@kernel.org>
 <wjbz5tp7vjrsjwjaiu3n7du5ksbrlsduuxhwg2wriyxshkrqd5@t3sdxr6ua2sg> <20260713123759-GKD106000@kernel.org>
In-Reply-To: <20260713123759-GKD106000@kernel.org>
From: Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>
Date: Mon, 13 Jul 2026 09:56:15 -0500
X-Gm-Features: AUfX_mxXZbxq8-VPSYzKHw4Bcqse0ZCXB00LCsca2IM_XGbO21zHzHAHbEujGR4
Message-ID: <CAEev2e-g3bZcohFf_7b5CaVyi0BeWi5uwLGj6MuhQXp16jiyEQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] Add UFS Host driver support for SpacemiT K3 SoC
To: Yixun Lan <dlan@kernel.org>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@sandisk.com>, 
	Bart Van Assche <bvanassche@acm.org>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Philipp Zabel <p.zabel@pengutronix.de>, 
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, linux-scsi@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-riscv@lists.infradead.org, spacemit@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Yixun,

On Mon, Jul 13, 2026 at 7:38=E2=80=AFAM Yixun Lan <dlan@kernel.org> wrote:
>
> Hi Anirudh,
>
> On 22:40 Sun 12 Jul     , Anirudh Srinivasan wrote:
> > Hi Yixun,
> >
> > On Thu, Jul 02, 2026 at 02:31:34AM +0000, Yixun Lan wrote:
> > > This series try to add UFS support for SpacemiT K3 SoC, the controlle=
r
> > > components consists of System Bus Interface Unit, UFS Host Controller
> > > Interface, UFS Transport Protocol Layer, UFS Host Registers, Device
> > > Management Entity (DME), Transport Layer, Network Layer, Data Link
> > > Layer, PHY Adapter Layer, and M-PHY Interface. A more detail function=
al
> > > block diagram can be found in SpacemiT website, chapter 9.7.3 [1]
> > >
> > > Please note, in order to test this driver, the UFS clock driver[2] he=
re
> > > should be applied first as a prerequisite patch.
> > >
> > > One known issue is that the device will occasionally raise BKOPS inte=
rrupt
> > > when doing some high load test, log from dmesg shows
> > >
> > > [  806.710763] ufshcd-spacemit c0e00000.ufshc: ufshcd_bkops_exception=
_event_handler: device raised urgent BKOPS exception for bkops status 1
> > >
> > > Link: https://spacemit.com/community/document/info?nodepath=3Dhardwar=
e/key_stone/k3/k3_docs/k3_usermanual/09_memory_storage.md&lang=3Den [1]
> > > Link: https://lore.kernel.org/all/20260630-06-clk-ufs-support-v1-0-cf=
7521d1d0fe@kernel.org/ [2]
> > > Signed-off-by: Yixun Lan <dlan@kernel.org>
> >
> > I see this during probe on a k3-pico-itx. Does the UFS chip on board
> > have an RPMB block on it? Is this error of any concern.
> >
> It's probably true of having a RPMB block, but not used in K3 platform, s=
o can ignore
>
> > [    5.957864] ufshcd-spacemit c0e00000.ufshc: ufshcd_scsi_add_wlus: BO=
OT WLUN not found
> > [    5.963319] bus_add_device: cannot add device 'ufs_rpmb0' to unregis=
tered bus 'ufs_rpmb'
> > [    5.971155] ufshcd-spacemit c0e00000.ufshc: Failed to register UFS R=
PMB device 0
> >
> Maybe disable CONFIG_RPMB to silent this? I've not tested this option loc=
ally

I'm testing on a distro defconfig, so it has this option enabled.

Is there anything we can do in the driver to have it ignore the RPMB?
If the error is a red-herring, we shouldn't be displaying it at all in
the first place.

Regards
Anirudh Srinivasan

>
> --
> Yixun Lan (dlan)

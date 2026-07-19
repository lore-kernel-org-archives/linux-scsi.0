Received: from mail-yx1-f48.google.com (mail-yx1-f48.google.com [74.125.224.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28FEA37F8C1
	for <linux-scsi@vger.kernel.org>; Sun, 19 Jul 2026 23:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784503222; cv=pass; b=RGpu5SHbs3hiRfFx8EYdKGKcmq3QjTL88JqbCYI5PHoHyezc77hHOhF97WM3bUvHC+Ozf/LyBema8RsdgdWWFeuWj6DrVjTiqsUPGg/KKeXvyq6wsZ7ZBi+/q0cYIxXrdcC9LNVma4WApCn7pJNse4117s2+fTLkLQVgGZ+gjYE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784503222; c=relaxed/simple;
	bh=DWT7/MJowsj2WV+e/BvUBOitlHcs+O939V9MzG/T3iw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=t1OQL78HSqhnrOe8mzRDK48pxiKp3Pa/LBBfGnJarOtvNsiNZzAaNBvdRYwwGnMVv+qvRSFMrSN7G2W6FJzNX4oooCFlqb44mMipK5nzhGeuPxFYCBWJXc8PG//Isb1RW6tELwNONeAP1OPcilyA+xtzQWc1D/N/W+bF1evx+Fs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.tenstorrent.com; spf=pass smtp.mailfrom=tenstorrent.com; dkim=pass (2048-bit key) header.d=tenstorrent.com header.i=@tenstorrent.com header.b=B6Qi70SU; arc=pass smtp.client-ip=74.125.224.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.tenstorrent.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tenstorrent.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=tenstorrent.com header.i=@tenstorrent.com header.b="B6Qi70SU"
Received: by mail-yx1-f48.google.com with SMTP id 956f58d0204a3-664a09bc459so13468743d50.1
        for <linux-scsi@vger.kernel.org>; Sun, 19 Jul 2026 16:20:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784503219; cv=none;
        d=google.com; s=arc-20260327;
        b=ViLgFQA0X+/eeMhKdXiYAQ+B4CD7IdxtFoN5rKaQcs2SJecJrmC2OXysjhvn5SO4+o
         Ge5DBmTUKkZkINrUwv4XrRxkJh4KvNfGiaRlPKWEmcD4OEFXO/dSZB0awlJd+EMMvip9
         vQBo44rKXKeiCTOwpulkNQWRI7PdyOtXMtL/d0B2aS3D7Q2iBAUVlfPnhOM6Ahti3g67
         99v7z0OcaBxUkKQLkOar5AgRAzhgBFkHGYIm9ip1NtuFCfea2COyvKkdHmc9+Y63yN8W
         DFdWdFh8P+mI6Ivj1b9KZG6x579WP3elIr0o8CcOqDOsbpoP/Tx0IXepg5z2zzY3vB2S
         ZokA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=UPqjPIJbJ4hSMkmX6fzNuKXuPBcJE4+S9+cyMi05hk4=;
        fh=LFW2cxNzIyykZPmlTPKM7gcXMHZuCa+fqGh2sFnr/LI=;
        b=nweB9g6jraq9ye1LOI/6PKrTQqPbbm/ZxcnziU0g1UUSSz05HnZy0Y93Uvrees8haT
         43Q7KxqL0yVWLtj92HvhBk2wscgExsnPj49pbcoPZFmE5EU79eWEDnt06G8CawQzCp/k
         MFxuCovf3jUuaLVfkc8Ga05hD9wXALVrTmCGqpAUxNFYfgWQ0Ex6FEo7xeMscCTynZlp
         31r2MM+bN2AyuQuKgMKxrGXVul9sKanIFcMozsosbnl2C+6ds079JY5rODUAx7BiYjZx
         gPhWvx80A4SanzFp2DRMs6KJaCXm94mRrlgnVBduOlhvqfyCOp7nUEc9lycRXFQm2Uyr
         3nkg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tenstorrent.com; s=google; t=1784503219; x=1785108019; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=UPqjPIJbJ4hSMkmX6fzNuKXuPBcJE4+S9+cyMi05hk4=;
        b=B6Qi70SUemhqvfqYHGv3PIEdkl5xy6wZSKEYEOcImb+l2KX0NqlpwlL4ZvRMuSSMF0
         jLZ/h82+L5fvNx8RW2HeWI8DGzkjPpI6tdOQWY7n/DeLzy5ex9DaOFp3JhLzj5uFoFA2
         lBOLaXDUNxgJLYdJxUkWiElh+D9QZ9d3i6uMn699QusxxYfo568MlWP36Y+yBm7ou6OM
         IeepW7uxmZoDj0ENjw6EyzxlQJtPAt91IbgVCg/9cZ0kiXGxwcRgpd11uLkUCt5emZNA
         vlO88bySJooJymm4eMOKF9IVHhIibwF7fBKEDq7vTAFfuX6qkvF10q/uUVeQtHmxmhns
         YPFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784503219; x=1785108019;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UPqjPIJbJ4hSMkmX6fzNuKXuPBcJE4+S9+cyMi05hk4=;
        b=TOZJS8ho/Uy72Tk4au9xjPnUzF+i8E7RSboFHeK9YBr1Bf0Mtbvq8WvMYVo/rfUa9Y
         +h147R4Xm3d9KMNxUm8BlZJ8KKylFrpoHIjdovLBtCgVzJHm5uYWpxtdQmAzPPldLJVY
         F3+YzPmNF/Dmdpv6uMx1/CQYSE4sodSFfNBjR98sPdCfZsKCFksvHTlgVGP1SCrqocId
         dWtXy6y+445kxgnkLH573iBod2J6PbVcJrFOQCbAz3WQIq45xEN56S2NRvcPw5Xp31sT
         G0xr7pF5hqgNNPCTTXqXtqrQRN6HCx/pNkY0QM2E+niD5BNLYAoOCqcK86lCGTf4EWOb
         OA9w==
X-Forwarded-Encrypted: i=1; AHgh+Roxxdlr/bjhP5Y02jg/SlDv4VhVS2/6Xq6zR7il7i9P+fBOwAcTJZqwVOrpgg9u0BtgTQdmvTsT7lC7@vger.kernel.org
X-Gm-Message-State: AOJu0YzrF+CJh4D63GrGJcOT3vxNKyf2WufT/W+8/vXBsj7BGUPBsLQH
	iUT0bFbYvMotvc1et6GA/dd4UHNlYowQS7BhfpZl/P6DZhl9+73vWFXwNZtMstNMzkHA2IVVGvb
	oug7Misp3b2VFVDceL+OCHlu2Cr6qyFz1gJ/VF2PHJQ==
X-Gm-Gg: AfdE7cnlIo1a/3bFhrSgSr+qBHKvsEx8OU6iUTq4t6yvKNbRDQ7if/QMhzlTdYUSAT7
	y0WIWO23tKqj/MEhLepRVzpRJpYD2YYRGdcMtHaUExNmKhdOtS9w6amHV2NTAPwHv5fvMZvnzi0
	Kt6wsl8snklXaztPq/6uvjqFityKVjN56P39/ftSAbsqCmjDAMOtPwmP5VeSNAFcYqOa8NyUmUe
	rdm8ESHhKGdfeDhwux9f2QTc93JSGCJmXdpw8OGArhS0PSXIRb4kqeaAiDHGjtxVp6+oGY/rags
	Ja6x4LLcy9NFMbY/Tw5vahpJ598qm2U+Cp1R4PO1RAlCGwJ02NY=
X-Received: by 2002:a05:690e:2504:10b0:667:c15b:dab6 with SMTP id
 956f58d0204a3-6683be6aa35mr2695296d50.95.1784503219030; Sun, 19 Jul 2026
 16:20:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260702-08-k3-ufs-support-v1-0-1a64a3ab128f@kernel.org>
 <wjbz5tp7vjrsjwjaiu3n7du5ksbrlsduuxhwg2wriyxshkrqd5@t3sdxr6ua2sg>
 <20260713123759-GKD106000@kernel.org> <CAEev2e-g3bZcohFf_7b5CaVyi0BeWi5uwLGj6MuhQXp16jiyEQ@mail.gmail.com>
 <20260713235742-GKE106000@kernel.org>
In-Reply-To: <20260713235742-GKE106000@kernel.org>
From: Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>
Date: Sun, 19 Jul 2026 18:20:08 -0500
X-Gm-Features: AUfX_mxUPpHWs2hIHbiNCUZT8v6smWRhuvoQSN4l0SVoBHHrNzCPKAS_FyVfPXc
Message-ID: <CAEev2e_hmQBrk3Vfv4WmeH+ex_gMwW_9mgNKaUjFaiCScxAqTQ@mail.gmail.com>
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

On Mon, Jul 13, 2026 at 6:57=E2=80=AFPM Yixun Lan <dlan@kernel.org> wrote:
>
> Hi Anirudh,
>
> On 09:56 Mon 13 Jul     , Anirudh Srinivasan wrote:
> > Hi Yixun,
> >
> > On Mon, Jul 13, 2026 at 7:38=E2=80=AFAM Yixun Lan <dlan@kernel.org> wro=
te:
> > >
> > > Hi Anirudh,
> > >
> > > On 22:40 Sun 12 Jul     , Anirudh Srinivasan wrote:
> > > > Hi Yixun,
> > > >
> > > > On Thu, Jul 02, 2026 at 02:31:34AM +0000, Yixun Lan wrote:
> > > > > This series try to add UFS support for SpacemiT K3 SoC, the contr=
oller
> > > > > components consists of System Bus Interface Unit, UFS Host Contro=
ller
> > > > > Interface, UFS Transport Protocol Layer, UFS Host Registers, Devi=
ce
> > > > > Management Entity (DME), Transport Layer, Network Layer, Data Lin=
k
> > > > > Layer, PHY Adapter Layer, and M-PHY Interface. A more detail func=
tional
> > > > > block diagram can be found in SpacemiT website, chapter 9.7.3 [1]
> > > > >
> > > > > Please note, in order to test this driver, the UFS clock driver[2=
] here
> > > > > should be applied first as a prerequisite patch.
> > > > >
> > > > > One known issue is that the device will occasionally raise BKOPS =
interrupt
> > > > > when doing some high load test, log from dmesg shows
> > > > >
> > > > > [  806.710763] ufshcd-spacemit c0e00000.ufshc: ufshcd_bkops_excep=
tion_event_handler: device raised urgent BKOPS exception for bkops status 1
> > > > >
> > > > > Link: https://spacemit.com/community/document/info?nodepath=3Dhar=
dware/key_stone/k3/k3_docs/k3_usermanual/09_memory_storage.md&lang=3Den [1]
> > > > > Link: https://lore.kernel.org/all/20260630-06-clk-ufs-support-v1-=
0-cf7521d1d0fe@kernel.org/ [2]
> > > > > Signed-off-by: Yixun Lan <dlan@kernel.org>
> > > >
> > > > I see this during probe on a k3-pico-itx. Does the UFS chip on boar=
d
> > > > have an RPMB block on it? Is this error of any concern.
> > > >
> > > It's probably true of having a RPMB block, but not used in K3 platfor=
m, so can ignore
> > >
> > > > [    5.957864] ufshcd-spacemit c0e00000.ufshc: ufshcd_scsi_add_wlus=
: BOOT WLUN not found
> ..
> > > > [    5.963319] bus_add_device: cannot add device 'ufs_rpmb0' to unr=
egistered bus 'ufs_rpmb'
>
> Just checked code under drivers/ufs/, and couldn't find where ufs_rpmb bu=
s is registered,
> so this kind of warning/error message is expected, or could UFS maintaine=
r confirm this?

Seems like both of these are bugs with the existing UFS/RPMB code in
the kernel.  The dev_err("BOOT WLUN not found") print should probably
be downgraded to a dev_warn. And like you mentiond above, the ufs_rpmb
bus doesn't seem to be registered before the ufs device is probed.

>
> > > > [    5.971155] ufshcd-spacemit c0e00000.ufshc: Failed to register U=
FS RPMB device 0
> > > >
> > > Maybe disable CONFIG_RPMB to silent this? I've not tested this option=
 locally
> >
> > I'm testing on a distro defconfig, so it has this option enabled.
> >
> > Is there anything we can do in the driver to have it ignore the RPMB?
>
> No, but why not disable CONFIG_RPMB in the first place
>
> > If the error is a red-herring, we shouldn't be displaying it at all in
> > the first place.
> >
>
> Either fix the code or just ignore it..
>
> --
> Yixun Lan (dlan)

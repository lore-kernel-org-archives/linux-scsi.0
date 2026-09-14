Received: from mail-yx2-f12.google.com (mail-yx2-f12.google.com [74.125.224.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FC52486BA9
	for <linux-scsi@vger.kernel.org>; Mon, 14 Sep 2026 16:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.140
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789403578; cv=pass; b=eLh9PQ8FyhPXA13h2RGWgWPiYvLQyWrmlb1dfr4ljjwxDOCgPVhKTwBcpP5flcKOnEeUwxGmquhg5LYP2Nrk7YApMSSYoh9LybqHRVbMi3tnvgEgSsB9mMFeokGsbkO2KLS+iDOUbZWv/B423GA5pYa/wmABA/DymsGiYleo6Z8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789403578; c=relaxed/simple;
	bh=hQHVRS3j3qwCMZvufegvdPbwFnAZmaOwqMLjoj+NQog=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XrHEcojAEaOXE5MpREzyzI4SBgqj+3Thr3qu+HLvVhG+/V1Hoj1R7seZ6GA3Pnqc9G/+qggJ4sGUIKD0Ku5HUVrMuVpQw/+8Foyix5CN7AZUdSO5pEI6xRlZjLCvxsiiaAmapYaJc1gQUaBaUZZJK7Lri7/lSN6aZ/MH1UetPZs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.tenstorrent.com; spf=pass smtp.mailfrom=tenstorrent.com; dkim=pass (2048-bit key) header.d=tenstorrent.com header.i=@tenstorrent.com header.b=ZPGHMV9y; arc=pass smtp.client-ip=74.125.224.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.tenstorrent.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tenstorrent.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=tenstorrent.com header.i=@tenstorrent.com header.b="ZPGHMV9y"
Received: by mail-yx2-f12.google.com with SMTP id 00721157ae682-8659af7454eso20549507b3.1
        for <linux-scsi@vger.kernel.org>; Mon, 14 Sep 2026 09:32:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789403574; cv=none;
        d=google.com; s=arc-20260327;
        b=mL20xTDNn6WRbm1+EBMt3YshHSMPgIoVqDltCIaNHR037TkkuiJ38uHfeMrcm+/Dkc
         0Ot4Rp9cjHGO3OjwQL4d7SotXEEGhlV1vIq8Pa5gN5YHzZFW56dyfJ/O6FWBT5Uk0F7W
         AV3oNPLRm7btNEi0aL87I2SqoIdRy2J7cKpuf9MrX6F8+zXfjqFwow/A8dIPdAvsRr88
         r4L46bOtgRvf6ddPZsfu/Dw9eFgQPuElmF9pxMbGHePuk8wFU+aJ9oO5dB3lJ4bIHVeC
         5EKB6SBNpGDkyOOpa8XsAfqamPRHGqzdpLlyh3V5r7mRbVz7jzLIPDuMCu9H7/9ZDvH9
         LyJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=U2puunLcCA0Ud8zKAQs4npBTHlIwjTI7Amm7eOrF5FM=;
        fh=arJUIvkEI6mQ6yRt7B37+C+N6zca0wI4Dfdaws7HzkU=;
        b=dH77D+Oo1JzqTIGoiicOBhIHy4jiYRBF0as3KDQIPAMJPyMKUQ/VWMFues14vBUA2a
         LebiHcFbrGEQHffIWwPziveqIsPeYfMe78tkRDjt/6LK30IN48OT2xowmGH880C6f9lx
         FZ+0Ljy7XDCnb04WsDdHf5+xJjOFKOiR6F+6o55hAaOThgB628wlyAVYgDD/R+2D6+1n
         8WLfvqhSVY6wDXrxrsDYbZ+TWUS7NKtUKBlEfyAxkUN0JXlVWB/F66e8KwDoCmgn15zG
         /PlqBw62YXFC98XK2yiw28f1LM5ne4hu5LOIINhjvCVByuREGM+mMtQGPNAv3nXkLLbu
         5ZAA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tenstorrent.com; s=google; t=1789403574; x=1790008374; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=U2puunLcCA0Ud8zKAQs4npBTHlIwjTI7Amm7eOrF5FM=;
        b=ZPGHMV9yuARSC0LlxJW5/ydUkvViYv/bjhgCcuyX63K4CqaLu5IbgEyA3GP/XHic6s
         ryXFLpI03+sYhUpWVhzDN6Vag2Gw8A8dVWtnr3Hi5UoNJdI6ZSpcWxWB3tIl8CBLBpq8
         FDit62sLjMLg2fJxVok8lThOEoEEs9N0NjOz4X31jjd9fU2rxLku7gIrfPnEc9MHhhu+
         M8TjhEpete7p5j9s3nXlfz3RXujrUdzipboqhih2SjzssW+9/q9KoSGqmO4O2zBycSZy
         4HQHM0/azPrGmX9jO7OUMn7w5bNa5PJbSuLWE0PIg0dqj4xTvveIZuPoehlcqVoEZvme
         a5hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789403574; x=1790008374;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=U2puunLcCA0Ud8zKAQs4npBTHlIwjTI7Amm7eOrF5FM=;
        b=IZoGV1ULtA9ekU2MOBd+D+V5F4I5cCCcl3YLLUzJJT7uMdtn7HTM32+snqJYl+teaF
         OL9RcVWk3vC59sVF9LykIqOxWuIpiBOv/1s8eu2jbMvUUp0ks4Hp5cib5vmo/dfgS3Ce
         kvJlPAp830g4Ali8ngRnL8YleWTfbJ0dLY9OgnepRcK2TkynqEIO/Cn23OMX4hSLfufM
         SounU1J5lNOSJO0bAh3MTAy98GtFwmqjEsUtidWVS01q/pAOtluQ2ZxzAaZ0UDn1Rerz
         8KIg5FkuhMkDbo8J2ktmEIfAwQzl/oshst43wck9/sucEllYvJ86KOBu36vxzQAHvOI6
         xMDA==
X-Forwarded-Encrypted: i=1; AKwUvByfwDE5z2JrJA34MjpfH4lM9zeuO9lcnqdb+icUTN4CnxDJR14BndSoWGLoJR05kWJ4QX1b3MsQv9gE@vger.kernel.org
X-Gm-Message-State: AFuF++lLLuNi/OM7dnG+ZqpwAqrufPpHaycQ+QWzY0MvCggvcY9pNzHW
	uTpoDfhTWb+vhvubl2qRh1mRkOZamEJp2Zs5kKqA7mXwX6tbZtrODXTiYLL/OKS58sNr0KGg44N
	xCBCNRVlPYdLp54PtdX8X+ecmLFgjVEkB47cwLqFEqw==
X-Gm-Gg: AYBFou08+9A2w+04Pjf2dTw9w8Z4PgW9I6qgQC8ABKXk/uTQQ/PPgLoXyuQ+J+/U3sO
	wiw20/KemoLKqov2Ej98q2r3pMzf2tneekIty7xmKF5FpneuDF0cuxfBsCAt9m+PGSq7OoO5FnN
	R6sJbfQ9Qmzgpkaw0JKcIVtSKZIunRNgTPDlL5ySYCPke0zyyD+XNMj4nnhebzKrV8ly5oGImJv
	2e3UztxhQpqkaSVDlcFDJpcvufzpZmRbDXcm1IS9FRLVBvCa4uj47X90Nn1wVpWxUg/4lP0Jgtm
	IVpFEBLOhbCgfDBgPTQSLKF31Di4zwQ+aRC+tjhUUQMTOsEWT6wtvR6I6l6fmXBNwFdNyOZi0uc
	DrYOUs/uxxdBsd4Eju6PaxTja1Wxre8pnrD7OJaLJ/o6K
X-Received: by 2002:a05:690c:d8c:b0:862:ec8:d142 with SMTP id
 00721157ae682-88d1f505069mr12332497b3.15.1789403574227; Mon, 14 Sep 2026
 09:32:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260908-08-k3-ufs-support-v4-0-22aa2bd97d3b@kernel.org>
In-Reply-To: <20260908-08-k3-ufs-support-v4-0-22aa2bd97d3b@kernel.org>
From: Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>
Date: Mon, 14 Sep 2026 11:32:41 -0500
X-Gm-Features: AcwNN1VyLPHubK4HBe4wLXnzYSfxOmAhK5WWmFPob51Sa4JHSy9JegsQyxuk3OE
Message-ID: <CAEev2e-zQotX9=QCfZxvYHpUD-hSgxbEjsVey4hEc2YbpoRjnA@mail.gmail.com>
Subject: Re: [PATCH v4 0/3] Add UFS Host driver support for SpacemiT K3 SoC
To: Yixun Lan <dlan@kernel.org>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@sandisk.com>, 
	Bart Van Assche <bvanassche@acm.org>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	Philipp Zabel <p.zabel@pengutronix.de>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, "Martin K. Petersen" <mkp@kernel.org>, Aurelien Jarno <aurelien@aurel32.net>, 
	Jennifer Berringer <jberring@redhat.com>, linux-scsi@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-riscv@lists.infradead.org, 
	spacemit@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Yixun,

On Tue, Sep 8, 2026 at 2:42=E2=80=AFAM Yixun Lan <dlan@kernel.org> wrote:
>
> This series try to add UFS support for SpacemiT K3 SoC, the controller
> components consists of System Bus Interface Unit, UFS Host Controller
> Interface, UFS Transport Protocol Layer, UFS Host Registers, Device
> Management Entity (DME), Transport Layer, Network Layer, Data Link
> Layer, PHY Adapter Layer, and M-PHY Interface. A more detail functional
> block diagram can be found in SpacemiT website, chapter 9.7.3 [1]
>
> One known issue is that the device will occasionally raise BKOPS interrup=
t
> when doing some high load test, log from dmesg shows
>
> [  806.710763] ufshcd-spacemit c0e00000.ufshc: ufshcd_bkops_exception_eve=
nt_handler: device raised urgent BKOPS exception for bkops status 1
>
> Link: https://spacemit.com/community/document/info?nodepath=3Dhardware/ke=
y_stone/k3/k3_docs/k3_usermanual/09_memory_storage.md&lang=3Den [1]
> Signed-off-by: Yixun Lan <dlan@kernel.org>
> ---
> Changes in v4:
> - fix clock and reset settings
> - drop function which retrieve value of tx_lanes
> - propagate return error of ufs_spacemit_dme_set()
> - check return value ufs_spacemit_check_hibern8()
> - drop call to ufshcd_vops_phy_initialization()
> - handle compiling warning if CONFIG_OF not enabled
>  add __maybe_unused to ufs_spacemit_of_match
> - Link to v3: https://patch.msgid.link/20260806-08-k3-ufs-support-v3-0-03=
7fb322acdb@kernel.org
>
> Changes in v3:
> - collect tags
> - fix dt-binding warning reported-by sashiko
> - fix low freq in opp-2 table
> - fix err checking in check_hibern8()
> - propagate err code in link_startup_notify()
> - update documents for event_notify()
> - ufs clock driver is merged into v7.3-rc1, update cover letter
> - Link to v2: https://patch.msgid.link/20260725-08-k3-ufs-support-v2-0-45=
036a2a2418@kernel.org
>
> Changes in v2:
> - fix missing interrupts property
> - move ufs node to k3-com260.dtsi
> - convert freq-table-hz to operating-points-v2
> - rework reset_control, fix header and drop global variable
> - drop dump_host_regs() debug interface
> - converge and refactor dme_set() operations
> - massive reduce of busy delay() loops
> - drop vendor specific hce_enable_notify(), fallback to default
> - drop unused member from struct ufs_spacemit_host
> - add COMPILE_TEST support to Kconfig
> - comment style fix
> - Link to v1: https://patch.msgid.link/20260702-08-k3-ufs-support-v1-0-1a=
64a3ab128f@kernel.org
>
> ---
> Yixun Lan (3):
>       scsi: ufs: spacemit: dt-bindings: Add UFS controller for K3 SoC
>       scsi: ufs: spacemit: k3: Add UFS Host Controller driver
>       riscv: dts: spacemit: k3: Add UFS support
>
>  .../devicetree/bindings/ufs/spacemit,k3-ufshc.yaml |  56 ++
>  arch/riscv/boot/dts/spacemit/k3-com260.dtsi        |   4 +
>  arch/riscv/boot/dts/spacemit/k3-pico-itx.dts       |   4 +
>  arch/riscv/boot/dts/spacemit/k3.dtsi               |  22 +
>  drivers/ufs/host/Kconfig                           |  12 +
>  drivers/ufs/host/Makefile                          |   1 +
>  drivers/ufs/host/ufs-spacemit.c                    | 678 +++++++++++++++=
++++++
>  drivers/ufs/host/ufs-spacemit.h                    |  79 +++
>  8 files changed, 856 insertions(+)

Tested-by: Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>

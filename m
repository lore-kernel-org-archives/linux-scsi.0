Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43B21357D0A
	for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2026 06:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789712383; cv=none; b=gYCmWAog+shOwfY4tNdxpZOqQpxhGjpM38bMmutFdkDRYhPOUYbiBUsitkrpLrfxRwgkhUD4VQHGPTgp9IwBdNCaxgojY5OCkf1ZkhvPNT/RbibfESWPkjEwZ9djgPGNiNB3KLXNr3DzBccxfDG44BGwsXcHVKOInmIeQtf2tLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789712383; c=relaxed/simple;
	bh=7Yxs28p87/ftaY8/WHPGoruYL/jiVjsi9J47z2UlkBU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=IZMRmG3mLVKKOEc9TdDu3rfSqrzNfW86kN5dD5k4EgLVXsxQLQ4e/SuYk3UaDC95UbcS/BAk0O3pOtwTC3543S99ighOOTWVEgPZ9j9vBh3UqMn5c2j1Xnia/Wfsc4WqBRO9f45QZacF5bP7VfM/8D/07uQ2P3TkM3JIT5U/Z5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TgMpI3Mj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TgMpI3Mj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B53111F000FF;
	Fri, 18 Sep 2026 06:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789712381;
	bh=GyKEO4F5hhBD86rLZU5rMIOGueP6ey6KJFj6wgMLtvg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TgMpI3MjnAqP5Urmp+qh3WTA9pLw4D0bxvp2esvA1X3QtFofCWrIAGE1AOSI0T9gh
	 ggePGOHXMmpSz6ebeLSg0fUwnOrpE1EhpQ908T1cECtUgdmiHYKHABHTdBMVYWgUlT
	 +LfLfaJxNqSN3szbmdHE0xKFuiF/x9opco3JkpqXG9qGXpWBtVgATLtuLUu/AJD3U9
	 /AT8Y0++jPhdcXIJKqCdmijIC8hYy4Lq0CWbhsM4upbLlMwNWA6kaBHG7u5f55oH63
	 iJglVQejRmNnCrKShlLAVnMqcBo25X+haGYSO8EpJx2O6XW9+PIifwVgiq6S/doRG2
	 k5+FWL5eqOOUw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: fix additional sense code definition
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260918061102.2224753-1-dlemoal@kernel.org>
References: <20260918061102.2224753-1-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 06:19:41 +0000
Message-Id: <20260918061941.B53111F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] scsi: incomplete macro rename leaves #undef ASC, breaking sparc bui=
lds
--

commit c2cd70c047b8b139d3b1ed0fd15c700a718e24ce
Author: Damien Le Moal <dlemoal@kernel.org>

scsi: fix additional sense code definition

This patch renames the ASC() and ASC_DEF() macros to SCSI_ASC() and
SCSI_ASC_DEF() to resolve a naming conflict with sparc architecture
headers.

Closes: https://lore.kernel.org/oe-kbuild-all/202609180743.kyprDg18-lkp@int=
el.com/

> diff --git a/include/scsi/scsi_sense.h b/include/scsi/scsi_sense.h
> index a210a93c1e4e8..f213c52776968 100644
> --- a/include/scsi/scsi_sense.h
> +++ b/include/scsi/scsi_sense.h
> @@ -30,10 +30,10 @@ enum scsi_sense_key {
>  	COMPLETED		=3D 0x0f,
>  };
> =20
> -#define ASC_DEF(name)	ASC_##name
> -#define ASC(name, code)					\
> -	ASC_DEF(name)	=3D (code),			\
> -	name		=3D ((code) << 8) | 0x00
> +#define SCSI_ASC_DEF(name)	ASC_##name
> +#define SCSI_ASC(name, code)				\
> +	SCSI_ASC_DEF(name)	=3D (code),		\
> +	name			=3D ((code) << 8) | 0x00

[Severity: Low]
Were the corresponding #undef directives at the end of this file missed
during the rename?

Further down in include/scsi/scsi_sense.h, these remain:

#undef ASC_DEF
#undef ASC

This leaves the newly renamed SCSI_ASC and SCSI_ASC_DEF macros leaking
into the global namespace, and unintentionally undefines the external ASC
macro. This seems like it will result in an undeclared identifier
compilation error on sparc builds that include both headers in the same
translation unit.

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260918061102.2224=
753-1-dlemoal@kernel.org?part=3D1

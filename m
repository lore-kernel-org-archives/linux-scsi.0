Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E3ED3A9627;
	Thu, 17 Sep 2026 07:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789630704; cv=none; b=sj5+mXA8moIUArq9VVVzcSGDQIC3RDL4KFe+pdBLjesO30DaEY4FVPYLu0WvS4HNH5T8CMM7Ceo8jM3tCL1Kb22RLfqAJOCA08IHgAbdSu7jUR+gt4AyK1nVmXqW/nJHpF4ciKW9Ky/D0pdZ74oT2+0ZdropOsoT075LZaFplTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789630704; c=relaxed/simple;
	bh=EhQKWwBiwSsfT1g/zH4+Lrs/dhW43p18dSx6UZMgXv8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=UdNBCpXlFf1WPT4M2HX5UJOU5uvPVuDgaRhGdCsOTvrzhXnJEEcE7uiT8YESWjhaflsQT20FuRBepN0uAECY/TY9Pjq6wSfF/egJ0MogiXRcvzywma5OjwejNx1SIXxDJcB0CyAHMaTondwtcnL5Vu4vXXHIIVztXe/wXzp+TgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EQ6ue6/G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EQ6ue6/G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC4401F00899;
	Thu, 17 Sep 2026 07:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789630702;
	bh=QWBfoUHT5q4T3RRcSmVDOAAWmNCvNg7PUQ4xMeBt6fA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EQ6ue6/G3Ev8km25N93Ji2XarqfvNPrehZdaaloYruMNtp3Y/f97ztiPnZkxMATZx
	 UEK8Fq6XqRbzStlMJlGr2c5xE5zYPHKk8Kt5U6htxbhfs2ypuKSWljXuu9x8p4pXFI
	 yGCnMHbMoJ12phk/3wp4HF49n+rzC6gm6l/42japXeyFiwtKZajw2/lhNd+IqNQcpK
	 Lsx5V214SkDTt0fMoK1C9QXV+qF6O6BEC7pUuvae5h0W58RBELy8ffKBtInpQ48aCQ
	 jUK0CdT+zZM1gTKLdLF6EFBklSkf5EfvM6zc9bk5122tYalB1Y4oodsAbkrcJeZ8MI
	 FMkn3iPj2+KvQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 19/28] x86/setup: Use snprintf() to concatenate builtin
 and boot command lines
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bill Wendling" <morbo@google.com>
Cc: "Chuck Lever" <cel@kernel.org>, robh@kernel.org, linux-scsi@vger.kernel.org, conor+dt@kernel.org, devicetree@vger.kernel.org, "Jeff
 Layton" <jlayton@kernel.org>, linux-input@vger.kernel.org, dmitry.torokhov@gmail.com, dri-devel@lists.freedesktop.org, media-ci@linuxtv.org, intel-xe@lists.freedesktop.org, "Anna
 Schumaker" <anna@kernel.org>
In-Reply-To: <20260915081910.4142719-20-morbo@google.com>
References: <20260915081910.4142719-1-morbo@google.com>
 <20260915081910.4142719-20-morbo@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 07:38:21 +0000
Message-Id: <20260917073821.AC4401F00899@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] x86/setup: stack frame size exceeded in setup_arch()
--

commit 77de53f82acddaba0d28234aa8f72d7d99b20943
Author: Bill Wendling <morbo@google.com>

x86/setup: Use snprintf() to concatenate builtin and boot command lines

This commit replaces multiple strlcat() calls with a single snprintf()
call in setup_arch() to concatenate the builtin and boot command lines.
It uses a temporary buffer to avoid undefined behavior from overlapping
source and destination buffers, preparing for the removal of the
deprecated strlcat() API.

Link: https://github.com/KSPP/linux/issues/370 [1]

> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -916,9 +916,11 @@ void __init setup_arch(char **cmdline_p)
>  #else
>  	if (builtin_cmdline[0]) {
>  		/* append boot loader cmdline to builtin */
> -		strlcat(builtin_cmdline, " ", COMMAND_LINE_SIZE);
> -		strlcat(builtin_cmdline, boot_command_line, COMMAND_LINE_SIZE);
> -		strscpy(boot_command_line, builtin_cmdline, COMMAND_LINE_SIZE);
> +		char tmp[COMMAND_LINE_SIZE];

[Severity: Low]
Will this unconditionally trigger a -Wframe-larger-than warning during buil=
d?

COMMAND_LINE_SIZE is 2048 on x86_64, which matches the default warning
threshold for stack frames (CONFIG_FRAME_WARN).=20

Combined with the function overhead and other local variables, allocating
this array directly on the stack will reliably exceed the limit and break
builds that have CONFIG_WERROR enabled.

> +
> +		snprintf(tmp, COMMAND_LINE_SIZE, "%s %s", builtin_cmdline, boot_comman=
d_line);
> +		strscpy(builtin_cmdline, tmp, COMMAND_LINE_SIZE);
> +		strscpy(boot_command_line, tmp, COMMAND_LINE_SIZE);
>  	}
>  #endif
>  	builtin_cmdline_added =3D true;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915081910.4142=
719-1-morbo@google.com?part=3D19

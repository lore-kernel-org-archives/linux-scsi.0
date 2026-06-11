Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FC0138945C
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jun 2026 06:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781160821; cv=none; b=ba3jXQNuWV3DxX/op0MRezX2Q+noa21MF1INhJk3T5VBURO/gHqan0M5wjrJ6ih0RdPb+uxX8O3MQSyTZL8/KRNg2wL3r8Lgz1XiI5LCqZK+/dtSq61Y2Vx5K3xAQhMXzEENuO7l4GB7eDhJxtOyJWkJNR+HAl36GCyKC+G+FJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781160821; c=relaxed/simple;
	bh=S0qbWTSSrlmQytFIei+PHc3fQYjOnLaZvTlH1UP18bY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=MKvBNTJU9E1Hx9wBciLlk+j+XETScXiV1JGtJravJvBUGO1yc37mme2l82tBWsWrQcpdMYyqWBwaUKXj4T75BD3HZh/W91afarm3+CwXqVYPce5yn//1Ixd1hb49PS7anCpFLYm2iEz85zsYokQB88g5oRYpvE93fbdfz+jXXyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UjHczuRq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UjHczuRq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 448941F00893;
	Thu, 11 Jun 2026 06:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781160816;
	bh=pU44by4qb+tVC6HxwHFMdfxFnfufJg3Evv/8Wu9lANw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UjHczuRqwWp0V27wBUzWE4aosnXU9Y+RDTwZKZnazuWKwRhWpAsBNM0qVJghl2E7i
	 b2fBs36ZglR0wglHemPb602DHIgQhN/guMTXd895aocI7JmT2vFtU+i0EQzchrtqHF
	 niVMezlsqTYCf5ubrBIrLtD+90J0AXRjoLxpOrSr9YEsT5uH+8R+swm3k492KkttoD
	 B3tt2SZ/dEcGHk+fY9fmMwtRLgs9jYr/6LXZSDEk0L2Le2tkNjZnK9ItAjlW3za967
	 oVSvgHkoYnBoDBBY5rrBSlsqXG/wWjpwy/YmqfV8jBGu2wQ3f7oN0xFA4JNur4yXYZ
	 TT+/cxixZKywg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: esas2r: fix refcount leak in esas2r_resume()
Reply-To: sashiko-reviews@lists.linux.dev
To: "WenTao Liang" <vulab@iscas.ac.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260611064100.65731-1-vulab@iscas.ac.cn>
References: <20260611064100.65731-1-vulab@iscas.ac.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 11 Jun 2026 06:53:35 +0000
Message-Id: <20260611065336.448941F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] The patch introduces a critical vulnerability in the IRQ claim fai=
lure path by blindly calling `esas2r_enable_chip_interrupts()`. Since `esas=
2r_power_up()` already decremented the `dis_ints_cnt` refcount on its succe=
ss path, this additional call drops the refcount to 0, which physically unm=
asks hardware interrupts without a registered OS-level handler.
--

commit bcbf85bebac19683b875da8be0ef4e9cf5ebfcdd
Author: WenTao Liang <vulab@iscas.ac.cn>

scsi: esas2r: fix refcount leak in esas2r_resume()

This commit attempts to fix a refcount leak in esas2r_resume() by calling
esas2r_enable_chip_interrupts() on the error paths.

> diff --git a/drivers/scsi/esas2r/esas2r_init.c b/drivers/scsi/esas2r/esas=
2r_init.c
> index 0a35f19537680..727ddcebec9f9 100644
> --- a/drivers/scsi/esas2r/esas2r_init.c
> +++ b/drivers/scsi/esas2r/esas2r_init.c

[ ... ]

> @@ -699,6 +700,7 @@ static int __maybe_unused esas2r_resume(struct device=
 *dev)
>  		esas2r_debug("yikes, unable to claim IRQ");
>  		esas2r_log(ESAS2R_LOG_CRIT, "could not re-claim IRQ!");
>  		rez =3D -ENOMEM;
> +		esas2r_enable_chip_interrupts(a);

[Severity: High]
Does this call to esas2r_enable_chip_interrupts() prematurely drop the
dis_ints_cnt refcount to 0 and physically unmask hardware interrupts?

If esas2r_power_up() succeeded earlier in this function, its internal succe=
ss
path already decremented the dis_ints_cnt refcount back to 1.

If esas2r_claim_interrupts() subsequently fails to register an IRQ handler =
and
execution branches to this error path, calling esas2r_enable_chip_interrupt=
s()
again drops the refcount from 1 to 0.

When the counter reaches 0, it writes ESAS2R_INT_ENB_MASK to the hardware
register to unmask interrupts. Since the OS explicitly refused to grant the
IRQ, will any generated hardware interrupt be left unhandled, leading to a
screaming interrupt on shared lines and forcing the kernel to disable the
shared IRQ line?

>  		goto error_exit;
>  	}
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260611064100.6573=
1-1-vulab@iscas.ac.cn?part=3D1

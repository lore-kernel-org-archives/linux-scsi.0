Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E01C947ECCE;
	Thu, 17 Sep 2026 07:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789630700; cv=none; b=d7l9zHCr7dY7d9qhb/i7VcAJEcrpmAWoKhgXfcx0cxI3C/FI1Eh5KDX/49j/jxhJWjNgDrgp9Ex9zNwirUepYTzN6xO5PkbmldoEt/kkdMCOJdVI8vetarE1cVSREKnTlL3fKQFRdrzNoSlvxBUPCCCqAoo2EB0zCPv0SfLXLVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789630700; c=relaxed/simple;
	bh=kF/vXg00+QWHRok8uAF21FvMJvEaVr6exICA9/swhjY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=iU2JFVNq2MYIe5DELPvBPuaEn4046r0d2C+b6NdyHIrN9OYsbhQAQcsTNctYRaeIb00cZgoRM6unTy0ey54HcSWVAhfuwy/lKp0/9UDjs4xXOVdWdMbgW5krp27+7o9MJKjR0xXoovOgM1WIXeNhyrNr5BjV/ijhEeVF5pZGzMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=co2D2s0V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="co2D2s0V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCE101F000FF;
	Thu, 17 Sep 2026 07:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789630698;
	bh=c2UNVKSr/QVtorhfnlk/txjQ3lgu4CnqY8mjFGVFZJk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=co2D2s0VMLdvRZQWzBUdZ2Eb6IrjffcwzxfcU4CNGK3YBVMbH1e0tKXT+3gyOOEca
	 jSEhsRB0OP21rtmNnjMPKhlPextvymOcIreUePuKPUNZ8MB52RnceZ5fKYj94z5yuK
	 65uK4rXHF8rLelZnrcrRwwamT9IhlEBdvp2Udm0bUzATjh4RXTwjUY2aeg1u9NH3wJ
	 EOIk7IthgaaZu5YsBnpc0ZlDOlnu8dLugpUYxmzILYmhXMvDka9sjy19DE1aX2gsNf
	 o/+zJ0Vm7ZF71ixu7YmIVvxMYchpXEQnMLLYD3eKbuBsiR1YMSNnaLmT8CTBO0wKgi
	 51aIjec5Rlymw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 04/28] scsi: bfa: Use snprintf() in
 bfa_fcs_fabric_nsymb_init()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bill Wendling" <morbo@google.com>
Cc: linux-scsi@vger.kernel.org, "Chuck Lever" <cel@kernel.org>, "Anna
 Schumaker" <anna@kernel.org>, media-ci@linuxtv.org, dri-devel@lists.freedesktop.org, "Jeff
 Layton" <jlayton@kernel.org>, intel-xe@lists.freedesktop.org, devicetree@vger.kernel.org, conor+dt@kernel.org, linux-input@vger.kernel.org, dmitry.torokhov@gmail.com, robh@kernel.org
In-Reply-To: <20260915081910.4142719-5-morbo@google.com>
References: <20260915081910.4142719-1-morbo@google.com>
 <20260915081910.4142719-5-morbo@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 07:38:17 +0000
Message-Id: <20260917073817.CCE101F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] scsi: bfa: missing char* cast for host_machine_name causes -Wformat=
 warning
--

commit e9ab2501ca8e083742e7d8a4f33a0d89bbb70aad
Author: Bill Wendling <morbo@google.com>

scsi: bfa: Use snprintf() in bfa_fcs_fabric_nsymb_init()

This commit replaces chained strscpy() and strlcat() calls with a single
snprintf() call when constructing the node symbolic name.

Link: https://github.com/KSPP/linux/issues/370 [1]

> diff --git a/drivers/scsi/bfa/bfa_fcs.c b/drivers/scsi/bfa/bfa_fcs.c
> index 9b57312f43f50..7a4e0e8c7182d 100644
> --- a/drivers/scsi/bfa/bfa_fcs.c
> +++ b/drivers/scsi/bfa/bfa_fcs.c
[ ... ]
> @@ -821,30 +821,13 @@ bfa_fcs_fabric_nsymb_init(struct bfa_fcs_fabric_s *=
fabric)
[ ... ]
> -	/* null terminate */
> -	port_cfg->node_sym_name.symname[BFA_SYMNAME_MAXLEN - 1] =3D 0;
> +	/* Model name/number, Driver Version, Host machine name */
> +	snprintf(port_cfg->node_sym_name.symname, BFA_SYMNAME_MAXLEN,
> +		 "%s" BFA_FCS_PORT_SYMBNAME_SEPARATOR
> +		 "%s" BFA_FCS_PORT_SYMBNAME_SEPARATOR
> +		 "%s" BFA_FCS_PORT_SYMBNAME_SEPARATOR,
> +		 model, (char *)driver_info->version,
> +		 driver_info->host_machine_name);

[Severity: Low]
Does this missing cast create a -Wformat compiler warning?

Looking at bfa_fcs_fabric_nsymb_init(), host_machine_name is passed to the
%s format specifier without an explicit (char *) cast, while version on the
preceding line includes one.

Does this cause a type mismatch warning since host_machine_name is an
unsigned char array?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915081910.4142=
719-1-morbo@google.com?part=3D4

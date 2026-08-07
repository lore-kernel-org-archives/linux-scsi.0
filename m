Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2E7D3E7BCA
	for <linux-scsi@vger.kernel.org>; Fri,  7 Aug 2026 09:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786096074; cv=none; b=Dn4U4nPmmhqJ/4ktDv7NGeT14rDi4JrmqrGx1z78O6R3E50IlT0Etj2rmZt9Dm6K98fVb3lsj+66LmhU/7mIrjGJRnATCFZUZoQgjv2PuzNzOvwBgjRd0jYcLshP6KbCoyzJI032arWnXgx2ntXUE1BTBWy8Ip7kGsPuSPmMwjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786096074; c=relaxed/simple;
	bh=8zvivn3Z/v6AK5lByeAZaSgcJReRzX4VuvNfhpeBcKo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=gyciVw2TyzoWeDaI0KC2WrLGDYBEqyxEG/Z2e0yDeDBJL/Enehq9v7bC0D+BSTLb6D4pRUEQ7dj70tN/EsimeG5/Vy1S2mn6uBeaCaSCGTiAj6WtkCrLbhowqxhIlVQtQ0L1lpMoxTlbQ7wfMWpC+w88TmpiqRApC9pjifFZeRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RtEPFEOC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RtEPFEOC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EF2D1F000E9;
	Fri,  7 Aug 2026 09:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786096072;
	bh=H2Yk3PQM1ArV4qNrAdPk0xm6OmQrVtsfGcB2QG0z0+A=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RtEPFEOCPyyS78B/hyT1A3sW/N8UGPPrV/5/b6hfGTdlro3Fb5lpm2bh8OG96XoW7
	 qvAh7DdigHJdKqWPnPQICNAvk7X/LuW12Cc5JE9kpBCER9u6CR4GCYOOxxlZ8cg2MU
	 /ugDCliXn1xhnU567LvgK+XbxcyqJpU1rJct4PGTDEkiIWvQ1DanPZP4OB9YnFdnXm
	 Mv5NzqoK3UHlPws9fC6GDwp/4Cep3S/aP6WWEgR237l1z4JP1d/me9ig5lKt39y0B2
	 djtw8pGgkR5yf2qJT7SvJfRg6cj0fxk6lI9w8ClVEhJCvgtxjmD3uVlXmJ9Zn9KfFo
	 lWbQcX+ZHS77w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: qla2xxx: Fix buffer overrun in login template
Reply-To: sashiko-reviews@lists.linux.dev
To: ghuicao@163.com
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260807093429.102604-1-ghuicao@163.com>
References: <20260807093429.102604-1-ghuicao@163.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 07 Aug 2026 09:47:51 +0000
Message-Id: <20260807094752.2EF2D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] The fix for the buffer overrun shifts the PLOGI payload by 4 bytes=
, corrupting the Fibre Channel Service Parameters and breaking connection e=
stablishment.
--

--- Patch [1]: [PATCH] scsi: qla2xxx: Fix buffer overrun in login template =
---
commit a554cfebac5525fe6bc8fe781ea87856585aeee0
Author: Cao Guanghui <caoguanghui@kylinos.cn>

scsi: qla2xxx: Fix buffer overrun in login template

This patch aims to fix a buffer overrun by changing the destination
pointer for the PLOGI ELS payload copy from the fl_csp field (offset 4)
to the start of the fc_els_flogi structure (offset 0).

> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_i=
nit.c
> index e746c9274cded..7e50cff79b5c6 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -5666,7 +5666,7 @@ static void qla_get_login_template(scsi_qla_host_t =
*vha)
>  		       "PLOGI ELS param read fail.\n");
>  		return;
>  	}
> -	q =3D (__be32 *)&ha->plogi_els_payld.fl_csp;
> +	q =3D (__be32 *)&ha->plogi_els_payld;

[Severity: High]
Does this change shift the firmware's payload backwards by 4 bytes
relative to the struct fields?

The commit message indicates moving the pointer to the start of the
struct does not affect any reader. However, looking at the consumers of
this data, they explicitly expect the firmware payload to align at
offsetof(fl_csp).

For example, in qla24xx_els_dcmd2_iocb() the driver copies the data like
this:

drivers/scsi/qla2xxx/qla_iocb.c:qla24xx_els_dcmd2_iocb()
    memcpy(elsio->u.els_plogi.els_plogi_pyld->data,
           (void *)&ha->plogi_els_payld + offsetof(struct fc_els_flogi, fl_=
csp),
           sizeof(ha->plogi_els_payld) - offsetof(struct fc_els_flogi, fl_c=
sp));

Similarly, qla24xx_process_purex_rdp() reads sp_bb_cred from within fl_csp:

drivers/scsi/qla2xxx/qla_os.c:qla24xx_process_purex_rdp()
    be16_to_cpu(ha->plogi_els_payld.fl_csp.sp_bb_cred);

If the firmware payload consists purely of the Service Parameters without
a 4-byte ELS header, pointing q to the start of the structure will write
the parameters into the fl_cmd field.

Would this cause consumers reading from offsetof(fl_csp) to skip the
first 4 bytes of the actual parameters and read misaligned data,
potentially breaking connection establishments?

> =20
>  	bp =3D (uint32_t *)ha->init_cb;
>  	cpu_to_be32_array(q, bp, sz / 4);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260807093429.1026=
04-1-ghuicao@163.com?part=3D1

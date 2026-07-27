Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 953CE42902D
	for <linux-scsi@vger.kernel.org>; Mon, 27 Jul 2026 17:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785172239; cv=none; b=qNy9GPKTEnI7UlpEwm+qUKvJ1p3dGnofv1HIXlWulat3q3ggaN2EGWV5T1VUXNovBHjH0nRVvi3pC1m/X0PfLCoCVoxoZeaG1Fz9PjZnT/B9FBgvKOag3GGFloLKmwCJ3nUQHF79dKse3qiD8JbxorAPKKP4Eeclg3N7oyT+Cw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785172239; c=relaxed/simple;
	bh=8h6Z2+DBFSehIgXfl0Z9bxV3m8AmfhxoOaqpWh6DY5I=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=CFMd+CgtwqKFpj/paQfUG55V65rrYb/hU9W9qSDRpmZFris4d5mrCqF2YY1mM5v2KGeMp4cxT8Xoxa+pQeqQ3AZPix3TBZbZ2wjugCejcC0dNzkD9yo0MI1LEAX6fQfXaIHp4uz1oq63FTt3TPcF28sHFIBRR4hpTR9AwrJhgJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eOOZRKLo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eOOZRKLo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F4351F000E9;
	Mon, 27 Jul 2026 17:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785172237;
	bh=9qDnb54BwRGvDeOI3SogeuAn5mjEp8cjRGptLHoZIQg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eOOZRKLoIbBX3RePI3A8GUOiXhYwZpIqdCSLaMe72OxWa0K86VH6JVzQco5ShhVRq
	 wU0gSkLE1y/OT2quNcw1wy0pv/y7577dcpD7CAqUvatxpHaRME+81WsZBURv8pc5Y6
	 YzXMUspTbFrJk5RLV8qg6383SvLeZQDY7xTjYuY0hRc6Gf2PYeTk2Z3xOzYNDEJAsy
	 JAa0qWxPMMbu6eS8j3yp7yTTUxmWZpBVMgLPlofla6qB0QeWh1Ugykz4h91PA8rdGb
	 tRYmGAKfwlIqiDzMMoWujsEVl9WGw0yh3uosJkSGmZbXveIBxlIWvwUfXXRkl2iVEm
	 0c+x9LrcLZ8MQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4] scsi: qla2xxx: Fix flex array member not at end
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jesse Taube" <jtaubepe@redhat.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260727164842.2123122-1-jtaubepe@redhat.com>
References: <20260727164842.2123122-1-jtaubepe@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 27 Jul 2026 17:10:36 +0000
Message-Id: <20260727171037.0F4351F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Missing bounds check on user-provided BSG request length leads to =
out-of-bounds memory accesses when casting to driver-specific structures.
--

--- Patch [1]: [PATCH v4] scsi: qla2xxx: Fix flex array member not at end -=
--
commit 5047f2de85357d7b297d2d46b642495d4d1e88e7
Author: Jesse Taube <jtaubepe@redhat.com>

scsi: qla2xxx: Fix flex array member not at end

In qla_edif_bsg.h: struct fc_bsg_reply and struct fc_bsg_request have flexi=
ble
array members, thus they must be the last member of the parent structure. T=
his
commit puts them inside a union with trailing members padded to silence war=
nings.

> diff --git a/drivers/scsi/qla2xxx/qla_edif_bsg.h b/drivers/scsi/qla2xxx/q=
la_edif_bsg.h
> index 514c265ba86e2..2b32a31856292 100644
> --- a/drivers/scsi/qla2xxx/qla_edif_bsg.h
> +++ b/drivers/scsi/qla2xxx/qla_edif_bsg.h
> @@ -36,16 +36,26 @@ struct extra_auth_els {
>  } __packed;
> =20
>  struct qla_bsg_auth_els_request {
> -	struct fc_bsg_request r;
> -	struct extra_auth_els e;
> +	union {
> +		struct fc_bsg_request r;
> +		struct {
> +			unsigned char __fc_bsg_request_sz[sizeof(struct fc_bsg_request)];
> +			struct extra_auth_els e;
> +		};
> +	};
>  };

[Severity: High]
This is a pre-existing issue, but while reviewing this structure I noticed a
potential missing bounds check on the user-provided BSG request length.

When a local user with CAP_SYS_RAWIO issues an SG_IO ioctl on the BSG device
with a maliciously small request_len, the BSG core allocates exactly
request_len bytes using memdup_user().

Since the core fc_bsg_host_dispatch calculates the expected cmdlen but never
validates job->request_len against it, could this lead to an out-of-bounds
heap read when casting bsg_job->request to larger structures?

For instance, in drivers/scsi/qla2xxx/qla_bsg.c:qla2x00_process_vendor_spec=
ific(),
vendor_cmd[0] is accessed without checking if request_len is sufficiently l=
arge:

	ql_dbg(ql_dbg_edif, vha, 0x911b, "%s FC_BSG_HST_VENDOR cmd[0]=3D0x%x\n",
	    __func__, bsg_request->rqst_data.h_vendor.vendor_cmd[0]);

	switch (bsg_request->rqst_data.h_vendor.vendor_cmd[0]) {

Similarly, in drivers/scsi/qla2xxx/qla_edif.c:qla_bsg_check(), the code dir=
ectly
dereferences req->e.sub_cmd assuming the request buffer is fully sized:

	if (p->sub_cmd =3D=3D PULL_ELS) {

Is it possible to validate bsg_job->request_len before accessing these
driver-specific payload fields to prevent out-of-bounds accesses?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260727164842.2123=
122-1-jtaubepe@redhat.com?part=3D1

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DE3044D693
	for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2026 19:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784922782; cv=none; b=AkJOBxyKg6yXKTg40wKiqjASetQn4k1qLEHqJPWmwwC6JJUSxLwxyfkrrN18HyoBL4VC7Vm8VJwU6CNvDpJfs/0hILUjsPCOz2mNxSYmdiFvVmoSeSFJxWtMOJnREMX59VYPuSXL4POWEQddL8wo56SchO4ciV+2QhX5T+lyW0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784922782; c=relaxed/simple;
	bh=vUkOjMp7HOuDGVAA8aXkJhKhVOYJ3GDfj2ji1ilYR2Q=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=PoBQrvEGrG0bYyCjohfELONBDP54LTjMkTDmJtkJyjjmyK+W99bB8mCouPlVXWgh/PKVSVPdyHIGOUbKROXsxsMGtw2OtguOl2ZpVRQXmPYlkB6Y0g9LzbcIROZDqVgFrcMpSDn5DN1qWDZ9fPh4k82FT4pBGTdA2YKvEvYa2ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VP8+z40V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VP8+z40V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A84181F000E9;
	Fri, 24 Jul 2026 19:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784922780;
	bh=/oKz+H6HxmvhWL1IYVlLqpWfOBNGBJJf4franyAatkQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VP8+z40VFVp3kuOVLPG/ibPn9LMSHBOf+uJzQusb9aQpw+B03ltQlgwifJafJsteM
	 VdG5+b6tRoVyPVif0QO+VxBnvDU+x2Ti+6PKNMX3Qd7iVVglwAQcXlOpo96KTyo0fZ
	 x7DmN6Xk32XZlMJsJATWETPBa0lMRVtO3L0dwDJ/SDgszqltDu52MvawpV5jipl5EC
	 74RWWI4zj20iqAIzqlqT0BymfVcS9Z/+zm8GHghdmGIqQTpsJKN8DSzHfjgy/Jx9MA
	 XBHjp7QOsZBdklcP7T4naTXyAmEwjC/ThsCcC4HKROn0qwAmBYE9yiP3r6B1Cs6TWM
	 xrtJ2M4IeaHlw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3] scsi: qla2xxx: Fix flex array member not at end
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jesse Taube" <jtaubepe@redhat.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260724173935.1959397-1-jtaubepe@redhat.com>
References: <20260724173935.1959397-1-jtaubepe@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 24 Jul 2026 19:53:00 +0000
Message-Id: <20260724195300.A84181F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Reordering fields in `struct qla_bsg_auth_els_request` and `struct=
 qla_bsg_auth_els_reply` breaks binary ABI for user-space tools and causes =
memory data aliasing corruption with the core BSG transport layer.
--

--- Patch [1]: [PATCH v3] scsi: qla2xxx: Fix flex array member not at end -=
--
commit 9255e4eda69e9adc31b6a8430b8f725b80a4ca2a
Author: Jesse Taube <jtaubepe@redhat.com>

scsi: qla2xxx: Fix flex array member not at end

In qla_edif_bsg.h: `struct fc_bsg_reply` and `struct fc_bsg_request`
have flexible array members, thus they must be the last member of
the parent structure. Contininging in the effort to add
`-Wflex-array-member-not-at-end`, put `struct fc_bsg_*` inside a
union with the trailing members padded to the size of `struct fc_bsg_*`
to silence the warning. This is similar to TRAILING_OVERLAP, exept
that the position of the flexible array member is also in a union,
causing it to not be the last member of the structure.

> diff --git a/drivers/scsi/qla2xxx/qla_edif_bsg.h b/drivers/scsi/qla2xxx/q=
la_edif_bsg.h
> index 514c265ba86e2..bcc35d149c1f1 100644
> --- a/drivers/scsi/qla2xxx/qla_edif_bsg.h
> +++ b/drivers/scsi/qla2xxx/qla_edif_bsg.h
> @@ -36,16 +36,16 @@ struct extra_auth_els {
>  } __packed;
> =20
>  struct qla_bsg_auth_els_request {
> -	struct fc_bsg_request r;
>  	struct extra_auth_els e;
> +	struct fc_bsg_request r;

[Severity: High]
Does moving `struct fc_bsg_request r` to the end break the ABI and BSG
transport integration?

The generic BSG transport expects the first word of the request buffer to be
`msgcode`, defined in `struct fc_bsg_request`. By moving `r` down, `e` is n=
ow
at offset 0, causing `msgcode` to alias with `e.sub_cmd`.

For example, in drivers/scsi/qla2xxx/qla_edif.c:qla_bsg_check():

	struct qla_bsg_auth_els_request *req =3D
	    (struct qla_bsg_auth_els_request *)bsg_job->request;
...
	p =3D &req->e;

	/* Get response */
	if (p->sub_cmd =3D=3D PULL_ELS) {

Will this cause `qla_bsg_check()` to read the generic BSG command code inst=
ead
of the intended `sub_cmd`, failing to parse valid commands?

>  };
> =20
>  struct qla_bsg_auth_els_reply {
> -	struct fc_bsg_reply r;
>  	uint32_t rx_xchg_address;
>  	uint8_t version;
>  	uint8_t pad[VND_CMD_PAD_SIZE];
>  	uint8_t reserved[VND_CMD_APP_RESERVED_SIZE];
> +	struct fc_bsg_reply r;

[Severity: High]
Does reordering these fields cause memory data aliasing corruption with the
core BSG transport layer?

The BSG core expects `result` at the beginning of the reply buffer.
In drivers/scsi/qla2xxx/qla_edif.c:qla_pur_get_pending():

	rpl->rx_xchg_address =3D purex->pur_info.pur_rx_xchg_address;

	SET_DID_STATUS(rpl->r.result, DID_OK);

Writing to `rpl->rx_xchg_address` overwrites the first 4 bytes of the reply
buffer. Will the BSG core subsequently read this as the standard `result` s=
tatus
and return a corrupted status code to user-space?

>  };

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260724173935.1959=
397-1-jtaubepe@redhat.com?part=3D1

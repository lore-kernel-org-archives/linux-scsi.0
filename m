Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 726D844C669
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 19:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784057268; cv=none; b=uVv1kxYxVjXafqh2AXEo1e9U/4HaLuENSc7YQdQkQSMl3mElmI115My6UeW1wflfY3TbU1rwxymQcQd0xlI0zZbaPmol9nKNzIk3hRU/ju0uxYpGiEdC+n0/N6XCAMP0qfML7vUsGHXbNynw2Z1ZJqhmj+LOrm+U+EJl/fwOAtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784057268; c=relaxed/simple;
	bh=KbsIFfJCc1y+LzJT/gEglSQMrHC+gXny4K8fMldWDcI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=BSzW0ZmwRr9Hdc/5fjpS4frFr4At5eCaOpym1LsCk1qxaM1uwN6jGIB3e72HkGSD1KgGVHhGAR0ZlxGSE/hRGEJ92gwr3luzbRj7HHHbpfVFtIxHEXZtpBb538HdeAtlJFHYmAC8ukMNjQHcLdV7udyCcfsVGicV3fpRb0dVtKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BjSxxQwg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BjSxxQwg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAAA11F000E9;
	Tue, 14 Jul 2026 19:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784057267;
	bh=CGt5B5BEMiGwzgF1dHW6t/B0XAgnmCAAm/fxTAoFc70=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BjSxxQwgAt6d45InInvktv64AG4SGDEg9lZQD5fyFS3OrQbWfHE8oPN+P0q/6bvvj
	 0cfZQp/ou0SMjZ7jzXtxswHcM5990ehYE5btoVDc/Pj37AqNMaqYDMRS6mPHBQ0cO7
	 ouy9cWliGAjVoUeTxh0FI4Zo3EkuFG6/dJQX+79cC4dY9YdNEJ+G3JhpTmoT3E+7DY
	 wr0tQUyxnuUWkv+pCGkI1wE0lfhH0mnxwjPUvNWFfNEP2AAl0FQFYrKJvTWokIG/+5
	 5nj6pk3AHoawwWKIJ7zBdWM/uXse8ZVS/FdW9Ova4bqSUIzGMzaAqDsr9AZGWAylLG
	 7NKzckAWZjS8w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] scsi: qla2xxx: Fix flex array member not at end
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jesse Taube" <jtaubepe@redhat.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260714185621.610105-1-jtaubepe@redhat.com>
References: <20260714185621.610105-1-jtaubepe@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 14 Jul 2026 19:27:46 +0000
Message-Id: <20260714192746.EAAA11F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [Low] The commit message incorrectly claims that structs were moved to th=
e end of the parent structures, while the code actually uses a union trick =
to preserve the existing layout.

Pre-existing issues:
- [High] Heap out-of-bounds read due to missing request_len validation in B=
SG handlers.
--

--- Patch [1]: [PATCH v2] scsi: qla2xxx: Fix flex array member not at end -=
--
commit 71cbbca6ae587defc94dd45238daf79e9aba8d13
Author: Jesse Taube <jtaubepe@redhat.com>

scsi: qla2xxx: Fix flex array member not at end

This commit addresses the flex array member warning for struct fc_bsg_reply
and struct fc_bsg_request in qla_edif_bsg.h. It updates the parent structs
qla_bsg_auth_els_request and qla_bsg_auth_els_reply to wrap the flexible
array structures within unions.

> In qla_edif_bsg.h: struct fc_bsg_reply and struct fc_bsg_request
> have flexible array members, thus they must be the last member of
> the parent structure. Contininging in the effort to add
> -Wflex-array-member-not-at-end, move the structs to the end of
> the parent structures, struct qla_bsg_auth_els_reply and
> struct qla_bsg_auth_els_request .

[Severity: Low]
This isn't a bug, but the commit message states the structs are moved to
the end of the parent structures, while the code actually uses a union
trick with an anonymous struct padding to preserve the existing binary
layout. Could the message be updated to more accurately reflect the use of
the union rather than a structural move?

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
This is a pre-existing issue, but while looking at these structures, is
there a missing bounds check on the request length when processing BSG
messages?

If a user issues an SG_IO ioctl to a BSG device with a minimal request_len
of 4 bytes but specifies a command requiring more data, bsg-lib allocates
exactly request_len bytes.

The generic FC transport increments cmdlen but reads vendor_id without
verifying the bounds:

drivers/scsi/scsi_transport_fc.c:fc_bsg_host_dispatch() {
    ...
    case FC_BSG_HST_VENDOR:
        cmdlen +=3D sizeof(struct fc_bsg_host_vendor);
        if ((shost->hostt->vendor_id =3D=3D 0L) ||
            (bsg_request->rqst_data.h_vendor.vendor_id !=3D
             shost->hostt->vendor_id)) {
    ...
}

The qla2xxx driver also unconditionally reads req->e.sub_cmd from this
request structure at offset 20:

drivers/scsi/qla2xxx/qla_edif.c:qla_bsg_check() {
    ...
    p =3D &req->e;

    /* Get response */
    if (p->sub_cmd =3D=3D PULL_ELS) {
    ...
}

And unconditionally reads vendor_cmd[0] at offset 12:

drivers/scsi/qla2xxx/qla_bsg.c:qla2x00_process_vendor_specific() {
    ...
    ql_dbg(ql_dbg_edif, vha, 0x911b, "%s FC_BSG_HST_VENDOR cmd[0]=3D0x%x\n",
        __func__, bsg_request->rqst_data.h_vendor.vendor_cmd[0]);
    ...
}

Could this lead to a heap out-of-bounds read if request_len is too small?

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260714185621.6101=
05-1-jtaubepe@redhat.com?part=3D1

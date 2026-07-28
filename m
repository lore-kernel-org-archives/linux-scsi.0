Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6666D15A86D;
	Tue, 28 Jul 2026 05:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785216379; cv=none; b=XZJAKpXV7Hp3NUFZ+wyAUq8PWNj98jyIXdSgaz4LK7cMvPA3H5wtZHX2WhRbYcvKv+GACzbr9SU+Rm+dF75idqqZ+2Ut3dcIUg6zBij8Mdt2T+fslhno9NIxrJ+AcL7KE7hSG9CWhguB0LM9PjHzbT/88CnjuQTIsYrl46Md5Y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785216379; c=relaxed/simple;
	bh=fcy3qiTj0m/4ag+ZXIGkp27Vf/DBHho1As6+hIDsvMA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=nwIGcEQJT58Cvb5b5qf94w1QEtamqFb43GaRE5X3eZQ8Kt/2rVMS4RvDCyXrqD9tHFCmlk9iF9JD1+CKCLyjDIdFAW9iIKerP9HnyB8novSD7Fkvp5CFAXZT6dm1R60R8m0nHijETCwdmVg3FgpmcMsJ+GH08D8FJqKtLbzazkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hl5PId55; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hl5PId55"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A56401F00A3D;
	Tue, 28 Jul 2026 05:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785216378;
	bh=Pv6TM2na1QHCCjwj2PPL7L8+fe5xx26epeC4GVEQB20=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hl5PId55P/nAORs/Er+0esEnsLrOCtiOkgxxIb1vtLat14tMg87gH8jMbBt5S27T4
	 Pf/jGe3MjFqkiXVHTsWiuM/OSJK2yjj3aKYQ7XFc1z6mAl0HcLQpoDW0wlI2VtrVIE
	 OaNlBKnLT8FxXo2BOs0FPGMmj/bMelR/0x/bnI9NkwqijH8jFkjt2l2FssMealmmit
	 S8s2KV7nxnBJlWNT+dtCosh4RaUcu5zO6q41dO4h8ej3aje5YLAfANwg1YlH9G62pT
	 3vz/QaFrYWTF+szQIzWkPPA8PaYSQqos+sID9MD07hP7OuP49Z7UJmtQME+DmQCTWA
	 KDXuXrAXWG3cg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 1/3] zfcp: Enhance fsf status read buffer tracing
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nihar Panda" <niharp@linux.ibm.com>
Cc: "Vasily Gorbik" <gor@linux.ibm.com>, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>
In-Reply-To: <20260728044857.2532646-2-niharp@linux.ibm.com>
References: <20260728044857.2532646-1-niharp@linux.ibm.com>
 <20260728044857.2532646-2-niharp@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 28 Jul 2026 05:26:17 +0000
Message-Id: <20260728052617.A56401F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] An integer underflow or missing upper-bounds check when calculatin=
g the payload length from an untrusted hardware response allows a massive o=
ut-of-bounds read, potentially leaking sensitive kernel memory into the deb=
ug trace ring buffer or causing a kernel panic.
--

--- Patch [1]: [PATCH v2 1/3] zfcp: Enhance fsf status read buffer tracing =
---
commit bb1109132aa94648a078f3011317837aeee0a3b8
Author: Chinmaya Kajagar <chinmayk@linux.ibm.com>

zfcp: Enhance fsf status read buffer tracing

This commit enhances FSF status read buffer (SRB) tracing by adding missing
fields to the zfcp_dbf_hba_uss structure. It appends the remaining SRB fiel=
ds
to the unsolicited status trace records and extends the driver to get the
source ID from a reserved field.

> diff --git a/drivers/s390/scsi/zfcp_dbf.c b/drivers/s390/scsi/zfcp_dbf.c
> index 71f625926ae19..89b859176b8bd 100644
> --- a/drivers/s390/scsi/zfcp_dbf.c
> +++ b/drivers/s390/scsi/zfcp_dbf.c
> @@ -220,6 +220,13 @@ void zfcp_dbf_hba_fsf_uss(char *tag, struct zfcp_fsf=
_req *req)
>  	rec->u.uss.lun =3D srb->fcp_lun;
>  	memcpy(&rec->u.uss.queue_designator, &srb->queue_designator,
>  	       sizeof(rec->u.uss.queue_designator));
> +	rec->u.uss.length =3D srb->length;
> +	rec->u.uss.res1 =3D srb->res1;
> +	rec->u.uss.res2 =3D srb->res2;
> +	rec->u.uss.class =3D srb->class;
> +	rec->u.uss.res3 =3D srb->res3;
> +	rec->u.uss.s_id =3D ntoh24(srb->s_id);
> +	memcpy(&rec->u.uss.res4, &srb->res4, sizeof(rec->u.uss.res4));
> =20
>  	/* status read buffer payload length */
>  	rec->pl_len =3D (!srb->length) ? 0 : srb->length -
>  			offsetof(struct fsf_status_read_buffer, payload);

[Severity: High]
This is a pre-existing issue, but can this length calculation underflow if =
the
hardware returns an srb->length smaller than the payload offset?

If srb->length is non-zero but smaller than offsetof(struct
fsf_status_read_buffer, payload) (which is around 64 bytes), rec->pl_len
will underflow and result in a massive unsigned integer.

If that happens, zfcp_dbf_pl_write() could read out-of-bounds past the
single-page allocation boundary, potentially leaking adjacent kernel memory
into the debug trace or causing a page fault panic.

Does this same missing bounds check also exist in zfcp_dbf_san_in_els()?

drivers/s390/scsi/zfcp_dbf.c:zfcp_dbf_san_in_els() {
    ...
    length =3D (u16)(srb->length -
            offsetof(struct fsf_status_read_buffer, payload));
    sg_init_one(&sg, srb->payload.data, length);
    zfcp_dbf_san(tag, dbf, "san_els", &sg, ZFCP_DBF_SAN_ELS, length, ...);
    ...
}

It appears this location also subtracts the offset without checking for
underflow or a zero length, meaning sg_init_one() and zfcp_dbf_san() could
process an extremely large underflowed length.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260728044857.2532=
646-1-niharp@linux.ibm.com?part=3D1

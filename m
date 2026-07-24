Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D8CB385516;
	Fri, 24 Jul 2026 06:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784873883; cv=none; b=E0QpzWOYLvJjswOgb3Df63TCAF74y+5W8rSI8vzYew+8bnJeVXHlwHvQD+dOWBs0FIy9l74f6CTQByOFSD9/gMmuCQx8guga9wv/ojdeTEi2ULYI1vKPfSk/uA9/pFTxYVIEbukA3kfaH1BEJPVghjjudQE6vxPgl4+mfYFJQxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784873883; c=relaxed/simple;
	bh=eExEz3fhe3kIyTtVQd3d+3QkDMYThG7Eyo7G1laF8bE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=V4tFwte6Ke60Cf+zKgH+wlWwOxu4aYgsWiJysH9G0ZasNtDMprtL7Lor3syQBjP6ZHOa8IUXyfyp/GaK6gPnDhNN997sd1tDfFqgly85+p7SQL8TOcvN5ItiXWYaZqeH/dMXQ2fT9fyo8vFwdaK0RdhTRzgyxfibvGdczpnzt6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gbMBpHso; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gbMBpHso"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 996BB1F000E9;
	Fri, 24 Jul 2026 06:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784873882;
	bh=uu0ALMTspE3PJ0I5jSY0qhDd2lyV9IET0RSu0WYlnns=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gbMBpHsoq6kFXk6lsfsdNeGWXfQ3hMwhSYzmxg/FMTwE0yzTiwd2YjDTYmc9zFUJz
	 pQVuF8wHUwV5GdypEhcaUvd6LI4FnOKjNrRxO+10PM8h4lRLZ6UzZl3pO0cYImpfQP
	 zDYmuM5r8qlxuw/OX11aJ086OhpPGYLoM6dPEEw842dg0dS0/KK59yXj7Zv49fRJuk
	 4eeYloH+320+TPLqcho5SHv94CsIL/ez1kTLKA+qwZmSzpTLJtc3MkU4iW1O/UWgPy
	 MLl5p9ZHfbikAA9KqgUYfHa8Dcf1fZNDf5NVCw2s7cGt6b83GvAxQGRRTZ+ydoHNN9
	 wLuPP7rj58SMQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/4] zfcp: Enhance fsf status read buffer tracing
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nihar Panda" <niharp@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, "Vasily Gorbik" <gor@linux.ibm.com>, "Heiko
 Carstens" <hca@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, linux-scsi@vger.kernel.org
In-Reply-To: <20260724053934.2781087-2-niharp@linux.ibm.com>
References: <20260724053934.2781087-1-niharp@linux.ibm.com>
 <20260724053934.2781087-2-niharp@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 24 Jul 2026 06:18:01 +0000
Message-Id: <20260724061801.996BB1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] An integer underflow occurs when the hardware/firmware provides a =
non-zero `srb->length` smaller than the `payload` offset, leading to a mass=
ive out-of-bounds read and potential kernel panic.
- [High] Missing bounds check on hardware-provided `log_start` and `log_len=
gth` allows an out-of-bounds read and information leak.
--

--- Patch [1]: [PATCH 1/4] zfcp: Enhance fsf status read buffer tracing ---
commit 2318c7a31a1b9a647e0a90e8e4d57fd114b807d1
Author: Chinmaya Kajagar <chinmayk@linux.ibm.com>

zfcp: Enhance fsf status read buffer tracing

This commit appends the remaining SRB fields to the unsolicited status trace
records and extends the driver to get the 3-byte source ID from the reserved
field. This helps fully trace the incoming FSF status read buffer.

> diff --git a/drivers/s390/scsi/zfcp_dbf.c b/drivers/s390/scsi/zfcp_dbf.c
> index 71f625926ae19..89b859176b8bd 100644
> --- a/drivers/s390/scsi/zfcp_dbf.c
> +++ b/drivers/s390/scsi/zfcp_dbf.c

[ ... ]

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
> 			offsetof(struct fsf_status_read_buffer, payload);
>=20
> 	if (rec->pl_len)
> 		zfcp_dbf_pl_write(dbf, srb->payload.data, rec->pl_len,
> 				  "fsf_uss", req->req_id, ZFCP_DBF_PAY_LEVEL);

[Severity: High]
This is a pre-existing issue, but is there a risk of an integer underflow
here if the firmware returns a non-zero srb->length that is smaller than the
payload offset?

If srb->length is less than offsetof(struct fsf_status_read_buffer, payload=
),
the subtraction will underflow. Because rec->pl_len is a u16, it would stor=
e a
large truncated positive integer.

Could this cause zfcp_dbf_pl_write() to perform a massive out-of-bounds read
beyond the srb buffer, potentially leading to a kernel panic from unmapped
memory access or leaking adjacent sensitive kernel heap data into the trace
ring buffer?

An identical instance of this calculation seems to exist in
zfcp_dbf_san_in_els() as well.


While reviewing this tracing code, I also noticed another pre-existing issue
in zfcp_dbf_hba_fsf_res():

drivers/s390/scsi/zfcp_dbf.c:zfcp_dbf_hba_fsf_res() {
	...
	if (q_head->log_length) {
		rec->pl_len =3D q_head->log_length;
		zfcp_dbf_pl_write(dbf, (char *)q_pref + q_head->log_start,
				  rec->pl_len, "fsf_res", req->req_id,
				  ZFCP_DBF_PAY_LEVEL);
	}
	...
}

[Severity: High]
This is also a pre-existing issue, but does this code adequately validate t=
he
hardware-provided q_head->log_length and q_head->log_start values?

Since these values are read directly from the hardware-populated qtcb heade=
r,
is it possible for a malfunctioning or compromised firmware to provide
arbitrary offsets and lengths?

Without bounds checking to ensure they fall strictly within the allocated q=
tcb
structure, could zfcp_dbf_pl_write() perform an out-of-bounds read from the
kernel heap, potentially leaking sensitive data or causing a crash?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260724053934.2781=
087-1-niharp@linux.ibm.com?part=3D1

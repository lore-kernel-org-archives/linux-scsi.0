Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FC613D9048
	for <linux-scsi@vger.kernel.org>; Fri, 16 Oct 2026 07:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792134696; cv=none; b=NUfywe+uo9U/T431vdyKMbmI0ggSS+7FHL8jUw1nFC3WcqEAiv4R6jWvSNdfJKghUK0jH3/1DGynqXeUYiFB3dvygnW5uYxl24Cnq+oaM+BQSLY5j9a9YJ+k37pdmuq3U52M/lT5syWhANf2Wr+5Rnclsk7ZyACWd/yqKBnrC+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792134696; c=relaxed/simple;
	bh=O/DkDphKMxhHQkbpZITo/XyxMl//v5zTebMa9OpZ3N8=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=QS4r1Z05Z6gisFqQ9lFxBO3J6kLA7ZeJN5O8bUzxQ18nhYziA2QNrdQ6A7ZDx7OY4aP98Vo5VCB5AuLdAc3ionv7dcdydWXUIy+x+kFeaWW1zIVpKVm019nIyB63Qxwrqjm53tOXHytgAOjMKz+pInMNHmTzAM6xiFe+FzxUIi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JDVS4QkV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JDVS4QkV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CC1C1F000C4;
	Fri, 16 Oct 2026 07:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792134694;
	bh=KAVMJTldQIpGNoW+wty46yVzw2T3a4VsfUjY7Vj0QgM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JDVS4QkVs+DY1W66nzeuZNCDp6z9dR6tj2wHVmZh4PLeU0lHGCJ27EkB2cQGEtZJs
	 +xbZubnt684YtkO9/ZDCUqM37/fjzKWfRJc3FBhuSwjfeKelA3Vlr7mnAjMBg9Bqlm
	 /2okbVsnmSWdd8Rl2q4u4D051UM17yHOYZ5GT5Gmw4khbDH7kmQ/IRlhJDjEq3l9Hh
	 x81+mN8gHUfM1ozKDTkp7FqU4V5os1PQLQnDlGHMZaFyfND+D8lCSBkbQflcX0gUE9
	 FRmBeciXGu20pqEOifq+4+lTFetlaA/w0Gq5KKOk5RSe6WGUEo3TJVaBcitt97pJEU
	 Xgli4OdyL8mCQ==
Message-ID: <sashiko-outbox-173903@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] scsi: bfa: bound the RSCN event list by the received
 frame length
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261016065827.1011210-1-yhlee@isslab.korea.ac.kr>
References: <20261016065827.1011210-1-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 16 Oct 2026 07:11:33 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] scsi: bfa: integer underflow in bfa_fcs_uf_recv bypasses RSCN boun=
ds check
- [Medium] scsi: bfa: missing endianness conditionals for fc_rscn_event_s b=
itfields
--

commit af527b1c9309cc98e3d17a397e7a493ebc42ff03
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Subject: scsi: bfa: bound the RSCN event list by the received frame length

This commit bounds the RSCN event list processing by comparing the payload
length to the actual received frame length. It is intended to prevent
out-of-bounds reads when processing maliciously crafted or malformed RSCN
frames with oversized payload length claims.

> diff --git a/drivers/scsi/bfa/bfa_fcs_lport.c b/drivers/scsi/bfa/bfa_fcs_=
lport.c
> index 8c9d423129c07..49bcb76c118b6 100644
> --- a/drivers/scsi/bfa/bfa_fcs_lport.c
> +++ b/drivers/scsi/bfa/bfa_fcs_lport.c
> @@ -5533,17 +5533,28 @@ bfa_fcs_lport_scn_process_rscn(struct bfa_fcs_lpo=
rt_s *port,
>  			struct fchs_s *fchs, u32 len)
>  {
>  	struct fc_rscn_pl_s *rscn =3D (struct fc_rscn_pl_s *) (fchs + 1);
> -	int             num_entries;
> +	int             num_entries =3D 0, max_entries =3D 0;
>  	u32        rscn_pid;
>  	bfa_boolean_t   nsquery =3D BFA_FALSE, found;
>  	int             i =3D 0, j;
> +	u32             pl_off =3D sizeof(struct fchs_s) + sizeof(*rscn);
> +	u16             payldlen =3D be16_to_cpu(rscn->payldlen);
> =20
> -	num_entries =3D
> -		(be16_to_cpu(rscn->payldlen) -
> -		 sizeof(u32)) / sizeof(rscn->event[0]);
> +	/* payldlen spans a four-byte header and the event list */
> +	if (payldlen >=3D sizeof(u32))
> +		num_entries =3D (payldlen - sizeof(u32)) / sizeof(rscn->event[0]);
> =20
>  	bfa_trc(port->fcs, num_entries);
> =20
> +	/* the event list cannot run past the frame that was received */
> +	if (len > pl_off)
> +		max_entries =3D (len - pl_off) / sizeof(rscn->event[0]);

[Severity: High]
Does this code fully prevent out-of-bounds reads if the received frame leng=
th
is underflowed?

When a truncated frame with a VFT header is passed to bfa_fcs_uf_recv():

drivers/scsi/bfa/bfa_fcs.c:bfa_fcs_uf_recv() {
	u16	len =3D bfa_uf_get_frmlen(uf);
	...
	if (fchs->routing =3D=3D FC_RTG_EXT_HDR &&
	    fchs->cat_info =3D=3D FC_CAT_VFT_HDR) {
		...
		fchs =3D (struct fchs_s *) (vft + 1);
		len -=3D sizeof(struct fc_vft_s);
	...
	bfa_fcs_fabric_uf_recv(fabric, fchs, len);
}

If the frame length is less than 8 bytes, len underflows to a very large
16-bit value (e.g., 65530). This massive length is passed down the call cha=
in
into bfa_fcs_lport_scn_process_rscn() as the u32 len parameter.

Since the underflowed len easily passes the (len > pl_off) bounds check
introduced here, max_entries becomes erroneously large.

Doesn't this bypass the security fix and allow an attacker-controlled paylo=
ad
length to trigger an out-of-bounds read up to 63 kB past the frame buffer?

> +
> +	if (num_entries > max_entries)
> +		num_entries =3D max_entries;

[Severity: Medium]
Are the event bitfields safe to parse directly on big-endian architectures?

Unlike the other Fibre Channel headers in this driver, the structure
fc_rscn_event_s mapping directly to the network payload lacks big-endian
conditional guards:

drivers/scsi/bfa/bfa_fc.h:
struct fc_rscn_event_s {
	u32	format:2;
	u32	qualifier:4;
	u32	resvd:2;
	u32	portid:24;
};

When bfa_fcs_lport_scn_process_rscn() iterates over num_entries, it extracts
rscn->event[i].portid and rscn->event[i].format.

On big-endian systems, won't the bitfields be packed in reverse order compa=
red
to little-endian, causing the driver to extract the wrong RSCN address form=
at
and incorrectly pad the 24-bit portid?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261016065827.1011=
210-1-yhlee@isslab.korea.ac.kr?part=3D1

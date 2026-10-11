Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0097842AA9
	for <linux-scsi@vger.kernel.org>; Sun, 11 Oct 2026 04:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791692013; cv=none; b=tA5f1hkJWFukDoHqPGU0e40R3N1xNWBM6biGRU78LIc66HVHVftHVLQGcvF9VEoRMPnjtr36yZzDPXUve/961CE83iQKk1oW4Ty8GNw0ePEqNmjrbmbuZvJesN/32KeAIy6P88BUqMWcWBpM/tZTE5ymhsKFX05MgrRIq8cQJz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791692013; c=relaxed/simple;
	bh=vXVgRKafOZBhmwYkTtF9sLKRhMwvkGJvdE5aj3D5xhQ=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=NIb1qK3chyudsIyjGOUvRcK0KXLnvDRKwDxPFCphGlTaCY+VeI5xGkPaFibHTearisee/W8XVbckNrxCUzaS6YOyK1FXv2NcGqeKFpM0gW6TL6TdBwOnXWT9bZO75MAiovd4zoOysFXoVmH7KnSxcYVRV3jbA9Wjw3AurFhWIw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bk/5vib/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bk/5vib/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63BFD1F000FF;
	Sun, 11 Oct 2026 04:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791692011;
	bh=zwPRSjfK1M+p660JnwO2+9vonVgH7LXqaoXKrt+1/io=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Bk/5vib/S4M75eF7lLH3RrKzgxGtKooxY+hsigRJFGUKlW/1mthDdFf+G1Sauo7AI
	 CzVOTFTmn6L52xXs5IwG7+CxFrX5VnvHcB9rB+MjW9VBvpwJrFVNNaqkiD0uzazwMj
	 8pZUa/DUyXOcPiL/XYc7TCkjAQC/w66RS+eZMIaUjwVf5yMQ4LjIeqROpU1sEel6Ww
	 6rPxRIt9nrdMaMl6Nmgf4iFsE5Mm195fVUATVTCTg49/aAZcKocLw0n3YVkKKbSft8
	 c1Myy17o0MG9OgAb23XmfdCy4zqPGq+S76PdwhMaEjmFQDBeQtsrGL81Dy4IJA7mwe
	 Rf7cRPN7spCFg==
Message-ID: <sashiko-outbox-167005@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 1/2] scsi: qla4xxx: bound the ISP83xx reset template
 to its buffer
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261011040257.2017421-2-yhlee@isslab.korea.ac.kr>
References: <20261011040257.2017421-1-yhlee@isslab.korea.ac.kr>
 <20261011040257.2017421-2-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 11 Oct 2026 04:13:30 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [Medium] scsi: qla4xxx: missing endianness conversions for reset template=
 payload fields
- [Medium] scsi: qla4xxx: reset sequence checksum check unconditionally pas=
ses
- [Low] scsi: qla4xxx: truncation in template size division causes uninitia=
lized vmalloc memory read
--

commit 4074c809e0d6707e10d7f40671e94534928d0d52
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

scsi: qla4xxx: bound the ISP83xx reset template to its buffer

This commit bounds the ISP83xx reset template to its allocated buffer
before copying from flash, and validates sizes to prevent out-of-bounds
reads and writes. It also adds error path cleanups for the template
pointer states.

Cc: stable@vger.kernel.org

> diff --git a/drivers/scsi/qla4xxx/ql4_83xx.c b/drivers/scsi/qla4xxx/ql4_8=
3xx.c
> index db41d90a5b6e9..44d285af22727 100644
> --- a/drivers/scsi/qla4xxx/ql4_83xx.c
> +++ b/drivers/scsi/qla4xxx/ql4_83xx.c
> @@ -745,7 +745,8 @@ static int qla4_83xx_reset_seq_checksum_test(struct s=
csi_qla_host *ha)
>  {
>  	uint32_t sum =3D  0;
>  	uint16_t *buff =3D (uint16_t *)ha->reset_tmplt.buff;
> -	int u16_count =3D  ha->reset_tmplt.hdr->size / sizeof(uint16_t);
> +	int u16_count =3D  le16_to_cpu(ha->reset_tmplt.hdr->size) /
> +			 sizeof(uint16_t);
>  	int ret_val;
> =20
>  	while (u16_count-- > 0)
>  		sum +=3D *buff++;
> =20
>  	while (sum >> 16)
>  		sum =3D (sum & 0xFFFF) +  (sum >> 16);
> =20
>  	/* checksum of 0 indicates a valid template */
>  	if (~sum) {
>  		ret_val =3D QLA_SUCCESS;
>  	} else {

[Severity: Medium]
Because sum is a 32-bit unsigned integer with its upper 16 bits guaranteed
to be zero after the loop, won't ~sum always result in a value where the
upper 16 bits are set to 1?

Does this mean ~sum will always evaluate to true (non-zero), unconditionally
passing the checksum check regardless of the flash contents?

[ ... ]

> @@ -807,18 +808,36 @@ void qla4_83xx_read_reset_template(struct scsi_qla_=
host *ha)
[ ... ]
> +	tmplt_hdr_def_size =3D (tmplt_size -
> +			      le16_to_cpu(ha->reset_tmplt.hdr->hdr_size)) /
> +			     sizeof(uint32_t);

[Severity: Low]
If the template size minus the header size is not a multiple of 4, integer
division by sizeof(uint32_t) truncates the remaining bytes.

When qla4_83xx_flash_read_u32() reads this truncated word count, could it
leave up to 3 bytes uninitialized at the end of the buffer?

Later, when qla4_83xx_reset_seq_checksum_test() loops over u16_count (which
covers the full size), could it read those uninitialized bytes from the
vmalloc buffer into the checksum calculation?

[ ... ]

> @@ -914,12 +945,14 @@ static void qla4_83xx_write_list(struct scsi_qla_ho=
st *ha,
>  				 struct qla4_83xx_reset_entry_hdr *p_hdr)
>  {
>  	struct qla4_83xx_entry *p_entry;
> +	char *p_end =3D (char *)p_hdr + le16_to_cpu(p_hdr->size);
>  	uint32_t i;
> =20
>  	p_entry =3D (struct qla4_83xx_entry *)
>  		  ((char *)p_hdr + sizeof(struct qla4_83xx_reset_entry_hdr));
> =20
> -	for (i =3D 0; i < p_hdr->count; i++, p_entry++) {
> +	for (i =3D 0; i < le16_to_cpu(p_hdr->count) &&
> +	     (char *)(p_entry + 1) <=3D p_end; i++, p_entry++) {
>  		qla4_83xx_wr_reg_indirect(ha, p_entry->arg1, p_entry->arg2);
>  		if (p_hdr->delay)
>  			udelay((uint32_t)(p_hdr->delay));

[Severity: Medium]
The patch correctly adds le16_to_cpu() for bounds checking like p_hdr->coun=
t,
but the payload fields (arg1, arg2, delay) are used as raw values.

Could this regression write garbage to the hardware registers and apply
incorrect delays on big-endian systems because the little-endian values
aren't converted to host byte order?

[ ... ]

> @@ -948,6 +983,7 @@ static void qla4_83xx_poll_list(struct scsi_qla_host =
*ha,
[ ... ]
>  	delay =3D (long)p_hdr->delay;
>  	if (!delay) {
> -		for (i =3D 0; i < p_hdr->count; i++, p_entry++) {
> +		for (i =3D 0; i < le16_to_cpu(p_hdr->count) &&
> +		     (char *)(p_entry + 1) <=3D p_end; i++, p_entry++) {
>  			qla4_83xx_poll_reg(ha, p_entry->arg1, delay,
>  					   p_poll->test_mask,
>  					   p_poll->test_value);

[Severity: Medium]
Similarly here, test_mask and test_value are used without endianness swappi=
ng.

Will this regression cause the polling loop logic to compare against swapped
bits on big-endian architectures?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261011040257.2017=
421-1-yhlee@isslab.korea.ac.kr?part=3D1

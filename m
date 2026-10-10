Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10DDC3603DD
	for <linux-scsi@vger.kernel.org>; Sat, 10 Oct 2026 18:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791656740; cv=none; b=En2zR3CnsKHp+Azh3L8rnbFdZkcTRFmnzQsBzKIPkBlMWNHzsUvnSoEhqCbD4u2fNmli0ZwjRmu1jI+pwDTnKZM3wRfESc1xq/29JlJKpvxAahXHX3AwqZJffS0ZE3jx4GL0nr3Nju/XivbXzNcoCT4nmiWtkYjlDRW9C/iulLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791656740; c=relaxed/simple;
	bh=7wmGEXbHZJ/YJZMaJZCwjzFrMsKLE8Y3mxft2lFSqP8=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=syO4MVclDEnbSprn00dzYox8pegzO76mV/fyme8zUMrjJH0EzCxxteLtrSYlYdmZYWCD220HMPdivexwJnsJrO0SfrPT/D3moxpJNhCh3WNsZnPphy8aoDisZsuUgTleSzSvMJ1HvZMJWEeclehlv9kHviLjo7YctCDulL4h0Ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A6kdjMve; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A6kdjMve"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65B421F000FF;
	Sat, 10 Oct 2026 18:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791656738;
	bh=4WuvxhOJ0aD7OnRIdqmKREuoEvwYNXfsSeD/e3vEamk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=A6kdjMveGnkXye3peoAm9dgT0oOP05jwBzXpWtAHMEC0ycYy4RHQGbKIGhxGv2qRh
	 5lRnkXydccsKPjJ9Qzapibg8Lwpa2foqn8Qp2f9tSh82RmmB3t9EeYccldMPdB1JtL
	 0ulz9wMg5b+MklkrUjfYKTQ535+QveXqZhPR1FcecZ4thCWrxvUWmkbdz1A0phI4tI
	 9YJRBuOApq/WSTndsb/VnM8PN+CsXg46FLtDNlnDP3oRB2xQMcYAqpJWzzv5bnabx5
	 iWVJQUIAVoD7oOfWoiNXp7ahLKUai4Rmn4iy52iD8j6hFK/BG+RVuUc6a3QmP23wvZ
	 MPkHRas36kB8g==
Message-ID: <sashiko-outbox-166801@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: qla4xxx: bound the ISP83xx reset template to its
 buffer
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261010181139.1911817-1-yhlee@isslab.korea.ac.kr>
References: <20261010181139.1911817-1-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 10 Oct 2026 18:25:37 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] scsi: qla4xxx: inconsistent endianness bypasses bounds check on BE
- [High] scsi: qla4xxx: reset template array_index is never incremented
--

commit e655f165fac597f0102c0474809c6d569ca19038
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

scsi: qla4xxx: bound the ISP83xx reset template to its buffer

This commit bounds the size of the ISP83xx reset template during adapter
initialization to prevent buffer overruns when reading from flash. It also
ensures bounds are respected during template execution and handles error
cleanup properly.

Cc: stable@vger.kernel.org

> diff --git a/drivers/scsi/qla4xxx/ql4_83xx.c b/drivers/scsi/qla4xxx/ql4_8=
3xx.c
> index db41d90a5b6e9..7fbcc4e85b26a 100644
> --- a/drivers/scsi/qla4xxx/ql4_83xx.c
> +++ b/drivers/scsi/qla4xxx/ql4_83xx.c
> @@ -815,6 +815,19 @@ void qla4_83xx_read_reset_template(struct scsi_qla_h=
ost *ha)
>  		goto exit_read_template_error;
>  	}
> =20
> +	/* The template size is chosen by the flash contents and nothing has
> +	 * bounded it yet, so a template claiming to be larger than the buffer
> +	 * would make the read below store past the end of it.  The integrity
> +	 * check runs after the copy and cannot prevent that.
> +	 */
> +	tmplt_size =3D le16_to_cpu(ha->reset_tmplt.hdr->size);
> +	if (tmplt_size > QLA83XX_RESTART_TEMPLATE_SIZE ||
> +	    tmplt_size < le16_to_cpu(ha->reset_tmplt.hdr->hdr_size)) {
> +		ql4_printk(KERN_ERR, ha, "%s: Template size %u is invalid\n",
> +			   __func__, tmplt_size);
> +		goto exit_read_template_error;
> +	}
> +
>  	addr =3D QLA83XX_RESET_TEMPLATE_ADDR + ha->reset_tmplt.hdr->hdr_size;
>  	p_buff =3D ha->reset_tmplt.buff + ha->reset_tmplt.hdr->hdr_size;
>  	tmplt_hdr_def_size =3D (ha->reset_tmplt.hdr->size -
>  			      ha->reset_tmplt.hdr->hdr_size) / sizeof(uint32_t);

[Severity: High]
Does this calculation use the raw unswapped __le16 values?

On Big-Endian architectures, the new le16_to_cpu() check above validates
the swapped size. However, an attacker could provide flash values that
pass the swapped bounds check, but become massive when read directly
without swapping.

Could this bypass the bounds check and lead to the vmalloc-out-of-bounds
write this patch intends to fix?

[ ... ]

> @@ -1046,6 +1082,7 @@ static void qla4_83xx_poll_read_list(struct scsi_ql=
a_host *ha,
>  	int index;
>  	struct qla4_83xx_quad_entry *p_entry;
>  	struct qla4_83xx_poll *p_poll;
> +	char *p_end =3D (char *)p_hdr + le16_to_cpu(p_hdr->size);
>  	uint32_t i;
>  	uint32_t value;
> =20
> @@ -1055,7 +1092,8 @@ static void qla4_83xx_poll_read_list(struct scsi_ql=
a_host *ha,
>  		  ((char *)p_poll + sizeof(struct qla4_83xx_poll));
>  	delay =3D (long)p_hdr->delay;
> =20
> -	for (i =3D 0; i < p_hdr->count; i++, p_entry++) {
> +	for (i =3D 0; i < le16_to_cpu(p_hdr->count) &&
> +	     (char *)(p_entry + 1) <=3D p_end; i++, p_entry++) {
>  		qla4_83xx_wr_reg_indirect(ha, p_entry->ar_addr,
>  					  p_entry->ar_value);

[Severity: High]
Is the array_index properly updated during this loop in
qla4_83xx_poll_read_list()?

Looking at the loop body:

			} else {
				index =3D ha->reset_tmplt.array_index;
				qla4_83xx_rd_reg_indirect(ha, p_entry->dr_addr,
							  &value);
				ha->reset_tmplt.array[index++] =3D value;

				if (index =3D=3D QLA83XX_MAX_RESET_SEQ_ENTRIES)
					ha->reset_tmplt.array_index =3D 1;
			}

The local index is incremented, but is it ever written back to
ha->reset_tmplt.array_index when it is less than the max? It appears
subsequent loop iterations will fetch the same stale index and overwrite
the same array element, breaking the read-modify-write reset operations.

[ ... ]

> @@ -1117,15 +1155,43 @@ static void qla4_83xx_process_reset_template(stru=
ct scsi_qla_host *ha,
>  	int index, entries;
>  	struct qla4_83xx_reset_entry_hdr *p_hdr;
>  	char *p_entry =3D p_buff;
> +	char *p_end;
> +
> +	if (!ha->reset_tmplt.buff || !ha->reset_tmplt.hdr || !p_buff) {
> +		ql4_printk(KERN_ERR, ha, "%s: No valid reset template\n",
> +			   __func__);
> +		return;
> +	}
> =20
>  	ha->reset_tmplt.seq_end =3D 0;
>  	ha->reset_tmplt.template_end =3D 0;
>  	entries =3D ha->reset_tmplt.hdr->entries;
>  	index =3D ha->reset_tmplt.seq_index;
> +	p_end =3D (char *)ha->reset_tmplt.buff +
> +		le16_to_cpu(ha->reset_tmplt.hdr->size);
> =20
>  	for (; (!ha->reset_tmplt.seq_end) && (index  < entries); index++) {
> =20
> +		/* Both the entry count and each entry size come from flash,
> +		 * so stop rather than walk past the end of the template.
> +		 */
> +		if (p_entry < (char *)ha->reset_tmplt.buff ||
> +		    p_entry + sizeof(*p_hdr) > p_end) {
> +			ql4_printk(KERN_ERR, ha, "%s: Entry %d is outside the template\n",
> +				   __func__, index);
> +			ha->reset_tmplt.seq_error++;
> +			break;
> +		}
> +
>  		p_hdr =3D (struct qla4_83xx_reset_entry_hdr *)p_entry;
> +		if (le16_to_cpu(p_hdr->size) < sizeof(*p_hdr) ||
> +		    p_entry + le16_to_cpu(p_hdr->size) > p_end) {
> +			ql4_printk(KERN_ERR, ha, "%s: Entry %d size %u is outside the templat=
e\n",
> +				   __func__, index, le16_to_cpu(p_hdr->size));
> +			ha->reset_tmplt.seq_error++;
> +			break;
> +		}
> +
>  		switch (p_hdr->cmd) {

[Severity: High]
Should the pointer increment at the end of this loop also use
le16_to_cpu(p_hdr->size)?

Looking at the end of qla4_83xx_process_reset_template():

		/* Set pointer to next entry in the sequence. */
		p_entry +=3D p_hdr->size;

Because the new bounds check correctly uses the swapped value, advancing
the pointer by the unswapped value on Big-Endian systems could still jump
out of bounds and read past the buffer.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261010181139.1911=
817-1-yhlee@isslab.korea.ac.kr?part=3D1

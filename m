Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B98A341F375
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 13:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784813133; cv=none; b=rUn9JbPZMUql7RzDRlqaNs4fSORpEp7S7ZFO4yKLqaY5exAd9kHPKS2luHaor0qNrxi1HXBX04Ki/75W8qjoY2M1v9XFc/DtMovLiCelIy1eObAFKdWISq8LAprQL7evCnqESrW4cVGNUe0J13Q3Zo9rmPOfeFyTqdnVF4iRNYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784813133; c=relaxed/simple;
	bh=apLPqWwKmgZSvBAN8TLwSwcjHcMXzF5rqYtmWOzwPA0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=bQMVI4xZw3Sd8Ch40KBqf5WzyWPrvy/l76U3cT7IOLZhEIYnWj3h00qh/qEX9oc91PbjpRgVOrDuMH+KVyJm26CslfcEGHSItqaL4HXfANzronWPKAv7uqf9iCEG1RI7eK08wUaA7lInP6osRgGhm0IeAfLQu42EZKC03azP75g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=izskovzA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="izskovzA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEC501F000E9;
	Thu, 23 Jul 2026 13:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784813120;
	bh=KoLYb8AH98xNpKDmNxZALhJJVvYEhbSQ4Y48pQG1OCY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=izskovzAdH1ruQU0zS2LhaZyKZwj/vYeAjG19EJnVJa6qJIz+qQuKLw2ETYAU7rGx
	 xc0ZW9uqjBOhVp1MEbMrnxmQ4NH2upH1ycmO6DEE7mgQVhfVETc1q1FAK2xFROSACE
	 +4mviWRDmO8l5Xi9CLa7elbFaJf8USE+AhSlDW0vpv7h7KRn32TLU7E9S+oRcJs+fN
	 hO4ynDj271eX3B5vcYi40PIqNtP7fBUYfOvLfu15amkCkbldcinqoz8q/hgJzK1pT7
	 ilj3kVLmAmuub68AuHbvcVLrGrq3eMp1hGscrdTMNIZK4j+yoY7wKX8nqA9yDeCqZU
	 4Yjul205MOU5w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 26/56] scsi: qla2xxx: Update handling of status
 entries for 29xx series
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723050413.3897522-27-njavali@marvell.com>
References: <20260723050413.3897522-1-njavali@marvell.com>
 <20260723050413.3897522-27-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 13:25:19 +0000
Message-Id: <20260723132519.EEC501F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Integer underflow in par_sense_len calculation causes an out-of-bo=
unds read from the DMA response ring buffer.
--

--- Patch [26]: [PATCH v6 26/56] scsi: qla2xxx: Update handling of status e=
ntries for 29xx series ---
commit 41d187f5b4a36f6b90c11b4e9bb88831b9152960
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Update handling of status entries for 29xx series

This commit modifies the qla2xxx driver to handle extended status entries=20
for the 29xx series. It updates function signatures to accept generic=20
pointers and adjusts the parsing logic for FWI2 status IOCBs.

> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_is=
r.c
> index 0d58dc470e870..5aa45b8f49290 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
[ ... ]
> @@ -3429,20 +3454,20 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct=
 rsp_que *rsp, void *pkt)
>  	sense_len =3D par_sense_len =3D rsp_info_len =3D resid_len =3D
>  	    fw_resid_len =3D 0;
>  	if (IS_FWI2_CAPABLE(ha)) {
> +		qla_sts_fwi2_extract(ha, pkt, &sf);
>  		if (scsi_status & SS_SENSE_LEN_VALID)
> -			sense_len =3D le32_to_cpu(sts24->sense_len);
> +			sense_len =3D sf.sense_len;
>  		if (scsi_status & SS_RESPONSE_INFO_LEN_VALID)
> -			rsp_info_len =3D le32_to_cpu(sts24->rsp_data_len);
> +			rsp_info_len =3D sf.rsp_data_len;
>  		if (scsi_status & (SS_RESIDUAL_UNDER | SS_RESIDUAL_OVER))
> -			resid_len =3D le32_to_cpu(sts24->rsp_residual_count);
> +			resid_len =3D sf.rsp_residual_count;
>  		if (comp_status =3D=3D CS_DATA_UNDERRUN)
>  			fw_resid_len =3D le32_to_cpu(sts24->residual_len);
> -		rsp_info =3D sts24->data;
> -		sense_data =3D sts24->data;
> -		host_to_fcp_swap(sts24->data, sizeof(sts24->data));
> +		rsp_info =3D sf.data;
> +		sense_data =3D sf.data;
> +		par_sense_len =3D sf.data_sz;

[Severity: High]
This is a pre-existing issue, but can this code cause an integer underflow
when calculating the remaining sense length?

If the HBA firmware returns a status IOCB with SS_RESPONSE_INFO_LEN_VALID s=
et
and provides an rsp_data_len that is larger than the inline data buffer size
in sf.data_sz, the subtraction further down in qla2x00_status_entry() will
wrap around:

	if (scsi_status & SS_RESPONSE_INFO_LEN_VALID) {
		if (IS_FWI2_CAPABLE(ha)) {
			sense_data +=3D rsp_info_len;
			par_sense_len -=3D rsp_info_len;
		}

Since par_sense_len is an unsigned integer, it becomes a large positive val=
ue.
Later, in qla2x00_handle_sense(), this bypasses the bounds check and leads =
to
an out-of-bounds read from the DMA response ring buffer:

qla2x00_handle_sense() {
    ...
	if (sense_len > par_sense_len)
		sense_len =3D par_sense_len;

	memcpy(cp->sense_buffer, sense_data, sense_len);
    ...
}

Should rsp_info_len be validated against par_sense_len before subtracting i=
t,
to prevent potential leaks of kernel DMA memory?

> +		sts_qual =3D sf.sts_qual;
>  		ox_id =3D le16_to_cpu(sts24->ox_id);
> -		par_sense_len =3D sizeof(sts24->data);
> -		sts_qual =3D le16_to_cpu(sts24->status_qualifier);
>  	} else {
>  		if (scsi_status & SS_SENSE_LEN_VALID)
[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723050413.3897=
522-1-njavali@marvell.com?part=3D26

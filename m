Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF3C05304DA
	for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 15:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791992021; cv=none; b=Z9erQ+m9ElsP8x5uKBDQWzk/yBWU7kTP/OOHS0LQc9FBwpRbWPOVMubkR6i6E4BLWBWqAXTOTHS5J+S33uXXUQceTIFttI/ohEPVC+TeI/zEmzzl1cB+qv9/1/U3+1Za0IRUiZkBrkMkjlL0RNT8VHqMb6q0eYD05oaJzevcHJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791992021; c=relaxed/simple;
	bh=WKZiCTecG+BD3UqSn2hnoOoNKGsiiteaWlp7HLXLgCA=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=WiciJJ0OZCI6GTQMK2gjox4RzPsewrwOBSlMg5t5K9W4jEBgNVdDG6cn/SepSOI84ofo6yZ+Kzz/2KyHXqiqsLeKybQ3gCIIH8HBQjhxt+no8MqYpOD6uozHYr0JaItwrPhnM8/jBvL75bV3Kq5lSCa6TChnVGq6x6NO9/3egs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EfmodgnR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EfmodgnR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7181D1F000C4;
	Wed, 14 Oct 2026 15:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791992020;
	bh=11GeioGbiD1zsyGWGRaGk8Jkx6pG0SI9ns52IKIcP2M=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EfmodgnR2zngxj8PFOWJih73/qMSa3fC/P8Z+n97yFy2jpCYcgoQQa8WLEneu98lF
	 jv7rMi5ciM/LhXyfNE3XxEBTeWXB22CjOnbM7Sjf1Q53v+GemlmF51eCOs2GjVcHZL
	 vYgNy+FfBhJYPuQ6Jh7xzMdfn2tK1aSdRxfJiL4YVt5j++/2CeyUpZvBBKwKVXSzBK
	 YVLVN4eS0nC1zbedTcHdhoG3YmcnH/XmNigIo82C2fbL42y+fdEuHz1hDE2VUk5vwT
	 4D7RGrqHmcDWTfrJV7sgqd5QlTKw0fYME6BpMH5x34hf3l+p1Hu0NbuiNrukvQI0ON
	 JW0Rw6oxkF9Kw==
Message-ID: <sashiko-outbox-171474@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 5/6] scsi: mvumi: validate the response frame tag
 before using it
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261014151914.3632701-6-yhlee@isslab.korea.ac.kr>
References: <20261014151914.3632701-1-yhlee@isslab.korea.ac.kr>
 <20261014151914.3632701-6-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 14 Oct 2026 15:33:40 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] scsi: mvumi: missing READ_ONCE() on DMA tag allows TOCTOU OOB acce=
ss
- [High] scsi: mvumi: missing endianness conversions in DMA shared structs
- [High] scsi: mvumi: missing dma_rmb() before reading DMA ring entry
--

commit 8741f5e18a328ba9b868f0711acd0a3e2b7e9ee4
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Subject: scsi: mvumi: validate the response frame tag before using it

This patch adds bounds and NULL command checks on the response frame tag
used in mvumi_handle_clob, mvumi_receive_ob_list_entry, and
mvumi_check_ob_frame. It ensures the bounds checks include the tag pool
size, and explicitly checks the array element dereference.

> diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
> index e63b3ba7eaabd..07cfac9276e7b 100644
> --- a/drivers/scsi/mvumi.c
> +++ b/drivers/scsi/mvumi.c
> @@ -468,7 +468,7 @@ static char mvumi_check_ob_frame(struct mvumi_hba *mh=
ba,
>  	p_outb_frame =3D mhba->ob_list + cur_obf * mhba->ob_max_size;
>  	request_id =3D p_outb_frame->request_id;
>  	tag =3D p_outb_frame->tag;

[Severity: High]
Does this read from DMA shared memory require a READ_ONCE to prevent a
TOCTOU double-fetch?

Without it, the compiler could potentially optimize this into multiple
fetches directly from memory. If a compromised or malicious device changes
the tag after the bounds check below, could it lead to an out-of-bounds
access on tag_cmd?

[Severity: High]
Does this function also need a dma_rmb before validating and returning?

The udelay(1) called earlier in this function works around the DMA visibili=
ty
race but does not provide the required memory barrier to prevent reordering=
 of
subsequent payload reads.

> -	if (tag > mhba->tag_pool.size) {
> +	if (tag >=3D mhba->tag_pool.size) {
>  		dev_err(&mhba->pdev->dev, "ob frame data error\n");
>  		return -1;
>  	}

[ ... ]

> @@ -546,10 +547,11 @@ static void mvumi_receive_ob_list_entry(struct mvum=
i_hba *mhba)
>  		/* Copy pointer may point to entry in outbound list
>  		*  before entry has valid data
>  		*/
> -		if (unlikely(p_outb_frame->tag > mhba->tag_pool.size ||
> -			mhba->tag_cmd[p_outb_frame->tag] =3D=3D NULL ||
> -			p_outb_frame->request_id !=3D
> -				mhba->tag_cmd[p_outb_frame->tag]->request_id))
> +		tag =3D p_outb_frame->tag;

[Severity: High]
Like in mvumi_check_ob_frame, does this read from DMA shared memory also
require a READ_ONCE to prevent a TOCTOU double-fetch?

Without READ_ONCE, the compiler might optimize this into multiple fetches
directly from memory, which could lead to an out-of-bounds access on tag_cmd
if the tag is changed by the device after the bounds check.

[Severity: High]
Additionally, is a dma_rmb needed after observing a valid tag?

On weakly ordered architectures, the subsequent memcpy of the frame payload
(which happens further down in this function) could be speculatively
reordered before the tag is validated, potentially capturing stale data.

[Severity: High]
Also, tag is a 16-bit field in mvumi_rsp_frame. Since it is being read using
native host endianness, will this result in byteswapped values on big-endian
architectures? This could cause huge swapped tag values to falsely fail the
bounds check.

> +		if (unlikely(tag >=3D mhba->tag_pool.size ||
> +			     !mhba->tag_cmd[tag] ||
> +			     mhba->tag_cmd[tag]->request_id !=3D
> +			     p_outb_frame->request_id))
>  			if (mvumi_check_ob_frame(mhba, cur_obf, p_outb_frame))
>  				continue;

[ ... ]

> @@ -1856,11 +1859,26 @@ static void mvumi_handle_clob(struct mvumi_hba *m=
hba)
>  		list_add_tail(&pool->list, &mhba->ob_data_list);
> =20
>  		ob_frame =3D (struct mvumi_rsp_frame *) &pool->data[0];
> -		cmd =3D mhba->tag_cmd[ob_frame->tag];
> +		/*
> +		 * The tag was checked against the frame in the outbound list.
> +		 * This is the copy, so check the value that is used.
> +		 */
> +		tag =3D ob_frame->tag;

[Severity: High]
Will reading this 16-bit tag from the local copy of the frame using native
endianness cause false bounds check failures on big-endian hosts? It appears
an endianness conversion is missing here as well.

> +		if (tag >=3D mhba->tag_pool.size) {
> +			dev_err(&mhba->pdev->dev,
> +				"ob frame tag[0x%x] out of range\n", tag);
> +			continue;
> +		}
> +		cmd =3D mhba->tag_cmd[tag];
> +		if (!cmd) {
> +			dev_err(&mhba->pdev->dev,
> +				"ob frame tag[0x%x] with no command\n", tag);
> +			continue;
> +		}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261014151914.3632=
701-1-yhlee@isslab.korea.ac.kr?part=3D5

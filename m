Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44A2D248880
	for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2026 01:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792026645; cv=none; b=iyhEV/BEaXlWhCfVHCBzHWbOehCJ7dZNJaRuUkw/0SVFj6a1oxzc6Vh4DQBW7qVZDQ1bbmaBk+sDKCGK8VBtmqPkdn5c/NdhBd4J5bRajylphLRmJ8FXOL/ZnUwR5jTFH9rkLpXD5sYbHLMqLXiqkLrI4Oz7teEBKaZff7yqAug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792026645; c=relaxed/simple;
	bh=EtFaUSWuCFphrjrZ6c8JouAefqaL1kf7e/rn+HOeHBc=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=Nx5FAo4cj+u7q8nIzzfoOpFQ4sfOMr+c7nw5OuQ/z0f74eWxV5Y8vyqjY/W0zAOt4itxq3XX7dUC8L09IGKeFD/Z9OfvjScRTlbQFp9EFGYQwcJiOwxr3ykSSPYSEY8nNsYfRKx7brQgObf2/xrIvNuyIdXPp/T+MkTS0SfkrlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D3EI3Vja; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D3EI3Vja"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6A261F000C4;
	Thu, 15 Oct 2026 01:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792026643;
	bh=ikiTTzHFqLHdTRiQ4zojozrlO3gaK8ctm4z6M1Y4CU8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=D3EI3Vjagu+A5CHm56S5cGnrkdBFscBUQV6Fwrh6VJtUsvnWcJ8Sxn020rrsbf28x
	 7BBDksQFJQeDmNGh3Bv9Qk1VgweTNyuI863tz/wd2x7mZ9KbbH4QRjIKNeZqrnJ/Qo
	 z/PdC57oBiw105P9lbzZhKI/Qvx2nbWEa5re+/2JTLrPytlZZ7+RFhJXsBm92gXjBv
	 rw5CGbM7B+4fnGdY/FaJ8pD7rRdPCh4uYz0MGVpZzJcm0CR1LEyFuc3AzclGms/DPS
	 AuhsTuC4fUQk7cXgBbvr/i9yQWmzX7vAufNY4JjWkT65QybNGDhw13xzFpfV+0UKSS
	 ayaM609bhPA5w==
Message-ID: <sashiko-outbox-172082@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 6/7] scsi: mvumi: validate the response frame tag
 before using it
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261015005717.3719956-7-yhlee@isslab.korea.ac.kr>
References: <20261015005717.3719956-1-yhlee@isslab.korea.ac.kr>
 <20261015005717.3719956-7-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 15 Oct 2026 01:10:43 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [High] scsi: mvumi: unconditional 1us delay per completion for MV9580
- [High] scsi: mvumi: missing endianness conversion for PCI DMA structure f=
ields
- [High] scsi: mvumi: tombstone tag 0xff collides with valid tags if max_io=
 > 255
- [Medium] scsi: mvumi: missing dma_rmb() before reading DMA payload
--

commit fe020b1f81f0a368740581377e4d8b32ba6b98b3
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

scsi: mvumi: validate the response frame tag before using it

This commit fixes out-of-bounds array access and time-of-check to time-of-u=
se
issues in the mvumi driver by ensuring the response frame tag and request ID
are fetched using READ_ONCE() before validation. It also adjusts tag bounds
checks to handle off-by-one errors and checks the tag against the array siz=
e it
indexes.

> diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
> index 8b8e5545747e8..2410d2aa147d9 100644
> --- a/drivers/scsi/mvumi.c
> +++ b/drivers/scsi/mvumi.c
> @@ -466,9 +466,9 @@ static char mvumi_check_ob_frame(struct mvumi_hba *mh=
ba,
> =20
>  	udelay(1);
>  	p_outb_frame =3D mhba->ob_list + cur_obf * mhba->ob_max_size;
> -	request_id =3D p_outb_frame->request_id;
> -	tag =3D p_outb_frame->tag;
> -	if (tag > mhba->tag_pool.size) {
> +	request_id =3D READ_ONCE(p_outb_frame->request_id);
> +	tag =3D READ_ONCE(p_outb_frame->tag);
> +	if (tag >=3D mhba->tag_pool.size) {

[Severity: High]
Since the hardware writes response frames to DMA memory in little-endian
format, does reading tag and request_id directly as native unsigned short
fields cause valid response frames to fail bounds checks on big-endian
architectures?

>  		dev_err(&mhba->pdev->dev, "ob frame data error\n");
>  		return -1;
>  	}
> =20

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
> +		tag =3D READ_ONCE(p_outb_frame->tag);
> +		if (unlikely(tag >=3D mhba->tag_pool.size ||
> +			     !mhba->tag_cmd[tag] ||
> +			     mhba->tag_cmd[tag]->request_id !=3D
> +			     READ_ONCE(p_outb_frame->request_id)))

[Severity: High]
For MV9580 controllers where request_id_enabled is 0, will this condition
almost always evaluate to true because the hardware does not reliably
populate request_id?

If so, this forces a fallback to mvumi_check_ob_frame() for every command
completion, causing an unconditional udelay(1) per command.

[Severity: Medium]
Does this code need a dma_rmb() before reading the DMA payload to ensure
weakly-ordered architectures don't speculatively execute the memcpy() paylo=
ad
fetch before the preceding tag and request_id validity check completes?

Later in mvumi_receive_ob_list_entry(), the driver reads the payload:

        memcpy(ob_data->data, p_outb_frame, mhba->ob_max_size);

Without a memory barrier, fetching stale DMA payload data (which includes I=
/O
completion status and sense data) can result in incorrect I/O completion
handling or data corruption.

[Severity: High]
If the firmware negotiates a max_io greater than 255 (such as 512 or 1024),
could the hardcoded tombstone value of 0xff collide with a legitimate tag?

Further down in mvumi_receive_ob_list_entry(), the code does:

        p_outb_frame->tag =3D 0xff;

The hardware's copy pointer can advance before the DMA completes, meaning t=
he
driver could read a stale tombstoned slot. If it sees tag 255, and tag 255 =
is
currently active with a matching request_id, the unlikely condition evaluat=
es
to false. This bypasses the mvumi_check_ob_frame() delay loop entirely,
causing the driver to prematurely complete the active command with garbage
data.

>  			if (mvumi_check_ob_frame(mhba, cur_obf, p_outb_frame))
>  				continue;
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261015005717.3719=
956-1-yhlee@isslab.korea.ac.kr?part=3D6

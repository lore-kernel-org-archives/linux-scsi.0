Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCE1E3B8921
	for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2026 02:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792032186; cv=none; b=QGKj+TKvbyRgBx8qMsCo7mrkbPBsp3ZLrldlVl0aCXUxrRbM5JzTA/1p7oQ1RDRLZXrGMwOfzPMN94JRtPZSHkXR+edcdC4UpwhaN77Saj5xyIQvfpDtgfUmG0j09cCoK0oIzwyFshbq31zcFO+pBq4UcSGh13eaQh3cZcs3J0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792032186; c=relaxed/simple;
	bh=hBMeVcP1XpUkQGbSAIYWYPbilYeN0VY6oWstYS1UxVw=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=DnTJiKuk8mzjcO4AMuE2a3b2mrzOwsUvUc2k+02WEZ+6hUmRy0zZxfp0TzUvcy17AewtQVo948CznETQQagPTT44Io2tq/pahP6rfpksn7wYezUfLgT1P+LpHWFePUznYknSjEhRIzCoSXBuJ60qVxvTpRVWVixwaCxVK4pZw40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GapAGNnJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GapAGNnJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 295D41F000C4;
	Thu, 15 Oct 2026 02:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792032185;
	bh=1NRUvSpv7fhpLHVU6hU4CyXvrBwn0u0rf+EzkNzxZ9k=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GapAGNnJcdpuXXlN5Je6xDo1rLoR9PnXroVLcx5DO74/1XiPzUK2ugM8RU8aRlGwb
	 FoFah2F16s4uLIfwn3O25JaXtxzi4a/ZbGpzaDjZyA549E55qRRcK0GV2coHnkiLD5
	 iVoRxqInUYu9x+q9LmnVttLJXVYT1c8rpX29TYbJUyipT3Gfez8ejt3XzxDQfJFi0E
	 gnKfvf6lZcOqHqy1hBZhvLdcWgGjWvFoROy15ZJ7UUuzoQuMv9JjnvkOO4tqMTKUZk
	 2INDGPjKEv25RghiqQVVZutrxk9jIcbmhVWBXrvpuO3puVlzB6MzUZyEfUq5jhm7sy
	 ugpZ3PjsqY6dg==
Message-ID: <sashiko-outbox-172173@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 6/8] scsi: mvumi: validate the response frame tag
 before using it
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261015022728.3936714-7-yhlee@isslab.korea.ac.kr>
References: <20261015022728.3936714-1-yhlee@isslab.korea.ac.kr>
 <20261015022728.3936714-7-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 15 Oct 2026 02:43:04 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] scsi: mvumi: missing dma_rmb() causes speculative payload reads
--

commit 3c389f3714e6aa28572a9d4c05ebdfea9ce5674f
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

    scsi: mvumi: validate the response frame tag before using it
   =20
    This commit fixes bounds checking and validates the response frame tag
    used in the outbound list. It also ensures the tag and request ID are
    retrieved using READ_ONCE() to prevent compiler optimizations that could
    lead to multiple fetches.

> diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
> index 8b8e5545747e8..2410d2aa147d9 100644
> --- a/drivers/scsi/mvumi.c
> +++ b/drivers/scsi/mvumi.c
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
>  			if (mvumi_check_ob_frame(mhba, cur_obf, p_outb_frame))
>  				continue;
> =20

[Severity: High]
Does this code need a dma_rmb() here?

The driver polls the completion tokens (tag and request_id) in DMA memory
here. A few lines below, the outbound DMA response frame is copied:

mvumi_receive_ob_list_entry() {
    ...
		tag =3D READ_ONCE(p_outb_frame->tag);
		if (unlikely(...))
			...
    ...
		memcpy(ob_data->data, p_outb_frame, mhba->ob_max_size);
    ...
}

Without a dma_rmb() after the completion tokens are validated, can the CPU
speculatively execute the memcpy() of the payload before reading the
completion token?

On weakly ordered architectures, the CPU may read stale values for
req_status or payload during the memcpy(). This could lead to silent data
corruption if a failed disk IO is incorrectly seen as successful.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261015022728.3936=
714-1-yhlee@isslab.korea.ac.kr?part=3D6

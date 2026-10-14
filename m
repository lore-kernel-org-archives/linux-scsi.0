Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDB3432B137
	for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 02:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791945196; cv=none; b=dJGeRyPg0CfIxlg4LA27Mx4962N4n29uIGnFfv5UBn7uUQrlvA98irzZfqKY5uRYGLy83uH/EfuImGirtqpF4AOojaz30JrDoeT45OLWIFwQ8YesO6pxMU6ZvJTnGqThkraSkch/i7L8L0uOD/vElogPrY1RXNOCVtIc0jpJlG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791945196; c=relaxed/simple;
	bh=WZH8jMw+bPB/VFpr/O8mE0iMrA0MrftEcwlZwzGupgk=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=IrenyGhwP60yEEygYuCrcMBd394cSV1HNy1A6ehDGJHDt1ZMeQBxxJW5Vlz0UMN7kWTYgm2aUDH6HpQ6knsi/ZZ4vK0tQ9loriO4VU3lbgq3i/3UvLg/Zyq58n4JrLXHTKhFur5E4sitGTWqblJ51461l2VRCtMj7RVGTofxO0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PAaRjqk5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PAaRjqk5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEEA51F000FF;
	Wed, 14 Oct 2026 02:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791945191;
	bh=FqYZPoKgAjhesBRaxIe84dbefa8QPo0cY2LUMtsdhj4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PAaRjqk5jJv0XHQQfXiYcYR1lkgKNPCVPlxEOW5RFDNRy5Dy6TH4WclamPdYqMUoB
	 bYzcQpv+9qXLqavmu/G2rcaWAStBhh3cb5sFGC6duwriRzexbAwrK7BOpbo67oUZ8Z
	 y2RkM3uHkeEkxvkYvOxFo56IT4tETJbdGUcQRvXi6ZCD8lgIa7LTF5CDgVzBsJW9bW
	 wLkO7l6vq6HmYe52Qi5sB4Me8YRcpLzaMgZW8M9xBAlM9MwkcX2nQwkCusQoscNwSS
	 ZocNczr1xArouhjjbKEwLwv7sNuyZEvwo8qIvgQ5zqwfnEY16wI0Dv1tQWhCVXKKBW
	 zUvoB76S6jzjQ==
Message-ID: <sashiko-outbox-170695@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3] scsi: mvumi: reject handshake sizes that overflow
 the list allocations
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261014021919.3486362-1-yhlee@isslab.korea.ac.kr>
References: <20261014021919.3486362-1-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 14 Oct 2026 02:33:10 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] scsi: mvumi: state corruption on error path bypasses check
- [Medium] scsi: mvumi: missing reset bounds check for max_target_id causes=
 OOB read
--

commit 0bf09b555b23de542df2211e673ba896cdb17d70
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

scsi: mvumi: reject handshake sizes that overflow the list allocations

This patch introduces checks to reject invalid handshake entry sizes and
list depths from the firmware to prevent allocation overflows. It bounds
the worst-case allocation sizes and rejects handshakes that exceed them,
particularly when buffer sizes grow across a host reset.

> diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
> index e70d336b4ab39..72a1516a804bb 100644
> --- a/drivers/scsi/mvumi.c
> +++ b/drivers/scsi/mvumi.c

[ ... ]

> @@ -1048,19 +1061,32 @@ static int mvumi_hs_process_page(struct mvumi_hba=
 *mhba,
>  	}
> =20
>  	switch (hs_header->page_code) {
> -	case HS_PAGE_FIRM_CAP:
> +	case HS_PAGE_FIRM_CAP: {
> +		unsigned int old_max_io =3D mhba->max_io;
> +		unsigned int old_ib =3D mhba->ib_max_size;
> +		unsigned int old_ob =3D mhba->ob_max_size;
> +		unsigned int old_list =3D mhba->list_num_io;
> +
>  		hs_page1 =3D (struct mvumi_hs_page1 *) hs_header;

[ ... ]

>  		mhba->max_io =3D hs_page1->max_io_support;
>  		mhba->list_num_io =3D hs_page1->cl_inout_list_depth;
>  		mhba->max_transfer_size =3D hs_page1->max_transfer_size;
>  		mhba->max_target_id =3D hs_page1->max_devices_support;

[Severity: Medium]
Is it safe to unconditionally update mhba->max_target_id here?

If a firmware handshake during a host reset returns a max_devices_support
value larger than the initial one, the target_map buffer is not reallocated
because MVUMI_FW_ALLOC is set. During a subsequent mvumi_flush_cache() call,
could the loop using this updated max_target_id read past the end of the
target_map allocation?

[ ... ]

> +		/* On reset the buffers are not reallocated; reject sizes that
> +		 * outgrow them.
> +		 */
> +		if ((mhba->fw_flag & MVUMI_FW_ALLOC) &&
> +		    (mhba->max_io > old_max_io || mhba->ib_max_size > old_ib ||
> +		     mhba->ob_max_size > old_ob ||
> +		     mhba->list_num_io > old_list)) {
> +			dev_err(&mhba->pdev->dev,
> +				"handshake sizes grew across reset\n");
> +			return -1;
> +		}

[Severity: High]
Does returning -1 here permanently corrupt the state in the mhba structure?

Because mhba->max_io and the other size fields were already updated with
the newly reported firmware values earlier in this block, returning
without restoring them leaves the oversized values stored in the mhba
structure. If the host reset is retried, old_max_io and the other
variables will cache these newly corrupted values as the baseline.

Would this cause the growth check to evaluate to false (since new =3D=3D ol=
d),
successfully bypassing the protection entirely and allowing the
out-of-bounds array accesses the patch seeks to prevent?

>  		break;
> +	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261014021919.3486=
362-1-yhlee@isslab.korea.ac.kr?part=3D1

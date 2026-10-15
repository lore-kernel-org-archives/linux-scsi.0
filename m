Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CA7731B101
	for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2026 01:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792026746; cv=none; b=HQVuK4yk1sHITVvPuA1+oF1OgWuB2TcIHZQNl+tVSpjX481AhT2lh1t1p85TJuOxKYlOCjGVgbXMvSw/UoGxqX24hxqZ8PPMeEFfOnovi8/Wbz2EMzj69ErpL/Vj8gutPHTOnLwA4nNpfnpB28GXrIw0+U4iDmKKJuYkF6WmqAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792026746; c=relaxed/simple;
	bh=OazhSoIU33IR8bKICITu3G/sx9PuAJZZ2uQ9IXQODjs=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=VO68VtaOpSItZd+eLzi5MtllBZoro57RpSLlsa4X1KRVPxcxe5eqlDkmHpCU1o3RsTKPNF0J11N47QCBgc+hbnQHBpUE5Ff2bYbH1KDkx4cxrdQ4zLAEh3L84+z+U7He+8YOaFceYJUNHPHRDjL6I91Z01Z5SH5qUpswOnUZZ4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mY7zTG7B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mY7zTG7B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EF571F000C4;
	Thu, 15 Oct 2026 01:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792026744;
	bh=j60vCZU/ClGtaB57eRDSZNWemPiJrX91blJLuOTE9+M=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mY7zTG7BdSe8YQczKyeCS8o6odzhVc1lx8QhlBTjxXge8U4Ti0K/jpmOUyBiD5Xf8
	 bXXqhtQm/1MzLWKamTpW2XBiZ3/qos1e89jHzNzzxH1gi8GEsU8VqwOUrDH6iaPGjh
	 Q6Pu+jBpwl/WxFeXLnu3BAgUypcqoAOg7tEORwRby3bw1AHU4myqHO0YzEBWC/nMwH
	 Amzmq0NlLkLhxom1FsZJp2TmlIdmbHJj0g19esKt33YHhmL2htJtmQj/8c4pW8Cgoe
	 YIkwzInyff0iabymzy8Bg/AgK0J8Lf7s94TS1ITYtxwgPyJpZFRTV7vfeupqQ8n0G1
	 2O8qzejQokPqA==
Message-ID: <sashiko-outbox-172083@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 5/7] scsi: mvumi: reject handshake sizes that
 overflow the list allocations
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261015005717.3719956-6-yhlee@isslab.korea.ac.kr>
References: <20261015005717.3719956-1-yhlee@isslab.korea.ac.kr>
 <20261015005717.3719956-6-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 15 Oct 2026 01:12:24 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] scsi: mvumi: newly added handshake bounds check breaks initializat=
ion on big-endian systems
--

commit 36e8afa776de38b656fa4baf03b7793afdcd3fef
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

scsi: mvumi: reject handshake sizes that overflow the list allocations

This patch adds missing bounds checks in mvumi_hs_process_page() to reject
invalid hardware handshake sizes. It prevents buffer overflows when the
hardware reports excessively large list allocations, capability fields, or
device limits.

> diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
> index 18964e860ac8e..8b8e5545747e8 100644
> --- a/drivers/scsi/mvumi.c
> +++ b/drivers/scsi/mvumi.c
[ ... ]
> @@ -1054,30 +1067,115 @@ static int mvumi_hs_process_page(struct mvumi_hb=
a *mhba,
[ ... ]
> +		/*
> +		 * The page is in coherent DMA memory, so take every field
> +		 * out of it once: a second fetch of a value that has already
> +		 * been checked would not be the value that was checked.
> +		 */
> +		in_sz =3D READ_ONCE(hs_page1->cl_in_max_entry_size);
> +		out_sz =3D READ_ONCE(hs_page1->cl_out_max_entry_size);
> +		list_depth =3D READ_ONCE(hs_page1->cl_inout_list_depth);
> +		new_max_io =3D READ_ONCE(hs_page1->max_io_support);
> +		new_max_target_id =3D READ_ONCE(hs_page1->max_devices_support);

[Severity: High]
Since hs_page1 is populated by the hardware via DMA, aren't these fields
inherently little-endian?

Reading hs_page1->max_devices_support directly into new_max_target_id witho=
ut
le16_to_cpu() causes the bytes to be swapped on big-endian architectures.

> +		new_capability =3D READ_ONCE(hs_page1->capability);
> +		new_max_transfer_size =3D READ_ONCE(hs_page1->max_transfer_size);
> +
[ ... ]
> +		/*
> +		 * A target above MVUMI_MAX_TARGET_ID cannot be addressed: its
> +		 * id would land in the LUN byte of device_id and alias another
> +		 * device.  It is also what makes the loop counter in
> +		 * mvumi_flush_cache() wrap before it reaches the bound.
> +		 */
> +		if (new_max_target_id > MVUMI_MAX_TARGET_ID) {

[Severity: High]
Will this newly added bounds check incorrectly fail the probe on big-endian
systems?

A valid firmware-reported target count of 1 (0x0001) would be byte-swapped
to 256 (0x0100). Since MVUMI_MAX_TARGET_ID is 255, this check would evaluate
256 > 255 as true, falsely log "too many devices reported", and abort the
initialization by returning -1.

> +			dev_err(&mhba->pdev->dev,
> +				"too many devices reported: %u\n",
> +				new_max_target_id);
> +			return -1;
> +		}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261015005717.3719=
956-1-yhlee@isslab.korea.ac.kr?part=3D5

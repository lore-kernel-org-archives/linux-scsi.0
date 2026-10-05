Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A20943E06F
	for <linux-scsi@vger.kernel.org>; Mon,  5 Oct 2026 10:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791194477; cv=none; b=F4Y77URmoUDYeg7S2zCjnKW7C2u4cCYUlkpnF1nqgju90PnUT72opGFobQFk5/d1rmrfqYgCX/937b6BqRYnXbwTyjveHdghQom38dhCsgUOpE8W0jJAmbRFLigudJ3gZBt++sdwZvu7V+skcy6AoJNsDzbPX07yhPVeglI4mFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791194477; c=relaxed/simple;
	bh=rCqV5dkF3cwNqDm1UcrJE9/Dt6cuMtXQXYiEo58JPFs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Is/sEjY54calYYq29UpMw+JPH/caeMvWxHIgc/MrWVtD2tESvxzx7aMqSA4Zq5xMoY+FJzAqE/50wNtaiK0DD5hbu2CyWT8BJDSkZMyQeXl2eTVYLzYGOGEvaVTsDH6eiDXHlEkw4GmNKpUTLRglBeRn3dfBFJnOMcMsuW8AlEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iXmMqB1x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iXmMqB1x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AD261F000FF;
	Mon,  5 Oct 2026 10:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791194475;
	bh=fPy3TLTPBgMeBvl1hZT3GVXWUH/j7fnCMOX8rxYh+jc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iXmMqB1xtYbpF2CyCLtfW5DT71reA/2Q9tjC7FQW9R9HwJRNFio1Rt+IVNxUVjN+U
	 GMSp8C9G/ya4M65quhpSD4SEIJoxMnyoOLWIWLL4aIZ+cTC0vVDd8/dIXVq1uniOP6
	 FxK1bSHRvifxSqYxPvxXQ/itve0m9qP1jWn77yJKJMCL3TzG9IZnDEZaAbpBw9tQIo
	 8jeoZ1ljcVqj+LAceWiGqGYPP+ipn3V+fFzC8anzTrueSS5k8j48WX2cchzG/4kA+b
	 IZzFyA7rXMRgg2BgTHryDhFXDIjGbzfzhQOfLzYevdzlRvGbtucT1aZj98+UOo1RkW
	 OlpmO7+d//s4A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/7] block: fail reads to offline zones early
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261005094632.580753-2-dlemoal@kernel.org>
References: <20261005094632.580753-1-dlemoal@kernel.org>
 <20261005094632.580753-2-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 05 Oct 2026 10:01:15 +0000
Message-Id: <20261005100115.9AD261F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] block: split bios bypass early offline zone read check
--

commit 4d9e6f59ea5e83a002020d10f8ee92430c6bfa6f
Author: Damien Le Moal <dlemoal@kernel.org>

block: fail reads to offline zones early

This commit fails read commands targeting offline zones of a zoned block
device early. It checks if the sector belongs to an offline zone in
submit_bio_noacct() and sets the BIO_QUIET flag before completing the bio
with an error.

> diff --git a/block/blk-core.c b/block/blk-core.c
> index 8836c7028568b..a72aa5c18096e 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -867,6 +867,11 @@ void submit_bio_noacct(struct bio *bio)
> =20
>  	switch (bio_op(bio)) {
>  	case REQ_OP_READ:
> +		if (bdev_is_zoned(bdev) &&
> +		    bdev_zone_is_offline(bdev, bio->bi_iter.bi_sector)) {
> +			bio_set_flag(bio, BIO_QUIET);
> +			goto end_io;
> +		}

[Severity: Medium]
Does this offline zone check get bypassed if a read crosses a zone boundary
into an offline zone?

If a read starts in an online zone but crosses into an offline zone, the
initial sector check passes here. The bio is later split at the zone
boundary by blk_mq_submit_bio() due to chunk_sectors alignment for zoned
devices.

The remainder of the split bio, which now starts exactly in the offline
zone, is then resubmitted by bio_submit_split_bioset() using:

block/blk-merge.c:bio_submit_split_bioset() {
	...
	else if (!blk_throtl_bio(bio))
		submit_bio_noacct_nocheck(bio, true);
	...
}

Because the remainder is submitted via submit_bio_noacct_nocheck(), it skips
submit_bio_noacct() completely. The offline remainder will be issued to
the hardware without the BIO_QUIET flag, potentially causing the noisy
device errors this code is intended to prevent.

>  		break;
>  	case REQ_OP_WRITE:
>  		if (bio->bi_opf & REQ_ATOMIC) {

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261005094632.5807=
53-1-dlemoal@kernel.org?part=3D1

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D01B11A2385;
	Fri, 17 Jan 2025 20:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737144553; cv=none; b=JlbzjnMUUDir8uwZPcEpApcZY48OHQOtx7CS5NpSH4NgUmXgGlxPwH0/bCi/H/rlSRHkmRbcUtPo8IJelmJ7XfrWhzCNKACxDzfD7JXc/U4Tl1Mk8FkbyvgVF7Nq8utUqvZSrDmVGiGE+CwI3nNiTN4MtzeCimsxSQnncct2QYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737144553; c=relaxed/simple;
	bh=M+JxruSgX1bYg5LhmKqbq37EhevWGWaB3pvY8VSU974=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BUaZ+9Jak+mERdlE71ZkouIbMDflUZvoWxiwHOj1of4WezERh24r+jsyVRWutf8zeZAA8MCfkTvI2B1QxS7yBx/zYFBdA0PEA4O52xypZidCGe1RFIoYu/E1jUVMBJdhwLVAtjVixLEkFL0xcBR8Zwf9gpCbubet1A7JLNue3XU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GoSc3/9P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GoSc3/9P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A208C4CEDD;
	Fri, 17 Jan 2025 20:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737144552;
	bh=M+JxruSgX1bYg5LhmKqbq37EhevWGWaB3pvY8VSU974=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GoSc3/9PdTyxgzGZJb88SFSIRNlqMsIjv6lU2ke9g2OVCnv2VetyQC8oq4WRP/Dyv
	 wLHvZvT1wvJiI9INv1XYRILbMrR1Kit+THZ8vyHJPUjmQn9eobwCdmVqAXqTqWOY5K
	 ERmned9Nqif/X8GX9BQrP8YAwWxjwrX9r8zz2HnaoRqKQRAJpPCLC3b4df9AleO6kI
	 ompcgioW5wpvz3kqDFR5Nm6ouEDalP7lBYZNfXqP6jdEUguVA1JBRpE0UYgnuBB88c
	 HRnGVpL8Umje47Y7QI6bPrKUXVluOb71k9bKAPisP+DkYEyZUyVx+4nFw3q8bXox3u
	 9B2k8Vq1qn+WQ==
Date: Fri, 17 Jan 2025 15:09:10 -0500
From: Mike Snitzer <snitzer@kernel.org>
To: John Garry <john.g.garry@oracle.com>, axboe@kernel.dk,
	mpatocka@redhat.com
Cc: axboe@kernel.dk, agk@redhat.com, hch@lst.de, song@kernel.org,
	yukuai3@huawei.com, kbusch@kernel.org, sagi@grimberg.me,
	James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
	linux-block@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH RFC v2 0/8] device mapper atomic write support
Message-ID: <Z4q45sjEih8vIC-V@kernel.org>
References: <20250116170301.474130-1-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250116170301.474130-1-john.g.garry@oracle.com>

On Thu, Jan 16, 2025 at 05:02:53PM +0000, John Garry wrote:
> This series introduces initial device mapper atomic write support.
> 
> Since we already support stacking atomic writes limits, it's quite
> straightforward to support.
> 
> Personalities dm-linear, dm-stripe, and dm-raid1 are supported here, and
> more personalities could be supported in future.
> 
> This is still an RFC as I would like to test further.
> 
> Based on 3d9a9e9a77c5 (block/for-6.14/block) block: limit disk max
> sectors to (LLONG_MAX >> 9)
> 
> Changes to v1:
> - Generic block layer atomic writes enable flag and dm-table rework
> - Add dm-stripe and dm-raid1 support
> - Add bio_trim() patch

This all looks good.

Mikulas, we need Jens to pick up patches 1 and 2.  I wouldn't be
opposed to him taking the entire set but I did notice the DM core
(ioctl) version and the 3 DM targets that have had atomic support
added need their version numbers bumped.  Given that, likely best for
you (Mikulas) to pick up patches 3-8 after rebasing on Jens' latest
for-6.14/block branch (once Jens picks up patches 1 and 2).

Jens, you cool with picking up patches 1+2 for 6.14?  Or too late and
we circle back to this for 6.15?

Either way, for the series:

Reviewed-by: Mike Snitzer <snitzer@kernel.org>

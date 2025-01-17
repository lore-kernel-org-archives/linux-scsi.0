Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8B36198851;
	Fri, 17 Jan 2025 21:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737150681; cv=none; b=mJbSLbrZKYEmVSBURZpHX9EDZ59ThpRuoSHXkUy67qMbXp6R6iOJ35BrpbyipqA4MKxjxwrF9M9Q15oXcOu7M8+c7t/skxrbW/+hp4CpdanIDQauHFG5SZqcUrGavXmp0O75oTJNIthysEAG/WGttyhybMA4FYO4R2QkFKRuZkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737150681; c=relaxed/simple;
	bh=FRpjS2wIB0Lhe5eU5biRWpurnDwG7XTpJwMfPQLrmxU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iBTy2zRgh60hmq5Hv44XIxz1KmOV1CXlU/CAYtWeQsoyihf5Otlc7vfHaGpLYX/O3LfOLga1dHtrVOtE77Jyl4NISrwyjTxJxb3Y1u4pUbCJp4o21CODa4p2VNGSTzetjuAd2Nsxuutb8uZ11p0LI9D8JHTntxF76GV6OKK0/Is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rCxuYe4b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rCxuYe4b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED9A3C4CEDD;
	Fri, 17 Jan 2025 21:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737150680;
	bh=FRpjS2wIB0Lhe5eU5biRWpurnDwG7XTpJwMfPQLrmxU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rCxuYe4bGhBnXfwsLJT0dKNJv6Ceh6kemVixJOPc4/yz2CgwAZ9u4tv+jHHmxVCpe
	 yjAvBO6aMxQro5xnU/+XgenZAo7WNLhAQmB0WlGt1Iw8/gjZB8tj9U7bVZaY/Dq+vO
	 ycL/3pfrbcWgseZCwS+6iXy7RUuhu+MW5gNBCOovCt+AtkenQNR8LCUiUtF8IwtEY4
	 WFxORbiIwZSm6TdmDNKDVZPz07bwR88Gk1b5nBjV6WESatqkJTHjXzHGK43DkHHRym
	 ffj9w1Dqrnvxg+nXwrtrVdoP1XbArL+LtrFNSO6EyxhrHGGGbOLZH1OY9qjFPTw9jl
	 RynjJ0T4WJYuw==
Date: Fri, 17 Jan 2025 16:51:18 -0500
From: Mike Snitzer <snitzer@kernel.org>
To: Mikulas Patocka <mpatocka@redhat.com>, axboe@kernel.dk
Cc: John Garry <john.g.garry@oracle.com>, agk@redhat.com, hch@lst.de,
	song@kernel.org, yukuai3@huawei.com, kbusch@kernel.org,
	sagi@grimberg.me, James.Bottomley@hansenpartnership.com,
	martin.petersen@oracle.com, linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org
Subject: Re: [PATCH RFC v2 0/8] device mapper atomic write support
Message-ID: <Z4rQ1ihb0GsOan6f@kernel.org>
References: <20250116170301.474130-1-john.g.garry@oracle.com>
 <Z4q45sjEih8vIC-V@kernel.org>
 <4c5d02d6-a798-a390-2743-088c31c8965f@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4c5d02d6-a798-a390-2743-088c31c8965f@redhat.com>

On Fri, Jan 17, 2025 at 10:27:22PM +0100, Mikulas Patocka wrote:
> 
> 
> On Fri, 17 Jan 2025, Mike Snitzer wrote:
> 
> > On Thu, Jan 16, 2025 at 05:02:53PM +0000, John Garry wrote:
> > > This series introduces initial device mapper atomic write support.
> > > 
> > > Since we already support stacking atomic writes limits, it's quite
> > > straightforward to support.
> > > 
> > > Personalities dm-linear, dm-stripe, and dm-raid1 are supported here, and
> > > more personalities could be supported in future.
> > > 
> > > This is still an RFC as I would like to test further.
> > > 
> > > Based on 3d9a9e9a77c5 (block/for-6.14/block) block: limit disk max
> > > sectors to (LLONG_MAX >> 9)
> > > 
> > > Changes to v1:
> > > - Generic block layer atomic writes enable flag and dm-table rework
> > > - Add dm-stripe and dm-raid1 support
> > > - Add bio_trim() patch
> > 
> > This all looks good.
> > 
> > Mikulas, we need Jens to pick up patches 1 and 2.  I wouldn't be
> > opposed to him taking the entire set but I did notice the DM core
> > (ioctl) version and the 3 DM targets that have had atomic support
> > added need their version numbers bumped.  Given that, likely best for
> > you (Mikulas) to pick up patches 3-8 after rebasing on Jens' latest
> > for-6.14/block branch (once Jens picks up patches 1 and 2).
> > 
> > Jens, you cool with picking up patches 1+2 for 6.14?  Or too late and
> > we circle back to this for 6.15?
> > 
> > Either way, for the series:
> > 
> > Reviewed-by: Mike Snitzer <snitzer@kernel.org>
> 
> Hi
> 
> I rebased on Jens' block tree, applied the patches 3-8, increased 
> DM_VERSION_MINOR, DM_VERSION_EXTRA, increased version numbers in 
> dm-linear, dm-stripe, dm-raid1 and uploaded it to git.kernel.org.
> 
> You can check it if it's correct.

Looks good, thanks!

Mike

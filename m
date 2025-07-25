Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ED0224BBE4
	for <linux-scsi@vger.kernel.org>; Fri, 25 Jul 2025 21:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753480573; cv=none; b=pV5yZCE0V621C90qEoXctmD+W8xq1tK8PG/qzfDTw2lEkB4He0UGQqrYG1b6suuNh2fVTd7Kr+oxwBwMBV9S3sU0praGcqn9esF7G5Qd9V9B35AP357TtE5zLFeBFPUiUjeFyINSWHB2iFJFzHEWcCJd/yG9CMMSMVaLvovvSNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753480573; c=relaxed/simple;
	bh=df8Tz4QcooVXP0W7cIfY0JvhI9ms4Wz+CegmIjxomhY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D7q9nFwaFGf8jL4z54YVashLJRchezujYz4hSpvM/PlJXQjOAbqnsFFz7Lrl7gnhPXUtrsXd43G1wyiZD7DEC3913ZOJHmNxgnYfYFjdoFVHAV5F19vdjIgfUGE0PIIsujkMSdUQn+HnY+ightPIu/Ic1ozA9dKmzbVKAkO3IH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WjNjXLWI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WjNjXLWI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E634CC4CEE7;
	Fri, 25 Jul 2025 21:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753480572;
	bh=df8Tz4QcooVXP0W7cIfY0JvhI9ms4Wz+CegmIjxomhY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WjNjXLWIHq728FXjUv+xo+QRbjvUkFPjFNvzPq5IcL8m1chqpeExKtGXn6mXcUgQ8
	 P5IVM436+dIrL75XiZm9eC9GVJSgQ21SRpeTApuDu/szLquoon4SxX60OmTkXNRXR1
	 Vh35z9Npy0fHal9y8y7p0LQz3Q4dkMTiBh6xse6TdENdX3+j+ACO5a2ohjBdce4GOu
	 ixgYYBhfljolUNVgD+jbNdnTl//hEapBJmdIXrte4y0b1ggBBoCsWTBxj/lfOwC7V5
	 Jo7sGzpw/E8/m7sJTJHRtiTRqhWaD5U6krtr1Yb0MI6Ih/xsuMzeGMoHC3KVeJVoyB
	 /ynNK8V+rP7fw==
Date: Fri, 25 Jul 2025 14:56:12 -0700
From: Kees Cook <kees@kernel.org>
To: Chris Leech <cleech@redhat.com>
Cc: linux-scsi@vger.kernel.org, Nilesh Javali <njavali@marvell.com>,
	"Gustavo A . R . Silva" <gustavoars@kernel.org>,
	Bryan Gurney <bgurney@redhat.com>,
	John Meneghini <jmeneghi@redhat.com>
Subject: Re: [PATCH 2/2] scsi: qla2xxx: unwrap purex_item.iocb.iocb so that
 __counted_by can be used
Message-ID: <202507251455.6BC9DEE4@keescook>
References: <20250725212732.2038027-1-cleech@redhat.com>
 <20250725212732.2038027-3-cleech@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250725212732.2038027-3-cleech@redhat.com>

On Fri, Jul 25, 2025 at 02:27:32PM -0700, Chris Leech wrote:
> Remove the outer wrapper from the iocb flex array, so that it can be
> linked to purex_item.size with __counted_by.

Oh nevermind about my suggestion, this is WAY better. Perhaps better to
just squash these two patches together?

-Kees

-- 
Kees Cook

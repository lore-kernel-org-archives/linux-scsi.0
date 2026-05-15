Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 233C6D531;
	Fri, 15 May 2026 00:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778804675; cv=none; b=pXO0OLETF29GM+uaPNO2aLeepQ0ET86PLttDRY5RMvFK69qVkUNwYNkRUsa39oXR8YNQodlaVQKn/zV6bailH+jIxTWXdrjBq/t25ZvtafDOuNBkLNWHpDvx+B55s1HMlMCfyNXxlPbGnOMWzFTWvhD+8wmfV24ZqeYNoT/niw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778804675; c=relaxed/simple;
	bh=k4W7/pJA6lvhQOEmxL4Uw4hNh3lzjA73mTSZz6L891g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=irTtCEXYDjQXWNt01Fpl1FtjmuFsZUexTiOjhqAVbY4sHtgVHYeAFb0DdCrrAfEJAfsopcFrIDhI7JzZe9Zh0ijT5Ij2zQ9u/QxSzpsh1Q8E9Azva5ep/JcvWuotSt0uh9RdU2Cf6gMEadYJLs2xMM6sHen2kC/VPVJ3dPRGppU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tD2BIK9V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tD2BIK9V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4531C2BCB3;
	Fri, 15 May 2026 00:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778804674;
	bh=k4W7/pJA6lvhQOEmxL4Uw4hNh3lzjA73mTSZz6L891g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tD2BIK9VBTnBncsoHz8hImJBJ3vlvh7QDgIdEffKwFpWh0uZadfLaadKAdX2eqx3j
	 1O1Q4tGiZOyD91QPUiLS+AJb1VVGvzk4bkrysSZSuu9T6ccr8NM0SN4/pYGMoPJBHu
	 AjE5BAOZuSMbBnRBtJ76U8gESt5i/B8vSKtGQYz4c0pOP4YcY6iFBJOxSIpORWYVMs
	 M88egYe3bRFdeq8/MGmTwPRrsqGlGerf1O8hP7/FhsWbrSLsXRCwbsxnYAHC1uH9Q/
	 DRVqD9qXy3GZ3FbdGLytphLbGeOSMuoDzi7yZ4mSjK/pWw3PZxhBFqXt+KVXF2IHED
	 5iWXIx1088evA==
Date: Thu, 14 May 2026 20:24:33 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: John Garry <john.g.garry@oracle.com>
Cc: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
	martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
	hare@suse.com, bmarzins@redhat.com, nilay@linux.ibm.com,
	jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, michael.christie@oracle.com,
	dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/13] libmultipath: a generic multipath lib for block
 drivers
Message-ID: <agZnwW64PHRew_5l@kernel.org>
References: <20260428111105.1778008-1-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260428111105.1778008-1-john.g.garry@oracle.com>

On Tue, Apr 28, 2026 at 11:10:52AM +0000, John Garry wrote:
> libmultipath: a generic multipath lib for block drivers
> 
> This series introduces libmultipath. It is essentially a refactoring of
> NVME multipath support, so we can have a common library to also support
> native SCSI multipath.
> 
> Much of the code is taken directly from the NVMe multipath code. However,
> NVMe specifics are removed. A template structure is provided so the driver
> may provide callbacks for driver specifics, like ANA support for NVMe.
> 
> Important new structures introduced include:
> 
> - mpath_head
> These contain much of the multipath-specific functionality from
> nvme_ns_head, including a pointer to the gendisk structure and
> a path SRCU-based array.
> 
> - mpath_device
> This is the per-path structure, and contains much the same
> multipath-specific functionality in nvme_ns
> 
> libmultipath provides functionality for path management, path selection,
> data path, and failover handling.
> 
> Since the NVMe driver has some code in the sysfs and ioctl handling
> which iterate all multipath NSes, functions like mpath_call_for_device()
> are added to do the same per-path iteration.

To get upstream this library needs an in-tree consumer. So at the end
of the series, it'd makes sense to include the NVMe and/or SCSI
changes that uses it.

Mike

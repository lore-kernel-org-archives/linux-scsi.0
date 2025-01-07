Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DFFF1E2606;
	Tue,  7 Jan 2025 10:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736244012; cv=none; b=icHOoA4tsLlhkzqhTshx77eYMbjnunAV9X7LXPAzSaMvPle00SUjtM9lK+LfMzGnYCwfBb1enHaL6RbiuB+70a6lH701Dng0KFo0fWE/rjIi7WdIimBDrzf3H0O4826v9WcKPgge8BQCQl6O0cMmFlZ4yBqXy/q7pC7xO6c7/VI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736244012; c=relaxed/simple;
	bh=VKQPgS4SnN96nY/5RA10CNSAWUjHNFtO30HNuewnXRo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CCJU9DqaurdqP7j23DcXJsQjtffcQ3v1dCN/xko2mB39T/7cD/il7oziRa4LFcyCK7LQqHwzMq7PNCMCgdm7OFdfpa3/Gu/YSyaVzGHhr1gIeYHTGWvfbjJgBN6ReP2sLzrc0vbwPTjRDWAk+KH8uQrrO4iQgsMPAF/UgbornoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XRm4c/7f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XRm4c/7f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70CF0C4CED6;
	Tue,  7 Jan 2025 10:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736244009;
	bh=VKQPgS4SnN96nY/5RA10CNSAWUjHNFtO30HNuewnXRo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=XRm4c/7fpeQvzPjN/W88+/YSBAo8AVk768mSxI6ihf8Y2c5EX3L+KSW3FiIt3kbUl
	 HVkj+IVJJRoGt7pfFNmuWmJZWr78sFl+La1SWEZJ/lOTMqJJ+BvWSJ2S3DpNrlxCpa
	 fkZ6RxHEksAJJutrafI+ipaIUBC4fmbV0x6aQ6YdxCQmGwkJkT4Hy9Kdodcpvd44kf
	 291Bp4awwPcnu+wWwQfOHEswWesNfz63OhgrNk+ejEKd0mOlJvKZF9atGU5FCjtYVq
	 kOy6gkM3vJchS4oYjARE5WlMONzSowGm7kgJ7tE96m31/G/+8d4Rfwg8dk+AikxAyc
	 I+O9Iq9/SMyIQ==
Message-ID: <206497e1-883f-4901-b061-b3ddb02965b2@kernel.org>
Date: Tue, 7 Jan 2025 19:00:07 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/8] nbd: fix queue freeze vs limits lock order
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Ming Lei <ming.lei@redhat.com>, Nilay Shroff <nilay@linux.ibm.com>,
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
 nbd@other.debian.org, linux-scsi@vger.kernel.org,
 usb-storage@lists.one-eyed-alien.net
References: <20250107063120.1011593-1-hch@lst.de>
 <20250107063120.1011593-8-hch@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20250107063120.1011593-8-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/7/25 15:30, Christoph Hellwig wrote:
> Match the locking order used by the core block code by only freezing
> the queue after taking the limits lock using the
> queue_limits_commit_update_frozen helper.
> 
> This also allows removes the need for the separate __nbd_set_size helper,
> so remove it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D4EB1A76BC;
	Wed,  8 Jan 2025 10:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736331656; cv=none; b=irMYGbutWMDZRMZkraCnTs2cJhytUZ0tXHYjaQ1tQLyy4LZUfcW6QdZODQm0H/ZDhI+QeGVBK74zBz3llr8+CT7BmWt5LpLn8x7UDR47JNLNHSh37KeajQaZtDSHOb6n7vqxwfTd1lVTH4ZI5HSPEVqvTi4lk10E9y17pixle0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736331656; c=relaxed/simple;
	bh=Sr5csu1r/k1+4I78TRGpkFCdGBPLBm1HsXHZfEAFYng=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WwMvYr6cBl7Ty6DD0IiNKbJQiK9DhQBtVBISEruSsdCIlb+fdlN9V9kNT2eEQaIaLtSzGo/v2YAlZO8iHAImaxaws33jMJlETCIt4MW+lgR/Dg8UKsz9070kx1C8yFjZQpP/ITIrjLVB3Ro/FqEZBoNVgruJ5hH2MiOcuf7NJIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QXAeWW19; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QXAeWW19"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A832BC4CEDF;
	Wed,  8 Jan 2025 10:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736331656;
	bh=Sr5csu1r/k1+4I78TRGpkFCdGBPLBm1HsXHZfEAFYng=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=QXAeWW19UR5Uc2GWgAUU8XJQ0Y9EbfHBv+4+D6eboqmkJTOrbUVB3YzxsVTyS/M4R
	 FXfyjMyMCy87j14VA5jWaE7k4GW/7gs/trNhg0nwRWBtji2VISgv3UoFu/kCNZE5o0
	 mARAo5JtXo9rt1oZ8qes7XRflBk1TP3Pl9vx/p8N1sdRZPKXzRnP8ebafU/VVPyNm2
	 J+O/B8n/2GPrGHNWzpPCmSAVTjy1TAL/aFzxlSldH4H6x0dndbPBEWePJg21LvIZYV
	 RzlmI6Hexjygca8+CptGU7zHdguig7d1/mNA9w42RSh1kA1DmGu/06PcAqplO/FUdt
	 Yk4/1Ui9IDxJg==
Message-ID: <866f4dff-c9bf-43d1-996b-bafd830b9e61@kernel.org>
Date: Wed, 8 Jan 2025 19:20:10 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/10] loop: refactor queue limits updates
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Ming Lei <ming.lei@redhat.com>, Nilay Shroff <nilay@linux.ibm.com>,
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
 nbd@other.debian.org, linux-scsi@vger.kernel.org,
 usb-storage@lists.one-eyed-alien.net
References: <20250108092520.1325324-1-hch@lst.de>
 <20250108092520.1325324-10-hch@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20250108092520.1325324-10-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/8/25 6:25 PM, Christoph Hellwig wrote:
> Replace loop_reconfigure_limits with a slightly less encompassing
> loop_update_limits that expects the aller to acquire and commit the
> queue limits to prepare for sorting out the freeze vs limits lock
> ordering.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research

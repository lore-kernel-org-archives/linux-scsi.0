Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36455169383;
	Wed, 29 May 2024 08:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716971295; cv=none; b=hfytzjArk44iWEDrvI+RgtpvR+kG4coG531dvRj7bLkJcT9RKGrcgjvvE/SGVS/+7q/KEwKK+MUHMLRqBfxSe4uPce0KXj0pb5PNfHSRPmmUvALRqnzf6k2DFw/I/YOvwEzCKqUqhSKaM2t+vGpPl9XFoGDHj2BQwnMqlSEFLug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716971295; c=relaxed/simple;
	bh=4xLTsI+g+6PM4GZdcp6tkOURF5lktb+4fm2gix3vClQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JSu4Pq6JvsTWVKO4Qw4/Dtzmt5xQhOP79dXJ3gYozOFQf7LMwiunVWgfZY/VSzb3DUW9maBaBY3bVqPXRrU5TB/z010TqkrAczDvqIWxcp2DDbInbY8k4NAa3bbSGCXJbo23r/r/5/f0467IsVoF5Qnr6JVP/dtrHMO7ITzHgew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=creCoCfk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="creCoCfk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF68BC2BD10;
	Wed, 29 May 2024 08:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716971294;
	bh=4xLTsI+g+6PM4GZdcp6tkOURF5lktb+4fm2gix3vClQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=creCoCfkg1r9P0k8mhbQwfgzqAswZmiHcWn5Bd1MuoZI86SxYC6hCoH0KS7axJpRP
	 T5h8NZUH+144AFLShb1Ye209bRfiGKQfICluAxPCjIl31GxjbCY/ZZO9BCNN2JyPxs
	 KI2ckBHEkR0/WvEE3z6RgUJOVV2nWrAL1xRk0dgjzNMb2/4WydlFDV4Vv9Q9Exms4t
	 zw1nCtAcJ7pSBxyqVgpFzXBd4oJqfsn4Md73ZGniohT92LzP2SC+w4HfaZP9jPfdIk
	 B1KifcBYlefe27lPs+SGjeRu5o3YScEpjkE/6WSWgxZ1cgJ6Uev8aMv3ZeVlm9xQqD
	 86KgS37/4vtFA==
Message-ID: <89f98897-bfb4-48d1-9b60-d793fde9fade@kernel.org>
Date: Wed, 29 May 2024 17:28:11 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 11/12] block: remove unused queue limits API
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Richard Weinberger <richard@nod.at>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>,
 Johannes Berg <johannes@sipsolutions.net>, Josef Bacik
 <josef@toxicpanda.com>, Ilya Dryomov <idryomov@gmail.com>,
 Dongsheng Yang <dongsheng.yang@easystack.cn>,
 =?UTF-8?Q?Roger_Pau_Monn=C3=A9?= <roger.pau@citrix.com>,
 linux-um@lists.infradead.org, linux-block@vger.kernel.org,
 nbd@other.debian.org, ceph-devel@vger.kernel.org,
 xen-devel@lists.xenproject.org, linux-scsi@vger.kernel.org
References: <20240529050507.1392041-1-hch@lst.de>
 <20240529050507.1392041-12-hch@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20240529050507.1392041-12-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/29/24 14:04, Christoph Hellwig wrote:
> Remove all APIs that are unused now that sd and sr have been converted
> to the atomic queue limits API.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

I think that disk_set_max_open_zones() and disk_set_max_active_zones() can also
go away.

-- 
Damien Le Moal
Western Digital Research


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5408B1547D2;
	Tue,  7 Jan 2025 10:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736244241; cv=none; b=JrzZf1ZA3fCO3d0Q4ccZt1rA8W4npve1W6MwVRR64LuU9H7Drv8oT3dua8h/ubWuGNeueRDdIJzmwQF65O1aAQFtPCK5O7qgf8n7IFDGoSei/DmLSKbDdhu3pd47g40lGP8SqSZu0BAlX6BNnCTKasVY4iP0gmLYNmpEpS0UDyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736244241; c=relaxed/simple;
	bh=rUve2nznfdJENEEcSgWwkof690ekE/iRC9z9WsHpcLY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MS4FPTpzgPAiO1iHLIIv2hNnO1Nd+yBxBW8d9tUArIr2Sxn4n15F7pZ+mUnO4mJJT0SgUAqR56xZ907W9vDxAhIhIKc9bwrk/AZ5mgdf/Os3mcf6vYZ7IKwEJYm+YbfBqnvUfOWUG3H/H/GjD3ycq2MmFl9TxqDgg/h1zHsYqbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PA7cDLky; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PA7cDLky"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B98D5C4CED6;
	Tue,  7 Jan 2025 10:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736244241;
	bh=rUve2nznfdJENEEcSgWwkof690ekE/iRC9z9WsHpcLY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=PA7cDLkyurapGnj8vGoiTcWIYoZrgj2LJcNu3/RwVpCDzqg47G9i3B5XHmroIH86A
	 9FQq7oHCRHUqnNLtuhNAXn6fH54CClksh0MJz9rZNPWQepCY4i8qg9D24npcAJJwq1
	 zo0kY3f9dsGMISWf0lpMBNc6zXYCVtciwqcqPjFTGCw0D20Dg7BFOfYUwe2mOnJyVb
	 4oLrjqghFC2PVOUQLfaWwOhDBzzOJ5235u3m1hhtZBIIGcfwh8D1znoZjchZKm0JDT
	 0NY1IYQ02tN/YWPwKR9C/EzVQQMKu9HjzYWXrk5kOHWsVmZH6t+G3z3u+eEs2gW2NV
	 T8B31lFjitg6w==
Message-ID: <a3c969a5-276b-4e14-8115-765991c560ba@kernel.org>
Date: Tue, 7 Jan 2025 19:03:58 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/8] block: fix docs for freezing of queue limits updates
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Ming Lei <ming.lei@redhat.com>, Nilay Shroff <nilay@linux.ibm.com>,
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
 nbd@other.debian.org, linux-scsi@vger.kernel.org,
 usb-storage@lists.one-eyed-alien.net
References: <20250107063120.1011593-1-hch@lst.de>
 <20250107063120.1011593-2-hch@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20250107063120.1011593-2-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/7/25 15:30, Christoph Hellwig wrote:
> queue_limits_commit_update is the function that needs to operate on a
> frozen queue, not queue_limits_start_update.  Update the kerneldoc
> comments to reflect that.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

With this comment fixed as Nilay suggested, feel free to add:

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research

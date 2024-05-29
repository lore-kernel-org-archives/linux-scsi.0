Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3520A167DBD;
	Wed, 29 May 2024 08:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716970493; cv=none; b=poRbcTf5zo+rGMiV4/KK1isO+A38D/pp28BAmWyFoq2+vgCaUKDIc6/CLW357MXTM8jn+gNINomsg+BbL7N45AvYZrzVwbr1QNG/gJk8Ch86pxWzlI52CPtJZCHYU57Md6EEF2iJrA5UrKkkecg2EZTjgIc9ypTGOuaL8+6uNj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716970493; c=relaxed/simple;
	bh=807aMJTkC1p+AoxUwaQMdhMlZoRzxAswKTa2dL4juDQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fIlQG1thSe0vEiPU9Ub7YGFo9iLZGu+MVpHdKhbUFvezPByaI0Ns1ACtLCDqoASu2SGETKH7D6lsvCWdKlBd7g+bW8buIaVwbuIdLA5CjhLy0kO9CaIF8e2L/OrheihHpxP05tGiKaTU+P1x31mgL8XEwU/T5T2fh1xvEMV6gRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UxzQFdZD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UxzQFdZD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B98BC2BD10;
	Wed, 29 May 2024 08:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716970493;
	bh=807aMJTkC1p+AoxUwaQMdhMlZoRzxAswKTa2dL4juDQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=UxzQFdZDojD5zpNCznqhTAYgdt/u91jAQBq4urzSctjoQNdJc95kx61nCycDlwl+Q
	 1JAZAr2BWpd8fVSOv1QtVb8WnA/H3q5yZ/J6rV5BrOS0h/5R7SBN4XhluIsMA1bnkC
	 ZgxW77pqNTlnmVDHqOWJDaloGp+tPXvK5/dfQKe4x5GXGHc718XUnBvEf6dq9tu658
	 4RCg8AKM8Yv0x+3AoBe6WqI19ZjEWYVxMLHJL8shoIDvIkL5J73b1/ED3qKdfnQSgN
	 6cjSWuxuKauqmy2HYUIA1sDs9N0HxdoZvZ2tKGZTyDH71GI3SCMxH44xQHHHqS1bMT
	 OeyWAOUjf5bLQ==
Message-ID: <87cbfdc6-4ba3-4a3c-9d80-24584fa38f27@kernel.org>
Date: Wed, 29 May 2024 17:14:50 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/12] sd: factor out a sd_discard_mode helper
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
 <20240529050507.1392041-8-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20240529050507.1392041-8-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/29/24 14:04, Christoph Hellwig wrote:
> Split the logic to pick the right discard mode into a little helper
> to prepare for further changes.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78CDE169385;
	Wed, 29 May 2024 08:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716970707; cv=none; b=uwSkN5C+6HtPqIV2Dx9mOiazy9bpmd9yRYR8ZYwEGB2wrHDKpzsjStg16OnF1BFdPQPHn0FuFKukBuUzRf+KVOkvwy+vo4F++EA2YuuBUGpWMgXUZS61+ZGxlekbRoh33HNpEucj6ME9SBcvtHwVvCOWESNLVI6FsrS3m0yFaKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716970707; c=relaxed/simple;
	bh=tdLgkL/G57QWDQYIQEXqBgxXMvBYXtk7Q684oBRA8MI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ugbyh68mXHuxBV8hxkdBS5ZvCghsYwLKRePW5G+DNUnjdyq8bkQnNGQgGTt+aY8o025F0tJDEaNQbakcaPeh9UoLwyHyrRm0CtzuTUR1slO/M1feKH5c1gHG6HtNDOntKSt4zDj7MtT8TOrt70tdEZDQe9dLVP7mnFqra8CHuD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LtR3Oh2a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LtR3Oh2a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 058B3C32786;
	Wed, 29 May 2024 08:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716970707;
	bh=tdLgkL/G57QWDQYIQEXqBgxXMvBYXtk7Q684oBRA8MI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=LtR3Oh2agCU9HURoDtBiUh7iTJLGV4B2vVD+qBUmDBqW0QyV3eFxvnbTWLYWNw50G
	 RB5F6E5jmfbwdx4YKjiEpROnk6sbnVvAIqXTJDWEejc7ZNcxGoEWiuHV14ngXeucKK
	 3MdK9HGPHlJYvUXI/8tUaQ0uLgAUaBXFpEhxviGN3usBWl1+GVSFyj7trFfsAdECb8
	 GTGIG7ne+XR/vEI89MNuxclVJdVem1+wTntjOmKx7Ai3Wvm2rt9icq/wfCzCOfhHWj
	 IZ28O7umJrgJMRyP+GPGCXscEvF3FCY+uz4C0cntcL17ACYS8VsyxIYO/y9XSQCsU4
	 hNmwuFFXE3C5w==
Message-ID: <633e78ae-eed4-4437-a6f7-e8c5e22756c8@kernel.org>
Date: Wed, 29 May 2024 17:18:23 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/12] sd: cleanup zoned queue limits initialization
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
 <20240529050507.1392041-9-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20240529050507.1392041-9-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/29/24 14:04, Christoph Hellwig wrote:
> Consolidate setting zone-related queue limits in sd_zbc_read_zones
> instead of splitting them between sd_zbc_revalidate_zones and
> sd_zbc_read_zones, and move the early_zone_information initialization
> in sd_zbc_read_zones above setting up the queue limits.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research


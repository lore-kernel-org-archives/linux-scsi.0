Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2F6F167264;
	Wed, 29 May 2024 08:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716970342; cv=none; b=EC1lUsI+mIs1PIqxrbMzk/Ts+etph5qhb6v8T7LFsjmNbETJ6aH1Aq/Vol7RthEgGwA0bLMpYtExS5LtlSEVb16EnujKNa4SKiW7RUTK8cn/vHWG+lgnuPcPzakDFAarlO4fartLjbKfjcmxrSQea0jv8KXbLlfIgFQIMuh50qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716970342; c=relaxed/simple;
	bh=6hbYxOsQLA742vo6TjIi/DCNFqZKNxvrO5GmFHCpV44=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lSi5YrSljbQ/aZnGTxGRZx5YexAJj79v0CUV/2f+ZAW97OIw6Qv6M7CbCMF6Cne9KHIDKmidc682Q4TDoulCxYN/diHBIQvVA/doUPjDW2rDKjhduqlJPcNE62hvDztC3lZX0DLq6Bf0cJUmQlG3/VbhKGN8q5Zc1gWoUDFrJJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R5mS/igR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R5mS/igR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7666DC32786;
	Wed, 29 May 2024 08:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716970341;
	bh=6hbYxOsQLA742vo6TjIi/DCNFqZKNxvrO5GmFHCpV44=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=R5mS/igRnNYSuaOU/WungJiFXByfPmU52aV3/8lDlnahx3fw8xYGEgm9I0GwjGMLI
	 rxgEHuZC8FN59Nts7D7mlYOVBxUtXbONIbSuFZA/nsChkRReh17QPPy3Nln5IcP01O
	 bsT5Xv1cO9MaQHL1Y0r23CFCdo5I/pmKCJKFQuVPp2FGd5eU3g8CUn1vaagml+SwH/
	 VFaQ6/MQ6XcCtKYl3ZsNtZ6oahfm06jpUk78jThj1RR2tPWitAJRbqdrAgZ8cH96NI
	 HA2Qjk0f15qnfydLy1JSV5a8XNMA+v8I41uKRHJ4B+z8Gf4xJOm2ZPo9UslIKFHhn/
	 xR//bL6vRZCpw==
Message-ID: <dd7a2835-8c38-4b52-aaea-f80064ccd22b@kernel.org>
Date: Wed, 29 May 2024 17:12:18 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/12] sd: add a sd_disable_write_same helper
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
 <20240529050507.1392041-6-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20240529050507.1392041-6-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/29/24 14:04, Christoph Hellwig wrote:
> Add helper to disable WRITE SAME when it is not supported and use it
> instead of sd_config_write_same in the I/O completion handler.  This
> avoids touching more fields than required in the I/O completion handler
> and  prepares for converting sd to use the atomic queue limits API.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 424C820B20;
	Wed,  8 Jan 2025 10:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736331674; cv=none; b=Hgn+Ec6xzkuv3g55bEKl+ZysWS9U6btF2XGv2J7VpkbiafO4J02AkC/CHEx10nwigHzozEWHs3NErdRNR/MmVlB5HNtbFYxnYr2FRZIZpY/K/nxGV30i86Ik7+94jH0tquSt3lKDduKsmBLyG7eP6qrHAvT5VmMvArQ0Scj/Nus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736331674; c=relaxed/simple;
	bh=JFHL9CU+SvxdU55U39KRsBzQCKSkGxUcXFDn7BoFcMY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MZhvhVh2Lgst054zpzDFmgHx3fTMKvF3Pcw/DvaU/+da7OvcjmFNyRmyYlNg1rZRvDJ8Ur2eGzev6eXSnz/IaEN2hWjo7GzEMyyIYxssLOPExFEonS6G8d0+uoZ3Hu2rPh1HTPrSK1S47+YQthvj/rfBHCDJ4MYXcFtCYPx/IVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nFYrl7fp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nFYrl7fp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAA48C4CEDF;
	Wed,  8 Jan 2025 10:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736331673;
	bh=JFHL9CU+SvxdU55U39KRsBzQCKSkGxUcXFDn7BoFcMY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=nFYrl7fp4fSPfIdVuMpJVBP6b3YldyaJpmtL8UGYeBOMd6X2fQZZKxcTko0MCHdEJ
	 jH+d4p+hrcpoLhM/023ELdse4fADysYzrU4Z1ABYpmpZi4cPVVGCnwlcjgpi+VvKJj
	 dxY8a/ceS4/CCMOQe2Z0kfi3cYBICxBW6R6rSgk7+6thjO0oVE0vCMDT4weAOb5gbw
	 PlnE5uQCecncE61izjeK/LRIhERUBfol6ssf6s3WOok59Uqvw/oQ6KSKZkaBmCHckz
	 c794gfsJc4uTMT+CqG5cQKseRKYv1Sfh7V3wFWlLsVnKTaew/CCMnZpmKNZicaqh4j
	 06hM49PLKaXRg==
Message-ID: <f3ca343b-0ff1-417b-b2ff-7ea166fb82b2@kernel.org>
Date: Wed, 8 Jan 2025 19:20:29 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/10] loop: fix queue freeze vs limits lock order
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Ming Lei <ming.lei@redhat.com>, Nilay Shroff <nilay@linux.ibm.com>,
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
 nbd@other.debian.org, linux-scsi@vger.kernel.org,
 usb-storage@lists.one-eyed-alien.net
References: <20250108092520.1325324-1-hch@lst.de>
 <20250108092520.1325324-11-hch@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20250108092520.1325324-11-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/8/25 6:25 PM, Christoph Hellwig wrote:
> Match the locking order used by the core block code by only freezing
> the queue after taking the limits lock using the
> queue_limits_commit_update_frozen helper and document the callers that
> do not freeze the queue at all.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research

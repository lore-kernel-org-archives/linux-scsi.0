Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62BF51E32DB;
	Tue,  7 Jan 2025 10:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736244029; cv=none; b=XUjZzyXTDqpPX03C2P4ssFBKBibhJIwryvUrkF1bnmR3E5lM8kjmNq+NWLEF7PCgA4h7bhhFM2VxHJ2No+XOJ49noLouDtDpEKhq0sjUo6osShlFmjaOoPUMTTa43ushHlLLjsBkTAcFcwlJEjCxgkn3yaqvuty4LY90X71mk+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736244029; c=relaxed/simple;
	bh=lqv2dPlcm26U+MhnC+L7UtWKIn/g+usaTKVohReAGkg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=k1w9lhAGH+wN0efssLURrlvLZfDrFiFz9SAk5X+j7w/5hpbmTicy6HNbw3YLpVrGFLIyBEr2aQq/geZfhibAz2fO8yLZTSe/s1aRExXe6fa4kubKn8gFQYJlPYFKJFDmT4tkvbuSIX+vxJ9Yn3cqGZWQiskn4x+Pv0PWB7BwLnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p2GYuq1v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p2GYuq1v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E30BC4CED6;
	Tue,  7 Jan 2025 10:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736244027;
	bh=lqv2dPlcm26U+MhnC+L7UtWKIn/g+usaTKVohReAGkg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=p2GYuq1vIzDhN7/wB2Kt1c6pdyVYofLr777705ynGJGNfbUCW9SrAdxP6RHps/AbE
	 9M0ln9Z4jvdNuZWck4sdsGiw5lapULOeoNpqn1ozha3AvmRCtlo+TE5B257a44K6aB
	 j/syb6Gi+5xuAkhzjkkblVdrVN+FCh7QUKpccpUn7lt31aeGBH7iAQ/Mj/1wmUThWI
	 OFG3kbx2mjeBg5xEZMOXzu0MYf738ERXUfP0XtfaD2jP/wYXKZc7RxfVkvoJQ2Kz6g
	 shVFdDwwdQyxjz13qMWGVMh49oi8HGNcp3CMHo0jwz/CRM7TnC1aGh/hyhYGGjF/bg
	 lplKfjA4e6LAA==
Message-ID: <f450d490-c820-47a4-8a29-316b6dab855c@kernel.org>
Date: Tue, 7 Jan 2025 19:00:25 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 8/8] usb-storage:fix queue freeze vs limits lock order
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Ming Lei <ming.lei@redhat.com>, Nilay Shroff <nilay@linux.ibm.com>,
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
 nbd@other.debian.org, linux-scsi@vger.kernel.org,
 usb-storage@lists.one-eyed-alien.net
References: <20250107063120.1011593-1-hch@lst.de>
 <20250107063120.1011593-9-hch@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20250107063120.1011593-9-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/7/25 15:30, Christoph Hellwig wrote:
> Match the locking order used by the core block code by only freezing
> the queue after taking the limits lock using the
> queue_limits_commit_update_frozen helper.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>


-- 
Damien Le Moal
Western Digital Research

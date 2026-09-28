Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 382CD43991C
	for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2026 06:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790576828; cv=none; b=gGsfs0PIe+bkECTg4OWVMhALdPL50pjVISY8sgq9slQGVOfRDFAZrkhtR2dkbG4uPpg1Z+JX0SAiHku7NZyzVmv+wOUVC+Ub/Mec1Y2gGe4ZjnGsa0ILarElCaos4VyXjl1Rsd94mMSGAGabDne/dhqLiutQiMxQCUFWhFcejBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790576828; c=relaxed/simple;
	bh=1vc0970Ot+tF4aGOPkXJrCMyMPdoh04GO8jZIvwhLNo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ri5CgJs3u5dtOrIob6Rdb/GvUXsgV7T/+lFe98Q3dU3tnguFVmbIMxCrFnTFYzJv9JPXyifmJa5kr4MRQmPSzLHcVvDk3HRh/AfM8aSfY+p5bJshGIXBB/+7AsDnVBzMXzdQeESxCYhWHNyzRMurzLfa1UgmMTSHsprS/fTwWPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a016nZMN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a016nZMN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC45C1F000FF;
	Mon, 28 Sep 2026 06:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790576826;
	bh=ACGpNSsWWUiFniA/yLA3lw402F8X6cINXHranH8j/vQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=a016nZMNUHl4DC77OLZYWbKuWv3WXiY22I93lG7DcPZl2IqsB8tTy6rx7dn7qS56w
	 5UrVcIgDeZwRPW0uIEnVecLzfOhJGII3X9QWvSiyZcQTXs4Aay3RCCxEvze8x1Hh/X
	 YyTSltIq5BkmmF212/2FnxQUg3jygxMLrbGJplTesC1iT/XBxbNp+krkNEmIK+VWbw
	 EQD8a5irXKdsCmCM5oeIp8y+84umpf6TNke2X/waKvg3+Jd4aIt4aS/YdE5c04y2YP
	 2Hzm0iERWEx9qZ/9O3iJkZZRMxjK4xumNuCR+YoHdt3Ell+CrVXh6rmanirtocSnR8
	 35dA7q5r2psnA==
Message-ID: <213e5ae6-82f4-42cf-85e8-66eee422ac99@kernel.org>
Date: Mon, 28 Sep 2026 08:27:03 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 20/54] scsi: csiostor: Pass the hw pointer directly to
 several functions
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>, John Garry <john.garry@linux.dev>,
 Hannes Reinecke <hare@kernel.org>, Kees Cook <kees@kernel.org>,
 Colin Ian King <colin.i.king@gmail.com>
References: <cover.1790360262.git.bvanassche@acm.org>
 <f6e8b86640799a70cfb161210048ca4570bad03d.1790360262.git.bvanassche@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <f6e8b86640799a70cfb161210048ca4570bad03d.1790360262.git.bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/09/25 20:25, Bart Van Assche wrote:
> Pass the struct csio_hw pointer directly to csio_scsi_cleanup_io_q(),
> csio_scsi_abort_io_q(), csio_scsim_cleanup_io(), and
> csio_scsim_cleanup_io_lnode() instead of passing the struct csio_scsim
> pointer. Update all callers and header declarations accordingly.
> 
> Prepare the csiostor driver for enabling compiler-based lock context
> analysis. No functionality has been changed.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research

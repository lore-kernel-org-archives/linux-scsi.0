Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DE0815383E;
	Tue, 19 Nov 2024 08:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732003305; cv=none; b=tlXIcJpp7z5dAXx9ZFt6COrrb38yORd1oFtJCJ/S/KkOfQ2G4ceM6+exRQaC0tEiRsme5a2d2clyeMAGHYlhib9TbYpdr7Ml6ndEVybloKAqErW0BpPUnm9jG023cINWzzPRZskeeP/KVU74ssCl8qSHAvlXCLzOsBeS+ovCkKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732003305; c=relaxed/simple;
	bh=ZUUNauj0C68Uxt6kBfuf5OP1sOOBI3twZoVs/zgf0V8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KDvAFkmRPvZ0UVjrJDVtsltQPOiMKf2BofKd198Eo0L96wU3Bz9CvFTTDBrA1VrqkTm+oeHMnqk1P+OaTMY0VVmyopZ/EWhqTbZIgReu8Coko659lGwLKGo9QLD6QtJTuFY+H3djx8I2/o9dVjmMggSi+D55hJRiVxMFyKDaDjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C32EXrgc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C32EXrgc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CA0DC4CECF;
	Tue, 19 Nov 2024 08:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732003305;
	bh=ZUUNauj0C68Uxt6kBfuf5OP1sOOBI3twZoVs/zgf0V8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=C32EXrgc0yGkOXsvsmXmYxTeSVkyuLlXW99/fn78HPjjgrYE33ffsQ2jvk1zNoOX8
	 HVVkPLI5FdYO1fstafpZYeIwhaHWXCnu3aERsyvZBbccvZzcbrejoNgE7Cx/GLUSWJ
	 UnO+esBpnaMFflP6U30qZsqW8JEkuMn48aoDy+6tcsdoy0of3B4JhaGZ+ttWbhuetr
	 HqE29ZyORZ3ujW/rRq4TCmTEXR51Ys3/ecGv/ak6sUdf+fBs0TVZ6OYpDhlJjEUYPh
	 3Ira6GoPWjxyNdAcgh5wbZfVGGC1KV0G65VBJo3f6rRbhu/1tvvKpmdcMMAkv4Xg/H
	 MbEztyNL4gLfw==
Message-ID: <95ab028e-6cf7-474e-aa33-37ab3bccd078@kernel.org>
Date: Tue, 19 Nov 2024 17:01:43 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 00/26] Improve write performance for zoned UFS devices
To: Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>, Jaegeuk Kim <jaegeuk@kernel.org>
References: <20241119002815.600608-1-bvanassche@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20241119002815.600608-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/19/24 09:27, Bart Van Assche wrote:
> Hi Damien and Christoph,
> 
> This patch series improves small write IOPS by a factor of four (+300%) for
> zoned UFS devices on my test setup with an UFSHCI 3.0 controller. Although
> you are probably busy because the merge window is open, please take a look
> at this patch series when you have the time. This patch series is organized
> as follows:
>  - Bug fixes for existing code at the start of the series.
>  - The write pipelining support implementation comes after the bug fixes.

Impressive improvements but the changes are rather invasive. Have you tried
simpler solution like forcing unplugging a zone write plug from the driver once
a command is passed to the driver and the driver did not reject it ? It seems
like this would make everything simpler on the block layer side. But I am not
sure if the performance gains would be the same.


-- 
Damien Le Moal
Western Digital Research

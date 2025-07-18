Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98A7422D9E9;
	Fri, 18 Jul 2025 07:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752824356; cv=none; b=PFoMNtZrKd7VK/uNnGX+1yVqKbEDWspZA/xOyER0KtYjGfqga6DBzXgNyHRKrZCAZsX0GDsRTu+YKqR3py+1yhjSS4Y93GdLYzfftpAxr/9tzaW/uqDh45odeUKzhM3bUrvcP2tfnzSo4n22Me70IWh2DO7Fl94Ux/eJ4NaJ19w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752824356; c=relaxed/simple;
	bh=PyDz5g8wBHRrjg2C8+mw8LkItjWRYCEWrUQxhkLOzrk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ntz+LeENwWXeJW2HX4Gdf03v+Sg185n9pl03OPtB9PNuTIQbb3ORL6bdCwrIa/9uwcbl0OdLMpe8O31JkYzOTnKmHb4CYZBo+Nup0yozY9wiPIUpzEr2ydm3RMukg2G++dkkL4pdP8vepdnzCYmZfBkD53JUGj45/pvWamny7xU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fzAJTDnD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fzAJTDnD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72875C4CEED;
	Fri, 18 Jul 2025 07:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752824356;
	bh=PyDz5g8wBHRrjg2C8+mw8LkItjWRYCEWrUQxhkLOzrk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=fzAJTDnDZJ9LKezj0wG8RhpoO0A06pAsaQS9oXWCztGedI+8Bj05evsx/YvKLsSXB
	 Kn27BeuRLB5KuToum2ZWzJ0TJ0tPNQOiL3A/TEldVOGXf1JmKWAmLXqx3XdlbM4c7G
	 uHY1g1AWNETWXqiH7/xxluFJWyzdNWBTLTTJ1KaPeDN7iVJ7410kcYz1vGoz2w2GbQ
	 NWkHrz5Jk6No/FbzDxBCaQfBBwrJW20nW/Gq8RVQzcbbctKrGO67N2IlYDpCM38L0Z
	 5icKP/CQTDX7ruysI01Fz8AcnHKcrik2eG/5bNFsSKHD4KUopTY3VKDavyNr3IRU/T
	 J3ZZPoWg4eKOg==
Message-ID: <ad7b1c95-2b60-4ffc-930f-555105798f4d@kernel.org>
Date: Fri, 18 Jul 2025 16:39:14 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v21 00/12] Improve write performance for zoned UFS devices
To: Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>
References: <20250717205808.3292926-1-bvanassche@acm.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20250717205808.3292926-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/18/25 05:57, Bart Van Assche wrote:
> Changes compared to v20:
>  - Converted a struct queue_limits member variable into a queue_limits feature
>    flag.
>  - Optimized performance of blk_mq_requeue_work().
>  - Instead of splitting blk_zone_wplug_bio_work(), introduce a loop in that
>    function.
>  - Reworked patch "blk-zoned: Support pipelining of zoned writes".
>  - Dropped the null_blk driver patch.

Why ? null_blk does not maintain submission order ?

-- 
Damien Le Moal
Western Digital Research

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FDFC34D382;
	Sat,  8 Nov 2025 01:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762565913; cv=none; b=dKNhjZLgzZMcfS6eljxRaJj+eGobrx/Sv00FRBb/DC2mcw43mD6oLVLBq9f0K9s6S3NgfQkRD7vTApSvR4CGrPLvpXdl3XcssgN0ga11zj6arsDkAh5okd72LOJAqVjhbrUfGL2/3jqeg6RQNaBj4EGCtpvj02IhcnForvGHRsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762565913; c=relaxed/simple;
	bh=zeOK1hMMZqhpO4M9Et9DVnmXPkmllRQczYXGh74bI5U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=l1pDlJWUjrU6JbHjc7GyTsZwlp/TtZ9qfgiO4mfYacY0bLeSUMoHAQuQcJtrJBNVGaPsq0pPZ6O1oIFT6K/a5O+8QJ5sHRgF7qtKqlWvD/IGq8ftWDhgYcRKklgTUUTHQoKAN/c3K70TOIrtzIwq1lf6Rt/nSf6n9bFrzaslrBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mdvxjU95; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mdvxjU95"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3542C4CEF7;
	Sat,  8 Nov 2025 01:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762565911;
	bh=zeOK1hMMZqhpO4M9Et9DVnmXPkmllRQczYXGh74bI5U=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=mdvxjU95Mb7GRfhcg634CJdkDZPRlvb0pYS2PTXklqm1AU5xFfg8jGMducBkd2wuL
	 iY1YP9dU258aF/UCJEETd+Vitw9xZHVCgUrabjdA3mWnDeqXe54j+lKqJ00QHv2Jsw
	 ef0r6DFV+VSp7gL641wI7orOsjGn4uSeD10VbMPPlYeYVl0r4EDTkMZqAViykJTo5V
	 Jr5bv3U2p1U6mdHLbJyqVuMv9WQdw1nDDCAP/U+Jh1MwxdftdbSAtWlZmn/lZygRA6
	 sBKBkNTSv347TEUvQyT5BP27/0uYygCD5K2ATklMKHlQOu5lWbGNWJobluASTLhk5+
	 r0b/9+ihE1sfg==
Message-ID: <a611f452-fd00-4352-a0d6-294e9ccdda72@kernel.org>
Date: Sat, 8 Nov 2025 10:38:30 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v26 08/17] blk-zoned: Move code from
 disk_zone_wplug_add_bio() into its caller
To: Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>
References: <20251107235310.2098676-1-bvanassche@acm.org>
 <20251107235310.2098676-9-bvanassche@acm.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20251107235310.2098676-9-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/8/25 08:53, Bart Van Assche wrote:
> Move the following code into the only caller of disk_zone_wplug_add_bio():
>  - The code for clearing the REQ_NOWAIT flag.
>  - The code that sets the BLK_ZONE_WPLUG_PLUGGED flag.
>  - The disk_zone_wplug_schedule_bio_work() call.
> 
> No functionality has been changed.
> 
> This patch prepares for zoned write pipelining by removing the code from
> disk_zone_wplug_add_bio() that does not apply to all zoned write pipelining
> bio processing cases.
> 
> Cc: Damien Le Moal <dlemoal@kernel.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

This patch squashed with 07/17 could go in now, regardless of this series.


-- 
Damien Le Moal
Western Digital Research

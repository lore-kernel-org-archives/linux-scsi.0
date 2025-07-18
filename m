Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BC45212B2B;
	Fri, 18 Jul 2025 07:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752822540; cv=none; b=puZs7pRTZ5ZfJtZOsYMF3DKLqxm4kNer9wYg5KdJJJy7XJCOk6KBbdHMB3XFbuE7u2LDAuQKBvwovtuHKMbP/I265SsHq9o8EwYjxwBb2qLx2X/aJZvmTCWguVbZKZvWHXiJ1pIrpdp3QOHo06CiUCv00E+1KsenzC0Iawn3Ah4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752822540; c=relaxed/simple;
	bh=P4RnAEIIIMu/njAnr9AUZT2k06uRIJi+wXv5jTmxBxs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AEArMonaZJAxZZJUxbw/Ag6JfZ7J+2rKRPffxhK73Lt5ahrLdq+Pgud/hETr3bA4ww8rqXky37HJ2WT+Ox52YzHRcEZSJXVhdt0/PdqWQ0p1X2jXmExvLIYao/zCWbjBOUuHnLZJIvL3B2nabvfyRx9b8DSRng6nhhJBPWLbuHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Eq0XAQiC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Eq0XAQiC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CC7AC4CEED;
	Fri, 18 Jul 2025 07:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752822539;
	bh=P4RnAEIIIMu/njAnr9AUZT2k06uRIJi+wXv5jTmxBxs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Eq0XAQiCMos72PYRBTarzxWo90Tt/8gP5vQYEqt7v0BNhLLENfAn/c4GjpRCTQDKB
	 TED7gc5o3YJ6rd7FQRyiaEVqtaU7bo77EM1bDSdZ4Zx/0O+LpfjQqpBnlchkdM6wSW
	 bMeyaiv9V//hlURMnKwncd35ML29Kh9z+wPyeaOaK9pF2VP+0p6Tq9rzIIiUbmzQx0
	 PgEkscrR0qbE0X/cm5Lnz7xf8jVmn9koLqh8/Qwtbzp53gqbbK+cfcfeLtFdPNbocL
	 ZC6e8PRneKD9HzFuZCNzC07VCekxDe2DV+qPIBpVjTuNm9SFaHBgRFMLpJv7KARfRw
	 Ncly7Bsbgz7Qg==
Message-ID: <f1b3060c-f951-4184-886c-87ba812986a7@kernel.org>
Date: Fri, 18 Jul 2025 16:08:57 +0900
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
> Hi Jens,
> 
> This patch series improves small write IOPS by a factor of two for zoned UFS
> devices on my test setup. The changes included in this patch series are as
> follows:
>  - A new request queue limits flag is introduced that allows block drivers to
>    declare whether or not the request order is preserved per hardware queue.
>  - The order of zoned writes is preserved in the block layer by submitting all
>    zoned writes from the same CPU core as long as any zoned writes are pending.
>  - A new member 'from_cpu' is introduced in the per-zone data structure
>    'blk_zone_wplug' to track from which CPU to submit zoned writes. This data
>    member is reset to -1 after all pending zoned writes for a zone have
>    completed.
>  - The retry count for zoned writes is increased in the SCSI core to deal with
>    reordering caused by unit attention conditions or the SCSI error handler.
>  - New functionality is added in the scsi_debug driver to make it easier to
>    test the changes introduced by this patch series.
> 
> Please consider this patch series for the next merge window.

Bart,

How did you test this ?

I do not have a zoned UFS drive, so I used an NVMe ZNS drive, which should be
fine since the commands in the submission queues of a PCI controller are always
handled in order. So I added:

diff --git a/drivers/nvme/host/zns.c b/drivers/nvme/host/zns.c
index cce4c5b55aa9..36d16b8d3f37 100644
--- a/drivers/nvme/host/zns.c
+++ b/drivers/nvme/host/zns.c
@@ -108,7 +108,7 @@ int nvme_query_zone_info(struct nvme_ns *ns, unsigned lbaf,
 void nvme_update_zone_info(struct nvme_ns *ns, struct queue_limits *lim,
                struct nvme_zone_info *zi)
 {
-       lim->features |= BLK_FEAT_ZONED;
+       lim->features |= BLK_FEAT_ZONED | BLK_FEAT_ORDERED_HWQ;
        lim->max_open_zones = zi->max_open_zones;
        lim->max_active_zones = zi->max_active_zones;
        lim->max_hw_zone_append_sectors = ns->ctrl->max_zone_append;

And ran this:

fio --name=test --filename=/dev/nvme1n2 --ioengine=io_uring --iodepth=128 \
	--direct=1 --bs=4096 --zonemode=zbd --rw=randwrite \
	--numjobs=1

And I get unaligned write errors 100% of the time. Looking at your patches
again, you are not handling REQ_NOWAIT case in blk_zone_wplug_handle_write(). If
you get REQ_NOWAIT BIO, which io_uring will issue, the code goes directly to
plugging the BIO, thus bypassing your from_cpu handling.

But the same fio command with libaio (no REQ_NOWAIT in that case) also fails.

I have not looked further into it yet.

-- 
Damien Le Moal
Western Digital Research

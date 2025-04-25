Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF02DA29;
	Fri, 25 Apr 2025 01:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745545368; cv=none; b=Q0pVcsS2oe4nj8vUISfqE4H6gykq2w4uJ9hswte+9uUiIPXS6zqrkED4FzW6f3KBlvQ8IdBSHQXWlBUx8fNgMvL5lPudjqf2nzDDgM5LXu3djakapl0Dfm/kmUtA2v7ww/6yvmi8kk5JqhLY9eNRx46FEo1RhvQeHeyXydPVKWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745545368; c=relaxed/simple;
	bh=0sf7RbNI11kGFaqtAzN6Qtqmzsf5nd2hTi/RJ907nHU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ichz6CmHLvy1RYh/hIxpGiPsn9VGs6dN2smiRWMhBv7spTNR8JShsHTlTP8v8wXMlq/mNuVvoApJmiyw2n7IQoKB/uakaunfDkrJWE6wVRCZ8LWZZPAvUBnHMkS/2NVNLVCfA8DoXcAnae2+80BZn1uEaUsgizHf0E8W0CWVco8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i0bYvJCo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i0bYvJCo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23B4FC4CEE3;
	Fri, 25 Apr 2025 01:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745545368;
	bh=0sf7RbNI11kGFaqtAzN6Qtqmzsf5nd2hTi/RJ907nHU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=i0bYvJCoHPXvm7Ls19ntQEpIG0+ZnCz/E0WmE8x83YRjFnsA9PA7VCmNUevj4MYZA
	 43+8B+bTTaZ2F2CWl72MHfx5KeQngYEzMPvnAuNqWI6+Y+8fVXE5/3WSidoXOwBYnN
	 l1Ov4swcvxY8RT0ZLrOzhTWA0aspyIgjctxmbHtDaf9+aoYH3ur6zqwqssGqAqdBDd
	 htzforAIcxEtC72ZEwZ1P9Lf/G1FNQ5q9v7/P1hNKWREHR/B92zGvdCZ53Sjb1pskf
	 1Ex/AtaloR1qc/d5PqdWDBSHzX/XpL2la8L6HVeFHL0sHxzPoSN1hQ6+SXpVw85bsR
	 H1BCweJPgdPfQ==
Message-ID: <ff2ba1e1-a7bd-49b7-a1f2-e51f5cfed27a@kernel.org>
Date: Fri, 25 Apr 2025 10:42:46 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: sd_zbc: Limit the report zones buffer size to
 UIO_MAXIOV
To: "Siwinski, Steve" <ssiwinski@atto.com>,
 Christoph Hellwig <hch@infradead.org>
Cc: bgrove@atto.com, James.Bottomley@hansenpartnership.com,
 linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com, Steve Siwinski <stevensiwinski@gmail.com>
References: <20250411203600.84477-1-ssiwinski@atto.com>
 <Z_yinytV0e_BbNrF@infradead.org>
 <OFA5AB0241.ED5C089D-ON85258C70.0068BDE0-85258C70.00721A7A@atto.com>
 <8454a55d-bfcc-441a-837e-157123e881fe@kernel.org>
 <05faf356-0bc7-4fdf-8a74-f738365fad20@atto.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <05faf356-0bc7-4fdf-8a74-f738365fad20@atto.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/25/25 00:33, Siwinski, Steve wrote:
> My issue is not with passthough report zones.
> 
> The report zones command is failing on driver load and causing the drive 
> to fail to appear as a block device. If queue_max_segments is set to a 
> value over 1024, then nr_vecs in bio_alloc() will be greater than 
> UIO_MAXIOV and bio_alloc() will return NULL.

OK... A remainder about the path:

sd_zbc_do_report_zones() -> scsi_execute_cmd() -> blk_rq_map_kern() ->
bio_map_kern() -> bio_kmalloc()

and the fact that bio_kmalloc() does not allow more than UIO_MAXIOV segments
would have made things clear from the beginning. I had to look it up again to
understand why UIO_MAXIOV matters.

> This causes the error.
> ```
> sd 8:0:0:0: [sdb] REPORT ZONES start lba 0 failed
> sd 8:0:0:0: [sdb] REPORT ZONES: Result: hostbyte=0xff driverbyte=DRIVER_OK
> sdb: failed to revalidate zones
> ```
> 
> You can reproduce this by setting the max_sgl_entries parameter to 2k or 
> greater in the mpt3sas driver. Other drivers can also reproduce this 
> behavior.

Well, I think that the problem you uncovered here is a lot more fundamental than
just ZBC report zones. If the drive has a queue_max_segments() value larger than
UIO_MAXIOV, any attempt to map a large buffer for any command (e.g. a read) will
also fail. So this limit inconsistency seems wrong...

Christoph ? Since you were touching the vmalloc-ed BIO mapping code, do you have
any idea about this ? The quick and dirty fix would be to do:

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 7a447ff600d2..3cb897b25878 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -169,6 +169,7 @@ static void *sd_zbc_alloc_report_buffer(struct scsi_disk *sdkp,
                                        unsigned int nr_zones, size_t *buflen)
 {
        struct request_queue *q = sdkp->disk->queue;
+       size_t max_segs;
        size_t bufsize;
        void *buf;

@@ -185,7 +186,8 @@ static void *sd_zbc_alloc_report_buffer(struct scsi_disk *sdkp,
        bufsize = roundup((nr_zones + 1) * 64, SECTOR_SIZE);
        bufsize = min_t(size_t, bufsize,
                        queue_max_hw_sectors(q) << SECTOR_SHIFT);
-       bufsize = min_t(size_t, bufsize, queue_max_segments(q) << PAGE_SHIFT);
+       max_segs = min(queue_max_segments(q), UIO_MAXIOV);
+       bufsize = min_t(size_t, bufsize, max_segs << PAGE_SHIFT);

        while (bufsize >= SECTOR_SIZE) {
                buf = kvzalloc(bufsize, GFP_KERNEL | __GFP_NORETRY);


But that feels wrong...

-- 
Damien Le Moal
Western Digital Research

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 458A4175A7B;
	Fri, 10 Jul 2026 00:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783645118; cv=none; b=tLDnk9oRl+tPwz/dfpN1onorB9wwPCvOhNW6bEr1jHV50YOPEW28u+KWsLy9+I6e/tDW19SHRdcJIVzs0p9JMP4lU18v1c+6hCccw6jL0XWUpIPaUzGJjmlqfCFkomj6iNyzgmJ2XinP0iJZBjqpk4y8BMUru5hZjBJQ4kJL4Tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783645118; c=relaxed/simple;
	bh=kX8HnrLPuF/RCDXTRd7lEJw6/ycqb6qFRjd3WukkzUo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=svMB9DpDBiiVtk9dQLzuKZk7F/4UM7/Wq8zM7GesZNJz9yE1c1tRqniwz0bEPr/WRqaizz6ybyU1O7VBBboU9pBVx/Lem1j86FzPmRmo3OpT7CIxwO2pkFNYFbJgeCOG8h5MYdYJdSzLoPnvJcqE/oO8/I996055sW4HhGYulmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h5jYR1h1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h5jYR1h1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E38811F000E9;
	Fri, 10 Jul 2026 00:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783645116;
	bh=M49Rsdk+yKBoXWSlkIuoNcmpgwLg1lupYccK7/fLgMY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=h5jYR1h1gsFprBQZ9hN1al2nZnNWZVK9hWfd+sfpX3V1O825c3ob1NyvhlOOFKs9C
	 eXJVkSffXNTWhjaCwCk6mzy7zWW30iwwM8I7xUqhCEp9jYXja3d2wIpE1/DS+yQCCj
	 KoYQfniiTzsGht+34bmmfMy5Zfct7hMeBS/0x7hcdFrcFHDV+twqraJ7BKMvNWB1Xm
	 XvS5AgEHu/976Rd/gUa4XHDT5RGIUgQ5OmhBHGDqe9xtVwU4E5WfzMGlLXq3ZfJQrE
	 XdTJCZdVm1n/u0EYVM1s5VAc9ZYcQzQtdJVwZgaHHhZr/CDY1qF1R5EqyvrIWzC6Dk
	 FSKJfU3GL139A==
Message-ID: <1357dbf9-e135-4ba3-896d-1472a208f82f@kernel.org>
Date: Fri, 10 Jul 2026 09:58:22 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: scsi_debug: fix REPORT ZONES alloc_len underflow
 OOB write
To: Ibrahim Hashimov <security@auditcode.ai>, martin.petersen@oracle.com,
 James.Bottomley@HansenPartnership.com
Cc: shinichiro.kawasaki@wdc.com, damien.lemoal@opensource.wdc.com,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20260709150631.45018-1-security@auditcode.ai>
 <20260709194824.50777-1-security@auditcode.ai>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260709194824.50777-1-security@auditcode.ai>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/07/10 4:48, Ibrahim Hashimov wrote:
> resp_report_zones() reads the REPORT ZONES(16) ALLOCATION LENGTH field
> (cmd[10..13]) into the unsigned alloc_len and, apart from the
> alloc_len == 0 fast path, uses it without flooring it against the
> 64-byte report header:
> 
> 	rep_max_zones = (alloc_len - 64) >> ilog2(RZONES_DESC_HD);
> 	arr = kzalloc(alloc_len, GFP_ATOMIC | __GFP_NOWARN);
> 	...
> 	desc = arr + 64;
> 
> For any alloc_len in the range 1..63, alloc_len - 64 wraps around
> (alloc_len and rep_max_zones are unsigned), so rep_max_zones becomes a
> huge value instead of zero. At the same time arr is allocated with the
> raw alloc_len, which is smaller than the 64-byte header the function
> always builds, and desc is set to arr + 64, already past the end of the
> allocation. The report header stores (put_unaligned_be32 at arr+0,
> put_unaligned_be64 at arr+8 and arr+16) can then run past a sub-24-byte
> buffer, and the per-zone descriptor loop, no longer bounded by the
> inflated rep_max_zones, writes 64-byte descriptors from desc onward,
> producing a slab out-of-bounds write.
> 
> Fix it the way ZBC and SPC require: allocation length truncation is not
> an error, and a small alloc_len is a legitimate probe a host uses to
> read the zone list length before allocating a full buffer. Clamp
> rep_max_zones to zero when alloc_len is below the header size so no
> descriptor is emitted, and size the allocation to at least the header
> so the unconditional 64-byte header build cannot overflow. The existing
> copy-out already truncates the result with
> fill_from_dev_buffer(scp, arr, min_t(u32, alloc_len, rep_len)), so the
> host still receives exactly the alloc_len bytes it asked for. There is
> no functional change for alloc_len >= 64.
> 
> This supersedes the previous approach of rejecting a sub-header
> allocation length with a check condition, which would have broken those
> legitimate small-alloc_len probes.
> 
> Verified on a v6.19 KASAN build: with scsi_debug loaded as
> zbc=host-managed, issuing REPORT ZONES(16) via SG_IO with alloc_len=32
> triggers a KASAN slab-out-of-bounds write in resp_report_zones()
> before this change, and the same command produces no report once the
> clamp and allocation floor are applied. Reproduction requires
> CAP_SYS_RAWIO to submit the raw CDB.
> 
> Fixes: 7db0e0c8190a ("scsi: scsi_debug: Fix buffer size of REPORT ZONES command")
> Cc: stable@vger.kernel.org
> Signed-off-by: Ibrahim Hashimov <security@auditcode.ai>
> Assisted-by: AuditCode-AI:2026.07
> ---
> v2: address sashiko-bot review of v1
> (https://lore.kernel.org/linux-scsi/20260709150631.45018-1-security@auditcode.ai/):
> rejecting a sub-header allocation length with a check condition violates the
> ZBC/SPC rule that allocation-length truncation is not an error and breaks
> legitimate small-alloc_len zone-list-length probes. Instead clamp rep_max_zones
> to zero and floor the allocation at the 64-byte header, letting the existing
> min(alloc_len, rep_len) copy-out return the truncated header. No functional
> change for alloc_len >= 64.
>  drivers/scsi/scsi_debug.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 9d1c9c41d0f9..a21d76fe35f6 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -5911,9 +5911,11 @@ static int resp_report_zones(struct scsi_cmnd *scp,
>  		return check_condition_result;
>  	}
>  
> -	rep_max_zones = (alloc_len - 64) >> ilog2(RZONES_DESC_HD);
> +	rep_max_zones = (alloc_len < RZONES_DESC_HD) ? 0 :
> +			(alloc_len - RZONES_DESC_HD) >> ilog2(RZONES_DESC_HD);

Please expend this using an actual if:

	if (alloc_len < RZONES_DESC_HD)
		rep_max_zones = 0;
	else
		rep_max_zones =
			(alloc_len - RZONES_DESC_HD) >> ilog2(RZONES_DESC_HD);

>  
> -	arr = kzalloc(alloc_len, GFP_ATOMIC | __GFP_NOWARN);
> +	arr = kzalloc(max_t(u32, alloc_len, RZONES_DESC_HD),
> +		      GFP_ATOMIC | __GFP_NOWARN);

Yes, but this only partly address the issue. E.g. if the command has an
allocation length of 64+32, rep_max_zones will incorrectly be 0, leaving the 32B
after the header unfilled. Sure, that is a "useless" case since no one wants a
partial zone descriptor. But the SCSI specs allow this, so let's do it correctly.

I have a patch in my local queue that I was about to send to fix this, but you
where faster :) What I did is:

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 4a95e6bae38b..96a5a0af4564 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -5842,6 +5842,7 @@ static int resp_report_zones(struct scsi_cmnd *scp,
        unsigned int rep_max_zones, nrz = 0;
        int ret = 0;
        u32 alloc_len, rep_opts, rep_len;
+       u64 arr_len;
        bool partial;
        u64 lba, zs_lba;
        u8 *arr = NULL, *desc;
@@ -5865,9 +5866,11 @@ static int resp_report_zones(struct scsi_cmnd *scp,
                return check_condition_result;
        }

-       rep_max_zones = (alloc_len - 64) >> ilog2(RZONES_DESC_HD);
+       rep_max_zones =
+               (ALIGN(alloc_len, RZONES_DESC_HD) - RZONES_DESC_HD) >>
+		ilog2(RZONES_DESC_HD);
+       arr_len = RZONES_DESC_HD * (rep_max_zones + 1);

-       arr = kzalloc(alloc_len, GFP_ATOMIC | __GFP_NOWARN);
+       arr = kzalloc(arr_len, GFP_ATOMIC | __GFP_NOWARN);
        if (!arr) {
                mk_sense_buffer(scp, ILLEGAL_REQUEST, INSUFF_RES_ASC,
                                INSUFF_RES_ASCQ);

With that, the buffer arr is always big enough to generate a correct report with
no overflows, but at the end, we only transfer alloc_len, which may be less than
arr_len.


-- 
Damien Le Moal
Western Digital Research

Received: from mta0.migadu.com (out-67.mta0.migadu.com [91.218.175.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D6A8255F2D
	for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2026 07:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789716070; cv=none; b=F9xM6YC86X+HeeiDwjy+0ueALo0nv3xaNxu+hlT/ek67t4VVvaOGknw7f0RkRE6CWS3dQz+tCqoXD/COvvc2K8C9q35CWl3zb/e/5RhZ8I4Ktl/KEKXTEtb2iPHnT+Jr79ur9eLbF+X0DrYvKpkYT9U9N2X9Fi2Cigz0NYWUHsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789716070; c=relaxed/simple;
	bh=NwlwwzFL76DRJQz+DCrZH40xeXNPA9XtJ9Cyrca0bLY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eMIxyaOt5vkESwP/Z8rxQ6tw3bZvX3ptf2SonkATNi0ZjyNuo5ufEMVnnKQK631WY3D0Wism3rduUE8lTU01elI8zMuBlIKWRhQjjd5Ks/IqTiSIrHl/V5ubcDJpW999FMfW3yE1FGTPCzWxE70ZO0oCSC4fuxT1zhFxkS18Wvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GryEmTav; arc=none smtp.client-ip=91.218.175.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GryEmTav"
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=NwlwwzFL76DRJQz+DCrZH40xeXNPA9XtJ9Cyrca0bLY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789716066; v=1; x=1790320866;
 b=GryEmTavoDQyZrdRXzpuJ/nm2YhIr95V2s/X5MYmhaP3EJ7zkcCZ1tqXMzH4nxE+SUKP9uWj
 N+Z8cdxzms65VdRI82SQPOHyydmTdvR1yDOePibEcDJAawnwMMteYsG3uCiWR17spPraTMzd300
 mYjZ7upgWCT4/Eq8TaHQSVLQ=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta11.migadu.com with ESMTPS id 1288202be22fd169;
	Fri, 18 Sep 2026 07:21:06 +0000
X-Mizu-Trace-ID: 1288202be22fd169
X-Migadu-Flow: FLOW_OUT
Message-ID: <f2f03175-63a2-4077-8c11-970dad2896de@linux.dev>
Date: Fri, 18 Sep 2026 08:21:00 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 02/10] scsi: scsi_debug: Make atomic writes and ZBC
 emulation mutually exclusive
To: Niklas Cassel <cassel@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org, Damien Le Moal <dlemoal@kernel.org>
References: <20260918062910.1709791-12-cassel@kernel.org>
 <20260918062910.1709791-14-cassel@kernel.org>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <20260918062910.1709791-14-cassel@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/18/26 07:29, Niklas Cassel wrote:
> There are no SMR drives that support atomic writes. Emulating a device
> that supports both is emulating something that a user cannot encounter,
> rather than the drives that exist, and it means maintaining the zone
> handling of a command that no zoned device implements.
> 
> Nothing in the standards forbids the combination. For what would be by
> far the most common case, a host managed SMR drive whose logical block
> size equals its physical block size, there is no problem in the two
> features being combined: the drive vendor only has to give atomic
> writes an alignment that makes sense with regards to ZBC, for instance
> equal to the physical block size. This is therefore a choice not to
> complicate scsi_debug, rather than a restriction that the standards
> impose.
> 
> Refuse the combination at initialisation. If SMR drives that support
> atomic writes ever become a thing, this can be changed back.
> 
> Suggested-by: Damien Le Moal <dlemoal@kernel.org>
> Assisted-by: LLM
> Signed-off-by: Niklas Cassel <cassel@kernel.org>

Reviewed-by: John Garry <john.garry@linux.dev>

> ---
> Tested by loading the module with each combination:
> 
>    zbc=managed atomic_wr=1    refused, -EINVAL
>    zbc=aware   atomic_wr=1    refused, -EINVAL
>    zbc=managed                loads
>    atomic_wr=1                loads
> ---
>   drivers/scsi/scsi_debug.c | 5 +++++
>   1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index c664966e95cb..8e45a57ae406 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -8739,6 +8739,11 @@ static int __init scsi_debug_init(void)
>   		return -EINVAL;
>   	}
>   
> +	if (sdeb_zbc_in_use && sdebug_atomic_wr) {
> +		pr_err("atomic_wr is not supported by a zoned device\n");
> +		return -EINVAL;
> +	}
> +
>   	if (sdebug_dev_size_mb == DEF_DEV_SIZE_PRE_INIT)
>   		sdebug_dev_size_mb = DEF_DEV_SIZE_MB;
>   	if (sdebug_dev_size_mb < 1)


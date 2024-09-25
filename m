Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A5717C6C;
	Wed, 25 Sep 2024 16:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727282049; cv=none; b=ruOdN5DauLln5uxNtF7g1a5l6fEuNVmLQp0087ewdTOouxHQLxsNeys8lGE1Ip++S83sDiLj2OT34kfgHnhtw7+khKH+QJxMBUjDn/609jx0HavA4ecffWTwHax5t0uSow/VvoqqmqfeeHQI6VHvGIYrcs1NGXGJbSQrXn3bJ+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727282049; c=relaxed/simple;
	bh=cuLHVkDzKjoEHhogUbpQZo71rZ7nSas3O2rhEfclQHA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XUzZeH8ekoKRO8L6JzanqWoagkaWj6V+tFYIsdGNME3eg4100hTT68NWKg5761ivf9PklhbasoPjo1jo34XEf6kq/vWS4TH/nRJwS0JydRrvirmS9dh9tN44F6CIAarNDMn1DCytHHwKGRpiZSOhBJRWzKZD92WrHCaz0nRniC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=DOp8J+7c; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="DOp8J+7c"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4XDMkR3MFXz6ClY98;
	Wed, 25 Sep 2024 16:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1727282043; x=1729874044; bh=/FyXFs10MLjrqvHD+X2ddLPl
	nu+sUJLNIwL7ZV9g+ds=; b=DOp8J+7cAsp/Tz33eG8p/X5L0yEHSriZC9a2JBFi
	ZuZJPCYIzcMyC2Cn3OSEhOtSPETKDRFa09ChFdJHDXQPq8Vzpgkg4DrUfV5HaCH+
	t6nm+SMwqZJcw85cT5LSh6AocrfmhUuK76mrK9kwq2OIy1bWzSkw6tF5bCiuVN2R
	ef7yKCeMbjZTL/kxX1r1C6UKM+XGnyMX5mJ/2VDPTrSKXODwCHBne9y07/NoGana
	8LXwoeFwUrHmbBOA3eA03eUam9LZ3VTldoDtdRB4M7GyavPr7G3vU9joihjzxQTl
	T+1m/tG4ZFjQ3PQ7cbvB1JXBp3exgH5LmI4QSVkMXcbPCA==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id i2J2OkpuoVyI; Wed, 25 Sep 2024 16:34:03 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4XDMkL38Tyz6ClY9N;
	Wed, 25 Sep 2024 16:34:02 +0000 (UTC)
Message-ID: <7c760b76-aba1-4e30-8966-17ae81a7e223@acm.org>
Date: Wed, 25 Sep 2024 09:34:00 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi:ufs:core: Add trace READ(16)/WRITE(16) commands
To: liuderong@oppo.com, alim.akhtar@samsung.com, avri.altman@wdc.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 Jaegeuk Kim <jaegeuk@kernel.org>
References: <1727232523-188866-1-git-send-email-liuderong@oppo.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <1727232523-188866-1-git-send-email-liuderong@oppo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/24/24 7:48 PM, liuderong@oppo.com wrote:
> From: liuderong <liuderong@oppo.com>
> 
> For sd_zbc_read_zones, READ(16)/WRITE(16) are mandatory for ZBC disks.
> Currently, when printing the trace:ufshcd_command on zone UFS devices,
> the LBA and SIZE fields appear invalid,
> making it difficult to trace commands.
> So add trace READ(16)/WRITE(16) commands for zone ufs device.
> 
> Trace sample:
> ufshcd_command: send_req: 1d84000.ufshc: tag: 31, DB: 0x0,
> size: -1, IS: 0, LBA: 0, opcode: 0x8a (WRITE_16), group_id: 0x0, hwq_id: 7
> ufshcd_command: complete_rsp: 1d84000.ufshc: tag: 31, DB: 0x0,
> size: -1, IS: 0, LBA: 0, opcode: 0x8a (WRITE_16), group_id: 0x0, hwq_id: 7
> 
> Signed-off-by: liuderong <liuderong@oppo.com>
> ---
>   drivers/ufs/core/ufshcd.c | 8 ++++++--
>   1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 5e3c67e..9e5e903 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -434,15 +434,19 @@ static void ufshcd_add_command_trace(struct ufs_hba *hba, unsigned int tag,
>   
>   	opcode = cmd->cmnd[0];
>   
> -	if (opcode == READ_10 || opcode == WRITE_10) {
> +	if (opcode == READ_10 || opcode == READ_16 ||
> +		opcode == WRITE_10 || opcode == WRITE_16) {
>   		/*
> -		 * Currently we only fully trace read(10) and write(10) commands
> +		 * Currently we only fully trace the following commands,
> +		 * read(10),read(16),write(10), and write(16)
>   		 */
>   		transfer_len =
>   		       be32_to_cpu(lrbp->ucd_req_ptr->sc.exp_data_transfer_len);
>   		lba = scsi_get_lba(cmd);
>   		if (opcode == WRITE_10)
>   			group_id = lrbp->cmd->cmnd[6];
> +		if (opcode == WRITE_16)
> +			group_id = lrbp->cmd->cmnd[14];
>   	} else if (opcode == UNMAP) {
>   		/*
>   		 * The number of Bytes to be unmapped beginning with the lba.

To me the above patch looks like a subset of this patch from 1.5y ago:
https://lore.kernel.org/linux-scsi/20230215190448.1687786-1-jaegeuk@kernel.org/

Bart.

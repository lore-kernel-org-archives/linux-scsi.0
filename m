Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAF2C10F9;
	Tue,  2 Jul 2024 03:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719891061; cv=none; b=R4y8bot31dduCou4rNVxsosC9RGlraqfe21UsaSrKWSBIUVumwskNsm8xNg6nvDSFu+GYfs2gzpi3OItxkMNWbJEkYPo/HogqvjWqMrzGnGfsdkGBAleEHx/XfMY6uy4EXJabxwzz5FyWD/+8wm+7D5rmPOGTcKKBdxTWsQx7Ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719891061; c=relaxed/simple;
	bh=gTuhRnzycDrX3ztlznec6pPw0hdjvQ5QSUvoaeUPKCM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PupJs/CsvPl1JOfpxwBt9kkYlldsu+V5Xqoz5JpanrYTqXS+1jtUc1MqCOa6iZZ0+XKy/uSxuwpdS8G2QptJwWqEE06Ol6F8pbD5C3OciQilLemiyeCEoXqg6guQ2gY6eN5H/1tgMG+cCCd0l4ktHxVaqCZzFni8v+lVLlPZE1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UDZxqUte; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UDZxqUte"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83CA1C116B1;
	Tue,  2 Jul 2024 03:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719891060;
	bh=gTuhRnzycDrX3ztlznec6pPw0hdjvQ5QSUvoaeUPKCM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=UDZxqUteofBKpyEogoxBH/mcplk1TTIF/vFG5ckX2FQP1BalFMg/nr9hgP/5nVYqZ
	 czil/wvfD3G0yftxmJ6+ywle2C3/QGTvlQPWGZCAMQ/xK5H3tZssyUou4GdYfRLDLm
	 q3OgW2Y+jzu/PMNiE9mHDAP3KYWPTSvgaDq/W7F8NbNz4IkQXgVGW9BQ7wXiMs7kou
	 J2YG/JNIwsdVI/bfTJYNSXvGodhck13TWhp3ZmPlF6U4Y7nZMiWdShbzVxNlYoTD56
	 LVtvH7v6rz+Yt41hxu1B54+2M6EO3E1DVfpxuegmds9vQisPIpBXJy1HAdFrCwwgaF
	 78iPTBbHQCOTA==
Message-ID: <469c4c38-ee78-4782-a58c-0e6f6c1faedc@kernel.org>
Date: Tue, 2 Jul 2024 12:30:58 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] scsi: sd: remove scsi_disk field lbpvpd
To: Haoqian He <haoqian.he@smartx.com>, Christoph Hellwig
 <hch@infradead.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 open list <linux-kernel@vger.kernel.org>,
 "open list:SCSI SUBSYSTEM" <linux-scsi@vger.kernel.org>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: fengli@smartx.com
References: <20240702030118.2198570-1-haoqian.he@smartx.com>
 <20240702030118.2198570-3-haoqian.he@smartx.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20240702030118.2198570-3-haoqian.he@smartx.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/2/24 12:01, Haoqian He wrote:
> The lbpme bit in scsi_disk can be used directly to indicate
> if the logical unit supports logical block provisioning
> management. The lbpvpd bit is no longer needed, so remove
> this field from scsi_disk.
> 
> Signed-off-by: Haoqian He <haoqian.he@smartx.com>
> Signed-off-by: Li Feng <fengli@smartx.com>
> ---
>  drivers/scsi/sd.c | 8 ++++----
>  drivers/scsi/sd.h | 1 -
>  2 files changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 44a19945b5b6..b49bab1d8610 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -3306,8 +3306,10 @@ static void sd_read_app_tag_own(struct scsi_disk *sdkp, unsigned char *buffer)
>  
>  static unsigned int sd_discard_mode(struct scsi_disk *sdkp)
>  {
> -	if (!sdkp->lbpvpd)
> -		/* Disable discard if LBP VPD page not provided */
> +	if (!sdkp->lbpme)
> +		/* LBPME was not set means the logical unit
> +		 * is fully provisioned, so disable discard.
> +		 */

Incorrect multi-line comment format. Please start the comment with a "/*" line
and no text. It may also be a good idea to add curly brackets for this if as it
is multi line (but single statement). Or move the comment before the if.

>  		return SD_LBP_DISABLE;
>  
>  	/* LBP VPD page tells us what to use */
> @@ -3430,7 +3432,6 @@ static void sd_read_block_provisioning(struct scsi_disk *sdkp)
>  	struct scsi_vpd *vpd;
>  
>  	if (!sdkp->lbpme) {
> -		sdkp->lbpvpd    = 0;
>  		sdkp->lbpu      = 0;
>  		sdkp->lbpws     = 0;
>  		sdkp->lbpws10   = 0;
> @@ -3445,7 +3446,6 @@ static void sd_read_block_provisioning(struct scsi_disk *sdkp)
>  		return;
>  	}
>  
> -	sdkp->lbpvpd	= 1;
>  	sdkp->lbpu	= (vpd->data[5] >> 7) & 1; /* UNMAP */
>  	sdkp->lbpws	= (vpd->data[5] >> 6) & 1; /* WRITE SAME(16) w/ UNMAP */
>  	sdkp->lbpws10	= (vpd->data[5] >> 5) & 1; /* WRITE SAME(10) w/ UNMAP */
> diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
> index 36382eca941c..ff9ff2655c25 100644
> --- a/drivers/scsi/sd.h
> +++ b/drivers/scsi/sd.h
> @@ -146,7 +146,6 @@ struct scsi_disk {
>  	unsigned	lbpu : 1;
>  	unsigned	lbpws : 1;
>  	unsigned	lbpws10 : 1;
> -	unsigned	lbpvpd : 1;
>  	unsigned	ws10 : 1;
>  	unsigned	ws16 : 1;
>  	unsigned	rc_basis: 2;

-- 
Damien Le Moal
Western Digital Research


Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7FE0251791;
	Tue, 19 Aug 2025 19:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755631456; cv=none; b=X1AWk8vQCBKQVhY6cjF8AhkIfP0G6Bp56uXwjefcfBOz80ntzXSssby5g77sqAucVPSOYIDL65Han6OnnGl9L86pdR/uohpOac4syww3d/M7GkJcwwpfzLgZC50ffj1r7TVcy4louAfNFjMWA6GqhIGOkZjuzST+hEsOWCu82qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755631456; c=relaxed/simple;
	bh=Kxk1SDXB4fcFxhnjAKyRZ327I1ep83bHuDQJt+yn524=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KzmAIKqCkUG1AYqT6+dYyKS//r8m7k6b4lbnbqiyOhQNVdPn3C0xWU6Zz3lY2esvdK19GBGo45H0IYGMiQ5/6HBXo4IkmqZnieyPw2wJC9sKB9nW+xil1dbmQsAwTgbKTqifEVaNfjxO9bZL/MM8pI1rya3ZUAmZEUpnoXiElyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=cuWiSMf3; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="cuWiSMf3"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4c5zzD0m6szlgqTq;
	Tue, 19 Aug 2025 19:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1755631446; x=1758223447; bh=EU3Zi4nQIaGbmWLkC6ovV3mr
	gMR8t0MyBZgCiRfHoHg=; b=cuWiSMf3OimQ3ID6rYE56z0RnY845ulQfsMb1494
	r7rvdzHVn93DOGlf3khWR2Ls1tU1lu8LSp5Obz3DWesEJHlLLAxH3AGi8xfKuUvi
	+UM34lQN+ra/vYOvvHeuNVSUh5cHUeEeUi+SEPoEydrF6mnhVcupNdr9PG9aOxXL
	kvFKavex9lar4GldVsrlemdTdW6wewk4QdD7G64ZlhRRPL3IVjj01LTOuYHdAwnJ
	NElM42bELyreGSkd39FpBj2rWxt+9flbSGVbh3myGMrq9RRMHFlJh4PKyTGMGN5E
	1BKbzw8Jh6sHd9pv9glnz0gkxPQjzl7kkpY9CrFtfPDTNQ==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id E0mLRd72z9jW; Tue, 19 Aug 2025 19:24:06 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4c5zz74z5vzlgqVY;
	Tue, 19 Aug 2025 19:24:02 +0000 (UTC)
Message-ID: <e5186da6-e621-457a-ba7a-316e5eb5d161@acm.org>
Date: Tue, 19 Aug 2025 12:24:01 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 2/2] scsi: sd: make sd_revalidate_disk() return void
To: Abinash Singh <abinashsinghlalotra@gmail.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250816205329.404116-1-abinashsinghlalotra@gmail.com>
 <20250816205329.404116-3-abinashsinghlalotra@gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250816205329.404116-3-abinashsinghlalotra@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/16/25 1:53 PM, Abinash Singh wrote:
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index c3791746806d..ba3bfd9b00aa 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -106,7 +106,7 @@ static void sd_config_discard(struct scsi_disk *sdkp, struct queue_limits *lim,
>   		unsigned int mode);
>   static void sd_config_write_same(struct scsi_disk *sdkp,
>   		struct queue_limits *lim);
> -static int  sd_revalidate_disk(struct gendisk *);
> +static void  sd_revalidate_disk(struct gendisk *);
>   static void sd_unlock_native_capacity(struct gendisk *disk);
>   static void sd_shutdown(struct device *);
>   static void scsi_disk_release(struct device *cdev);
> @@ -3691,7 +3691,7 @@ static void sd_read_block_zero(struct scsi_disk *sdkp)
>    *	performs disk spin up, read_capacity, etc.
>    *	@disk: struct gendisk we care about
>    **/
> -static int sd_revalidate_disk(struct gendisk *disk)
> +static void sd_revalidate_disk(struct gendisk *disk)
>   {
>   	struct scsi_disk *sdkp = scsi_disk(disk);
>   	struct scsi_device *sdp = sdkp->device;
> @@ -3709,13 +3709,13 @@ static int sd_revalidate_disk(struct gendisk *disk)
>   	 * of the other niceties.
>   	 */
>   	if (!scsi_device_online(sdp))
> -		goto out;
> +		return;
>   
>   	lim = kmalloc(sizeof(*lim), GFP_KERNEL);
>   	if (!lim) {
>   		sd_printk(KERN_WARNING, sdkp,
>   			"sd_revalidate_disk: Disk limit allocation failure.\n");
> -		goto out;
> +		return;
>   	}
>   
>   	buffer = kmalloc(SD_BUF_SIZE, GFP_KERNEL);
> @@ -3829,7 +3829,6 @@ static int sd_revalidate_disk(struct gendisk *disk)
>   	kfree(lim);
>   	kfree(buffer);
>   
> -	return err;
>   }

Shouldn't this patch remove the initializer from the 'err' variable?
Otherwise this patch looks good to me.

Bart.

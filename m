Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B29AE4C637;
	Mon, 25 Mar 2024 19:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711396563; cv=none; b=kaZORheVtAW1bf5/HN7/6p6lWMudVe30Qilr3P0/9A/HxnLB5UgIJohgfdq7uMc4Eo2Mt/0Z6WCRGE0HzZtf6ro6ZrBnu6SqlV6xttym00zHGbE1Jrt+iGxaSe7lxxoJ29e458nAd//DxqISAusezI8RdAB8gA0L2hUJcNNs58Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711396563; c=relaxed/simple;
	bh=ueJbC8IxL2dBPH2NNtc6xDJ5SqSI/4eoJjnKWHwEXY4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=s42lB3gmu/uzt5dxLAzA+NTsjUXryqN8LrFChbS9KIgwBa2AvsnaoU8KNXCvyswwUhGjAvnOEQQZD/5ULnHvY/21bPBVN1m6Ii8kBnknHaG0kPx29ibxK+zEeA9a0eLnqW+qFpXQanUj7/pprwNbJOKjZRZUovlSFw0lW1R94iI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=tZFpFWPm; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="tZFpFWPm"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4V3NwK1Hhdz6Cnk9N;
	Mon, 25 Mar 2024 19:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:references:content-language:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1711396558; x=1713988559; bh=OMJepmD1LuGKVJmqK/LqtBV9
	dMOWcM8bDgmCSeTKYy0=; b=tZFpFWPmPsUU8ZKGBf0iw1T1rhxCE6y/pshQ5cI6
	1JJOanyjOhhdOZRjQ1hL9cYoNnAMeFiMKXZZWk0HwAmL8BE2Gr1zLhIzWrWMx4SK
	+m7MCyXLlyPA1RwDRoS+bVJ2rUws4uYkE1pLcRLmmH01P3AEXO+oDVTQZbBM2ZVB
	YPx2oFc3ewNpmxBIwzUNnFsbPfAaWmxb+GTcJG5C+rVFgjoV8DAzvVwjLQ6XXXyW
	M07gx0nsX0Dm3OXwiZ6fmt0QMtx2zBNcv3n+TFUIaCUfWGxIFhWqxZ4mBVTjb82w
	/VYh2mfP6DlQxAAigA/GLoyAmsUkMXamMR/gVc1z7ZG5rg==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id thV5ewaziJC7; Mon, 25 Mar 2024 19:55:58 +0000 (UTC)
Received: from [100.96.154.173] (unknown [104.132.1.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4V3NwF46mkz6Cnk9M;
	Mon, 25 Mar 2024 19:55:57 +0000 (UTC)
Message-ID: <4a8620df-eaf3-4fe5-ba1b-4579e81de2ef@acm.org>
Date: Mon, 25 Mar 2024 12:55:56 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 04/28] block: Introduce bio_straddle_zones() and
 bio_offset_from_zone_start()
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
References: <20240325044452.3125418-1-dlemoal@kernel.org>
 <20240325044452.3125418-5-dlemoal@kernel.org>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240325044452.3125418-5-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/24/24 21:44, Damien Le Moal wrote:
> +static inline bool bio_straddle_zones(struct bio *bio)
> +{
> +	return bio_sectors(bio) &&
> +		bio_zone_no(bio) !=
> +		disk_zone_no(bio->bi_bdev->bd_disk, bio_end_sector(bio) - 1);
> +}

Please rename bio_straddle_zones() into bio_straddles_zones()
(grammar).

Thanks,

Bart.

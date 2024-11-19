Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F91E1482E8;
	Tue, 19 Nov 2024 07:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732003088; cv=none; b=WjPjWRJqAvnOtcuMmbzMzHXF7xZrpkTqV//4JIttvXYCEiwxBo36gzzvx07Fgvh2pz1VA9grWXkhQTqHUYPMeEsku+d3q7URktF2I3nvlIwjVRjW3dbaM/G23JRDUIHaqaMjjhlBufZVL3BbgNBnJiiGyWpWu2zHqunYKYkFi5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732003088; c=relaxed/simple;
	bh=l3u30BnlrxmXDuy49dyNSMmEdwl8ZgM++OlPO33Q+g8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cobzvafac2q4Z269h47aSVYCJp0LfEbJCc4Mkz5yickQa+y09pksD/AaojlbEYFt0T3wLvo/wKnSibz+dwAUlZp9IL9qYV7yS9PWic7EzLPWfWFpYN+zwAEL5BU1Xsvb5X3OMgxYnUWR+HhTPtBjPMqf+2dMmfB+mBxOfApcwWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YzN5r5HR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YzN5r5HR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0A6FC4CECF;
	Tue, 19 Nov 2024 07:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732003087;
	bh=l3u30BnlrxmXDuy49dyNSMmEdwl8ZgM++OlPO33Q+g8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=YzN5r5HRDNPGe/kc3KGgNDQ14qCc7faKsAFvKk5gffek8sH0DKcUE/+FERUm5keZn
	 YMW0s99rYmNjA4ueEuD4G5YOie5uj+q+WuokhrIzwuh55r5J7jPMz+8cTQMs7UxRAI
	 SJef8z7U7pcqUQGBJ2N6kB8Z3yQc+eno5hXk5Ix4aeTeqrLsG47cKaWgXKCv9YaDUp
	 AVTbVjTkiGsl6HYN5aptLUh/WNKYWIx0XKzd2m3fwwZART3t4CZoXPuHsln2iwPiBG
	 RXD5likoYn5UdauY/cmbPiYsU/W+2zyxrlVH9xFXQtLvwiBZ4gaLlWofPjZPD8iXU3
	 B8OiNC22T1zBg==
Message-ID: <b9eabe3f-12f3-418f-a07b-3a7089f98524@kernel.org>
Date: Tue, 19 Nov 2024 16:58:05 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 18/26] blk-zoned: Make disk_should_remove_zone_wplug()
 more robust
To: Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>, Jaegeuk Kim <jaegeuk@kernel.org>
References: <20241119002815.600608-1-bvanassche@acm.org>
 <20241119002815.600608-19-bvanassche@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20241119002815.600608-19-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/19/24 09:28, Bart Van Assche wrote:
> Make the disk_should_remove_zone_wplug() behavior independent of the
> number of zwplug references held by the caller.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  block/blk-zoned.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/block/blk-zoned.c b/block/blk-zoned.c
> index 2b4783026450..59f6559b94da 100644
> --- a/block/blk-zoned.c
> +++ b/block/blk-zoned.c
> @@ -457,12 +457,9 @@ static inline bool disk_should_remove_zone_wplug(struct gendisk *disk,
>  	 * blk_zone_write_plug_finish_request() (e.g. with split BIOs
>  	 * that are chained). In such case, disk_zone_wplug_unplug_bio()
>  	 * should not attempt to remove the zone write plug until all BIO
> -	 * completions are seen. Check by looking at the zone write plug
> -	 * reference count, which is 2 when the plug is unused (one reference
> -	 * taken when the plug was allocated and another reference taken by the
> -	 * caller context).
> +	 * completions are seen.
>  	 */
> -	if (refcount_read(&zwplug->ref) > 2)
> +	if (zwplug->wp_offset != zwplug->wp_offset_compl)

See my comment in patch 5 about wp_offset_compl. I do not think it works.


>  		return false;
>  
>  	/* We can remove zone write plugs for zones that are empty or full. */


-- 
Damien Le Moal
Western Digital Research

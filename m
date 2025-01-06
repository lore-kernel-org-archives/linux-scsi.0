Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6E4F1DB36B;
	Mon,  6 Jan 2025 10:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736160136; cv=none; b=Gt4iQLvx9+nTtxBUHT/DHgWKtHjQUW1rYjRDsi65gF33RfIgOlSyfGWXnNlbeQRysfKSZLByWBsEoMpozlnlqUZljVe7lk0eS3pdgJILgihrWoY+MS7nq+X+91sAP9vEDA0dLOhUGn116n/wGIlavn4IzYmWOurGVicCV4gnr8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736160136; c=relaxed/simple;
	bh=euhWvUhz5CciYJh8Yuw2cExBVHc9+EtlTZ1pgZbX7Ho=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OW6i2Ci3Yfknq42qNUXOuL0OljLelD6X0FW6U0Z4JRvpMYd1CSc+v9ahznPXhtxK2wY+Yf4W1bHVNoc6rfH1P6DwUZwvK3frK3hKMA+6Ul5YjD+vtkwUR7BWv55H+T9abbtdxlG4tlsbec4wIkBxsZv53+RM6ULiYIbauIbk+mE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hUODWLJY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hUODWLJY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B58D2C4CEE0;
	Mon,  6 Jan 2025 10:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736160135;
	bh=euhWvUhz5CciYJh8Yuw2cExBVHc9+EtlTZ1pgZbX7Ho=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=hUODWLJYC9lAQuwth5KQ9f/9n4JkccHviDS4BUW+GVnYUc95BTbiEfTLJTO2cSnhI
	 RoGLBLJs/jDMAKfkGSoG8fMvgAx1f+wf/EoLVq5jlCe5Aj3acYnWwRbQGefxm3Mk9y
	 Se7gjWn7ohH1ELKxO/yfEDpwedIExf6+QWU+QcTdeme4+2Syu5DERgr2CZJUWfbOaT
	 u1/Kl9WCgzP0ekKNfmY2vOBe+7Xpneq1f8fTkpfwoym9kbHfUXAwDhUN3RpSPjKDxE
	 Lq4zljlYQUJJRYaE589asV0Y2gFz7Ho5fL+S9ICfeYhrdshKYQIWtuuwVkio2eASNk
	 oPa63ka2qmKYg==
Message-ID: <c760f509-8902-429c-bf1b-526b1043c483@kernel.org>
Date: Mon, 6 Jan 2025 19:41:29 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/10] block: add a queue_limits_commit_update_frozen
 helper
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Ming Lei <ming.lei@redhat.com>, Nilay Shroff <nilay@linux.ibm.com>,
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
 nbd@other.debian.org, virtualization@lists.linux.dev,
 linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
References: <20250106100645.850445-1-hch@lst.de>
 <20250106100645.850445-3-hch@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20250106100645.850445-3-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/6/25 7:06 PM, Christoph Hellwig wrote:
> Add a helper that freezes the queue, updates the queue limits and
> unfreezes the queue and convert all open coded versions of that to the
> new helper.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

[...]

> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> index 71a7ffeafb32..0a987f195630 100644
> --- a/drivers/block/virtio_blk.c
> +++ b/drivers/block/virtio_blk.c
> @@ -1105,9 +1105,7 @@ cache_type_store(struct device *dev, struct device_attribute *attr,
>  		lim.features |= BLK_FEAT_WRITE_CACHE;
>  	else
>  		lim.features &= ~BLK_FEAT_WRITE_CACHE;
> -	blk_mq_freeze_queue(disk->queue);
>  	i = queue_limits_commit_update(disk->queue, &lim);

You need to change this line to use queue_limits_commit_update_frozen().

Other than that, looks good !

-- 
Damien Le Moal
Western Digital Research

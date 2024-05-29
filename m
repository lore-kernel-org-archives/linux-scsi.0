Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFD14DDA1;
	Wed, 29 May 2024 20:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717012943; cv=none; b=Vz0E4M6/L3xKhPvjDZXZY/q9/L+qNd0qH14jpvkfUisiTRrm0VKFJTB90qJq7Tlmeb2BzAbPyVm35OtZ9eqJmF0jV/v3LAWqBx5FhGdSdxcanI4NZslUpkYJkGV8aTQ29tiJrubcBgfYRlqC45jvqLZJVqSGT2p5UDwLhQo4kv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717012943; c=relaxed/simple;
	bh=uoeP/ZwWetQAmYm+NWLIZq1WWa6NvZlKRvH5A7Q7LnM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NMDuZe73dj+0r2O9Ci5qEv3GEiApnKsKDRX88grWCTtpw4bYqlEJnX8nYEmo8DRh62/c3UtVqPYjG9Wj8d9ZzgFOvp6VNHa+20NsfKDDri3Ur+VxwLfKhUeyoOEEgIkaS4coZHso7L+GMgSmiXnp48hofM9yQu5PZnXQJiPqEJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=lWKJhAAF; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="lWKJhAAF"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4VqKzW3g9Bz6Cnk98;
	Wed, 29 May 2024 20:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1717012933; x=1719604934; bh=BsBWx6rt7XKTmBO9OqYrip5a
	lx7g+yyYVBrkP5DYA/c=; b=lWKJhAAFnD4regaOzBo2CMF3nCGaj6EdqB7E9ApF
	2gc01eXOjhGjZyl97mxzl2+ym7amJo87E7tN0XhzSX6n13fwuF1DCfOBvd+X0aMY
	t5f3GYJsTYnHBEI1m5N6DU2opnKZ4/Nw+cuxZe3+nzbr0POj3Ob8eEEDe/EtWLtB
	314xdPe0iOKLbSk0sWQiWbZkccn8Db33m5CmKclAG8iyvE4LN9OSLjVHb6JaN9wF
	fI7FkQjOAxta3uwEvhcIon5awyek5ZLnijvO+hYatg6FB2IhnQyuOgNSf2YsD1SP
	oscToafrbu0ME58DjBJRjEIqfZlsFjYjil8mRb/W41LWyw==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 2k_xyZiv_lwt; Wed, 29 May 2024 20:02:13 +0000 (UTC)
Received: from [100.96.154.26] (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4VqKzR4Tl5z6Cnk97;
	Wed, 29 May 2024 20:02:11 +0000 (UTC)
Message-ID: <4251566e-0a1a-48f1-b170-d5987bbabd90@acm.org>
Date: Wed, 29 May 2024 13:02:09 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 3/3] scsi: ufs: sysfs: Make max_number_of_rtt
 read-write
To: Avri Altman <avri.altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Bean Huo <beanhuo@micron.com>, Peter Wang <peter.wang@mediatek.com>,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240526081636.2064-1-avri.altman@wdc.com>
 <20240526081636.2064-4-avri.altman@wdc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240526081636.2064-4-avri.altman@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/26/24 01:16, Avri Altman wrote:
> +static inline void ufshcd_freez_hw_queues(struct ufs_hba *hba)
> +{
> +	struct scsi_device *sdev;
> +
> +	shost_for_each_device(sdev, hba->host) {
> +		if (sdev == hba->ufs_device_wlun)
> +			continue;
> +		blk_mq_freeze_queue(sdev->request_queue);
> +		blk_mq_quiesce_queue(sdev->request_queue);
> +	}
> +}
> +
> +static inline void ufshcd_unfreez_hw_queues(struct ufs_hba *hba)
> +{
> +	struct scsi_device *sdev;
> +
> +	shost_for_each_device(sdev, hba->host) {
> +		if (sdev == hba->ufs_device_wlun)
> +			continue;
> +		blk_mq_unquiesce_queue(sdev->request_queue);
> +		blk_mq_unfreeze_queue(sdev->request_queue);
> +	}
> +}

Why have these functions been declared inline? blk_mq_freeze_queue()
may sleep and hence performance is not an argument to inline these
functions. Additionally, the WLUN should not be skipped when freezing
or unfreezing request queues. The blk_mq_quiesce_queue() and
blk_mq_unquiesce_queue() calls are not necessary in the above code.
Please remove these.

Thanks,

Bart.

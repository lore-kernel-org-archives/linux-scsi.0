Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FF9712A172;
	Mon, 25 Mar 2024 07:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711352332; cv=none; b=lH/0cnq1C/fK1BemCdvpE4oyr03HkLRHLbwT9j3tpWmGCN8LtnY7tiXsPFvZRvkNJ66Prt5ZSVu5Gf+zicjIuV+nsmVDiNfKrud5KHSeNBlL9ctGcvMsWTAF1vJJiIdPKELCGFAfCVwh8XIIoMhDukot74UOgMLREulKQSgeCo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711352332; c=relaxed/simple;
	bh=GggQfJqWGV/Ctp7o7AkWVGsFya1/ymUgBfTjhhsT0r8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=id8oyF8+EeP4aH9NHbBxgwASLv1Bl82IJmGdUHjTeuGVzsfsPXAyH8MySa1VjWwqjYlkuLpleyqmZgQIgQB74sH2V7jrJNUM3B/AZSmZhVt2pNRi8AZ4SEshNglNkgJ7C9zJyQBqlQeqmFe01Q3ULowy7+EAgRapxwdcF+0+uiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lwMMElU2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lwMMElU2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C484C433C7;
	Mon, 25 Mar 2024 07:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711352331;
	bh=GggQfJqWGV/Ctp7o7AkWVGsFya1/ymUgBfTjhhsT0r8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=lwMMElU28H9qxNX5S/CYy53BwULqnlTsVNm1C0ApIvl31LhkamaFy5z33+qhzA+5d
	 CXbKAqbXYEr3jW9JjVYDKU6UQ2h3CvMRJsCJupqswWYKxGp33kSg8DStl5a4Yxjxhl
	 yx0LBuJOfEIdO/DliKKH6kEeqBwr2I0iwlcc4bYrnN9QsVTUkazWuY4qKSZslvYLD5
	 Ki/RIu2PZPB0d/FAuN2Hdwu5B31UFLEnYfMqFvnkTqX6S78Q+TvZNk0W0bvuvDZWs1
	 Ptr2G8/fYJSlbc1ZkgsM329JWqSdL+IgnE9b7TJwM9IJyrkSlNNVhPVSbid/+7Rjmv
	 uCbbaAFD9b5MQ==
Message-ID: <6199c70e-f0a9-4756-b3fb-106985c41ebf@kernel.org>
Date: Mon, 25 Mar 2024 16:38:43 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/23] scsi: add a device_configure method to the host
 template
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Niklas Cassel <cassel@kernel.org>,
 Takashi Sakamoto <o-takashi@sakamocchi.jp>,
 Sathya Prakash <sathya.prakash@broadcom.com>,
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
 Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
 "Juergen E. Fischer" <fischer@norbit.de>,
 Xiang Chen <chenxiang66@hisilicon.com>,
 HighPoint Linux Team <linux@highpoint-tech.com>,
 Tyrel Datwyler <tyreld@linux.ibm.com>, Brian King <brking@us.ibm.com>,
 Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
 Mike Christie <michael.christie@oracle.com>,
 John Garry <john.g.garry@oracle.com>, Jason Yan <yanaijie@huawei.com>,
 Kashyap Desai <kashyap.desai@broadcom.com>,
 Sumit Saxena <sumit.saxena@broadcom.com>,
 Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
 Chandrakanth patil <chandrakanth.patil@broadcom.com>,
 Jack Wang <jinpu.wang@cloud.ionos.com>, Nilesh Javali <njavali@marvell.com>,
 GR-QLogic-Storage-Upstream@marvell.com,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
 Bart Van Assche <bvanassche@acm.org>,
 Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
 Alan Stern <stern@rowland.harvard.edu>, linux-block@vger.kernel.org,
 linux-ide@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
 MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
 open-iscsi@googlegroups.com, megaraidlinux.pdl@broadcom.com,
 mpi3mr-linuxdrv.pdl@broadcom.com, linux-samsung-soc@vger.kernel.org,
 linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
References: <20240324235448.2039074-1-hch@lst.de>
 <20240324235448.2039074-11-hch@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20240324235448.2039074-11-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/25/24 08:54, Christoph Hellwig wrote:
> This is a version of ->slave_configure that also takes a queue_limits
> structure that the caller applies, and thus allows drivers to reconfigure
> the queue using the atomic queue limits API.
> 
> In the long run it should also replace ->slave_configure entirely as
> there is no need to have two different methods here, and the slave
> name in addition to being politically charged also has no basis in
> the SCSI standards or the kernel code.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/scsi_scan.c | 33 +++++++++++++++++++--------------
>  include/scsi/scsi_host.h |  4 ++++
>  2 files changed, 23 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 699356d7d17545..8e05780f802523 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -227,7 +227,7 @@ static int scsi_realloc_sdev_budget_map(struct scsi_device *sdev,
>  
>  	/*
>  	 * realloc if new shift is calculated, which is caused by setting
> -	 * up one new default queue depth after calling ->slave_configure
> +	 * up one new default queue depth after calling ->device_configure
>  	 */
>  	if (!need_alloc && new_shift != sdev->budget_map.shift)
>  		need_alloc = need_free = true;
> @@ -874,8 +874,9 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
>  static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
>  		blist_flags_t *bflags, int async)
>  {
> +	const struct scsi_host_template *hostt = sdev->host->hostt;
>  	struct queue_limits lim;
> -	int ret;
> +	int ret, ret2;
>  
>  	/*
>  	 * XXX do not save the inquiry, since it can change underneath us,
> @@ -1073,22 +1074,26 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
>  		lim.max_hw_sectors = 512;
>  	else if (*bflags & BLIST_MAX_1024)
>  		lim.max_hw_sectors = 1024;
> -	ret = queue_limits_commit_update(sdev->request_queue, &lim);
> +
> +	if (hostt->device_configure)
> +		ret = hostt->device_configure(sdev, &lim);
> +	else if (hostt->slave_configure)
> +		ret = hostt->slave_configure(sdev);
> +
> +	ret2 = queue_limits_commit_update(sdev->request_queue, &lim);

Why do this if ->device_configure() or ->slave_configure() failed ?
Shouldn't the "if (ret) goto fail" hunk be moved above this call ?

> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> index b0948ab69e0fa6..1959193d47e7f5 100644
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -211,7 +211,11 @@ struct scsi_host_template {
>  	 *     up after yourself before returning non-0
>  	 *
>  	 * Status: OPTIONAL
> +	 *
> +	 * Note: slave_configure is the legacy version, use device_configure for
> +	 * all new code.

Maybe explictly mention that both *cannot* be defined here ?

>  	 */
> +	int (* device_configure)(struct scsi_device *, struct queue_limits *lim);
>  	int (* slave_configure)(struct scsi_device *);
>  
>  	/*

With these 2 nits addressed, looks all goo to me. Feel free to add:

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research


Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E25B182AE;
	Fri,  5 Apr 2024 06:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712299360; cv=none; b=XTuvIjJA4erKUseIHOEFTA7G7V7r1kdvztCQ1FaVbNH+dHvSLuwD+wncQC6sUgfJMsd3XbaOag0jpWCo5LfbkrdBwMD6JBcE1e2FG+UVH68hbF7e0cQWYWji9KR3TQR4Uu2wDDb14vXrT5E4FrUA+RR55aGVeHm30OP3qiYE/W4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712299360; c=relaxed/simple;
	bh=0rwm07wQC+cv++Uk73vwWN7bYSat4x06PgfWQ0XVscM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BYfmrhW6CVVWYOwCSMGn1AW0rlfhR9n5TLQwYNpHjy6FmqyDZz1+s1icIJk6gbIhgOmrVB5drStwNX2KG3nN6fdan4xMfUzJkgqBroDKarmGeypNSMkh8Es6y/bL8siB0tjateKD/EaJsUA1RPeSY14i6W2RPpcxJeg6E5zW+CQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6740B68D07; Fri,  5 Apr 2024 08:42:33 +0200 (CEST)
Date: Fri, 5 Apr 2024 08:42:33 +0200
From: Christoph Hellwig <hch@lst.de>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	"Juergen E. Fischer" <fischer@norbit.de>,
	Xiang Chen <chenxiang66@hisilicon.com>,
	HighPoint Linux Team <linux@highpoint-tech.com>,
	Tyrel Datwyler <tyreld@linux.ibm.com>,
	Brian King <brking@us.ibm.com>, Lee Duncan <lduncan@suse.com>,
	Chris Leech <cleech@redhat.com>,
	Mike Christie <michael.christie@oracle.com>,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	Chandrakanth patil <chandrakanth.patil@broadcom.com>,
	Jack Wang <jinpu.wang@cloud.ionos.com>,
	Nilesh Javali <njavali@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Alan Stern <stern@rowland.harvard.edu>, linux-block@vger.kernel.org,
	linux-ide@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
	MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
	megaraidlinux.pdl@broadcom.com, mpi3mr-linuxdrv.pdl@broadcom.com,
	linux-samsung-soc@vger.kernel.org, linux-usb@vger.kernel.org,
	usb-storage@lists.one-eyed-alien.net
Subject: Re: [PATCH 03/23] mpi3mr: pass queue_limits to bsg_setup_queue
Message-ID: <20240405064233.GD3480@lst.de>
References: <20240402130645.653507-1-hch@lst.de> <20240402130645.653507-4-hch@lst.de> <8011f224-04f2-40b6-84ad-fc0fb3d10b16@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8011f224-04f2-40b6-84ad-fc0fb3d10b16@acm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Apr 04, 2024 at 09:55:13AM -0700, Bart Van Assche wrote:
> On 4/2/24 06:06, Christoph Hellwig wrote:
>> diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
>> index ce5445eb9d0e4e..05e061fc6d3a06 100644
>> --- a/drivers/scsi/mpi3mr/mpi3mr_app.c
>> +++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
>> @@ -1838,6 +1838,10 @@ void mpi3mr_bsg_init(struct mpi3mr_ioc *mrioc)
>>   {
>>   	struct device *bsg_dev = &mrioc->bsg_dev;
>>   	struct device *parent = &mrioc->shost->shost_gendev;
>> +	struct queue_limits lim = {
>> +		.max_hw_sectors		= MPI3MR_MAX_APP_XFER_SECTORS,
>> +		.max_segments		= MPI3MR_MAX_APP_XFER_SEGMENTS,
>> +	};
>
> Can 'lim' be declared 'static const'?

It can't because the queue limit validation can modify it (and thus
none of the pointers in the chain leading to it are marked const)


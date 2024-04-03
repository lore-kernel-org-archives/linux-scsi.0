Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78580146D41;
	Wed,  3 Apr 2024 12:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712148944; cv=none; b=OQCQcaSLxmLsTkSm3dsoSNFyvAtmObkqGY96LOuIqDuv8kgJQ3gCHsZY5v4UVUy4oKlPFUGAz+446+FQW29Qx2zjMmEUrYCVebq7NcEnCOPDvYrx1PIEoJg2ieoJ1fe5CmYxm3bG+eLjesAlgdyaSmotF1lFN2mLhaot+cmQVkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712148944; c=relaxed/simple;
	bh=kLg5w+VhnMZXw4r2H5fTrv+slAsLxDCRcGAC3HKHuaA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wwv66IqElOrgKjPOaYiwXCWuEKKI3GajvYmQx/A/2hN60z5JQ5tPDDvcFYlSU0Jn9mRkLe1GBORxLFzeZ/0NXwJLdo9bdAyDB05CoKQ40DlERb1+yoWbO1/0L8H0hXsbRhlxTt/jAN0StT5RNB1ALPKFDbEO+tYwvAdZUiEX15E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 965EC68D05; Wed,  3 Apr 2024 14:55:35 +0200 (CEST)
Date: Wed, 3 Apr 2024 14:55:35 +0200
From: Christoph Hellwig <hch@lst.de>
To: Hannes Reinecke <hare@suse.de>
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
	Bart Van Assche <bvanassche@acm.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Alan Stern <stern@rowland.harvard.edu>, linux-block@vger.kernel.org,
	linux-ide@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
	MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
	megaraidlinux.pdl@broadcom.com, mpi3mr-linuxdrv.pdl@broadcom.com,
	linux-samsung-soc@vger.kernel.org, linux-usb@vger.kernel.org,
	usb-storage@lists.one-eyed-alien.net
Subject: Re: [PATCH 11/23] megaraid_sas: switch to using ->device_configure
Message-ID: <20240403125535.GC19332@lst.de>
References: <20240402130645.653507-1-hch@lst.de> <20240402130645.653507-12-hch@lst.de> <9f555953-6b41-4962-8f43-339326e30d6a@suse.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9f555953-6b41-4962-8f43-339326e30d6a@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Apr 03, 2024 at 09:06:12AM +0200, Hannes Reinecke wrote:
>> +	lim->virt_boundary_mask = mr_nvme_pg_size - 1;
>>     	blk_queue_flag_set(QUEUE_FLAG_NOMERGES, sdev->request_queue);
>> -	blk_queue_virt_boundary(sdev->request_queue, mr_nvme_pg_size - 1);
>>   }
> That now looks odd.
> We're taking great pains to have everything in queue_limits and avoid 
> having to use the request_queue directly, yet this one call we're missing.
> Wouldn't it make sense to move that into queue_limits, too?

The queue flags are in the queue, so there is no way to set them
through the limits.  I plan to eventually split out actual features
and move them to the limits from the blk-mq internal state flags.

That being said QUEUE_FLAG_NOMERGES is a really weird one and drivers
shouldn't really be messing with it at all..


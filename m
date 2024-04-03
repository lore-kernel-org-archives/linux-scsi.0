Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB1631487C4;
	Wed,  3 Apr 2024 12:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712148796; cv=none; b=D2zigYREktJyHHVhN7Tm72kGEoUTfskLLgPVLVe+CuT4JTNLbu+J08p9bYn7/6Y2gcPqKnH6DNN+p26cv3q6XdUOZxlnVAYPxB/9231QgjyALTV0kd6F3+KLpYPd6BAJ1tr+w5pVpQdiTP/g+lDVl85r7rhy96zXtTq+ArLZ8pM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712148796; c=relaxed/simple;
	bh=ABDGDHRyD3g7K24RzddakmQSGMxG1+3prr36JPwuvJ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ot2xzecdqVgEZPZlIm1MZ96x/QVUH9NZrlwc89uxnlIXZB4PuL8hwCY2bUEjvSFM1lEjfmOINeb5VSfq/GTbG4IsbpI6Sn3LFGTgFgBpvLFnXqWmeAPdAz+Xk1g/4cEvKWGjrf2Ky43PiLtnSHuHFLZy7arKkN3GjJPymInEGno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5778768D05; Wed,  3 Apr 2024 14:53:06 +0200 (CEST)
Date: Wed, 3 Apr 2024 14:53:05 +0200
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
Subject: Re: [PATCH 05/23] scsi_transport_fc: add a max_bsg_segments field
 to struct fc_function_template
Message-ID: <20240403125305.GB19332@lst.de>
References: <20240402130645.653507-1-hch@lst.de> <20240402130645.653507-6-hch@lst.de> <db9cefa4-b9c0-4a40-b232-68423fa98271@suse.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <db9cefa4-b9c0-4a40-b232-68423fa98271@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Apr 03, 2024 at 08:50:52AM +0200, Hannes Reinecke wrote:
>> +++ b/include/scsi/scsi_transport_fc.h
>> @@ -709,6 +709,7 @@ struct fc_function_template {
>>   	int  	(*vport_delete)(struct fc_vport *);
>>     	/* bsg support */
>> +	u32				max_bsg_segments;
>>   	int	(*bsg_request)(struct bsg_job *);
>>   	int	(*bsg_timeout)(struct bsg_job *);
>>   
> That looks like an odd alignment...

With alignment do you mean the indentation?  It matches that of other
non-function pointer fields in this structure.

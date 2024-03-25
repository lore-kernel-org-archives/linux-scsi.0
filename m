Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC7A92F41;
	Mon, 25 Mar 2024 17:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711388607; cv=none; b=kOQsjMZA8/Xjt1ZXNWxrtVhjuGRmW4wdh277kOFCMNyAp57cScn3EV/3KaYsiFYMxqNeXdL2ANNlqMkIZwexVib6cTOSGm0b49MfIZkZ+kmovyUG8cVhXIOf/C9T5O7CrH1tQTSmp3P0e8USmhn4Ic5jEsXyBSTsbzgaPovr7XM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711388607; c=relaxed/simple;
	bh=KvNYZd3AQJEKxzKSsUqYfPUgEx64KpoOhil2sUQcMcA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pXtWoyO/Twdc3VXs9Z4ql6e0IjYrX1ESyAUYyCRUQNVZpgHihwCguC7BmIgDNH75Zidhzv1x3ajcTCXXHMUsR/Ph6Fm+IV0+ay3+74ErNNJT20abMzf2Y+XJoR9fnlVQX88A+wwBw54vo9BX/4FL+hMCLKNn0hEtsh9xfgYnOmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=yEmOz93X; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="yEmOz93X"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4V3KzK10GMzlgVnN;
	Mon, 25 Mar 2024 17:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:references:content-language:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1711388596; x=1713980597; bh=KvNYZd3AQJEKxzKSsUqYfPUg
	Ex64KpoOhil2sUQcMcA=; b=yEmOz93X3WhLuQFVhg9ZMT59j9XE2e6lsXqOW6Ih
	4YZ9MWxEJhHPuUVRU0Rjdt7Q336elfa9splr7SLfyJjSI9pVcCl9BX04/kVBeZ/o
	g3vJoOUEi0x+CnWWnCOlNYzqCIfF3/cTvuedZ6fU3ivlvXd/cSLjf0oe0jPveTdR
	j+UwkHN+8WSusmWnp6qKh+QD7BecPL8ricRAdDal5YMsQimlQwT/tUjABYjXzegl
	fMD7y+tLC5kfFgvZyqN1JO6Upr9mib/yheJtvAgRCPU2uJMjd1lt4QEjy29Dvous
	AulexnevambS4U/nToOqwZ9QpH5RwPelSv677pGmwl3tJA==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 8WkJ3RETGwdw; Mon, 25 Mar 2024 17:43:16 +0000 (UTC)
Received: from [100.96.154.173] (unknown [104.132.1.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4V3Kz34YD4zlgTGW;
	Mon, 25 Mar 2024 17:43:11 +0000 (UTC)
Message-ID: <26f51e14-0625-4225-aaf0-f4f7bff5c2ba@acm.org>
Date: Mon, 25 Mar 2024 10:43:09 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/23] scsi: initialize scsi midlayer limits before
 allocating the queue
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Damien Le Moal <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>,
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
 Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
 Alan Stern <stern@rowland.harvard.edu>, linux-block@vger.kernel.org,
 linux-ide@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
 MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
 open-iscsi@googlegroups.com, megaraidlinux.pdl@broadcom.com,
 mpi3mr-linuxdrv.pdl@broadcom.com, linux-samsung-soc@vger.kernel.org,
 linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
References: <20240324235448.2039074-1-hch@lst.de>
 <20240324235448.2039074-5-hch@lst.de>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240324235448.2039074-5-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/24/24 16:54, Christoph Hellwig wrote:
> Turn __scsi_init_queue into scsi_init_limits which initializes
> queue_limits structure that can be passed to blk_mq_alloc_queue.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

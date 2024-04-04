Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED81E12B82;
	Thu,  4 Apr 2024 17:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712251055; cv=none; b=NTdAWFYh/SB/a6od/c7Q4IfEch2Tg1dw+bAsz2ahigg9WELJteyx1GRsM8nXmCXWDWgLSn61I7YNOXOEITtOeX5f6EEA1uLoabmPqr4NDjfLJxT2OS1A1PO3whFBfeNpiqOIxCMeskLPiBJFsKQEp7yq+S3Q/ktHSRNfgz9AiLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712251055; c=relaxed/simple;
	bh=HQkSNFPA1A8z8KFsn8EP/LhL18xwv+Q6EHrk7q5IWRI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=O+xSA+XizROq+mPc33oNKmFyHPGxB5lrJgJ2C0itDkcomA9m9n1oIirRUP/fspFcCAGWtNzojwZTZ9ZqK9SK/tePAHrxWNK1So6Uav4iUQ1C0qxfteKML7ACzlx9mmnh41bhfIqwiWTDbEr9oa9U/9zY/YvYU41FraoYeMQDLT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=mV1rUhRp; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="mV1rUhRp"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4V9Swr0G9KzlgTGW;
	Thu,  4 Apr 2024 17:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:references:content-language:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1712251040; x=1714843041; bh=HQkSNFPA1A8z8KFsn8EP/LhL
	18xwv+Q6EHrk7q5IWRI=; b=mV1rUhRpiLK3JtnTfoW/DCj2IKNyiTgFu8q7NvE5
	mAihlZXrDrhN2kfIGftTNJeyYI/rhbAQj9WyrrsxJAaj7jV61es28ep3EIAeEIPu
	TRhO3ho2fQIa9ytLEY4CMfE3xjF/2YRYm36H/h8200tpPrJ63y4GmQKmGpthrXyY
	yrHuOfDzCG9MBhD7arjYKAL+WZBRQE2CMT2ellqEJVOhDBff/vNs37tsx3VEj8Mb
	Y5jw4ESAs95KnNRwQdeKtXXd6nS/lFbA30X1ij2OtyTzRSIR5QERlOGLDI/DWKEk
	WrhM2qB00ZwEqIUMBPNvcvb3JoDogkaV/XziWlRPBkUSew==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id QVqTQJGwJwvO; Thu,  4 Apr 2024 17:17:20 +0000 (UTC)
Received: from [100.96.154.173] (unknown [104.132.1.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4V9SwW6YjTzlgTHp;
	Thu,  4 Apr 2024 17:17:15 +0000 (UTC)
Message-ID: <9aa90db8-fcc4-414f-a4e3-ee33ff78fb2d@acm.org>
Date: Thu, 4 Apr 2024 10:17:15 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 12/23] mpt3sas: switch to using ->device_configure
Content-Language: en-US
To: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>,
 Jens Axboe <axboe@kernel.dk>, "Martin K. Petersen"
 <martin.petersen@oracle.com>
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
 megaraidlinux.pdl@broadcom.com, mpi3mr-linuxdrv.pdl@broadcom.com,
 linux-samsung-soc@vger.kernel.org, linux-usb@vger.kernel.org,
 usb-storage@lists.one-eyed-alien.net
References: <20240402130645.653507-1-hch@lst.de>
 <20240402130645.653507-13-hch@lst.de>
 <031d6f0c-7d94-4adc-b194-929dbfe80c6b@suse.de>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <031d6f0c-7d94-4adc-b194-929dbfe80c6b@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 4/3/24 00:08, Hannes Reinecke wrote:
> On 4/2/24 15:06, Christoph Hellwig wrote:
>> @@ -2687,8 +2686,7 @@ scsih_slave_configure(struct scsi_device *sdev)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 **/
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 blk_queue_flag_=
set(QUEUE_FLAG_NOMERGES,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sdev->request_queue);
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 blk_queue_virt_boundary(sd=
ev->request_queue,
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 ioc->page_size - 1);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 lim->virt_boundary_mask =3D=
 ioc->page_size - 1;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return 0;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
> Here the same argument as done for the previous patch could be made; if=
=20
> we had the possibility to set NOMERGES in the queue limits we could do=20
> away with the reference to the request queue here.

Another possibility is to remove all code from drivers that sets
QUEUE_FLAG_NOMERGES. I agree with Christoph that drivers shouldn't set
that flag.

Thanks,

Bart.


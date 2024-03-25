Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C8035A0ED;
	Mon, 25 Mar 2024 20:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711398939; cv=none; b=UjI5pggAGQmDBVxZJ91ZQfxUU2rDPc5bV5WOVSlB9lLG4O3+9kABfhOsrI8Rbi+4U/DhuPr2ZmrIAi00Hh4ZmcFTOXQYgZMyjcqGEBYE+1gKYbMJj4BOafyWQRjSnn84o7FvkCPU2tLnUIDoLklFaSh8HV1HKGuk826iTXbx0hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711398939; c=relaxed/simple;
	bh=XNfyrdt8IwQ8sHcus5wiHVSWAwkkOBqq6H3cQ1K8ILY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=A0CI9ae8Vcs9fgl5KRmBaDIANEz8eqKUSRoEnjP5Fw3wP0GFGin6LXUSNnVFV0xgieZSgrrAMHAPgCxcsqr+/51Aq89zQooOkyVehwI6O0cBUxMhrzQ8iQjfDtX4ln/XlboNwGhY60RoJdL/uZkdlip15YSaRgpTPRoOonocWV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=CwOss4Dj; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="CwOss4Dj"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4V3Pp04KSNzlgVnN;
	Mon, 25 Mar 2024 20:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:references:content-language:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1711398923; x=1713990924; bh=QT9Io8KlSjuHM6Qho+N/CED+
	XBtHtFpIBkOTBJKm48w=; b=CwOss4DjseDThUn2brTB1Hu6WUzYytx3mm1/m30Y
	Mqh18pNyF0OMual3NSavgmfjBLQ5ojLlIH/MP4VcMBg8JKW8Gx3AZzHqty4MkMho
	xQZ137EV1NYikFm/w0XRC1eC7ZaQ163f2HIl+GaCyd6CFsu5+G1/JeVLVhjzCgD9
	w1KGli9BewpP4Fookosj9MhkOBgK4xcaj0PSyX/w4lf7qvDCrM2VsjR02k8NN+FP
	kEz0Of8c4gtFWCSegx1yAxGoFvy6odVLz5Y0DmnMSvzhuKTVjqzvzo+Gpiw0L1b6
	7/6krY9wp0l4UykThkNiDoraaMUf3l+ihJTCVVtR7NwKCA==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id qG5C0clMo2Zv; Mon, 25 Mar 2024 20:35:23 +0000 (UTC)
Received: from [100.96.154.173] (unknown [104.132.1.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4V3PnV22fmzlgTGW;
	Mon, 25 Mar 2024 20:35:09 +0000 (UTC)
Message-ID: <b3ee2dec-3258-4c9f-81d8-0a266128b9ef@acm.org>
Date: Mon, 25 Mar 2024 13:35:08 -0700
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
 <20240324235448.2039074-11-hch@lst.de>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240324235448.2039074-11-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/24/24 16:54, Christoph Hellwig wrote:
> This is a version of ->slave_configure that also takes a queue_limits
> structure that the caller applies, and thus allows drivers to reconfigure
> the queue using the atomic queue limits API.
> 
> In the long run it should also replace ->slave_configure entirely as
> there is no need to have two different methods here, and the slave
> name in addition to being politically charged also has no basis in
> the SCSI standards or the kernel code.

There are two methods with names that are politically charged:
slave_configure() and slave_alloc(). Shouldn't both be renamed?

>   	 * Status: OPTIONAL
> +	 *
> +	 * Note: slave_configure is the legacy version, use device_configure for
> +	 * all new code.
>   	 */
> +	int (* device_configure)(struct scsi_device *, struct queue_limits *lim);
>   	int (* slave_configure)(struct scsi_device *);

The name "device_configure" may make people wonder whether that method
perhaps configures a struct device instance. How about using the name
"sdev_configure" instead of "device_configure" to make it more clear
that this method is used to configure a SCSI device?

Thanks,

Bart.


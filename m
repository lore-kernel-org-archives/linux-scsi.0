Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A15615E213;
	Mon, 25 Mar 2024 07:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711351888; cv=none; b=RlkiHw8ZFcfC1DmCRpaVNSO5RshvcfHeGDudQe4yEZjs/59T8SvdZ1kBCglFDIuBOJeFgLDV/Ga3QrKwFQRcg4XVaDEwQPfuSzq/hn5vZmMgMkk3Pq/MD1uYiirEpCYsksO0mRb4r+pSWqKdnM92tH4LXwuY9H6XO3EFEuSbe+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711351888; c=relaxed/simple;
	bh=IC8NYRbOMOiKOx44RirXjG8foOxmmNK/Eyzsmt6KCLg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fQxWTlpsSIlUjYkh5kFBWDTxtR6Be88TuBEa0QP2KOQWun9UlsDgXArdzGDb7thr1N5DTphzSvgrbWZFT0hXg+PWLdmKJTMa6eDKFM6zbRa5ThkueO9z8WKnD2fZqNBk2lxHo7pfE4blvGLBc5I065u3mkuEL+fNFbE20K7n/EI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RM4sFH01; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RM4sFH01"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E082FC433F1;
	Mon, 25 Mar 2024 07:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711351887;
	bh=IC8NYRbOMOiKOx44RirXjG8foOxmmNK/Eyzsmt6KCLg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=RM4sFH012a7DZxA84yCjRBudqGMTkwq0Fwk8bsqetGLY5ECxmf+l0zw6wzWP4hxAh
	 6XgrqK9oxlOt+Tr5gOxTa4G1Wk+JxJsvxn+W+tMXcZWEfafowUu63uuTk0vck0Fwfh
	 3XJP0oYHpYZ8D/Xslkyf2kH0aFM8xCGMkTHnqoQpSkdeFgWH+dkD6PUmlVUFvJuKmH
	 TQCFgXJ6pRFYCMmMUeqtS9Mp/5AjUbaJ8OTva/QsE5PfzGNLcxpV7jqXM5XRe1R4Dn
	 QjukBx6aiXcQJKwdqxGZnXXMYTFy2btWnV/hpKhDpmVtqGKGnUyiEbG+/mkc9nNlLs
	 SCyvm8HwB30Xg==
Message-ID: <0fa3b0d9-d6a8-4427-80a3-616e54987a77@kernel.org>
Date: Mon, 25 Mar 2024 16:31:22 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/23] ufs-exynos: move setting the the dma alignment to
 the init method
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
 <20240324235448.2039074-9-hch@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20240324235448.2039074-9-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/25/24 08:54, Christoph Hellwig wrote:
> Use the SCSI host's dma_alignment field and set it in ->init and remove
> the now unused config_scsi_dev method.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks OK to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research


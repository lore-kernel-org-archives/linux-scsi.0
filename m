Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 029A418E3A;
	Thu, 28 Mar 2024 05:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711602094; cv=none; b=PuPDM2WZagefB67mjj7JYHniLYpVj/JOsrTpNJIIgm8eAT6Pfuaotw+wuomq8Ban9gwClFXhb4B3Je6nT4k2VU63ewGn3Uj8cvdjjvGn2UFU6zFWn3BhOvQdrP1VXIaIW5k9JiPFuGU/lzqqtcTePnoJwy4/WYLMDK0Hv0Zizs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711602094; c=relaxed/simple;
	bh=QGOjoDyeWF3dA35WKaoPxT8+F2LMLEgxxVll4TwFRGI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hX88JHp50RgSGTad3o6L2BG7UntVLNBolB8Ll3BHOPMbri/K6GsDlf8G/JkEzT2w52vkfRf4etN2OB5tNY1XyesdjwYDiPIhaTmBpFmfLjX8x3IEbnIfUswi3TkB6yG25Vww6kryBeaH4pRvElCCjOcpI7xeyTE6xfgt6+ugbAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5852C68B05; Thu, 28 Mar 2024 06:01:21 +0100 (CET)
Date: Thu, 28 Mar 2024 06:01:20 +0100
From: Christoph Hellwig <hch@lst.de>
To: John Garry <john.g.garry@oracle.com>
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
Subject: Re: [PATCH 07/23] scsi: add a dma_alignment field to the host and
 host template
Message-ID: <20240328050120.GB14655@lst.de>
References: <20240324235448.2039074-1-hch@lst.de> <20240324235448.2039074-8-hch@lst.de> <1137e698-4376-4dc3-9bdf-886945787486@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1137e698-4376-4dc3-9bdf-886945787486@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Mar 27, 2024 at 03:15:28PM +0000, John Garry wrote:
>>   	shost->max_cmd_len = SCSI_MAX_VARLEN_CDB_SIZE;
>> +	shost->dma_alignment = 0;
>>   
>
> nit: I am not sure that we really need to zero this, but it also seems 
> needless for max_channel also ...

In this case we need it (at least to keep the existing behavior), as
the SCSI mid layer sets a default alignment, and iSCSI claims to have
no alignment requirements at all.

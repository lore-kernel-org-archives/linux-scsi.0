Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA07415ECE1;
	Mon, 25 Mar 2024 07:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711351813; cv=none; b=GUnIP0EA6EVsDzdiOU6+CUWZZpRtwFKCVSBmhey1zQ7/A8Bkk50ivHv1RJolMhJe/aK9FwWBmosIikOGoX49CaAFDwV6D3Bm3ofXX2dQKB2T/DZMUwkYpzGaJFR6bmp18Nn9OPs+ieHxuOySSQSBfUNYKfTztqL8sDlkJoa+JlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711351813; c=relaxed/simple;
	bh=NDrBUpM1fCLkHIX/k1OcYxlc7+QNZ4MTP5hVlmaU808=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uerf7YcX+jgCpENMkh42t3F1iD0tb1TAQrVCzQivVGid1z5TVds8RcyAy9RXxfViVkJ6hfTGa9SRDy4HjxvWsjIi84+Zsxdx76IjX6nqo3V0vPR6DnZ2VsK5P3D1hEeEyJusNC/hLg+lbgFChvuY0q461yT4QGCviZiClO4cNRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=et16iQGk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="et16iQGk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EB3EC433F1;
	Mon, 25 Mar 2024 07:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711351813;
	bh=NDrBUpM1fCLkHIX/k1OcYxlc7+QNZ4MTP5hVlmaU808=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=et16iQGk3uzH3inLKxHIVwmH/ZOKLRNisFtq/zgjl3TXvONDYMuIOHRwkrfAytWqq
	 3lRMoVUARh5ghzQm7JLFiXmBjhCodoeqsMpRKcvwO/rrUzw98ewNLc9XD20pDhw+ub
	 DqTJlsd0LIpX6jbzbdmhrV7KgS+432yhcyo1SU226C4dRd03YFq7LceQkpGlKO/Yeq
	 O3MDjVYH6GS2PVBtbcq/KkrEO8GjSGI2h0LVkZS0ZWszuXbmZLHzkLpz45xcJ3DiWf
	 8AbTLD7Gv6G8H1XqlL8o/oIc28bMnjnnt9TvFnwVDttTXMNcZaaWpg/2TTDZbcGCwd
	 QyJKyo3Krivhg==
Message-ID: <3f140e6e-a73b-4c27-a14f-0add8c36dd26@kernel.org>
Date: Mon, 25 Mar 2024 16:30:06 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/23] scsi: add a dma_alignment field to the host and
 host template
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
 <20240324235448.2039074-8-hch@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20240324235448.2039074-8-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/25/24 08:54, Christoph Hellwig wrote:
> Get drivers out of the business of having to call the block layer
> dma alignment limits helpers themselves.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks OK to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D77F185F20;
	Mon, 25 Mar 2024 07:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711351020; cv=none; b=PQRmOB3pw1MXlg/PS7If05WsAgQ/+Z81DNpuZS5NwJTU7G4te11VIfQ1ujUPYRf9Da+t3trzuIa7pUPZFoGKkRJ2EreemxMAAWXK1Ah+MNdVhuF3fuKFYSfLPg8PwnVVouw9zN9o0uBntIbQvAAkm+4LaDkhfbzLgC5b6uRtAsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711351020; c=relaxed/simple;
	bh=jRFQXMqk2mr54MVNPz8FLEo+v0iOrBwd2zWx2qG45N4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=df8X8qHeDZHx4rWfoF0Jp3XpKc5FPLpLugqq1GgYavP8OVe50QUcQCZ7gjHwQWz2eOEky1SCfxLzlOEFl82qL8ILRgsymyPqnkqWYUCtOMU38wrPl0IZAb3AHwQBVqDwypRUsM3LeGAdN5tcE8fWtFJUyPc2wsEV8gj/HXuy/hE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iSghu8mR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iSghu8mR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 153FEC43390;
	Mon, 25 Mar 2024 07:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711351018;
	bh=jRFQXMqk2mr54MVNPz8FLEo+v0iOrBwd2zWx2qG45N4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=iSghu8mRQGF5IJ+vZYOrgRCs0MbHfMU1nH/utJwHMeTBTyM/1H1+L/n7V8M1vdgfm
	 jZYIAt9zw/BGq/gn15hf71O59Pp+daLKFacfmNTnexvB2mDEwsrYzgQ7O2LPJBoNce
	 ZlbKPLyERP+NpfjrBsU2cFN5FQ4g4ukcMHaqboDPd19LZyVTAE6VI+Jwnmg27PmVXF
	 1vU1AnJtShxBVRvdo6OpHr1sjw6W1n5w3dziWvrnMQ799B3YYb1GVrRCaQR7BUYyw4
	 sKOL/yeaYy+4Bhjkbve6hrb0pKKmDBagN+MRg3tASNji/iAqgitihTNp4S5UtDDTvN
	 ceCqRblm0YWRg==
Message-ID: <c9070d06-3095-4bc9-8b9e-ce292404362c@kernel.org>
Date: Mon, 25 Mar 2024 16:16:50 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/23] bsg: pass queue_limits to bsg_setup_queue
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
 <20240324235448.2039074-3-hch@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20240324235448.2039074-3-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/25/24 08:54, Christoph Hellwig wrote:
> This allows bsg_setup_queue to pass them to blk_mq_alloc_queue and thus
> set up the limits at queue allocation time.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks OK to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research


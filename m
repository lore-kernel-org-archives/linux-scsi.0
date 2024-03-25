Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40DF913DBBC;
	Mon, 25 Mar 2024 07:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711353329; cv=none; b=GnkxmrziPzFRXOxP6NGTS4lQtZFwRNfDM4FojO7rBP/fzAjhSFmOAxounR4H7wJc2u3VQ0eRJ+PvMcm8ECqt+zqq3zCOsFhwovP5saTcmGCH5/h0PVzMFZPYq7b7N7qHMsin76DoVF4jYToxfBwmdjI1Rqi3WKQRlR6+jtPbRic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711353329; c=relaxed/simple;
	bh=wRfDMdaIn7grVH4v5DLJ7V9z90fDUtky1hLnubiKjdo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tXYqK553IBBnKn96WXs11Q/osVnu/ImaLA0D78rxILAdFx7ISy8b8JYnR75jIfoxYuVYFuGj1771eSiQf9ufvfCK682pjyjbVn5PDn4in0OotT/YP6LTyZVyi3mEM6UTaS8vjQl2BevfOKq32k9uASD4tNF0fOMSdET+CAon7hM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i6pow1wt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i6pow1wt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2865FC433C7;
	Mon, 25 Mar 2024 07:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711353328;
	bh=wRfDMdaIn7grVH4v5DLJ7V9z90fDUtky1hLnubiKjdo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=i6pow1wt+UgVCld5LOB9MtljCmSzY8fmuMpZI1C44NhZ2RVvWjChCw8ieb9rWm2IQ
	 LW1O+4JXOrYFh9hib3Qhkq4H3PglIJWHSSDo6xuvDcQl1NdKXXcIt7AGn6qy58XYoZ
	 oFzyPA9QYcAFzfjh2+mNuNYnZX9CSxYQ0KInyhT6CPtZIVm6G6uMKeQSEJ3pAa/cF8
	 zdn8+gwrzWCrFOTKsP5s7VdVNhPzVTZY3/8vhIJdfMhQZnF1yslY0boLsvmKja4IcR
	 yQdWhJjKnB6hW5V2eScRDk0ir21w4Z2I996HkhCWw2AH5AIhKNSXoXFoz2XznVTJ6I
	 wFDPA4ncdqNuw==
Message-ID: <43670f3c-b1cd-4732-9e0f-3cfb3ae9233a@kernel.org>
Date: Mon, 25 Mar 2024 16:55:22 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 22/23] uas: switch to using ->device_configure to
 configure queue limits
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
 <20240324235448.2039074-23-hch@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20240324235448.2039074-23-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/25/24 08:54, Christoph Hellwig wrote:
> Switch to the ->device_configure method instead of ->slave_alloc
> and update the block limits on the passed in queue_limits instead
> of using the per-limit accessors.
> 
> Note that uas was the only driver setting these size limits from
> ->slave_alloc and not ->slave_configure and this makes it match
> everyone else.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks OK to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research


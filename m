Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86AAB13E8BD;
	Mon, 25 Mar 2024 07:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711351401; cv=none; b=eMZsOskkBa/uoIoTXt/aGkrbWDp7emUzynqmjZ3UVDs29uHyr6OtDsLTka7SqJL6hWuegn3FBpQiRYVTUrRckYqZiz2xbUk9Lwa8uJrgztW8f95fDI3Nbln+kq3Uj1VuDD+g01aCcfOFM+JP82i0+WsbGGimtHvc4UYXStRR+Oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711351401; c=relaxed/simple;
	bh=kejTuzIp9rfToJ4oy04aXfQo2mLPE9gVCVVnySoDABs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=So5lmPHCQAkSctQIgOGhoLISN8F38QhtrCjZXeNO7fhPPBLN9DkUMkH9V5emfWVtWnaG0AnK6F9YYYTXfyfv/zsBGelW7HQMdjSqTE9YMM6ayPy/k+nPJiN2+FjMl+1OugmmGd3sT5HpIxaC7I76jKkBsTcjumwSQN1kGxZnXvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cQqk9TXB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cQqk9TXB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F153EC433F1;
	Mon, 25 Mar 2024 07:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711351401;
	bh=kejTuzIp9rfToJ4oy04aXfQo2mLPE9gVCVVnySoDABs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=cQqk9TXBq4tgTpnY+hlyUGJfi7yyom6JXB9i2HUcI64xPvvlIVPrltzqs5VeG+FUS
	 kVcOfp7IYSKx0W6PW3nCOhwjndCkz7+40nBI/eRbzqzShnIYqh/54TvrovU7N65Pwk
	 RwNETPj8eYi0WSyYfW6nN9ysBAJsrdPvxe/ITLUXWGi8ufOTPJnEiF1dAg3j9JFXm2
	 BD9asb/Hyb9ZfYUQHXfpSwWcmlGbyR3ByYYGV0KgOb5Of+TIEkJccV2dgh08Nds5PZ
	 X71IkDWnd8xMsPZ8pw6Of7A/1o+C/Etk2JXfCmJWMXt7xRgDODl6i6PjZozk5rJ/DI
	 Ld7nzYvEKO6Vw==
Message-ID: <08451976-7e39-4c7f-8bf5-5eeda4316c4b@kernel.org>
Date: Mon, 25 Mar 2024 16:23:14 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/23] scsi_transport_fc: add a max_bsg_segments field to
 struct fc_function_template
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
 <20240324235448.2039074-6-hch@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20240324235448.2039074-6-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/25/24 08:54, Christoph Hellwig wrote:
> ibmvfc only supports a single segment for BSG FC passthrough.  Instead of
> having it set a queue limits after creating the BSD queues, add a field so
> that the FC transport can set it before allocating the queue.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks OK to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research


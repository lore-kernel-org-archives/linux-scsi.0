Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F0ED1428FB;
	Mon, 25 Mar 2024 07:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711353378; cv=none; b=nI8puqXf+XuREma696Eq9BG+8/PwH1gqsORsV8Ds9HrrHRKPF7ZtoMTlArjhu86tY8gTWKu6CUzvYhAgXfke9tfnQuD0mnsPsT3Dr6OIe1q13Zo8QQPGUizrZbt5XYhiOGOKCDUaje60x0lSEvy37pIuSwbPfj3T2jymN6clpa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711353378; c=relaxed/simple;
	bh=+z5n42jcDU1Q65n+MHR7wbB2WsqxNLtuNE+zdSE58go=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eqhKGR1r2msdxkdKS6oz6Vbg+7ZqDZz14Na4Q4C+ZV89593q/EGBd5/WcjcZ1oAfRWZLJiZwuJKQhYGH2ql3JgG+PV8UezdSpeFH1qPxQsvNx7zFgVwNenHpIKX0hTXKAmh6wUDwH0FiKilD9tkrCchpM/wW/ECH3zA2BQfQ5fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DRIyCw+R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DRIyCw+R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8369DC433C7;
	Mon, 25 Mar 2024 07:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711353378;
	bh=+z5n42jcDU1Q65n+MHR7wbB2WsqxNLtuNE+zdSE58go=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=DRIyCw+Raq/vGzJ0dJqI9r/RqfobgkxAwTJe0q7r86S7sVHlxRfqfCeguJNxmT0IQ
	 BB7G1F7G8oItcYfoOGv+Vk9cdINiBQ9buBhrCvxIEmQH+RXECl4Pt4pzMnQzyRMMdI
	 xRU3VVC3OaIDw+iTMZXeT+uSPC584aanpCeKbuY72xI2ElQzycopkmWcwvq0vgjvOp
	 8JQZo1gVo6qbPKuXMhhXtPvB1IxlauCcerYawjfiYkZwlxOO7rUWkq1+OLNMhxFxTX
	 mhSfFOyPmw6W9Upanlj7BLcaT+nZTb4/0j8TwOw9qnsvgpo0zL1kFVUHf8swReWnTI
	 jE1durxYfPgig==
Message-ID: <bc4293a0-988d-42f3-a94a-b6715d72c204@kernel.org>
Date: Mon, 25 Mar 2024 16:56:12 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 23/23] block: remove now unused queue limits helpers
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
 <20240324235448.2039074-24-hch@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20240324235448.2039074-24-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/25/24 08:54, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks OK to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 157441E531;
	Tue,  2 Apr 2024 23:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712100286; cv=none; b=WpUJCyvaXkfHyJswGEtGNO3wh7rRvSaj7DZffM13w8FTll9//kqfDZkUL1y5tz43/2yeZK+b4aoBKwMSCPvwDJssY113vQXHEs5reEQk6TTvmgCRAiMDp1mU6Px1uFB8EX0onf2vo7Ihaiyld/953q4U83t8l1w7s7Z+meApfUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712100286; c=relaxed/simple;
	bh=SOcZmrJfqQWxyRrd5zPsb0SS4XNlrFrejR2keRnseV4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mv3qZ3w/4Hjf25CDtooQ3XcMOdkRw7lV8IpFFU+1JV2LutW/lImoWrpzc7elyfd5Ro+hHkGsBlAlg/oQuxAOQs+9roodWCEJdBQXoGTWeKW5/ASfevMiQxpFnp0XbgHNeL9OJaXxnmHd3lB83euDIJM89SKkQtOF5kZeoOmdxZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UDo1c+tC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UDo1c+tC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 576F6C433F1;
	Tue,  2 Apr 2024 23:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712100285;
	bh=SOcZmrJfqQWxyRrd5zPsb0SS4XNlrFrejR2keRnseV4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=UDo1c+tCNp/2smLd5/d1j/Qxh5i7+6sQQE/akTCYPQzi0uokgij/08ZiMKqbPtKWw
	 0gar+cTToqgQcYSkP+ZWuJwjrkY4wmjJLSIhVcaEMASiAN+JH+q/3TJm/ZTVTYJP8F
	 WUjWN5Ke4G0iq68+VzPr8KEJ0Sh2tQzFbCXml891QjePPaI3s7jnO9qmK+ru1L8DPq
	 yPst2pTlCr59CtPo7/cwyz4n45SbDQ0V7D3cTw59NDMu08FjVccOt7Fmc1suFDSDbb
	 689ikLQAZVTDcBJqFM4Ap2fQL8yLTYT1bOc5Z5An6OckOpgTdAtGJfWucFNRgWIkn7
	 xHlxZkx/XdIAw==
Message-ID: <dac7ec14-7819-46dd-82b0-fd009523c743@kernel.org>
Date: Wed, 3 Apr 2024 08:24:37 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/23] block: add a helper to cancel atomic queue limit
 updates
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
 megaraidlinux.pdl@broadcom.com, mpi3mr-linuxdrv.pdl@broadcom.com,
 linux-samsung-soc@vger.kernel.org, linux-usb@vger.kernel.org,
 usb-storage@lists.one-eyed-alien.net
References: <20240402130645.653507-1-hch@lst.de>
 <20240402130645.653507-2-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20240402130645.653507-2-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/2/24 22:06, Christoph Hellwig wrote:
> Drivers might have to perform complex actions to determine queue limits,
> and those might fail.  Add a helper to cancel a queue limit update
> that can be called in those cases.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research


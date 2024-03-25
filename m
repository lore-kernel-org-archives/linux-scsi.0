Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B08ED139577;
	Mon, 25 Mar 2024 07:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711353011; cv=none; b=lP82rCVWSFnqq2IEHZDk8ACNbdlYz0JgjyOofKoMrLBYJD5PyLbnR6cKNFGc4807Sf9OQhndDUzVZQH+zaUo2oM/lqd/FqCQmKpXyBTXvQRNBHWmfBxftPoX+pnM5Qm0hLDvgcPt8M8VZIwQbSzoaEJaGo8hIvvkkEjeNUDYAOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711353011; c=relaxed/simple;
	bh=g2liTy/svI2y0Rrkakwfy55aiwUTTTcX59UpQY/YMaw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=k8OyqNKHKSesZb2gRurJPozbXMe+MAjR2ki3Bd7Fx85957+U3qnUlkTk4uT0dVPZgnFTFaE3iOzrpseVrMFBX507oyO+Yd5WraDsTXw/dOHr0iNci3DLnHvMG0XR9PtGzIC0bolwWmypUrHUEEfSBMmx96htOaFPjixYNSEtQOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nXE/LH2T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nXE/LH2T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73AE8C433F1;
	Mon, 25 Mar 2024 07:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711353011;
	bh=g2liTy/svI2y0Rrkakwfy55aiwUTTTcX59UpQY/YMaw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=nXE/LH2Tee6RTRiqYHzbKktkaxvExho+IhyLfOvurmtdQRGyzbIfvRU54YopRGZjJ
	 S2Z2r7Bl5bjPwVog89MMAUGOI24AOURu61gof7Hnz3hs8ai+0bkPRpTl3zFOlUvZ+d
	 faKqeKIkCu/GVV46oMHPjGaAuO5HlFPDoDMRw9mT2yKrEoyLx1NZp+KrKxpkH8BS8j
	 GuT2pMuQQflquWZgYDirJFmQ25JKb2yC1yWfR3DTyA2Gqc0ohemNW/InMsrZivSXKy
	 JbkybTLaNFe41V7eq2HDB27tE7woU3WwRo90wxTQRwXbPFiMugRsbL+1jmjwjGkqYt
	 uEAOEYJWrQrmQ==
Message-ID: <6944da16-2a6c-42cd-baa1-c6d6d4dfc866@kernel.org>
Date: Mon, 25 Mar 2024 16:50:04 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 19/23] pata_macio: switch to using ->device_configure
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
 <20240324235448.2039074-20-hch@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20240324235448.2039074-20-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/25/24 08:54, Christoph Hellwig wrote:
> Switch to the ->device_configure method instead of ->slave_configure
> and update the block limits on the passed in queue_limits instead
> of using the per-limit accessors.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks OK to me.

Acked-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research


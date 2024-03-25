Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C136D18431C;
	Mon, 25 Mar 2024 07:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711350898; cv=none; b=LRQ9XxXr5shgu5TlTXB4D/luQMHpOytxAKe/BxGV+zVyX0p2SYFbTKIVbYApz5vl9TPfxHmOS3692EezkQC2nyrM3XU/hT0YcQqHNWAWZFNpJwXXWGN8Xsm3QNgLfykwIA1a1HTaDlbF6IkbifRG5eW0h1w6TnSxZTwW/ujyDO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711350898; c=relaxed/simple;
	bh=y3qv71zpjndpj4NB+KeexavfGhw/KD4Z+vmOdRol9g0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aDEd2bN35UBaAqEI5DfjkZhtL8mqnDuwXP3IYxybIwVY/B0Ywd8cH7OJ6oyPZMY4/F+GIk0JH6r8weZua2v1aLy0sqDDMFwm1WjY/Kcj5v4DXHnwTk4oJsmnOLfpjTtK4uTe5aDieD3Gs8Y5FEH2kjL/0h0U+OoiYMAaaszoUe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rtrmh5Sf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rtrmh5Sf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D80BC43390;
	Mon, 25 Mar 2024 07:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711350898;
	bh=y3qv71zpjndpj4NB+KeexavfGhw/KD4Z+vmOdRol9g0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Rtrmh5SfbgjERmHsqPcQ+yhhfByQQq8GxgvgRdmK7Z+Hjkdms8oZ+o/UmiYcqZ16x
	 Dks5YmvOe4uY/xGqR/Ty83lnbI6YNpx+jDOWCJXw8y8JK+BPozZOxLa+XqubWoV97M
	 PEVP8itGIYGNI3tnfonfdvQ6AbqfRJUyGrtoJya7FWk3PTZi++DCDUmK44jaWGMeTL
	 Yi2zJUJlzbsFvOD6TfhJsknzpUGbU0Iz3dE2XpkhqRZlzCa1dhU13LkBqPQNHMQ7Hh
	 Fii0E7sNJ37tfk2IR4ihYhXcwMa4KAJ/9lXdY3WB4TX+xg+hvKuZRqyGG7Bbaey5iR
	 NlThAD2Cl/Pxw==
Message-ID: <b8346696-316c-497d-972e-c76d897a1c87@kernel.org>
Date: Mon, 25 Mar 2024 16:14:51 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/23] block: don't reject too large max_user_setors in
 blk_validate_limits
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
 <20240324235448.2039074-2-hch@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20240324235448.2039074-2-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/25/24 08:54, Christoph Hellwig wrote:
> We already cap down the actual max_sectors to the max of the hardware
> and user limit, so don't reject the configuration.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks OK to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research


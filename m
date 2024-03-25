Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5086712FF81;
	Mon, 25 Mar 2024 07:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711352927; cv=none; b=ARijzz8966aLlQ7nHGUZhkCG2sHrLyMGyvgCfa3OBXEbp1qkaQl1ULsVHO1rtofJ2nDRQyRXQhsQf4ryWCzxk9lTj64eVb30dYaiUbkP6eHBdFEGSOFALYsWP3j8frj45McuS72D1Nv2rdmX1eIuYUP1UtIPk/zKaMfDchLJ/dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711352927; c=relaxed/simple;
	bh=VK/6BkARnl/o3OozqGNIJdt7BEP2i7mKnGvBJjOZ2u0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=m48S/dwhs7tneigi8b2Wmp+ok5ymXhdWrvYmHihKuOVysOUBrIE6fIjia90B7bByrjKI4+5III3CPpdsGGs160H+Cwq5R0nkcZv/+B/NM/LoQjJnX6dRskypVuPXDqiM+0rCNOKDh8bK1ZuI3N2bITVMrK8OswcVC9h3CzgPWGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SeVYTbo7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SeVYTbo7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06BE3C433F1;
	Mon, 25 Mar 2024 07:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711352926;
	bh=VK/6BkARnl/o3OozqGNIJdt7BEP2i7mKnGvBJjOZ2u0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=SeVYTbo7XFptQ6mWrWBPVyvQAJx9LyolOlkhSsJq6pxUR/dZ8a0SX8i2SCkiHdxhK
	 9UGmsq8tngObo0Rl/xX+azoMmQtaKDEgcehgORBLVgUaI9dvykPA3e4h76UqNqI21j
	 sMpt5+vY64Etqh14S7yn6NwMX3s4hAmRSpIPyhe/J/BSJpulFlVk66gb/muntNmyVs
	 eSZluCqUidVQRC/LjFLHZe5Chu2gIb8ysJETi6XX+prnnXShdPLkvrn5WpHZ8/QsXZ
	 GR9O4WCTPUs+g/xzO0kBdThTUEqxDnMwNpt1fJiNPZNi+mTgrzyGffuFRjPLD+q476
	 fFFdRLTmbmxkA==
Message-ID: <9f2082fd-83d8-4140-84a2-865112090a46@kernel.org>
Date: Mon, 25 Mar 2024 16:48:38 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 17/23] usb-storage: switch to using ->device_configure
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
 <20240324235448.2039074-18-hch@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20240324235448.2039074-18-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/25/24 08:54, Christoph Hellwig wrote:
> Switch to the ->device_configure method instead of ->slave_configure
> and update the block limits on the passed in queue_limits instead
> of using the per-limit accessors.
> 
> Also use the proper atomic queue limit update helpers and freeze the
> queue when updating max_hw_sectors from sysfs.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks OK to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research


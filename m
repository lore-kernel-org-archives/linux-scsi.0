Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CA7F1869C2;
	Mon, 25 Mar 2024 07:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711351063; cv=none; b=HJvZ0w/g5u4Y04lNnfTdRk30sEf8iHVBjqRtfNEpQ8uZAd9xLJoSl6vaucKwpTS6rAyRSPqyrhRYgG/h0hypwbx2pgD/dPKpVFhRDP567XdVKsZ3HVlFLN1JApjNH7cl9I1voQn7Wtmf2wTDdrw21O7lN8lM9nV3sqJVaIMIDmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711351063; c=relaxed/simple;
	bh=krcKJp10FuGtr98dTHJSOHbrBcdRM3frvNdn3khaR+o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P/FnJ3rtwQMkxdgfNbgP7HdRerKxIa+8JP9f3ZZanoM2n6gPVVq8EO1ugBo8G2EuAiNIeGL97LCGdg68RcESg7b2J8g1yc+QE/2uxbt+9vMYfNhFV+emw8ytwiyiy3M/OhgZ8aGEIqqKcVsGk0ty8s6RA6UpPtqqz6sy6+2PoKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dSlxD04j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dSlxD04j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C16C3C433F1;
	Mon, 25 Mar 2024 07:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711351062;
	bh=krcKJp10FuGtr98dTHJSOHbrBcdRM3frvNdn3khaR+o=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=dSlxD04j/cvhKDB4Qx1Ot1hj6nlV/+6z4nRumaOdp1EgrKMnrD6zopVoHdDllatrM
	 8g7FwBOsONYyJFZ4Xe/YWQSl7WXvHpzt7bAc1HqdGUYKa9BId2QEZwHOus/sV9cMVe
	 e7LsW504Ro8HHnhETGfRjeeeAmIx2tCEujdFrfodwQUWtGq2FHzGzR0a9UOEZkXNjy
	 g/zmTd3HQPZCgw3+u52Q7cCnkAwYUsnlL0mZgn4fqktcLoEcJnZ6G96flxEZGhws+Y
	 KXusUbhNnQtNpQxdSKYzFbkKvEuq4rRgbyvHzhElCp710VKE30dHV7/QTf1WFGs0VU
	 RYtSkIHm1l23w==
Message-ID: <04beb70f-38b0-46f7-bbbc-24cf40a91d70@kernel.org>
Date: Mon, 25 Mar 2024 16:17:35 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/23] mpi3mr: pass queue_limits to bsg_setup_queue
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
 <20240324235448.2039074-4-hch@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20240324235448.2039074-4-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/25/24 08:54, Christoph Hellwig wrote:
> Pass the limits to bsg_setup_queue instead of setting them up on the live
> queue.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks OK to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research


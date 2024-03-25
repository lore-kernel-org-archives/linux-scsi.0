Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C64113C9C9;
	Mon, 25 Mar 2024 07:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711353286; cv=none; b=r+nv6F2F7VM2UsfiJGtopKevSy5f7zu4Rle89oj0MrrF/dXxqyF7VeE7GgH8/61UI5+WDHQ0RCrrDb5pPkN+2t30CLKHWUntgqQ/7Zc/RXTQp0IRiFcnxnu+dUBPS9Sxz4RIXoMc2Xpc7v8rElCo1EbpIMOHOGEF14KD4NtgIxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711353286; c=relaxed/simple;
	bh=owMqOeBsS40pgAVEEJqiivm8vJ9vsYeg9GKGOlS+4mk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d4en4xCU7yS4YnE2uI+VLaSQoRiiZmcK8YTLoPpJbwmu3AiqVmaqZ4rSpaZSh8gxIcuLlHb2OtbK6oTUBf8JxiJuoS5mJaYV3EaXyj4dP/PAyjfRCM4GB7d1d+34hiuvqlMULhyEdWduF2MahR75YYfc4vzimDbngfjb9VJPfZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j1xHlxFy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j1xHlxFy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86033C433F1;
	Mon, 25 Mar 2024 07:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711353285;
	bh=owMqOeBsS40pgAVEEJqiivm8vJ9vsYeg9GKGOlS+4mk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=j1xHlxFyrQ4/4bWLbtuWfZHhrQilncRu7iJnrGz4+8mMPb4xD+/VaDx68WL0+yb1Y
	 n7pWfWEtpZFX2XSRJAbUng/wnBPnQQXf8yPXh1ETB/RRw7tBc8WRgMSrz8ojqZn/Bh
	 xcufasJNpsdvt7lgZZf9lP9HES8aoIbbJpA0TESAPV3vZ89a5ERculIinIzz1yyKOg
	 HbwcXVxUqFyQUg9bUic+qhmV1ZyPj0qinBaIXb/i/3teYlDO/eAJ1P4wPYIi87D9Yb
	 2Rn5poUux+rcVeKZNNqyDwc4KQYvGzTZ5yBd9+s4rkaSKjm7ATo6nodTEBLbTbFxM8
	 cXOOBBSHz7XLA==
Message-ID: <66169fb4-efeb-4da5-8280-a0585537acfd@kernel.org>
Date: Mon, 25 Mar 2024 16:54:38 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 21/23] mpi3mr: switch to using ->device_configure
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
 <20240324235448.2039074-22-hch@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20240324235448.2039074-22-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/25/24 08:54, Christoph Hellwig wrote:
> Switch to the ->device_configure method instead of ->slave_configure
> and update the block limits on the passed in queue_limits instead
> of using the per-limit accessors.
> 
> Note that mpi3mr also updates the limits from an event handler that
> iterates all SCSI devices.  This is also updated to use the
> queue_limits, but the complete locking of this path probably means
> it already is completely broken and needs a proper audit.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks OK to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research


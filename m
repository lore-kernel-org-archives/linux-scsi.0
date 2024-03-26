Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E97E13C812;
	Tue, 26 Mar 2024 14:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711464643; cv=none; b=gSK/YFcYuWw2XDoq9gxJ+vek7X7n6QFZloU4A4+AGqeZVRyE8FnEShAC0vKo9HZOKCRiXLdPTdsLZJYd+UnYv4D5fOP0c/D3PuiB/jM7cXeT06KizDZyxw4fBD/EuZQ0tqXtmWjG0e3Ygeto94o1rZFrW8kM3NU5tOVlhISYjzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711464643; c=relaxed/simple;
	bh=BMaWtReNcW0SfbPcKNR6e7oETiRCsXGbYLmLZs2SAGM=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p6RQFG+DsgbAIKFpGhjjB25wPE577s16sbzqzmMaCcPzohwRGJwT8hppKuWiRPvPumhN737lpAN6fbymiF3v9rbN7GPamZiuv5eWkkUpixeC2ysUmnlqdZkX+q2maGYa2AlntdaKPRbYN5IdZEYiLh4LmNCA1UuOkjOpxsJDQMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 848FA68D37; Tue, 26 Mar 2024 15:50:33 +0100 (CET)
Date: Tue, 26 Mar 2024 15:50:33 +0100
From: Christoph Hellwig <hch@lst.de>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	"Juergen E. Fischer" <fischer@norbit.de>,
	Xiang Chen <chenxiang66@hisilicon.com>,
	HighPoint Linux Team <linux@highpoint-tech.com>,
	Tyrel Datwyler <tyreld@linux.ibm.com>,
	Brian King <brking@us.ibm.com>, Lee Duncan <lduncan@suse.com>,
	Chris Leech <cleech@redhat.com>,
	Mike Christie <michael.christie@oracle.com>,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	Chandrakanth patil <chandrakanth.patil@broadcom.com>,
	Jack Wang <jinpu.wang@cloud.ionos.com>,
	Nilesh Javali <njavali@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Alan Stern <stern@rowland.harvard.edu>, linux-block@vger.kernel.org,
	linux-ide@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
	MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
	open-iscsi@googlegroups.com, megaraidlinux.pdl@broadcom.com,
	mpi3mr-linuxdrv.pdl@broadcom.com, linux-samsung-soc@vger.kernel.org,
	linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
Subject: Re: [PATCH 13/23] sbp2: switch to using ->device_configure
Message-ID: <20240326145033.GA22360@lst.de>
References: <20240324235448.2039074-1-hch@lst.de> <20240324235448.2039074-14-hch@lst.de> <20240326093045.GA139274@workstation.local>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240326093045.GA139274@workstation.local>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Mar 26, 2024 at 06:30:45PM +0900, Takashi Sakamoto wrote:
> >  drivers/firewire/sbp2.c | 7 ++++---
> >  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> I'm not good at any kind of storage protocol, thus execute me not to
> review it. My concern is which subsystem provides the change to mainline.
> I don't mind it is your subsystem.

The whole series should go in together, probably through the scsi tree.


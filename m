Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63A84129E7C;
	Tue, 26 Mar 2024 06:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711433531; cv=none; b=MrYjjo5L1+8l2S4EIGSWGIbubc5V20cmego36MxkZKJgmGXxYJyWn/+356YEqu+9lunGCRkJyYF/X0BUrGpT8op+HMIzfyUVSCvccXjjSoMFmipgro3vbuE0dKk9A9tmLLUfObu4NZJjRW9gbY0Eh3qXTuZvUby8h1rtyPv1ds0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711433531; c=relaxed/simple;
	bh=kpe4H+Lam6s0YjI7t7JzmG7WmdeMs+5xtps5XOmEcyw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UAxqt1JHuBDiUBB5YmixmqhOpESntL6KrsIQ6PlIlQkxhN69SeKbIPeWAjVksIREye8EBg7jXtA4OOUySl9etgOxlQXzeHZdz4T4R2/gu+dLdRnzB9GWLnjjM9OFGC3ijOMYSIXOErxsJ1boDzheLb9GyljYaBIA9Pp7zajn5oM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 572EF68D47; Tue, 26 Mar 2024 07:12:03 +0100 (CET)
Date: Tue, 26 Mar 2024 07:12:02 +0100
From: Christoph Hellwig <hch@lst.de>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
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
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Alan Stern <stern@rowland.harvard.edu>, linux-block@vger.kernel.org,
	linux-ide@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
	MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
	open-iscsi@googlegroups.com, megaraidlinux.pdl@broadcom.com,
	mpi3mr-linuxdrv.pdl@broadcom.com, linux-samsung-soc@vger.kernel.org,
	linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
Subject: Re: [PATCH 10/23] scsi: add a device_configure method to the host
 template
Message-ID: <20240326061202.GD7108@lst.de>
References: <20240324235448.2039074-1-hch@lst.de> <20240324235448.2039074-11-hch@lst.de> <b3ee2dec-3258-4c9f-81d8-0a266128b9ef@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b3ee2dec-3258-4c9f-81d8-0a266128b9ef@acm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Mar 25, 2024 at 01:35:08PM -0700, Bart Van Assche wrote:
> There are two methods with names that are politically charged:
> slave_configure() and slave_alloc(). Shouldn't both be renamed?

Probably.  This series howerver doesn't actually renames anything,
it just adds a new method that takes the queue_limits and avoids the
name while we're at it.

> The name "device_configure" may make people wonder whether that method
> perhaps configures a struct device instance. How about using the name
> "sdev_configure" instead of "device_configure" to make it more clear
> that this method is used to configure a SCSI device?

I think device_ is probably better as it matches the target_ naming.
I could live with sdev_ if everyone else would prefer it.

Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B0BC182AE;
	Fri,  5 Apr 2024 06:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712299396; cv=none; b=PjhdXhjUJm5Mws11EbTZxMlwf58XwY+f0iizNgbUSOKhJ5MOP4ntGo2dAryR7Z4iONgBe9wVcajdmQuWwUA9ZiMX7GWfKgQM9zg67DUnWBe30Pc59VMXajNaZ2cFtYzttWyhGwj/a+E6hRDBNQRaCP5mcyMxJr1/wj+iR9Jovdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712299396; c=relaxed/simple;
	bh=tDW09LKNuTg7VM0d3/LgA++2+IuvIT7d0NN9Qin8xJQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oi2lbcScjgyhfkEzjsb5RZxcgPEMrEzgUE9l5KZ+rEdA7DP5MnT2MxgAZe8B+W/xGNnpNduZPdONQ1Ze0NmFQHyACbG4SRIs2eOXDMAgRseNAxY8Hclt3IPqnzJ1UdCw91b8NTQDLgDjIh75rNfit5Ax7VwJ0C36j/4DEKEFVQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C749268D07; Fri,  5 Apr 2024 08:43:11 +0200 (CEST)
Date: Fri, 5 Apr 2024 08:43:11 +0200
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
	megaraidlinux.pdl@broadcom.com, mpi3mr-linuxdrv.pdl@broadcom.com,
	linux-samsung-soc@vger.kernel.org, linux-usb@vger.kernel.org,
	usb-storage@lists.one-eyed-alien.net
Subject: Re: [PATCH 05/23] scsi_transport_fc: add a max_bsg_segments field
 to struct fc_function_template
Message-ID: <20240405064311.GE3480@lst.de>
References: <20240402130645.653507-1-hch@lst.de> <20240402130645.653507-6-hch@lst.de> <f272dc57-dc2c-46f2-8390-e801fa5c4bf8@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f272dc57-dc2c-46f2-8390-e801fa5c4bf8@acm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Apr 04, 2024 at 09:56:45AM -0700, Bart Van Assche wrote:
> On 4/2/24 06:06, Christoph Hellwig wrote:
>> ibmvfc only supports a single segment for BSG FC passthrough.  Instead of
>> having it set a queue limits after creating the BSD queues, add a field so
>                                                   ^^^
>                                                   BSG?

Yes, thanks.


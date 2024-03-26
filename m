Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE8FB12AAF0;
	Tue, 26 Mar 2024 06:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711433621; cv=none; b=F2X02SC8kCwFOuhlICHXaBkEk+NOAHd80XiTucQrBX7U2C1nspYf+XTtI79LIFEqPBuJyDgZ2EdxKqtDxz9FQdkKW2bTrYSgrOImOKIgQFnCxFPfpvRMQwxEMst1Ok/+4GAoUf0UnD88T7j9pJabOWegK73QaljfavQeLNWtJGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711433621; c=relaxed/simple;
	bh=DcNGe9Tk16HHRAoWEdPOBl5gcDCsDZwYgrSCwCtlhAw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VJJMAxgwzPjl5coCQLY5tl2iVFl+pZHAiAZDkDKrUBk4jHhQbVXVFn/v4MIgbEYZo+mhOg/PeQEZjR9DVFKgECaF1a3twvHWLG/X2pNJQqW5YkVEnb+FlYK6pwkexXf4vKBmC3soJ0Qbp36DIuF6j0T8WzMO3jWvP5wGFb8+vis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id AEBC068D45; Tue, 26 Mar 2024 07:13:35 +0100 (CET)
Date: Tue, 26 Mar 2024 07:13:35 +0100
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
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
	Bart Van Assche <bvanassche@acm.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Alan Stern <stern@rowland.harvard.edu>, linux-block@vger.kernel.org,
	linux-ide@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
	MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
	open-iscsi@googlegroups.com, megaraidlinux.pdl@broadcom.com,
	mpi3mr-linuxdrv.pdl@broadcom.com, linux-samsung-soc@vger.kernel.org,
	linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
Subject: Re: [PATCH 10/23] scsi: add a device_configure method to the host
 template
Message-ID: <20240326061335.GE7108@lst.de>
References: <20240324235448.2039074-1-hch@lst.de> <20240324235448.2039074-11-hch@lst.de> <6199c70e-f0a9-4756-b3fb-106985c41ebf@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6199c70e-f0a9-4756-b3fb-106985c41ebf@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Mar 25, 2024 at 04:38:43PM +0900, Damien Le Moal wrote:
> > +	if (hostt->device_configure)
> > +		ret = hostt->device_configure(sdev, &lim);
> > +	else if (hostt->slave_configure)
> > +		ret = hostt->slave_configure(sdev);
> > +
> > +	ret2 = queue_limits_commit_update(sdev->request_queue, &lim);
> 
> Why do this if ->device_configure() or ->slave_configure() failed ?
> Shouldn't the "if (ret) goto fail" hunk be moved above this call ?

queue_limits_commit_update unlocks the limits lock, which we'd
otherwise leak.  We could have a queue_limits_commit_abort, but
it seems a bit pointless.

> > +	 *
> > +	 * Note: slave_configure is the legacy version, use device_configure for
> > +	 * all new code.
> 
> Maybe explictly mention that both *cannot* be defined here ?

Will do.


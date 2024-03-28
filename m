Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AC892B9B4;
	Thu, 28 Mar 2024 05:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711602184; cv=none; b=XlDB7W3pi23g5j2eROdkH0ySo2OuNkvO17KTCuuHFRgUNZKO3Q5NLGRA/50XR9GTmaHxKnjqNbKGW7CgZbi/4RMMu3m2P4lxcU/iM9KQdAy+lI21BqJIh7UlkVdY6sVJvQSWloyoocaPP1K4JqpmbMICc2WqMsCDu8i/Ql0Cbos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711602184; c=relaxed/simple;
	bh=FSuohLyFVycqsC8R8pS+M1lZc+cDDemK4lAv98Qy8ck=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pdhK40u4ZbbZnq6UcAAddservgkS3TSpYMXj6w+Lasv5+V8R940AIKCnKucph7U9WzWxLi6bNSJ1yN2/hfG6p85Sbaohf2aBJwcYtMRddTmEz251QjHqNgsAoXzuoEq8g5osTQNJuAJga/pr6X6UTZNgWperQOpzETo16A36sko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id EE41968B05; Thu, 28 Mar 2024 06:02:56 +0100 (CET)
Date: Thu, 28 Mar 2024 06:02:55 +0100
From: Christoph Hellwig <hch@lst.de>
To: John Garry <john.g.garry@oracle.com>
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
	megaraidlinux.pdl@broadcom.com, mpi3mr-linuxdrv.pdl@broadcom.com,
	linux-samsung-soc@vger.kernel.org, linux-usb@vger.kernel.org,
	usb-storage@lists.one-eyed-alien.net
Subject: Re: [PATCH 09/23] scsi: use the atomic queue limits API in
 scsi_add_lun
Message-ID: <20240328050255.GC14655@lst.de>
References: <20240324235448.2039074-1-hch@lst.de> <20240324235448.2039074-10-hch@lst.de> <eaaf6c1d-2a7d-4a67-94e3-bd5dc4a83045@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eaaf6c1d-2a7d-4a67-94e3-bd5dc4a83045@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Mar 27, 2024 at 03:39:25PM +0000, John Garry wrote:
> Is there some reason to relocate this and have it included for other error 
> paths, i.e. queue_limits_commit_update() call? It doesn't really tell us 
> much to know the cause of the failure. At least previously it was in one 
> location, so we knew the point of failure.

I assumed an error message might be useful, but maybe it should indeed
be a different one.

Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E16C1370;
	Fri,  5 Apr 2024 06:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712298748; cv=none; b=NxpoNBdto+R2848b+tWsqT267zBYh3wV5FmPKZczrBt9BjzhAfadFkgUyyS7T3e4uGWi5Xf+y6adO3FOYclB+KADSzgtmPc1CfBYO/SxCqL8u/8VtYKiFBH9BJAWRVMxS7J7xDVgX+9CdCju1mzzX/KMzkWlgxHYxVv0p79+6mI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712298748; c=relaxed/simple;
	bh=dCGIzkI2WWywAAD+bVC9mLePlWvKEyEDzpXJWUUjq34=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Oure3q9VhY+1O1/Rk2ExlDSFOt/PbQmJKXccdA5pQ6NK4RAPzp9CDSyjMPpZYqK1MPyF6oobOXeRpkg7liMzADux5Cb4TGHBM3kHRp0dR5MCoGs8Cu3Z7Rxzg6JHrjKF1gOh+RBHAvXUjXE0TGZETw4tcVp2bwj+UVMmuDJwdIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5E9A268D07; Fri,  5 Apr 2024 08:32:20 +0200 (CEST)
Date: Fri, 5 Apr 2024 08:32:20 +0200
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
Subject: Re: [PATCH 01/23] block: add a helper to cancel atomic queue limit
 updates
Message-ID: <20240405063220.GA3480@lst.de>
References: <20240402130645.653507-1-hch@lst.de> <20240402130645.653507-2-hch@lst.de> <bb458d47-5b5a-43c0-8cae-211b82b16309@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bb458d47-5b5a-43c0-8cae-211b82b16309@acm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Apr 04, 2024 at 09:53:03AM -0700, Bart Van Assche wrote:
> At least in scsi_add_lun() there are multiple statements between
> queue_limits_start_update(), queue_limits_cancel_update() and
> queue_limits_commit_update(). Has it been considered to use __cleanup()
> to invoke queue_limits_commit_update() when the end of the current scope
> is reached? I think that would make code that uses the
> queue_limits_*_update() functions easier to verify. For an example of
> how to use the __cleanup() macro, see e.g. the __free() and
> no_free_ptr() macros in <linux/cleanup.h>.

It has been considered and rejected as this syntactic sugar might make
teenagers with attention deficit syndrome happy, but otherwise just
horribly obfuscates the code.


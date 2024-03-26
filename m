Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5E2A43AC2;
	Tue, 26 Mar 2024 06:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711433366; cv=none; b=hGdJzzF0TMbVWA62vWsBkSm+b2kpuBnsxHWIDDSMjBEWsFE5kLRDX1LeL10SswQFdq/1dSuI3IzdWYi1VNiegOB5M/VkbL3z9ibzqfcuSJ7vcM4Ak53clnEhmffSIwHZipQ9ANSZIk+8sv4z0wqZXDSiSTtqsOqXJilX8dLT9y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711433366; c=relaxed/simple;
	bh=PAyVBORsJOf54MDJupr82WTTfEjRiH2MrJbR32SeU3s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CwGbmbCHfo8GC1sIlBm330eYpCo0guCAkh2R63y7Yu91C74Eb9aG8qMmiirCdCLuy3LhhmAEG8tJWzTc5DNxVc1qYobNHrDTppKMTGEWF4aYPKmLxMGIQT59IMt9M8Qtayzqq1erqmX85USUANu2OOLLh+YozBR0cV0vx6Y4C4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A28C568D42; Tue, 26 Mar 2024 07:09:17 +0100 (CET)
Date: Tue, 26 Mar 2024 07:09:17 +0100
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
Subject: Re: [PATCH 06/23] scsi: add a no_highmem flag to struct Scsi_Host
Message-ID: <20240326060917.GC7108@lst.de>
References: <20240324235448.2039074-1-hch@lst.de> <20240324235448.2039074-7-hch@lst.de> <80162a6e-12d1-4fd4-ac74-dc5388853323@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <80162a6e-12d1-4fd4-ac74-dc5388853323@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Mar 25, 2024 at 04:26:55PM +0900, Damien Le Moal wrote:
> On 3/25/24 08:54, Christoph Hellwig wrote:
> > While we really should be killing the block layer bounce buffering ASAP,
> > I even more urgently need to stop the drivers to fiddle with the limits
> > from ->slave_configure.  Add a no_highmem flag to the Scsi_Host to
> > centralize this setting and switch the remaining four drivers that use
> > block layer bounce buffering to it.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> The USB hunks could probably be moved to their own patch following this one ?

Seems like a bit too much churn to me.

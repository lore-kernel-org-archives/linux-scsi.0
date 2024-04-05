Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEFC6182DB;
	Fri,  5 Apr 2024 06:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712298866; cv=none; b=FWQqSR56TCzJUwvAulzJwRzM/ljpWktSeCE67IcCpsBmRoquuttseiE5iRBc6mivtfQhHCLjtlii6nK4UgHfqotWqaopEoGPhk22lOYP/fJ99Rkn7LIqA6qw3fHHbr7+zeYJdxR7LOZuccpLT0+hdaOAFXFe9f0ko33lV429sHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712298866; c=relaxed/simple;
	bh=nBoSUIHaqPptaW5fhytEdqG5WKwjz01/Xr4aEricBGU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zk3Tp4kjYgZdshSJRpnjAt1CjFM2fUmDLVytdJVNqCVV3ETxNYeVS2CQUDTIkfxq2XYmDORECc7tUrt+iilCDE5+RK8sWF+Urr5gLKOqTX0if7IX9onknoMptb8iY5GivLTYE+qAzik4NBpE0cXgIL7gK/rlAZH+5Rg+x8B6TQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2BED168D07; Fri,  5 Apr 2024 08:34:19 +0200 (CEST)
Date: Fri, 5 Apr 2024 08:34:18 +0200
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
Subject: Re: [PATCH 01/23] block: add a helper to cancel atomic queue limit
 updates
Message-ID: <20240405063418.GB3480@lst.de>
References: <20240402130645.653507-1-hch@lst.de> <20240402130645.653507-2-hch@lst.de> <fd99a58b-37c4-45dd-a738-cd2b49341c70@oracle.com> <20240403125116.GA19332@lst.de> <34c1f31b-2a67-4c3d-8efa-b08a50f20e31@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <34c1f31b-2a67-4c3d-8efa-b08a50f20e31@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Apr 04, 2024 at 08:14:20AM +0100, John Garry wrote:
>
> john@localhost:~/mnt_sda4/john/linux> make C=1 block/blk-settings.o
>  UPD     include/config/kernel.release
>  UPD     include/generated/utsrelease.h
>  CALL    scripts/checksyscalls.sh
>  DESCEND objtool
>  INSTALL libsubcmd_headers
>  CC      block/blk-settings.o
>  CHECK   block/blk-settings.c
> block/blk-settings.c:263:9: warning: context imbalance in
> 'queue_limits_commit_update' - wrong count at exit
> john@localhost:~/mnt_sda4/john/linux>
>
> Is that a known issue?

I see that too, and it really confuses me as we have the proper
annotations there.  I'll see what I can do.

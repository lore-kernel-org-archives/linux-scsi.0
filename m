Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79DDA1482E1;
	Wed,  3 Apr 2024 12:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712148685; cv=none; b=Q5qzi4JZej61xCM8tarOjMd7tLC3zc61Y90H6HwA299vTa0cmS31ZbSl18ZQvF1CuXC8JIZ8RW4xVPm6/4D1ETOW46YhK4CUODhf8yCgyy7FfzdoMzpdO0PqA3PSe7kvNhNBQzX5Y82pl1Uy2LGL27upV34y/s7dkgrMtNe9yrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712148685; c=relaxed/simple;
	bh=CgSXcFQFrSihOoQEs9+0mpaB+A0EeYhWLs6ajpOaRXA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZKOO/i4z5Xkd8dfIlTslABedttyxPTCqR3vkSRedFpNnusl6DYycyUtZrlFY/q2xnSROG7HorD21iQuV7ooWL6x2tBGo4+YOCqho5WL5IQGutLXm/EYMzo/5vGDR4r7W8KzYOtbn6up2HkKuawyV7fGe7oWlRVnIQo1YGziqHH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 574DA68D05; Wed,  3 Apr 2024 14:51:17 +0200 (CEST)
Date: Wed, 3 Apr 2024 14:51:16 +0200
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
Message-ID: <20240403125116.GA19332@lst.de>
References: <20240402130645.653507-1-hch@lst.de> <20240402130645.653507-2-hch@lst.de> <fd99a58b-37c4-45dd-a738-cd2b49341c70@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fd99a58b-37c4-45dd-a738-cd2b49341c70@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Apr 03, 2024 at 08:38:42AM +0100, John Garry wrote:
>> + */
>> +static inline void queue_limits_cancel_update(struct request_queue *q)
>
> Just curious, why no __releases() annotation, like what we have in 
> queue_limits_commit_update()?

Mostly because sparse doesn't seem to actually need it on inline
functins.  At least I don't seem to get a sparse warning without it.


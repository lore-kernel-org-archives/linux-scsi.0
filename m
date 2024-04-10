Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19721BA50;
	Wed, 10 Apr 2024 04:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712723142; cv=none; b=fWAR+Bzb5VLOXNMFUAD8D1RCCs9FRRHbO9654NfN5PwjJ/3DJfM0cZyeI/FuwhSYnI65BVCpbcAxMKtF/s2VsVoxm20jA2qpvBzutK1UvQYHTPcpdg5KLLggxn+AwKZEk78mRXqB4fUfPoV4exxzUhakH1oqZG8VscFZLJrM8tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712723142; c=relaxed/simple;
	bh=4FBVoUmFN8na8de48F5/iGsG5nPf0m9yzudFippKALs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ml/9KC8c5Vbd31WSq8oCWZK5mgnvF+FTTQqvBlR+amTBRH8xG39d5lVnqlaIhM4LT5rlHYgJFeC7ymkQBLoQvRl/93HbnpE2T8qwpgS5FNgxFn6G7e28LzGToK0oG/izbvJC0AmQ1+evA5wSObEDhlfZt6uGj2+k3XTDXqHVDp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id EF67068B05; Wed, 10 Apr 2024 06:25:32 +0200 (CEST)
Date: Wed, 10 Apr 2024 06:25:32 +0200
From: Christoph Hellwig <hch@lst.de>
To: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
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
	"GR-QLogic-Storage-Upstream@marvell.com" <GR-QLogic-Storage-Upstream@marvell.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <Avri.Altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
	"linux1394-devel@lists.sourceforge.net" <linux1394-devel@lists.sourceforge.net>,
	"MPT-FusionLinux.pdl@broadcom.com" <MPT-FusionLinux.pdl@broadcom.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"megaraidlinux.pdl@broadcom.com" <megaraidlinux.pdl@broadcom.com>,
	"mpi3mr-linuxdrv.pdl@broadcom.com" <mpi3mr-linuxdrv.pdl@broadcom.com>,
	"linux-samsung-soc@vger.kernel.org" <linux-samsung-soc@vger.kernel.org>,
	"linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
	"usb-storage@lists.one-eyed-alien.net" <usb-storage@lists.one-eyed-alien.net>,
	Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 21/23] mpi3mr: switch to using ->device_configure
Message-ID: <20240410042532.GA2457@lst.de>
References: <20240409143748.980206-1-hch@lst.de> <20240409143748.980206-22-hch@lst.de> <1e41a8df-2046-45cf-8ab7-caa5839d1718@wdc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1e41a8df-2046-45cf-8ab7-caa5839d1718@wdc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Apr 09, 2024 at 03:34:13PM +0000, Johannes Thumshirn wrote:
> Why did you split this into two functions, with the innermost function 
> being only called once?
> 
> While it's slightly less of a mess to read this would be fully 
> sufficient and IMHO more readable (please excuse the whitespace damage):

Because having a helper for a specific type of device just simply
is good code struture.  It might not matter too much now, but as
soon as something else gets added your version turns into a mess
quickly.

But it turns out the rebase caused a real mess in this patch as it
marks a function static that now gets used outside the fіle in the
scsi tree, and has a weird rename in not actually visible characters,
so I'm resending it.

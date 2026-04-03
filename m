Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC4AE391E4A;
	Fri,  3 Apr 2026 09:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.149.199.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775209424; cv=none; b=uFpXzibExkaNYm6Lr53cxsZ3ksniCLcnssPgvynoyjBjZvWyakLU6Uk6sBBEe3DJWQmckMVcidBO82M+uLaiS7xGJmVqPa8BKtu2CHIPpGPmOX3gadIPaKboGGp6xkTeHyasoZcYOJ+8v/zuefqiteA2oe5eNzBPbGbaKI1aZEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775209424; c=relaxed/simple;
	bh=fWHX2TSXG7hhC1VwHCnsCjqhyvpmNrWLlMLNWAssQjM=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=MCWN43xQ6cy6CDgMYoYdxazjz8QoR1ZtkgLoA8s6/GnGFGEmeyEktzkkH2GZ2GSPYCo/vTMBDdXdTThgUURpALZ2PM7iGBCzl3bAl55UYhz6mBTGPaGvAhq0fuP4TN+S/Ht33rIIvGeNZxDNtmxEddDmfscKQRvINvLtAxBHtzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru; spf=pass smtp.mailfrom=ispras.ru; dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b=ArS3juWV; arc=none smtp.client-ip=83.149.199.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ispras.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b="ArS3juWV"
Received: from localhost (unknown [10.10.165.6])
	by mail.ispras.ru (Postfix) with ESMTPSA id 8FFDF40737CA;
	Fri,  3 Apr 2026 09:43:37 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 8FFDF40737CA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
	s=default; t=1775209418;
	bh=BlTGqnCJGh4mB5RDKBN0tAN5xbPo1gnzhzo9p74pj1Y=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=ArS3juWVKe95xJXrOX2F6Ro0yZ8cseolXjAQ6iDUHnykQIiPxXKnylqzTCAnec2B8
	 q535YNWxALE+971ppWvQ43SqWyBv38lZaCMpA0iGwTw8p0Madg3maVBBl5//FHUIaw
	 ZiJGLy4cUxRlmBaihFSGjT1GykEtfuoERsRO8eis=
Date: Fri, 3 Apr 2026 12:43:37 +0300
From: Fedor Pchelkin <pchelkin@ispras.ru>
To: "Heyne, Maximilian" <mheyne@amazon.de>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>, 
	Ming Lei <ming.lei@redhat.com>, Keith Busch <kbusch@kernel.org>, Yi Zhang <yi.zhang@redhat.com>, 
	Jens Axboe <axboe@kernel.dk>, Hector Martin <marcan@marcan.st>, 
	Sven Peter <sven@svenpeter.dev>, Alyssa Rosenzweig <alyssa@rosenzweig.io>, 
	Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
	"James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, 
	Bart Van Assche <bvanassche@acm.org>, Sasha Levin <sashal@kernel.org>, 
	Peter Wang <peter.wang@mediatek.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Seunghwan Baek <sh8267.baek@samsung.com>, Seunghui Lee <sh043.lee@samsung.com>, 
	Adrian Hunter <adrian.hunter@intel.com>, Brian Kao <powenkao@google.com>, 
	Sanjeev Yadav <sanjeev.y@mediatek.com>, Wonkon Kim <wkon.kim@samsung.com>, 
	Chaitanya Kulkarni <kch@nvidia.com>, Hannes Reinecke <hare@suse.de>, 
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"asahi@lists.linux.dev" <asahi@lists.linux.dev>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 6.1.y v2 6/6] nvme: fix admin queue leak on controller
 reset
Message-ID: <20260403123652-2fd721d0de63be980e2ec1e9-pchelkin@ispras>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260402-fox-attic-82ebf113@mheyne-amazon>

"Heyne, Maximilian" <mheyne@amazon.de>
> [ Have to do analogous work in nvme_pci_alloc_admin_tag_set in pci.c due
>   to missing upstream commit 0da7feaa5913 ("nvme-pci: use the tagset
>   alloc/free helpers") ]

nit: not actually needed for 6.1.y because the only callsite of
nvme_pci_alloc_admin_tag_set() there looks like

	if (!dev->ctrl.admin_q) {
		result = nvme_pci_alloc_admin_tag_set(dev);

Though that doesn't really matter and not worth resending I think.

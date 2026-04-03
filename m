Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C5E030DEDD;
	Fri,  3 Apr 2026 09:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.149.199.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775208935; cv=none; b=uhgdgv465YTL0hr9O+4XXAfnE3VssrH1VEqsZjl30B1yzDnTMxI5xkqC/MmQmNLDAVv6NLkUjgfBl3vl8P8IRHDfCWEHaAndZY40a2EOlsHC5a0vEXydLsj6Lhr3axJUfETYnEYK1DGDolN2LwuOeDZgddLIwo2h+KaN+nBEDvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775208935; c=relaxed/simple;
	bh=Jmc+hkmsMikTsNMDPR+G4B5+RqIPC+V1ZU0stJu42kM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QpL9kErO6beUcADouctRv95aXgU5k80oXuM5SzzW2AIWqep3Ls5VKJgfEBqFqmLcAyldrF/GHs8/70tahG/dPbb9Fb3U8khNliqwo/JaWRQ9a4b9kKu5Td3khGYJZNpYR/vRnmLvMiOZHkKpRLJcAQCL4oSx3d3VmCsdXa6FGLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru; spf=pass smtp.mailfrom=ispras.ru; dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b=kkajyW/M; arc=none smtp.client-ip=83.149.199.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ispras.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b="kkajyW/M"
Received: from localhost (unknown [10.10.165.6])
	by mail.ispras.ru (Postfix) with ESMTPSA id 7C6E8406C750;
	Fri,  3 Apr 2026 09:35:22 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 7C6E8406C750
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
	s=default; t=1775208922;
	bh=wlvLXwJfFjZbNs8KeJ75jbz3sMVhqOGXKKb58Lo082A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kkajyW/MO2/WOtf2CjU7BA1zf+P12pO0nzZUK3ic6z9goAhAh/LpcCOw758fUn1+l
	 pjThZBskY0/QlKbnsWNFBMbHwoP0x0TK8fopvjnWZNjQc5p3bgHz9sYLL2qUY4leqf
	 ePN3zoAj1yOaWjRBs6Nf1aFS61xyY8SnKLCM1bbg=
Date: Fri, 3 Apr 2026 12:35:22 +0300
From: Fedor Pchelkin <pchelkin@ispras.ru>
To: "Heyne, Maximilian" <mheyne@amazon.de>
Cc: Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
	"stable@vger.kernel.org" <stable@vger.kernel.org>, Sven Peter <sven@svenpeter.dev>, 
	Chaitanya Kulkarni <kch@nvidia.com>, Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	Hector Martin <marcan@marcan.st>, Alyssa Rosenzweig <alyssa@rosenzweig.io>, 
	"James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, 
	Bart Van Assche <bvanassche@acm.org>, Sasha Levin <sashal@kernel.org>, 
	Peter Wang <peter.wang@mediatek.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Seunghui Lee <sh043.lee@samsung.com>, Sanjeev Yadav <sanjeev.y@mediatek.com>, 
	Wonkon Kim <wkon.kim@samsung.com>, Brian Kao <powenkao@google.com>, Hannes Reinecke <hare@suse.de>, 
	Ming Lei <ming.lei@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "asahi@lists.linux.dev" <asahi@lists.linux.dev>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 6.1.y 5/8] nvme-apple: remove an extra queue reference
Message-ID: <20260403123041-90f6c38394b8f71e66844864-pchelkin@ispras>
References: <20260401-pliny-ashley-ff03a0b6@mheyne-amazon>
 <20260401232116-53765a086f3855a30962fb81-pchelkin@ispras>
 <20260402-anti-cuba-1ea02cea@mheyne-amazon>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260402-anti-cuba-1ea02cea@mheyne-amazon>

On Thu, 02. Apr 12:31, Heyne, Maximilian wrote:
> On Wed, Apr 01, 2026 at 11:45:57PM +0300, Fedor Pchelkin wrote:
> > Hello,
> > 
> > "Heyne, Maximilian" <mheyne@amazon.de> wrote:
> > > From: Christoph Hellwig <hch@lst.de>
> > > 
> > > [ Upstream commit 941f7298c70c7668416e7845fa76eb72c07d966b ]
> > > 
> > > Now that blk_mq_destroy_queue does not release the queue reference, there
> > > is no need for a second admin queue reference to be held by the
> > > apple_nvme structure.
> > 
> > This patch is probably buggy in upstream.  It removes extra reference
> > ->get, but doesn't remove the corresponding ->put which is located
> > inside apple_nvme_free_ctrl().
> 
> Now I'm seeing this as well. Has the same problem as the pci driver in
> 6.1 where blk_put_queue is called from nvme_free_ctrl() and again from
> apple_nvme_free_ctrl(). Thank you for catching this. I don't have the
> hardware to test this.
> 
> Are you going to send a fix upstream? It's looks to be broken on master,
> too.

I don't have the needed hardware either but will send the patch for review.

> > 
> > That said, the other part of the backport series FWIW looks good to me,
> > and I've also verified it resolves the 6.1.y regression.
> 
> You may leave a Tested-by if you want ;-)

I'll leave it for v2 then.

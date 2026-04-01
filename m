Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 495DA37C935;
	Wed,  1 Apr 2026 20:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.149.199.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775076362; cv=none; b=PAZBwn5TEAJAQzleBHVpz5tufhynSRh7g2Jat3YEh+uuoQRws+u3BdFC27FxSmR0hNMDloWpiSuRHY7gmn0nC1rmoBwE3jzRsOkj7JvLWzJhXL/+kQ4KSmdirYqV7JNndORSdjD5BAZbREdxKa0jbv89m9dwzXccNT53+a5/e/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775076362; c=relaxed/simple;
	bh=PnadoJZ2TluITYj2qQtgiYK2s1CHLRGKtL3HYGaw3qI=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=NXqYSQa3zl8j7aJKDARBHheuySCayck+zgiIufcLCUixXTZiOWhKhrQRiNYCpy/kK8CEMo12C4cSAyTTWoMM0QUhjyc7FjHS6zNqjt5BA2ZCyU70chfZn5sD9bnQb/zHRq0xk1gEeaZBe0jhpWqgUGndoVtgzQxcP4khz/Hg8qU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru; spf=pass smtp.mailfrom=ispras.ru; dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b=i7DBaSK7; arc=none smtp.client-ip=83.149.199.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ispras.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b="i7DBaSK7"
Received: from localhost (unknown [10.10.165.9])
	by mail.ispras.ru (Postfix) with ESMTPSA id 70C5D4077929;
	Wed,  1 Apr 2026 20:45:57 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 70C5D4077929
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
	s=default; t=1775076357;
	bh=YECgA1W4XiOu+H+V0hPI++cSywV+2xeI4LnbCk8QRLE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=i7DBaSK7MEMLzy87dC5qHlcQ93SYuEV6yJqTixIYcNJ1p9nCSDtLw1Z3hl8r7+DnU
	 /CvrNpMt1BEO98BehFHFa/byL7S5z7i1crJOk95P9u2BgPkbx8e8592n9n6F+xWtU+
	 e8zFXYqrDaK8Mq2lxFQsNxD1fzxrRX7CuMZ2P0vI=
Date: Wed, 1 Apr 2026 23:45:57 +0300
From: Fedor Pchelkin <pchelkin@ispras.ru>
To: "Heyne, Maximilian" <mheyne@amazon.de>, Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagi@grimberg.me>, 
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
Message-ID: <20260401232116-53765a086f3855a30962fb81-pchelkin@ispras>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260401-pliny-ashley-ff03a0b6@mheyne-amazon>

Hello,

"Heyne, Maximilian" <mheyne@amazon.de> wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> [ Upstream commit 941f7298c70c7668416e7845fa76eb72c07d966b ]
> 
> Now that blk_mq_destroy_queue does not release the queue reference, there
> is no need for a second admin queue reference to be held by the
> apple_nvme structure.

This patch is probably buggy in upstream.  It removes extra reference
->get, but doesn't remove the corresponding ->put which is located
inside apple_nvme_free_ctrl().

I'm reporting here currently just for the heads up - was looking at the
same nvme regression problem at 6.1.y, found this thread, and the
nvme-apple changes appeared suspicious.

nvme-apple patch is not required to fix the regression (this also holds
true for [PATCH 6.1.y 3/8] scsi: remove an extra queue reference).  Maybe
they shouldn't go to stable.

That said, the other part of the backport series FWIW looks good to me,
and I've also verified it resolves the 6.1.y regression.

Thanks.

> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
> Reviewed-by: Sven Peter <sven@svenpeter.dev>
> Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
> Reviewed-by: Keith Busch <kbusch@kernel.org>
> Link: https://lore.kernel.org/r/20221018135720.670094-5-hch@lst.de
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Maximilian Heyne <mheyne@amazon.de>
> ---
>  drivers/nvme/host/apple.c | 9 ---------
>  1 file changed, 9 deletions(-)
> 
> diff --git a/drivers/nvme/host/apple.c b/drivers/nvme/host/apple.c
> index c5fc293c22123..c84ebfcfdeb88 100644
> --- a/drivers/nvme/host/apple.c
> +++ b/drivers/nvme/host/apple.c
> @@ -1507,15 +1507,6 @@ static int apple_nvme_probe(struct platform_device *pdev)
>  		goto put_dev;
>  	}
>  
> -	if (!blk_get_queue(anv->ctrl.admin_q)) {
> -		nvme_start_admin_queue(&anv->ctrl);
> -		blk_mq_destroy_queue(anv->ctrl.admin_q);
> -		blk_put_queue(anv->ctrl.admin_q);
> -		anv->ctrl.admin_q = NULL;
> -		ret = -ENODEV;
> -		goto put_dev;
> -	}
> -
>  	nvme_reset_ctrl(&anv->ctrl);
>  	async_schedule(apple_nvme_async_probe, anv);
>  
> -- 
> 2.50.1

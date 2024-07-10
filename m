Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D11881AB6;
	Wed, 10 Jul 2024 07:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720595682; cv=none; b=fwTsgjMhNo9wImCugDUw2gOaHc4pb5vyxfnn/rF/HMvzxwLhctQIi747/ivo2lUnL6tK/KdqLYOgOGx1hIVgclwX89hwbaDYQ/Li7uJQjPLDbz4RhoI98Je+UQURcZ3ENXuLKKWP5iTyP0ICZmJXhIiE6yyn1mWlRcCD8nKDfYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720595682; c=relaxed/simple;
	bh=ZIpn7wnJpGQcUsHVM4ecFAZEzbyjpH+DlQIGSO1YPig=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y0/od7WlZb4sqaFa4tL6yoXLJMdJK/vKMuJGcWhUWOa4cjITMreFaDPUZGnplxHRNY4oAbRZ8WPL/ceQZelxtsnkZHkVogOuqKUZPpGbe2LBnVSz71DBjvOZIZgEspfV2sfhUUR2EAl95PJrdJ95EeEFFylDOK1DNRrT66B0/hA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 71165227A87; Wed, 10 Jul 2024 09:14:35 +0200 (CEST)
Date: Wed, 10 Jul 2024 09:14:35 +0200
From: Christoph Hellwig <hch@lst.de>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: linux-block <linux-block@vger.kernel.org>, linux-scsi@vger.kernel.org,
	open list <linux-kernel@vger.kernel.org>,
	lkft-triage@lists.linaro.org, Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	Chaitanya Kulkarni <chaitanyak@nvidia.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Anders Roxell <anders.roxell@linaro.org>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>
Subject: Re: next-20240709: kernel BUG at drivers/scsi/scsi_lib.c:1160! -
 WARNING: block/blk-merge.c:607 __blk_rq_map_sg
Message-ID: <20240710071435.GA26861@lst.de>
References: <CA+G9fYuSAE=WjPBDQ=rTLdVit2A6aay_cQHKreJ02FFGFU+vSQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYuSAE=WjPBDQ=rTLdVit2A6aay_cQHKreJ02FFGFU+vSQ@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jul 10, 2024 at 12:36:42PM +0530, Naresh Kamboju wrote:
> The arm64 Juno-r2 boot failed due to boot BUG and Warnings [1] while booting
> Linux next-20240709 tag kernel.

The fix is here:

https://git.kernel.dk/cgit/linux-block/commit/?h=for-6.11/block&id=61353a63a22890f2c642232ae1ab4a2e02e6a27c


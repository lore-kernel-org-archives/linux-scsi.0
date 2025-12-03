Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C6291F4181;
	Wed,  3 Dec 2025 07:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764747544; cv=none; b=dpJXYPlJMWf1nDZLCMs3b8P7wqmKMPqWeRXobRj3sK2zjXe1GfSSU1tctVMuXKwBpS77HlF2x3mV6fBUIJk3hMM7rYpxLqZnQmpJm2bGcCjEaulGaWKhZwLLbZ4hZUAqKifuY2mZumNf2V8QDFnKsuWiweIFAjlIpfcRoJTNL10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764747544; c=relaxed/simple;
	bh=UTQxlf6B0OArOOGobjR4wVur08lAadkrV6siDjLuBT4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HwAWwxtXr+M8N6XkK5vU7sluA8COwZ+zF6JI3s30Wl7Nvgh9c0MJBWZKOCVcqyrNgUvNn2FlFBEzPpTHOQ6BtEl5de/d4uq5lb+ekIEJT6ccYcujdrUI0mGCNmggfHo5LcsYIFe3o9ce5oMjX/asdXdkV3rL+eN1HJ9KJHZDokw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=db+tkzQW; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="db+tkzQW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=9OwsHs+J9aAz5y1eOeeUNPQgKZMHcOFkUB7eJml93tA=; b=db+tkzQW5Fn4yiZAGPHMB95iY0
	Lo0Yb7W7oxgGP/E+LkPxvlFqJYIC/r/DNvuG/1Y97liwAQZuRoPbj4y64lSfTgkKl7J6yVUqavkTW
	1ib+H6VHbDQkuDNFywuKKIkwCEmSwvFAUmt/w6iH13N4ks6cONR1LFjPOcU9f6Oviggih7rqpUVz2
	ZjID3y/Xef83jC860SFuk0AB6fgLNCAtnF+pl/840XhUkd3x/xDvPkvykUDWuvmzML3eEBTk6lPvV
	M9a7tySZd/2TX0pO5zCF65HZVcHrr0TFuRsPta9GKt6NnHT7iXUDxSAnEk4FV+ZyJNVyTTDG1o7bt
	YhpDZ3zA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vQhRz-00000006GSc-2Jew;
	Wed, 03 Dec 2025 07:38:59 +0000
Date: Tue, 2 Dec 2025 23:38:59 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Po-Wen Kao <powenkao@google.com>, Hannes Reinecke <hare@suse.com>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	"open list:SCSI SUBSYSTEM" <linux-scsi@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/1] scsi: core: Fix error handler encryption support
Message-ID: <aS_pE4nf7wQ031Y8@infradead.org>
References: <20251203073310.2248956-1-powenkao@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251203073310.2248956-1-powenkao@google.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Dec 03, 2025 at 07:33:08AM +0000, Po-Wen Kao wrote:
> From: Brian Kao <powenkao@google.com>
> 
> Some low-level drivers (LLD) access block layer crypto fields, such as
> rq->crypt_keyslot and rq->crypt_ctx within `struct request`, to
> configure hardware for inline encryption.

So don't do that except for commands that can actually be encrypted,
i.e. those that have non-zero payload size.  I think you really want
to fix this in the driver.

And we really need to stop passing scsi_cmnds to the error handler.

Hannes, any chance you could send another batch of your decades old
series?


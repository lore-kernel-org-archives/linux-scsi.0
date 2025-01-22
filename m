Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E129813213E;
	Wed, 22 Jan 2025 06:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737527579; cv=none; b=Nm7AUTAC/uZ1Esox8qgh/iV4c2/qOjDRbSq0RQWpGeXFJXxXBcV8w1XnDuZ81yBWaQ0bzKH7k1WGfaT1ACb9oORiAt3d9ycJGblnKGYnu+8crrS/vS3hzYfbLytwxo4RemtOlqZnsues1ABNHmmc+8LmaTKBNc6wm1JBGn5i1OE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737527579; c=relaxed/simple;
	bh=GYJzEwIQBHEGL7aDYcJ5bTXyzU9977MRchbIzgX7Uuk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SCZrJFW0XpcyqVtrYz+0rk/7fpVSUa/TGD24bLbptNwTH2RQPeUVMmtS5QFt9yuHqvoNOaqVtwpVPnITarSUoRtE95QmbGXG5JfhXRX1tsdK8vaxJAyxmR5/U0leUv3QD4gU8+TN9a6hCjQxghEl0bCb9wvEV+LfuTqpizDc1Bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5197C68D05; Wed, 22 Jan 2025 07:32:51 +0100 (CET)
Date: Wed, 22 Jan 2025 07:32:51 +0100
From: Christoph Hellwig <hch@lst.de>
To: Ming Lei <ming.lei@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org, nbd@other.debian.org,
	ceph-devel@vger.kernel.org, virtualization@lists.linux.dev,
	linux-mtd@lists.infradead.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/2] loop: force GFP_NOIO for underlying file systems
 allocations
Message-ID: <20250122063251.GA31207@lst.de>
References: <20250117074442.256705-1-hch@lst.de> <20250117074442.256705-2-hch@lst.de> <Z4pFgIqB50gz-ODi@fedora>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z4pFgIqB50gz-ODi@fedora>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Jan 17, 2025 at 07:56:48PM +0800, Ming Lei wrote:
> If we call memalloc_noio_save() here, setting PF_MEMALLOC_NOIO can be removed
> from loop_process_work().

Nah, we can skip this patch as the explicit PF_MEMALLOC_NOIO does
everything that is needed.


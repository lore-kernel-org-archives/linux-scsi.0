Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D48F31DEFC2;
	Fri,  8 Nov 2024 14:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731075539; cv=none; b=lY1T9v4xyNhJuMl8stlO82K8xlAaXtlMZaJvVzrwGQKOyqP2s4dVjg1I6R2QjKPQWfp2BPJVfWIRSJi/ocGVlncZ1c7rmPX+/jKmZR6wwTSkBSxCjawFOcYJAU81vXEX2WHtd7Fqh4mKvt43/Lq6S6hb6jRUY3XYfP+fQrKcHnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731075539; c=relaxed/simple;
	bh=wu1DyLSHOo07HRiMezhZbAOQ8LtbfG7jGzBdKusNcOE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UPaLvYaMjF2Gpw3LiRHoKtXChLgz1f0vhiYFoSNNkWmPnEPOioaic2VMtCdsuIT1nLNLa/dxiNRxaxxQpGIhvhLNt6Mv/jDihzUIqLWjeHQUfz0EKYZ7ZH9bfgCv08QhMC/wHIa3hLxXKvVI2xQjhR4rpmn9DuTCHEHxqy1HxJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1458168AA6; Fri,  8 Nov 2024 15:18:53 +0100 (CET)
Date: Fri, 8 Nov 2024 15:18:52 +0100
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@meta.com>,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, io-uring@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, joshi.k@samsung.com,
	javier.gonz@samsung.com, bvanassche@acm.org
Subject: Re: [PATCHv10 0/9] write hints with nvme fdp, scsi streams
Message-ID: <20241108141852.GA6578@lst.de>
References: <20241029151922.459139-1-kbusch@meta.com> <20241105155014.GA7310@lst.de> <Zy0k06wK0ymPm4BV@kbusch-mbp>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zy0k06wK0ymPm4BV@kbusch-mbp>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Nov 07, 2024 at 01:36:35PM -0700, Keith Busch wrote:
> The zone block support all looks pretty neat, but I think you're making
> this harder than necessary to support streams. You don't need to treat
> these like a sequential write device. The controller side does its own
> garbage collection, so no need to duplicate the effort on the host. And
> it looks like the host side gc potentially merges multiple streams into
> a single gc stream, so that's probably not desirable.

We're not really duplicating much.  Writing sequential is pretty easy,
and tracking reclaim units separately means you need another tracking
data structure, and either that or the LBA one is always going to be
badly fragmented if they aren't the same.

Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB8BF1B4248;
	Fri, 10 Jan 2025 09:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736501599; cv=none; b=dXgMu2AcmWlfp0d/NrDMDT56uH7CpRsQSO/bRuOju+Df4hNMA3u7iivbDQXLNN68nDGm9YfFMhWsrTw2Xwp0DxYCWHvBZBFl/CXMqS9n+9Kn4B40fUpgo5CUTdBt9BSrNXB37TXHIKYIcZIq8e1QuonV/MI3VTyYNYesZCf5A/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736501599; c=relaxed/simple;
	bh=LSZZQLHEUL35al6IQQVXAzakwnVJ1OwQSLU2c936n7k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XGIrJTdhT52x4d6TCk6yStW+KhcguEWX0M/akEL4Y+AZcN2C7vUtkW02coGjIFqDJ/MFbD/YS+WIQzxCtHRqE9NwjJIOWjcS1E5JmvJn21PqRexa24QN06/c5HZZYs0yi+WRdo92F3r1ucU0eWgbtpGHtM8/OiXwmletViH93qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B95E868BFE; Fri, 10 Jan 2025 10:33:11 +0100 (CET)
Date: Fri, 10 Jan 2025 10:33:11 +0100
From: Christoph Hellwig <hch@lst.de>
To: John Garry <john.g.garry@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Damien Le Moal <dlemoal@kernel.org>, Ming Lei <ming.lei@redhat.com>,
	Nilay Shroff <nilay@linux.ibm.com>, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, nbd@other.debian.org,
	linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: Re: [PATCH 06/11] block: fix queue freeze vs limits lock order in
 sysfs store methods
Message-ID: <20250110093311.GA9083@lst.de>
References: <20250109055810.1402918-1-hch@lst.de> <20250109055810.1402918-7-hch@lst.de> <8cfe7690-0101-42e7-ba97-6c6b717c4706@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8cfe7690-0101-42e7-ba97-6c6b717c4706@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jan 09, 2025 at 01:07:47PM +0000, John Garry wrote:
> Do you mean that the sysfs_lock could be removed in future? I would have 
> thought that queue limits lock could be used for the same thing, but I am 
> probably failing to see some lock nesting/ordering issues...

More or less.  Think about it: what does it even try to protect?

Readіng/writing sysfs files vs itself and file removal it serialized by
sysfs/kernfs internally.

Any information tweaked in sysfs usually also has other places that can
modify it.  So we'll need a lock independent of sysfs for that anyway.
A big part, buy by far all of that is covered by limits_lock.

Serializing creating/removing sysfs attribues is supposed to be
serialized using sysfs_dir_lock, although that needs a careful audit.

It's also used to serialize a few debugfs things, but we'll need to look
carefully for what exactly and switch that over to debugfs_mutex or
something new.

And then there's a bunch of misc cruft that also needs a careful look.

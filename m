Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFF4F20A5C7;
	Fri, 10 Jan 2025 09:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736502969; cv=none; b=Y55KLZBnWBGm0BehIRbycItVLeBjdPU7+HO0nAvSlZSTl+FiA0rK8Jd+3zZNiADDU+4uEowRQWWxrYxpmtw5G26TgcMrTRxSqHgf5GhYChk0gOo/uWS88WyxQkUKlc9J3b+XTBBByDTu6I24Bd1e2wAr1HtLWMquVEwKMja1hb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736502969; c=relaxed/simple;
	bh=Rsah2nVlCaQlYNq1lBFnL4teOk02ZxM6goCGCU3OFD0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WVuWrkDNnyCmtO187SsWNeI/ha5jhJS8zJuC/RTolMPtM2gxbu8lFRe292yhkj99784albvLPjpjwV9vHGZnuf56fPUtUcAk0Efp9FJ67t+nnIC6xvt2KRCoHGS/2LlTFSOGBIjX0ECnSWfgDw5/R1Xh7NMpJtFoor0Wv0oc+24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 32AEA68BFE; Fri, 10 Jan 2025 10:56:01 +0100 (CET)
Date: Fri, 10 Jan 2025 10:56:01 +0100
From: Christoph Hellwig <hch@lst.de>
To: John Garry <john.g.garry@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Damien Le Moal <dlemoal@kernel.org>, Ming Lei <ming.lei@redhat.com>,
	Nilay Shroff <nilay@linux.ibm.com>, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, nbd@other.debian.org,
	linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: Re: [PATCH 05/11] block: add a store_limit operations for sysfs
 entries
Message-ID: <20250110095601.GA11121@lst.de>
References: <20250110054726.1499538-1-hch@lst.de> <20250110054726.1499538-6-hch@lst.de> <e7177a33-aebd-4828-87b0-f790b4fb1306@oracle.com> <20250110091859.GA8373@lst.de> <68cd5371-f4ca-44c0-8ac7-c734da04f877@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68cd5371-f4ca-44c0-8ac7-c734da04f877@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Jan 10, 2025 at 09:51:18AM +0000, John Garry wrote:
> ok, and that just comes down to the behavior of queue_var_store(), which 
> mimics sysfs_ops.store
>
> I will note that queue_var_store and queue_var_store64 differ in behaviour 
> here :(
>
>> ->store_limits uses
>> the simpler and harder to get wrong convention of returning 0 on
>> success.
>>
>
> understood, so any reason why not to change the rest (apart from being 
> busy)?

Not real urge.  The idea here was to get it right for the new one.
Changing the existing would be a lot of churn for a relatively small
improvement.  For me that's only worth it when touching the area anyway.
Which might or might not happen when trying to remove the sysfs_lock
around ->store.


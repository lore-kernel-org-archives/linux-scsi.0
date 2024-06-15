Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C13FF2905;
	Sat, 15 Jun 2024 05:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718427690; cv=none; b=nIx7PY4A7A2vSki5YA8447yrfuv6tcllsi4ZISJ9UXmmSyEDmlfMSEWF/O1BeTDbHUKjKA6/EkqCS9dlZRipJ1sLAkl0R8oKAzqRymWATF1nu35DHjCbMjxI6SGZksD9WUj3sYZFUQbnrOTdTXiWvH1/WOwEtIIviVvmVfA3meQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718427690; c=relaxed/simple;
	bh=wqnpxKSvD4j/iASUgryWwC28WqjKo0vTXEi/iwMVw6g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PvJWbeJg/omyv5e+kGGQQC9Qrbb20QrTczjl6AN+GdT+xKxHKBRgs4p25F+b0GZnNymKsSdIYxeAijVmuPO50AoUcC7P6nL3S2L8kNjB6Ve6p9XQB8DQEaD/R24bdauqOYqupYZqAStF0aTa7vRE6/3d3J8pd2t3NWV+GysHfGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C5DAE68D07; Sat, 15 Jun 2024 07:01:21 +0200 (CEST)
Date: Sat, 15 Jun 2024 07:01:20 +0200
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>, Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>, linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org
Subject: Re: move integrity settings to queue_limits v3
Message-ID: <20240615050120.GA28819@lst.de>
References: <20240613084839.1044015-1-hch@lst.de> <f134f09a-69df-4860-90a9-ec9ad97507b2@kernel.dk> <20240614160322.GA16649@lst.de> <af0144b5-315e-4af0-a1df-ec422f55e5be@kernel.dk> <20240614160708.GA17171@lst.de> <6c5d4295-098c-4dc2-8ad2-f747a205f689@kernel.dk> <2fb3fc18-64fb-4a12-9771-3685111fd19f@kernel.dk>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2fb3fc18-64fb-4a12-9771-3685111fd19f@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Jun 14, 2024 at 10:23:33AM -0600, Jens Axboe wrote:
> Done, both series are in for-6.11/block-limits. It's pulled into the main
> block branch as well, but SCSI can pull it too as needed.

Thanks.  Btw, both this and the md branch now have versions of the
raid0 and raid1 use after free on failed ->run fixes.  Maybe drop them
from for-6.11/block-limits given that they've been picked up by the
md branch you've pulled.  They might even be 6.10 candidates given
that they can easily be triggered (although only by root).


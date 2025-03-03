Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8161212FBC;
	Mon,  3 Mar 2025 14:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741011093; cv=none; b=UKhSaeBvyhA318lnxp25lenv5PO/l7zwZ7qJRjy+INKy0RQ3fcvXuNiV50mcROZ4AXybgw10ikpqyuIqj+S1z5eRwuQKh5PHfr6FxzmB5M5TuvcOnGWDxVHeuWwVdXdirqSWOoiplXAewqeFRFfmMFZRYoTP8/R8h9tfgmw9tlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741011093; c=relaxed/simple;
	bh=PC7oQKyzC4j92ej9Wia77BdeaPQqrnIrA3/FK24PbL0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=agkhxYFRJmiXgwoWbI7AljymEYMvo9KK5spbZjMqnoAge1fhemnduoYWHv5wMkgUSZhKPIrcszYeU+sJwWl8o70Sv9ivU0Qrsu17vf6Ee5wATDtubQn0i/w4YYJvgHDzEPIXfjUjprD9T2/uIEDQFbyXKpb2SgTqnzdP+39D1oY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6106768CFE; Mon,  3 Mar 2025 15:11:26 +0100 (CET)
Date: Mon, 3 Mar 2025 15:11:26 +0100
From: Christoph Hellwig <hch@lst.de>
To: Anuj Gupta <anuj20.g@samsung.com>
Cc: axboe@kernel.dk, martin.petersen@oracle.com, anuj1072538@gmail.com,
	nikh1092@linux.ibm.com, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
	dm-devel@lists.linux.dev, M Nikhil <nikhilm@linux.ibm.com>
Subject: Re: [PATCH v2 2/2] block: Correctly initialize
 BLK_INTEGRITY_NOGENERATE and BLK_INTEGRITY_NOVERIFY
Message-ID: <20250303141126.GA16268@lst.de>
References: <20250226112035.2571-1-anuj20.g@samsung.com> <CGME20250226112859epcas5p2b97647182f58b4c6514326cf497e3fdb@epcas5p2.samsung.com> <20250226112035.2571-3-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250226112035.2571-3-anuj20.g@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Feb 26, 2025 at 04:50:35PM +0530, Anuj Gupta wrote:
> Currently, BLK_INTEGRITY_NOGENERATE and BLK_INTEGRITY_NOVERIFY are not
> explicitly set during integrity initialization. This can lead to incorrect
> reporting of read_verify and write_generate sysfs values, particularly when
> a device does not support integrity. This patch ensures that these flags
> are correctly initialized by default.

You don't need to stay "this patch" in a commit log, just state what
it is doing.  Also please wrap commit log lines at 73 characters.

The code changes themselves here look good.


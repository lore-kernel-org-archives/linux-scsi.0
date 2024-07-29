Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D876715DBA3;
	Mon, 29 Jul 2024 17:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722272596; cv=none; b=ampGBIJtiIwM0T0zHalzv9Ny5u4HBewvQV1j6kO0LMtqveDQg5OZ4TyGSrr0dtj7KBiN2Pb3pfTN5AQmr2d/ckxdO0rHPmlulkY152GGv+jj0H6PytYoKpXdMIvVLAc0nsZfjheKU3GrJQ3/WA3ZEyKuGFauw/P25K1n6foX3dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722272596; c=relaxed/simple;
	bh=vTdmm85VXx0fxyq4pl51cOePcRd+npUcY+OXXqyjETM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IzTzPBJUXPGObOEA1HRFzkI6VM8Pb+oUBFJJj23MsqKRnw/RiCVetBHySFUfoEofmap1doPbRjEZ3cC/m2hdqpAP9OGgmAQ7fkjALQv93DdJx1Ulrp1F7gTL8YhU1wDIg/4+bsKDTq/AE+KmPJDgX6ohxeJYMCxgrT/BxiNeA1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id DCA0968B05; Mon, 29 Jul 2024 19:03:08 +0200 (CEST)
Date: Mon, 29 Jul 2024 19:03:08 +0200
From: Christoph Hellwig <hch@lst.de>
To: Anuj Gupta <anuj20.g@samsung.com>
Cc: Christoph Hellwig <hch@lst.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Kanchan Joshi <joshi.k@samsung.com>, linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
Subject: Re: fine-grained PI control
Message-ID: <20240729170308.GA31298@lst.de>
References: <20240705083205.2111277-1-hch@lst.de> <yq1ttgz5l6d.fsf@ca-mkp.ca.oracle.com> <CGME20240709071611epcas5p1c5f2b59325d562658522842f89a31861@epcas5p1.samsung.com> <20240709071604.GB18993@lst.de> <20240726102156.GA17572@green245>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240726102156.GA17572@green245>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Jul 26, 2024 at 03:51:56PM +0530, Anuj Gupta wrote:
> 
> I was thinking something like below patch[*] could help us get rid of the
> BIP_USER_CHECK_FOO flags, and also driver can now check flags passed by block
> layer instead of checking if it's user passthrough data. Haven't plumbed the
> scsi side of things, but do you think it can work with scsi? 
> 
> Subject: [PATCH] block: introduce BIP_CHECK_GUARD/REFTAG/APPTAG bip_flags
> 
> This patch introduces BIP_CHECK_GUARD/REFTAG/APPTAG bip_flags which
> indicate how the hardware should check the payload. The driver can now
> just rely on block layer flags, and doesn't need to know the integrity
> source. Submitter of PI chooses which tags to check. This would also
> give us a unified interface for user and kernel generated integrity.

This looks reasonably to me for the in-kernel interface.  We'll still
need to deal with the fact that SCSI is a bit selective in what
combination of these flags it actually allows.


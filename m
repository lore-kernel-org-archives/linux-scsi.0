Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7F223AC1F;
	Thu, 11 Jul 2024 05:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720676551; cv=none; b=hDAOa7WSFEzTWYlrFTGvr11YnlJo5JaQjca+zw+/IEht8XmsyvS7+ij+YzHtPCKkt7JrPVFt9qbinTtTuhceNNWB0CaUQSDUzl1YnF39Xj1x+AFXinaoF+5tY8wVCykSi1zt2HUa4Pq3LWtNcm2NN7qe2t559RbR44+JGmLdEII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720676551; c=relaxed/simple;
	bh=CgAFU959M+tbjtGnitDMPE9JCtXXNro4X7Ff4vH5ctA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nOtBiCTmSo7WS1DVGHRfHST+dEr0FucMrWdE6UI4+iHJgWb4kkWOrxzaHh+Koz7lHPDBbriUydYh6zzsJXSC8h7MpIMZR5gy4xZgcLOkxnk0GYtIBa0jdpD4KfnUBICmUnejUQTzIGYFww6OcNJzN4jOn6J4mrNaHBKztfogrxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1A8CA68AA6; Thu, 11 Jul 2024 07:42:25 +0200 (CEST)
Date: Thu, 11 Jul 2024 07:42:24 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Kanchan Joshi <joshi.k@samsung.com>,
	Anuj Gupta <anuj20.g@samsung.com>, linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
Subject: Re: fine-grained PI control
Message-ID: <20240711054224.GA4331@lst.de>
References: <20240705083205.2111277-1-hch@lst.de> <yq1ttgz5l6d.fsf@ca-mkp.ca.oracle.com> <20240709071604.GB18993@lst.de> <yq1h6cy3r3f.fsf@ca-mkp.ca.oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1h6cy3r3f.fsf@ca-mkp.ca.oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jul 09, 2024 at 11:47:58PM -0400, Martin K. Petersen wrote:
> For the user API I think it would be most sensible to have CHECK_GUARD,
> CHECK_APP, CHECK_REF to cover the common DIX/NVMe case.
> 
> And then we could have NO_CHECK_DISK and IP_CHECKSUM_CONVERSION to
> handle the peculiar SCSI corner cases and document that these are
> experimental flags to be used for test purposes only. Not particularly
> elegant but I don't have a better idea. Especially since things are
> inherently asymmetric with controller-to-target communication being
> protected even if you don't attach PI to the bio.
> 
> I.e. I think the CHECK_{GUARD,APP,REF} flags should describe how a
> DIX or NVMe controller should check the attached bip payload. And
> nothing else.

I really hate an API that is basically exposes a completely
different set of flags for SCSI vs NVMe.

I am also really not sold on IP_CHECKSUM_CONVERSION and the separate
no check for disk vs controller things.  I can see why someone would
want to do that for testing, but as a general API at the syscall
level it just is not a useful abstraction and highly confusing.

Can we figure out a way to do these as error injection points in
scsi or something similar so that we don't have to overload the
user interface with it?

> I'll try to connect my NVMe test box tomorrow. It's been offline after a
> rack move. Would like to understand what's going on. Are we not setting
> ILBRT/EILBRT appropriately?

I think NVMe just had a real mess with deallocation and Write Zeroes
in the past, and my test driver might be old enough to have implemented
the ECNs that fixes this eventually, assuming it actually got fixed
everywhere.


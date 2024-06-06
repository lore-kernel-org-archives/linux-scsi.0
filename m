Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9348713C8F9
	for <linux-scsi@vger.kernel.org>; Thu,  6 Jun 2024 09:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717666372; cv=none; b=GHdER10NkEIaLmDNw/6jSoGLBY+sNPXh1ypKmAoaus0DmhQvX6ndYGZ+9p7pUAY/30+qXHumIPcv5Om5T/5us3ryFufa2IrwFDIiPpDmsenSNZLkASkKzAb9CnkWGkvzr3tRMSovpVasDWyx3Dza3iwytJVpfWlF15HLpv5iioE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717666372; c=relaxed/simple;
	bh=Jfz2+ayrbxaJv2g8a8iccddmsMw9fL4rjOjz9LWfJqQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W/s5KQECGH8pshxBgCKtCqs/d8caKjb5NBDzcMha7O0Hefyqe7B5GTp4wLsLukR6adlv7GfTn/kcC2ZWcm0xV9s3eA5uITFH73JlMOkRUJI21LOTL59yARxyeFR4+9mFYm1fghoQYcynyAwwl/9rbnFKXjvDbMG9itYz+o8A90s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=R/gsmZER; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="R/gsmZER"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Jfz2+ayrbxaJv2g8a8iccddmsMw9fL4rjOjz9LWfJqQ=; b=R/gsmZERbpqiGy+xuUrXba2zOu
	m6p3E8NTBWL2eDY3S8TVahiUnzJEV5SEcEliIifijiHr0FpetD7XkJo0GpsFvIWJs69R59j8iHjzj
	Bk4mDGZXJwZfVBYQJXls2NIxpfrTkI/KYViP+juLtPOHgkbQVBszsRdiaxfquDrK7mgGCHUk6NzRq
	2INPmzZyVayOOWRoPv5avnkxvSNPzLUMWEEzdX5kS5M4E7u8QOuWoWPSJEOCPqelxjmSIoD/3eYAQ
	5ubHFsR9TofYm7+MwM8yjeqv54pKFA7FHcvTy0vK5Rr22qGwcXS7KRGbRHjQZzmhGmrQnbUH2tCNo
	Y3YuromA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sF9UH-00000009Cfn-1XSt;
	Thu, 06 Jun 2024 09:32:49 +0000
Date: Thu, 6 Jun 2024 02:32:49 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, Niklas Cassel <cassel@kernel.org>
Subject: Re: [PATCH] scsi: core: Disabe CDL by default
Message-ID: <ZmGCQTIjZjEpTJUR@infradead.org>
References: <20240606054606.55624-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240606054606.55624-1-dlemoal@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Jun 06, 2024 at 02:46:06PM +0900, Damien Le Moal wrote:
> However, for ATA devices, a drive may spin-up with the CDL feature
> either enabled or disabled by default, depending on the drive. But the
> scsi device cdl_enable field is always initialized to false (CDL
> disabled), regardless of the actual device CDL feature state.

The same should be true for native SCSI as well, right?

The patch itself looks good, though:

Reviewed-by: Christoph Hellwig <hch@lst.de>

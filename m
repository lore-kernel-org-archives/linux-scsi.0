Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87B3E386
	for <linux-scsi@vger.kernel.org>; Fri,  1 Mar 2024 13:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709298581; cv=none; b=CBCSbS/7W/RcBPFs0xW4Lg4z3VWsFuF7uDsQbZOyMvdNEOkqwxtKdf+HKGXbyrb7H2iInspBfFVEZyEliLoFNCCkp2Pviv1kuro9aLKbs5ANlzcb2wG4l1hNfVLLvJixlxUZlR56rt+QeQ5jLyLdd21ymKZ99uWwTDswlMRmdds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709298581; c=relaxed/simple;
	bh=Xnna1e1Qs4t/3f93q6ndQjs8WRzM/MY5pBHGrRT2570=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I4jQNLZPOK2MHCL0aVKgSVvqTcpbK5lUVOLS/4jZh4CxexzJiWn5oCUcfsLuPheHwTFFkrEPCINEO9yi1CXWCde9IISPeqjW8SBpgEeod6yLPTGGw2PQwKHEE9FHWp60DyF3fdvKGpK+UMs9Sijx/F45UPbspW77d3lZHG0yl/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qyi73H3P; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qyi73H3P"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=jx0zbgdVVbCPN4biVhBYRSnxgg8WOhkzuTYYwRMiclg=; b=qyi73H3P1hGHrJ5hp9nN35UdFW
	fHocVqj+hwM95fUgrZCLeri8XAMtFEKI274xj57svoeANJEHoBErhlS0H1XOj6VWDKaK3DwjrJ7if
	u7O7HpfeNeGYeCbYWK1sHtpYOg0B+Mue8DeJQZaFpINoatoQiNRrk3PJKSu3sIFMFRtBOJVVgbDtN
	MornpvrjULpVjfpzlOdulBQtoh5EQziKBJO6pfD8BoNh2QrhznJLLlj6Un4Plr4D+O2DK1N5fE40B
	Q1rdo3LYB6BjeZg3ZQV78NOa4JHWiTjP3QnmL2JFl2z4IV6OW5RMw/3S2owFYdwDC5o8p0fg4iw77
	GvaVwjFw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rg2dt-00000000Jso-2aNn;
	Fri, 01 Mar 2024 13:09:37 +0000
Date: Fri, 1 Mar 2024 05:09:37 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH] scsi/sd_zbc: Use READ(10)/WRITE(10) for zoned UFS devices
Message-ID: <ZeHTkRXw15O8mphZ@infradead.org>
References: <20240229172333.2494378-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240229172333.2494378-1-bvanassche@acm.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Feb 29, 2024 at 09:23:32AM -0800, Bart Van Assche wrote:
> READ(10) and WRITE(10) are sufficient for zoned UFS devices. UFS device
> manufacturers prefer to minimize the size of their firmware and hence

But ZBS rquires the 16byte formats.  It UFS vendors keep ignoring 
SCSI they should not claim to implement it.

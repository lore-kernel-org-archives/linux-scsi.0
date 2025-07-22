Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C43E4A95E
	for <linux-scsi@vger.kernel.org>; Tue, 22 Jul 2025 05:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753163860; cv=none; b=oQuBJaXsGF1+OYZtPfb56kxIHhgA3y0Yvq9YBu/sqB0FCkEiHuam+WXCYIOCMnTAYPa6kse5KfdsCYjgNHUVyHPxCQOC5bPeLN0UWml9xmVsEKLlOOdEggX/EgZXyGDIlQVhbsAKuBzMjWOEhVcersmyNK+vXYYCuP7spPqIlwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753163860; c=relaxed/simple;
	bh=NoBZw4Ozrr0u8C+o3AdoZXJK3jEz/vbJRJ0ZM0lWyik=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XNGxrSjcYK5gf7401U22J54Z3EXrIMnfQa7RGwmuvJXOeqoXGMpuwGhouvgKzQcrJHwGXTGpWJNehWdEi7bU0eNBCYbv01BcknL8OJfB15cwbZaSeK8Ysvuhkyzs6sV3GNgdKP1etjeTSzmYd6f/fVCYpjYnvzoU7rrtwr5if5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=wrfob/zO; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="wrfob/zO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=NoBZw4Ozrr0u8C+o3AdoZXJK3jEz/vbJRJ0ZM0lWyik=; b=wrfob/zOj74/sDtVpGRPGHqwTH
	jQr1eUqTzUZYPew7KJCGMOz4h4r+mnbU1vrq4j9VY+AHu6CQo7uWB8hcjDdrecD0LVJByISOumwRl
	untZ7JL4YZgaGUbB7Ft73VYb9ElcQKESLxMBHehaFCZcQl95Z0xEXbR43Xdoa736Yw+dWOAFtxPZC
	NEsAFsvWWzZRud3YjsL/JlUl+2dH5XWNHIw0F0wJnmQB89mArDCnzfoBsfCiVPVB+Rno83uP9p1bj
	9F6eKjlq+l8AW2eLjFsA7aiSSU97N8J2VtIx8io3exnG+sITdYl18M6/GyrIhDpcQdi9Ky0mSXo/P
	T4PRa/yw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ue60Q-00000001NUT-3w7B;
	Tue, 22 Jul 2025 05:57:39 +0000
Date: Mon, 21 Jul 2025 22:57:38 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
	sathya.prakash@broadcom.com
Subject: Re: [PATCH v1] mpt3sas: Set DMA_BIDIRECTIONAL for additional SCSI
 commands
Message-ID: <aH8oUpyOhTlo-sZc@infradead.org>
References: <20250721110546.100355-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250721110546.100355-1-ranjan.kumar@broadcom.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Jul 21, 2025 at 04:35:46PM +0530, Ranjan Kumar wrote:
> Extend DMA direction override to handle additional SCSI commands
> (SECURITY_PROTOCOL_IN, SERVICE_ACTION_IN_16 with RELEASE) that
> require bidirectional DMA mapping, in addition to ZBC REPORT_ZONES.
> This avoids issues on platforms that perform strict DMA checks.

I think you are totally misstating the problem here.

The Broadcom MPT3SAS implementation, probablt the SATL is implemented
gravely incorrectly, and rewrites data structure in place against
the protocol requirements, which is cought by all but the dumbest
IOMMUs, but Broadcome until now never bothered to actually rest the
junk they ship out to customers fully.


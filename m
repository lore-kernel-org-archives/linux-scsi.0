Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4370181315;
	Mon, 17 Jun 2024 06:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718605055; cv=none; b=aMZDn4HteGefHBhAochALvL1SuZluxgEOeWt+W88chSJViCzGnkcYzPpZIibwRovGn2gMmguo2dgfh1JPYMtSojVRJKeNluFirb31piAZ7+KrPp23RERk0nth+W1WYCMhcWYRiLYVp1RTGOjdWgIrdw+w26vtw/wuO6rGTEiBY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718605055; c=relaxed/simple;
	bh=ncY2wGCxhFJiX5cy/N8svulUm9ekQ2k5a/Gc8ht/9d0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g7ILckZ7vyWWMbDCL8BZMtHUFraXUUTFBJP9i7rz96CPI58RQcehs6ARjmrd5Xv4/obhKBkFK/dk2Zk5DgTvMFJu9zqaeGrtjFbv9QogCt0MjhXKp3qIYfqZtNeW3hOWBuXIn/HiHr5veY3P5xNCcq7z5Wvs0f5B8eyXb7eA7TM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=A9oIIiLE; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="A9oIIiLE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=pkTHKmxzyeCAx+Op/zCoBY2/fUvL2c3TR2l79pXmyYQ=; b=A9oIIiLE01yISYnVkNmWFKZGl/
	gdZyZ1HzZFYzvo/Z4GQQdQTVRy/xt7exYDLSx51FkxHjAnwpBXNX4y0/8uewsMikkBpqLmm/6MhDH
	52YmRS15DdWGtPdqhJNs7ZTgcGLt577llNysoLtESEMXwy21Dwy0IhvEwi/PGqCVCJXChDAiT+RCA
	QrwpFFa95IqBk9LhN4HCgp9132jtc9kKoiA70sOxBNcNo1oDN3KVH54b9FWATizVr99bfZTgg7gRS
	P0Tm/XmMdxedgOzdjeisyHX7AvvDixle+SCMenBGWX5iLUiF4UZUycRURfsUCXChnTgcUc66zd2Y0
	i/fHALvA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sJ5gL-00000009PES-1Wim;
	Mon, 17 Jun 2024 06:17:33 +0000
Date: Sun, 16 Jun 2024 23:17:33 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Li Feng <fengli@smartx.com>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	open list <linux-kernel@vger.kernel.org>,
	"open list:SCSI SUBSYSTEM" <linux-scsi@vger.kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: sd: Keep the discard mode stable
Message-ID: <Zm_U_ZA96u2K6a6S@infradead.org>
References: <20240614160350.180490-1-fengli@smartx.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240614160350.180490-1-fengli@smartx.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sat, Jun 15, 2024 at 12:03:47AM +0800, Li Feng wrote:
> +		/*
> +		 * When the discard mode has been set to UNMAP, it should not be set to

Overly long line here.

> +		 * WRITE SAME with UNMAP.
> +		 */
> +		if (!sdkp->max_unmap_blocks)
> +			sd_config_discard(sdkp, SD_LBP_WS16);

But more importantly this doesn't really scale to all the variations
of reported / guessed at probe time vs overriden.  I think you just
need an explicit override flag that skips the discard settings.


Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 354913D38E
	for <linux-scsi@vger.kernel.org>; Tue, 11 Jun 2024 17:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718127391; cv=none; b=DSsK/09rwm+FeGP74Z/mt9ZbResO4395sGSoNqspCl+V4bRRHroZRqReoGkpS7i1E8x9fHdRp0+JkQvywSp4lR4f/W3Wqz2ePhisnsqhXI5RrBJAXKqIoCRTgSRm60yN5CmW7tDeH97gJVsWn+buTlHJJ8KpM4cbdkW6IFDhcNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718127391; c=relaxed/simple;
	bh=/BqqK/VVtD7v/i9CbUEaT6zRLELdsgQYQZL4OsY0/F0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S/JANMR0brQa3qJez6OfHsWjSWPHUIB48wSvKAW/Ko3QYVCHq2KVU8GBF6vz+oTBZ3B5cl0NHduWNoOAM1rvFEhzxQj2Ud7hydol8wx2MhpsL3/btJcLSwfHdkR4Fz0itYwu4lIeoJf9jdduxwDcHiNfn9fLNcEknTv2cJJxxUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=2IZgz2AR; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="2IZgz2AR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=EujE9XMlYhLGZw29C4addK4kkM4307N1EoWblmsEK7k=; b=2IZgz2AR2MUVm5WkeKmPHJtUlO
	o7ZpyiR/zmgbxbdGhoBT5V698yScsbFTqSDaPT5vxC6Sz40nlAPCKgn7sjbq5FfZ4Z6fba54ShmJf
	qn0dfGieWivslfw29yA/F4rmxOt5Wm6pvFUhuVb2mQ5Po/x3OBn1oZ2/1FrN7Iaqoy1AIhIebuUEd
	WpeV3MKoqDo+KguvBqpMBe16aYsd5FfapV7m1G2xBjc17yn5diLZP0zi2TkiTOOjtvtUyYSDTAv9u
	o1hnHE5EzD8iIOguiq/jlEei/VZFueAWORH3hJXmIWxh74cn2F8OysXXflXsrwzYPQ7dBOw3Dl/z6
	28MtiP+A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sH5Q5-00000009gkI-35Lu;
	Tue, 11 Jun 2024 17:36:29 +0000
Date: Tue, 11 Jun 2024 10:36:29 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, Avri Altman <Avri.Altman@wdc.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>
Subject: Re: [PATCH] scsi: core: Remove an incorrect comment
Message-ID: <ZmiLHY7wjT1kMx98@infradead.org>
References: <20240607213553.1743087-1-bvanassche@acm.org>
 <ZmPrGSJvofIjA2fb@infradead.org>
 <8dff4945-97fb-4ab7-8e7d-065e9755a3f0@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8dff4945-97fb-4ab7-8e7d-065e9755a3f0@acm.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Jun 10, 2024 at 11:08:14AM -0700, Bart Van Assche wrote:
> How about changing the comment above scsi_static_device_list[] into this?
> 
> /*
>  * scsi_static_device_list: list of devices that require settings that differ
>  * from the default, includes black-listed (broken) devices. The entries here
>  * are added to the tail of scsi_dev_info_list via scsi_dev_info_list_init.
>  *
>  * If possible, set the BLIST_* flags from inside the SCSI LLD rather than
>  * adding an entry to this list.
>  */

This sounds good to me.


Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D61BA3B;
	Fri, 22 Dec 2023 05:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hY7Vxbzm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=MET1rK6m4uSg+pjKk7i8yy4yXYItUii1yK0ipiQ0oPE=; b=hY7Vxbzmk9qmUN6cH/EMWdCR2P
	pGB6/uGNKF7lRHEsFWIGJUgpY5ux3h3+nFE+ccluYdShmcskgMMK+1Hxb6kvq1SpQeBGk2PwfPrF3
	qrBsZSMN4M91HaTfCCWR5lfbtOlUrB2UowjRk/wc+uimfdIZgpipa9SUQUyeDY9CrX9EbdVRhcrSO
	WwVCIJ8mIm8arMQhADoCq3a2wyOAmEFXnoDtaRmykQSuJF4KBhOnUCRJHU9tJSNt4nKTHRSJazhDq
	R3VndL0DEAnugtkuDfRIY8X43SM7Cx4ZmqKpOiyBC6D93lcKuuST+iYbbFYlpOvrdaKfFenMFBiBT
	kHasqCrw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rGXmi-004wKg-3A;
	Fri, 22 Dec 2023 05:09:20 +0000
Date: Thu, 21 Dec 2023 21:09:20 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Hannes Reinecke <hare@suse.de>, lsf-pc@lists.linuxfoundation.org,
	linux-mm@kvack.org, linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
Subject: Re: [LSF/MM/BPF TOPIC] Large block for I/O
Message-ID: <ZYUaAMrdzveBuroa@infradead.org>
References: <7970ad75-ca6a-34b9-43ea-c6f67fe6eae6@iogearbox.net>
 <4343d07b-b1b2-d43b-c201-a48e89145e5c@iogearbox.net>
 <03ebbc5f-2ff5-4f3c-8c5b-544413c55257@suse.de>
 <5c356222-fe9e-41b0-b7fe-218fbcde4573@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5c356222-fe9e-41b0-b7fe-218fbcde4573@acm.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Dec 21, 2023 at 12:33:08PM -0800, Bart Van Assche wrote:
> I'm interested in this topic. But I'm wondering whether the disadvantages of
> large blocks will be covered? Some NAND storage vendors are less than
> enthusiast about increasing the logical block size beyond 4 KiB because it
> increases the size of many writes to the device and hence increases write
> amplification.

Then they should not increase the logical block size for the products
where they worry about it.  It's not like larger blocks are a feature
the Linux wants, it's want that makes hardware vendors life easier and
is thus pushed by them.  Of course it doesn't make sense for every
product line, but it's not like Linux is going to stop supporting
512 byte or 4k blocks.


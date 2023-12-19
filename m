Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A183C7486
	for <linux-scsi@vger.kernel.org>; Tue, 19 Dec 2023 05:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="o3uF0NaT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=uCE7cd/ZNUMyLdxA+oodo9T3dOAgVUxC+Rr3rX80wuY=; b=o3uF0NaTDXD8ptYLWzGOmYkYDh
	90SYPv5JpzeptRSLnWiQHQEWQBfaS7zncRed6QlsY+3EUd4bDcE+fVagIzump/jTzN4eUbU1Qc+dQ
	DnVKBgLKXbPC2Pjsjon8v5Bt79ifWo3a7dks6WyI5LlbjOIMD+ixYoeONjC0N+lErGzl1pqx6bXll
	n0mRC6Pm2bS5V2aW5h+/mJnZ3IJD4rhSv8UogjJBd2HeIt5yjB5DazSUcAMBmBC3nY73ftJKYwcVn
	TdgIWRRxjuKkd4f1WrIoZUW8AO2AQk4QPHBRiuuJTOpPCUEtKzldv4tPn45+XvZjkVRB7ZDVX51sx
	wMSclodg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rFT7f-00CwKL-06;
	Tue, 19 Dec 2023 05:58:31 +0000
Date: Mon, 18 Dec 2023 21:58:31 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Nilesh Javali <njavali@marvell.com>
Cc: martin.petersen@oracle.com, lduncan@suse.com, cleech@redhat.com,
	linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
	jmeneghi@redhat.com
Subject: Re: [PATCH] cnic: change __GFP_COMP allocation method
Message-ID: <ZYExB52f/iDzD8xL@infradead.org>
References: <20231219055514.12324-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231219055514.12324-1-njavali@marvell.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Dec 19, 2023 at 11:25:14AM +0530, Nilesh Javali wrote:
> The dma_alloc_coherent no more provide __GFP_COMP allocation as per commit,
> dma-mapping: reject __GFP_COMP in dma_alloc_attrs, and hence
> instead use __get_free_pages for __GFP_COMP allocation along with
> dma_map_single to get dma address in order to fix page reference counting
> issue caused in iscsiuio mmap.

You can't just do a single map for things mapped to userspace, as that
breaks setups that are not DMA coherent.  There was a patch floating
around to explicitly support dma coherent allocations in uio, which is
the right thing to do.


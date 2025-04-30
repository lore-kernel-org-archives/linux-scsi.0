Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35AB01B5EB5;
	Wed, 30 Apr 2025 14:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746022004; cv=none; b=Ecznhbo6SnAj0rJs0MnzgwXo1CW2vDMsXLGzLsVVDLjUzae587+ogbMFtBhAkHQ3H3yokrNF6+jHF7n0Ve7As0ohSXrs6KpRmvwryshxwMdtam8C2ciXTdD8fac/eGEXCN7ANCXM0rKT9A6DY3WMzGVl7sic03EYG5pWAGJFXl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746022004; c=relaxed/simple;
	bh=mw38HgEHjajBQ1//yCEw7fTIe/O8xtTZ82ailKpYT9s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GF3B332Oy+4T4hdekjfZdv/JSySrxzxwQIn5RJs2svkytmy6PbShG3hUc81KwMTxytmOuxzGNeMhlsBWGtWkM8UMQDkURjkduVRliKCV+nL8v0l9yy+sBG8vqJM1YYNlmuKy2qyNhItyb9CYPKomr/duE4Brz4dkDrLRlLJ8sS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=UBjnj48N; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UBjnj48N"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=mw38HgEHjajBQ1//yCEw7fTIe/O8xtTZ82ailKpYT9s=; b=UBjnj48N81zfUvF2fVPOQQbHCw
	WMkUrlrb4wwdtnm4lQBlEQjAEMwtw2cUKztcXNnkFC6KUPiZufY1ig96Z79rBLkIxwk3vJl63NXEL
	YrUS2AoZPVJ7QEAYGKR70htCkArYg1tKk2XC6AqrfsoCJIGEnylWdA20Lbej3q2cXOoVAKubmefrN
	5BMmlF9iwgTwLaquqzfyPUxgCepclmZv/D9cN4nEDaqb9Znz3Lez72LkXLxu2k8VxMcZ1OuG55frL
	DI4D3q1JfMop5F2dn0ufQfB9h4Hak+lxiphouzzGbGce3aOljH8jqTY9CdHvOkOtwNOWpi5jRAJ2o
	/LKmYR1Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uA85C-0000000D4cG-0jSB;
	Wed, 30 Apr 2025 14:06:42 +0000
Date: Wed, 30 Apr 2025 07:06:42 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: "Siwinski, Steve" <ssiwinski@atto.com>,
	Christoph Hellwig <hch@infradead.org>, bgrove@atto.com,
	James.Bottomley@hansenpartnership.com, linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
	Steve Siwinski <stevensiwinski@gmail.com>
Subject: Re: [PATCH] scsi: sd_zbc: Limit the report zones buffer size to
 UIO_MAXIOV
Message-ID: <aBIucgM0vrlfE2f9@infradead.org>
References: <20250411203600.84477-1-ssiwinski@atto.com>
 <Z_yinytV0e_BbNrF@infradead.org>
 <OFA5AB0241.ED5C089D-ON85258C70.0068BDE0-85258C70.00721A7A@atto.com>
 <8454a55d-bfcc-441a-837e-157123e881fe@kernel.org>
 <05faf356-0bc7-4fdf-8a74-f738365fad20@atto.com>
 <ff2ba1e1-a7bd-49b7-a1f2-e51f5cfed27a@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ff2ba1e1-a7bd-49b7-a1f2-e51f5cfed27a@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Apr 25, 2025 at 10:42:46AM +0900, Damien Le Moal wrote:
> and the fact that bio_kmalloc() does not allow more than UIO_MAXIOV segments
> would have made things clear from the beginning. I had to look it up again to
> understand why UIO_MAXIOV matters.

We shouldn't really allow mapping unlimited number of segments.
So the original patch looks mostly fine, except that we should
really replace that UIO_MAXIOV symbolic name with a more descriptive
one in the block layer, keeping the same value for it.


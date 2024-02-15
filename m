Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5CF08F4E;
	Thu, 15 Feb 2024 05:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707974703; cv=none; b=FFevb7bjTgh5qN9QNBh74Jn5j3iR6Y/s/mycr+x6rmP8No4j/NMXToWba9qn/0EF6C0qf273bY2HAXOwwheNHqv8XE7pMQdBWCZz1IP2wgonG2R0VX1ivvmpcQWHG2EzgRc+v8cVJJu+/IhOajDAeKKNA0AUmbX+zY0qUc4+E84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707974703; c=relaxed/simple;
	bh=nXZ8dhhN6vNnqxncAQ33On4azS2ISMYdWmxcmT15kSk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K0/RD62K2qSgo5T21bxLX9pTFGRXTGnHNHjqyKG9ZVeNlST3BiK1uq7S5TlMf55tkEVTwm8jizysnQ8eDmbguTtgu52J+iveenifri+5rEx6Fnx8Jg7x1sAJNTIAVTHKmQSHXhUiF3TbUDAOtPIMHQS7IXam7fmgY0v2FwimMQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=iQSPeeaA; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iQSPeeaA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=AJd6EEm5AeyrSlx8/jk3HAiyYxH1ZBFPwHgSBySyS4w=; b=iQSPeeaA6A/M/NKgrMO7gWumOx
	S4hijDekdQxzHRGxU/ry3GYs46ZrXtC9+12v6J6aB5OacrIc/c4GibxZMltwunNU7mfRYbcflg2O9
	NgBJQG6Em5rvyRhElGdXYJIIqIGwBSApHc9uHlevYJLUyzEY8bxfqItIQWrBdv8Y/YqdHV74Flkqs
	KHi4RzvJsD+JIcrywoa3V7thuLprf4VTGVCWBljOJjuCkFKDYroAN20kWwFAFE1XUcio8Dnso4r+X
	dlp/hsT+5RpdG5yNVJq12Oc3vGuVFSa1KLraTQfBfTIrMYnNtRp74dXaQd052TZkFGoXEfHHXjjL9
	sqFN0zow==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1raUEz-0000000F1Id-2ZRS;
	Thu, 15 Feb 2024 05:24:57 +0000
Date: Wed, 14 Feb 2024 21:24:57 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Naohiro Aota <naohiro.aota@wdc.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	martin.petersen@oracle.com
Subject: Re: [PATCH] scsi: target: pscsi: fix bio_put for error case
Message-ID: <Zc2gKZmCSYsFpi7f@infradead.org>
References: <20240214144356.101814-1-naohiro.aota@wdc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240214144356.101814-1-naohiro.aota@wdc.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Feb 14, 2024 at 11:43:56PM +0900, Naohiro Aota wrote:
> As of commit 066ff571011d ("block: turn bio_kmalloc into a simple kmalloc
> wrapper"), a bio allocated by bio_kmalloc() must be freed by bio_uninit()
> and kfree(). That is not done properly for the error case, hitting WARN and
> NULL pointer dereference in bio_free().
> 
> Fixes: 066ff571011d ("block: turn bio_kmalloc into a simple kmalloc wrapper")
> CC: stable@vger.kernel.org # 6.1+
> Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

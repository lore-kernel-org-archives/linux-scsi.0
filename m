Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70EA44ACC61
	for <linux-scsi@vger.kernel.org>; Wed,  7 Oct 2026 13:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791378864; cv=none; b=JAxnirsYsz4fSi+RJLFeo/eMvreOlx23PKP75Vp+ZjMHPoYkktdT19SrZaMT4H4QiSDZb6VZBPgogWh5ibKtpTxLjTS6oj+Bl9CB5Zd6oggGDHtQjIz3fBA2WIH+xcXuZeahtNAfXPbilVxbmyIJ6pQWso2VXv7zBFDU+QTKrrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791378864; c=relaxed/simple;
	bh=EVRpmFjJ2W8oKyEn2kS6MhrPerdZPsnJGcY47qFLRYQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o82cNmGtbXofckNP2NxNWk978SoRiVdAunpRDUeHjOqsrQaVT+uP+9pDs88VqPf/FEkEmPJFqVAkYbw6DqLmzETJ3HY/Rftzw75DFHJz/wxOo7Q4JoUMNDct5GAgX/OKdxOp/t0wkIxVywcnKkVMWSIukJmp8SA0dcTGom9SnOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7374668BFE; Wed,  7 Oct 2026 15:14:11 +0200 (CEST)
Date: Wed, 7 Oct 2026 15:14:11 +0200
From: Christoph Hellwig <hch@lst.de>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, John Garry <john.g.garry@oracle.com>,
	Marco Elver <elver@google.com>, llvm@lists.linux.dev
Subject: Re: [PATCH v4 7/8] scsi: scsi_debug: Improve lock context
 annotations
Message-ID: <20261007131411.GE30647@lst.de>
References: <cover.1791349129.git.bvanassche@acm.org> <765bf3683555f3d7fbe8510cde1eb50d5f6d0c6f.1791349129.git.bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <765bf3683555f3d7fbe8510cde1eb50d5f6d0c6f.1791349129.git.bvanassche@acm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Oct 06, 2026 at 10:07:29PM -0700, Bart Van Assche wrote:
>  static inline void
>  sdeb_read_lock(rwlock_t *lock)
> +	__acquires_shared(lock)
> +	__context_unsafe(/*conditional locking*/)
>  {
> -	if (sdebug_no_rwlock)
> -		__acquire(lock);
> -	else
> +	if (!sdebug_no_rwlock)
>  		read_lock(lock);
>  }

Is there no way we can make the spare-style __acquire/__release work for
clang?  That would be this and similar patterns so much better and
safer than the blanket __context_unsafe.

Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 011ED2F693C;
	Tue,  2 Dec 2025 05:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764654936; cv=none; b=B7XhsiyT9+uBWcI5wFjyQAlvmEU6+bxSupN+WwDXs5SjL67tDqr5yjt4etW4NfdGji2thKtw99gt20+QdyTCR7J03P3a6arzSdcGgKd9zbHj2/L+KXpLuyRmfcQr7kaAAioAk63C08JD9A0saCfArgok6Gs8x/Wij8hifaTMGSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764654936; c=relaxed/simple;
	bh=eZyMEmTjmbFIlMzk+uDSONCGj4WK61mKqJvv8axi53c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IJiS6rDrLczoTduesmqoDHKw5j6q+plqEnEPsDfGoRqFSuZYJQba01BgUjEfctHtWskapmMPRgxnehSyI+ILgKCv+98hTrYNB2fiTFPapS582Sw0NRQso36mWchGhwqJjrA81N1LKY7pG+mUrXosNDpsSRNXAmFmF/HpXrMeeB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id CF00768AA6; Tue,  2 Dec 2025 06:55:30 +0100 (CET)
Date: Tue, 2 Dec 2025 06:55:30 +0100
From: Christoph Hellwig <hch@lst.de>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org,
	Keith Busch <kbusch@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-kernel@vger.kernel.org,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	Mike Christie <michael.christie@oracle.com>,
	linux-nvme@lists.infradead.org, Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org, Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [PATCH v2 2/4] nvme: reject invalid pr_read_keys() num_keys
 values
Message-ID: <20251202055530.GA15852@lst.de>
References: <20251127155424.617569-1-stefanha@redhat.com> <20251127155424.617569-3-stefanha@redhat.com> <20251201063649.GB19461@lst.de> <20251201162255.GD866564@fedora>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251201162255.GD866564@fedora>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Dec 01, 2025 at 11:22:55AM -0500, Stefan Hajnoczi wrote:
> > We use struct_size to calculate the size below, which saturates on
> > overflow.  So just checking the rse_len variable returned by the that
> > would be nicer.  Bonus points for using sizeof_field() instead of
> > hardcoding U32_MAX.
> 
> Will fix. I don't see how to use sizeof_field() here, but taking
> advantage of struct_size() already improves things a lot:

I thought we'd stuff the len in some field, but we actually convert
it to the ndw in the command, so yes it doesn't make sense here.
Sorry for the misleading direction.

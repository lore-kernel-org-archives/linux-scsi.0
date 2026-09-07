Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBD6838A711;
	Mon,  7 Sep 2026 05:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788760171; cv=none; b=TT3mnLvCzToM1bnRGLrpkF6W2RfdkZcEU+NtrzBxAhepWp7JoSczJBp1oCCmyXH37FGlPw2aXzUuE4ocCLOb6bwofTH/TZvYwOUTsRoCF2n972umsE3m/tuh67NS68LI8DVn48mYYrBJ0129Ppu0s+sCNe+t+mbOddEqL6qnsF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788760171; c=relaxed/simple;
	bh=9dAB3uq+UOHywnn17eNjoawTsE9FRv5EFrCuj7JDu0k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CqmdyU/KIftLBZf4xGEO6b35HntUxKC7ykaGlC/gk8wk0IQAwQeNg1N8CnacKMNvKLud3O/CdxlTcz6l+NnlmZa2ooxoK5e9qXc1DX1vUwnbzP+NIZ6ecyBOHA9PX/tIShyi3JlUxg4/CW+RbWU/h8PzFuXeEHv1NbizMWiAaiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 588E768D05; Mon,  7 Sep 2026 07:49:26 +0200 (CEST)
Date: Mon, 7 Sep 2026 07:49:26 +0200
From: Christoph Hellwig <hch@lst.de>
To: Anuj Gupta/Anuj Gupta <anuj20.g@samsung.com>
Cc: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@kernel.org>,
	fstests@vger.kernel.org,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	John Garry <john.g.garry@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 6/6] generic: test corruption detection using T10
 protection information
Message-ID: <20260907054926.GC31481@lst.de>
References: <20260831064557.2577241-1-hch@lst.de> <CGME20260831064639epcas5p4e02eef8306da9865f278d578a6ea8dd9@epcas5p4.samsung.com> <20260831064557.2577241-7-hch@lst.de> <93041ae8-da31-4482-b12c-04750629f475@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <93041ae8-da31-4482-b12c-04750629f475@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Sep 03, 2026 at 11:30:26AM +0530, Anuj Gupta/Anuj Gupta wrote:
> > +	if [ "$last" -eq 1 ]; then
> > +		echo "adding to $phys_blk" >> $seqres.full
> > +		phys_blk=$((phys_blk + 127))
> 
> last sector for a 4096-byte block size would be 1023 not 127 right? 
> maybe use something like this to calculate the last sector?
> 
> phys_blk=$((phys_blk + (128 * blksz / 512) - 1))
> 
> and maybe rename it to phys_sector

Yeah.  Currently we force 512 byte blocks when setting up the
scsi_debug device, but it doesn't hurt to be consistent in the
arithmetics.


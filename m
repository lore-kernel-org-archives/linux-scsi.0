Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB2412E859;
	Tue, 24 Sep 2024 05:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727156213; cv=none; b=P1vjNQwj3EVBXautkrOp5hrYBQX35sBSgVuVeSuMb8HKvN/10UJWWWwOfUzw8gCucDxtJk198tNjJ+oSQtmDl8IfH9xoDIJYqZpOROc7nisrAIbScDSTqxC2Randq+yuF2BDu3abK46UAd4E8IX093Jkm9fxuv9nwKxq7obQAyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727156213; c=relaxed/simple;
	bh=mL1DMwjOifYVdaeXW09oxLfXWIkdC0FtKt77jcr0XrU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xr4oJkxW7X+y399eAULC0c1fOZV956DPobYLijamCmcxJoMh1GxCOA+LWpmVNcM7rULj6e9vkNZ+Per1ypKtb3EyAuF/jz42AGBDZfMfHcYUrc7xHoc3Kk048zu1Ttd7pSt4A1pfxxqGkXaFooF3OwCYuviszDnguR2HekaZPOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9E783227A8E; Tue, 24 Sep 2024 07:36:44 +0200 (CEST)
Date: Tue, 24 Sep 2024 07:36:44 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Anuj Gupta <anuj20.g@samsung.com>, Christoph Hellwig <hch@lst.de>,
	Kanchan Joshi <joshi.k@samsung.com>, linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
Subject: Re: fine-grained PI control
Message-ID: <20240924053644.GA10569@lst.de>
References: <20240705083205.2111277-1-hch@lst.de> <yq1ttgz5l6d.fsf@ca-mkp.ca.oracle.com> <CGME20240918064651epcas5p418d61389752da25e5fc50e6a50a111b8@epcas5p4.samsung.com> <20240918063910.hqntgm5jy2jisys2@green245> <yq1bk0dhlko.fsf@ca-mkp.ca.oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1bk0dhlko.fsf@ca-mkp.ca.oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Sep 23, 2024 at 09:59:10PM -0400, Martin K. Petersen wrote:
> Originally we had code in Linux allowing filesystems to attach
> additional metadata to bios which would then be stored in the app tag
> space. This was intended for backpointers but never really took off.
> However, if we move the burden of PI generation to filesystems as
> Christoph suggested, then we can revisit using the app tag space.

Just to make clear I want file systems to be able to opt into
generating PI, not get rid of the auto generation.  That is actually
kinda possible already, I just want to make it nicer.


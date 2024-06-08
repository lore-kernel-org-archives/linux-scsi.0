Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC8C7610C
	for <linux-scsi@vger.kernel.org>; Sat,  8 Jun 2024 05:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717824289; cv=none; b=JvdJKtES3l8LU1Jtk/FoB3vuSEDoVIAdepjMhEpOsabcC9eIkentKds5Yvufla+BC30dF6o0Ihl0A8X3dIA4ZLN5LkHYD89FLceyTYs51SZxkPsbMeieQKL3pGzcWQTbynT3NgJDth+Ms7QkiefDO3ENhraaGnQuCoLWIUPQoHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717824289; c=relaxed/simple;
	bh=vraDkijnwiDKU97rBK6NDpj8VS38lewgSbepNehk5n0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rG2J8oGTJZ/9deO9c41pzJNSQdJcurMxwdH0+kflmDDdcaN4SuZFxwlufeAjF5fSfejdhjWdw+OtAnCXPD+oalpckv4NFut1M+9hQLwM503P9znv7i8bjBDtxXj0OqHYq2E8QcFdWTGtA9uE2vfvspGR+u6br9/lhBdUaBDhcgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=oB/kvpcW; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="oB/kvpcW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=DNtmnKGMcK0/AVQ8W6HgxYDGoxtX313oE59lgHqieO4=; b=oB/kvpcWG628I4lsTDRNqYtPcl
	NtlYjx8q0wlUe1Oy7KZ7oEUsGfztSAdY6pf+4FBXFflv53OXhTffvK3UzC31pK3jQKGbeuWSXsPrZ
	AbXSpp3HRKLzpWLH7ba2iCzA/6Ps1GABPr3HOBPheBnleP6V3u1ppMjT1U9fEky2MbchhIZCAQgJo
	mDBwTsgt1VWeGLylMSJUrJ5PKyRPXJ9F6z+B7L3xxDT3ERkinD5VlM8ydgiEAQo9GnYIwOvyE9kp+
	Qv/wZTMRkYSzZSkdYrnod7mlnhu0YFaap96QMBd0+u2IiZfyGJf47iteXGusoFDiMXFmP2roVtmds
	55YBf0dA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sFoZF-0000000GdVk-2ZV4;
	Sat, 08 Jun 2024 05:24:41 +0000
Date: Fri, 7 Jun 2024 22:24:41 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, Avri Altman <Avri.Altman@wdc.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>
Subject: Re: [PATCH] scsi: core: Remove an incorrect comment
Message-ID: <ZmPrGSJvofIjA2fb@infradead.org>
References: <20240607213553.1743087-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240607213553.1743087-1-bvanassche@acm.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Jun 07, 2024 at 02:35:53PM -0700, Bart Van Assche wrote:
> The comment that scsi_static_device_list would go away was added more than
> 18 years ago. Today, that list is still there and 84 additional entries have
> been added. This shows that the comment is incorrect. Hence remove that
> comment.

I agree that the comment as-is is bogus.  But it would be good to state
that quirks should go into the LLDs if they aren't for devices on a
physical bus like SAS, Fibre Channel or parallel SCSI.  Most quirks
theses days are for unusually buggy consumer devices like UFS or
usb-storage/uas and are better placed there instead of in the core
scsi code.


Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F46113B7BC;
	Thu, 23 May 2024 13:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716469426; cv=none; b=F50C+mU3l8RD6lDVkn+oEga932DnjmQSrPuIMyw9keE+o6yyC8T+J6kNseuha0VFxlmRCqjRkO0dr6MY1zj3LEwcLWqS9m0TK6f1aYSCf5ZjWyMfSsW8aVYQqOa8rg5BHeJAgvCeT9sJsSu527cgtJz9yDHRoPC+PfS28dlpLN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716469426; c=relaxed/simple;
	bh=aTKOd1UoK6Oh7xptMTRw5Ie4ZQXVlGTbh7xLE+9kjpA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XCNs39z8clwx8+vn2yXYiVhkG5eoGMacbN0i26CInIc+D7KD4rRMZM5L+b6GnyMCGOZa/2Elule5IzNPv96xdL1Cu8RD6PgUyVSPfP8mifGvOPHsX1qaqbuVMpyGVufVzi71lfd6c9sOaYaahOJkT0vltKnGqs9T0QVXYAU/sXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=nsTcLFBX; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nsTcLFBX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Wmf33RKBUBJ0C2hNtWf7GvxhAyNe4rmkkT5B6MiF5eg=; b=nsTcLFBXrPRMA6fgT3Sv9pbkaX
	qoxNuNXxGmKHuAU9jiJ4LG0C7jHPROcxwm8d5c7CY6Rb8bYXw33iA3lBW9lwwXdLRYYeFYEwkLCUX
	a0TGjqYKR4iYJnrD7D28980Q8u3+EFHzF/C9vkl/TA6TMe3La2Fftt8aVcva2HaGr7FasmXWvrtPe
	GpdE7BgYHPSBkYqCKi6wnSKK6+zdkfA+QRhH4BJTEtqRw/acAMNounoHPtDg/C12DPa6OiYsU4zzM
	xVcv2QsOOiUR/7pdhCOSYdnM8BIp0tZgODgS5HsR5J+P86gG1FfexRIYyrLu3Nv4vgTgV44rnw0er
	i/L9QY6Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sA86h-00000006JB0-0FHf;
	Thu, 23 May 2024 13:03:43 +0000
Date: Thu, 23 May 2024 06:03:43 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Avri Altman <avri.altman@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	Bart Van Assche <bvanassche@acm.org>, Bean Huo <beanhuo@micron.com>,
	Peter Wang <peter.wang@mediatek.com>, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 2/3] scsi: ufs: Allow platform vendors to set rtt
Message-ID: <Zk8-rwjFvgP714Mn@infradead.org>
References: <20240523125827.818-1-avri.altman@wdc.com>
 <20240523125827.818-3-avri.altman@wdc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240523125827.818-3-avri.altman@wdc.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, May 23, 2024 at 03:58:25PM +0300, Avri Altman wrote:
> Allow platform vendors to take precedence having their own rtt
> negotiation mechanism.  This makes sense because the host controller's
> nortt characteristic may vary among vendors.

Platform vendors have absolutelyt no business saying anything.

Fortunately that's not what you're actually doing, but I really don't
understand your vendor fetish.


Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24AA8219F6;
	Tue, 18 Jun 2024 06:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718692880; cv=none; b=Xi3U7cPJTOMOT7OnqOd+wAmeG0oCAE4bneUf4WNnPPGBNJLhXhzbd20a6em7aed5CFTiSTkQRzUHPhxTTLH9r/mYgxor39IJF7fdsqKwMawlFb9mnIi7CuQ8jXhNCvgRnJzd4faXcTvcmQ31ujicD6X2Ct4FLR1YbkLNiJnJWmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718692880; c=relaxed/simple;
	bh=KEpSjas0DKfufJCEUjlBNGFZLhYMGabgaAFHrIwnukg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bVgwGu2kgvYoFwm1qT6AnYO3VGce+ld4c5sz6HWS/HbXJRH6EkT4EyqK+8587i4hKStSP2rTnHJoolI6yKXNRLDrsjkyVgzp+NVz7098TOcmXHH7qYs8veR0UrMe/nN+jAuAQEogQ7C80MNiLhVg9vKznST+PNHgYyRDj0Kadr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=thaJkyxn; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="thaJkyxn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=GahJgorngmwcktzCTAh/wUq0FM9ta9Xd5y8IYgAQh6s=; b=thaJkyxnpQhwGzniqemB+oD49i
	FxkwJDKe7KGz3kkAnkn+3HoLFsl988LS6VFFg789HCwW3cTlNkqrt7sa9TW7tFO7TFC7EdhClhD20
	S9ihJfJBNxk/BlRVx+SsMM242B4ZImOI+GnpwLjylwA+qrHymB6HQhl5qZcGXsVRg7/EsTfeKUljK
	3i3QFh8FMpCL+J7U0onS7/mNaCbc3Q1wV/Zxp8qP1PuIgEMNDw4nkCYirV3FBXzhdaPAOX/jOz9Zw
	L6g1i++l1bFIieD1W2/S61JQ6cx/f4lCFaHPR6MxwP+aoWAeDXw+FbS7GbyAO5TpmRHYWMqZOWmAB
	fQWwkfkw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sJSWq-0000000DqOx-3IHo;
	Tue, 18 Jun 2024 06:41:16 +0000
Date: Mon, 17 Jun 2024 23:41:16 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Li Feng <fengli@smartx.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: sd: Keep the discard mode stable
Message-ID: <ZnEsDHOAjODOS6HJ@infradead.org>
References: <20240614160350.180490-1-fengli@smartx.com>
 <Zm_U_ZA96u2K6a6S@infradead.org>
 <44BCFE4F-AB66-4E6A-A181-E7D93847EF98@smartx.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <44BCFE4F-AB66-4E6A-A181-E7D93847EF98@smartx.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Jun 17, 2024 at 05:03:03PM +0800, Li Feng wrote:
> > But more importantly this doesn't really scale to all the variations
> > of reported / guessed at probe time vs overriden.  I think you just
> > need an explicit override flag that skips the discard settings.
> > 
> I think we only need to prevent the temporary change of discard mode 
> from UNMAP to WS16, and this patch should be enough.
> 
> Maybe it is a good idea to remove the call to sd_config_discard 
> from read_capacity_16 . Because the unmap_alignment/ unmap_granularity
> used by sd_config_discard are assigned in sd_read_block_limits. 
> 
> sd_read_block_limits is enough to negotiate the discard parameter. 
> It is redundant for read_capacity to modify the discard parameter.  In this way, 
> when the SCSI probe sends read_capacity first and then read block limits, 
> it avoids the change of discard from DISABLE to WS16 to UNMAP.

Note that in the linux-next tree for 6.11 we're not only applying
the discard choice to the queue_limits structure and not commiting
it in read_capacity_16.  So it will be overriden before it gets
actually applied.  Can you check that your issue doesn't show up in
linux-next?


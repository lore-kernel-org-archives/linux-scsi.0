Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DA59224B0D
	for <linux-scsi@vger.kernel.org>; Wed, 10 Dec 2025 05:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765344405; cv=none; b=kJwc2Ya3fIpkk5ciu5v0qrNs4zCGAWWiz0cCmF2HpgTowQ9u13BXhrmrHHT5UPtB0Ccbu9n01SpQkYQbR/qqWKk9y9jhkDdHu9rRA55RFTlkT+l01hNDAWU4LMS9vf71dQmOHAfXvY35ax8YefyyY8WKWbKKxtYxFQZsJrKMyLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765344405; c=relaxed/simple;
	bh=IBYmCLtEaqTwes0Pk0YZaBmwUfTJ35hg+vt6Wmf1egY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FOwYEI1w2Sp0AXu/Osv6icnVTKgiNeI0tjKXhUR6ZBvIcSOj5Uzw4ag1FkgUKy+iUioV7sRgLdIxzW3xPbYlS7A4tyHOU+nN9psvu2ke5juZaHiZDriKzal0Bb8Ya1avetJM7IsrRf5CmURz2xNmnd/PWMnatGKGTUpunRmILcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=wernOzFN; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="wernOzFN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=YPHdr5itTzuvGfTe+Cj24FxTalH5+G5c8NxH+V9milQ=; b=wernOzFN/Ha0C6bEDmdwQRe9d/
	LRIJxPRJ7FGhzIN2NAonuKCX+vIRM17n4+lpQ3QsmE7/HcOy3ha+XdL4VdbaAyV/Yu7PXyx1E8f71
	jMx5wH6It9nBwKP7bSRIE+xh3vE1hpYfF2maSGLudr1gxVvPCyCCtsXFcNST7Zv91KWZqz23KVGyM
	AulvOBoieEXdAk94tUiJeGhpbuh5OmH9M51Lu8mFS90zIlelfpk/Wa/ZSDhrQ/AzNpPckOkzXiuXT
	nVIyIGoNn5XwBdl1Psz5L8+V7NOmfhF/c48XlxYVrgmEtM7Zv+sW4mvPK8/OgCYuJY9Vrdys/erhx
	jfyYxdnQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vTCim-0000000F8K5-3QQF;
	Wed, 10 Dec 2025 05:26:40 +0000
Date: Tue, 9 Dec 2025 21:26:40 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@baylibre.com>
Cc: Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org
Subject: Re: [PATCH 2/8] scsi: Make use of bus callbacks
Message-ID: <aTkEkPEhrcbvGzYo@infradead.org>
References: <cover.1765312062.git.u.kleine-koenig@baylibre.com>
 <59b408f6d89d402457a23564302afcbb334bc9dd.1765312062.git.u.kleine-koenig@baylibre.com>
 <e4924c88-909c-4ba4-8281-184f783539ff@acm.org>
 <akknplwphiv2qllb6s3k5cpyqz76coyvbutmwln4bjtsi5rxqo@twezemfbfiow>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <akknplwphiv2qllb6s3k5cpyqz76coyvbutmwln4bjtsi5rxqo@twezemfbfiow>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Dec 09, 2025 at 10:22:54PM +0100, Uwe Kleine-König wrote:
> I decided not to do that as part of this patch set. In case I missed a
> driver and for oot drivers I think it's nice and fair to not break them
> immediately and give its users/developers a chance to see the warning
> and act on it.

No one should care about out of tree drivers.  On the other hand
unfinished transitions are really annoying and have a tendency to
go stale.  So please go the final steps and finish it.


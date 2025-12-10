Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DADCE19F48D
	for <linux-scsi@vger.kernel.org>; Wed, 10 Dec 2025 07:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765350285; cv=none; b=FGRUWVTp08o1RX7XYwhxtKI2TkRt1SLrFDoPmTUDo8Cpre0cJNkm21eaq4sujJsf7Jcl2vvpaYHZqLh1fpJoxdvzNfOZNrwGQfcL8G7SUIhirNo3D0LzDZTEelIDdzEqSrwixYAGo1AZElNkdJE/VnbfcSn/grQAjEigSLxA444=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765350285; c=relaxed/simple;
	bh=b+ZzAox73kliQIMyiHI+9lAM6aCn17eDDTnqOXxhrfI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p+0lc5sGSTDHP536D4ynJajXm80tvqhYELFBYZZX+fGcDeMxMATpwtOWe6n0sQuCHXU4TXSVD7TQMkgvcaIMwDNNBFHTu21Nzek0olzgepWMH6f/Qs5cwGjLj7YaqGfnZ1qcqSknXpoifEMHE5de9BxGmW6NirfUbdqUHlhB364=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=0hdDeS+9; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="0hdDeS+9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=yk3ZmGCxu6DW0tmK4b/ck3yvAGVxIAQFEAKL0YWONX4=; b=0hdDeS+9D5fV02/DtPnTRMw5Z4
	FwNbxLgMFj/xX08eK55h1y+HYRI+tcrUERZy47OpSJy2EheDPrF7dJcHI4u/s8Ddrlq6O6gXZAioe
	dNJPYjj3ML4v+bssSx7oeYiBG/1U2tLmKiKBfIIygOVOZX2bwrt7Ua7Kv+NbYMPUyOn9/R3IGrQI9
	r6gv2A1xSgQ4s11JFy5hDZl5Bb6HgugHuKkMflGNISGzILv0jAw5kJVRkFTJ8DdlNd9TP/G2Wq0eb
	wHvXnMLJmRnLrXuV8rBEVeC8KUrpJdXh8pMiKpWvAEmi8PtaZLPwFsZMpCppc4PA+dzuxMQYMol5t
	XFFU1k6A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vTEFc-0000000FBwY-139i;
	Wed, 10 Dec 2025 07:04:40 +0000
Date: Tue, 9 Dec 2025 23:04:40 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@baylibre.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org
Subject: Re: [PATCH 2/8] scsi: Make use of bus callbacks
Message-ID: <aTkbiHE45DDeQhH3@infradead.org>
References: <cover.1765312062.git.u.kleine-koenig@baylibre.com>
 <59b408f6d89d402457a23564302afcbb334bc9dd.1765312062.git.u.kleine-koenig@baylibre.com>
 <e4924c88-909c-4ba4-8281-184f783539ff@acm.org>
 <akknplwphiv2qllb6s3k5cpyqz76coyvbutmwln4bjtsi5rxqo@twezemfbfiow>
 <aTkEkPEhrcbvGzYo@infradead.org>
 <77keukzmb57v2jyf26ulsystu77f2k5ta5k2vjxk5hygypzb7c@4kvu4hdty3o6>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <77keukzmb57v2jyf26ulsystu77f2k5ta5k2vjxk5hygypzb7c@4kvu4hdty3o6>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Dec 10, 2025 at 07:56:10AM +0100, Uwe Kleine-König wrote:
> On Tue, Dec 09, 2025 at 09:26:40PM -0800, Christoph Hellwig wrote:
> > On Tue, Dec 09, 2025 at 10:22:54PM +0100, Uwe Kleine-König wrote:
> > > I decided not to do that as part of this patch set. In case I missed a
> > > driver and for oot drivers I think it's nice and fair to not break them
> > > immediately and give its users/developers a chance to see the warning
> > > and act on it.
> > 
> > No one should care about out of tree drivers.  On the other hand
> > unfinished transitions are really annoying and have a tendency to
> > go stale.  So please go the final steps and finish it.
> 
> Given that the whole quest to remove the device_driver callbacks will go
> on for a few kernel releases and completing the transition for scsi
> yields to broken drivers without compile time issues if something is
> missed, I think it's sensible to keep them in the "working with warning"
> state for a release cycle (or even until the driver callbacks go away).

You will notice very quickly when they break.  And it's not like there's
a lot of them to start with.  Please just finish up the conversion
instead of leaving it lingering.


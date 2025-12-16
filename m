Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8DDF313E31;
	Tue, 16 Dec 2025 10:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765881902; cv=none; b=N7qedDyr09z/SAItdLOPrNNR2HRnPLXNCwxym0QrBkZFVn9cz42EF8b7AP5F0Nvhr506bRvuQbg6HGlBBs7Zd+Ht31ztrYmZ9HmKKzLCK/GpiCuGaZOFpjnq1m3iB7DIQW9WNFav604Cb+BRbnEmuZyxHkP+AYoeW8w9XzgOC5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765881902; c=relaxed/simple;
	bh=DdarVVZ5OH4pCBHjYbyoTbgPj5/VU4AUOg6W/5STJt0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bnfWz4bCRLxLnJWbqmY9GwDvnnJ+gTzpUJm/kt5FYEQ52C89F6HlcLPz0YmVA2TdVg5JCoXpE01VTuS3YTAWK04MrlMzNyJ5inWYc0FCuQK1WB/rG10p7UfjdmymVd6iGOiCrfB7L6kQW8bCyF0nlFuN0r8bRpYt3W0xTLjlhAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Sfms1nG1; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Sfms1nG1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Dwg0aPc3Qa9SLJ5PeQ6ch3u2nNI4wNVF+QGbPhtSVuQ=; b=Sfms1nG1czUoiZYS/rzOViDBYk
	yLhgujjQLlRFPZciufezDcCQiLZxpviMM38C/6wewuSAaGdN/f6ddLGyIkWmVB9HoM0elOGS5oJzC
	a2mgGiAVMjPmV6cvjCpUQqhI0/DUvJLzxRef4LhQYvhke+T7GAvEwtOZ05nV/ZIi+T7xaphiexK3U
	NguBth1nBqaDOMvZ08i2PglEhNxohObixit++TACm/tAhQtmw71Kwk0OTWj8iwDgEeJLkIh04wrWn
	jYKOVSzQh8OtKx8akfy8QB3qq+IRxYgISDYrD6X2A3+OQfd2Y/6je+crxdBRqcQCibbc3cpzQnjW0
	IUx3TtbA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vVSY5-000000053df-1u8g;
	Tue, 16 Dec 2025 10:44:57 +0000
Date: Tue, 16 Dec 2025 02:44:57 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Christoph Hellwig <hch@infradead.org>, Po-Wen Kao <powenkao@google.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	"open list:UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER" <linux-scsi@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] scsi: ufs: core: Fix error handler encryption support
Message-ID: <aUE4Kf73OxxO7r-K@infradead.org>
References: <20251208025232.4068621-1-powenkao@google.com>
 <aTkXqslvwMOz2TUG@infradead.org>
 <955ba65e-424b-4968-9541-ab235a7bafd3@acm.org>
 <aT-jjQpp1UfaiZIU@infradead.org>
 <54d824db-ec39-447c-8eab-6c2ce4ca87a6@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54d824db-ec39-447c-8eab-6c2ce4ca87a6@acm.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Dec 15, 2025 at 08:47:03AM -0800, Bart Van Assche wrote:
> > I don't think callers vs calle is the important part here.  It is to
> > check if any actual data is tranferred instead of special casing EH
> > commands.
> 
> Hi Christoph,
> 
> Do you agree with the following?
> 
> (a) There is code in the SCSI error handler that submits SCSI commands
>     with a data buffer. Hence, disabling encryption if and only if the
>     data buffer length is zero can't fix the reported problem. From
>     scsi_eh_prep_cmnd() in drivers/scsi/scsi_error.c:

This still does not actually transfer data to the media, and thus
is not affected by inline encryption.


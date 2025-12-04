Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22F7F326D73;
	Thu,  4 Dec 2025 10:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764843239; cv=none; b=GGF8SkA7p73R1W475lrMP3TxZbRdMmZn+BUtm4hShuDZ9Fh4sPZQGt8+utnRmjXkql8oAbtyWfx1T0hh5CKfiTWAWOL/0rv3en/VJMtmSobtjOs0xyl2dU08oO/7+BFeBUk0rE5aJG0gTsAf01ywGcx8KHgVAYKK4Oo0AZ/hY7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764843239; c=relaxed/simple;
	bh=0WsWEUUiZEKxD5ApGsajjgGJV4JXCjrb9Ws500CBVYk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VUYeT14fwG3zRIYeVa6z9A6ISMDkWUfgFk0PyyQpVSkyWXvzmQN2d8ZC8BTDS15X3Rt8UjW3P0BXsC8plpQEJLCESp2cAOblvTbDX73IM+h4hlA6uFvwgfPOZ+I7Ozd+4oE3bgbfOKRbrKAjSa1hsJOrkxeMq2/aDBPBCvLD8E8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=n3YULKd5; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="n3YULKd5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=0WsWEUUiZEKxD5ApGsajjgGJV4JXCjrb9Ws500CBVYk=; b=n3YULKd50rsaaIszqVkb/ZeU+C
	H717rAonkrd2yOF6w6A1mWR53ucj9+15iU3/hTITtakNrGcS7o50eS0yOe3qc57+BKo3bD70tx/d5
	OfbyTh9YJJOIGn/1K36otMx2TBLPN4EThA8SCAFmhLu5HEOWYHXa1/jngau2T0R6j4mir6Aa02VDV
	4zoP1iD/HSFmLGwwP7e6WnbrgVs9c8mc0HZkZw01OkcS9zkZSxXzOMvWcr1xaDnUqjdDi4LD5O81o
	rHSDw53X3n3oq+gosQFOXYM99L2X4PhRfe5ZM00BAVQjfpqHs2f6SNuthST5Uz8rZh5FHehgGFLvv
	jCRjwjfA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vR6LT-00000007pOR-4BAE;
	Thu, 04 Dec 2025 10:13:56 +0000
Date: Thu, 4 Dec 2025 02:13:55 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Christoph Hellwig <hch@infradead.org>, Po-Wen Kao <powenkao@google.com>,
	Hannes Reinecke <hare@suse.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	"open list:SCSI SUBSYSTEM" <linux-scsi@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/1] scsi: core: Fix error handler encryption support
Message-ID: <aTFe48CQcpCt6bm8@infradead.org>
References: <20251203073310.2248956-1-powenkao@google.com>
 <aS_pE4nf7wQ031Y8@infradead.org>
 <9d678edb-0db0-4ee5-9ad7-b2b141575026@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9d678edb-0db0-4ee5-9ad7-b2b141575026@acm.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Dec 03, 2025 at 05:57:49AM -1000, Bart Van Assche wrote:
> That would make it impossible to submit SCSI commands from the SCSI
> error handler that read data, e.g. to check that the medium is still
> readable.

That's already impossible right now, because data mapping isn't handled
for EH commands.

> I think that the approach of this patch is better than
> requiring that every SCSI LLD driver that supports inline encryption
> only sets up inline encryption for commands that have a non-zero
> payload size.

There is exactly one such driver (ufshcd) and the error handler needs
to clean up how it sends commands anyway.


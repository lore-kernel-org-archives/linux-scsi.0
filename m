Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B8D91CD15;
	Tue,  4 Nov 2025 12:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762259563; cv=none; b=YoYhI+7LoyjN/MUUiXfRcjUFjLwm2FezRKPu/OKqVszv3ui+/XyyG8u9fNqvOXHzZARXi3tPMfzeBWslvZAWgfaqesbYTKT1Zlcp214gfvtn3H4r74S/bmY9JmLYWONYXIPklX3/unaeq3O7eqjjycsY0T+luqAIFH9seOa2TnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762259563; c=relaxed/simple;
	bh=Wjd9WZCwkQ7vQ6XOuV9ap40jasa/RbYWhbQP6Nf1kL4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bn0ofhLGj8IxVHZ7UtsCLA+5qsQz9eVbinOOcbpWzK3MNV6DcCUIsG+2WZfoARuiaRVGnmAzt7OqjMtLzfKvGky0ciB16dB7bgt+lnTqr1U8cqwtl8gvb/p5YO/t+vfHukiVYt4LmFp9blssus6orrduGh42Nvv/iGzK42cwMPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Gihxy//Q; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Gihxy//Q"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=pg5SBsDUAbvuxjgoI3ytMsvZIqVbaHXpOJe5j4l5vis=; b=Gihxy//QMFGt9YfqER2G1lu0I/
	VvSoxjvNDWUAeKWeIUhZwKIjgjOuZscQPBDb1hQKIkn+/9uZPoEwaxqKOvcF5hv0b6eOh/ABax0Oz
	Ye6oxBvFBBTeh7UCp1wyEi85NgecTUU15lCy+SQe0H7NzYit+Sw26lFYk/ACkkGhSrZyXtch7pq5D
	eygeJOCHFPH1MI2+Ny+YgWWA6KaBrTLqVsg/OCF5mtiybpgJpA3U+zhMo+5eKyxB2F6bZy4cjMjpj
	Ly+8Lo/N+6Clljyc/YaLVGwGypSyf7tYX8wD6NTdk72eGpUl/v7h5eyt1lMAybjPShLaaGvH+hVQH
	bCiGpWhA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vGGDH-0000000BnIW-1WdI;
	Tue, 04 Nov 2025 12:32:39 +0000
Date: Tue, 4 Nov 2025 04:32:39 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: John Garry <john.g.garry@oracle.com>,
	Igor Pylypiv <ipylypiv@google.com>,
	Niklas Cassel <cassel@kernel.org>,
	John Garry <john.garry@huawei.com>, Jens Axboe <axboe@kernel.dk>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
	linux-block@vger.kernel.org
Subject: Re: ATA PASS-THROUGH latency regression after exposing blk-mq
 hardware queues
Message-ID: <aQnyZyN-BuRXDIAu@infradead.org>
References: <20251103170308.3356608-1-ipylypiv@google.com>
 <51db9579-f78d-4192-93fa-b252fe954d13@kernel.org>
 <c911b6fa-84d1-44a5-a668-6b46dbd00423@oracle.com>
 <180f16e4-851a-4009-8193-1efa41734afa@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <180f16e4-851a-4009-8193-1efa41734afa@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Nov 04, 2025 at 09:07:56PM +0900, Damien Le Moal wrote:
> Not illegal at all. libata-scsi is a SAT implementation which can do that. The
> problem with multi-queue HBAs is that delaying NCQ commands with also the
> non-NCQ ones delayed does not guarantee that the non-NCQ command will be the
> first one to show up once the queue is drained. So this is not trivial... Not
> sure how to do it yet.
> 
> An "ugly" solution would be to use a submission workqueue in libata-scsi that
> holds on to the non-NCQ command instead of sending it back for requeue. But
> that's not pretty and holding on command in the low level driver is not great.
> Still thinking.

I think we need to make the block layer aware of non-queued commands,
and then have a modality where we either issue queued or non-queued
commands with some kind of fairness between them.  I think the flush
state machine in blk-flush.c might give some ideas and/or code to reuse
for that.


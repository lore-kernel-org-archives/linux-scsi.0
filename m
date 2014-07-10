From: Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: scsi-mq V2
Date: Thu, 10 Jul 2014 09:44:39 -0400
Message-ID: <20140710134439.GP12478@kvack.org>
References: <1403715121-1201-1-git-send-email-hch@lst.de> <20140708144829.GA5539@infradead.org> <53BD7041.5010300@interlog.com> <53BD9A24.7010203@kernel.dk> <94D0CD8314A33A4D9D801C0FE68B402958B9628B@G9W0745.americas.hpqcorp.net> <20140710062040.GB20146@infradead.org> <20140710133609.GO12478@kvack.org> <53BE97AD.9080306@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <53BE97AD.9080306@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, "Elliott, Robert (Server Storage)" <Elliott@hp.com>, "dgilbert@interlog.com" <dgilbert@interlog.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Bart Van Assche <bvanassche@fusionio.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jul 10, 2014 at 03:39:57PM +0200, Jens Axboe wrote:
> That's how fio always runs, it sets up the context with the exact queue 
> depth that it needs. Do we have a good enough understanding of other aio 
> use cases to say that this isn't the norm? I would expect it to be, it's 
> the way that the API would most obviously be used.

The problem with this approach is that it works very poorly with per cpu 
reference counting's batching of references, which is pretty much a 
requirement now that many core systems are the norm.  Allocating the bare 
minimum is not the right thing to do today.  That said, the default limits 
on the number of requests probably needs to be raised.

		-ben
-- 
"Thought is the essence of where you are now."

From: Jens Axboe <axboe@suse.de>
Subject: Re: Servicing of requests
Date: Sun, 23 Mar 2003 13:28:10 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030323122810.GC2371@suse.de>
References: <20030323121850.48607.qmail@mail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030323121850.48607.qmail@mail.com>
List-Id: linux-scsi@vger.kernel.org
To: Subodh S <subodh_s_1975@mail.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Sun, Mar 23 2003, Subodh S wrote:
> Hi,
> 
> Whenever I read data of 'x'k size using one read() system call, I find
> batches of some 'y' no. of make_requests calls followed by the same
> no. of end_io's. Something like :

> make_req
> make_req
> make_req
> end_io
> end_io
> end_io
> make_req
> make_req
> make_req
> end_io
> end_io
> end_io
> 
> The output above gives me an idea that 3(hypothetical no.)
> buffer_heads above form a request.  (since 1 make_request corresponds
> to 1 buffer_head) and maybe since 1 request is serviced at a time I
> can see 3 make_req's together. Is my understanding right ??
> 
> But, I have read that sd uses some optimization algorithm to club
> requests so that the disk seek time is reduced. In which case since
> all requests are to adjecents sectors it should create a single
> request of all 'x'k assuming 1 buffer_head is of size 1k.
> 
> Does this make sense ??

First of all, please line wrap your emails at 72 chars. Your mail reads
horribly.

Second, what is your question? Yes typically buffer_heads can get
clustered into a request so that contig regions on disk are handed to
the driver as a single request that may contain X buffer_heads. sd
doesn't do this on its own, the block layer does it for the driver. And
it happens for all drivers.

-- 
Jens Axboe


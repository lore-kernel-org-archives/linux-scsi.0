From: Andrew Morton <akpm@digeo.com>
Subject: Re: Warning - running *really* short on DMA buffers while
 doingfiletransfers
Date: Fri, 27 Sep 2002 12:58:00 -0700
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <3D94B848.E2F6412E@digeo.com>
References: <3D94AC8B.4AB6EB09@digeo.com> <2561606224.1033154176@aslan.btc.adaptec.com> <3D94B33F.EB3B9D41@digeo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
To: "Justin T. Gibbs" <gibbs@scsiguy.com>, James Bottomley <James.Bottomley@steeleye.com>, Jens Axboe <axboe@suse.de>, Matthew Jacob <mjacob@feral.com>, "Pedro M. Rodrigues" <pmanuel@myrealbox.com>, Mathieu Chouquet-Stringer <mathieu@newview.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Andrew Morton wrote:
> 
> ...
> One sample trace is at
> http://www.zip.com.au/~akpm/linux/patches/trace.txt
> 

Another thing to note from that trace is that many writes
went through the entire submit_bio/elv_next_request/bio_endio
cycle between the submission and completion of the read.

So there was:

	submit_bio(the read)
	elv_next_request(the read)
	...
	submit_bio(a write)
	elv_next_request(that write)
	bio_endio(that write)
	...
	bio_endio(the read)

For many writes.  I'm fairly (but not 100%) sure that the same
behaviour was seen with four tags.

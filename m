From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [dm-devel] [PATCH 1/2] block: fix leaks associated with discard
 request payload
Date: Thu, 1 Jul 2010 08:28:02 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1007010803040.18570@hs20-bc2-1.build.redhat.com>
References: <20100622180029.GA15950@redhat.com>
 <1277582211-10725-1-git-send-email-snitzer@redhat.com>
 <1277652576.4366.19.camel@mulgrave.site>  <Pine.LNX.4.64.1006291811300.27462@hs20-bc2-1.build.redhat.com>
  <1277852600.4379.211.camel@mulgrave.site>
 <Pine.LNX.4.64.1006291925480.11847@hs20-bc2-1.build.redhat.com>
 <1277907738.2839.9.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1277907738.2839.9.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>, axboe@kernel.dk, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

> > It is either/or choice. If the interface isn't fixed NOW, the existing 
> > flawed zeroed-page-allocation interface gets into RHEL
> 
> That's a false dichotomy.  You might see an either apply this hack now
> or support the interface choice with RHEL, but upstream has the option
> to fix stuff correctly.  RHEL has never needed my blessing to apply
> random crap to their kernel before ... why is this patch any different?

We can't apply non-upstream patches (except few exceptions such as 
dm-raid45). It makes sense, non-upstream patches have smaller test 
coverage.

> And the rest of this rubbish is based on that false premise.  It might
> help you to take off your SCSI antipathy and see this as a system
> problem: it actually originates in block and spills out from there.
> Thus it requires a system solution.
> 
> James

Imagine this: I take a FPGA PCI board, I design a storage controller on it 
and this controller will need 3 pages to process a discard request. Now I 
say: I refuse to allocate these 3 pages in the driver because the driver 
would look ugly --- instead, I demand that everyone in the Linux kernel 
who creates a discard request must attach 3 pages to the request for my 
driver.

Do you think it is correct behavior? Would you accept such a driver? I 
guess you wouldn't! But this is the same thing that you are doing with 
SCSI.

Now lets take it a bit further and I say "I may clean up the driver for my 
controller one day, when I do it, I remove that 3-page requirement --- and 
then, everyone who allocated those pages will have to change his code and 
remove the allocations".

And this is what you are intending to do with SCSI.

Mikulas

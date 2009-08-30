From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 6/7] block: allow large discard requests
Date: Sat, 29 Aug 2009 22:56:16 -0400
Message-ID: <20090830025616.GA26428@infradead.org>
References: <20090829230332.017137693@bombadil.infradead.org> <20090829231122.302813585@bombadil.infradead.org> <4A99E89E.9020204@rtr.ca> <20090830025022.GE22870@parisc-linux.org> <4A99E98B.403@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4A99E98B.403@rtr.ca>
Sender: linux-ide-owner@vger.kernel.org
To: Mark Lord <liml@rtr.ca>
Cc: Matthew Wilcox <matthew@wil.cx>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, jens.axboe@oracle.com, dwmw2@infradead.org
List-Id: linux-scsi@vger.kernel.org

On Sat, Aug 29, 2009 at 10:52:59PM -0400, Mark Lord wrote:
>> That depends on the firmware.  I do have plans to group the extents,
>> but let's get something working before making it quick.
> ..
>
> In this situation, it's more a case of making it *not sucky slow*
> than getting to the point where we think about making it "quick".
>
> One extent at a time is glacial.

Really depends on the use case.  With XFS you will only have very few
free space extents per AG, so it should work reasonably well for the
batched "offline" discard in my last patch.  And for SCSI arrays that
can actually process other I/O during that time the WRITE SAME is in
progress it should not be that bad.

But so far this is all a lot of talk of course until I can actually
work against real hardware.

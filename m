From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi sysfs update (scsi_debug 3/3)
Date: Fri, 8 Nov 2002 02:30:56 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021108023055.A18954@infradead.org>
References: <20021107073619.GA1390@beaverton.ibm.com> <20021107073943.GB1390@beaverton.ibm.com> <20021107074222.GC1390@beaverton.ibm.com> <20021107183042.C15350@sgi.com> <20021107163348.GC1292@beaverton.ibm.com> <3DCAF8AA.4050701@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3DCAF8AA.4050701@torque.net>; from dougg@torque.net on Fri, Nov 08, 2002 at 10:35:06AM +1100
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: Mike Anderson <andmike@us.ibm.com>, linux-scsi@vger.kernel.org

On Fri, Nov 08, 2002 at 10:35:06AM +1100, Douglas Gilbert wrote:
> BTW Is the 256 minors limit history yet in 2.5?

No.  but for blockdevices minors are basically meaningless now.

> Whither sg?? Well it has been my intention to put
> a functionally stripped down version of the sg_io_hdr
> interface in a mid level ioctl. It could overlay the
> current SCSI_IOCTL_SEND_COMMAND or be a new ioctl
> number.

Please use a new one one, overloading only creates confusion.

> that it is dreadful (making sg_header look good :-) ).
> However from an application point of view you are
> still going to have sd, sr or st in the way of what
> you are really trying to do. Then there are the odd
> ball devices: this week I came across a SCSI printer
> type device for the first time. It's a modern device
> build to hide its true purpose from OSes!
> 
> Rather than a free standing upper level device, sg
> could be seen as an adjunct to the mid level. There is
> no need to probe sg to find out whether it is interested
> in a newly attach scsi device - by definition it is
> (unless it has run out of resources).

Yupp.  What I was thinking about was not to remove the sg device
nodes and leaving only the ioctl functionality as part of other
device nodes but rather creating a sg node for every scsi device,
without it beeing a "real" upper layer driver.

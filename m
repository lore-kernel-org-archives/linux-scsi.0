From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] switch scsi upper driver probing to the driver model
Date: Sat, 17 May 2003 13:59:52 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EC5B3B8.9020308@torque.net>
References: <20030516182039.A7369@lst.de>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:61454 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S261190AbTEQDq1
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 May 2003 23:46:27 -0400
In-Reply-To: <20030516182039.A7369@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
> Upper drivers now use the LDM ->probe/->remove callbacks and the
> core list code.  Note that this means there is only one driver per
> scsi device and not multiple, e.g. you can't have sd _and_ sg for
> the same device.

Is that "_and_" symmetric? That is, can one have the sg
device in preference to the sd device? If so, how is
that selected?

>  Personally I think that's not a problem anymore
> with the generic SG_IO in place, but if you scream loud enough I
> could come up with a hack that makes the sg nodes a property of the
> scsi midlayer instead of a LDM-style driver and we could get the
> old behaviour back.

Christoph,
This patch would have some interesting side effects:
   - no generic interface (apart from SCSI_IOCTL_SEND_COMMAND)
     for tape devices (st and osst). While the maintainers of
     st and osst might like this, not all the user apps would :-)
   - the SG_IO ioctl in the block level
      - limits maximum transfer size to 65536 bytes
      - does not support mmap-ed IO [and would need
        something like a reserved buffer concept to do it]
      - does not support direct IO
      - needs work (debuggings)
      - does not support async IO (either does SG_IO
        in sg but it can be done other ways in sg)
   - the extra ioctls that sg defines are either fudged
     or missing. This might upset programs other than
     cdrecord; cdparanoia comes to mind

It was my understanding that the device model has been
recently modified by Greg KH to cope with the dual nature
of the interface that sg causes. Evidently similar situations
occur elsewhere in the kernel.

Whether the sg driver is an upper level SCSI driver or
part of the mid level actually makes little difference.
The sgbind patch that I canvassed the other day
actually fits well into sg's functionality being subsumed
into the mid level with a single virtual device node
(e.g. /dev/scsi or /dev/scsibind ?) for access with each
open file descriptor getting its own state.

But then there is the problem of backward compatibility...

Doug Gilbert




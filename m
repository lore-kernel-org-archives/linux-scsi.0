From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [RFC] scsi host sysfs support again [0/4]
Date: Mon, 05 May 2003 19:40:24 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EB63188.3080703@torque.net>
References: <20030505083315.GB8416@beaverton.ibm.com> <20030505093833.A13506@infradead.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:2053 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S262119AbTEEJZV
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 May 2003 05:25:21 -0400
In-Reply-To: <20030505093833.A13506@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
> On Mon, May 05, 2003 at 01:33:15AM -0700, Mike Anderson wrote:
> 
>>Current Known Issues:
>>	- Current users of scsi_remove_host will need to have there
>>	  cleanup reordered to support the restoration of the call to the
>>	  Scsi_Host_Template release.
> 
> 
> That's not going to fly.  Most ->remove calls are surprise removals
> and thus scsi_remove_host must implcy a scsi_set_host_offline and never
> call into the LLDD again.  It can thusly free it's resources nicely
> after it called scsi_remove_host.  struct Scsi_Host itself needs
> refcounting, but as soon as scsi_remove_host is called it must be gone
> as far as the driver is concerned.  Your approch would imply we could
> imply we could get a scsi release callback long after the pci/whatever
> ->remove is called which is a very bad thing.

I assume Mike was talking about this change:

[HBA REMOVAL old]
LLD                   mid level
---                   ---------
scsi_remove_host()  -----+
                          |
                     slave_destroy()
                     slave_destroy()
                     slave_destroy()
scsi_unregister()  -->

to this:

[HBA REMOVAL new]
LLD                      mid level                 LLD
---                      ---------                 ---
scsi_remove_host() ---------+
                             |
                      slave_destroy()
                      slave_destroy()
                         release()     -->     scsi_unregister()

In the new model there is nothing left to do after
scsi_remove_host() has finished since everything happened
during that call. The the LLD is re-entered to cleanup
up any HBA specific device resources (slave_destroy()).
Finally the LLD is re-entered by the release().

Also module unloads (should) use the ->remove
method as well. Does the LLD need to know
whether a HBA removal is hot or not?

Doug Gilbert



From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [Patch] QLogic qla2x00 driver fixes
Date: Thu, 24 Feb 2005 22:46:32 -0800
Message-ID: <20050225064632.GC19601@plap.qlogic.org>
References: <1109305293.27139.216.camel@compaq-rhel4.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from avexch01.qlogic.com ([198.70.193.200]:12848 "EHLO
	avexch01.qlogic.com") by vger.kernel.org with ESMTP id S262631AbVBYGqK
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Feb 2005 01:46:10 -0500
Content-Disposition: inline
In-Reply-To: <1109305293.27139.216.camel@compaq-rhel4.xsintricity.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: linux-scsi mailing list <linux-scsi@vger.kernel.org>

On Thu, 24 Feb 2005, Doug Ledford wrote:

> Don't use cmd->request->nr_hw_segments as it may not be initialized
> (SG_IO in particular bypasses anything that initializes this and just
> uses scsi_do_req to insert a scsi_request directly on the head of the
> queue)
>

I opted to begin to use the nr_hw_segments as a guide following the
following thread on linux-scsi:

http://marc.theaimsgroup.com/?l=linux-scsi&m=107940832718154&w=2

and had inquired about its validaty in usage again in September of
last year:

http://marc.theaimsgroup.com/?l=linux-scsi&m=109580376921554&w=2

seems not all callers (properly?) prepare a request, still...

> and a bogus value here can trip up the checks to make sure that
> the number of segments will fit in the queue ring buffer, resulting in
> commands that are never completed.
> 

Yes, this is an unfortunate side-effect.  Not wanting to labor on the
reasoning behind its usage (the first marc referenced-link goes into
some details), the changes queued up in:

http://marc.theaimsgroup.com/?l=linux-scsi&m=110754501726445&w=2

negate any dependencies on nr_hw_segments.

> Fix up several issues with PCI DMA mapping and failure to check return
> values on the mappings.
> 

Yes, thanks for catching this.

> Make the check for space in the ring buffer happen after the DMA mapping
> is done since any checks done before the mapping has taken place are
> bogus.
> 

I'm hoping once the tree opens up after 2.6.11 is released to begin
making further additions to the qla2xxx driver with the experimentaly
patched driver as a base.

I'll queue-up your changes for my next set of patches.

Thanks again,
Andrew Vasquez

From: Luben Tuikov <tluben@rogers.com>
Subject: Re: [PATCH] make the SCSI mid-layer obey the device online flag
Date: Fri, 06 Jun 2003 11:28:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EE0B316.4060207@rogers.com>
References: <1054742495.1674.18.camel@mulgrave> <20030604165146.GA1426@beaverton.ibm.com> <1054754103.2360.8.camel@mulgrave> <20030606073603.A13259@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep04-mail.bloor.is.net.cable.rogers.com ([66.185.86.74]:39419
	"EHLO fep04-mail.bloor.is.net.cable.rogers.com") by vger.kernel.org
	with ESMTP id S261874AbTFFPOz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jun 2003 11:14:55 -0400
In-Reply-To: <20030606073603.A13259@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Mike Anderson <andmike@us.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>

Christoph Hellwig wrote:
> On Wed, Jun 04, 2003 at 03:14:56PM -0400, James Bottomley wrote:
> 
>>Yes, that's why I think forbidding *all* I/O after offlining is too much
>>effort.  Offlining should be a precursor to device destruction, but
>>actual destruction probably relys on detaching the queue from the block
>>device interface and sitting on it until all use counts drop to zero.
> 
> 
> We need a way to disable _all_ I/O to a device due to the way the driver
> model works.  The driver model ->remove always is a surprise removal,
> so the underlying PCI (or whatever) device for a scsi host can go away
> anytime.  Because of that we need to make damn sure no call to
> ->queuecommand will happen after scsi_remove_host is called.  Whether
> this is implemented with the same mechanisms as the current sdev->online
> is another question.

James was talking about ``device server not ready'' aliased to
online -- i.e. if online is 0 then only INQUIRY or TUR should
be sent from SCSI Core (unless SCSI Core decides to _know_ about
the different ULP).  The semantics on this are somewhat touched
in the INQUIRY description in SPC-3.

(This means that the device is on the SAN, but not ready to
process commands.)

You're talking about hardware removal -- more specifically
logical removal of a host -- in which case of course there's no
_host_, so how can online be checked.... (online being
member of sdev, sdev being parented by shost...)

IOW, you probably need either a flag in shost, to mean that
it's logically removed (whether hdwr or not) until it is
actually gone, or an external flag per host... it's your call.

-- 
Luben




From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [SAS ANNOUNCEMENT] MPT Fusion driver 3.02.07.02 update
Date: 16 Nov 2004 10:09:49 -0600
Message-ID: <1100621395.2279.35.camel@mulgrave>
References: <91888D455306F94EBD4D168954A9457C3FFE19@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:10418 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262012AbUKPQKC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Nov 2004 11:10:02 -0500
In-Reply-To: <91888D455306F94EBD4D168954A9457C3FFE19@nacos172.co.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>, Jens Axboe <axboe@suse.de>

On Mon, 2004-11-15 at 18:11, Moore, Eric Dean wrote:
> On Monday, November 15, 2004 3:51 PM, James Bottomley wrote:
> 
> > This isn't an exercise to expose all the layers in the 
> > transport, merely
> > to separate them out logically when it's useful to do so.  Thus, it
> > would make sense to expose the link layer separately only if something
> > other than a PHY were going to be using it.  If that's not the case,
> > then link transport parameters can be safely stashed in the PHY layer.
> 
> I open to debate on this.  The link info is going to be providing properties
> between two phys.

Right, but phys are essentially point to point, so the link info is also
a property of the local HBA phy.

> Would the "scan interface" be able to call the LLD drivers
> with a SAS Address?  Here is our SMP passthru struct:
> 
> typedef struct _MSG_SMP_PASSTHROUGH_REQUEST
> {
[...]
> } MSG_SMP_PASSTHROUGH_REQUEST, MPI_POINTER PTR_MSG_SMP_PASSTHROUGH_REQUEST,
>   SmpPassthroughRequest_t, MPI_POINTER pSmpPassthroughRequest_t;

Actually, no.  What you're wanting is a network type of connection (open
HBA and send an addressed packet).  What I'm proposing is more like a
connected socket model: We expose in the transport class a file that
understands the addressing (like the scan file in the scsi_host class). 
You send a command to this asking for the transport specific address to
be attached and it appears as a device node.  You communicate with the
device node using SG_IO and remove it again when you've finished.  So,
the packets you send to the device node are pure commands and have no
need of any addressing or topology information (and hence can be well
understood by SCSI or SATA.

James



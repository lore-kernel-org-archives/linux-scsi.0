From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [SAS ANNOUNCEMENT] MPT Fusion driver 3.02.07.02 update
Date: 15 Nov 2004 16:50:47 -0600
Message-ID: <1100559053.2058.597.camel@mulgrave>
References: <91888D455306F94EBD4D168954A9457C3FFD67@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:10132 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261529AbUKOWvB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Nov 2004 17:51:01 -0500
In-Reply-To: <91888D455306F94EBD4D168954A9457C3FFD67@nacos172.co.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>, Jens Axboe <axboe@suse.de>

On Mon, 2004-11-15 at 16:15, Moore, Eric Dean wrote:
> (1) In addition to PHY, there is a link layer. How about
> a transport layer for that?  Some of the things we report
> are { Current/Previous Negotiated Link Rate, Phy enable/disable, SATA OOB
> complete,
> Invalid Dword Count, Loss  Dword Sync Count, Phy Reset Problem Count }.

This isn't an exercise to expose all the layers in the transport, merely
to separate them out logically when it's useful to do so.  Thus, it
would make sense to expose the link layer separately only if something
other than a PHY were going to be using it.  If that's not the case,
then link transport parameters can be safely stashed in the PHY layer.

> (2) Reporting PHYS that are not direct attached to HBA; e.g. SMP Protocal
> for Exander Management.  This SMP passthru is addressed by the SAS Address. 
> How can the SAS address be sent down to the LLDs?

That was what this bit of my email was about:

> As far as the controller and expander protocols to which Doug Gilbert
> has been referring, I really have no current idea how to do 
> them, but if
> anyone else does now would be a good time to say something.

Although really, the simplest way is a protocol to allow direct
attachment of a remote PHY (sort of like a variant of the scan interface
under the scsi_host class).

> (3) SATA Drives in SAS topology - STP/SATA Passthru Protocal need to report
> such
> things as SMART DATA, Identify DATA, etc.   This is address by target, bus,
> channel.
> How SATA/IDE info be made available to upper transport layers?

surely if we have a SATA device at the end (even if we reach the end
point traversing a SAS domain) then you simply use SG_IO to transport
the device native commands and the HBA does the correct thing for
encapsulation.

> (4) Douglas concern on dual ported SAS drives in /dev/sg?? multipath eh?

Well, that's identical to FC drives which are also dual ported, so the
solution should be the same (dm-multipath).

James



From: Luben Tuikov <tluben@rogers.com>
Subject: Re: [PATCH] make the SCSI mid-layer obey the device online flag
Date: Fri, 06 Jun 2003 12:02:23 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EE0BB0F.5010208@rogers.com>
References: <1054742495.1674.18.camel@mulgrave>	<20030604165146.GA1426@beaverton.ibm.com>	<1054754103.2360.8.camel@mulgrave>  <20030606073603.A13259@infradead.org> <1054912742.1778.25.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep03-mail.bloor.is.net.cable.rogers.com ([66.185.86.73]:52900
	"EHLO fep03-mail.bloor.is.net.cable.rogers.com") by vger.kernel.org
	with ESMTP id S261928AbTFFPsu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jun 2003 11:48:50 -0400
In-Reply-To: <1054912742.1778.25.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Christoph Hellwig <hch@infradead.org>, Mike Anderson <andmike@us.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>

James Bottomley wrote:
> Surprise ejection:
> 
> driver starts returning DID_NO_CONNECT to commands
> possibly hotplug notify of surprise ejection
> device->online to be reset
> command queue drains
> command queue drops to zero, ->remove can be called and everything
> cleaned up from user level (including remove-single-device)
> 
> Nice ejection:
> 
> hotplug notify of ejection request
> eject script cleans up, unmounts, possibly resets online
> command queue drains
> command queue drops to zero, ->remove can be called and everything
> cleaned up from user level (including remove-single-device)
> ejection may now proceed

Exactly right!  (This is ``ejection'' of a device off the SAN.)
 
> For the remove_host scenario, it would be convenient just to do
> nice/surprise ejections on all the devices (from user level) and then do
> the clean up when the hosts device count falls to zero.  That may imply
> some type of host->offline flag which disallows the addition of new scsi
> devices to the host.

Just to be clear: this is when a PCI host (SCSI portal) becomes
unavailable. (quite different from the above)

In which case SCSI host should NOT call the queuecommand
(it being a property of the portal) and if user space drivers submit
commands to a device there of or the host, SCSI Core should return said
commands with response SERVICE DELIVERY OR TARGET FAILURE (this is NOT
the status SAM_xxx).

-- 
Luben



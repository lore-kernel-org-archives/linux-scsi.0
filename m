From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC] scsi host sysfs support again [0/4]
Date: Mon, 5 May 2003 09:38:33 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030505093833.A13506@infradead.org>
References: <20030505083315.GB8416@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.mvhi.com ([195.224.96.167]:25609 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S262063AbTEEI0E (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 May 2003 04:26:04 -0400
Content-Disposition: inline
In-Reply-To: <20030505083315.GB8416@beaverton.ibm.com>; from andmike@us.ibm.com on Mon, May 05, 2003 at 01:33:15AM -0700
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Patrick Mochel <mochel@osdl.org>

On Mon, May 05, 2003 at 01:33:15AM -0700, Mike Anderson wrote:
> Current Known Issues:
> 	- Current users of scsi_remove_host will need to have there
> 	  cleanup reordered to support the restoration of the call to the
> 	  Scsi_Host_Template release.

That's not going to fly.  Most ->remove calls are surprise removals
and thus scsi_remove_host must implcy a scsi_set_host_offline and never
call into the LLDD again.  It can thusly free it's resources nicely
after it called scsi_remove_host.  struct Scsi_Host itself needs
refcounting, but as soon as scsi_remove_host is called it must be gone
as far as the driver is concerned.  Your approch would imply we could
imply we could get a scsi release callback long after the pci/whatever
->remove is called which is a very bad thing.


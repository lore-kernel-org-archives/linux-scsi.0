From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Race in removal of host class device attribute file
Date: Fri, 17 Oct 2003 13:30:07 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031017133007.A27304@infradead.org>
References: <20030709144410.GA3544@beaverton.ibm.com> <Pine.LNX.4.44L0.0310161656400.890-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:42759 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S263425AbTJQMaN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Oct 2003 08:30:13 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0310161656400.890-100000@ida.rowland.org>; from stern@rowland.harvard.edu on Thu, Oct 16, 2003 at 05:09:04PM -0400
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Mike Anderson <andmike@us.ibm.com>, Christoph Hellwig <hch@infradead.org>, SCSI development list <linux-scsi@vger.kernel.org>

On Thu, Oct 16, 2003 at 05:09:04PM -0400, Alan Stern wrote:
> I've created a class device attribute file for the hosts supported by the
> usb-storage driver, using the shost_attrs member of the host template.  
> It seems to contain an intractable race condition when unregistering the
> host.  There's no way for the driver to know when the scsi host's class
> device is released, so there's no way to know when it's safe to deallocate
> the host's driver-specific data structure.  Waiting until
> scsi_remove_host() returns isn't good enough, because a user process might
> keep the attribute file open and thus prevent release of the class device
> indefinitely.

What's the problem with that?  Yes, that means a user process can lock
the memory into core, but we do this in many places.  General rule
of the thumb is that a driver may only release data after scsi_remove_host()
returns for per-host data or in ->slave_destroy() for per-device data.


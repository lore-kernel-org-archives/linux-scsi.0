From: Matthew Wilcox <willy@debian.org>
Subject: Re: sg MiB writes scheduling while atomic
Date: Tue, 16 Sep 2003 12:42:38 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030916114238.GA21596@parcelfarce.linux.theplanet.co.uk>
References: <Pine.LNX.4.44L0.0309101219190.905-100000@ida.rowland.org> <1063217791.3669.43.camel@patehci2> <1063219776.3669.72.camel@patehci2> <1063222216.3669.87.camel@patehci2> <3F66AF1B.5010402@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:47019 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S261845AbTIPLmj
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Sep 2003 07:42:39 -0400
Content-Disposition: inline
In-Reply-To: <3F66AF1B.5010402@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: Pat LaVarre <p.lavarre@ieee.org>, linux-scsi@vger.kernel.org

On Tue, Sep 16, 2003 at 04:35:07PM +1000, Douglas Gilbert wrote:
> A user process is doing IO and the user decides to kill the
> process while a command is "in flight". After the user hits
> Ctrl+C, sg_close() is called and the sg driver lets it go
> through (i.e. doesn't hold the user process in an unkillable
> wait). Since the sg driver knows a command done notification
> is coming (callback to sg_cmd_done()) then it keeps all its
> related instances alive (including the scsi_device instance)
> and notes this situation by setting its sfp->close flag.
> 
> When the callback arrives, the respone is discarded and if
> this is the last outstanding command on this device then
> scsi_device_put(sdp->device) is called. scsi_device_put()
> isn't designed to be called from such a context. However sg
> (and all other upper level drivers I suspect) have no suitable
> context to call scsi_device_put() from in this situation.
> 
> Holding the sg_close() until the response arrives is an ugly
> solution. Any better suggestions?

scsi_device_put() calls down_write() so it needs to be called in process
context.  Probably the best way to do this is by calling schedule_work().
An ickier solution would be to hijack an error handling thread ;-)

-- 
"It's not Hollywood.  War is real, war is primarily not about defeat or
victory, it is about death.  I've seen thousands and thousands of dead bodies.
Do you think I want to have an academic debate on this subject?" -- Robert Fisk

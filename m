From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [usb-storage] Re: [PATCH] SCSI: limit mode sense usage
Date: Wed, 29 Oct 2003 10:16:46 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0310291010090.874-100000@ida.rowland.org>
References: <20031028232154.A15780@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:6404 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S261659AbTJ2PQq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Oct 2003 10:16:46 -0500
In-Reply-To: <20031028232154.A15780@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Ronald Kuetemeier <ronald@kuetemeier.com>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage List <usb-storage@one-eyed-alien.net>

On Tue, 28 Oct 2003, Patrick Mansfield wrote:

> On Tue, Oct 28, 2003 at 05:51:57PM -0800, Patrick Mansfield wrote:
> 
> > I think the sdev->changed is getting set, causing the read command
> > (sd_init_command fails) to fail.
> > 
> > I'll look more tomorrow. If anyone figures out or knows the sdev->changed
> > code please post.
> 
> If we get ILLEGAL REQUEST for the TEST UNIT READY via scsi_ioctl in the
> sd_media_changed, the sdev->changed will be set. So that explains the
> failure of the sd_init_command (on READ), given the the TEST UNIT READY is
> getting one (Invalid Command status).
> 
> So (still) why the odd result of the TEST UNIT READY? 

I believe that's a quirk of the device, perhaps related to the problem
that caused it to mess up the MODE-SENSE(10) for page 3F.  Apparently it
isn't clearing the sense information when it receives the TEST-UNIT-READY
command.  Or maybe it isn't understanding that command at all and is
really replying with the sense data for the previous MODE-SENSE(10).  This 
device uses the CB transport protocol, which is extremely nonrobust as 
regards delimiting commands and matching commands with status.

Anyway, as we saw in the successful log this problem goes away when we
don't ask for page 3F.

> And why so many apparent open's?
> 
> If USB code is OK, and we can't detect and fix anything in USB, one patch
> (hack) might be to treat an ILLEGAL REQUEST with TEST UNIT READY as a
> retry case in scsi_decide_disposition, since that is generally impossible.

That sounds like a reasonable thing to add in.

Alan Stern


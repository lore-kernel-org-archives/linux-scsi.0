From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [usb-storage] Re: [PATCH] SCSI: limit mode sense usage
Date: Tue, 28 Oct 2003 23:21:54 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031028232154.A15780@beaverton.ibm.com>
References: <1067376788.1056.5.camel@ronald.kuetemeier.com> <Pine.LNX.4.44L0.0310281737350.6912-100000@ida.rowland.org> <20031028175157.A14803@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.104]:44197 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S261923AbTJ2HXv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Oct 2003 02:23:51 -0500
Content-Disposition: inline
In-Reply-To: <20031028175157.A14803@beaverton.ibm.com>; from patmans@us.ibm.com on Tue, Oct 28, 2003 at 05:51:57PM -0800
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Ronald Kuetemeier <ronald@kuetemeier.com>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage List <usb-storage@one-eyed-alien.net>

On Tue, Oct 28, 2003 at 05:51:57PM -0800, Patrick Mansfield wrote:
> On Tue, Oct 28, 2003 at 05:49:48PM -0500, Alan Stern wrote:

> > Your device doesn't like the MODE-SENSE(10) for page 3F.  But instead of 
> > reporting a normal error code, it tries to send an overlong packet (i.e., 
> > longer than the host asked for).  Of course this is an error, and the SCSI 
> > code retries several times, eventually giving up.  Oddly enough, the 
> > device then returns an Invalid Command status for the _next_ command, 
> > which is an innocuous TEST-UNIT-READY.  I don't understand that.

> I think the sdev->changed is getting set, causing the read command
> (sd_init_command fails) to fail.
> 
> I'll look more tomorrow. If anyone figures out or knows the sdev->changed
> code please post.

If we get ILLEGAL REQUEST for the TEST UNIT READY via scsi_ioctl in the
sd_media_changed, the sdev->changed will be set. So that explains the
failure of the sd_init_command (on READ), given the the TEST UNIT READY is
getting one (Invalid Command status).

So (still) why the odd result of the TEST UNIT READY? 

And why so many apparent open's?

If USB code is OK, and we can't detect and fix anything in USB, one patch
(hack) might be to treat an ILLEGAL REQUEST with TEST UNIT READY as a
retry case in scsi_decide_disposition, since that is generally impossible.

-- Patrick Mansfield
~                                                      

From: Ronald Kuetemeier <ronald@kuetemeier.com>
Subject: Re: [usb-storage] Re: [PATCH] SCSI: limit mode sense usage
Date: Wed, 29 Oct 2003 09:04:57 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1067443496.1103.16.camel@ronald.kuetemeier.com>
References: <Pine.LNX.4.44L0.0310291010090.874-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 12-254-105-101.client.attbi.com ([12.254.105.101]:63492 "EHLO
	gw.kuetemeier.com") by vger.kernel.org with ESMTP id S261959AbTJ2QGD
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Oct 2003 11:06:03 -0500
In-Reply-To: <Pine.LNX.4.44L0.0310291010090.874-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Patrick Mansfield <patmans@us.ibm.com>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage List <usb-storage@one-eyed-alien.net>

Just thought about it,
how about I change scsiglue.c to exclude the flag and run a sequence of
test.
1st. no flags comment out (08) scsiglue.c (different error, I know that
from experience)
2nd. set flag to 08; 0x2000
3rd. set flag to 08 && 3f; 0x6000 ( which should work)

I could also run a test with only 3f (0x4000), but believe it will die
on the 08 test before even getting to the 3f test. But can be wrong on
this.
If you need these runs let me know.
Ronald

 
On Wed, 2003-10-29 at 08:16, Alan Stern wrote:
> On Tue, 28 Oct 2003, Patrick Mansfield wrote:
> 
> > On Tue, Oct 28, 2003 at 05:51:57PM -0800, Patrick Mansfield wrote:
> > 
> > > I think the sdev->changed is getting set, causing the read command
> > > (sd_init_command fails) to fail.
> > > 
> > > I'll look more tomorrow. If anyone figures out or knows the sdev->changed
> > > code please post.
> > 
> > If we get ILLEGAL REQUEST for the TEST UNIT READY via scsi_ioctl in the
> > sd_media_changed, the sdev->changed will be set. So that explains the
> > failure of the sd_init_command (on READ), given the the TEST UNIT READY is
> > getting one (Invalid Command status).
> > 
> > So (still) why the odd result of the TEST UNIT READY? 
> 
> I believe that's a quirk of the device, perhaps related to the problem
> that caused it to mess up the MODE-SENSE(10) for page 3F.  Apparently it
> isn't clearing the sense information when it receives the TEST-UNIT-READY
> command.  Or maybe it isn't understanding that command at all and is
> really replying with the sense data for the previous MODE-SENSE(10).  This 
> device uses the CB transport protocol, which is extremely nonrobust as 
> regards delimiting commands and matching commands with status.
> 
> Anyway, as we saw in the successful log this problem goes away when we
> don't ask for page 3F.
> 
> > And why so many apparent open's?
> > 
> > If USB code is OK, and we can't detect and fix anything in USB, one patch
> > (hack) might be to treat an ILLEGAL REQUEST with TEST UNIT READY as a
> > retry case in scsi_decide_disposition, since that is generally impossible.
> 
> That sounds like a reasonable thing to add in.
> 
> Alan Stern
> 


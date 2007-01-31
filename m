From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH] scsi: Update Aic94xx SAS/SATA Linux open source device driver for new sequence firmware.
Date: Wed, 31 Jan 2007 11:32:38 -0800 (PST)
Message-ID: <75297.51455.qm@web31801.mail.mud.yahoo.com>
References: <1170262564.3402.42.camel@mulgrave.il.steeleye.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31801.mail.mud.yahoo.com ([68.142.207.64]:28301 "HELO
	web31801.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1030565AbXAaTcj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 Jan 2007 14:32:39 -0500
In-Reply-To: <1170262564.3402.42.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@infradead.org>
Cc: "Wu, Gilbert" <Gilbert_Wu@adaptec.com>, linux-scsi@vger.kernel.org

--- James Bottomley <James.Bottomley@SteelEye.com> wrote:

> On Wed, 2007-01-31 at 09:56 +0000, Christoph Hellwig wrote:
> > On Tue, Jan 30, 2007 at 03:31:25PM -0800, Wu, Gilbert wrote:
> > > Subject:  [PATCH] scsi: Update Aic94xx SAS/SATA Linux open source device
> > > driver for new sequence firmware.
> > > 
> > >  
> > > 
> > > Contribution:
> > > 
> > >    Ed Chim <ed_chim@adaptec.com>
> > >    Gilbert Wu <gilbert_wu@adaptec.com>
> > > 
> > > Change Log:
> > >  
> > > 1.    Use dword instead of qword to display the value of Connection
> > > State register for debug purpose.
> > > 
> > > 2.    There are some registers location of AIC94xx chip has been changed
> > > according to the new V28 firmware. The patch has redefined the register
> > > location and provided initialization.
> > 
> > These look like incompatible changes, so you should make sure the driver
> > still works when it detects the old firmware.
> 
> Yes, there's going to be a bit of a problem if they are:  I expected the
> firmware to be backward compatible, so the current driver only prints
> out the firmware version, it won't refuse to use it ... what will happen
> if we use the new firmware on an old driver?

What will happen?  No-workie, or if you're lucky, unexpected random
behavior from the sequencer and thus the driver.

Hmm, I think I mentioned this on several an occasion, back when "the community"
decided that the best thing to do is to pull out the FW out of the driver and
into user space, thus decoupling the source code (version) from the FW version.
I just don't have the time to search linux-scsi in marc.10east.com and include
links to the messages here.

That is, if the user upgrades the kernel to include a new(er) driver, but
forgets to upgrade the FW (now living in the filesystem in user space)
then kaboom, no-workie.

For this reason, and to make it easiest for the user to upgrade, the FW should
be part of the driver source code, as was originally designed.  Then when
a user upgrades the kernel, possibly including a new(er) driver, the FW is right
there, in the source code.  Then compile and run, simple.

Now a user, before rebooting, will have to go out on the internet and find
this (elusive?) new FW version to go with their new kernel.  This is especially
true when the driver provides the device on which the root fs is mounted, else
after a reboot -- no workie.

This split only makes it harder for the user: integration and deployment are
"out with the bath water".  And after all, faster integration and deployment
and easy upgrade is what the user wants, and what should probably be striven to.

    Luben
P.S. Needless to say, the driver as I maintain it, still has the FW right
in the source -- patch, compile and run.


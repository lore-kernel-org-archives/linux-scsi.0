From: Stephen Cameron <smcameron@yahoo.com>
Subject: Re: Is this a known problem with the SCSI mid layer?
Date: Thu, 14 Jan 2010 18:14:34 -0800 (PST)
Message-ID: <364432.14309.qm@web33001.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web33001.mail.mud.yahoo.com ([209.191.69.116]:25429 "HELO
	web33001.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751603Ab0AOCOf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Jan 2010 21:14:35 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

stefanr@s5r6.in-berlin.de wrote:
> scameron@beardog.cce.hp.com wrote:
> > On Thu, Jan 14, 2010 at 01:24:59PM -0500, Douglas Gilbert wrote:
> >> scameron@beardog.cce.hp.com wrote:
> >>> I'm seeing a problem which I think is a problem in the SCSI mid layer.
> [...]
> >>> Remove the device while something has it open:
> [...]
> >>> [root@slicer ~]# rmmod hpsa
> >>> ERROR: Module hpsa is in use
> 
> The sg driver's open method takes a reference to the underlying SCSI
> device representation of the mid layer.  Among else, this step increases
> the module use count of the respective low-level driver (transport layer
> driver) so that the SCSI mid layer can be sure that function pointers to
> driver methods stay valid during the lifetime of the SCSI device
> representation.
> 
> This reference taking is of course being reversed when the sg driver
> finishes its last uses of the underlying SCSI device.  This may be at
> the respective close() or even later.
> 
> In short, it is normal, expected, and necessary what you are seeing.
> -- 
> Stefan Richter
> 

I don't think you are correct.  Look more closely at my test cases.

When I attempt the rmmod, *nothing* has the device open.  The last
close has already occurred -- albeit *after* the device was
removed.  

In my test, the module *never* becomes rmmod-able.  Doesn't matter
how long you wait, and nothing will ever decrement the reference
count.

Are you saying that this is correct behavior, that once a device
is removed while a process has it open that it shoule *never*
be rmmod'able?

Because that is the behavior I am seeing.

-- steve



      

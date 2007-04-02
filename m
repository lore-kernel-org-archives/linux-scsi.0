From: "Ed Lin" <ed.lin@promise.com>
Subject: RE: [PATCH 3/4] [SCSI]stex: fix reset recovery for console device
Date: Mon, 2 Apr 2007 11:14:56 -0700
Message-ID: <B70A50D07063384EB9BCE3330D18414F0327EBC5@nonameb.ptu.promise.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 67.111.72.3.ptr.us.xo.net ([67.111.72.3]:53349 "EHLO
	nonameb.ptu.promise.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965634AbXDBSNU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Apr 2007 14:13:20 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, jeff <jeff@garzik.org>, Promise_Linux <Promise_Linux@promise.com>



> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@SteelEye.com] 
> Sent: Saturday, March 31, 2007 11:46 AM
> To: Ed Lin
> Cc: linux-scsi; linux-kernel; jeff; Promise_Linux
> Subject: Re: [PATCH 3/4] [SCSI]stex: fix reset recovery for 
> console device
> 
> 
> On Fri, 2007-03-30 at 15:21 -0700, Ed Lin wrote:
> > After reset completed, the scsi error handler sends out START_STOP
> > and TEST_UNIT_READY to the device. For 'normal' devices these
> > commands will be handled by firmware. However, because the RAID
> > console only interfaces to scsi mid layer, the firmware 
> will not process
> > these commands for it. This will make the console to be 
> offlined right
> > after reset. Add the handling in driver to fix this problem.
> 
> I don't see how this explanation can be correct.  The error 
> handler only
> sends a START_STOP command if sdev->allow_restart is one, 
> which you have
> to set in the slave_configure routines (which stex doesn't).  
> If you're
> seeing a START_STOP in the eh path, there's something else wrong.
> TEST_UNIT_READY, certainly ... it's part of a restart check.
> 

I just saw the routine name scsi_eh_try_stu, and didn't notice the
allow_restart (partly because I thought it was not harmful...).
But the TEST_UNIT_READY must stay.

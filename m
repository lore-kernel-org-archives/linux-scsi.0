From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/1] sym53c8xx_2: Fix validation (Fix hotplug support).
Date: Mon, 18 Aug 2008 09:10:34 -0500
Message-ID: <1219068634.3261.6.camel@localhost.localdomain>
References: <1219004320-6384-1-git-send-email-michaelc@cs.wisc.edu>
	 <1219030321.3917.44.camel@localhost.localdomain>
	 <48A8F0D8.3030000@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:36646 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752680AbYHROKj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Aug 2008 10:10:39 -0400
In-Reply-To: <48A8F0D8.3030000@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org, Aaro Koskinen <aaro.koskinen@nsn.com>, Matthew Wilcox <matthew@wil.cx>

On Sun, 2008-08-17 at 22:47 -0500, Mike Christie wrote:
> James Bottomley wrote:
> > On Sun, 2008-08-17 at 15:18 -0500, michaelc@cs.wisc.edu wrote:
> >> From: Mike Christie <michaelc@cs.wisc.edu>
> >>
> >> The patch and description is from Aaro Koskinen. He sent us the
> >> patch against our fedora kernel, but he is short on time and did not have
> >> time to send it upstream, so I am sending it for him so it does not sit in
> >> just our trees.
> >>
> >> This patch applies to scsi-fc-fixes.
> > 
> > One of the things that's missing from this is really the problem it's
> > trying to solve ... the below is just an analysis of potential bugs in
> > the sym2 code.
> > 
> 
> Sorry. I meant to add a link to the mail with the bug report. Here is my 
> initial post:
> http://marc.info/?l=linux-scsi&m=120898142212407&w=2
> 
> Basically users are trying to do a hot unplug and hotplug add of a disk. 
> They will do:
> 
> 1. echo 1 > /sys/block/sdb/device/delete
> (or do it from proc)
> 2. Remove the disk physically.
> 3. Insert new disk.
> 4. Rescan from sysfs
> (or from proc).
> 5. For the rescan we can either get:
> 
> A. inquiry from scsi_scan.c will timeout and the driver's bus reset 
> funtion will do a BUS RESET (bdr failed and so we got to the bus reset 
> handler). This will succeed, and when the inqiury is resent it will 
> succeed and the rescan will find the device and everything is fine.
> 
> B. inquiry is failed with 0x100ff. We see this error message from 
> scsi_scan.c:
> 
> scsi_scan_host_selected: <1:0:0:0>
> scsi scan: INQUIRY to host 1 channel 0 id 0 lun 0
> scsi scan: 1st INQUIRY failed with code 0x100ff
> 
> 
> I will let Aaro handle the other questions because I know nothing about SPI.

Actually, the report says everything goes fine if they notify the mid
layer through sysfs before doing the removal.  The problem is on
unnotified hot swap with a rescan afterwards.

The problem in the second case is the parameter mismatch.  The HBA is
thinking previous transfer parameters and the drive is thinking async.

Tacking the parameters on to the messages before inquiry and request
sense is the standards suggested way out of this, so that's what the
driver should be doing.  However, unnotified hot swap is also the
completely incorrect way of doing this.  You could end up with the
kernel connecting a device or filesystem wrongly.  Notify, remove, add
and rescan is the correct way of handling this.

James



From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 15/15] Add Documentation/DocBook/scsi_midlayer.tmpl and
	add to Makefile.
Date: Sat, 27 Oct 2007 08:24:24 -0500
Message-ID: <1193491464.15612.6.camel@localhost.localdomain>
References: <200710262318.01021.rob@landley.net>
	 <20071026230557.2ac5f9c8.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:42769 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753911AbXJ0NY0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Oct 2007 09:24:26 -0400
In-Reply-To: <20071026230557.2ac5f9c8.rdunlap@xenotime.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Rob Landley <rob@landley.net>, linux-scsi@vger.kernel.org

On Fri, 2007-10-26 at 23:05 -0700, Randy Dunlap wrote:
> On Fri, 26 Oct 2007 23:18:00 -0500 Rob Landley wrote:
> 
> > From: Rob Landley <rob@landley.net>
> > 
> > Add Documentation/DocBook/scsi_midlayer.tmpl and add to Makefile.
> 
> 
> I have comments for all 15 patches here.
> 
> a.  You should cc: the maintainer who you want/expect to apply the
> 	patches.  Always.  Andrew Morton is the only person who
> 	trolls for patches on a mailing list.  :)

Realistically too, for this first batch that covers mostly the mid-layer
and the transport classes, a single patch like you originally submitted
was just fine.  One patch per file isn't.  Patches should be split
across functional areas (in this case the function is simply adding the
SCSI mid layer to the docbook build, so they can all go together).

> b.  The function "Description:" section header is not strictly
> 	required by scripts/kernel-doc.  It will assume that the
> 	first text section after parameters is the Description:
> 	section.  FYI.
> 
> c.  Extraneous whitespace.  Git or quilt check for this.
> 	I don't know about hg...

Actually, the checkpatch.pl script in the scripts directory of the
kernel is very good for this (I ran it on the original monolithic
patch):

jejb@mulgrave> ./scripts/checkpatch.pl ~/tmp.mail
ERROR: trailing whitespace
#1065: FILE: drivers/scsi/scsi_ioctl.c:185:
+ * a pointer to a &struct scsi_device. $

ERROR: trailing whitespace
#1670: FILE: drivers/scsi/scsicam.c:60:
+ * Description : determine the BIOS mapping/geometry used for a drive
in a $

total: 2 errors, 0 warnings, 1502 lines checked
Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

In addition, there seem to be a few functions that you added kerneldoc
for which don't show up in the doc output.  The one that caught my eye
was scsi_cmd_get_serial(), but I think there are others.

James



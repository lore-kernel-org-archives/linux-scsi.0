From: Christoph Hellwig <hch@lst.de>
Subject: What's the state of sdev->tagged_queue
Date: Fri, 6 Jun 2003 09:48:13 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030606074813.GA18748@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:6097 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S265387AbTFFHeo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jun 2003 03:34:44 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: dledford@redhat.com
Cc: linux-scsi@vger.kernel.org

Hi Doug,

scsi_ioctl.c has the following comment from you:

 * The next two ioctls either need to go or need to be changed to
 * pass tagged queueing changes through the low level drivers.
 * Simply enabling or disabling tagged queueing without the knowledge
 * of the low level driver is a *BAD* thing.

and scsi.h has this:

 unsigned tagged_queue:1;/* This is going away!!!!  Look at simple_tags
                            instead!!!  Please fix your driver now!! */

but several drivers still look at it although it's never touched
outside scsi_ioctl.c and the individual drivers.  Most drivers uses also
look pretty bogus.  Can we just the ioctls and the field?


53c700.c:	if(SCp->device->tagged_supported && !SCp->device->tagged_queue
AM53C974.c:				if (!hostdata->connected->device->tagged_queue)
AM53C974.c:			    cmd->device->tagged_queue = 0;
AM53C974.c:	if (cmd->device->tagged_queue && (tag != TAG_NONE)) {
NCR5380.c:						cmd->device->tagged_queue = 0;
arm/acornscsi.c:	if (SCpnt->device->tagged_queue) {
arm/acornscsi.c:	    host->SCpnt->device->tagged_queue = 0;
arm/acornscsi.c:			     scd->tagged_queue ? "en" : "dis",
arm/fas216.c:	if (SCpnt->device->tagged_queue && SCpnt->cmnd[0] != REQUEST_SENSE &&
arm/fas216.c:				     scd->tagged_queue ? "en" : "dis",
ncr53c8xx.c:	if (lp && !lp->numtags && cmd->device && cmd->device->tagged_queue) {
qla1280.c:			if (cmd->device->tagged_queue)
qla1280.c:			if (cmd->device->tagged_queue)
scsi.h:	unsigned tagged_queue:1;/* This is going away!!!!  Look at simple_tags
scsi_ioctl.c:		sdev->tagged_queue = 1;
scsi_ioctl.c:		sdev->tagged_queue = 0;
sym53c8xx.c:	if (lp && !lp->numtags && cmd->device && cmd->device->tagged_queue) {

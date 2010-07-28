From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: [patch 02/10] zfcp: Remove SCSI device when removing unit
Date: Wed, 28 Jul 2010 10:35:54 +0200
Message-ID: <20100728083553.GA3668@schmichrtp.mainz.de.ibm.com>
References: <20100716133733.621672000@de.ibm.com>
 <20100716134300.006377000@de.ibm.com>
 <1280263075.2833.404.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:44092 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459Ab0G1If4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Jul 2010 04:35:56 -0400
Content-Disposition: inline
In-Reply-To: <1280263075.2833.404.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com

On Tue, Jul 27, 2010 at 03:37:55PM -0500, James Bottomley wrote:
> On Fri, 2010-07-16 at 15:37 +0200, Christof Schmitt wrote:
> > plain text document attachment (705-zfcp-unit-removal.diff)
> > From: Christof Schmitt <christof.schmitt@de.ibm.com>
> > 
> > Configuring a LUN in zfcp, also creates a SCSI device. For
> > consistency, it makes sense to remove the SCSI device when the LUN is
> > deconfigured. Replace the flush_work with the call to
> > scsi_remove_device: scsi_remove_device also takes the scan_mutex that
> > synchronizes itself with any long running device discovery.
> 
> This one's rejecting:
> 
> jejb@mulgrave:~/git/scsi-misc-2.6> patch -p1 < ~/tmp/tmp/02
> patching file drivers/s390/scsi/zfcp_def.h
> patching file drivers/s390/scsi/zfcp_scsi.c
> Hunk #1 FAILED at 564.
> 1 out of 1 hunk FAILED -- saving rejects to file
> drivers/s390/scsi/zfcp_scsi.c.rej
> 
> It looks like a missing patch somewhere.
> 
> Could you check the current state of scsi-misc-2.6 (it includes
> scsi-rc-fixes-2.6) and see if I've lost something?

scsi-misc and scsi-rc-fixes have the three fixes i sent for 2.6.35. I
sent them again with six additional fixes here:

http://marc.info/?l=linux-scsi&m=127857607617662&w=2

The six additional patches are missing and this seems to cause the
reject. On top of scsi-misc, these patches apply cleanly in this
order:

>From http://marc.info/?l=linux-scsi&m=127857607617662&w=2
zfcp: Do not unblock rport from REOPEN_PORT_FORCED
zfcp: Do not try "forced close" when port is already closed
zfcp: Register SCSI devices after successful fc_remote_port_add
zfcp: Use forced_reopen in terminate_rport_io callback
zfcp: Fail erp after timeout
zfcp: Fix retry after failed "open port" erp action

>From http://marc.info/?l=linux-scsi&m=127928780100336&w=2
zfcp: Use memdup_user and kstrdup
zfcp: Remove SCSI device when removing unit
zfcp: Use correct width for timer_interval field
zfcp: Cleanup function parameters for sbal value.
zfcp: Cleanup QDIO attachment and improve processing.
zfcp: Post events through FC transport class
zfcp: Prevent access on uninitialized memory.
zfcp: Enable data division support for FCP devices
zfcp: Introduce experimental support for DIF/DIX
zfcp: Trigger logging in the FCP channel on qdio error conditions

I can also resend them in one series if this makes things easier. 

Christof

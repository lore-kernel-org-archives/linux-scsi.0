From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: dmesg spam
Date: Mon, 04 Feb 2008 14:15:00 -0600
Message-ID: <1202156101.3096.102.camel@localhost.localdomain>
References: <20080203143033.cfea0501.akpm@linux-foundation.org>
	 <200802041524.55700.bzolnier@gmail.com>
	 <20080204120548.79f3fe57.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:34178 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755084AbYBDUPI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Feb 2008 15:15:08 -0500
In-Reply-To: <20080204120548.79f3fe57.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-scsi@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, Jeff Garzik <jeff@garzik.org>

On Mon, 2008-02-04 at 12:05 -0800, Andrew Morton wrote:
> On Mon, 4 Feb 2008 15:24:55 +0100 Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> 
> > On Sunday 03 February 2008, Andrew Morton wrote:
> > > 
> > > With latest -mm, running fc8 I am getting this in the logs,
> >                            ^^^
> > => SCSI/libata
> > 
> > cc:ing Jeff
> > 
> > > once per second.
> > > 
> > > sr0: CDROM not ready.  Make sure there is a disc in the drive.
> > > sr0: CDROM not ready.  Make sure there is a disc in the drive.
> > > sr0: CDROM not ready.  Make sure there is a disc in the drive.
> > > sr0: CDROM not ready.  Make sure there is a disc in the drive.
> > > sr0: CDROM not ready.  Make sure there is a disc in the drive.
> > > sr0: CDROM not ready.  Make sure there is a disc in the drive.
> > > sr0: CDROM not ready.  Make sure there is a disc in the drive.
> > > sr0: CDROM not ready.  Make sure there is a disc in the drive.
> > > sr0: CDROM not ready.  Make sure there is a disc in the drive.
> 
> Well..  it's coming out of the kernel.  Presumably it's that cdrom polling
> thing in KDE.  James recently made changes to sr_ioctl.c but I've been
> buried in more terminal regressions than this one.

You're thinking of this one?

commit 210ba1d1724f5c4ed87a2ab1a21ca861a915f734
Author: James Bottomley <James.Bottomley@HansenPartnership.com>
Date:   Sat Jan 5 10:39:51 2008 -0600

    [SCSI] sr: update to follow tray status correctly
    
    Based on an original patch from: David Martin <tasio@tasio.net>
 
You could try reversing it if you want, but I'm not certain that's the
problem (the patch only affected sr_do_status, which is a cdrom internal
thing).

The message comes from sr_ioctl.c:sr_do_ioctl().  Which means some user
level application is poking the drive with a command that's returning
NOT_READY.  Apparently it will shut up if quiet is set in the packet
command structure.

It could be the application is getting the wrong idea of the status from
sr_do_staus() which leads it to send commands which require a medium?
But we'll need a bit of debugging to determine this.

James



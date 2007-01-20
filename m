From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] sd: implement stop_on_shutdown
Date: Sat, 20 Jan 2007 08:39:29 -0600
Message-ID: <1169303969.2842.10.camel@mulgrave.il.steeleye.com>
References: <20070119170122.GS10987@htj.dyndns.org>
	 <45B1574D.1090502@us.ibm.com>  <45B18AE2.3010503@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:59702 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965275AbXATOjj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 20 Jan 2007 09:39:39 -0500
In-Reply-To: <45B18AE2.3010503@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>, Jeff Garzik <jgarzik@pobox.com>, hmh@hmh.eng.br, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On Sat, 2007-01-20 at 12:22 +0900, Tejun Heo wrote:
> Darrick J. Wong wrote:
> > Tejun Heo wrote:
> >> sd doesn't stop (unload head) on shutdown.  This behavior is necessary
> >> for multi initiator cases.  Unloading head by powering off stresses
> >> the drive and sometimes produces distinct clunking noise which
> >> apparently disturbs users considering multiple reports on different
> >> distributions.  halt(8) usually puts the drives to sleep prior to
> >> shutdown but the implementation is fragile and it doesn't work with
> >> sleep-to-disk.
> > 
> > I wonder if this sort of thing (cache flush + spin down) is the sort of
> > thing that ought to be done to near-line storage at suspend time too,
> > though one would want allow_restart = 1 before doing such a thing.
> 
> For ATA, it's currently being done inside libata proper (a bit ugly).
> It would be nice to have those implemented at sd layer but I wonder how
> useful it's going to be for actual SCSI devices.  Do people actually
> suspend using SCSI?  If it's useful at the SCSI layer, I can implement
> and test it with SATA devices here.

There are practical problems to handling this in sd, namely that the
power handling commands and state model are part of the ATA command set,
not part of the SCSI command set.  SAT really only covers the basics of
mapping the different power management models.

However, I suppose if we're going to allow stop on shutdown, it does
make sense to use it on suspend as well.

James



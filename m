From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] sd: implement stop_on_shutdown
Date: Sat, 20 Jan 2007 08:39:36 -0600
Message-ID: <1169303976.2842.11.camel@mulgrave.il.steeleye.com>
References: <20070119170122.GS10987@htj.dyndns.org>
	 <45B1574D.1090502@us.ibm.com> <45B18AE2.3010503@gmail.com>
	 <45B1E5D3.90101@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <45B1E5D3.90101@pobox.com>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Tejun Heo <htejun@gmail.com>, "Darrick J. Wong" <djwong@us.ibm.com>, hmh@hmh.eng.br, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, 2007-01-20 at 04:50 -0500, Jeff Garzik wrote:
> Tejun Heo wrote:
> > Darrick J. Wong wrote:
> >> Tejun Heo wrote:
> >>> sd doesn't stop (unload head) on shutdown.  This behavior is necessary
> >>> for multi initiator cases.  Unloading head by powering off stresses
> >>> the drive and sometimes produces distinct clunking noise which
> >>> apparently disturbs users considering multiple reports on different
> >>> distributions.  halt(8) usually puts the drives to sleep prior to
> >>> shutdown but the implementation is fragile and it doesn't work with
> >>> sleep-to-disk.
> >> I wonder if this sort of thing (cache flush + spin down) is the sort of
> >> thing that ought to be done to near-line storage at suspend time too,
> >> though one would want allow_restart = 1 before doing such a thing.
> > 
> > For ATA, it's currently being done inside libata proper (a bit ugly).
> > It would be nice to have those implemented at sd layer but I wonder how
> > useful it's going to be for actual SCSI devices.  Do people actually
> > suspend using SCSI?  If it's useful at the SCSI layer, I can implement
> > and test it with SATA devices here.
> 
> There is always the open question for multi-initiator SCSI devices, as 
> to who "owns" the SCSI device.  Some devices should be suspended/stopped 
> when the machine is suspended/stopped, others not.

Actually, ownership in multi-initiator is horribly complex: Some cluster
models have transferrable single ownership, but for things like OCFS,
there's no one recognised owner at all (for power down, the owner would
be the last unmounter).  As a practical point, this isn't just a SCSI
problem:  it won't be long before someone realises they can run OCFS
from multiple nodes directly connected over SAS using SATA devices via
an expander.

The current almost de-facto standard for multi-initiator SATA is the DVD
device in a blade centre.

James



From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] New QStor SATA/RAID Driver for 2.6.9-rc2
Date: Wed, 15 Sep 2004 14:55:46 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040915125545.GE4111@suse.de>
References: <414711AC.5030200@rtr.ca> <41471A84.4090200@pobox.com> <4147C38C.3000104@torque.net> <414839F0.20008@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:2023 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S265489AbUIOM5s (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Sep 2004 08:57:48 -0400
Content-Disposition: inline
In-Reply-To: <414839F0.20008@rtr.ca>
List-Id: linux-scsi@vger.kernel.org
To: Mark Lord <lsml@rtr.ca>
Cc: dougg@torque.net, Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org

On Wed, Sep 15 2004, Mark Lord wrote:
> It is currently next-to-impossible for a vendor to support a
> new drive controller card under Linux unless it uses either SCSI
> or libata.  Doing one as a new block driver is not an option,
> because of the installation issues for the end-user during the
> first couple of years of deployment --> until the distros begin
> to include the required /dev/ entries everywhere.
> 
> To solve this requires a nice generic /dev/ interface for disks,
> common to all drivers which talk to such devices.
> 
> Currently on Linux, that interface is called "SCSI".
> I think it might not be unreasonable to gradually evolve
> the SCSI host interface to include, say, a non-translating
> queuecommand() method, and associated pals.
> 
> This would get rid of much (not all) of the double-translation objection,
> and provide a smooth path for supporting Firewire, USB, parallel-port,
> SATA, ATA, and of course SCSI, disks all under one naming subsystem.
> 
> We practically have that already today.
> The SCSI mid-layer is a nice generic block device glue system.
> We just need perhaps to make it less SCSI-specific.

This is what we have been doing for quite some time. If you look, a lot
of the helper functions have actually been moved _out_ of SCSI and into
the block layer. Most of it is already there. The SCSI mid layer is
getting smaller, not bigger.

The remaining piece (well the biggest one at least) is a nice /dev/disk
abstraction. That's currently the biggest obstacle to nice generic block
drivers, not the infrastructure.

-- 
Jens Axboe


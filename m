From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] 2.5.51 SCSI_IOCTL_GET_IDLUN + _GET_BUS_NUMBER
Date: Thu, 12 Dec 2002 18:42:41 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021212174241.GB6481@suse.de>
References: <3DF83E4F.8000704@torque.net> <200212121427.gBCERG502453@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200212121427.gBCERG502453@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: dougg@torque.net, linux-scsi@vger.kernel.org

On Thu, Dec 12 2002, James Bottomley wrote:
> dougg@torque.net said:
> > For disks both the SCSI_IOCTL_GET_IDLUN and SCSI_IOCTL_GET_BUS_NUMBER
> > ioctls return the value 0 (type: int) in all cases. The attachment
> > removes the dummy definitions of these ioctls in driver/block/
> > scsi_ioctl.c so they fall through to the scsi mid level which
> > correctly implements them (at least in terms of lk 2.4). 
> 
> I'm not sure this is the correct thing to do.  These ioctls may be there 
> because cdrecord is using them.  In the new scheme, you can record a CD 
> without ever troubling the scsi mid-layer, so if cdrecord wants them, they 
> have to be provided in some fashion without relying on a fall through.
> 
> I've copied Jens on this mail, since he's the one that knows this stuff and 
> should be able to confirm or deny this suspicion.  Jens?

Hmm, I _may_ be wrong but I think the main reason for GET_IDLUN and
GET_BUS_NUMBER in the generic block layer is to stop them from failing
in libscg and thus fooling it into believing we are scsi. You would need
to check libscg/scsi-linux-sg.c to be sure.

For one thing, we need to maintain the behaviour we have now of _not_
failing them for ata devices. If you want to pass them down to SCSI as
well and get the right id/lun and bus, fine, but don't break the ata
one.

-- 
Jens Axboe


From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] 2.5.51 SCSI_IOCTL_GET_IDLUN + _GET_BUS_NUMBER
Date: Thu, 12 Dec 2002 08:27:16 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200212121427.gBCERG502453@localhost.localdomain>
References: <dougg@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id GAA05458
	for <linux-scsi@vger.kernel.org>; Thu, 12 Dec 2002 06:27:19 -0800
In-Reply-To: Message from Douglas Gilbert <dougg@torque.net>
   of "Thu, 12 Dec 2002 18:44:15 +1100." <3DF83E4F.8000704@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net, axboe@suse.de
Cc: linux-scsi@vger.kernel.org

dougg@torque.net said:
> For disks both the SCSI_IOCTL_GET_IDLUN and SCSI_IOCTL_GET_BUS_NUMBER
> ioctls return the value 0 (type: int) in all cases. The attachment
> removes the dummy definitions of these ioctls in driver/block/
> scsi_ioctl.c so they fall through to the scsi mid level which
> correctly implements them (at least in terms of lk 2.4). 

I'm not sure this is the correct thing to do.  These ioctls may be there 
because cdrecord is using them.  In the new scheme, you can record a CD 
without ever troubling the scsi mid-layer, so if cdrecord wants them, they 
have to be provided in some fashion without relying on a fall through.

I've copied Jens on this mail, since he's the one that knows this stuff and 
should be able to confirm or deny this suspicion.  Jens?

James



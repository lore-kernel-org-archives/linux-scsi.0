From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Revisiting task tags and Linux SCSI
Date: Thu, 09 May 2002 09:10:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200205091310.g49DAMB01883@localhost.localdomain>
References: <mheinz@infiniconsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id GAA21513
	for <linux-scsi@vger.kernel.org>; Thu, 9 May 2002 06:10:25 -0700
In-Reply-To: Message from "Heinz, Michael" <mheinz@infiniconsys.com>
   of "Wed, 08 May 2002 23:01:11 EDT." <08628CA53C6CBA4ABAFB9E808A5214CB0C5E9D@mercury.infiniconsys.com>
List-Id: linux-scsi@vger.kernel.org
To: "Heinz, Michael" <mheinz@infiniconsys.com>
Cc: linux-scsi@vger.kernel.org

mheinz@infiniconsys.com said:
> Maybe I'm an idiot - but I cannot find *anywhere* in sd.c, sg.c,
> scsi.c or elsewhere that the scsi_cmnd.tag field is set to anything
> except zero, nor can I find anywhere in the high level SCSI drivers
> that the "scsi_device.tagged_*" fields are used. 

> Am I wrong here? I can certainly generate task tags that are
> guaranteed to be unique (I already have to do that anyway), and I can
> certainly 'or' them with ORDERED_QUEUE_TAG but I'm not sure how that's
> going to impact the higher level SCSI drivers since they never pay
> attention to the values of any of the "tagged_*" fields anyway..... 

No, you're not wrong.  In the current layering model, tags are manipulated 
almost exclusively by the low level drivers (see aic7xxx, sym8xxx, 53c700 for 
details).  If you use a LLD without TCQ support, then you only send one 
command per lun.

scsi_cmnd.tag is really never used, I believe.

This is counter intuitive since tag manipulation functions should be higher up 
in the driver stack, but that's the way it works today.  Jens Axboe is working 
on generic tag functions (look in block/ll_rw_block.c) but they were only 
introduced recently and aren't yet used in the SCSI layer at all.

James Bottomley



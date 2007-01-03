From: Mark Lord <liml@rtr.ca>
Subject: Re: [PATCH] SCSI, libata: add support for ATA_16	commands	to	libata
 ATAPI devices
Date: Wed, 03 Jan 2007 18:57:43 -0500
Message-ID: <459C42F7.2000000@rtr.ca>
References: <200701021935.07840.liml@rtr.ca>	 <1167788405.3687.25.camel@mulgrave.il.steeleye.com>	 <459B4243.5080804@rtr.ca>	 <1167838307.2789.12.camel@mulgrave.il.steeleye.com>	 <459C066D.30507@torque.net> <1167860496.2789.70.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1167860496.2789.70.camel@mulgrave.il.steeleye.com>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: dougg@torque.net, Linux IDE <linux-ide@vger.kernel.org>, Tejun Heo <htejun@gmail.com>, Jeff Garzik <jeff@garzik.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

James Bottomley wrote:
>
> As I read the code Mark sent me, current libata will only accept ATA_16
> for ATAPI devices (whether type 5 or not) ... pehaps this needs to be
> altered?

It could be.

Both ATA_12 and ATA_16 are just ways of getting a taskfile sent
down to the LLD, and ATA_12 is merely a restricted subset of ATA_16
so it is not really necessary here.

I think that given the opcode conflict with "BLANK", it may be best for
the moment to just not bother with ATA_12 for libata ATAPI.  We don't really
have a need for ATA_12 anyway, as ATA_16 is more flexible.

And any application code that uses these isn't going to want to have
to vary its commands between ATA_12 and ATA_16 depending upon the target.
I think they'll all just go straight for ATA_16 for uniformity and
to minimize testing drudgery.

hdparm will certainly use only ATA_16 once it becomes available in SCSI/libata.

Cheers

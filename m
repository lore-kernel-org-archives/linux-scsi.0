From: Jeff Garzik <jeff@garzik.org>
Subject: ATA ULD (was Re: [PATCH 2/3] scsi: add scsi_device->alt_capacity)
Date: Fri, 15 May 2009 15:44:57 -0400
Message-ID: <4A0DC639.8060104@garzik.org>
References: <1241828002-12742-1-git-send-email-tj@kernel.org>	 <1241828002-12742-3-git-send-email-tj@kernel.org>	 <1241842999.6357.2.camel@mulgrave>  <4A05AAA4.9010806@kernel.org> <1241886223.3542.37.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:55119 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958AbZEOTpC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 May 2009 15:45:02 -0400
In-Reply-To: <1241886223.3542.37.camel@mulgrave.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Mauelshagen@RedHat.com, dm-devel@RedHat.com, dan.j.williams@gmail.com

James Bottomley wrote:
> On Sun, 2009-05-10 at 01:09 +0900, Tejun Heo wrote:
>> James Bottomley wrote:
>>> This is done at slightly the wrong level.  Capacity is actually a
>>> property of struct scsi_disk not struct scsi_device ... shouldn't
>>> alt_capacity be at the same level?
>> Hmmm... I think that was my first try and then I moved it to sdev for
>> some reason I can't rememer now.  I'll look into it again and try to
>> move it into sdev.
> 
> Really one of the things I was wondering is why even scsi_disk ...
> capacity is in there, but it's also in gendisk, so I've thought
> (admittedly never translated it to action) that we could just remove the
> duplication in scsi_disk.
> 
> This alt_capacity looks to be a pure ATA thing ... I can't find it in
> the SCSI specs and there doesn't seem to be a SAT equivalent of the
> commands.  Ideally, what should be happening is that the ata ULD would
> issue the capacity commands and just set the block alt_capacity without
> having to worry about transporting the value up and down the stack.
> Matthew Wilcox thought we could begin an implementation of the ATA uld
> using the ATA_16 command to transport it through SCSI ... this might
> provide the good reason to begin that.

hmmmmm.  Well, ATA ULD is certainly the long term goal.  My main worry 
would then be user impact & confusion, and increasing the difficulty of 
separating libata from SCSI by increasing difficulty of making SCSI 
emulation an optional piece.

At this point the SCSI emulation is not only a hack to get sd.c to do 
work for us, it is also part of the ABI expected of diagnostic tools and 
the like.  That complicates changes.

It is my hope that we can separate libata-scsi.c into a separate kernel 
module, thus at least making it _optional_, thus providing a path for 
CONFIG_ATA + !CONFIG_SCSI.

I do also agree that the ATA hacks can only go on for so long, before 
they start infecting SCSI.   e.g. there was a patch to add DMI check in 
sd.c for an ATA hardware special case.

So far the "ATA infection" has been thankfully limited to things that sd 
might need anyway, like suspend/resume (start/stop)

A "libsd" does not seem viable, though.  Might be better to
	cp sd.c ata-disk.c
and then iterate from there, over time.

	Jeff





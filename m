From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 2/3] scsi: add scsi_device->alt_capacity
Date: Sat, 09 May 2009 16:23:43 +0000
Message-ID: <1241886223.3542.37.camel@mulgrave.int.hansenpartnership.com>
References: <1241828002-12742-1-git-send-email-tj@kernel.org>
	 <1241828002-12742-3-git-send-email-tj@kernel.org>
	 <1241842999.6357.2.camel@mulgrave>  <4A05AAA4.9010806@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4A05AAA4.9010806@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: jeff@garzik.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Mauelshagen@RedHat.com, dm-devel@RedHat.com, dan.j.williams@gmail.com
List-Id: linux-scsi@vger.kernel.org

On Sun, 2009-05-10 at 01:09 +0900, Tejun Heo wrote:
> James Bottomley wrote:
> > This is done at slightly the wrong level.  Capacity is actually a
> > property of struct scsi_disk not struct scsi_device ... shouldn't
> > alt_capacity be at the same level?
> 
> Hmmm... I think that was my first try and then I moved it to sdev for
> some reason I can't rememer now.  I'll look into it again and try to
> move it into sdev.

Really one of the things I was wondering is why even scsi_disk ...
capacity is in there, but it's also in gendisk, so I've thought
(admittedly never translated it to action) that we could just remove the
duplication in scsi_disk.

This alt_capacity looks to be a pure ATA thing ... I can't find it in
the SCSI specs and there doesn't seem to be a SAT equivalent of the
commands.  Ideally, what should be happening is that the ata ULD would
issue the capacity commands and just set the block alt_capacity without
having to worry about transporting the value up and down the stack.
Matthew Wilcox thought we could begin an implementation of the ATA uld
using the ATA_16 command to transport it through SCSI ... this might
provide the good reason to begin that.

James



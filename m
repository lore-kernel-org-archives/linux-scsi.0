From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [patch 4/6] ps3: Disk Storage Driver
Date: Fri, 15 Jun 2007 15:40:42 -0700
Message-ID: <1181947242.3600.8.camel@mulgrave.il.steeleye.com>
References: <1181918159.25228.543.camel@pmac.infradead.org>
	 <Pine.LNX.4.62.0706151642010.8248@pademelon.sonytel.be>
	 <20070615171545.316dfac7@the-village.bc.nu>
	 <20070615.141917.85409547.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:50704 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755834AbXFOWkq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Jun 2007 18:40:46 -0400
In-Reply-To: <20070615.141917.85409547.davem@davemloft.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: alan@lxorguk.ukuu.org.uk, Geert.Uytterhoeven@sonycom.com, dwmw2@infradead.org, axboe@kernel.dk, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, paulus@samba.org

On Fri, 2007-06-15 at 14:19 -0700, David Miller wrote:
> From: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Date: Fri, 15 Jun 2007 17:15:45 +0100
> 
> > > > Any particular reason why this is done as a separate block device driver
> > > > rather than as SCSI?
> > > 
> > > Because no new fake SCSI drivers are accepted anymore.
> > 
> > Where did drivers/ata come from ;)
> > 
> > How about making it a fake ata driver if James is being fussy 8)
> 
> That sounds like a good idea for my virtual I/O case on
> Niagara too actually :-)

I have no objections to VIO servers speaking SCSI ... if you want to do
that, I suggest you look at an existing example, like
drivers/scsi/ibmvscsi (the actual communication piece is very ppc
hypervisor specific, though).

However, I do strongly believe that using SCSI for devices which truly
aren't SCSI (i.e. you have to code a shim in the driver between the SCSI
commands and whatever your device speaks) is wrong ... if SCSI has
features that the generic block layer doesn't, then we need to move the
function from SCSI to block to give you access ... in theory this was
the rationale for having libata as the last "fake" SCSI driver, so we
could identify this functionality and begin to move it.

> Another quirk I have to deal with is that under LDOMs you
> can export full disks and also just slices.  So I'll have
> to get down into the partition machinery to support that
> somehow.

For this, it sounds like you might find nbd a more enticing
proposition ... it already is partition independent and is basically a
block to net socket exporter.

James



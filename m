From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: sbp2: modprobe -r fails, module allegedly in use
Date: Sun, 10 Jul 2005 12:29:22 -0500
Message-ID: <1121016562.5078.15.camel@mulgrave>
References: <42D133EE.9090204@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:17804 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261980AbVGJR30 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 10 Jul 2005 13:29:26 -0400
In-Reply-To: <42D133EE.9090204@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, linux1394-devel@lists.sourceforge.net, Ben Collins <bcollins@debian.org>

On Sun, 2005-07-10 at 16:42 +0200, Stefan Richter wrote:
> it seems the sbp2 driver module can never be unloaded because the
> module "is in use" even though all SBP-2 devices were physically removed
> (after umount etc.). I believe it is an old problem of the last few 2.6
> kernels but am not sure when it was really introduced.
> 
> One thing can easily be spotted by "ps x": The scsi_error_handler of an
> SBP-2 device does not exit. The /sys/bus/scsi/devices/$a:$b:$c:$d 
> vanished, the /sys/bus/ieee1394/devices/$guid-$unit too, but the 
> scsi_eh_# daemon is still there. It seems shost->shost_gendev.release 
> was never called.
> 
> So I just added a few more scsi_host_put() to sbp2_remove_device(). 
> scsi_eh_# now goes away when I disconnect the device. Still, modprobe -r 
> sbp2 fails with "FATAL: Module sbp2 is in use.".

Actually, I think your error is the opposite of this: you should never
have to do a scsi_host_put() unless you did a corresponding
scsi_host_get(), which, as far as I can see, sbp2 never does, so the
extra put should be meaningless.

Except, I notice that you don't do a scsi_device_put() after
scsi_add_device().  I think this is probably the source of the
refcounting errors: scsi_add_device returns an sdev with the refcount
incremented by one, so you need to decrement the count after you've
finished with it (in your case, you do nothing with it, so just
decrement after you've checked it's not an error pointer).

James



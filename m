From: Ben Collins <bcollins@debian.org>
Subject: Re: sbp2: modprobe -r fails, module allegedly in use
Date: Sun, 10 Jul 2005 11:31:26 -0400
Message-ID: <20050710153126.GB14956@phunnypharm.org>
References: <42D133EE.9090204@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [206.246.247.150] ([206.246.247.150]:64227 "EHLO
	bristol.phunnypharm.org") by vger.kernel.org with ESMTP
	id S261883AbVGJPb1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 10 Jul 2005 11:31:27 -0400
Content-Disposition: inline
In-Reply-To: <42D133EE.9090204@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-scsi@vger.kernel.org, linux1394-devel@lists.sourceforge.net

Yeah, seems like every two months we have to change sbp2 to accomodate
changes to the scsi layers whole reference scheme which never seems
simple, and never stays the same.

Any of the scsi guys care to comment on any changes in the reference
counting to scsi over the last couple of months? Seriously, I've been
having to go through tracking these sorts of changes every month or so
ever since scsi switched to using the driver model. Usually I just take a
peek at the usb storage module, since it somehow seems to stay up with
whatever changes are needed to keep working with the scsi callbacks.

On Sun, Jul 10, 2005 at 04:42:54PM +0200, Stefan Richter wrote:
> Hi all,
> 
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
> -- 
> Stefan Richter
> -=====-=-=-= -=== -=-=-
> http://arcgraph.de/sr/
> 

-- 
Debian     - http://www.debian.org/
Linux 1394 - http://www.linux1394.org/
Subversion - http://subversion.tigris.org/
SwissDisk  - http://www.swissdisk.com/

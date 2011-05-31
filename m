From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: 2.6.39 and Powerfile c200
Date: Tue, 31 May 2011 21:26:43 +0200
Message-ID: <20110531212643.174c2739@stein>
References: <BANLkTikkCOML4aNv_wSrk9VRSofjVwtVAw@mail.gmail.com>
	<20110528202646.02280a95@stein>
	<BANLkTi=JUTZ+7DNNZJR5wpODes78tYPVjA@mail.gmail.com>
	<BANLkTin=kaUtYMi7QeEAJmSLvLm7rmADkQ@mail.gmail.com>
	<20110530232429.3ef05054@stein>
	<BANLkTin4A-RCNtogW6LiVpumNcea+rmCAg@mail.gmail.com>
	<20110530233841.4e652322@stein>
	<BANLkTinSPtcr-btv7v5ZUkdPObguYDSSag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:34560 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807Ab1EaT04 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 31 May 2011 15:26:56 -0400
In-Reply-To: <BANLkTinSPtcr-btv7v5ZUkdPObguYDSSag@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jonathan Isom <jeisom@gmail.com>
Cc: linux1394-user@lists.sourceforge.net, linux-scsi@vger.kernel.org

On May 31 Jonathan Isom wrote:
> Well I did some further testing.  If I boot with /bin/sh as init and
> manually load the firewire modules the C200 works.  I moved out all
> kernel modules but firewire and loaded init and it start giving the
> offline messages.  So it appears to be a userspace problem.

(Or a firmware problem actually, provoked by Linux userspace that does not
behave like a Windows system.)

> Just  not sure where to start. I already did some digging in udev but
> no luck so far. I'm running gentoo which probably make tracking it
> down just a little harder as there are few identical installs in the
> world.  Below is a listing of init scripts loaded at boot.
> 
> Any Ideas?
[...]

Nothing obvious as far as I can tell.  The mythbackend perhaps?  Or a GUI
desktop component that is started after login into xdm?

I don't know if there is a logging facility in the kernel's SCSI layer
that could expose the process name of SCSI ioctl issuers, but you can add
one:

--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -479,6 +479,9 @@ static int sr_block_open(struct block_de
 		ret = cdrom_open(&cd->cdi, bdev, mode);
 		if (ret)
 			scsi_cd_put(cd);
+		else
+			printk(KERN_INFO "***** %s opened by %s *****\n",
+			       cd->cdi.name, current->comm);
 	}
 	mutex_unlock(&sr_mutex);
 	return ret;

-- 
Stefan Richter
-=====-==-== -=-= =====
http://arcgraph.de/sr/

From: Philipp Matthias Hahn <pmhahn@titan.lahn.de>
Subject: Re: Linux-2.6.13-rc6: aic7xxx testers please..
Date: Thu, 11 Aug 2005 08:34:07 +0200
Message-ID: <20050811063407.GA21395@titan.lahn.de>
References: <Pine.LNX.4.58.0508071136020.3258@g5.osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ip-svs-1.Informatik.Uni-Oldenburg.DE ([134.106.12.126]:63884
	"EHLO aechz.svs.informatik.uni-oldenburg.de") by vger.kernel.org
	with ESMTP id S964800AbVHKGfE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Aug 2005 02:35:04 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0508071136020.3258@g5.osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>

Hello!

On Sun, Aug 07, 2005 at 11:47:53AM -0700, Linus Torvalds wrote:
> James and gang found the aic7xxx slowdown that happened after 2.6.12, and 
> we'd like to get particular testing that it's fixed, so if you have a 
> relevant machine, please do test this.

I just tried 2.6.13-rc6 after my last 2.6.11.12 and got a problem with
the onboard aic7xxx on my old Gigabyte-6BXDS dual i686-600: During boot,
something bad happened within domain validation and I got an oops from
an unhandled NULL pointer. Since I don't have a secondary computer at
home to capture the OOPS, here's the shortened stacktrace written down
by hand:
	show_stack
	show_register
	die
	do_page_fault
	error_code
	ahc_set_syncrate
	ahc_reset_channel
	ahc_linux_bus_reset
	scsi_try_bus_reset
	scsi_eh_bus_reset
	scsi_eh_ready_devs
	scsi_unjam_host
	scsi_error_handler
	kernel_thread_helper

After chaning the Adaptec bios setting for the Pioneer CDROM from
"async" to "10 MB", I was able to boot the same kernel without problems.

If somebody needs more information, I can reproduce the OOPS again and
provide the missing information.

BYtE
Philipp
-- 
  / /  (_)__  __ ____  __ Philipp Hahn
 / /__/ / _ \/ // /\ \/ /
/____/_/_//_/\_,_/ /_/\_\ pmhahn@titan.lahn.de

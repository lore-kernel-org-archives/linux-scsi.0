From: Joe Korty <joe.korty@ccur.com>
Subject: Re: [PATCH] Fix section mismatch in the Adaptec DPT SCSI Raid driver
Date: Fri, 17 Aug 2007 19:01:30 -0400
Message-ID: <20070817230130.GB1840@tsunami.ccur.com>
References: <20070817205115.GA12416@tsunami.ccur.com> <20070817141856.5720ed38.akpm@linux-foundation.org>
Reply-To: Joe Korty <joe.korty@ccur.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from flvpn.ccur.com ([66.10.65.2]:60589 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751654AbXHQXBq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Aug 2007 19:01:46 -0400
Content-Disposition: inline
In-Reply-To: <20070817141856.5720ed38.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <matthew@wil.cx>
Cc: aacraid@adaptec.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, Aug 17, 2007 at 02:18:56PM -0700, Andrew Morton wrote:
> Please always provide at least a copy of the error message when providing
> patches which fix warnings, or build errors, or section mismatches.
> 
> For section mismatches, an analysis of what caused the problem would help,
> too.  It saves others from having to do the same thing.
> 
> In this case, I'd need to see what error is being fixed so that I can judge
> the seriousness of the problem.  In this case I don't _think_ it'll be
> terribly serious because iirc most architectures don't free exitcall memory.




Fix section mismatch in the Adaptec DPT SCSI Raid driver.

WARNING: vmlinux.o(.init.text+0x1fcd2): Section mismatch:
	reference to .exit.text:adpt_exit (between 'adpt_init' and 'ahc_linux_init')

This warning is due to adaptec device detection calling the exit routine
on failure to properly register the adaptec device.

The exit routine + call was added on July 30 by
  Commit: 55d9fcf57ba5ec427544fca7abc335cf3da78160
  Author: Matthew Wilcox
  Subject: [SCSI] dpt_i2o: convert to SCSI hotplug model.

Mathew: isn't a module exit routine a little too strong to be calling
on the failure of a single device?  Module exit implies that other,
non-failing adaptec raid devices will also get shut down.

Signed-off-by: Joe Korty <joe.korty@ccur.com>

Index: 2.6.23-rc3-git1/drivers/scsi/dpt_i2o.c
===================================================================
--- 2.6.23-rc3-git1.orig/drivers/scsi/dpt_i2o.c	2007-08-17 16:36:05.000000000 -0400
+++ 2.6.23-rc3-git1/drivers/scsi/dpt_i2o.c	2007-08-17 16:50:13.000000000 -0400
@@ -3351,7 +3351,7 @@
 	return count > 0 ? 0 : -ENODEV;
 }
 
-static void __exit adpt_exit(void)
+static void adpt_exit(void)
 {
 	while (hba_chain)
 		adpt_release(hba_chain);

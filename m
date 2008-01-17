From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.24-rc8-mm1 Build Failure on scsi driver
Date: Thu, 17 Jan 2008 11:11:04 -0800
Message-ID: <20080117111104.3baa878e.akpm@linux-foundation.org>
References: <20080117023514.9df393cf.akpm@linux-foundation.org>
	<478F7F2B.9000801@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55314 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751790AbYAQTLr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jan 2008 14:11:47 -0500
In-Reply-To: <478F7F2B.9000801@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, fischer@norbit.de, Andy Whitcroft <apw@shadowen.org>, Balbir Singh <balbir@linux.vnet.ibm.com>, Samuel Ortiz <samuel@sortiz.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Tejun Heo <htejun@gmail.com>

On Thu, 17 Jan 2008 21:45:39 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:

> Hi Andrew,
> 
> The kernel build fails with following error
> 
> drivers/scsi/aha152x.o: In function `aha152x_host_reset_host':
> /home/kamalesh/scrap/linux-2.6.24-rc8/drivers/scsi/aha152x.c:1324: multiple definition of `aha152x_host_reset_host'
> drivers/scsi/pcmcia/built-in.o:/home/kamalesh/scrap/linux-2.6.24-rc8/drivers/scsi/aha152x.c:1324: first defined here
> drivers/scsi/aha152x.o: In function `aha152x_release':
> /home/kamalesh/scrap/linux-2.6.24-rc8/drivers/scsi/aha152x.c:908: multiple definition of `aha152x_release'
> drivers/scsi/pcmcia/built-in.o:/home/kamalesh/scrap/linux-2.6.24-rc8/drivers/scsi/aha152x.c:908: first defined here
> ld: Warning: size of symbol `aha152x_release' changed from 68 in drivers/scsi/pcmcia/built-in.o to 100 in drivers/scsi/aha152x.o
> drivers/scsi/aha152x.o: In function `aha152x_probe_one':

Neat.  Seems that the scsi build system is linking together two copies of
drivers/scsi/aha152x.o.  One via drivers/scsi/aha152x.o directly and the
other via drivers/scsi/pcmcia/built-in.o.

Please send the .config.

I'm looking suspiciously at this, from git-scsi-misc:

commit 8ae732a91df051aba6820068a47b631a06599d84
Author: Tejun Heo <htejun@gmail.com>
Date:   Fri Dec 7 22:36:23 2007 +0900

    [SCSI] make pcmcia directory use obj-y|m instead of subdir-y|m
    
    subdir-y|m isn't supposed to contain modules or built-in components.
    Change subdir-$(CONFIG_PCMCIA) to obj-$(CONFIG_PCMCIA).
    
    Signed-off-by: Tejun Heo <htejun@gmail.com>
    Acked-by: Sam Ravnborg <sam@ravnborg.org>
    Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index b5441f5..93e1428 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -17,7 +17,7 @@
 CFLAGS_aha152x.o =   -DAHA152X_STAT -DAUTOCONF
 CFLAGS_gdth.o    = # -DDEBUG_GDTH=2 -D__SERIAL__ -D__COM2__ -DGDTH_STATISTICS
 
-subdir-$(CONFIG_PCMCIA)		+= pcmcia
+obj-$(CONFIG_PCMCIA)		+= pcmcia/
 
 obj-$(CONFIG_SCSI)		+= scsi_mod.o
 obj-$(CONFIG_SCSI_TGT)		+= scsi_tgt.o


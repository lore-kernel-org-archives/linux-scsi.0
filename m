From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: Re: 2.6.0-test5-mm1 aha152x **still** doesn't work (fwd)
Date: Wed, 10 Sep 2003 10:56:22 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030910105622.783ac4a3.rddunlap@osdl.org>
References: <Pine.LNX.3.96.1030910101202.21238F-100000@gatekeeper.tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:46750 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S265316AbTIJSCJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Sep 2003 14:02:09 -0400
In-Reply-To: <Pine.LNX.3.96.1030910101202.21238F-100000@gatekeeper.tmr.com>
List-Id: linux-scsi@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: linux-scsi@vger.kernel.org, jejb <james.bottomley@steeleye.com>

(moving to linux-scsi)

On Wed, 10 Sep 2003 10:14:37 -0400 (EDT) Bill Davidsen <davidsen@tmr.com> wrote:

| 
| oddball:root> modprobe aha152x aha152x=0x340,9,7,1,1,1
| SCSI subsystem initialized
| aha152x: invalid module params io=0x340, irq=8,scsiid=7,reconnect=1,parity=1,sync=1,delay=1000,exttrans=0
| FATAL: Error inserting aha152x 
| (/lib/modules/2.6.0-test5-mm1/kernel/drivers/scsi/aha152x.ko): No such 
| device
| 
| 
| It happily looks at the "9" in the init string and says "irq=8" doesn't 
| work. Works with the 2.4.18 kernel from RH7.3, so ??? The IRQ jumpers are 
| soldered on the board.
| 
| Clearly if I had the option of using another board I would, that's not
| going to happen for various reasons (administrative and technical).

The patch below enables aha152x to build when AHA152X_DEBUG
is #defined (before #include "aha152x.h").

Bill- the driver module scans the parameter list correctly for me,
but I don't have hardware...  What's different about your setup?

James, please apply to 2.6.0-test5.

--
~Randy


patch_name:	aha152x_debugon.patch
patch_version:	2003-09-10.11:02:09
author:		Randy.Dunlap <rddunlap@osdl.org>
description:	enable aha152x to build when AHA152X_DEBUG is defined;
product:	Linux
product_versions: 260-test5
maintainer:	James Bottomley
diffstat:	=
 drivers/scsi/aha152x.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -Naurp ./drivers/scsi/aha152x.c~compdebug ./drivers/scsi/aha152x.c
--- ./drivers/scsi/aha152x.c~compdebug	2003-09-10 10:40:22.000000000 -0700
+++ ./drivers/scsi/aha152x.c	2003-09-10 10:54:30.000000000 -0700
@@ -1762,7 +1762,7 @@ static void reset_ports(struct Scsi_Host
 int aha152x_host_reset(Scsi_Cmnd * SCpnt)
 {
 #if defined(AHA152X_DEBUG)
-	struct Scsi_Host *shpnt = SCpnt->host;
+	struct Scsi_Host *shpnt = SCpnt->device->host;
 #endif
 
 	DPRINTK(debug_eh, DEBUG_LEAD "aha152x_host_reset(%p)\n", CMDINFO(SCpnt), SCpnt);

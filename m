From: Adrian Bunk <bunk@kernel.org>
Subject: [2.6 patch] esp_scsi.c: remove __dev{init,exit}
Date: Thu, 11 Oct 2007 17:35:20 +0200
Message-ID: <20071011153520.GA16424@stusta.de>
References: <200710110552.49129.rob@landley.net> <20071011110555.GV16424@stusta.de> <200710110817.22344.rob@landley.net> <1192109439.3352.11.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:43574 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753874AbXJKPex (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Oct 2007 11:34:53 -0400
Content-Disposition: inline
In-Reply-To: <1192109439.3352.11.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Rob Landley <rob@landley.net>, linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>

On Thu, Oct 11, 2007 at 08:30:38AM -0500, James Bottomley wrote:
> On Thu, 2007-10-11 at 08:17 -0500, Rob Landley wrote:
> > On Thursday 11 October 2007 6:05:55 am Adrian Bunk wrote:
> > > On Thu, Oct 11, 2007 at 05:52:48AM -0500, Rob Landley wrote:
> > > > CONFIG_SCSI_SUNESP=y breaks the build in 2.6.23:
> > > >
> > > >   LD      vmlinux
> > > > `scsi_esp_unregister' referenced in section `__ksymtab' of
> > > > drivers/built-in.o: defined in discarded section `.exit.text' of
> > > > drivers/built-in.o
> > > > make: *** [vmlinux] Error 1
> > > >
> > > > Do you need my full .config to reproduce this?
> > >
> > > Please always attach the .config when reporting errors.
> > > The few bytes don't matter and it often saves some time.
> > >
> > > I have an idea regarding what might be going wrong in this case,
> > > but it would cost me additional time to look at it because you didn't
> > > send your .config.
> > 
> > *shrug*  That's why I asked.
> > 
> > The reason I hesitated is I use miniconfig files rather than big .config 
> > files, and some people get confused by that.  Drop the attached 
> > miniconfig-linux in the kernel source directory and go:
> >   make ARCH=sparc allnoconfig KCONFIG_ALLCONFIG=miniconfig-linux
> > 
> > That expands it to a big .config file, and from there "make ARCH=sparc 
> > CROSS_COMPILE=sparc-" to reproduce the problem.  Assuming you have a sparc 
> > cross-compiler lying around.
> > 
> > Disable CONFIG_SCSI_SUNESP and it builds to the end, (and the result boots but 
> > won't mount the root filesystem, which is sort of expected).
> 
> This is a very subtle error.  You're building without hotplug, which
> causes __devexit to become __exit, so scsi_esp_unregister is placed in
> the discard section of vmlinux.  Unfortunately, the EXPORT_SYMBOL causes
> it to be referenced from the symbol export table.
> 
> The fix is probably just to remove the __devexit tag from the function
> rather than trying to work out how to make the export symbol conditional
> on the symbol not being discarded.

You can't make it conditional on that since a built-in esp_scsi could 
have modular users.

scsi_esp_register() is also buggy since it's impossible that the 
EXPORT_SYMBOL(scsi_esp_register) works in the CONFIG_HOTPLUG=n case when 
it's __devinit - it will always Oops.

Having anything exported __{,dev}{init,exit} is always very likely to be 
buggy.

Patch below.

> James

cu
Adrian


<--  snip  -->


Since scsi_esp_{,un}register() are EXPORT_SYMBOL'ed, these functions
(and the functions they use) can't be __dev{init,exit}.

Based on a bug report by Rob Landley.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/scsi/esp_scsi.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- linux-2.6.23/drivers/scsi/esp_scsi.c.old	2007-10-11 17:29:50.000000000 +0200
+++ linux-2.6.23/drivers/scsi/esp_scsi.c	2007-10-11 17:31:25.000000000 +0200
@@ -2138,7 +2138,7 @@
 }
 EXPORT_SYMBOL(scsi_esp_intr);
 
-static void __devinit esp_get_revision(struct esp *esp)
+static void esp_get_revision(struct esp *esp)
 {
 	u8 val;
 
@@ -2187,7 +2187,7 @@
 	}
 }
 
-static void __devinit esp_init_swstate(struct esp *esp)
+static void esp_init_swstate(struct esp *esp)
 {
 	int i;
 
@@ -2233,7 +2233,7 @@
 	esp_read8(ESP_INTRPT);
 }
 
-static void __devinit esp_set_clock_params(struct esp *esp)
+static void esp_set_clock_params(struct esp *esp)
 {
 	int fmhz;
 	u8 ccf;
@@ -2306,7 +2306,7 @@
 
 static struct scsi_transport_template *esp_transport_template;
 
-int __devinit scsi_esp_register(struct esp *esp, struct device *dev)
+int scsi_esp_register(struct esp *esp, struct device *dev)
 {
 	static int instance;
 	int err;
@@ -2346,7 +2346,7 @@
 }
 EXPORT_SYMBOL(scsi_esp_register);
 
-void __devexit scsi_esp_unregister(struct esp *esp)
+void scsi_esp_unregister(struct esp *esp)
 {
 	scsi_remove_host(esp->host);
 }


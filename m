From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: advansys regions [Re: 2.4 vs 2.6 versions of
 include/linux/ioport.h]
Date: Wed, 6 Aug 2003 10:40:41 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030806104041.4a09f4f0.rddunlap@osdl.org>
References: <200308051041.08078.gene.heskett@verizon.net>
	<20030805075758.31f51879.rddunlap@osdl.org>
	<200308052050.07841.gene.heskett@verizon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:40156 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S270763AbTHFRog (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Aug 2003 13:44:36 -0400
In-Reply-To: <200308052050.07841.gene.heskett@verizon.net>
List-Id: linux-scsi@vger.kernel.org
To: gene.heskett@verizon.net
Cc: linux-scsi@vger.kernel.org

On Tue, 5 Aug 2003 20:50:07 -0400 Gene Heskett <gene.heskett@verizon.net> wrote:

| On Tuesday 05 August 2003 10:57, Randy.Dunlap wrote:
| >On Tue, 5 Aug 2003 10:41:08 -0400 Gene Heskett 
| <gene.heskett@verizon.net> wrote:
| >| Greetings;
| >|
| >| In the 2.4 includes, find this in ioport.h
| >| ----
| >| /* Compatibility cruft */
| >| #define check_region(start,n)   __check_region(&ioport_resource,
| >| (start), (n))
| >| [snip]
| >| extern int __check_region(struct resource *, unsigned long,
| >| unsigned long);
| >| ----
| >| But in the 2.6 version, find this:
| >| ----
| >| /* Compatibility cruft */
| >| [snip]
| >| extern int __check_region(struct resource *, unsigned long,
| >| unsigned long);
| >| [snip]
| >| static inline int __deprecated check_region(unsigned long s,
| >| unsigned long n)
| >| {
| >|         return __check_region(&ioport_resource, s, n);
| >| }
| >| ----
| >| First, the define itself is missing in the 2.6 version.
| >|
| >| Many drivers seem to use this call, and in that which I'm trying
| >| to build, the nforce and advansys modules use it.  And while the
| >| modules seem to build, they do not run properly.
| >|
| >| I cannot run 2.6.x for extended tests because of the advansys
| >| breakage this causes.  I also haven't even tried to run X because
| >| of the nforce error reported when its built, the same error as
| >| attacks the advansys code.
| >|
| >| Can I ask why this change was made, and is there a suitable
| >| replacement call available that these drivers could use instead of
| >| check_region(), as shown here in a snip from advansys.c?
| >| ----
| >| if (check_region(iop, ASC_IOADR_GAP) != 0) {
| >| ...
| >| if (check_region(iop_base, ASC_IOADR_GAP) != 0) {
| >| ...
| >|
| >| Hopeing for some hints here.
| >
| >check_region() was racy.  Use request_region() instead.
| >
| >   if (!request_region(iop, ASC_IOADR_GAP, "advansys")) {
| >   ...
| >
| >   if (!request_region(iop_base, ASC_IOADR, "advansys")) {
| >   ...
| >
| >Of course, if successful, this assigns the region to the driver,
| >while check_region() didn't do this, so release_region() should be
| >used as needed to return the resources.
| 
| Randy, look the attached patch over & see if its suitable.  Its 
| against the driver in the 2.6.0-test2 archive, and was done from 
| within the drivers/scsi directory.  Its working fine here, booting 
| and accessing my tape drive just fine with the advansys driver 
| incorporated into the kernel, or as a module.  I didn't see any 
| memory leakage, but my test method isn't definitive.
| 
| If its suitable, pass it on to Linus.  It will add one more card to 
| the NOT broken by 2.6 list.

First, I've moved this to the linux-scsi mailing list for more/better
comments.

Second, (minor nit) part of your patch[1] contained a line that only
added a trailing space.

But most importantly, if I'm reading it correctly, the driver now does
request_region() 2 times for an IO region (note: for CONFIG_ISA only;
is your Advansys adapter PCI or ISA?).

I'm not terribly interested in spending much time on this driver,
so the simplest thing to do IMO is to emulate check_region() with
pairs of request_region() and release_region() calls.  Yes, this
is still racy, just like check_region() was.  Is that a problem
in your machine environment?

Below is a patch that uses request_region/release_region pairs
instead of check_region().  Does it work for you?

[1] http://lkml.org/lkml/2003/8/5/304

--
~Randy				For Linux-2.6, see:
http://www.kernel.org/pub/linux/kernel/people/davej/misc/post-halloween-2.5.txt


patch_name:	advansys_regions_260.patch
patch_version:	2003-08-06.10:27:17
author:		Randy.Dunlap <rddunlap@osdl.org>
description:	convert check_region() to request/release
product:	Linux
product_versions: linux-260-test2
diffstat:	=
 drivers/scsi/advansys.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)


diff -Naurp ./drivers/scsi/advansys.c~advans ./drivers/scsi/advansys.c
--- ./drivers/scsi/advansys.c~advans	2003-07-27 09:59:39.000000000 -0700
+++ ./drivers/scsi/advansys.c	2003-08-06 10:24:45.000000000 -0700
@@ -4619,17 +4619,19 @@ advansys_detect(Scsi_Host_Template *tpnt
                         ASC_DBG1(1,
                                 "advansys_detect: probing I/O port 0x%x...\n",
                             iop);
-                        if (check_region(iop, ASC_IOADR_GAP) != 0) {
+                        if (!request_region(iop, ASC_IOADR_GAP, "advansys")) {
                             printk(
 "AdvanSys SCSI: specified I/O Port 0x%X is busy\n", iop);
                             /* Don't try this I/O port twice. */
                             asc_ioport[ioport] = 0;
+			    release_region(iop, ASC_IOADR_GAP);
                             goto ioport_try_again;
                         } else if (AscFindSignature(iop) == ASC_FALSE) {
                             printk(
 "AdvanSys SCSI: specified I/O Port 0x%X has no adapter\n", iop);
                             /* Don't try this I/O port twice. */
                             asc_ioport[ioport] = 0;
+			    release_region(iop, ASC_IOADR_GAP);
                             goto ioport_try_again;
                         } else {
                             /*
@@ -4647,6 +4649,7 @@ advansys_detect(Scsi_Host_Template *tpnt
                                   * 'ioport' past this board.
                                   */
                                  ioport++;
+				 release_region(iop, ASC_IOADR_GAP);
                                  goto ioport_try_again;
                             }
                         }
@@ -10001,16 +10004,18 @@ AscSearchIOPortAddr11(
     }
     for (; i < ASC_IOADR_TABLE_MAX_IX; i++) {
         iop_base = _asc_def_iop_base[i];
-        if (check_region(iop_base, ASC_IOADR_GAP) != 0) {
+        if (!request_region(iop_base, ASC_IOADR_GAP, "advansys")) {
             ASC_DBG1(1,
-               "AscSearchIOPortAddr11: check_region() failed I/O port 0x%x\n",
+               "AscSearchIOPortAddr11: request_region() failed I/O port 0x%x\n",
                      iop_base);
             continue;
         }
         ASC_DBG1(1, "AscSearchIOPortAddr11: probing I/O port 0x%x\n", iop_base);
         if (AscFindSignature(iop_base)) {
+	    release_region(iop_base, ASC_IOADR_GAP);
             return (iop_base);
         }
+	release_region(iop_base, ASC_IOADR_GAP);
     }
     return (0);
 }

From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: compile warning fix for advansys (trivial)
Date: Sun, 21 Dec 2003 22:40:49 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0312212237460.2348-100000@poirot.grange>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:28860 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S264142AbTLUVla (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 21 Dec 2003 16:41:30 -0500
Received: from lyakh (helo=localhost)
	by poirot.grange with local-esmtp (Exim 3.35 #1 (Debian))
	id 1AYBJh-0000cI-00
	for <linux-scsi@vger.kernel.org>; Sun, 21 Dec 2003 22:40:49 +0100
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi

This was earlier sent with a pretty masking subject to LKML, so, in case,
it wasn't noticed by those, who collect stuff for 2.6.1+, here it is
again.

On Fri, 19 Dec 2003, Gene Heskett wrote:

> Hey, how about us advansis users?  There is at least one, me...  And
> thats the only driver in the whole compile that spits out visible
> warnings about check_region() being deprecated.  But its still
> working, so far.  I presume it will until such time as check_region()
> is actually removed from wherever it lives.

Well, wouldn't it suffice just to remove the deprecated checks? The only
(for recent kernels) request_region() does check the return code. So, this
should do:

--- drivers/scsi/advansys.c~	Mon Nov 24 20:43:42 2003
+++ drivers/scsi/advansys.c	Sat Dec 20 15:34:00 2003
@@ -4619,13 +4619,7 @@
                         ASC_DBG1(1,
                                 "advansys_detect: probing I/O port 0x%x...\n",
                             iop);
-                        if (check_region(iop, ASC_IOADR_GAP) != 0) {
-                            printk(
-"AdvanSys SCSI: specified I/O Port 0x%X is busy\n", iop);
-                            /* Don't try this I/O port twice. */
-                            asc_ioport[ioport] = 0;
-                            goto ioport_try_again;
-                        } else if (AscFindSignature(iop) == ASC_FALSE) {
+			if (AscFindSignature(iop) == ASC_FALSE) {
                             printk(
 "AdvanSys SCSI: specified I/O Port 0x%X has no adapter\n", iop);
                             /* Don't try this I/O port twice. */
@@ -10003,12 +9997,6 @@
     }
     for (; i < ASC_IOADR_TABLE_MAX_IX; i++) {
         iop_base = _asc_def_iop_base[i];
-        if (check_region(iop_base, ASC_IOADR_GAP) != 0) {
-            ASC_DBG1(1,
-               "AscSearchIOPortAddr11: check_region() failed I/O port 0x%x\n",
-                     iop_base);
-            continue;
-        }
         ASC_DBG1(1, "AscSearchIOPortAddr11: probing I/O port 0x%x\n", iop_base);
         if (AscFindSignature(iop_base)) {
             return (iop_base);

Regards
Guennadi
---
Guennadi Liakhovetski


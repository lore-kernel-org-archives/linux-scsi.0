From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [Bug]+[Patch] kernel oops after removing lld
Date: Thu, 15 May 2003 15:59:47 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200305151559.48002.heiko.carstens@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from d06lmsgate-4.uk.ibm.com ([195.212.29.4]:44476 "EHLO
	d06lmsgate-4.uk.ibm.com") by vger.kernel.org with ESMTP
	id S264026AbTEONzy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 May 2003 09:55:54 -0400
Received: from d06relay02.portsmouth.uk.ibm.com (d06relay02.uk.ibm.com [9.166.84.148])
	by d06lmsgate-4.uk.ibm.com (8.12.9/8.12.8) with ESMTP id h4FE7vBm232054
	for <linux-scsi@vger.kernel.org>; Thu, 15 May 2003 15:08:33 +0100
Received: from osiris (osiris.boeblingen.de.ibm.com [9.152.242.25])
	by d06relay02.portsmouth.uk.ibm.com (8.12.9/NCO/VER6.5) with ESMTP id h4FE7oNx243670
	for <linux-scsi@vger.kernel.org>; Thu, 15 May 2003 15:07:51 +0100
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi all,

I got a kernel oops when doing the following:

modprobe <lowleveldriver>
rmmod <lowleveldriver>
ls -al /proc/scsi

the lld in question was zfcp, but the bug is generic anyway:
In this specific case the call of tpnt->detect(tpnt) from scsi_register_host()
will return 0, since when the module was loaded there was no hostadapter
available. Considering this the proc entry in /proc/scsi will be created, but
the Scsi_Host_Template won't be added to scsi_hosts, since tpnt->present
is zero.
When one afterwards removes the module, the corresponding procfs entry
won't be removed, because the Scsi_Host_Template is not in scsi_hosts,
which finally will lead to the described kernel oops.
Below is a patch which adds the template in any case to scsi_hosts, even
if tpnt->present is zero... but I'm not sure if this is the right way to fix this.

Any opinions?

Heiko

diff -urN linux-2.4.21-rc2/drivers/scsi/scsi.c linux-2.4.21-rc2-scsi/drivers/scsi/scsi.c
--- linux-2.4.21-rc2/drivers/scsi/scsi.c	Fri Nov 29 00:53:14 2002
+++ linux-2.4.21-rc2-scsi/drivers/scsi/scsi.c	Thu May 15 15:31:36 2003
@@ -1899,6 +1899,9 @@
 	} else
 		tpnt->present = tpnt->detect(tpnt);
 
+	tpnt->next = scsi_hosts;	/* Add to the linked list */
+	scsi_hosts = tpnt;
+
 	if (tpnt->present) {
 		if (pcount == next_scsi_host) {
 			if (tpnt->present > 1) {
@@ -1917,8 +1920,6 @@
 				return 1;
 			}
 		}
-		tpnt->next = scsi_hosts;	/* Add to the linked list */
-		scsi_hosts = tpnt;
 
 		/* Add the new driver to /proc/scsi */
 #ifdef CONFIG_PROC_FS


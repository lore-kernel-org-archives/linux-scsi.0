From: Douglas Gilbert <dougg@torque.net>
Subject: [PATCH] sg direct io/mmap oops
Date: Tue, 30 Aug 2005 21:14:21 +1000
Message-ID: <43143F8D.3080904@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080302010103080906090004"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:31649 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S1751372AbVH3LON (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Aug 2005 07:14:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: ahmed.teirelbar@adic.com, Kai.Makisara@kolumbus.fi, James.Bottomley@SteelEye.com

This is a multi-part message in MIME format.
--------------080302010103080906090004
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Back in the lk 2.4 series it was possible with the sgm_dd
utility to do a zero copy transfer between two disks (or
2 locations on the same disk). That was done by doing mmap-ed
IO on the read and direct IO on the write with the sg driver.

Well that no longer works in the lk 2.6 series because the
sg (and st) driver uses get_user_pages() for direct IO and
that returns -EFAULT when VM_IO is set on any of the user
pages it is trying use. Pages that are mmap-ed have VM_IO
set.

I can live with that: dio and mmap-ed IO work separately
and dio can work on both sides of a transfer.

This was brought to my attention by Ahmed Teirelbar
<ahmed.teirelbar@adic.com> with lk 2.6.5 . Worse, when
tested in lk 2.6.12 and lk 2.6.13, attempting dio/mmap
caused the sg driver to oops (due to empty entries in
a scatter gather list). Ahmed proposed the following
patch which both of us have tested.

I have alerted Kai M. as the same fix is needed in
the st driver IMO.


Changelog:
   - check error return (a negative integer) properly after
     the get_user_pages() call that sets up direct IO

Signed-off-by: Douglas Gilbert <dougg@torque.net>

Doug Gilbert




--------------080302010103080906090004
Content-Type: text/x-patch;
 name="sg_2613mm.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sg_2613mm.diff"

--- linux/drivers/scsi/sg.c	2005-08-29 18:28:23.000000000 +1000
+++ linux/drivers/scsi/sg.c2613mm	2005-08-30 15:09:04.000000000 +1000
@@ -61,7 +61,7 @@
 
 #ifdef CONFIG_SCSI_PROC_FS
 #include <linux/proc_fs.h>
-static char *sg_version_date = "20050328";
+static char *sg_version_date = "20050830";
 
 static int sg_proc_init(void);
 static void sg_proc_cleanup(void);
@@ -1831,7 +1831,8 @@
 	up_read(&current->mm->mmap_sem);
 
 	/* Errors and no page mapped should return here */
-	if (res < nr_pages)
+	/* Beware of signed to unsigned integer promotions!! */
+	if ((res < 0) || (res < nr_pages))
 		goto out_unmap;
 
         for (i=0; i < nr_pages; i++) {


--------------080302010103080906090004--

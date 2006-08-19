From: Douglas Gilbert <dougg@torque.net>
Subject: Re: Bugs on Linux 2.6.18-rc2 sg code?
Date: Sat, 19 Aug 2006 00:11:34 -0400
Message-ID: <44E68F76.4010702@torque.net>
References: <8202f4270608101843r7df002d2l40e03eca3271b050@mail.gmail.com> <44E6388D.1000206@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070405090709020905020900"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:40330 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1030196AbWHSELm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 19 Aug 2006 00:11:42 -0400
In-Reply-To: <44E6388D.1000206@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Fajun Chen <fajunchen@gmail.com>
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org

This is a multi-part message in MIME format.
--------------070405090709020905020900
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Douglas Gilbert wrote:
> Fajun Chen wrote:
>> Hi Folks,
>>
>> I use ATA pass through via sg ioctl interface for data read/write.
>> Linux 2.6.18-rc2 patched with Jeff Garzik's libata git patch was
>> running on ARM IOP80321 board. The HBA Sil3124 was used.
>>
>> Two problems were observed:
>> 1. sg mmap bug?
>>    My test program could not write data correctly to the mmapped
>> buffer in the user space.      The program did a read immediately
>> after a write and the data mismatches.  Swapped the sg_vma_nopage()
>> function with the one in 2.6.15.4 release fixed the problem. So this
>> appears to be a wrong change to the sg mmap code in 2.6.18-rc2
>> release.
> 
> Thanks for the report. I can confirm that mmap-ed IO
> in the sg driver is broken. Simply reading 16 blocks
> from some arbitrary offset with sg_dd and sgm_dd
> and comparing the fetched data shows mismatches starting
> above the first page (i.e. above byte offset 4096 on
> i386).
> 
> Your point about the change to sg_vma_nopage() between
> lk 2.6.15 and lk 2.6.16 also seems to be correct.
> The most indented part of that function has been
> changed from incrementing the change count on the
> reported page (as indicated by 'offset') in a
> compound page allocation to ignoring the 'offset'
> and incrementing the page count on the first page
> in a compound page allocation.

Fajun,
Could you please try the patch below and report if it fixes
your sg mmap problem. The patch is against lk 2.6.18-rc4
and I assume it will apply against "rc2" as well.
The patch re-instates the former logic and fixes the
problem in my tests.

Doug Gilbert

--------------070405090709020905020900
Content-Type: text/x-patch;
 name="sg2618rc4nopage.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sg2618rc4nopage.diff"

--- linux/drivers/scsi/sg.c	2006-07-16 08:19:19.000000000 -0400
+++ linux/drivers/scsi/sg.c2618rc4nopage	2006-08-18 23:40:15.000000000 -0400
@@ -18,8 +18,8 @@
  *
  */
 
-static int sg_version_num = 30533;	/* 2 digits for each component */
-#define SG_VERSION_STR "3.5.33"
+static int sg_version_num = 30534;	/* 2 digits for each component */
+#define SG_VERSION_STR "3.5.34"
 
 /*
  *  D. P. Gilbert (dgilbert@interlog.com, dougg@triode.net.au), notes:
@@ -60,7 +60,7 @@
 
 #ifdef CONFIG_SCSI_PROC_FS
 #include <linux/proc_fs.h>
-static char *sg_version_date = "20050908";
+static char *sg_version_date = "20060818";
 
 static int sg_proc_init(void);
 static void sg_proc_cleanup(void);
@@ -1164,7 +1164,7 @@
 		len = vma->vm_end - sa;
 		len = (len < sg->length) ? len : sg->length;
 		if (offset < len) {
-			page = sg->page;
+			page = virt_to_page(page_address(sg->page) + offset);
 			get_page(page);	/* increment page count */
 			break;
 		}

--------------070405090709020905020900--

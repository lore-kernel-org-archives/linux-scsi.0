From: "Greg M. Kurtzer" <gmkurtzer@lbl.gov>
Subject: linux-2.4 sd.c sd_init_command patch
Date: Thu, 7 Oct 2004 22:10:48 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041008051048.GC21119@gmk.lbl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gmk.lbl.gov ([128.3.10.31]:51689 "EHLO gmk.lbl.gov")
	by vger.kernel.org with ESMTP id S267689AbUJHFKs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Oct 2004 01:10:48 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I came across an issue on an Opteron with the 2.4 branch when trying to use a
file system larger then 1TB with a 3-Ware card. They pointed me to:

   http://www.3ware.com/KB/article.aspx?id=10753

which includes the following patch:

diff -Naur linux-2.4.23-rc2/drivers/scsi/sd.c
linux-2.4.23-rc3/drivers/scsi/sd.c--- linux-2.4.23-rc2/drivers/scsi/sd.c  Mon
Aug 25 04:44:42 2003
+++ linux-2.4.23-rc3/drivers/scsi/sd.c  Wed Nov 19 15:15:38 2003
@@ -294,7 +294,8 @@

 static int sd_init_command(Scsi_Cmnd * SCpnt)
 {
-       int dev, block, this_count;
+       int dev, this_count;
+       unsigned long block;
        struct hd_struct *ppnt;
        Scsi_Disk *dpnt;
 #if CONFIG_SCSI_LOGGING


I am curious if there is a reason why this has not been introduced into the
main 2.4 tree. Is this not a widely known issue, and/or does this (seemingly
inert) patch cause other problems? I can't seem to find much about it on the
mailing list except that Adam Radford posted it late in 2003.

Any comments would be greatly appreciated!

Thanks!

note: Please include my direct email in any list replies.
-- 
Greg Kurtzer
Berkeley Lab, Linux guy

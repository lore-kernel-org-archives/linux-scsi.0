From: Hiroaki Fuse <fuse@sm.sony.co.jp>
Subject: [patch] scsicam: scsi_partsize work correctly on a big-endian
 machine
Date: Wed, 28 Jul 2004 13:52:07 +0900 (JST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040728.135207.74732275.fuse@sm.sony.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
 boundary="--Next_Part(Wed_Jul_28_13:52:07_2004_253)--"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from NS8.Sony.CO.JP ([137.153.0.33]:47332 "EHLO ns8.sony.co.jp")
	by vger.kernel.org with ESMTP id S266780AbUG1E4M (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Jul 2004 00:56:12 -0400
Received: from mail20.sony.co.jp (localhost [127.0.0.1])
	by mail20.sony.co.jp (R8/Sony) with ESMTP id i6S4uAv7007185
	for <linux-scsi@vger.kernel.org>; Wed, 28 Jul 2004 13:56:10 +0900 (JST)
Received: from smail1.sm.sony.co.jp (smail1.sm.sony.co.jp [43.11.253.1])
	by mail20.sony.co.jp (R8/Sony) with ESMTP id i6S4uACP007178
	for <linux-scsi@vger.kernel.org>; Wed, 28 Jul 2004 13:56:10 +0900 (JST)
Received: from imail.sm.sony.co.jp (imail.sm.sony.co.jp [43.2.217.16]) by smail1.sm.sony.co.jp (8.11.6p2/8.11.6) with ESMTP id i6S4u9D10833 for <linux-scsi@vger.kernel.org>; Wed, 28 Jul 2004 13:56:09 +0900 (JST)
Received: from localhost (IDENT:fuse@valentina.sm.sony.co.jp [43.2.226.21]) by imail.sm.sony.co.jp (8.11.6p2/3.7W) with ESMTP id i6S4u9I25179 for <linux-scsi@vger.kernel.org>; Wed, 28 Jul 2004 13:56:09 +0900 (JST)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

----Next_Part(Wed_Jul_28_13:52:07_2004_253)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


Hello.

The attached patch fix the problem of scsi_partsize function.
Now, scsi_partsize works correctly on a big-endian machine.

Thanks.

Hiroaki Fuse


----Next_Part(Wed_Jul_28_13:52:07_2004_253)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="scsicam.c-diff"

--- linux-2.4.26/drivers/scsi/scsicam.c	Sat Dec 22 02:41:55 2001
+++ linux-2.4.26-new/drivers/scsi/scsicam.c	Wed Jul 28 13:27:08 2004
@@ -97,7 +97,7 @@
 	unsigned int logical_end, physical_end, ext_physical_end;
 
 
-	if (*(unsigned short *) (bh->b_data + 510) == 0xAA55) {
+	if (*(unsigned short *) (bh->b_data + 510) == __cpu_to_le16(0xAA55)) {
 		for (largest_cyl = -1, p = (struct partition *)
 		     (0x1BE + bh->b_data), i = 0; i < 4; ++i, ++p) {
 			if (!p->sys_ind)
@@ -130,8 +130,8 @@
 		    end_head * end_sector + end_sector;
 
 		/* This is the actual _sector_ number at the end */
-		logical_end = get_unaligned(&largest->start_sect)
-		    + get_unaligned(&largest->nr_sects);
+		logical_end = __le32_to_cpu(get_unaligned(&largest->start_sect))
+		    + __le32_to_cpu(get_unaligned(&largest->nr_sects));
 
 		/* This is for >1023 cylinders */
 		ext_cyl = (logical_end - (end_head * end_sector + end_sector))

----Next_Part(Wed_Jul_28_13:52:07_2004_253)----

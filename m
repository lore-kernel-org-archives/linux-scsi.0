From: Douglas Gilbert <dougg@torque.net>
Subject: [PATCH] sg negative size: 2.4.23-pre9
Date: Sat, 08 Nov 2003 20:44:15 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3FACC8FF.2000705@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020009000001010001010201"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:59662 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S261678AbTKIAIg
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 8 Nov 2003 19:08:36 -0500
List-Id: linux-scsi@vger.kernel.org
To: marcelo.tosatti@cyclades.com
Cc: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------020009000001010001010201
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Marcelo,
Thanks to work by Pat LaVarre <p.lavarre@ieee.org> one
of sg's ioctls [SG_SET_RESERVED_SIZE] was found to allow
negative sizes. This causes the kernel pain. This
patch fixes that (, a similar patch was recently put
into lk 2.6.0-test8).

Doug Gilbert

--------------020009000001010001010201
Content-Type: text/plain;
 name="sg_2423pre9.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sg_2423pre9.diff"

--- linux/drivers/scsi/sg.c	2003-06-14 13:49:51.000000000 +1000
+++ linux/drivers/scsi/sg.c2423pre9dpg	2003-11-08 19:11:00.000000000 +1000
@@ -871,6 +871,8 @@
     case SG_SET_RESERVED_SIZE:
         result = get_user(val, (int *)arg);
         if (result) return result;
+        if (val < 0)
+            return -EINVAL;
         if (val != sfp->reserve.bufflen) {
             if (sg_res_in_use(sfp) || sfp->mmap_called)
                 return -EBUSY;

--------------020009000001010001010201--



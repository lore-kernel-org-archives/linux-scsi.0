From: Nate Dailey <nhdailey@verizon.net>
Subject: [PATCH] drivers/scsi/st.c: decrement in_use under the lock in st_open
Date: Thu, 21 Apr 2005 10:08:31 -0500 (CDT)
Message-ID: <31176667.1114096111445.JavaMail.root@vms064.mailsrvcs.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vms046pub.verizon.net ([206.46.252.46]:11396 "EHLO
	vms046pub.verizon.net") by vger.kernel.org with ESMTP
	id S261422AbVDUPIb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Apr 2005 11:08:31 -0400
Received: from vms064.mailsrvcs.net ([192.168.1.1])
 by vms046.mailsrvcs.net (Sun Java System Messaging Server 6.2 HotFix 0.04
 (built Dec 24 2004)) with ESMTPA id <0IFA00FQ1Y271284@vms046.mailsrvcs.net> for
 linux-scsi@vger.kernel.org; Thu, 21 Apr 2005 10:08:31 -0500 (CDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai.Makisara@kolumbus.fi
Cc: linux-scsi@vger.kernel.org

Hi, this patch changes the err_out case in st_open to decrement STp->in_use under the st_dev_arr_lock.

I'm just basing this on looking at the code (I didn't run into an actual problem here), but it seems like the right thing to do; st_open and release hold the lock when adjusting in_use in other places.

This is against kernel 2.6.12-rc2.

Nate Dailey
Stratus Technologies


Signed-off-by: Nate Dailey <nate.dailey@stratus.com>


--- linux-2.6.12-rc2/drivers/scsi/st.c.orig	2005-04-20 11:28:39.000000000 -0400
+++ linux-2.6.12-rc2/drivers/scsi/st.c	2005-04-20 11:30:08.000000000 -0400
@@ -1115,7 +1115,9 @@ static int st_open(struct inode *inode, 
 
  err_out:
 	normalize_buffer(STp->buffer);
+	write_lock(&st_dev_arr_lock);
 	STp->in_use = 0;
+	write_unlock(&st_dev_arr_lock);
 	scsi_device_put(STp->device);
 	return retval;
 


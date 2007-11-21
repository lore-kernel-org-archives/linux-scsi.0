From: Ken Witherow <ken@krwtech.com>
Subject: [patch] advansys: fix timestamp for 64 bit
Date: Wed, 21 Nov 2007 18:15:53 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0711211743050.27096@death.krwtech.com>
Reply-To: Ken Witherow <ken@krwtech.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cpe-72-225-45-7.rochester.res.rr.com ([72.225.45.7]:51090 "EHLO
	death.krwtech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836AbXKUXid (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Nov 2007 18:38:33 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

Timestamp assertion compares int and unsigned long. Fails on 64 bit 
machines where unsigned long is 8 bytes instead of 4. Promote int (from 
scsi_cmnd.this_residual) to unsigned long (jiffies) so it is a proper 
comparison on both 32 bit and 64 bit architectures.

Tested on AMD64

Signed-off-by: Ken Witherow <ken@krwtech.com>


--- linux-2.6.23-gentoo-r2/drivers/scsi/advansys.c.orig	2007-11-21 02:33:00.000000000 -0500
+++ linux-2.6.23-gentoo-r1/drivers/scsi/advansys.c	2007-11-21 17:37:56.000000000 -0500
@@ -3497,7 +3497,7 @@ typedef struct scsi_cmnd REQ, *REQP;
       * If the request time stamp is less than the system time stamp, then \
       * maybe the system time stamp wrapped. Set the request time to zero.\
       */ \
-    if (REQPTIME(reqp) <= REQTIMESTAMP()) { \
+    if ((unsigned long) REQPTIME(reqp) <= REQTIMESTAMP()) { \
          REQPTIME(reqp) = REQTIMESTAMP() - REQPTIME(reqp); \
      } else { \
          /* Indicate an error occurred with the assertion. */ \

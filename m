From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [usb-storage] unsolicited sense in 2.6.0-test5 usb-storage.ko
Date: 11 Sep 2003 18:21:19 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1063326079.3616.74.camel@patehci2>
References: <Pine.LNX.4.44L0.0309101700230.1579-100000@ida.rowland.org>
	 <1063229049.6245.12.camel@patehci2>
	 <20030910145252.F13649@one-eyed-alien.net>
	 <1063231717.6245.22.camel@patehci2>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:59903 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S261662AbTILAUT
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Sep 2003 20:20:19 -0400
In-Reply-To: <1063231717.6245.22.camel@patehci2>
List-Id: linux-scsi@vger.kernel.org
To: mdharm-scsi@one-eyed-alien.net
Cc: stern@rowland.harvard.edu, usb-storage@one-eyed-alien.net, linux-scsi@vger.kernel.org

> > > ... I should prepare and forward
> > > a patch to correct sgp_dd? ...
> > > ...
> >
> > Yes.
> 
> Clear now, thanks, will do.

Below appears a patch to make sg3_utils sgp_dd.c as polite as sg_dd.c or
sgm_dd.c.  I know now, this patch sets Hi = Di in sgp_dd.c precisely as
sg_dd.c and sgp_dd.c do.

This fixes my actual problem, but leaves me mystified over why we
include in drivers/usb/storage/ any code path that assaults a
bInterfaceProtocol = x50 BBB device with unsolicited sense. 

Pat LaVarre

diff -ur sg3_utils-1.05/sgp_dd.c sg3_utils/sgp_dd.c
--- sg3_utils-1.05/sgp_dd.c	2003-05-29 03:00:48.000000000 -0600
+++ sg3_utils/sgp_dd.c	2003-09-11 18:05:54.013907720 -0600
@@ -59,6 +59,7 @@
 /* #define SG_DEBUG */
 
 #define SENSE_BUFF_LEN 32       /* Arbitrary, could be larger */
+#define READ_CAP_REPLY_LEN 8
 #define DEF_TIMEOUT 60000       /* 60,000 millisecs == 60 seconds */
 
 #define SGP_READ10 0x28
@@ -234,7 +235,7 @@
 {
     int res;
     unsigned char rcCmdBlk [10] = {READ_CAPACITY, 0, 0, 0, 0, 0, 0, 0,
0, 0};
-    unsigned char rcBuff[64];
+    unsigned char rcBuff[READ_CAP_REPLY_LEN];
     unsigned char sense_b[64];
     struct sg_io_hdr io_hdr;
 



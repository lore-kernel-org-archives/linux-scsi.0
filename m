From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH] aacraid: New products patch
Date: Mon, 20 Jun 2005 14:38:44 -0400
Message-ID: <60807403EABEB443939A5A7AA8A7458B01520E90@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:29397 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261440AbVFTSja convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Jun 2005 14:39:30 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>, James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

For the fragment:

+
+	/* 
+	 * GetBusInfo 
+	 */
+
+	fib_init(fibptr);
+
+	bus_info = (struct aac_bus_info_response *) fib_data(fibptr);
+
+	memset(info,0,sizeof(*bus_info));
+
+	command = (struct aac_bus_info *)bus_info;

I hate to do this to a patch that has already undergone some review,
especially since this as merely cosmetic, but I noticed that the memset
was on the 'info' pointer rather than the 'bus_info' pointer. One should
note that the value of info is the same as bus_info, they are simply two
different types originating from a void * source; there is no functional
difference, the resultant code will work fine in either case.

Supplementary cleanup patch (if there is such a thing):

diff -u a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -671,7 +671,7 @@
 
 	bus_info = (struct aac_bus_info_response *) fib_data(fibptr);
 
-	memset(info,0,sizeof(*bus_info));
+	memset(bus_info,0,sizeof(*bus_info));
 
 	command = (struct aac_bus_info *)bus_info;
 

-- Mark Salyzyn

From: Naveen Burmi <naveenb@cisco.com>
Subject: New SCSI host_byte status code.
Date: Tue, 9 Mar 2004 18:36:05 +0530
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200403091836.05057.naveenb@cisco.com>
Reply-To: naveenb@cisco.com
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_9EcTAnCe9H5Q7+l"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ind-iport-1-sec.cisco.com ([64.104.129.9]:45668 "EHLO
	ind-iport-1.cisco.com") by vger.kernel.org with ESMTP
	id S261905AbUCINGV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Mar 2004 08:06:21 -0500
Received: from naveenb-lnx.cisco.com (naveenb-lnx.cisco.com [10.77.7.56])
	by india-core-1.cisco.com (8.12.10/8.12.6) with ESMTP id i29D64Yx022960
	for <linux-scsi@vger.kernel.org>; Tue, 9 Mar 2004 05:06:05 -0800 (PST)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: davmyers@cisco.com, Clay Haapala <chaapala@cisco.com>


--Boundary-00=_9EcTAnCe9H5Q7+l
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


At present there is no way to retry, if allowed, a scsi command without 
decrementing the scsi command's retry count.

Please find a patch attached, which is submitted, for adding a new host_byte 
status code called "DID_IMM_RETRY". This enables the Low Level SCSI drivers 
to initiate retry of a scsi command without decrementing the scsi commad's 
retry count.

Thanks,
Naveen.

--Boundary-00=_9EcTAnCe9H5Q7+l
Content-Type: text/x-diff;
  charset="us-ascii";
  name="DID_IMM_RETRY.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="DID_IMM_RETRY.patch"

diff -Nuar linux-2.6.3/drivers/scsi/constants.c linux-2.6.3.new/drivers/scsi/constants.c
--- linux-2.6.3/drivers/scsi/constants.c	2004-02-25 17:11:53.212334320 +0530
+++ linux-2.6.3.new/drivers/scsi/constants.c	2004-02-25 17:10:04.187908552 +0530
@@ -1135,7 +1135,7 @@
 static const char * hostbyte_table[]={
 "DID_OK", "DID_NO_CONNECT", "DID_BUS_BUSY", "DID_TIME_OUT", "DID_BAD_TARGET", 
 "DID_ABORT", "DID_PARITY", "DID_ERROR", "DID_RESET", "DID_BAD_INTR",
-"DID_PASSTHROUGH", "DID_SOFT_ERROR", NULL};
+"DID_PASSTHROUGH", "DID_SOFT_ERROR", "DID_IMM_RETRY", NULL};
 
 void print_hostbyte(int scsiresult)
 {   static int maxcode=0;
diff -Nuar linux-2.6.3/drivers/scsi/scsi_error.c linux-2.6.3.new/drivers/scsi/scsi_error.c
--- linux-2.6.3/drivers/scsi/scsi_error.c	2004-02-25 17:11:48.453057840 +0530
+++ linux-2.6.3.new/drivers/scsi/scsi_error.c	2004-02-25 17:08:53.324681400 +0530
@@ -1181,6 +1181,8 @@
 		 */
 	case DID_SOFT_ERROR:
 		goto maybe_retry;
+	case DID_IMM_RETRY:
+		return NEEDS_RETRY;
 
 	case DID_ERROR:
 		if (msg_byte(scmd->result) == COMMAND_COMPLETE &&
diff -Nuar linux-2.6.3/include/scsi/scsi.h linux-2.6.3.new/include/scsi/scsi.h
--- linux-2.6.3/include/scsi/scsi.h	2004-02-25 17:12:36.435763360 +0530
+++ linux-2.6.3.new/include/scsi/scsi.h	2004-02-25 17:07:45.909930000 +0530
@@ -266,6 +266,7 @@
 #define DID_BAD_INTR    0x09	/* Got an interrupt we weren't expecting.  */
 #define DID_PASSTHROUGH 0x0a	/* Force command past mid-layer            */
 #define DID_SOFT_ERROR  0x0b	/* The low level driver just wish a retry  */
+#define DID_IMM_RETRY   0x0c	/* Retry without decrementing retry count  */
 #define DRIVER_OK       0x00	/* Driver status                           */
 
 /*

--Boundary-00=_9EcTAnCe9H5Q7+l--

From: Douglas Gilbert <dougg@torque.net>
Subject: [PATCH] scsi_level constants in scsi.h
Date: Tue, 24 Aug 2004 21:39:36 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <412B28F8.8000107@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070901030501080807090005"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from borg.st.net.au ([65.23.158.22]:21741 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S267532AbUHXLl7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Aug 2004 07:41:59 -0400
Received: from [192.168.48.80] (dsl-224.129.240.220.lns02-wick-bne.dsl.comindico.com.au [220.240.129.224])
	by borg.st.net.au (Postfix) with ESMTP id 807123946EA
	for <linux-scsi@vger.kernel.org>; Tue, 24 Aug 2004 21:41:32 +1000 (EST)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------070901030501080807090005
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

The scsi_level value in struct scsi_device is a bit
mysterious. Hopefully this patch makes it a bit clearer
since it is visible via sysfs.

Changes:
   - add scsi_level constants for SPC-2 and SPC-3
   - comment on relationship between scsi_level and INQUIRY response

Doug Gilbert

--------------070901030501080807090005
Content-Type: text/x-patch;
 name="scsi_h_2681.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scsi_h_2681.diff"

--- linux/include/scsi/scsi.h	2004-08-14 21:12:52.000000000 +1000
+++ linux/include/scsi/scsi.h2681sl	2004-08-24 21:34:25.866435024 +1000
@@ -353,14 +353,19 @@
 		     ((lun) & 0x07))
 
 /*
- *  SCSI command sets
+ *  struct scsi_device::scsi_level values. For SCSI devices other than those
+ *  prior to SCSI-2 (i.e. over 12 years old) this value is (resp[2] + 1)
+ *  where "resp" is a byte array of the response to an INQUIRY. The scsi_level
+ *  variable is visible to the user via sysfs.
  */
 
 #define SCSI_UNKNOWN    0
 #define SCSI_1          1
 #define SCSI_1_CCS      2
 #define SCSI_2          3
-#define SCSI_3          4
+#define SCSI_3          4        /* SPC */
+#define SCSI_SPC_2      5
+#define SCSI_SPC_3      6
 
 /*
  * INQ PERIPHERAL QUALIFIERS

--------------070901030501080807090005--


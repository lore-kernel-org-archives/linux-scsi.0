From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: [PATCH 12/12] scsi: megaraid_sas - Version and documentation update
Date: Thu, 5 Aug 2010 14:38:29 -0600
Message-ID: <4B6A08C587958942AA3002690DD4F8C3DBD67FBC@cosmail02.lsi.com>
References: <4B6A08C587958942AA3002690DD4F8C35C5123FA@cosmail02.lsi.com>
 <4B6A08C587958942AA3002690DD4F8C35C6861A5@cosmail02.lsi.com>
 <3A916D859199814BBB666188F96EB165013979165E@cosmail02.lsi.com>
 <4B6A08C587958942AA3002690DD4F8C3CDB80B82@cosmail02.lsi.com>
 <4B6A08C587958942AA3002690DD4F8C3CDB80C39@cosmail02.lsi.com>
 <4B6A08C587958942AA3002690DD4F8C3D0804562@cosmail02.lsi.com>
 <4B6A08C587958942AA3002690DD4F8C3D09274B7@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:33798 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756497Ab0HEUii convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Aug 2010 16:38:38 -0400
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C3D09274B7@cosmail02.lsi.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>, "'James.Bottomley@HansenPartnership.com'" <James.Bottomley@HansenPartnership.com>, "'James.Bottomley@suse.de'" <James.Bottomley@suse.de>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "'akpm@osdl.org'" <akpm@osdl.org>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "Daftardar, Jayant" <Jayant.Daftardar@lsi.com>

RESUBMIT requested by James Bottomley:

Update the version and documentation.

Signed-off-by Bo Yang<bo.yang@lsi.com>

---
Documentation/scsi/ChangeLog.megaraid_sas |   46 ++++++++++++++++++++++++++++++
 drivers/scsi/megaraid/megaraid_sas.h      |    6 +--
 2 files changed, 49 insertions(+), 3 deletions(-)

diff -rupN old/Documentation/scsi/ChangeLog.megaraid_sas new/Documentation/scsi/ChangeLog.megaraid_sas
--- old/Documentation/scsi/ChangeLog.megaraid_sas	2010-08-04 07:48:32.000000000 -0400
+++ new/Documentation/scsi/ChangeLog.megaraid_sas	2010-08-04 07:58:50.000000000 -0400
@@ -1,3 +1,49 @@
+1 Release Date    : Thur.  May 03, 2010 09:12:45 PST 2009 -
+			(emaild-id:megaraidlinux@lsi.com)
+			Bo Yang
+
+2 Current Version : 00.00.04.31-rc1
+3 Older Version   : 00.00.04.17.1-rc1
+
+1.	Add the Online Controller Reset (OCR) to the Driver.
+	OCR is the new feature for megaraid_sas driver which
+	will allow the fw to do the chip reset which will not
+	affact the OS behavious.
+
+	To add the OCR support, driver need to do: 
+		a). reset the controller chips -- Xscale and Gen2 which
+		will change the function calls and add the reset function
+		related to this two chips.
+		
+		b). during the reset, driver will store the pending cmds
+		which not returned by FW to driver's pending queue.  Driver
+		will re-issue those pending cmds again to FW after the OCR
+		finished.
+		
+		c). In driver's timeout routine, driver will report to
+		OS as reset. Also driver's queue routine will block the
+		cmds until the OCR finished.
+		
+		d). in Driver's ISR routine, if driver get the FW state as
+		state change, FW in Failure status and FW support online controller
+		reset (OCR), driver will start to do the controller reset.
+		
+		e). In driver's IOCTL routine, the application cmds will wait for the
+		OCR to finish, then issue the cmds to FW.
+		 
+		f). Before driver kill adapter, driver will do last chance of
+		OCR to see if driver can bring back the FW.      
+
+2.	Add the CTIO support to the driver.
+3.	Add the support update flag to the driver to tell LSI megaraid_sas
+	application which driver will support the device update.  So application
+	will not need to do the device update after application add/del the device
+	from the system.
+
+4.	Add the input parameter max_sectors to 1MB support to our GEN2 controller.
+	customer can use the input paramenter max_sectors to add 1MB support to GEN2
+	controller.
+
 1 Release Date    : Thur.  Oct 29, 2009 09:12:45 PST 2009 -
 			(emaild-id:megaraidlinux@lsi.com)
 			Bo Yang
diff -rupN old/drivers/scsi/megaraid/megaraid_sas.h new/drivers/scsi/megaraid/megaraid_sas.h
--- old/drivers/scsi/megaraid/megaraid_sas.h	2010-08-04 07:52:09.000000000 -0400
+++ new/drivers/scsi/megaraid/megaraid_sas.h	2010-08-04 07:48:32.000000000 -0400
@@ -18,9 +18,9 @@
 /*
  * MegaRAID SAS Driver meta data
  */
-#define MEGASAS_VERSION			"00.00.04.17.1-rc1"
-#define MEGASAS_RELDATE			"Oct. 29, 2009"
-#define MEGASAS_EXT_VERSION		"Thu. Oct. 29, 11:41:51 PST 2009"
+#define MEGASAS_VERSION			"00.00.04.31-rc1"
+#define MEGASAS_RELDATE			"May 3, 2010"
+#define MEGASAS_EXT_VERSION		"Mon. May 3, 11:41:51 PST 2010"
 
 /*
  * Device IDs

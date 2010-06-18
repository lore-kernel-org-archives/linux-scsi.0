From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: [PATCH 12/12] scsi: megaraid_sas - Version and documentation update
Date: Fri, 18 Jun 2010 15:13:06 -0600
Message-ID: <4B6A08C587958942AA3002690DD4F8C3D09274B7@cosmail02.lsi.com>
References: <4B6A08C587958942AA3002690DD4F8C35C5123FA@cosmail02.lsi.com>
 <4B6A08C587958942AA3002690DD4F8C35C6861A5@cosmail02.lsi.com>
 <3A916D859199814BBB666188F96EB165013979165E@cosmail02.lsi.com>
 <4B6A08C587958942AA3002690DD4F8C3CDB80B82@cosmail02.lsi.com>
 <4B6A08C587958942AA3002690DD4F8C3CDB80C39@cosmail02.lsi.com>
 <4B6A08C587958942AA3002690DD4F8C3D0804562@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:34725 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752427Ab0FRVNP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Jun 2010 17:13:15 -0400
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C3D0804562@cosmail02.lsi.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>, "'James.Bottomley@HansenPartnership.com'" <James.Bottomley@HansenPartnership.com>, "'James.Bottomley@suse.de'" <James.Bottomley@suse.de>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "'akpm@osdl.org'" <akpm@osdl.org>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "Daftardar, Jayant" <Jayant.Daftardar@lsi.com>

RESUBMIT:

Update the version and documentation.

Signed-off-by Bo Yang<bo.yang@lsi.com>

---
Documentation/scsi/ChangeLog.megaraid_sas |   42 ++++++++++++++++++++++++++++++
 drivers/scsi/megaraid/megaraid_sas.h      |    6 ++--
 2 files changed, 45 insertions(+), 3 deletions(-)

diff -rupN old/Documentation/scsi/ChangeLog.megaraid_sas new/Documentation/scsi/ChangeLog.megaraid_sas
--- old/Documentation/scsi/ChangeLog.megaraid_sas	2010-06-17 07:51:22.000000000 -0400
+++ new/Documentation/scsi/ChangeLog.megaraid_sas	2010-06-17 07:51:22.000000000 -0400
@@ -1,3 +1,45 @@
+1 Release Date    : Thur.  May 03, 2010 09:12:45 PST 2009 -
+			(emaild-id:megaraidlinux@lsi.com)
+			Bo Yang
+
+2 Current Version : 00.00.04.30-rc1
+3 Older Version   : 00.00.04.17.1-rc1
+
+1.	Add the Online Controller Reset (OCR) to the Driver.
+	OCR is the new feature for megaraid_sas driver which
+	will allow the fw to do the chip reset which will not
+	affact the OS hbhavious.
+
+	To add the OCR support, driver need to do: 
+		a). reset the controller chip -- Xscale and Gen2.
+		
+		b). during the reset, driver will store the pending
+		cmds to pending queue.
+		
+		c). Also in driver's timeout routine, driver will
+		report to OS as reset.
+		
+		d). in Driver's ISR routine, if driver get the FW
+		state as state change and FW in Failure status,
+		driver will start to do the controller reset.
+		
+		e). If driver goes to timeout, but driver is in
+		operational status, driver will check if fw in failed
+		status, if yes, driver will do OCR to FW upto three times.
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
--- old/drivers/scsi/megaraid/megaraid_sas.h	2010-06-17 09:10:24.000000000 -0400
+++ new/drivers/scsi/megaraid/megaraid_sas.h	2010-06-17 09:06:18.000000000 -0400
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

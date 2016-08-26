From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH 16/17] smartpqi: add smartpqi.txt
Date: Fri, 26 Aug 2016 11:45:43 -0500
Message-ID: <147222994345.31214.15253908733296553779.stgit@brunhilda>
References: <147222977996.31214.8588187948847476082.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0067.outbound.protection.outlook.com ([104.47.38.67]:4800
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754823AbcHZRCM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 26 Aug 2016 13:02:12 -0400
In-Reply-To: <147222977996.31214.8588187948847476082.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, Viswas.G@microsemi.com, Mahesh.Rajashekhara@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Kevin.Barnett@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@microsemi.com>

Reviewed-by: Kevin Barnett <kevin.barnett@microsemi.com>
Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 Documentation/scsi/smartpqi.txt |   80 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 80 insertions(+)
 create mode 100644 Documentation/scsi/smartpqi.txt

diff --git a/Documentation/scsi/smartpqi.txt b/Documentation/scsi/smartpqi.txt
new file mode 100644
index 0000000..ab377d9
--- /dev/null
+++ b/Documentation/scsi/smartpqi.txt
@@ -0,0 +1,80 @@
+
+SMARTPQI - Microsemi Smart PQI Driver
+-----------------------------------------
+
+This file describes the smartpqi SCSI driver for Microsemi
+(http://www.microsemi.com) PQI controllers. The smartpqi driver
+is the next generation SCSI driver for Microsemi Corp. The smartpqi
+driver is the first SCSI driver to implement the PQI queuing model.
+
+The smartpqi driver will replace the aacraid driver for Adaptec Series 9
+controllers. Customers running an older kernel (Pre-4.9) using an Adaptec
+Series 9 controller will have to configure the smartpqi driver or their
+volumes will not be added to the OS.
+
+For Microsemi smartpqi controller support, enable the smartpqi driver
+when configuring the kernel.
+
+For more information on the PQI Queuing Interface, please see:
+http://www.t10.org/drafts.htm
+http://www.t10.org/members/w_pqi2.htm
+
+Supported devices:
+------------------
+<Controller names to be added as they become publically available.>
+
+smartpqi specific entries in /sys
+-----------------------------
+
+  smartpqi host attributes:
+  -------------------------
+  /sys/class/scsi_host/host*/rescan
+  /sys/class/scsi_host/host*/version
+
+  The host rescan attribute is a write only attribute. Writing to this
+  attribute will trigger the driver to scan for new, changed, or removed
+  devices and notify the SCSI mid-layer of any changes detected.
+
+  The version attribute is read-only and will return the driver version
+  and the controller firmware version.
+  For example:
+              driver: 0.9.13-370
+              firmware: 0.01-522
+
+  smartpqi sas device attributes
+  ------------------------------
+  HBA devices are added to the SAS transport layer. These attributes are
+  automatically added by the SAS transport layer.
+
+  /sys/class/sas_device/end_device-X:X/sas_address
+  /sys/class/sas_device/end_device-X:X/enclosure_identifier
+  /sys/class/sas_device/end_device-X:X/scsi_target_id
+
+smartpqi specific ioctls:
+-------------------------
+
+  For compatibility with applications written for the cciss protocol.
+
+  CCISS_DEREGDISK
+  CCISS_REGNEWDISK
+  CCISS_REGNEWD
+
+  The above three ioctls all do exactly the same thing, which is to cause the driver
+  to rescan for new devices.  This does exactly the same thing as writing to the
+  smartpqi specific host "rescan" attribute.
+
+  CCISS_GETPCIINFO
+
+	Returns PCI domain, bus, device and function and "board ID" (PCI subsystem ID).
+
+  CCISS_GETDRIVVER
+
+	Returns driver version in three bytes encoded as:
+	(DRIVER_MAJOR << 28) | (DRIVER_MINOR << 24) | (DRIVER_RELEASE << 16) | DRIVER_REVISION;
+
+  CCISS_PASSTHRU
+
+	Allows "BMIC" and "CISS" commands to be passed through to the Smart Storage Array.
+	These are used extensively by the SSA Array Configuration Utility, SNMP storage
+	agents, etc.
+


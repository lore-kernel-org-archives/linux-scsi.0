From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH] bnx2fc: Add driver documentation
Date: Tue, 13 Sep 2011 11:55:14 -0700
Message-ID: <1315940114-988-1-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2911 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932092Ab1IMSz2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Sep 2011 14:55:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, mchan@broadcom.com, Bhanu Prakash Gollapudi <bprakash@broadcom.com>

bnx2fc.txt outlines the driver usage model.

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 Documentation/scsi/bnx2fc.txt |   76 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 76 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/scsi/bnx2fc.txt

diff --git a/Documentation/scsi/bnx2fc.txt b/Documentation/scsi/bnx2fc.txt
new file mode 100644
index 0000000..59e218c
--- /dev/null
+++ b/Documentation/scsi/bnx2fc.txt
@@ -0,0 +1,76 @@
+Operating FCoE using bnx2fc
+===========================
+Broadcom FCoE offload through bnx2fc is full stateful hardware offload that
+cooperates with all interfaces provided by the Linux ecosystem for FC/FCoE and
+SCSI controllers.  As such, FCoE functionality, once enabled is largely
+transparent. Devices discovered on the SAN will be registered and unregistered
+automatically with the upper storage layers.
+
+Despite the fact that the Broadcom's FCoE offload is fully offloaded, it does
+depend on the state of the network interfaces to operate. As such, the network
+interface (e.g. eth0) associated with the FCoE offload initiator must be 'up'.
+It is recommended that the network interfaces be configured to be brought up
+automatically at boot time.
+
+Furthermore, the Broadcom FCoE offload solution creates VLAN interfaces to
+support the VLANs that have been discovered for FCoE operation (e.g.
+eth0.1001-fcoe).  Do not delete or disable these interfaces or FCoE operation
+will be disrupted.
+
+Driver Usage Model:
+===================
+
+1. Ensure that fcoe-utils package is installed.
+
+2. Configure the interfaces on which bnx2fc driver has to operate on.
+Here are the steps to configure:
+	a. cd /etc/fcoe
+	b. copy cfg-ethx to cfg-eth5 if FCoE has to be enabled on eth5.
+	c. Repeat this for all the interfaces where FCoE has to be enabled.
+	d. Edit all the cfg-eth files to set "no" for DCB_REQUIRED** field, and
+	   "yes" for AUTO_VLAN.
+	e. Other configuration parameters should be left as default
+
+3. Ensure that "bnx2fc" is in SUPPORTED_DRIVERS list in /etc/fcoe/config.
+
+4. Start fcoe service. (service fcoe start). If Broadcom devices are present in
+the system, bnx2fc driver would automatically claim the interfaces, starts vlan
+discovery and log into the targets.
+
+5. "Symbolic Name" in 'fcoeadm -i' output would display if bnx2fc has claimed
+the interface.
+Eg:
+[root@bh2 ~]# fcoeadm -i
+    Description:      NetXtreme II BCM57712 10 Gigabit Ethernet
+    Revision:         01
+    Manufacturer:     Broadcom Corporation
+    Serial Number:    0010186FD558
+    Driver:           bnx2x 1.70.00-0
+    Number of Ports:  2
+
+        Symbolic Name:     bnx2fc v1.0.5 over eth5.4
+        OS Device Name:    host11
+        Node Name:         0x10000010186FD559
+        Port Name:         0x20000010186FD559
+        FabricName:        0x2001000DECB3B681
+        Speed:             10 Gbit
+        Supported Speed:   10 Gbit
+        MaxFrameSize:      2048
+        FC-ID (Port ID):   0x0F0377
+        State:             Online
+
+6. Verify the vlan discovery is performed by running ifconfig and notice
+<INTERFACE>.<VLAN>-fcoe interfaces are automatically created.
+
+Refer to fcoeadm manpage for more information on fcoeadm operations to
+create/destroy interfaces or to display lun/target information.
+
+NOTE:
+====
+** Broadcom FCoE capable devices implement a DCBX/LLDP client on-chip. Only one
+LLDP client is allowed per interface. For proper operation all host software
+based DCBX/LLDP clients (e.g. lldpad) must be disabled. To disable lldpad on a
+given interface, run the following command:
+
+lldptool set-lldp -i <interface_name> adminStatus=disabled
+
-- 
1.7.0.6



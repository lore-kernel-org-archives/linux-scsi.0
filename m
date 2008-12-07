From: Karen Xie <kxie@chelsio.com>
Subject: [PATCH 3/3 2.6.29] cxgb3i -- documentation
Date: Sat, 6 Dec 2008 23:11:46 -0800
Message-ID: <200812070711.mB77Bk1K020901@localhost.localdomain>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.22.49.110]:2955 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443AbYLGHKo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Dec 2008 02:10:44 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com
Cc: michaelc@cs.wisc.edu, James.Bottomley@HansenPartnership.com, kxie@chelsio.com

[PATCH 3/3 2.6.29] cxgb3i -- documentation

From: Karen Xie <kxie@chelsio.com>

- document cxgb3i driver's capablity and setup steps to be used with
  open-iscsi initiator.

Signed-off-by: Karen Xie <kxie@chelsio.com>
---

 Documentation/scsi/cxgb3i.txt |   81 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 81 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/scsi/cxgb3i.txt


diff --git a/Documentation/scsi/cxgb3i.txt b/Documentation/scsi/cxgb3i.txt
new file mode 100644
index 0000000..9456013
--- /dev/null
+++ b/Documentation/scsi/cxgb3i.txt
@@ -0,0 +1,81 @@
+Chelsio S3 iSCSI Driver for Linux
+
+Introduction
+============
+
+The Chelsio T3 ASIC based Adapters (S310, S320, S302, S304, Mezz cards, etc.
+series of products) supports iSCSI acceleration and iSCSI Direct Data Placement
+(DDP) where the hardware handles the expensive byte touching operations, such
+as CRC computation and verification, and direct DMA to the final host memory
+destination:
+
+	- iSCSI PDU digest generation and verification
+
+	  On transmitting, Chelsio S3 h/w computes and inserts the Header and
+	  Data digest into the PDUs.
+	  On receiving, Chelsio S3 h/w computes and verifies the Header and
+	  Data digest of the PDUs.
+
+	- Direct Data Placement (DDP)
+
+	  S3 h/w can directly place the iSCSI Data-In or Data-Out PDU's
+	  payload into pre-posted final destination host-memory buffers based
+	  on the Initiator Task Tag (ITT) in Data-In or Target Task Tag (TTT)
+	  in Data-Out PDUs.
+
+	- PDU Transmit and Recovery
+
+	  On transmitting, S3 h/w accepts the complete PDU (header + data)
+	  from the host driver, computes and inserts the digests, decomposes
+	  the PDU into multiple TCP segments if necessary, and transmit all
+	  the TCP segments onto the wire. It handles TCP retransmission if
+	  needed.
+
+	  On receving, S3 h/w recovers the iSCSI PDU by reassembling TCP
+	  segments, separating the header and data, calculating and verifying
+	  the digests, then forwards the header to the host. The payload data,
+	  if possible, will be directly placed into the pre-posted host DDP
+	  buffer. Otherwise, the payload data will be sent to the host too.
+
+The cxgb3i driver interfaces with open-iscsi initiator and provides the iSCSI
+acceleration through Chelsio hardware wherever applicable.
+
+Using the cxgb3i Driver
+=======================
+
+The following steps need to be taken to accelerates the open-iscsi initiator:
+
+1. Load the cxgb3i driver: "modprobe cxgb3i"
+
+   The cxgb3i module registers a new transport class "cxgb3i" with open-iscsi.
+
+   * in the case of recompiling the kernel, the cxgb3i selection is located at
+	Device Drivers
+		SCSI device support --->
+			[*] SCSI low-level drivers  --->
+				<M>   Chelsio S3xx iSCSI support
+
+2. Create an interface file located under /etc/iscsi/ifaces/ for the new
+   transport class "cxgb3i".
+
+   The content of the file should be in the following format:
+	iface.transport_name = cxgb3i
+	iface.net_ifacename = <ethX>
+	iface.ipaddress = <iscsi ip address>
+
+   * if iface.ipaddress is specified, <iscsi ip address> needs to be either the
+	same as the ethX's ip address or an address on the same subnet. Make
+	sure the ip address is unique in the network.
+
+3. edit /etc/iscsi/iscsid.conf
+   The default setting for MaxRecvDataSegmentLength (131072) is too big, search
+   and replace all occurances of "xxx.iscsi.MaxRecvDataSegmentLength" to be a
+   value no bigger than 15872 (for example 8192):
+
+	discovery.sendtargets.iscsi.MaxRecvDataSegmentLength = 8192
+	node.conn[0].iscsi.MaxRecvDataSegmentLength = 8192
+
+4. To direct open-iscsi traffic to go through cxgb3i's accelerated path,
+   "-I <iface file name>" option needs to be specified with most of the
+   iscsiadm command. <iface file name> is the transport interface file created
+   in step 2.

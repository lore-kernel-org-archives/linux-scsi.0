From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 08 of 10] scsi: Documentation for the SCSI protection
	information/DIF support
Date: Wed, 25 Jun 2008 11:22:47 -0400
Message-ID: <324ad30d5cc766e8382f.1214407367@sermon.lab.mkp.net>
References: <patchbomb.1214407359@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jaguar.mkp.net ([192.139.46.146]:41047 "EHLO jaguar.mkp.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758954AbYFYPZ2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Jun 2008 11:25:28 -0400
In-Reply-To: <patchbomb.1214407359@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---
1 file changed, 57 insertions(+)
Documentation/scsi/data-integrity.txt |   57 +++++++++++++++++++++++++++++++++



diff --git a/Documentation/scsi/data-integrity.txt b/Documentation/scsi/data-integrity.txt
new file mode 100644
--- /dev/null
+++ b/Documentation/scsi/data-integrity.txt
@@ -0,0 +1,57 @@
+----------------------------------------------------------------------
+1.0 INTRODUCTION
+
+For a general overview of the data integrity framework please consult
+Documentation/block/data-integrity.txt.
+
+----------------------------------------------------------------------
+2.0 SCSI LAYER IMPLEMENTATION DETAILS
+
+The scsi_command has been extended with a scatterlist for the
+integrity metadata.  Note that all SCSI mid layer changes refer to
+this using the term "protection information" which is what it is
+called in the T10 spec.
+
+The term DIF (Data Integrity Field) is specific to SCSI disks (SBC).
+The SCSI midlayer doesn't know, or care, about the contents of the
+protection scatterlist, except it calls blk_rq_map_integrity_sg()
+during command initialization.
+
+
+2.1 SCSI DEVICE SCANNING
+
+A SCSI device has the PROTECT bit set in the standard INQUIRY page if
+it supports protection information.  The state of this bit is saved in
+the scsi_device struct.
+
+
+2.2 SCSI DISK SETUP
+
+In the case of a SCSI disk the actual DIF protection format is
+contained in in result of READ CAPACITY(16).  Consequently we have to
+use the 16-byte READ CAPACITY variant if the device is
+protection-capable.
+
+If the device has DIF-enabled we'll negotiate capabilities with the
+HBA.  And if the HBA is capable of protection DMA, the blk_integrity
+profile will be registered.
+
+Currently we only support Type 1 and Type 3.  Type 2 is only defined
+for 32-byte CDBs and is awaiting varlen CDB support.
+
+The controller may support checksum conversion as an optimization.
+Initial benchmarks showed that calculating a 16-bit CRC for each 512
+bytes of an I/O was expensive.  Emulex' hardware had the capability to
+convert an IP checksum to the T10 CRC on the wire.  So as part of the
+negotiation process the checksum algorithm will be selected and the
+blk_integrity profile set accordingly.
+
+----------------------------------------------------------------------
+3.0 HBA INTERFACE
+
+See the following doc:
+
+http://oss.oracle.com/projects/data-integrity/dist/documentation/linux-hba.pdf
+
+----------------------------------------------------------------------
+2007-12-24 Martin K. Petersen <martin.petersen@oracle.com>



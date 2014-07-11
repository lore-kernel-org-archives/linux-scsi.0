From: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] scsi: Remove some false sharing in Scsi_Host / Scsi_Device
Date: Fri, 11 Jul 2014 13:25:10 -0700
Message-ID: <1405110310-3555-1-git-send-email-andi@firstfloor.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:50710 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751587AbaGKUZQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jul 2014 16:25:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>

From: Andi Kleen <ak@linux.intel.com>

These data structures are accessed by different CPUs and have some
fields which are mostly read only and others which are frequently
written. Separate some common ones into separate cache line
to minimize false sharing while submitting a command.

This allows scsi_dispatch_cmd to do more work with shared clean
cache lines.

- Move the cmd_serial_number to the end before the host data
- Separate write common fields from read mostly fields in
the scsi device

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 include/scsi/scsi_device.h |  4 ++++
 include/scsi/scsi_host.h   | 15 ++++++++++-----
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 5853c91..2064d47 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -98,6 +98,10 @@ struct scsi_device {
 
 	unsigned long last_queue_ramp_up;	/* last queue ramp up time */
 
+	/* Mostly read fields below. Move to own cache line to avoid false
+	 * sharing  */
+	char align1 __attribute__((aligned(SMP_CACHE_BYTES)));
+
 	unsigned int id, lun, channel;
 
 	unsigned int manufacturer;	/* Manufacturer of device, for using 
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 94844fc..a9371b9 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -654,11 +654,7 @@ struct Scsi_Host {
 	short unsigned int sg_prot_tablesize;
 	short unsigned int max_sectors;
 	unsigned long dma_boundary;
-	/* 
-	 * Used to assign serial numbers to the cmds.
-	 * Protected by the host lock.
-	 */
-	unsigned long cmd_serial_number;
+
 	
 	unsigned active_mode:2;
 	unsigned unchecked_isa_dma:1;
@@ -761,6 +757,15 @@ struct Scsi_Host {
 	struct device *dma_dev;
 
 	/*
+	 * Used to assign serial numbers to the cmds.
+	 * Protected by the host lock.
+	 * Hot cache line, keep separate from read only fields.
+	 */
+	unsigned long cmd_serial_number
+		__attribute__((aligned(SMP_CACHE_BYTES)));
+	char pad[SMP_CACHE_BYTES - sizeof(unsigned long)];
+
+	/*
 	 * We should ensure that this is aligned, both for better performance
 	 * and also because some compilers (m68k) don't automatically force
 	 * alignment to a long boundary.
-- 
1.9.3


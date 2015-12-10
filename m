From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 2/6] cxlflash: Fix to avoid virtual LUN failover failure
Date: Thu, 10 Dec 2015 16:53:49 -0600
Message-ID: <1449788029-23093-1-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1449787867-23015-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:49332 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242AbbLJWyX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Dec 2015 17:54:23 -0500
Received: from localhost
	by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
	Thu, 10 Dec 2015 15:54:22 -0700
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id 3FE031FF0049
	for <linux-scsi@vger.kernel.org>; Thu, 10 Dec 2015 15:42:27 -0700 (MST)
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id tBAMsGFQ28770552
	for <linux-scsi@vger.kernel.org>; Thu, 10 Dec 2015 15:54:16 -0700
Received: from d03av02.boulder.ibm.com (localhost [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id tBAMsFWM012870
	for <linux-scsi@vger.kernel.org>; Thu, 10 Dec 2015 15:54:16 -0700
In-Reply-To: <1449787867-23015-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, Brian King <brking@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>

From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>

Applications which use virtual LUN's that are backed by a physical LUN
over both adapter ports may experience an I/O failure in the event of
a link loss (e.g. cable pull).

Virtual LUNs may be accessed through one or both ports of the adapter.
This access is encoded in the translation entries that comprise the
virtual LUN and used by the AFU for load-balancing I/O and handling
failover scenarios. In a link loss scenario, even though the AFU is
able to maintain connectivity to the LUN, it is up to the application
to retry the failed I/O. When applications are unaware of the virtual
LUN's underlying topology, they are unable to make a sound decision of
when to retry an I/O and therefore are forced to make their reaction to
a failed I/O absolute. The result is either a failure to retry I/O or
increased latency for scenarios where a retry is pointless.

To remedy this scenario, provide feedback back to the application on
virtual LUN creation as to which ports the LUN may be accessed. LUN's
spanning both ports are candidates for a retry in a presence of an I/O
failure.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/vlun.c       |  2 ++
 include/uapi/scsi/cxlflash_ioctl.h | 10 ++++++++++
 2 files changed, 12 insertions(+)

diff --git a/drivers/scsi/cxlflash/vlun.c b/drivers/scsi/cxlflash/vlun.c
index a53f583..50f8e93 100644
--- a/drivers/scsi/cxlflash/vlun.c
+++ b/drivers/scsi/cxlflash/vlun.c
@@ -1008,6 +1008,8 @@ int cxlflash_disk_virtual_open(struct scsi_device *sdev, void *arg)
 	virt->last_lba = last_lba;
 	virt->rsrc_handle = rsrc_handle;
 
+	if (lli->port_sel == BOTH_PORTS)
+		virt->hdr.return_flags |= DK_CXLFLASH_ALL_PORTS_ACTIVE;
 out:
 	if (likely(ctxi))
 		put_context(ctxi);
diff --git a/include/uapi/scsi/cxlflash_ioctl.h b/include/uapi/scsi/cxlflash_ioctl.h
index 831351b..2302f3c 100644
--- a/include/uapi/scsi/cxlflash_ioctl.h
+++ b/include/uapi/scsi/cxlflash_ioctl.h
@@ -31,6 +31,16 @@ struct dk_cxlflash_hdr {
 };
 
 /*
+ * Return flag definitions available to all ioctls
+ *
+ * Similar to the input flags, these are grown from the bottom-up with the
+ * intention that ioctl-specific return flag definitions would grow from the
+ * top-down, allowing the two sets to co-exist. While not required/enforced
+ * at this time, this provides future flexibility.
+ */
+#define DK_CXLFLASH_ALL_PORTS_ACTIVE	0x0000000000000001ULL
+
+/*
  * Notes:
  * -----
  * The 'context_id' field of all ioctl structures contains the context
-- 
2.1.0


From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH v2 2/6] cxlflash: Fix to avoid virtual LUN failover failure
Date: Mon, 14 Dec 2015 14:55:44 -0600
Message-ID: <1450126544-47592-2-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1450126293-47440-1-git-send-email-ukrishn@linux.vnet.ibm.com>
 <1450126544-47592-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e19.ny.us.ibm.com ([129.33.205.209]:48735 "EHLO
	e19.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285AbbLNU5C (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Dec 2015 15:57:02 -0500
Received: from localhost
	by e19.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
	Mon, 14 Dec 2015 15:57:01 -0500
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id 4D52638C8039
	for <linux-scsi@vger.kernel.org>; Mon, 14 Dec 2015 15:56:59 -0500 (EST)
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id tBEKuxiD27656270
	for <linux-scsi@vger.kernel.org>; Mon, 14 Dec 2015 20:56:59 GMT
Received: from d01av04.pok.ibm.com (localhost [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id tBEKuwwX024660
	for <linux-scsi@vger.kernel.org>; Mon, 14 Dec 2015 15:56:58 -0500
In-Reply-To: <1450126544-47592-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, Brian King <brking@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>

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
Acked-by: Manoj Kumar <manoj@linux.vnet.ibm.com>
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


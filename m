From: Robert Jennings <rcj@linux.vnet.ibm.com>
Subject: [PATCH 15/16 v4] ibmvfc: Add support for collaborative memory
	overcommit
Date: Wed, 23 Jul 2008 13:35:48 -0500
Message-ID: <20080723183548.GR12905@linux.vnet.ibm.com>
References: <20080723181932.GC12905@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:37540 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751903AbYGWSf7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Jul 2008 14:35:59 -0400
Received: from d01relay06.pok.ibm.com (d01relay06.pok.ibm.com [9.56.227.116])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m6NIZwr2026578
	for <linux-scsi@vger.kernel.org>; Wed, 23 Jul 2008 14:35:58 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d01relay06.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6NIZwK81638508
	for <linux-scsi@vger.kernel.org>; Wed, 23 Jul 2008 14:35:58 -0400
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m6NIZl4c002385
	for <linux-scsi@vger.kernel.org>; Wed, 23 Jul 2008 12:35:48 -0600
Content-Disposition: inline
In-Reply-To: <20080723181932.GC12905@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: paulus@samba.org, benh@kernel.crashing.org
Cc: linuxppc-dev@ozlabs.org, linux-scsi@vger.kernel.org, Brian King <brking@linux.vnet.ibm.com>, Santiago Leon <santil@us.ibm.com>, Nathan Fontenot <nfont@austin.ibm.com>, David Darrington <ddarring@linux.vnet.ibm.com>

From: Brian King <brking@linux.vnet.ibm.com>

Adds support to the ibmvfc driver for collaborative memory overcommit.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
Signed-off-by: Robert Jennings <rcj@linux.vnet.ibm.com>

---
We would like to take this patch through linuxppc-dev with the full
change set for this feature.  We are copying linux-scsi for review and ack.

---
 drivers/scsi/ibmvscsi/ibmvfc.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

Index: b/drivers/scsi/ibmvscsi/ibmvfc.c
===================================================================
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -3819,6 +3819,20 @@ static int ibmvfc_remove(struct vio_dev 
 	return 0;
 }
 
+/**
+ * ibmvfc_get_desired_dma - Calculate DMA resources needed by the driver
+ * @vdev:	vio device struct
+ *
+ * Return value:
+ *	Number of bytes the driver will need to DMA map at the same time in
+ *	order to perform well.
+ */
+static unsigned long ibmvfc_get_desired_dma(struct vio_dev *vdev)
+{
+	unsigned long pool_dma = max_requests * sizeof(union ibmvfc_iu);
+	return pool_dma + ((512 * 1024) * driver_template.cmd_per_lun);
+}
+
 static struct vio_device_id ibmvfc_device_table[] __devinitdata = {
 	{"fcp", "IBM,vfc-client"},
 	{ "", "" }
@@ -3829,6 +3843,7 @@ static struct vio_driver ibmvfc_driver =
 	.id_table = ibmvfc_device_table,
 	.probe = ibmvfc_probe,
 	.remove = ibmvfc_remove,
+	.get_desired_dma = ibmvfc_get_desired_dma,
 	.driver = {
 		.name = IBMVFC_NAME,
 		.owner = THIS_MODULE,

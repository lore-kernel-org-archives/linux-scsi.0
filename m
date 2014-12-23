From: "Anil Chintalapati (achintal)" <achintal@cisco.com>
Subject: [PATCH 1/1] IOMMU Fault occurs when IO and abort IO is out of order
Date: Tue, 23 Dec 2014 19:40:00 +0000
Message-ID: <1A24EF7A5DFB3449AD456B40D20E12A0011FD5EE@xmb-aln-x09.cisco.com>
References: <1416263292-25713-1-git-send-email-achintal@cisco.com>
 <D0BF0347.2DC6A%hishah@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcdn-iport-9.cisco.com ([173.37.86.80]:13565 "EHLO
	rcdn-iport-9.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280AbaLWTte convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Dec 2014 14:49:34 -0500
Received: from xhc-rcd-x12.cisco.com (xhc-rcd-x12.cisco.com [173.37.183.86])
	by rcdn-core-7.cisco.com (8.14.5/8.14.5) with ESMTP id sBNJe1Js007709
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=FAIL)
	for <linux-scsi@vger.kernel.org>; Tue, 23 Dec 2014 19:40:01 GMT
In-Reply-To: <D0BF0347.2DC6A%hishah@cisco.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "Hiral Shah (hishah)" <hishah@cisco.com>, "Sesidhar Baddela (sebaddel)" <sebaddel@cisco.com>

When I/O is aborted by mid-layer, fnic FW will complete the I/O before completing the abort task. In some cases abort request is completed before the I/O, which could lead to inconsistent driver and firmware states. In this case firmware reset would clear the inconsistent state


Signed-off-by: Anil Chintalapati <achintal@cisco.com>
Signed-off-by: Sesidhar Baddela <sebaddel@cisco.com>
Signed-off-by: Hiral Shah <hishah@cisco.com>

---
 drivers/scsi/fnic/fnic.h      |  2 +-
 drivers/scsi/fnic/fnic_scsi.c | 15 +++++++++++++++
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h index bf8d34c..26270c3 100644
--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -39,7 +39,7 @@
 
 #define DRV_NAME		"fnic"
 #define DRV_DESCRIPTION		"Cisco FCoE HBA Driver"
-#define DRV_VERSION		"1.6.0.11"
+#define DRV_VERSION		"1.6.0.17"
 #define PFX			DRV_NAME ": "
 #define DFX                     DRV_NAME "%d: "
 
diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c index 961bdf5..9ebc933 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -1873,6 +1873,21 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
 		goto fnic_abort_cmd_end;
 	}
 
+	/* IO out of order */
+
+	if (!(CMD_FLAGS(sc) & (FNIC_IO_ABORTED | FNIC_IO_DONE))) {
+		spin_unlock_irqrestore(io_lock, flags);
+		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
+			"Issuing Host reset due to out of order IO\n");
+
+		if (fnic_host_reset(sc) == FAILED) {
+			FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
+				"fnic_host_reset failed.\n");
+		}
+		ret = FAILED;
+		goto fnic_abort_cmd_end;
+	}
+
 	CMD_STATE(sc) = FNIC_IOREQ_ABTS_COMPLETE;
 
 	/*
--
1.8.5.4



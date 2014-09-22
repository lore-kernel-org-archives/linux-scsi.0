From: Chris J Arges <chris.j.arges@canonical.com>
Subject: [PATCH v2] mptfusion: enable no_write_same for vmware scsi disks
Date: Mon, 22 Sep 2014 15:44:52 -0500
Message-ID: <1411418701-25025-1-git-send-email-chris.j.arges@canonical.com>
References: <20140922181929.GA11319@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140922181929.GA11319@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: hch@infradead.org
Cc: bruce.lucas@mongodb.com, Chris J Arges <chris.j.arges@canonical.com>, Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

When using a virtual SCSI disk in a VMWare VM if blkdev_issue_zeroout is used
data can be improperly zeroed out using the mptfusion driver. This patch
disables write_same for this driver and the vmware subsystem_vendor which
ensures that manual zeroing out is used instead.

BugLink: http://bugs.launchpad.net/bugs/1371591
Reported-by: Bruce Lucas <bruce.lucas@mongodb.com>
Tested-by: Chris J Arges <chris.j.arges@canonical.com>
Signed-off-by: Chris J Arges <chris.j.arges@canonical.com>
---
 drivers/message/fusion/mptspi.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/message/fusion/mptspi.c b/drivers/message/fusion/mptspi.c
index 787933d..fca1594 100644
--- a/drivers/message/fusion/mptspi.c
+++ b/drivers/message/fusion/mptspi.c
@@ -1409,6 +1409,12 @@ mptspi_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		return 0;
 	}
 
+	/* Fix for vmware guests that do not implement write_same
+         */
+	if (pdev->subsystem_vendor == 0x15AD) {
+		mptspi_driver_template.no_write_same = 1;
+	}
+
 	sh = scsi_host_alloc(&mptspi_driver_template, sizeof(MPT_SCSI_HOST));
 
 	if (!sh) {
-- 
1.9.1

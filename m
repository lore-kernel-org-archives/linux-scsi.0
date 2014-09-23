From: Chris J Arges <chris.j.arges@canonical.com>
Subject: [PATCH v3] mptfusion: enable no_write_same for vmware scsi disks
Date: Tue, 23 Sep 2014 09:22:25 -0500
Message-ID: <1411482160-32007-1-git-send-email-chris.j.arges@canonical.com>
References: <20140923071154.GB3867@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140923071154.GB3867@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: hch@infradead.org
Cc: bruce.lucas@mongodb.com, adam.radford@avagotech.com, kashyap.desai@avagotech.com, Chris J Arges <chris.j.arges@canonical.com>, Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
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
 drivers/message/fusion/mptspi.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/message/fusion/mptspi.c b/drivers/message/fusion/mptspi.c
index 787933d..613231c 100644
--- a/drivers/message/fusion/mptspi.c
+++ b/drivers/message/fusion/mptspi.c
@@ -1419,6 +1419,11 @@ mptspi_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto out_mptspi_probe;
         }
 
+	/* VMWare emulation doesn't properly implement WRITE_SAME
+	 */
+	if (pdev->subsystem_vendor == 0x15AD)
+		sh->no_write_same = 1;
+
 	spin_lock_irqsave(&ioc->FreeQlock, flags);
 
 	/* Attach the SCSI Host to the IOC structure
-- 
1.9.1

From: Leann Ogasawara <ogasawara@osdl.org>
Subject: [PATCH] mptbase:  Fix ignored return value warning
Date: Fri, 20 Oct 2006 14:09:43 -0700
Message-ID: <1161378583.19763.81.camel@ogasawara.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:18408 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1030355AbWJTVJp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Oct 2006 17:09:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "Moore, Eric" <Eric.Moore@lsil.com>

Hi All,

This patch fixes the following warning:

drivers/message/fusion/mptbase.c:1526: warning: ignoring return value of
`pci_enable_device', declared with attribute warn_unused_result

Signed-off-by: Leann Ogasawara <ogasawara@osdl.org>

---

Index: linux-2.6.19-rc2-git4/drivers/message/fusion/mptbase.c
===================================================================
--- linux-2.6.19-rc2-git4.orig/drivers/message/fusion/mptbase.c	2006-10-20 09:54:14.000000000 -0700
+++ linux-2.6.19-rc2-git4/drivers/message/fusion/mptbase.c	2006-10-20 13:43:15.000000000 -0700
@@ -1516,6 +1516,7 @@
 	MPT_ADAPTER *ioc = pci_get_drvdata(pdev);
 	u32 device_state = pdev->current_state;
 	int recovery_state;
+	int err;
 
 	printk(MYIOC_s_INFO_FMT
 	"pci-resume: pdev=0x%p, slot=%s, Previous operating state [D%d]\n",
@@ -1523,7 +1524,11 @@
 
 	pci_set_power_state(pdev, 0);
 	pci_restore_state(pdev);
-	pci_enable_device(pdev);
+	err = pci_enable_device(pdev);
+	if (err) {
+		printk(KERN_ERR "mptbase: Failed to enable PCI device.\n");
+		return err;
+	}
 
 	/* enable interrupts */
 	CHIPREG_WRITE32(&ioc->chip->IntMask, MPI_HIM_DIM);



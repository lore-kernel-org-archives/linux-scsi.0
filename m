From: Noriyuki Fujii <n-fujii@np.css.fujitsu.com>
Subject: [PATCH] PCI legacy I/O port free driver - Making MegaRAID SAS driver
Date: Fri, 20 Nov 2009 16:27:20 +0900
Message-ID: <4B0644D8.8010000@np.css.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:54180 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286AbZKTH2g (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Nov 2009 02:28:36 -0500
Received: from m6.gw.fujitsu.co.jp ([10.0.50.76])
	by fgwmail7.fujitsu.co.jp (Fujitsu Gateway) with ESMTP id nAK7SenP004857
	for <linux-scsi@vger.kernel.org> (envelope-from n-fujii@np.css.fujitsu.com);
	Fri, 20 Nov 2009 16:28:40 +0900
Received: from smail (m6 [127.0.0.1])
	by outgoing.m6.gw.fujitsu.co.jp (Postfix) with ESMTP id 6A6E045DE4C
	for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2009 16:28:40 +0900 (JST)
Received: from s6.gw.fujitsu.co.jp (s6.gw.fujitsu.co.jp [10.0.50.96])
	by m6.gw.fujitsu.co.jp (Postfix) with ESMTP id 09F3045DE51
	for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2009 16:28:40 +0900 (JST)
Received: from s6.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s6.gw.fujitsu.co.jp (Postfix) with ESMTP id D7E74E18004
	for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2009 16:28:39 +0900 (JST)
Received: from ml2.s.css.fujitsu.com (ml2.s.css.fujitsu.com [10.23.4.192])
	by s6.gw.fujitsu.co.jp (Postfix) with ESMTP id 896391DB803F
	for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2009 16:28:39 +0900 (JST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: megaraidlinux@lsi.com, linux-scsi@vger.kernel.org, James.Bottomley@suse.de

Hi,

On the large servers, I/O port resource may not be assigned to all
the PCI devices since it is limited (to 64KB on Intel Architecture[1])
and it may also be fragmented (I/O base register of PCI-to-PCI bridge
will usually be aligned to a 4KB boundary[2]).
If no I/O port resource is assigned to devices, those devices do not
work.
[1] Some machines support 64KB I/O port space per PCI segment.
[2] Some P2P bridges support optional 1KB aligned I/O base.

Therefore, I made a patch for MegaRAID SAS driver to make PCI legacy I/O
port free.
I have also tested the patch and it had no problem.

The way to make PCI legacy I/O port free is the same as Fusion-MPT
driver's and it has been merged into 2.6.30.4.

This has already been fixed in e1000 and lpfc.

As a result of the above, the driver can handle its device even when
there are a huge number of PCI devices being used on the system and no
I/O port region assigned to the device.

Thanks,
Noriyuki Fujii

Signed-off-by: Noriyuki Fujii n-fujii@np.css.fujitsu.com

 drivers/scsi/megaraid/megaraid_sas.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.c
b/drivers/scsi/megaraid/megaraid_sas.c
index a39addc..8a58927 100644
--- a/drivers/scsi/megaraid/megaraid_sas.c
+++ b/drivers/scsi/megaraid/megaraid_sas.c
@@ -2087,7 +2087,9 @@ static int megasas_init_mfi(struct
megasas_instance *instance)
 		instance->base_addr = pci_resource_start(instance->pdev, 0);
 	}

-	if (pci_request_regions(instance->pdev, "megasas: LSI")) {
+	if (pci_request_selected_regions(instance->pdev,
+		pci_select_bars(instance->pdev, IORESOURCE_MEM),
+		"megasas: LSI")) {
 		printk(KERN_DEBUG "megasas: IO memory region busy!\n");
 		return -EBUSY;
 	}
@@ -2220,7 +2222,8 @@ static int megasas_init_mfi(struct
megasas_instance *instance)
 	iounmap(instance->reg_set);

       fail_ioremap:
-	pci_release_regions(instance->pdev);
+	pci_release_selected_regions(instance->pdev,
+		pci_select_bars(instance->pdev, IORESOURCE_MEM));

 	return -EINVAL;
 }
@@ -2240,7 +2243,8 @@ static void megasas_release_mfi(struct
megasas_instance *instance)

 	iounmap(instance->reg_set);

-	pci_release_regions(instance->pdev);
+	pci_release_selected_regions(instance->pdev,
+		pci_select_bars(instance->pdev, IORESOURCE_MEM));
 }

 /**
@@ -2537,7 +2541,7 @@ megasas_probe_one(struct pci_dev *pdev, const
struct pci_device_id *id)
 	/*
 	 * PCI prepping: enable device set bus mastering and dma mask
 	 */
-	rval = pci_enable_device(pdev);
+	rval = pci_enable_device_mem(pdev);

 	if (rval) {
 		return rval;
@@ -2818,7 +2822,7 @@ megasas_resume(struct pci_dev *pdev)
 	/*
 	 * PCI prepping: enable device set bus mastering and dma mask
 	 */
-	rval = pci_enable_device(pdev);
+	rval = pci_enable_device_mem(pdev);

 	if (rval) {
 		printk(KERN_ERR "megasas: Enable device failed\n");



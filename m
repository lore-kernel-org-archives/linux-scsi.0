From: Ke Wei <kewei@marvell.com>
Subject: [PATCH 8/8] mvsas: check subsystem id
Date: Fri, 21 Mar 2008 19:07:13 +0800
Message-ID: <47E396E1.7090605@marvell.com>
Reply-To: kewei@marvell.com, kewei.mv@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host2.marvell.com ([65.219.4.2]:12033 "EHLO maili.marvell.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754624AbYCULHQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Mar 2008 07:07:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: james.bottomley@hansenpartnership.com, jeff@garzik.org

add support for mv6480 chip which subsystem id is 6480 in spite of 
device id is 6440.


Signed-off-by: Ke Wei <kewei@marvell.com>
---
 drivers/scsi/mvsas.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/mvsas.c b/drivers/scsi/mvsas.c
index b5de3d0..e55b903 100644
--- a/drivers/scsi/mvsas.c
+++ b/drivers/scsi/mvsas.c
@@ -3163,6 +3163,15 @@ static struct sas_domain_function_template 
mvs_transport_ops = {
 static struct pci_device_id __devinitdata mvs_pci_table[] = {
     { PCI_VDEVICE(MARVELL, 0x6320), chip_6320 },
     { PCI_VDEVICE(MARVELL, 0x6340), chip_6440 },
+    {
+        .vendor     = PCI_VENDOR_ID_MARVELL,
+        .device     = 0x6440,
+        .subvendor    = PCI_ANY_ID,
+        .subdevice    = 0x6480,
+        .class        = 0,
+        .class_mask    = 0,
+        .driver_data    = chip_6480,
+    },
     { PCI_VDEVICE(MARVELL, 0x6440), chip_6440 },
     { PCI_VDEVICE(MARVELL, 0x6480), chip_6480 },
 
-- 
1.5.4



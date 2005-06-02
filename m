From: Nathan Lynch <ntl@pobox.com>
Subject: [PATCH] fix slab corruption during ipr probe
Date: Thu, 2 Jun 2005 17:15:09 -0500
Message-ID: <20050602221509.GA11355@otto>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from orb.pobox.com ([207.8.226.5]:49058 "EHLO orb.pobox.com")
	by vger.kernel.org with ESMTP id S261351AbVFBWPP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Jun 2005 18:15:15 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@SteelEye.com, brking@us.ibm.com, linuxppc64-dev@ozlabs.org

Hi-

With CONFIG_DEBUG_SLAB=y I see slab corruption messages during boot on
pSeries machines with IPR adapters with any 2.6.12-rc kernel.

The change which seems to have introduced the problem is "SCSI: revamp
target scanning routines" and may be found at:
http://marc.theaimsgroup.com/?l=bk-commits-head&m=111093946426333&w=2

In order to revert that in a 2.6.12-rc1 tree, I had to revert "target
code updates to support scanned targets" first:
http://marc.theaimsgroup.com/?l=bk-commits-head&m=111094132524649&w=2

With both patches reverted, the corruption messages go away.

ipr: IBM Power RAID SCSI Device Driver version: 2.0.13 (February 21,
2005)
ipr 0001:d0:01.0: Found IOA with IRQ: 167
ipr 0001:d0:01.0: Starting IOA initialization sequence.
ipr 0001:d0:01.0: Adapter firmware version: 020A005C
ipr 0001:d0:01.0: IOA initialized.
scsi0 : IBM 570B Storage Adapter
  Vendor: IBM       Model: VSBPD4E1  U4SCSI  Rev: 4770
  Type:   Enclosure                          ANSI SCSI revision: 02
  Vendor: IBM   H0  Model: HUS103036FL3800   Rev: RPQF
  Type:   Direct-Access                      ANSI SCSI revision: 04
  Vendor: IBM   H0  Model: HUS103036FL3800   Rev: RPQF
  Type:   Direct-Access                      ANSI SCSI revision: 04
  Vendor: IBM   H0  Model: HUS103036FL3800   Rev: RPQF
  Type:   Direct-Access                      ANSI SCSI revision: 04
  Vendor: IBM   H0  Model: HUS103036FL3800   Rev: RPQF
  Type:   Direct-Access                      ANSI SCSI revision: 04
  Vendor: IBM       Model: VSBPD4E1  U4SCSI  Rev: 4770
  Type:   Enclosure                          ANSI SCSI revision: 02
Slab corruption: start=c0000001e8de5268, len=512
Redzone: 0x5a2cf071/0x5a2cf071.
Last user: [<c00000000029c3a0>](.scsi_target_dev_release+0x28/0x50)
080: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6a
Prev obj: start=c0000001e8de5050, len=512
Redzone: 0x5a2cf071/0x5a2cf071.
Last user: [<0000000000000000>](0x0)
000: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
010: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
Next obj: start=c0000001e8de5480, len=512
Redzone: 0x170fc2a5/0x170fc2a5.
Last user: [<c000000000228d7c>](.as_init_queue+0x5c/0x228)
000: c0 00 00 01 e8 83 26 08 00 00 00 00 00 00 00 00
010: 00 00 00 00 00 00 00 00 c0 00 00 01 e8 de 54 98
Slab corruption: start=c0000001e8de5268, len=512
Redzone: 0x5a2cf071/0x5a2cf071.
Last user: [<c00000000029c3a0>](.scsi_target_dev_release+0x28/0x50)
080: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6a
Prev obj: start=c0000001e8de5050, len=512
Redzone: 0x5a2cf071/0x5a2cf071.
Last user: [<0000000000000000>](0x0)
000: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
010: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
Next obj: start=c0000001e8de5480, len=512
Redzone: 0x170fc2a5/0x170fc2a5.
Last user: [<c000000000228d7c>](.as_init_queue+0x5c/0x228)
000: c0 00 00 01 e8 83 26 08 00 00 00 00 00 00 00 00
010: 00 00 00 00 00 00 00 00 c0 00 00 01 e8 de 54 98
...

I did some digging and the problem seems to be a refcounting issue in
__scsi_add_device.  The target gets freed in scsi_target_reap, and
then __scsi_add_device tries to do another device_put on it.  I'm not
sure whether other users of __scsi_add_device are affected by this.

This patch works for me (tm); is it correct?

Signed-off-by: Nathan Lynch <ntl@pobox.com>

Index: linux-2.6.12-rc5/drivers/scsi/scsi_scan.c
===================================================================
--- linux-2.6.12-rc5.orig/drivers/scsi/scsi_scan.c
+++ linux-2.6.12-rc5/drivers/scsi/scsi_scan.c
@@ -1197,6 +1197,7 @@ struct scsi_device *__scsi_add_device(st
 	if (!starget)
 		return ERR_PTR(-ENOMEM);
 
+	get_device(&starget->dev);
 	down(&shost->scan_mutex);
 	res = scsi_probe_and_add_lun(starget, lun, NULL, &sdev, 1, hostdata);
 	if (res != SCSI_SCAN_LUN_PRESENT)




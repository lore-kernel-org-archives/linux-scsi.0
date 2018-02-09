From: Meelis Roos <mroos@linux.ee>
Subject: [PATCH] aacraid: fix shutdown crash when init fails
Date: Fri, 9 Feb 2018 08:57:44 +0200 (EET)
Message-ID: <alpine.LRH.2.21.1802082158280.7112@math.ut.ee>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:42269 "EHLO smtp2.it.da.ut.ee"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750828AbeBIG5u (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 9 Feb 2018 01:57:50 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Adaptec OEM Raid Solutions <aacraid@microsemi.com>

When aacraid init fails with "AAC0: adapter self-test failed.", shutdown 
leads to UBSAN warning and then oops:

[154316.118423] ================================================================================
[154316.118508] UBSAN: Undefined behaviour in drivers/scsi/scsi_lib.c:2328:27
[154316.118566] member access within null pointer of type 'struct Scsi_Host'
[154316.118631] CPU: 2 PID: 14530 Comm: reboot Tainted: G        W        4.15.0-dirty #89
[154316.118701] Hardware name: Hewlett Packard HP NetServer/HP System Board, BIOS 4.06.46 PW 06/25/2003
[154316.118774] Call Trace:
[154316.118848]  dump_stack+0x48/0x65
[154316.118916]  ubsan_epilogue+0xe/0x40
[154316.118976]  __ubsan_handle_type_mismatch+0xfb/0x180
[154316.119043]  scsi_block_requests+0x20/0x30
[154316.119135]  aac_shutdown+0x18/0x40 [aacraid]
[154316.119196]  pci_device_shutdown+0x33/0x50
[154316.119269]  device_shutdown+0x18a/0x390
[...]
[154316.123435] BUG: unable to handle kernel NULL pointer dereference at 000000f4
[154316.123515] IP: scsi_block_requests+0xa/0x30

This is because aac_shutdown() does

        struct Scsi_Host *shost = pci_get_drvdata(dev);
        scsi_block_requests(shost);

and that assumes shost has been assigned with pci_set_drvdata().

However, pci_set_drvdata(pdev, shost) is done in aac_probe_one() far 
after bailing out with error from calling the init function 
((*aac_drivers[index].init)(aac)), and when the init function fails, no 
error is returned from aac_probe_one() so PCI layer assumes there is 
driver attached, and tries to shut it down later.

Fix it by returning error from aac_probe_one() when card-specific init 
function fails.

This fixes reboot on my HP NetRAID-4M with dead battery.

Signed-off-by: Meelis Roos <mroos@linux.ee>

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index d55332de08f9..01c171e440bd 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1693,8 +1693,10 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	 *	Map in the registers from the adapter.
 	 */
 	aac->base_size = AAC_MIN_FOOTPRINT_SIZE;
-	if ((*aac_drivers[index].init)(aac))
+	if ((*aac_drivers[index].init)(aac)) {
+		error = -ENODEV;
 		goto out_unmap;
+	}
 
 	if (aac->sync_mode) {
 		if (aac_sync_mode)

-- 
Meelis Roos (mroos@linux.ee)

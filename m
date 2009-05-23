From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] Convert scsi_scan to use generic async mechanism
Date: Sat, 23 May 2009 11:21:43 -0500
Message-ID: <1243095703.3630.24.camel@localhost.localdomain>
References: <20090428193557.GC21648@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:59297 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752656AbZEWQVn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 23 May 2009 12:21:43 -0400
In-Reply-To: <20090428193557.GC21648@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>, Brian King <brking@linux.vnet.ibm.com>

On Tue, 2009-04-28 at 13:35 -0600, Matthew Wilcox wrote:
> The new generic async scanning infrastructure is a perfect replacement
> for the scsi async scanning code.  We do need to use a separate domain
> as libata drivers will deadlock waiting for themselves to complete if
> we don't.  Tested with 515 LUNs (3 on AHCI, two fibre channel cards,
> each with two targets, each with 128 LUNs).

I'm afraid this patch fails in testing with the ipr driver by causing a
boot hang:


INFO: task modprobe:424 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
modprobe      D 000000000ff61bb4     0   424      1
Call Trace:
[c00000007875af50] [c00000007875b000] 0xc00000007875b000 (unreliable)
[c00000007875b120] [c0000000000121fc] .__switch_to+0x14c/0x1ac
[c00000007875b1b0] [c00000000039e9ec] .__schedule+0x9c4/0xaa8
[c00000007875b2e0] [c00000000039eaec] .schedule+0x1c/0x3c
[c00000007875b360] [c000000000085ab0] .async_synchronize_cookie_domain
+0xec/0x178
[c00000007875b440] [d000000000ca00d8] .__scsi_add_device+0xb0/0x130
[scsi_mod]
[c00000007875b500] [d000000000ca016c] .scsi_add_device+0x14/0x44
[scsi_mod]
[c00000007875b570] [d000000000e77094] .ipr_probe+0x11d4/0x12d4 [ipr]
[c00000007875b6c0] [c0000000001fe028] .local_pci_probe+0x34/0x48
[c00000007875b730] [c0000000001fed2c] .pci_device_probe+0xe8/0x130
[c00000007875b7e0] [c0000000002ca9f8] .driver_probe_device+0xd4/0x1bc
[c00000007875b880] [c0000000002cab74] .__driver_attach+0x94/0xd8
[c00000007875b910] [c0000000002c9f84] .bus_for_each_dev+0x80/0xe8
[c00000007875b9c0] [c0000000002ca7c8] .driver_attach+0x28/0x40
[c00000007875ba40] [c0000000002c9628] .bus_add_driver+0x138/0x2d8
[c00000007875bae0] [c0000000002cafe8] .driver_register+0xf0/0x1b0
[c00000007875bb80] [c0000000001ff2b8] .__pci_register_driver+0x70/0x11c
[c00000007875bc20] [d000000000e771cc] .ipr_init+0x38/0x1af4 [ipr]
[c00000007875bca0] [c0000000000092d8] .do_one_initcall+0x80/0x1a4
[c00000007875bd90] [c00000000009f468] .SyS_init_module+0xd8/0x240
[c00000007875be30] [c000000000008554] syscall_exit+0x0/0x40
1 lock held by modprobe/424:
 #0:  (&shost->scan_mutex){+.+...}, at:
[<d000000000ca00c0>] .__scsi_add_device+0x98/0x130 [scsi_mod]

(This kernel was configured for SYNC scanning).

The problem has its roots in the way the ipr driver works.  ipr is a
hybrid SCSI/RAID card, very much in the mold of fusion.  However, unlike
fusion it treats everything as a RAID, so my single pass through SAS
disk on an ipr card is presented natively, it's not attached to the SAS
transports.

The problem is in ipr.c:7612 (it's trying to make the device visible
using scsi_add_device) and hanging.

The device it's trying to add is this one:

Host: scsi0 Channel: 255 Id: 255 Lun: 255
  Vendor: IBM      Model: 572C001SISIOA    Rev: 0150
  Type:   Unknown                          ANSI SCSI revision: 03

The reason scsi_add_device() is failing seems to be that
async_synchronize_full_domain() is a bit fragile in that it only expects
to be called once.  Call it again, like we do, to make sure there aren't
any outstanding scans and it hangs on the wait event.

This simplest fix might be just to take the async wait out of our sync
methods, like the patch below.  Alternatively, perhaps
async_synchronize_full_domain() should be made a bit more robust?

James

---
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 7d7db71..e449435 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1472,8 +1472,6 @@ struct scsi_device *__scsi_add_device(struct Scsi_Host *shost, uint channel,
 		return ERR_PTR(-ENOMEM);
 
 	mutex_lock(&shost->scan_mutex);
-	if (!shost->async_scan)
-		scsi_complete_async_scans();
 
 	if (scsi_host_scan_allowed(shost))
 		scsi_probe_and_add_lun(starget, lun, NULL, &sdev, 1, hostdata);
@@ -1587,8 +1585,6 @@ void scsi_scan_target(struct device *parent, unsigned int channel,
 		return;
 
 	mutex_lock(&shost->scan_mutex);
-	if (!shost->async_scan)
-		scsi_complete_async_scans();
 
 	if (scsi_host_scan_allowed(shost))
 		__scsi_scan_target(parent, channel, id, lun, rescan);
@@ -1640,8 +1636,6 @@ int scsi_scan_host_selected(struct Scsi_Host *shost, unsigned int channel,
 		return -EINVAL;
 
 	mutex_lock(&shost->scan_mutex);
-	if (!shost->async_scan)
-		scsi_complete_async_scans();
 
 	if (scsi_host_scan_allowed(shost)) {
 		if (channel == SCAN_WILD_CARD)






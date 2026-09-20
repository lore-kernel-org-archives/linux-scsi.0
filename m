Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57A3417B50F;
	Sun, 20 Sep 2026 01:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789867487; cv=none; b=VlEFI3+54wPeEj4Ceg7SFHDcEOE/RMQARR50zjN20j0QQPFNep6lKn2S5BdaK48xYChydB338xkBtLJzlfMVkGa5/+KdFcSOIg2Mtbd20k9X94Pxt6JilFDksi0Gfc3B0k9O2Wd0Y3KHwwmINi11tN9+DL/uIvP4MfyhXTkM6OM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789867487; c=relaxed/simple;
	bh=wVa29BDPgTaFLYu+82Pfq27S9e/BxvnQ1dFAU97nMCk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=KcUVSddokJV3mICixep16QIUfpCALJMukMse/+A0TAp/3FvqNNhbs7fqc2mmjmbB7uwALwmKYmA3E290KyWOmibAM09tTDf+MBRrfEqa2hoNKrhytuIyWhI5OmWIuC8swll8rEnTmPQNyStVfWQ2fAeReC+sl0Fi4ZBBpCTAMA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 04bf767cb49211f19a56ed5b684f684d-20260920
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:3b028417-4ef9-471f-b76d-d874774c7354,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:7db8b62,CLOUDID:ee5bbe308ca2b855adfb34d9bf7f7fc1,BulkI
	D:nil,BulkQuantity:0,SF:102|865|898,TC:nil,Content:0|15|50|99,EDM:-3,IP:ni
	l,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 04bf767cb49211f19a56ed5b684f684d-20260920
X-User: lijiayi@kylinos.cn
Received: from thinksys.tail1c7620.ts.net [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <lijiayi@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1051692619; Sun, 20 Sep 2026 09:24:26 +0800
From: Jiayi Li <lijiayi@kylinos.cn>
To: Oliver Neukum <oneukum@suse.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	linux-usb@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	usb-storage@lists.one-eyed-alien.net,
	linux-kernel@vger.kernel.org,
	Jiayi Li <lijiayi@kylinos.cn>
Subject: [RFC PATCH] usb: uas: quiesce SCSI before stopping endpoints on driver unbind
Date: Sun, 20 Sep 2026 09:23:58 +0800
Message-Id: <20260920012358.3362053-1-lijiayi@kylinos.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A driver-only unbind of uas while reads are in flight can leave the
storage device unusable after the driver is rebound.

Test environment:

  - Device: VIA Labs USB storage bridge, VID:PID 2109:0715, product SO1,
    with a ZX1 512 GB SSD
  - Link: SuperSpeed 5 Gbit/s, UAS interface 2-4:1.0
  - System: Ubuntu 24.04.3 LTS
  - Kernel: 7.0.0-31-generic

Reproduction steps:

  1. Unmount every mounted partition on the test disk.  In this setup
     only /dev/sda1 was mounted:

       udisksctl unmount -b /dev/sda1

  2. Start 32 concurrent O_DIRECT readers at different offsets:

       disk=/dev/sda
       pids=
       for i in $(seq 0 31); do
               while dd if="$disk" of=/dev/null bs=1M \
                       skip=$((i * 4096)) count=4096 iflag=direct \
                       status=none 2>/dev/null; do :; done &
               pids="$pids $!"
       done

  3. Wait until at least eight reads are in flight:

       while :; do
               read -r reads writes < /sys/class/block/sda/inflight
               [ "$reads" -ge 8 ] && break
               sleep 0.005
       done

  4. Unbind uas, wait two seconds, and bind it again:

       intf=2-4:1.0
       echo "$intf" > /sys/bus/usb/drivers/uas/unbind
       sleep 2
       echo "$intf" > /sys/bus/usb/drivers/uas/bind
       kill $pids 2>/dev/null || true

  5. Check dmesg and lsblk for UAS/SCSI errors and disk recovery.
The two-second delay deliberately separates teardown from reprobe.  It
did not prevent the failure.  Additional recovery checks on the same
bridge showed that waiting alone does not clear the failed state:

  - the failed device remained unusable after more than 12 minutes;
  - UAS unbind/reset followed by a 5-second wait did not recover it;
  - unbinding xHCI, waiting 10 seconds and binding it again did not
    recover it;
  - USB device reset and authorized 0 -> 1 did not recover it.

The device recovered only after it was physically unplugged and reconnected.

Observed failure:

  - 30 READ commands were in flight when unbind started;
  - the old commands completed with DID_NO_CONNECT during teardown;
  - after the two-second delay, the new UAS instance created a SCSI
    host, but the first INQUIRY Data IN completed with -EOVERFLOW;
  - error handling initially reported a successful USB device reset, but
    the following READ(10) still timed out;
  - xHCI reported completion events for unknown stream rings, a later
    device reset failed with -ENODEV, and SCSI offlined the device;
  - the USB device then disconnected and re-enumerated, but the new UAS
    instance again timed out on INQUIRY and TEST UNIT READY and was
    offlined.

Representative log from the steps above:

  [ 5138.886447] sd 0:0:0:0: [sda] tag#0 uas_zap_pending 0 uas-tag 1 inflight: CMD
  [ 5138.886674] sd 0:0:0:0: [sda] tag#0 FAILED Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK cmd_age=0s
  [ 5138.886682] I/O error, dev sda, sector 75497472 op 0x0:(READ) flags 0x4800 phys_seg 128 prio class 2
  [ 5139.077259] sd 0:0:0:0: [sda] Synchronize Cache(10) failed: Result: hostbyte=DID_ERROR driverbyte=DRIVER_OK
  [ 5141.100631] scsi host0: uas
  [ 5141.103134] scsi 0:0:0:0: tag#12 data cmplt err -75 uas-tag 1 inflight: CMD
  [ 5141.103160] scsi 0:0:0:0: tag#12 CDB: Inquiry 12 00 00 00 24 00
  [ 5161.649075] scsi 0:0:0:0: tag#12 uas_eh_abort_handler 0 uas-tag 1 inflight: CMD
  [ 5161.653963] xhci_hcd 0000:00:12.0: Transfer event 26 for unknown stream ring slot 4 ep 14
  [ 5162.682379] scsi host0: uas_eh_device_reset_handler success
  [ 5192.884624] sd 0:0:0:0: [sda] tag#16 uas_eh_abort_handler 0 uas-tag 1 inflight: CMD IN
  [ 5192.884659] sd 0:0:0:0: [sda] tag#16 CDB: Read(10) 28 00 00 00 00 00 00 00 01 00
  [ 5193.023329] scsi host0: uas_eh_device_reset_handler success
  [ 5223.084816] xhci_hcd 0000:00:12.0: Transfer event 26 for unknown stream ring slot 4 ep 10
  [ 5227.160590] usb usb2-port4: Cannot enable. Maybe the USB cable is bad?
  [ 5227.160712] scsi host0: uas_eh_device_reset_handler FAILED err -19
  [ 5227.160732] sd 0:0:0:0: Device offlined - not ready after error recovery
  [ 5227.627367] usb 2-4: USB disconnect, device number 5
  [ 5232.135739] usb 2-4: new SuperSpeed USB device number 6 using xhci_hcd
  [ 5232.157674] scsi host0: uas
  [ 5252.783442] scsi 0:0:0:0: tag#16 CDB: Inquiry 12 00 00 00 24 00
  [ 5252.783644] xhci_hcd 0000:00:12.0: Transfer event 26 for unknown stream ring slot 4 ep 10
  [ 5253.815690] scsi 0:0:0:0: tag#16 CDB: Test Unit Ready 00 00 00 00 00 00
  [ 5254.841412] scsi 0:0:0:0: Device offlined - not ready after error recovery
Why it fails:

  - usbcore disables an interface's endpoints before ->disconnect unless
    the driver sets soft_unbind;
  - the command URB may already have delivered a SCSI command when the
    data and status URBs are killed;
  - uas_disconnect() removes the SCSI host only after killing its anchored
    URBs, so SCSI teardown cannot first quiesce those accepted commands;
  - the new UAS instance can then encounter residual transport state.

The failure survived xHCI unbind/rebind and a USB device reset.  Since only
physically unplugging and reconnecting the device recovered it, the residual
state is most likely retained by the storage bridge rather than the host
controller, and is not cleared by a USB reset.

What this patch does:

  - set soft_unbind so endpoints remain available during driver-only
    unbind;
  - cancel pending scanning before removing the SCSI host;
  - for driver-only unbind, remove the SCSI host before setting resetting,
    killing the anchored URBs and freeing streams;
  - for physical disconnect, retain the existing kill-first order because
    the endpoints are no longer usable.

This follows the broad ordering used by usb-storage, which sets
soft_unbind and removes its SCSI host before releasing transport
resources.

Test results:

  - Unmodified driver: the steps above, including the
    two-second delay, reproduced on the first iteration.
  - Patched driver: 10 of 10 zero-delay iterations reattached the disk and
    completed the post-bind O_DIRECT read.
  - Each patched iteration had 30 reads in flight at unbind.
  - Patched unbind took 82 to 109 ms.
  - No UAS completion error or command timeout occurred after rebind.

Signed-off-by: Jiayi Li <lijiayi@kylinos.cn>
---
Open questions for RFC discussion:

The change above fixes the reproduced failure, but it is not clear whether
this is the best way to handle driver-only unbind in uas.

  1. Is enabling soft_unbind and moving scsi_remove_host() ahead of URB
     teardown acceptable for driver-only unbind?
  2. Is there a more appropriate way to quiesce SCSI commands and UAS
     streams before endpoint teardown?
  3. If this ordering is acceptable, does the driver-only unbind path need
     a bounded fallback when scsi_remove_host() encounters a nonresponsive
     device or ongoing SCSI error handling?

Base: linux-next next-20260915
base-commit: e6e35979777d646fe3c7c94dca7dd32fb25d45f4

---
 drivers/usb/storage/uas.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 8655edbd66b16..b64048083cb02 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -1215,7 +1215,14 @@ static void uas_disconnect(struct usb_interface *intf)
 {
 	struct Scsi_Host *shost = usb_get_intfdata(intf);
 	struct uas_dev_info *devinfo = (struct uas_dev_info *)shost->hostdata;
+	struct usb_device *udev = interface_to_usbdev(intf);
 	unsigned long flags;
+	bool driver_unbind = udev->state != USB_STATE_NOTATTACHED;
+
+	if (driver_unbind) {
+		cancel_work_sync(&devinfo->scan_work);
+		scsi_remove_host(shost);
+	}
 
 	spin_lock_irqsave(&devinfo->lock, flags);
 	devinfo->resetting = 1;
@@ -1227,13 +1234,10 @@ static void uas_disconnect(struct usb_interface *intf)
 	usb_kill_anchored_urbs(&devinfo->data_urbs);
 	uas_zap_pending(devinfo, DID_NO_CONNECT);
 
-	/*
-	 * Prevent SCSI scanning (if it hasn't started yet)
-	 * or wait for the SCSI-scanning routine to stop.
-	 */
-	cancel_work_sync(&devinfo->scan_work);
-
-	scsi_remove_host(shost);
+	if (!driver_unbind) {
+		cancel_work_sync(&devinfo->scan_work);
+		scsi_remove_host(shost);
+	}
 	uas_free_streams(devinfo);
 	scsi_host_put(shost);
 }
@@ -1267,6 +1271,7 @@ static struct usb_driver uas_driver = {
 	.suspend = uas_suspend,
 	.resume = uas_resume,
 	.reset_resume = uas_reset_resume,
+	.soft_unbind = 1,
 	.shutdown = uas_shutdown,
 	.id_table = uas_usb_ids,
 };

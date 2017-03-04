From: Stephen Hemminger <stephen@networkplumber.org>
Subject: [RFC] hv_storvsc: error handling.
Date: Fri, 3 Mar 2017 16:50:11 -0800
Message-ID: <20170303165011.53a38794@xeon-e3>
References: <c1949de0-8b95-e254-1bec-bcdae762890f@kernel.dk>
        <1488301573.3046.9.camel@linux.vnet.ibm.com>
        <20170228105741.6253bb8a@xeon-e3>
        <1488325732.11610.9.camel@linux.vnet.ibm.com>
        <20170228172532.280811ed@xeon-e3>
        <1488349258.20321.11.camel@linux.vnet.ibm.com>
        <20170228224845.1da358ee@xeon-e3>
        <20170301155057.GA13167@lst.de>
        <20170301075412.2e5f1e98@xeon-e3>
        <20170302000135.GA22886@lst.de>
        <20170302005615.GA23687@lst.de>
        <20170301174058.383da142@xeon-e3>
        <c8ff2b64-2421-ca45-1f89-afec0490c8b3@suse.de>
        <20170302102324.47dbe3ad@xeon-e3>
        <895c4f2e-7faa-41e1-b5de-eedb4ae0f882@email.android.com>
        <20170302110505.6ad2eb61@xeon-e3>
        <1b325703-b823-4304-9d9d-86071811e000@email.android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f51.google.com ([74.125.83.51]:33493 "EHLO
        mail-pg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751584AbdCDAvN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2017 19:51:13 -0500
Received: by mail-pg0-f51.google.com with SMTP id 25so49056898pgy.0
        for <linux-scsi@vger.kernel.org>; Fri, 03 Mar 2017 16:50:19 -0800 (PST)
In-Reply-To: <1b325703-b823-4304-9d9d-86071811e000@email.android.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@Hansenpartnership.com>
Cc: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, James Bottomley <jejb@linux.vnet.ibm.com>, Jens Axboe <axboe@kernel.dk>, Linus Torvalds <torvalds@linux-foundation.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "K. Y. Srinivasan" <kys@microsoft.com>, Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>, Josh Poulson <jopoulso@microsoft.com>, v-adsuho@microsoft.com, linux-scsi@vger.kernel.org, Haiyang Zhang <haiyangz@microsoft.com>

Needs more testing but this does fix the observed problem.

From: Stephen Hemminger <sthemmin@microsoft.com>

Subject: [PATCH] hv_storvsc: fix error handling

The Hyper-V storvsc SCSI driver was hiding all errors in INQUIRY and
MODE_SENSE commands. This caused the scan process to incorrectly think
devices were present and online.  Also invalid LUN errors were not
being handled correctly.

This fixes problems booting a GEN2 VM on Hyper-V. It effectively
reverts commit 4ed51a21c0f69 ("Staging: hv: storvsc: Fixup
srb and scsi status for INQUIRY and MODE_SENSE")

Signed-off-by: Stephen Hemminger <sthemmin@microsoft.com>
---
 drivers/scsi/storvsc_drv.c | 48 ++++------------------------------------------
 1 file changed, 4 insertions(+), 44 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 638e5f427c90..8cc241fc54b8 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -543,28 +543,6 @@ static void storvsc_host_scan(struct work_struct *work)
 	kfree(wrk);
 }
 
-static void storvsc_remove_lun(struct work_struct *work)
-{
-	struct storvsc_scan_work *wrk;
-	struct scsi_device *sdev;
-
-	wrk = container_of(work, struct storvsc_scan_work, work);
-	if (!scsi_host_get(wrk->host))
-		goto done;
-
-	sdev = scsi_device_lookup(wrk->host, 0, wrk->tgt_id, wrk->lun);
-
-	if (sdev) {
-		scsi_remove_device(sdev);
-		scsi_device_put(sdev);
-	}
-	scsi_host_put(wrk->host);
-
-done:
-	kfree(wrk);
-}
-
-
 /*
  * We can get incoming messages from the host that are not in response to
  * messages that we have sent out. An example of this would be messages
@@ -955,8 +933,7 @@ static void storvsc_handle_error(struct vmscsi_request *vm_srb,
 		}
 		break;
 	case SRB_STATUS_INVALID_LUN:
-		do_work = true;
-		process_err_fn = storvsc_remove_lun;
+		set_host_byte(scmnd, DID_NO_CONNECT);
 		break;
 	case SRB_STATUS_ABORTED:
 		if (vm_srb->srb_status & SRB_STATUS_AUTOSENSE_VALID &&
@@ -1050,32 +1027,15 @@ static void storvsc_on_io_completion(struct storvsc_device *stor_device,
 
 	stor_pkt = &request->vstor_packet;
 
-	/*
-	 * The current SCSI handling on the host side does
-	 * not correctly handle:
-	 * INQUIRY command with page code parameter set to 0x80
-	 * MODE_SENSE command with cmd[2] == 0x1c
-	 *
-	 * Setup srb and scsi status so this won't be fatal.
-	 * We do this so we can distinguish truly fatal failues
-	 * (srb status == 0x4) and off-line the device in that case.
-	 */
-
-	if ((stor_pkt->vm_srb.cdb[0] == INQUIRY) ||
-	   (stor_pkt->vm_srb.cdb[0] == MODE_SENSE)) {
-		vstor_packet->vm_srb.scsi_status = 0;
-		vstor_packet->vm_srb.srb_status = SRB_STATUS_SUCCESS;
-	}
-
-
 	/* Copy over the status...etc */
 	stor_pkt->vm_srb.scsi_status = vstor_packet->vm_srb.scsi_status;
 	stor_pkt->vm_srb.srb_status = vstor_packet->vm_srb.srb_status;
 	stor_pkt->vm_srb.sense_info_length =
 	vstor_packet->vm_srb.sense_info_length;
 
-	if (vstor_packet->vm_srb.scsi_status != 0 ||
-	    vstor_packet->vm_srb.srb_status != SRB_STATUS_SUCCESS)
+	if (stor_pkt->vm_srb.cdb[0] != INQUIRY &&
+	    (vstor_packet->vm_srb.scsi_status != 0 ||
+	     vstor_packet->vm_srb.srb_status != SRB_STATUS_SUCCESS))
 		storvsc_log(device, STORVSC_LOGGING_WARN,
 			"cmd 0x%x scsi status 0x%x srb status 0x%x\n",
 			stor_pkt->vm_srb.cdb[0],
-- 
2.11.0

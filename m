From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 5/6] mptsas : FW event thread and scsi mid layer deadlock in SYNCHRONIZE CACHE command
Date: Wed, 2 Sep 2009 11:46:33 +0530
Message-ID: <20090902061622.GF20211@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og113.obsmtp.com ([64.18.2.179]:59714 "EHLO
	exprod7og113.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932179AbZIBGiv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Sep 2009 02:38:51 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


Normally In HBA reset path MPT driver will flush existing work in current work
queue (mpt/0) . This is just a dummy activity for MPT driver point of
view, since HBA reset will turn off Work queue events.

It means we will simply returns from work queue without doing anything.
But for the case where Work is already done (half the way), we have to have
that work to be done.

Considering above condition we stuck forever since Deadlock in scsi midlayer
and MPT driver. sd_sync_cache() will wait forever since HBA is not in
Running state, and it will never come into Running state since
sd_sync_cache() is called from HBA reset context.
Now new code will not wait for half cooked work to be finished
before returning from HBA reset.

Once we are out of HBA reset, EH thread will change host state to running from
recovery and work waiting for running state of HBA will be finished.
New code is turning ON firmware event from another special work called
Rescan toplogy.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 02a18df..83873e3 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -325,7 +325,6 @@ mptsas_cleanup_fw_event_q(MPT_ADAPTER *ioc)
 {
 	struct fw_event_work *fw_event, *next;
 	struct mptsas_target_reset_event *target_reset_list, *n;
-	u8	flush_q;
 	MPT_SCSI_HOST	*hd = shost_priv(ioc->sh);
 
 	/* flush the target_reset_list */
@@ -345,15 +344,10 @@ mptsas_cleanup_fw_event_q(MPT_ADAPTER *ioc)
 	     !ioc->fw_event_q || in_interrupt())
 		return;
 
-	flush_q = 0;
 	list_for_each_entry_safe(fw_event, next, &ioc->fw_event_list, list) {
 		if (cancel_delayed_work(&fw_event->work))
 			mptsas_free_fw_event(ioc, fw_event);
-		else
-			flush_q = 1;
 	}
-	if (flush_q)
-		flush_workqueue(ioc->fw_event_q);
 }
 
 
@@ -1279,7 +1273,6 @@ mptsas_ioc_reset(MPT_ADAPTER *ioc, int reset_phase)
 		}
 		mptsas_cleanup_fw_event_q(ioc);
 		mptsas_queue_rescan(ioc);
-		mptsas_fw_event_on(ioc);
 		break;
 	default:
 		break;
@@ -1599,6 +1592,7 @@ mptsas_firmware_event_work(struct work_struct *work)
 		mptsas_scan_sas_topology(ioc);
 		ioc->in_rescan = 0;
 		mptsas_free_fw_event(ioc, fw_event);
+		mptsas_fw_event_on(ioc);
 		return;
 	}
 

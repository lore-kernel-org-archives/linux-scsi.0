From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 0/17] mpt fusion: Submission of reviewed patch once
 again for [2.6.30-rc6]
Date: Tue, 09 Jun 2009 23:01:01 +0000
Message-ID: <1244588461.12321.161.camel@mulgrave.site>
References: <20090529110454.GA10181@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:48252 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752216AbZFIXBE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Jun 2009 19:01:04 -0400
In-Reply-To: <20090529110454.GA10181@lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Kashyap, Desai" <kashyap.desai@lsi.com>
Cc: linux-scsi@vger.kernel.org, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

On Fri, 2009-05-29 at 16:34 +0530, Kashyap, Desai wrote:
> Resending all pending mpt fusion patch based on 2.6.30-rc6 version.
> Applying previous patches were giving "hunk failed" errors.
> Now patches are synced with latest 2.6.30-rc6 kernel.
> 
> Included all comments pointed by James B in previous submission.
> There are not logical changes in this patches.

Actually, there are, but I elided patches 4 deleting uses of
mpt_timer_expired and 5 which actually deletes it.

There were also several commented on docbook required fixes outstanding.
I just bundled them up into this patch, and will apply it at the end
(can't be bothered to fix up each individual patch).

So you don't need to do anything: the mptfusion patch series should be
in scsi-misc.

James

---

diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 88a1a6d..7888b40 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -636,8 +636,7 @@ mptsas_add_device_component_by_fw(MPT_ADAPTER *ioc, u8 channel, u8 id)
 }
 
 /**
- *	mptsas_add_device_component_starget_ir - Handle Integrated RAID, adding
- *	each individual device to list
+ *	mptsas_add_device_component_starget_ir - Handle Integrated RAID, adding each individual device to list
  *	@ioc: Pointer to MPT_ADAPTER structure
  *	@channel: fw mapped id's
  *	@id:
@@ -776,8 +775,7 @@ mptsas_add_device_component_starget(MPT_ADAPTER *ioc,
 }
 
 /**
- *	mptsas_del_device_component_by_os - Once a device has been removed, we
- *	mark the entry in the list as being cached
+ *	mptsas_del_device_component_by_os - Once a device has been removed, we mark the entry in the list as being cached
  *	@ioc: Pointer to MPT_ADAPTER structure
  *	@channel: os mapped id's
  *	@id:
@@ -1125,11 +1123,12 @@ mptsas_target_reset_queue(MPT_ADAPTER *ioc,
 }
 
 /**
- *	mptsas_taskmgmt_complete - Completion for TARGET_RESET after
- *	NOT_RESPONDING_EVENT, enable work queue to finish off removing device
- *	from upper layers. then send next TARGET_RESET in the queue.
+ *	mptsas_taskmgmt_complete - complete SAS task management function 
  *	@ioc: Pointer to MPT_ADAPTER structure
  *
+ *	Completion for TARGET_RESET after NOT_RESPONDING_EVENT, enable work
+ *	queue to finish off removing device from upper layers. then send next
+ *	TARGET_RESET in the queue.
  **/
 static int
 mptsas_taskmgmt_complete(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *mr)
@@ -1441,8 +1440,7 @@ mptsas_add_end_device(MPT_ADAPTER *ioc, struct mptsas_phyinfo *phy_info)
 }
 
 /**
- *	mptsas_del_end_device - report a deleted end device to sas transport
- *	layer
+ *	mptsas_del_end_device - report a deleted end device to sas transport layer
  *	@ioc: Pointer to MPT_ADAPTER structure
  *	@phy_info: decribes attached device
  *
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index 9668120..024e830 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -2442,10 +2442,7 @@ mptscsih_get_scsi_lookup(MPT_ADAPTER *ioc, int i)
 EXPORT_SYMBOL(mptscsih_get_scsi_lookup);
 
 /**
- * mptscsih_getclear_scsi_lookup
- *
- * retrieves and clears scmd entry from ScsiLookup[] array list
- *
+ * mptscsih_getclear_scsi_lookup -  retrieves and clears scmd entry from ScsiLookup[] array list
  * @ioc: Pointer to MPT_ADAPTER structure
  * @i: index into the array
  *



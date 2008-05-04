From: Matthias Kaehlcke <matthias@kaehlcke.net>
Subject: [PATCH] Fusion MPT: Convert inactive_list_mutex in a mutex
Date: Sun, 4 May 2008 20:05:44 +0200
Message-ID: <20080504180544.GN20036@traven>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.riseup.net ([204.13.164.18]:57228 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753854AbYEDSYB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 4 May 2008 14:24:01 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric.Moore@lsi.com, support@lsi.com, DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org

MPT Fusion: The semaphore inactive_list_mutex is used as a
mutex. Convert it to the mutex API

Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>

--

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 0c303c8..06557f2 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -2136,7 +2136,7 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u32 reason, int sleepFlag)
 		/*
 		 * Initalize link list for inactive raid volumes.
 		 */
-		init_MUTEX(&ioc->raid_data.inactive_list_mutex);
+		mutex_init(&ioc->raid_data.inactive_list_mutex);
 		INIT_LIST_HEAD(&ioc->raid_data.inactive_list);
 
 		if (ioc->bus_type == SAS) {
@@ -5122,13 +5122,13 @@ mpt_inactive_raid_list_free(MPT_ADAPTER *ioc)
 	if (list_empty(&ioc->raid_data.inactive_list))
 		return;
 
-	down(&ioc->raid_data.inactive_list_mutex);
+	mutex_lock(&ioc->raid_data.inactive_list_mutex);
 	list_for_each_entry_safe(component_info, pNext,
 	    &ioc->raid_data.inactive_list, list) {
 		list_del(&component_info->list);
 		kfree(component_info);
 	}
-	up(&ioc->raid_data.inactive_list_mutex);
+	mutex_unlock(&ioc->raid_data.inactive_list_mutex);
 }
 
 /**
@@ -5187,7 +5187,7 @@ mpt_inactive_raid_volumes(MPT_ADAPTER *ioc, u8 channel, u8 id)
 	if (!handle_inactive_volumes)
 		goto out;
 
-	down(&ioc->raid_data.inactive_list_mutex);
+	mutex_lock(&ioc->raid_data.inactive_list_mutex);
 	for (i = 0; i < buffer->NumPhysDisks; i++) {
 		if(mpt_raid_phys_disk_pg0(ioc,
 		    buffer->PhysDisk[i].PhysDiskNum, &phys_disk) != 0)
@@ -5207,7 +5207,7 @@ mpt_inactive_raid_volumes(MPT_ADAPTER *ioc, u8 channel, u8 id)
 		list_add_tail(&component_info->list,
 		    &ioc->raid_data.inactive_list);
 	}
-	up(&ioc->raid_data.inactive_list_mutex);
+	mutex_unlock(&ioc->raid_data.inactive_list_mutex);
 
  out:
 	if (buffer)
diff --git a/drivers/message/fusion/mptbase.h b/drivers/message/fusion/mptbase.h
index caadc68..4190e88 100644
--- a/drivers/message/fusion/mptbase.h
+++ b/drivers/message/fusion/mptbase.h
@@ -531,7 +531,7 @@ struct inactive_raid_component_info {
 typedef	struct _RaidCfgData {
 	IOCPage2_t	*pIocPg2;		/* table of Raid Volumes */
 	IOCPage3_t	*pIocPg3;		/* table of physical disks */
-	struct semaphore	inactive_list_mutex;
+	struct mutex	inactive_list_mutex;
 	struct list_head	inactive_list; /* link list for physical
 						disk that belong in
 						inactive volumes */
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index af1de0c..4e70ef4 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -2295,14 +2295,14 @@ mptscsih_is_phys_disk(MPT_ADAPTER *ioc, u8 channel, u8 id)
 	if (list_empty(&ioc->raid_data.inactive_list))
 		goto out;
 
-	down(&ioc->raid_data.inactive_list_mutex);
+	mutex_lock(&ioc->raid_data.inactive_list_mutex);
 	list_for_each_entry(component_info, &ioc->raid_data.inactive_list,
 	    list) {
 		if ((component_info->d.PhysDiskID == id) &&
 		    (component_info->d.PhysDiskBus == channel))
 			rc = 1;
 	}
-	up(&ioc->raid_data.inactive_list_mutex);
+	mutex_unlock(&ioc->raid_data.inactive_list_mutex);
 
  out:
 	return rc;
@@ -2332,14 +2332,14 @@ mptscsih_raid_id_to_num(MPT_ADAPTER *ioc, u8 channel, u8 id)
 	if (list_empty(&ioc->raid_data.inactive_list))
 		goto out;
 
-	down(&ioc->raid_data.inactive_list_mutex);
+	mutex_lock(&ioc->raid_data.inactive_list_mutex);
 	list_for_each_entry(component_info, &ioc->raid_data.inactive_list,
 	    list) {
 		if ((component_info->d.PhysDiskID == id) &&
 		    (component_info->d.PhysDiskBus == channel))
 			rc = component_info->d.PhysDiskNum;
 	}
-	up(&ioc->raid_data.inactive_list_mutex);
+	mutex_unlock(&ioc->raid_data.inactive_list_mutex);
 
  out:
 	return rc;

-- 
Matthias Kaehlcke
Embedded Linux Engineer
Barcelona


   Usually when people are sad, they don't do anything. They just cry over
     their condition. But when they get angry, they bring about a change
                              (Malcolm X)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-

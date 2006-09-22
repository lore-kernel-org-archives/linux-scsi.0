From: martin.wilck@fujitsu-siemens.com
Subject: [PATCH] scsi/mptsas: add RAID devices in ascending ID order
Date: Fri, 22 Sep 2006 16:57:39 +0200
Message-ID: <4513F9E3.mailNQ511V9QA@fujitsu-siemens.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dgate1.fujitsu-siemens.com ([217.115.66.35]:65362 "EHLO
	dgate1.fujitsu-siemens.com") by vger.kernel.org with ESMTP
	id S932546AbWIVO5l (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Sep 2006 10:57:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric.Moore@lsil.com
Cc: martin.wilck@fujitsu-siemens.com, linux-scsi@vger.kernel.org, mpt_linux_developer@lsil.com

From: Martin Wilck <Martin.Wilck@fujitsu-siemens.com>

    [SCSI] mptsas: add RAID devices in ascending ID order
    
    This patch fixes the order in which mptsas registers
    RAID devices with the SCSI mid layer. The VolumeID field
    is not in ascending order. This leads to situations where
    e.g. device 2:8:2:0 is registered before 2:8:0:0.
    
    That may lead to an unbootable system e.g. if a user installs
    on a two-disk RAID1 array and adds another 2-disk RAID1 later
    (the new array will be detected as sda, the old one as sdb).
    
    The patch makes sure that arrays are added in ascending
    VolumeID order.

Signed-off-by: Martin Wilck <Martin.Wilck@fujitsu-siemens.com>

diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index b752a47..3f01f03 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -1962,6 +1962,7 @@ mptsas_scan_sas_topology(MPT_ADAPTER *io
 {
 	u32 handle = 0xFFFF;
 	int i;
+	int last_added_id;
 
 	mutex_lock(&ioc->sas_discovery_mutex);
 	mptsas_probe_hba_phys(ioc);
@@ -1974,9 +1975,24 @@ mptsas_scan_sas_topology(MPT_ADAPTER *io
 		goto out;
 	if (!ioc->raid_data.pIocPg2->NumActiveVolumes)
 		goto out;
-	for (i=0; i<ioc->raid_data.pIocPg2->NumActiveVolumes; i++) {
+
+	/* Add logical volumes in the usual SCSI scan sequence (ascending VolumeID) */
+	for (last_added_id = -1;;) {
+		int idx = -1;
+		int smallest_id = 256; /* VolumeID is u8 */
+
+		for (i=0; i<ioc->raid_data.pIocPg2->NumActiveVolumes; i++) {
+			int id = ioc->raid_data.pIocPg2->RaidVolume[i].VolumeID;
+			if (id > last_added_id && id < smallest_id) {
+				smallest_id = id;
+				idx = i;
+			}
+		}
+		if (idx == -1)
+			break;
+		last_added_id = smallest_id;
 		scsi_add_device(ioc->sh, MPTSAS_RAID_CHANNEL,
-		    ioc->raid_data.pIocPg2->RaidVolume[i].VolumeID, 0);
+		    ioc->raid_data.pIocPg2->RaidVolume[idx].VolumeID, 0);
 	}
  out:
 	mutex_unlock(&ioc->sas_discovery_mutex);

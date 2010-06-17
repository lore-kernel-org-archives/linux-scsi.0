From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 13/17] mpt2sas: Add additional check for responding volumes after Host Reset
Date: Thu, 17 Jun 2010 13:48:10 +0530
Message-ID: <20100617081810.GN28921@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:40166 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932663Ab0FQIxq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jun 2010 04:53:46 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Eric.Moore@lsi.com, James.Bottomley@HansenPartnership.com, Sathya.Prakash@lsi.com

ISSUE DESCRIPTION:
This test case involves creating two RAID1 volumes,  then
simultaneiously issue host reset and pull all the drives associated to
the 1st raid volume.  The observed behavour is the physical drives are
removed, however the volume remains.   The expected behavour is the
volume as well as physical drives should be removed from OS.

FIX:
Add support in the post host reset device scan logic for raid volumes
where the driver will have an additional check for responding raid
volume where the status should be either online, optimal, or degraded.
So for voluemes that have a status of missing or failed, the driver
will mark them for deletion.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index b327d60..228961b 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -5952,6 +5952,7 @@ static void
 _scsih_search_responding_raid_devices(struct MPT2SAS_ADAPTER *ioc)
 {
 	Mpi2RaidVolPage1_t volume_pg1;
+	Mpi2RaidVolPage0_t volume_pg0;
 	Mpi2RaidPhysDiskPage0_t pd_pg0;
 	Mpi2ConfigReply_t mpi_reply;
 	u16 ioc_status;
@@ -5971,8 +5972,17 @@ _scsih_search_responding_raid_devices(struct MPT2SAS_ADAPTER *ioc)
 		if (ioc_status == MPI2_IOCSTATUS_CONFIG_INVALID_PAGE)
 			break;
 		handle = le16_to_cpu(volume_pg1.DevHandle);
-		_scsih_mark_responding_raid_device(ioc,
-		    le64_to_cpu(volume_pg1.WWID), handle);
+
+		if (mpt2sas_config_get_raid_volume_pg0(ioc, &mpi_reply,
+		    &volume_pg0, MPI2_RAID_VOLUME_PGAD_FORM_HANDLE, handle,
+		     sizeof(Mpi2RaidVolPage0_t)))
+			continue;
+
+		if (volume_pg0.VolumeState == MPI2_RAID_VOL_STATE_OPTIMAL ||
+		    volume_pg0.VolumeState == MPI2_RAID_VOL_STATE_ONLINE ||
+		    volume_pg0.VolumeState == MPI2_RAID_VOL_STATE_DEGRADED)
+			_scsih_mark_responding_raid_device(ioc,
+			    le64_to_cpu(volume_pg1.WWID), handle);
 	}
 
 	/* refresh the pd_handles */

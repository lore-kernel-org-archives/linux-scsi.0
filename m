From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 1/11] mpt2sas: [Resend] Power cycling cascaded expanders causes kernel panic
Date: Wed, 5 Aug 2009 11:13:10 +0530
Message-ID: <20090805054251.GB13733@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og107.obsmtp.com ([64.18.2.167]:43457 "EHLO
	exprod7og107.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754725AbZHEGEM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Aug 2009 02:04:12 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


Kernel panic is seen because of enclosure_handle received from FW is zero.
Check is introduced before calling mpt2sas_config_get_enclosure_pg0.
---

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
Signed-off-by: Eric Moore <Eric.moore@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 2a01a5f..b1326bf 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -3663,12 +3663,11 @@ _scsih_add_device(struct MPT2SAS_ADAPTER *ioc, u16 handle, u8 phy_num, u8 is_pd)
 	sas_device->hidden_raid_component = is_pd;
 
 	/* get enclosure_logical_id */
-	if (!(mpt2sas_config_get_enclosure_pg0(ioc, &mpi_reply, &enclosure_pg0,
-	   MPI2_SAS_ENCLOS_PGAD_FORM_HANDLE,
-	   sas_device->enclosure_handle))) {
+	if (sas_device->enclosure_handle && !(mpt2sas_config_get_enclosure_pg0(
+	   ioc, &mpi_reply, &enclosure_pg0, MPI2_SAS_ENCLOS_PGAD_FORM_HANDLE,
+	   sas_device->enclosure_handle)))
 		sas_device->enclosure_logical_id =
 		    le64_to_cpu(enclosure_pg0.EnclosureLogicalID);
-	}
 
 	/* get device name */
 	sas_device->device_name = le64_to_cpu(sas_device_pg0.DeviceName);

From: <nagalakshmi.nandigama@lsi.com>
Subject: RESEND [PATCH 04/10] mpt2sas: Fix for issue - Failure message
 displayed during diag reset
Date: Wed, 19 Oct 2011 15:36:47 +0530
Message-ID: <201110191612.p9JGCiDg026212@milmhbs0.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:49553 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751598Ab1JSQNL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Oct 2011 12:13:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, kashyap.desai@lsi.com, Nagalakshmi.Nandigama@lsi.com, Sathya.Prakash@lsi.com, Eric.Moore@lsi.com
Cc: JBottomley@parallels.com

Fix for the issue - Failure message displayed during diag reset.

The fix is to inhibit the warning message in _scsih_get_sas_address
when the MPI2_IOCSTATUS_CONFIG_INVALID_PAGE ioc status is returned.

Signed-off-by: Nagalakshmi Nandigama <nagalakshmi.nandigama@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 849fa84..deb9791 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -388,31 +388,34 @@ _scsih_get_sas_address(struct MPT2SAS_ADAPTER *ioc, u16 handle,
 	Mpi2SasDevicePage0_t sas_device_pg0;
 	Mpi2ConfigReply_t mpi_reply;
 	u32 ioc_status;
+	*sas_address = 0;
 
 	if (handle <= ioc->sas_hba.num_phys) {
 		*sas_address = ioc->sas_hba.sas_address;
 		return 0;
-	} else
-		*sas_address = 0;
+	}
 
 	if ((mpt2sas_config_get_sas_device_pg0(ioc, &mpi_reply, &sas_device_pg0,
 	    MPI2_SAS_DEVICE_PGAD_FORM_HANDLE, handle))) {
-		printk(MPT2SAS_ERR_FMT "failure at %s:%d/%s()!\n",
-		    ioc->name, __FILE__, __LINE__, __func__);
+		printk(MPT2SAS_ERR_FMT "failure at %s:%d/%s()!\n", ioc->name,
+		__FILE__, __LINE__, __func__);
 		return -ENXIO;
 	}
 
-	ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
-	    MPI2_IOCSTATUS_MASK;
-	if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
-		printk(MPT2SAS_ERR_FMT "handle(0x%04x), ioc_status(0x%04x)"
-		    "\nfailure at %s:%d/%s()!\n", ioc->name, handle, ioc_status,
-		     __FILE__, __LINE__, __func__);
-		return -EIO;
+	ioc_status = le16_to_cpu(mpi_reply.IOCStatus) & MPI2_IOCSTATUS_MASK;
+	if (ioc_status == MPI2_IOCSTATUS_SUCCESS) {
+		*sas_address = le64_to_cpu(sas_device_pg0.SASAddress);
+		return 0;
 	}
 
-	*sas_address = le64_to_cpu(sas_device_pg0.SASAddress);
-	return 0;
+	/* we hit this becuase the given parent handle doesn't exist */
+	if (ioc_status == MPI2_IOCSTATUS_CONFIG_INVALID_PAGE)
+		return -ENXIO;
+	/* else error case */
+	printk(MPT2SAS_ERR_FMT "handle(0x%04x), ioc_status(0x%04x), "
+	    "failure at %s:%d/%s()!\n", ioc->name, handle, ioc_status,
+	     __FILE__, __LINE__, __func__);
+	return -EIO;
 }
 
 /**

From: Alex Shi <alex.shi@intel.com>
Subject: [PATCH] scsi/mpt2sas: fix unsafe preempt setting for ioc
Date: Mon, 26 Mar 2012 14:20:10 +0800
Message-ID: <1332742810-5116-1-git-send-email-alex.shi@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:49390 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753805Ab2CZGVX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Mar 2012 02:21:23 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: Nagalakshmi.Nandigama@lsi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

commit 911ae943 add a new function:
+_base_get_msix_index(struct MPT2SAS_ADAPTER *ioc)
+{
+       return ioc->cpu_msix_table[smp_processor_id()];
+}
Here smp_processor_id() need be used in preempt safe condition. but
caller did not give this assurance. So fix this in caller.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 drivers/scsi/mpt2sas/mpt2sas_base.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index a78036f..55a368e 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -1803,6 +1803,7 @@ mpt2sas_base_put_smid_scsi_io(struct MPT2SAS_ADAPTER *ioc, u16 smid, u16 handle)
 	u64 *request = (u64 *)&descriptor;
 
 
+	preempt_disable();
 	descriptor.SCSIIO.RequestFlags = MPI2_REQ_DESCRIPT_FLAGS_SCSI_IO;
 	descriptor.SCSIIO.MSIxIndex =  _base_get_msix_index(ioc);
 	descriptor.SCSIIO.SMID = cpu_to_le16(smid);
@@ -1810,6 +1811,7 @@ mpt2sas_base_put_smid_scsi_io(struct MPT2SAS_ADAPTER *ioc, u16 smid, u16 handle)
 	descriptor.SCSIIO.LMID = 0;
 	_base_writeq(*request, &ioc->chip->RequestDescriptorPostLow,
 	    &ioc->scsi_lookup_lock);
+	preempt_enable();
 }
 
 
@@ -1849,6 +1851,7 @@ mpt2sas_base_put_smid_default(struct MPT2SAS_ADAPTER *ioc, u16 smid)
 	Mpi2RequestDescriptorUnion_t descriptor;
 	u64 *request = (u64 *)&descriptor;
 
+	preempt_disable();
 	descriptor.Default.RequestFlags = MPI2_REQ_DESCRIPT_FLAGS_DEFAULT_TYPE;
 	descriptor.Default.MSIxIndex =  _base_get_msix_index(ioc);
 	descriptor.Default.SMID = cpu_to_le16(smid);
@@ -1856,6 +1859,7 @@ mpt2sas_base_put_smid_default(struct MPT2SAS_ADAPTER *ioc, u16 smid)
 	descriptor.Default.DescriptorTypeDependent = 0;
 	_base_writeq(*request, &ioc->chip->RequestDescriptorPostLow,
 	    &ioc->scsi_lookup_lock);
+	preempt_enable();
 }
 
 /**
@@ -1873,6 +1877,7 @@ mpt2sas_base_put_smid_target_assist(struct MPT2SAS_ADAPTER *ioc, u16 smid,
 	Mpi2RequestDescriptorUnion_t descriptor;
 	u64 *request = (u64 *)&descriptor;
 
+	preempt_disable();
 	descriptor.SCSITarget.RequestFlags =
 	    MPI2_REQ_DESCRIPT_FLAGS_SCSI_TARGET;
 	descriptor.SCSITarget.MSIxIndex =  _base_get_msix_index(ioc);
@@ -1881,6 +1886,7 @@ mpt2sas_base_put_smid_target_assist(struct MPT2SAS_ADAPTER *ioc, u16 smid,
 	descriptor.SCSITarget.IoIndex = cpu_to_le16(io_index);
 	_base_writeq(*request, &ioc->chip->RequestDescriptorPostLow,
 	    &ioc->scsi_lookup_lock);
+	preempt_enable();
 }
 
 /**
-- 
1.7.5.4


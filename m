From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 4/9] mpt2sas: Config request and diag reset deadlock
Date: Fri, 7 Aug 2009 19:36:00 +0530
Message-ID: <20090807140552.GE5807@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og108.obsmtp.com ([64.18.2.169]:42454 "EHLO
	exprod7og108.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757399AbZHGO2H (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Aug 2009 10:28:07 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com, stable@kernel.org

Moving the setting and clearing of the mutex's to
_config_request. There was a mutex deadlock when diag reset is called from
inside _config_request, so diag reset was moved to outside the mutexs.
---

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
Signed-off-by: Eric Moore <Eric.moore@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_config.c b/drivers/scsi/mpt2sas/mpt2sas_config.c
index 7e7843f..a18b80e 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_config.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_config.c
@@ -236,12 +236,14 @@ _config_request(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigRequest_t
 	Mpi2ConfigRequest_t *config_request;
 	int r;
 	u8 retry_count;
-	u8 issue_reset;
+	u8 issue_host_reset = 0;
 	u16 wait_state_count;
 
+	mutex_lock(&ioc->config_cmds.mutex);
 	if (ioc->config_cmds.status != MPT2_CMD_NOT_USED) {
 		printk(MPT2SAS_ERR_FMT "%s: config_cmd in use\n",
 		    ioc->name, __func__);
+		mutex_unlock(&ioc->config_cmds.mutex);
 		return -EAGAIN;
 	}
 	retry_count = 0;
@@ -254,8 +256,8 @@ _config_request(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigRequest_t
 			printk(MPT2SAS_ERR_FMT
 			    "%s: failed due to ioc not operational\n",
 			    ioc->name, __func__);
-			ioc->config_cmds.status = MPT2_CMD_NOT_USED;
-			return -EFAULT;
+			r = -EFAULT;
+			goto out;
 		}
 		ssleep(1);
 		ioc_state = mpt2sas_base_get_iocstate(ioc, 1);
@@ -271,8 +273,8 @@ _config_request(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigRequest_t
 	if (!smid) {
 		printk(MPT2SAS_ERR_FMT "%s: failed obtaining a smid\n",
 		    ioc->name, __func__);
-		ioc->config_cmds.status = MPT2_CMD_NOT_USED;
-		return -EAGAIN;
+		r = -EAGAIN;
+		goto out;
 	}
 
 	r = 0;
@@ -292,9 +294,15 @@ _config_request(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigRequest_t
 		    ioc->name, __func__);
 		_debug_dump_mf(mpi_request,
 		    sizeof(Mpi2ConfigRequest_t)/4);
-		if (!(ioc->config_cmds.status & MPT2_CMD_RESET))
-			issue_reset = 1;
-		goto issue_host_reset;
+		retry_count++;
+		if (ioc->config_cmds.smid == smid)
+			mpt2sas_base_free_smid(ioc, smid);
+		if ((ioc->shost_recovery) ||
+		    (ioc->config_cmds.status & MPT2_CMD_RESET))
+			goto retry_config;
+		issue_host_reset = 1;
+		r = -EFAULT;
+		goto out;
 	}
 	if (ioc->config_cmds.status & MPT2_CMD_REPLY_VALID)
 		memcpy(mpi_reply, ioc->config_cmds.reply,
@@ -302,21 +310,13 @@ _config_request(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigRequest_t
 	if (retry_count)
 		printk(MPT2SAS_INFO_FMT "%s: retry completed!!\n",
 		    ioc->name, __func__);
+out:
 	ioc->config_cmds.status = MPT2_CMD_NOT_USED;
-	return r;
-
- issue_host_reset:
-	if (issue_reset)
+	mutex_unlock(&ioc->config_cmds.mutex);
+	if (issue_host_reset)
 		mpt2sas_base_hard_reset_handler(ioc, CAN_SLEEP,
 		    FORCE_BIG_HAMMER);
-	ioc->config_cmds.status = MPT2_CMD_NOT_USED;
-	if (!retry_count) {
-		printk(MPT2SAS_INFO_FMT "%s: attempting retry\n",
-		    ioc->name, __func__);
-		retry_count++;
-		goto retry_config;
-	}
-	return -EFAULT;
+	return r;
 }
 
 /**
@@ -375,7 +375,6 @@ mpt2sas_config_get_manufacturing_pg0(struct MPT2SAS_ADAPTER *ioc,
 	int r;
 	struct config_request mem;
 
-	mutex_lock(&ioc->config_cmds.mutex);
 	memset(config_page, 0, sizeof(Mpi2ManufacturingPage0_t));
 	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
 	mpi_request.Function = MPI2_FUNCTION_CONFIG;
@@ -417,7 +416,6 @@ mpt2sas_config_get_manufacturing_pg0(struct MPT2SAS_ADAPTER *ioc,
 		_config_free_config_dma_memory(ioc, &mem);
 
  out:
-	mutex_unlock(&ioc->config_cmds.mutex);
 	return r;
 }
 
@@ -438,7 +436,6 @@ mpt2sas_config_get_bios_pg2(struct MPT2SAS_ADAPTER *ioc,
 	int r;
 	struct config_request mem;
 
-	mutex_lock(&ioc->config_cmds.mutex);
 	memset(config_page, 0, sizeof(Mpi2BiosPage2_t));
 	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
 	mpi_request.Function = MPI2_FUNCTION_CONFIG;
@@ -480,7 +477,6 @@ mpt2sas_config_get_bios_pg2(struct MPT2SAS_ADAPTER *ioc,
 		_config_free_config_dma_memory(ioc, &mem);
 
  out:
-	mutex_unlock(&ioc->config_cmds.mutex);
 	return r;
 }
 
@@ -501,7 +497,6 @@ mpt2sas_config_get_bios_pg3(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigReply_t
 	int r;
 	struct config_request mem;
 
-	mutex_lock(&ioc->config_cmds.mutex);
 	memset(config_page, 0, sizeof(Mpi2BiosPage3_t));
 	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
 	mpi_request.Function = MPI2_FUNCTION_CONFIG;
@@ -543,7 +538,6 @@ mpt2sas_config_get_bios_pg3(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigReply_t
 		_config_free_config_dma_memory(ioc, &mem);
 
  out:
-	mutex_unlock(&ioc->config_cmds.mutex);
 	return r;
 }
 
@@ -564,7 +558,6 @@ mpt2sas_config_get_iounit_pg0(struct MPT2SAS_ADAPTER *ioc,
 	int r;
 	struct config_request mem;
 
-	mutex_lock(&ioc->config_cmds.mutex);
 	memset(config_page, 0, sizeof(Mpi2IOUnitPage0_t));
 	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
 	mpi_request.Function = MPI2_FUNCTION_CONFIG;
@@ -606,7 +599,6 @@ mpt2sas_config_get_iounit_pg0(struct MPT2SAS_ADAPTER *ioc,
 		_config_free_config_dma_memory(ioc, &mem);
 
  out:
-	mutex_unlock(&ioc->config_cmds.mutex);
 	return r;
 }
 
@@ -627,7 +619,6 @@ mpt2sas_config_get_iounit_pg1(struct MPT2SAS_ADAPTER *ioc,
 	int r;
 	struct config_request mem;
 
-	mutex_lock(&ioc->config_cmds.mutex);
 	memset(config_page, 0, sizeof(Mpi2IOUnitPage1_t));
 	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
 	mpi_request.Function = MPI2_FUNCTION_CONFIG;
@@ -669,7 +660,6 @@ mpt2sas_config_get_iounit_pg1(struct MPT2SAS_ADAPTER *ioc,
 		_config_free_config_dma_memory(ioc, &mem);
 
  out:
-	mutex_unlock(&ioc->config_cmds.mutex);
 	return r;
 }
 
@@ -690,7 +680,6 @@ mpt2sas_config_set_iounit_pg1(struct MPT2SAS_ADAPTER *ioc,
 	int r;
 	struct config_request mem;
 
-	mutex_lock(&ioc->config_cmds.mutex);
 	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
 	mpi_request.Function = MPI2_FUNCTION_CONFIG;
 	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_HEADER;
@@ -732,7 +721,6 @@ mpt2sas_config_set_iounit_pg1(struct MPT2SAS_ADAPTER *ioc,
 		_config_free_config_dma_memory(ioc, &mem);
 
  out:
-	mutex_unlock(&ioc->config_cmds.mutex);
 	return r;
 }
 
@@ -753,7 +741,6 @@ mpt2sas_config_get_ioc_pg8(struct MPT2SAS_ADAPTER *ioc,
 	int r;
 	struct config_request mem;
 
-	mutex_lock(&ioc->config_cmds.mutex);
 	memset(config_page, 0, sizeof(Mpi2IOCPage8_t));
 	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
 	mpi_request.Function = MPI2_FUNCTION_CONFIG;
@@ -795,7 +782,6 @@ mpt2sas_config_get_ioc_pg8(struct MPT2SAS_ADAPTER *ioc,
 		_config_free_config_dma_memory(ioc, &mem);
 
  out:
-	mutex_unlock(&ioc->config_cmds.mutex);
 	return r;
 }
 
@@ -818,7 +804,6 @@ mpt2sas_config_get_sas_device_pg0(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigReply_t
 	int r;
 	struct config_request mem;
 
-	mutex_lock(&ioc->config_cmds.mutex);
 	memset(config_page, 0, sizeof(Mpi2SasDevicePage0_t));
 	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
 	mpi_request.Function = MPI2_FUNCTION_CONFIG;
@@ -863,7 +848,6 @@ mpt2sas_config_get_sas_device_pg0(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigReply_t
 		_config_free_config_dma_memory(ioc, &mem);
 
  out:
-	mutex_unlock(&ioc->config_cmds.mutex);
 	return r;
 }
 
@@ -886,7 +870,6 @@ mpt2sas_config_get_sas_device_pg1(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigReply_t
 	int r;
 	struct config_request mem;
 
-	mutex_lock(&ioc->config_cmds.mutex);
 	memset(config_page, 0, sizeof(Mpi2SasDevicePage1_t));
 	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
 	mpi_request.Function = MPI2_FUNCTION_CONFIG;
@@ -931,7 +914,6 @@ mpt2sas_config_get_sas_device_pg1(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigReply_t
 		_config_free_config_dma_memory(ioc, &mem);
 
  out:
-	mutex_unlock(&ioc->config_cmds.mutex);
 	return r;
 }
 
@@ -953,7 +935,6 @@ mpt2sas_config_get_number_hba_phys(struct MPT2SAS_ADAPTER *ioc, u8 *num_phys)
 	Mpi2ConfigReply_t mpi_reply;
 	Mpi2SasIOUnitPage0_t config_page;
 
-	mutex_lock(&ioc->config_cmds.mutex);
 	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
 	mpi_request.Function = MPI2_FUNCTION_CONFIG;
 	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_HEADER;
@@ -1002,7 +983,6 @@ mpt2sas_config_get_number_hba_phys(struct MPT2SAS_ADAPTER *ioc, u8 *num_phys)
 		_config_free_config_dma_memory(ioc, &mem);
 
  out:
-	mutex_unlock(&ioc->config_cmds.mutex);
 	return r;
 }
 
@@ -1026,7 +1006,6 @@ mpt2sas_config_get_sas_iounit_pg0(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigReply_t
 	Mpi2ConfigRequest_t mpi_request;
 	int r;
 	struct config_request mem;
-	mutex_lock(&ioc->config_cmds.mutex);
 	memset(config_page, 0, sz);
 	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
 	mpi_request.Function = MPI2_FUNCTION_CONFIG;
@@ -1069,7 +1048,6 @@ mpt2sas_config_get_sas_iounit_pg0(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigReply_t
 		_config_free_config_dma_memory(ioc, &mem);
 
  out:
-	mutex_unlock(&ioc->config_cmds.mutex);
 	return r;
 }
 
@@ -1094,7 +1072,6 @@ mpt2sas_config_get_sas_iounit_pg1(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigReply_t
 	int r;
 	struct config_request mem;
 
-	mutex_lock(&ioc->config_cmds.mutex);
 	memset(config_page, 0, sz);
 	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
 	mpi_request.Function = MPI2_FUNCTION_CONFIG;
@@ -1137,7 +1114,6 @@ mpt2sas_config_get_sas_iounit_pg1(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigReply_t
 		_config_free_config_dma_memory(ioc, &mem);
 
  out:
-	mutex_unlock(&ioc->config_cmds.mutex);
 	return r;
 }
 
@@ -1160,7 +1136,6 @@ mpt2sas_config_get_expander_pg0(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigReply_t
 	int r;
 	struct config_request mem;
 
-	mutex_lock(&ioc->config_cmds.mutex);
 	memset(config_page, 0, sizeof(Mpi2ExpanderPage0_t));
 	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
 	mpi_request.Function = MPI2_FUNCTION_CONFIG;
@@ -1205,7 +1180,6 @@ mpt2sas_config_get_expander_pg0(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigReply_t
 		_config_free_config_dma_memory(ioc, &mem);
 
  out:
-	mutex_unlock(&ioc->config_cmds.mutex);
 	return r;
 }
 
@@ -1229,7 +1203,6 @@ mpt2sas_config_get_expander_pg1(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigReply_t
 	int r;
 	struct config_request mem;
 
-	mutex_lock(&ioc->config_cmds.mutex);
 	memset(config_page, 0, sizeof(Mpi2ExpanderPage1_t));
 	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
 	mpi_request.Function = MPI2_FUNCTION_CONFIG;
@@ -1276,7 +1249,6 @@ mpt2sas_config_get_expander_pg1(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigReply_t
 		_config_free_config_dma_memory(ioc, &mem);
 
  out:
-	mutex_unlock(&ioc->config_cmds.mutex);
 	return r;
 }
 
@@ -1299,7 +1271,6 @@ mpt2sas_config_get_enclosure_pg0(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigReply_t
 	int r;
 	struct config_request mem;
 
-	mutex_lock(&ioc->config_cmds.mutex);
 	memset(config_page, 0, sizeof(Mpi2SasEnclosurePage0_t));
 	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
 	mpi_request.Function = MPI2_FUNCTION_CONFIG;
@@ -1344,7 +1315,6 @@ mpt2sas_config_get_enclosure_pg0(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigReply_t
 		_config_free_config_dma_memory(ioc, &mem);
 
  out:
-	mutex_unlock(&ioc->config_cmds.mutex);
 	return r;
 }
 
@@ -1366,7 +1336,6 @@ mpt2sas_config_get_phy_pg0(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigReply_t
 	int r;
 	struct config_request mem;
 
-	mutex_lock(&ioc->config_cmds.mutex);
 	memset(config_page, 0, sizeof(Mpi2SasPhyPage0_t));
 	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
 	mpi_request.Function = MPI2_FUNCTION_CONFIG;
@@ -1412,7 +1381,6 @@ mpt2sas_config_get_phy_pg0(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigReply_t
 		_config_free_config_dma_memory(ioc, &mem);
 
  out:
-	mutex_unlock(&ioc->config_cmds.mutex);
 	return r;
 }
 
@@ -1434,7 +1402,6 @@ mpt2sas_config_get_phy_pg1(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigReply_t
 	int r;
 	struct config_request mem;
 
-	mutex_lock(&ioc->config_cmds.mutex);
 	memset(config_page, 0, sizeof(Mpi2SasPhyPage1_t));
 	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
 	mpi_request.Function = MPI2_FUNCTION_CONFIG;
@@ -1480,7 +1447,6 @@ mpt2sas_config_get_phy_pg1(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigReply_t
 		_config_free_config_dma_memory(ioc, &mem);
 
  out:
-	mutex_unlock(&ioc->config_cmds.mutex);
 	return r;
 }
 
@@ -1504,7 +1470,6 @@ mpt2sas_config_get_raid_volume_pg1(struct MPT2SAS_ADAPTER *ioc,
 	int r;
 	struct config_request mem;
 
-	mutex_lock(&ioc->config_cmds.mutex);
 	memset(config_page, 0, sizeof(Mpi2RaidVolPage1_t));
 	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
 	mpi_request.Function = MPI2_FUNCTION_CONFIG;
@@ -1547,7 +1512,6 @@ mpt2sas_config_get_raid_volume_pg1(struct MPT2SAS_ADAPTER *ioc,
 		_config_free_config_dma_memory(ioc, &mem);
 
  out:
-	mutex_unlock(&ioc->config_cmds.mutex);
 	return r;
 }
 
@@ -1571,7 +1535,6 @@ mpt2sas_config_get_number_pds(struct MPT2SAS_ADAPTER *ioc, u16 handle,
 	struct config_request mem;
 	u16 ioc_status;
 
-	mutex_lock(&ioc->config_cmds.mutex);
 	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
 	*num_pds = 0;
 	mpi_request.Function = MPI2_FUNCTION_CONFIG;
@@ -1619,7 +1582,6 @@ mpt2sas_config_get_number_pds(struct MPT2SAS_ADAPTER *ioc, u16 handle,
 		_config_free_config_dma_memory(ioc, &mem);
 
  out:
-	mutex_unlock(&ioc->config_cmds.mutex);
 	return r;
 }
 
@@ -1644,7 +1606,6 @@ mpt2sas_config_get_raid_volume_pg0(struct MPT2SAS_ADAPTER *ioc,
 	int r;
 	struct config_request mem;
 
-	mutex_lock(&ioc->config_cmds.mutex);
 	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
 	memset(config_page, 0, sz);
 	mpi_request.Function = MPI2_FUNCTION_CONFIG;
@@ -1686,7 +1647,6 @@ mpt2sas_config_get_raid_volume_pg0(struct MPT2SAS_ADAPTER *ioc,
 		_config_free_config_dma_memory(ioc, &mem);
 
  out:
-	mutex_unlock(&ioc->config_cmds.mutex);
 	return r;
 }
 
@@ -1710,7 +1670,6 @@ mpt2sas_config_get_phys_disk_pg0(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigReply_t
 	int r;
 	struct config_request mem;
 
-	mutex_lock(&ioc->config_cmds.mutex);
 	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
 	memset(config_page, 0, sizeof(Mpi2RaidPhysDiskPage0_t));
 	mpi_request.Function = MPI2_FUNCTION_CONFIG;
@@ -1753,7 +1712,6 @@ mpt2sas_config_get_phys_disk_pg0(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigReply_t
 		_config_free_config_dma_memory(ioc, &mem);
 
  out:
-	mutex_unlock(&ioc->config_cmds.mutex);
 	return r;
 }
 
@@ -1777,7 +1735,6 @@ mpt2sas_config_get_volume_handle(struct MPT2SAS_ADAPTER *ioc, u16 pd_handle,
 	struct config_request mem;
 	u16 ioc_status;
 
-	mutex_lock(&ioc->config_cmds.mutex);
 	*volume_handle = 0;
 	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
 	mpi_request.Function = MPI2_FUNCTION_CONFIG;
@@ -1841,7 +1798,6 @@ mpt2sas_config_get_volume_handle(struct MPT2SAS_ADAPTER *ioc, u16 pd_handle,
 		_config_free_config_dma_memory(ioc, &mem);
 
  out:
-	mutex_unlock(&ioc->config_cmds.mutex);
 	return r;
 }
 

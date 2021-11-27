Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29E83C433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Nov 2021 14:13:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343843AbhK0OQh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 27 Nov 2021 09:16:37 -0500
Received: from bedivere.hansenpartnership.com ([96.44.175.130]:43146 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235610AbhK0OOg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 27 Nov 2021 09:14:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1638022282;
        bh=DJIr+4tpBItXK/Nvat4fr+Rt4lhjhNQlD89G6Wvbel4=;
        h=Message-ID:Subject:From:To:Date:From;
        b=SA6PgaXJAPeFql/poQP7jajiPtTX5uWtfODMV3iwWkhrQS0kcK2yqc2sDz3OiZaNK
         GpqLG6dir24WbUcR1oBzIkfzj0C11wnqN8PMbYrhvHp6BU+UXwgjSFvekGv1PKUVoL
         g7jJqOYablKNNvFaorvWjAZIj+GDzz9O9iHnJgHQ=
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 2024912803C3;
        Sat, 27 Nov 2021 09:11:22 -0500 (EST)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id K9m75vMZLD5v; Sat, 27 Nov 2021 09:11:22 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1638022281;
        bh=DJIr+4tpBItXK/Nvat4fr+Rt4lhjhNQlD89G6Wvbel4=;
        h=Message-ID:Subject:From:To:Date:From;
        b=bWj9MpFytCD87tTBG9n5oOGFvvbpiFLFLXFYruKCJBFe784YlhfjcGDgPVz0vH0yf
         gyseplecmoF2iDnx8002mlFhXcP7qQnb9IET+FNugSmf+fmI2a+1NYkEzeIAyUifwu
         JUtwEmLzYa1x7vKL64ZKBwJhslz7WmvjthgS7Tpg=
Received: from jarvis.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4300:c551::527])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 81921128028D;
        Sat, 27 Nov 2021 09:11:21 -0500 (EST)
Message-ID: <88066061f5f16e91cdfe2a5794b0a8b533909787.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 5.16-rc1
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Sat, 27 Nov 2021 09:11:20 -0500
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Twelve fixes, eleven in drivers (target, qla2xx, scsi_debug, mpt3sas,
ufs).  The core fix is a minor correction to the previous state update
fix for the iscsi daemons.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Bean Huo (1):
      scsi: ufs: ufshpb: Fix warning in ufshpb_set_hpb_read_to_upiu()

Dan Carpenter (2):
      scsi: target: configfs: Delete unnecessary checks for NULL
      scsi: qla2xxx: edif: Fix off by one bug in qla_edif_app_getfcinfo()

George Kennedy (2):
      scsi: scsi_debug: Sanity check block descriptor length in resp_mode_select()
      scsi: scsi_debug: Fix type in min_t to avoid stack OOB

Mike Christie (2):
      scsi: core: sysfs: Fix setting device state to SDEV_RUNNING
      scsi: target: core: Use RCU helpers for INQUIRY t10_alua_tg_pt_gp

Shin'ichiro Kawasaki (1):
      scsi: scsi_debug: Zero clear zones at reset write pointer

Sreekanth Reddy (3):
      scsi: mpt3sas: Fix incorrect system timestamp
      scsi: mpt3sas: Fix system going into read-only mode
      scsi: mpt3sas: Fix kernel panic during drive powercycle test

Ye Guojin (1):
      scsi: ufs: ufs-mediatek: Add put_device() after of_find_device_by_node()

And the diffstat:

 drivers/scsi/mpt3sas/mpt3sas_base.c          |  4 +-
 drivers/scsi/mpt3sas/mpt3sas_base.h          |  4 ++
 drivers/scsi/mpt3sas/mpt3sas_scsih.c         | 59 +++++++++++++++++++++++++++-
 drivers/scsi/qla2xxx/qla_edif.c              |  2 +-
 drivers/scsi/scsi_debug.c                    | 43 ++++++++++++--------
 drivers/scsi/scsi_sysfs.c                    |  2 +-
 drivers/scsi/ufs/ufs-mediatek.c              |  1 +
 drivers/scsi/ufs/ufshpb.c                    |  2 +-
 drivers/target/target_core_fabric_configfs.c | 16 ++++----
 drivers/target/target_core_spc.c             | 14 +++----
 10 files changed, 108 insertions(+), 39 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 27eb652b564f..81dab9b82f79 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -639,8 +639,8 @@ static void _base_sync_drv_fw_timestamp(struct MPT3SAS_ADAPTER *ioc)
 	mpi_request->IOCParameter = MPI26_SET_IOC_PARAMETER_SYNC_TIMESTAMP;
 	current_time = ktime_get_real();
 	TimeStamp = ktime_to_ms(current_time);
-	mpi_request->Reserved7 = cpu_to_le32(TimeStamp & 0xFFFFFFFF);
-	mpi_request->IOCParameterValue = cpu_to_le32(TimeStamp >> 32);
+	mpi_request->Reserved7 = cpu_to_le32(TimeStamp >> 32);
+	mpi_request->IOCParameterValue = cpu_to_le32(TimeStamp & 0xFFFFFFFF);
 	init_completion(&ioc->scsih_cmds.done);
 	ioc->put_smid_default(ioc, smid);
 	dinitprintk(ioc, ioc_info(ioc,
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index db6a759de1e9..a0af986633d2 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -142,6 +142,8 @@
 
 #define MPT_MAX_CALLBACKS		32
 
+#define MPT_MAX_HBA_NUM_PHYS		32
+
 #define INTERNAL_CMDS_COUNT		10	/* reserved cmds */
 /* reserved for issuing internally framed scsi io cmds */
 #define INTERNAL_SCSIIO_CMDS_COUNT	3
@@ -798,6 +800,7 @@ struct _sas_phy {
  * @enclosure_handle: handle for this a member of an enclosure
  * @device_info: bitwise defining capabilities of this sas_host/expander
  * @responding: used in _scsih_expander_device_mark_responding
+ * @nr_phys_allocated: Allocated memory for this many count phys
  * @phy: a list of phys that make up this sas_host/expander
  * @sas_port_list: list of ports attached to this sas_host/expander
  * @port: hba port entry containing node's port number info
@@ -813,6 +816,7 @@ struct _sas_node {
 	u16	enclosure_handle;
 	u64	enclosure_logical_id;
 	u8	responding;
+	u8	nr_phys_allocated;
 	struct hba_port *port;
 	struct	_sas_phy *phy;
 	struct list_head sas_port_list;
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index cee7170beae8..00792767c620 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -3869,7 +3869,7 @@ _scsih_ublock_io_device(struct MPT3SAS_ADAPTER *ioc,
 
 	shost_for_each_device(sdev, ioc->shost) {
 		sas_device_priv_data = sdev->hostdata;
-		if (!sas_device_priv_data)
+		if (!sas_device_priv_data || !sas_device_priv_data->sas_target)
 			continue;
 		if (sas_device_priv_data->sas_target->sas_address
 		    != sas_address)
@@ -6406,11 +6406,26 @@ _scsih_sas_port_refresh(struct MPT3SAS_ADAPTER *ioc)
 	int i, j, count = 0, lcount = 0;
 	int ret;
 	u64 sas_addr;
+	u8 num_phys;
 
 	drsprintk(ioc, ioc_info(ioc,
 	    "updating ports for sas_host(0x%016llx)\n",
 	    (unsigned long long)ioc->sas_hba.sas_address));
 
+	mpt3sas_config_get_number_hba_phys(ioc, &num_phys);
+	if (!num_phys) {
+		ioc_err(ioc, "failure at %s:%d/%s()!\n",
+		    __FILE__, __LINE__, __func__);
+		return;
+	}
+
+	if (num_phys > ioc->sas_hba.nr_phys_allocated) {
+		ioc_err(ioc, "failure at %s:%d/%s()!\n",
+		   __FILE__, __LINE__, __func__);
+		return;
+	}
+	ioc->sas_hba.num_phys = num_phys;
+
 	port_table = kcalloc(ioc->sas_hba.num_phys,
 	    sizeof(struct hba_port), GFP_KERNEL);
 	if (!port_table)
@@ -6611,6 +6626,30 @@ _scsih_sas_host_refresh(struct MPT3SAS_ADAPTER *ioc)
 			ioc->sas_hba.phy[i].hba_vphy = 1;
 		}
 
+		/*
+		 * Add new HBA phys to STL if these new phys got added as part
+		 * of HBA Firmware upgrade/downgrade operation.
+		 */
+		if (!ioc->sas_hba.phy[i].phy) {
+			if ((mpt3sas_config_get_phy_pg0(ioc, &mpi_reply,
+							&phy_pg0, i))) {
+				ioc_err(ioc, "failure at %s:%d/%s()!\n",
+					__FILE__, __LINE__, __func__);
+				continue;
+			}
+			ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
+				MPI2_IOCSTATUS_MASK;
+			if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
+				ioc_err(ioc, "failure at %s:%d/%s()!\n",
+					__FILE__, __LINE__, __func__);
+				continue;
+			}
+			ioc->sas_hba.phy[i].phy_id = i;
+			mpt3sas_transport_add_host_phy(ioc,
+				&ioc->sas_hba.phy[i], phy_pg0,
+				ioc->sas_hba.parent_dev);
+			continue;
+		}
 		ioc->sas_hba.phy[i].handle = ioc->sas_hba.handle;
 		attached_handle = le16_to_cpu(sas_iounit_pg0->PhyData[i].
 		    AttachedDevHandle);
@@ -6622,6 +6661,19 @@ _scsih_sas_host_refresh(struct MPT3SAS_ADAPTER *ioc)
 		    attached_handle, i, link_rate,
 		    ioc->sas_hba.phy[i].port);
 	}
+	/*
+	 * Clear the phy details if this phy got disabled as part of
+	 * HBA Firmware upgrade/downgrade operation.
+	 */
+	for (i = ioc->sas_hba.num_phys;
+	     i < ioc->sas_hba.nr_phys_allocated; i++) {
+		if (ioc->sas_hba.phy[i].phy &&
+		    ioc->sas_hba.phy[i].phy->negotiated_linkrate >=
+		    SAS_LINK_RATE_1_5_GBPS)
+			mpt3sas_transport_update_links(ioc,
+				ioc->sas_hba.sas_address, 0, i,
+				MPI2_SAS_NEG_LINK_RATE_PHY_DISABLED, NULL);
+	}
  out:
 	kfree(sas_iounit_pg0);
 }
@@ -6654,7 +6706,10 @@ _scsih_sas_host_add(struct MPT3SAS_ADAPTER *ioc)
 			__FILE__, __LINE__, __func__);
 		return;
 	}
-	ioc->sas_hba.phy = kcalloc(num_phys,
+
+	ioc->sas_hba.nr_phys_allocated = max_t(u8,
+	    MPT_MAX_HBA_NUM_PHYS, num_phys);
+	ioc->sas_hba.phy = kcalloc(ioc->sas_hba.nr_phys_allocated,
 	    sizeof(struct _sas_phy), GFP_KERNEL);
 	if (!ioc->sas_hba.phy) {
 		ioc_err(ioc, "failure at %s:%d/%s()!\n",
diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
index 2e37b189cb75..53d2b8562027 100644
--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -865,7 +865,7 @@ qla_edif_app_getfcinfo(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 			    "APP request entry - portid=%06x.\n", tdid.b24);
 
 			/* Ran out of space */
-			if (pcnt > app_req.num_ports)
+			if (pcnt >= app_req.num_ports)
 				break;
 
 			if (tdid.b24 != 0 && tdid.b24 != fcport->d_id.b24)
diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 1d0278da9041..3c0da3770edf 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -1189,7 +1189,7 @@ static int p_fill_from_dev_buffer(struct scsi_cmnd *scp, const void *arr,
 		 __func__, off_dst, scsi_bufflen(scp), act_len,
 		 scsi_get_resid(scp));
 	n = scsi_bufflen(scp) - (off_dst + act_len);
-	scsi_set_resid(scp, min_t(int, scsi_get_resid(scp), n));
+	scsi_set_resid(scp, min_t(u32, scsi_get_resid(scp), n));
 	return 0;
 }
 
@@ -1562,7 +1562,8 @@ static int resp_inquiry(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	unsigned char pq_pdt;
 	unsigned char *arr;
 	unsigned char *cmd = scp->cmnd;
-	int alloc_len, n, ret;
+	u32 alloc_len, n;
+	int ret;
 	bool have_wlun, is_disk, is_zbc, is_disk_zbc;
 
 	alloc_len = get_unaligned_be16(cmd + 3);
@@ -1585,7 +1586,8 @@ static int resp_inquiry(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 		kfree(arr);
 		return check_condition_result;
 	} else if (0x1 & cmd[1]) {  /* EVPD bit set */
-		int lu_id_num, port_group_id, target_dev_id, len;
+		int lu_id_num, port_group_id, target_dev_id;
+		u32 len;
 		char lu_id_str[6];
 		int host_no = devip->sdbg_host->shost->host_no;
 		
@@ -1676,9 +1678,9 @@ static int resp_inquiry(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 			kfree(arr);
 			return check_condition_result;
 		}
-		len = min(get_unaligned_be16(arr + 2) + 4, alloc_len);
+		len = min_t(u32, get_unaligned_be16(arr + 2) + 4, alloc_len);
 		ret = fill_from_dev_buffer(scp, arr,
-			    min(len, SDEBUG_MAX_INQ_ARR_SZ));
+			    min_t(u32, len, SDEBUG_MAX_INQ_ARR_SZ));
 		kfree(arr);
 		return ret;
 	}
@@ -1714,7 +1716,7 @@ static int resp_inquiry(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	}
 	put_unaligned_be16(0x2100, arr + n);	/* SPL-4 no version claimed */
 	ret = fill_from_dev_buffer(scp, arr,
-			    min_t(int, alloc_len, SDEBUG_LONG_INQ_SZ));
+			    min_t(u32, alloc_len, SDEBUG_LONG_INQ_SZ));
 	kfree(arr);
 	return ret;
 }
@@ -1729,8 +1731,8 @@ static int resp_requests(struct scsi_cmnd *scp,
 	unsigned char *cmd = scp->cmnd;
 	unsigned char arr[SCSI_SENSE_BUFFERSIZE];	/* assume >= 18 bytes */
 	bool dsense = !!(cmd[1] & 1);
-	int alloc_len = cmd[4];
-	int len = 18;
+	u32 alloc_len = cmd[4];
+	u32 len = 18;
 	int stopped_state = atomic_read(&devip->stopped);
 
 	memset(arr, 0, sizeof(arr));
@@ -1774,7 +1776,7 @@ static int resp_requests(struct scsi_cmnd *scp,
 			arr[7] = 0xa;
 		}
 	}
-	return fill_from_dev_buffer(scp, arr, min_t(int, len, alloc_len));
+	return fill_from_dev_buffer(scp, arr, min_t(u32, len, alloc_len));
 }
 
 static int resp_start_stop(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
@@ -2312,7 +2314,8 @@ static int resp_mode_sense(struct scsi_cmnd *scp,
 {
 	int pcontrol, pcode, subpcode, bd_len;
 	unsigned char dev_spec;
-	int alloc_len, offset, len, target_dev_id;
+	u32 alloc_len, offset, len;
+	int target_dev_id;
 	int target = scp->device->id;
 	unsigned char *ap;
 	unsigned char arr[SDEBUG_MAX_MSENSE_SZ];
@@ -2468,7 +2471,7 @@ static int resp_mode_sense(struct scsi_cmnd *scp,
 		arr[0] = offset - 1;
 	else
 		put_unaligned_be16((offset - 2), arr + 0);
-	return fill_from_dev_buffer(scp, arr, min_t(int, alloc_len, offset));
+	return fill_from_dev_buffer(scp, arr, min_t(u32, alloc_len, offset));
 }
 
 #define SDEBUG_MAX_MSELECT_SZ 512
@@ -2499,11 +2502,11 @@ static int resp_mode_select(struct scsi_cmnd *scp,
 			    __func__, param_len, res);
 	md_len = mselect6 ? (arr[0] + 1) : (get_unaligned_be16(arr + 0) + 2);
 	bd_len = mselect6 ? arr[3] : get_unaligned_be16(arr + 6);
-	if (md_len > 2) {
+	off = bd_len + (mselect6 ? 4 : 8);
+	if (md_len > 2 || off >= res) {
 		mk_sense_invalid_fld(scp, SDEB_IN_DATA, 0, -1);
 		return check_condition_result;
 	}
-	off = bd_len + (mselect6 ? 4 : 8);
 	mpage = arr[off] & 0x3f;
 	ps = !!(arr[off] & 0x80);
 	if (ps) {
@@ -2583,7 +2586,8 @@ static int resp_ie_l_pg(unsigned char *arr)
 static int resp_log_sense(struct scsi_cmnd *scp,
 			  struct sdebug_dev_info *devip)
 {
-	int ppc, sp, pcode, subpcode, alloc_len, len, n;
+	int ppc, sp, pcode, subpcode;
+	u32 alloc_len, len, n;
 	unsigned char arr[SDEBUG_MAX_LSENSE_SZ];
 	unsigned char *cmd = scp->cmnd;
 
@@ -2653,9 +2657,9 @@ static int resp_log_sense(struct scsi_cmnd *scp,
 		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 3, -1);
 		return check_condition_result;
 	}
-	len = min_t(int, get_unaligned_be16(arr + 2) + 4, alloc_len);
+	len = min_t(u32, get_unaligned_be16(arr + 2) + 4, alloc_len);
 	return fill_from_dev_buffer(scp, arr,
-		    min_t(int, len, SDEBUG_MAX_INQ_ARR_SZ));
+		    min_t(u32, len, SDEBUG_MAX_INQ_ARR_SZ));
 }
 
 static inline bool sdebug_dev_is_zoned(struct sdebug_dev_info *devip)
@@ -4430,7 +4434,7 @@ static int resp_report_zones(struct scsi_cmnd *scp,
 	put_unaligned_be64(sdebug_capacity - 1, arr + 8);
 
 	rep_len = (unsigned long)desc - (unsigned long)arr;
-	ret = fill_from_dev_buffer(scp, arr, min_t(int, alloc_len, rep_len));
+	ret = fill_from_dev_buffer(scp, arr, min_t(u32, alloc_len, rep_len));
 
 fini:
 	read_unlock(macc_lckp);
@@ -4653,6 +4657,7 @@ static void zbc_rwp_zone(struct sdebug_dev_info *devip,
 			 struct sdeb_zone_state *zsp)
 {
 	enum sdebug_z_cond zc;
+	struct sdeb_store_info *sip = devip2sip(devip, false);
 
 	if (zbc_zone_is_conv(zsp))
 		return;
@@ -4664,6 +4669,10 @@ static void zbc_rwp_zone(struct sdebug_dev_info *devip,
 	if (zsp->z_cond == ZC4_CLOSED)
 		devip->nr_closed--;
 
+	if (zsp->z_wp > zsp->z_start)
+		memset(sip->storep + zsp->z_start * sdebug_sector_size, 0,
+		       (zsp->z_wp - zsp->z_start) * sdebug_sector_size);
+
 	zsp->z_non_seq_resource = false;
 	zsp->z_wp = zsp->z_start;
 	zsp->z_cond = ZC1_EMPTY;
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 7afcec250f9b..d4edce930a4a 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -812,7 +812,7 @@ store_state_field(struct device *dev, struct device_attribute *attr,
 
 	mutex_lock(&sdev->state_mutex);
 	if (sdev->sdev_state == SDEV_RUNNING && state == SDEV_RUNNING) {
-		ret = count;
+		ret = 0;
 	} else {
 		ret = scsi_device_set_state(sdev, state);
 		if (ret == 0 && state == SDEV_RUNNING)
diff --git a/drivers/scsi/ufs/ufs-mediatek.c b/drivers/scsi/ufs/ufs-mediatek.c
index fc5b214347b3..5393b5c9dd9c 100644
--- a/drivers/scsi/ufs/ufs-mediatek.c
+++ b/drivers/scsi/ufs/ufs-mediatek.c
@@ -1189,6 +1189,7 @@ static int ufs_mtk_probe(struct platform_device *pdev)
 	}
 	link = device_link_add(dev, &reset_pdev->dev,
 		DL_FLAG_AUTOPROBE_CONSUMER);
+	put_device(&reset_pdev->dev);
 	if (!link) {
 		dev_notice(dev, "add reset device_link fail\n");
 		goto skip_reset;
diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index 2e31e1413826..ded5ba9b1466 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -331,7 +331,7 @@ ufshpb_set_hpb_read_to_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp,
 	cdb[0] = UFSHPB_READ;
 
 	if (hba->dev_quirks & UFS_DEVICE_QUIRK_SWAP_L2P_ENTRY_FOR_HPB_READ)
-		ppn_tmp = swab64(ppn);
+		ppn_tmp = (__force __be64)swab64((__force u64)ppn);
 
 	/* ppn value is stored as big-endian in the host memory */
 	memcpy(&cdb[6], &ppn_tmp, sizeof(__be64));
diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index 0b65de9f2df1..95a88f6224cd 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -520,7 +520,7 @@ static ssize_t target_fabric_port_alua_tg_pt_gp_show(struct config_item *item,
 {
 	struct se_lun *lun = item_to_lun(item);
 
-	if (!lun || !lun->lun_se_dev)
+	if (!lun->lun_se_dev)
 		return -ENODEV;
 
 	return core_alua_show_tg_pt_gp_info(lun, page);
@@ -531,7 +531,7 @@ static ssize_t target_fabric_port_alua_tg_pt_gp_store(struct config_item *item,
 {
 	struct se_lun *lun = item_to_lun(item);
 
-	if (!lun || !lun->lun_se_dev)
+	if (!lun->lun_se_dev)
 		return -ENODEV;
 
 	return core_alua_store_tg_pt_gp_info(lun, page, count);
@@ -542,7 +542,7 @@ static ssize_t target_fabric_port_alua_tg_pt_offline_show(
 {
 	struct se_lun *lun = item_to_lun(item);
 
-	if (!lun || !lun->lun_se_dev)
+	if (!lun->lun_se_dev)
 		return -ENODEV;
 
 	return core_alua_show_offline_bit(lun, page);
@@ -553,7 +553,7 @@ static ssize_t target_fabric_port_alua_tg_pt_offline_store(
 {
 	struct se_lun *lun = item_to_lun(item);
 
-	if (!lun || !lun->lun_se_dev)
+	if (!lun->lun_se_dev)
 		return -ENODEV;
 
 	return core_alua_store_offline_bit(lun, page, count);
@@ -564,7 +564,7 @@ static ssize_t target_fabric_port_alua_tg_pt_status_show(
 {
 	struct se_lun *lun = item_to_lun(item);
 
-	if (!lun || !lun->lun_se_dev)
+	if (!lun->lun_se_dev)
 		return -ENODEV;
 
 	return core_alua_show_secondary_status(lun, page);
@@ -575,7 +575,7 @@ static ssize_t target_fabric_port_alua_tg_pt_status_store(
 {
 	struct se_lun *lun = item_to_lun(item);
 
-	if (!lun || !lun->lun_se_dev)
+	if (!lun->lun_se_dev)
 		return -ENODEV;
 
 	return core_alua_store_secondary_status(lun, page, count);
@@ -586,7 +586,7 @@ static ssize_t target_fabric_port_alua_tg_pt_write_md_show(
 {
 	struct se_lun *lun = item_to_lun(item);
 
-	if (!lun || !lun->lun_se_dev)
+	if (!lun->lun_se_dev)
 		return -ENODEV;
 
 	return core_alua_show_secondary_write_metadata(lun, page);
@@ -597,7 +597,7 @@ static ssize_t target_fabric_port_alua_tg_pt_write_md_store(
 {
 	struct se_lun *lun = item_to_lun(item);
 
-	if (!lun || !lun->lun_se_dev)
+	if (!lun->lun_se_dev)
 		return -ENODEV;
 
 	return core_alua_store_secondary_write_metadata(lun, page, count);
diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index 22703a0dbd07..4c76498d3fb0 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -40,11 +40,11 @@ static void spc_fill_alua_data(struct se_lun *lun, unsigned char *buf)
 	 *
 	 * See spc4r17 section 6.4.2 Table 135
 	 */
-	spin_lock(&lun->lun_tg_pt_gp_lock);
-	tg_pt_gp = lun->lun_tg_pt_gp;
+	rcu_read_lock();
+	tg_pt_gp = rcu_dereference(lun->lun_tg_pt_gp);
 	if (tg_pt_gp)
 		buf[5] |= tg_pt_gp->tg_pt_gp_alua_access_type;
-	spin_unlock(&lun->lun_tg_pt_gp_lock);
+	rcu_read_unlock();
 }
 
 static u16
@@ -325,14 +325,14 @@ spc_emulate_evpd_83(struct se_cmd *cmd, unsigned char *buf)
 		 * Get the PROTOCOL IDENTIFIER as defined by spc4r17
 		 * section 7.5.1 Table 362
 		 */
-		spin_lock(&lun->lun_tg_pt_gp_lock);
-		tg_pt_gp = lun->lun_tg_pt_gp;
+		rcu_read_lock();
+		tg_pt_gp = rcu_dereference(lun->lun_tg_pt_gp);
 		if (!tg_pt_gp) {
-			spin_unlock(&lun->lun_tg_pt_gp_lock);
+			rcu_read_unlock();
 			goto check_lu_gp;
 		}
 		tg_pt_gp_id = tg_pt_gp->tg_pt_gp_id;
-		spin_unlock(&lun->lun_tg_pt_gp_lock);
+		rcu_read_unlock();
 
 		buf[off] = tpg->proto_id << 4;
 		buf[off++] |= 0x1; /* CODE SET == Binary */


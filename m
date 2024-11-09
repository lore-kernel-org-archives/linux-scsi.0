Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A339D286A8
	for <linux-scsi@vger.kernel.org>; Sat,  9 Nov 2024 04:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731127535; cv=none; b=B+kQ5EibVRxZ97qq+BKLA4mXD98ZoqT8MMDWZ2w/95BdaYCxATIpoWe0RcfjIogqbDoh8fSoWqOkIlPIMnmxf7TL60bn898zsUGNtXMxTIBwAK8bJtdhhRqu5NftgHCCcvpFKrEUgsFZ0A+GB/YS4H/YAixDZ7fzBAD1WoRZ5Pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731127535; c=relaxed/simple;
	bh=+wQGD7OhU+LITN3CSeh543W8Ng61OzHHq4tpiw8BvmA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TVfp9zoAwMCIKM2uhoAoN/DeoQFMqblQUEz59lrQ5B7+c0nO/d5qAbfZyJvMRjjeYMN9vpc3Rlrc2duF6NEMa966G1Q4FdzDp7TWmTQEAcY8aY4tH+gMi1HuQdfhDDNzPoU2Ut065zfZCOs8QebUP70mx6YZ2Ivs5PMLq14ajug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=QSIXPEia; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QSIXPEia"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A94PdN3005286
	for <linux-scsi@vger.kernel.org>; Sat, 9 Nov 2024 04:45:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2023-11-20; bh=ETtSE
	CxwWca1iUuaTGAyoNHvHcywCYSkiw7Y9HP1yj8=; b=QSIXPEia7YWR64EfUJVhL
	hdguaxoyYHIClmjJoygCex2VeIyBb97b7uvAD6qSsjv6zUx7BDK152yMft0cxHL9
	RHMJw1EbJ46NqNsBhlmGe/6yQ3ofHcLM5Nj/j6PIaP0jtYoJch/QDx6nedRpuhrG
	R/qvyOd/KqtHfc/tAN24FB8s0urPZC/trQlem2r2MqHU4nI5Cv4eloKqIKG+HNbV
	KSELNXPzd3NYiiY/SDkDX0uR2gbKzBn4UdfGjyvSsoeAjQGGZA4G2ky2rfNrXK+1
	uSGOCymUC4fXkXy2xKDuAuNbWNDq1KiD9OJLaRHpat1rSqU5OZbn1wxp/RMvJTgp
	Q==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42t0heg0bc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Sat, 09 Nov 2024 04:45:32 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4A91Y5d8034515
	for <linux-scsi@vger.kernel.org>; Sat, 9 Nov 2024 04:45:31 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42sx65ajaj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Sat, 09 Nov 2024 04:45:31 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4A94jTda001575
	for <linux-scsi@vger.kernel.org>; Sat, 9 Nov 2024 04:45:31 GMT
Received: from hmadhani-upstream.osdevelopmeniad.oraclevcn.com (hmadhani-upstream.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.255.48])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 42sx65aj9h-8;
	Sat, 09 Nov 2024 04:45:31 +0000
From: himanshu.madhani@oracle.com
To: martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Subject: [RFC v1 7/8] scsi: Add multipath disk init code for sd driver
Date: Sat,  9 Nov 2024 04:45:28 +0000
Message-ID: <20241109044529.992935-8-himanshu.madhani@oracle.com>
X-Mailer: git-send-email 2.41.0.rc2
In-Reply-To: <20241109044529.992935-1-himanshu.madhani@oracle.com>
References: <20241109044529.992935-1-himanshu.madhani@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-09_03,2024-11-08_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 adultscore=0 phishscore=0 bulkscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2411090036
X-Proofpoint-ORIG-GUID: kJaq1VJ95Rt7FTBTZlVIPkRUh9FQ-yaw
X-Proofpoint-GUID: kJaq1VJ95Rt7FTBTZlVIPkRUh9FQ-yaw

From: Himanshu Madhani <himanshu.madhani@oracle.com>

This patch adds allocation and initialization code to
scsi disk driver.

Signed-off-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/sd.c | 83 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 83 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 41e2dfa2d67d..b4727b599794 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1483,6 +1483,9 @@ static void sd_uninit_command(struct scsi_cmnd *SCpnt)
 
 static bool sd_need_revalidate(struct gendisk *disk, struct scsi_disk *sdkp)
 {
+	if (scsi_is_sdev_multipath(sdkp->device))
+		return true;
+
 	if (sdkp->device->removable || sdkp->write_prot) {
 		if (disk_check_media_change(disk))
 			return true;
@@ -1892,6 +1895,10 @@ static int sd_get_unique_id(struct gendisk *disk, u8 id[16],
 		if (len == 16)
 			break;
 	}
+
+	if (scsi_mpath_enabled(sdev))
+		ret = scsi_mpath_unique_id(sdev, id, type);
+
 out_unlock:
 	rcu_read_unlock();
 	return ret;
@@ -3817,6 +3824,33 @@ static int sd_revalidate_disk(struct gendisk *disk)
 	if (sdkp->media_present && scsi_device_supports_vpd(sdp))
 		sd_read_cpr(sdkp);
 
+	/* for multipath device, Adjust queue limits for MPATH disk */
+	if (scsi_is_sdev_multipath(sdp)) {
+		struct queue_limits *mpath_lim = &sdp->mpath_disk->queue->limits;
+
+		blk_mq_freeze_queue(sdp->mpath_disk->queue);
+		lim = queue_limits_start_update(sdp->mpath_disk->queue);
+		lim.logical_block_size = mpath_lim->logical_block_size;
+		lim.physical_block_size = mpath_lim->physical_block_size;
+		lim.io_min = mpath_lim->io_min;
+		lim.io_opt = mpath_lim->io_opt;
+		queue_limits_stack_bdev(&lim, sdp->mpath_disk->part0, 0,
+		    sdp->mpath_disk->disk_name);
+
+		sdp->mpath_disk->flags |= GENHD_FL_HIDDEN;
+
+		set_capacity_and_notify(sdp->mpath_disk,
+		    logical_to_sectors(sdp, sdkp->capacity));
+
+		err = queue_limits_commit_update(sdp->mpath_disk->queue, &lim);
+
+		scsi_mpath_revalidate_path(sdp->mpath_disk,
+		    logical_to_sectors(sdp, sdkp->capacity));
+
+		blk_mq_unfreeze_queue(sdp->mpath_disk->queue);
+		if (err)
+			return err;
+	}
 	/*
 	 * For a zoned drive, revalidating the zones can be done only once
 	 * the gendisk capacity is set. So if this fails, set back the gendisk
@@ -3943,6 +3977,9 @@ static int sd_probe(struct device *dev)
 	if (!sdkp)
 		goto out;
 
+	if (scsi_mpath_enabled(sdp) && sdp->is_shared)
+		scsi_mpath_alloc_disk(sdp);
+
 	gd = blk_mq_alloc_disk_for_queue(sdp->request_queue,
 					 &sd_bio_compl_lkclass);
 	if (!gd)
@@ -3960,6 +3997,10 @@ static int sd_probe(struct device *dev)
 		goto out_free_index;
 	}
 
+	if (scsi_is_sdev_multipath(sdp))
+		snprintf(sdp->mpath_disk->disk_name, DISK_NAME_LEN, "mpath%dsd%d",
+		    sdp->host->host_no, index);
+
 	sdkp->device = sdp;
 	sdkp->disk = gd;
 	sdkp->index = index;
@@ -4021,6 +4062,21 @@ static int sd_probe(struct device *dev)
 			sdp->host->rpm_autosuspend_delay);
 	}
 
+	if (scsi_is_sdev_multipath(sdp)) {
+		sdp->mpath_disk->major = sd_major((index & 0xf0) >> 4);
+		sdp->mpath_disk->first_minor = ((index & 0xf) << 4) | (index & 0xfff00);
+		sdp->mpath_disk->minors = SD_MINORS;
+
+		scsi_mpath_add_disk(sdp);
+
+		if (!test_bit(SCSI_MPATH_DISK_LIVE, &sdp->mpath_flags)) {
+			device_unregister(&sdkp->disk_dev);
+			clear_bit(SCSI_MPATH_DISK_LIVE, &sdp->mpath_flags);
+			put_disk(sdp->mpath_disk);
+			goto out;
+		}
+	}
+
 	error = device_add_disk(dev, gd, NULL);
 	if (error) {
 		device_unregister(&sdkp->disk_dev);
@@ -4074,12 +4130,20 @@ static int sd_remove(struct device *dev)
 		sd_shutdown(dev);
 
 	put_disk(sdkp->disk);
+
+	if (scsi_is_sdev_multipath(sdkp->device))
+		scsi_mpath_remove_disk(sdkp->device);
+
 	return 0;
 }
 
 static void scsi_disk_release(struct device *dev)
 {
 	struct scsi_disk *sdkp = to_scsi_disk(dev);
+	struct scsi_device *sdp = to_scsi_device(dev);
+
+	if (scsi_is_sdev_multipath(sdp))
+		scsi_mpath_dev_release(sdp);
 
 	ida_free(&sd_index_ida, sdkp->index);
 	put_device(&sdkp->device->sdev_gendev);
@@ -4171,6 +4235,25 @@ static void sd_shutdown(struct device *dev)
 	if (pm_runtime_suspended(dev))
 		return;
 
+	if (scsi_is_sdev_multipath(sdkp->device)) {
+		struct scsi_device *sdp = sdkp->device;
+		bool last_path = false;
+
+		if (scsi_mpath_clear_current_path(sdp))
+			synchronize_srcu(&sdp->host->mpath_dev->srcu);
+
+		mutex_lock(&sdp->host->mpath_dev->mpath_lock);
+		list_del_rcu(&sdp->siblings);
+		if (list_empty(&sdp->host->mpath_sdev)) {
+			list_del_init(&sdp->mpath_entry);
+			last_path = true;
+		}
+		mutex_unlock(&sdp->host->mpath_dev->mpath_lock);
+
+		if (last_path)
+			scsi_mpath_shutdown_disk(sdp);
+	}
+
 	if (sdkp->WCE && sdkp->media_present) {
 		sd_printk(KERN_NOTICE, sdkp, "Synchronizing SCSI cache\n");
 		sd_sync_cache(sdkp);
-- 
2.41.0.rc2


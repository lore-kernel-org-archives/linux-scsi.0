Received: from fgw20-4.mail.saunalahti.fi (fgw20-4.mail.saunalahti.fi [62.142.5.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DB0D4C79
	for <linux-scsi@vger.kernel.org>; Fri, 28 Feb 2025 12:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.142.5.107
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740746831; cv=none; b=k0IQyCeSwttM3B9dVMLVtoKj3p4VFXuXXXw5JAbhOanyBssEEiUa86BBCc6/h3SXlBXIAzmfQXPv4OPhvdmnSJfEml2ZJc0mQfB24/aOeqWCg51ohNOSFBXvtyzIhxMBpWL/wmRvIGkXWDLW/QI3D+4H6vajp62lWcnoVI7fXHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740746831; c=relaxed/simple;
	bh=aYzV3vM4DB2x+7JC9kGgYJUs407DHyh8lPDXfnbooHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BZ1S0dLxOSpskubO6U5u2/SegmdbRgZn/NznDORCMJY4N58DaSMqElOUTkcZgL2ccyHArDqMxsQuXp/M+ZLlBVbryIb75BzEs1gaoLTf2FdMlEtw+MFky1oqKv2g6GmXFZ3zhp5GenWgDHIisOpnWNGdk/6vS0hrqM/CnarO2GQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi; spf=pass smtp.mailfrom=kolumbus.fi; dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b=tBJZz9bg; arc=none smtp.client-ip=62.142.5.107
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b="tBJZz9bg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=kolumbus.fi; s=elisa1;
	h=content-transfer-encoding:content-type:mime-version:references:in-reply-to:
	 message-id:date:subject:cc:to:from:from:to:cc:reply-to:subject:date:
	 in-reply-to:references:list-archive:list-subscribe:list-unsubscribe:
	 content-type:content-transfer-encoding:message-id;
	bh=+UYzh4/3VfD4+JYlnYzCGJ5vGPuYc8uJIlyMP7ERllk=;
	b=tBJZz9bgX3r1z1pvG+KrXLIK59i1QdmC3O/iLH1jUHsCJuHwTFtHoletYVebBu8F8zJHoYRyK1d1n
	 WOGWnt86IcLhwKPL/5ejQcbsePQOy3vZGzGA048ZnV7/9tmVjA8X6ANPjO+BFazGA93t7DqgPFI2dG
	 edSHwI3lp5SQJGEQ4kGuxpNGo+WyVM4A/DW974ExCuIaCDnHJY8Ld9w6TYWg9t9OhOTRD3UYizcXwK
	 yOb+0GsbGBgSY5/h68Xn4CTklH0099qCED3u7oGcoBxTUU/rEefBhYSGs8tOJDvuEjXq3DOE6Hb2zh
	 rDbnP7hP1mgtqLPrhK/62PVKv40WgLw==
Received: from kaipn1.makisara.private (85-156-116-90.elisa-laajakaista.fi [85.156.116.90])
	by fgw23.mail.saunalahti.fi (Halon) with ESMTPSA
	id 15a36d96-f5d2-11ef-a2a5-005056bdfda7;
	Fri, 28 Feb 2025 14:46:52 +0200 (EET)
From: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
To: linux-scsi@vger.kernel.org,
	dgilbert@interlog.com
Cc: martin.petersen@oracle.com,
	James.Bottomley@HansenPartnership.com,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
Subject: [PATCH 4/4] scsi: scsi_debug: Use scsi_device->type instead os sdebug_ptype where possible
Date: Fri, 28 Feb 2025 14:46:27 +0200
Message-ID: <20250228124627.177873-6-Kai.Makisara@kolumbus.fi>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250228124627.177873-1-Kai.Makisara@kolumbus.fi>
References: <20250228124627.177873-1-Kai.Makisara@kolumbus.fi>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Devices of several types can be created for a single host. The module
device type should be used only when the devices are created.

Scsi_scan sets the device type initially to 0xff and sets the correct
type based in Inquiry results. This means that Inquiry must report
sdebug_ptype as long as scsi_device->type is not set (the limit 32
comes from the 5-bit length of the Peripheral Device Type in Inquiry).

Signed-off-by: Kai Mäkisara <Kai.Makisara@kolumbus.fi>
---
 drivers/scsi/scsi_debug.c | 61 ++++++++++++++++++++++-----------------
 1 file changed, 35 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 15f24d11be05..d64d7ed88ba2 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -2065,13 +2065,19 @@ static int resp_inquiry(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	unsigned char *cmd = scp->cmnd;
 	u32 alloc_len, n;
 	int ret;
-	bool have_wlun, is_disk, is_zbc, is_disk_zbc;
+	bool have_wlun, is_disk, is_zbc, is_disk_zbc, is_tape;
 
 	alloc_len = get_unaligned_be16(cmd + 3);
 	arr = kzalloc(SDEBUG_MAX_INQ_ARR_SZ, GFP_ATOMIC);
 	if (! arr)
 		return DID_REQUEUE << 16;
-	is_disk = (sdebug_ptype == TYPE_DISK);
+	if (scp->device->type >= 32) {
+		is_disk = (sdebug_ptype == TYPE_DISK);
+		is_tape = (sdebug_ptype == TYPE_TAPE);
+	} else {
+		is_disk = (scp->device->type == TYPE_DISK);
+		is_tape = (scp->device->type == TYPE_TAPE);
+	}
 	is_zbc = devip->zoned;
 	is_disk_zbc = (is_disk || is_zbc);
 	have_wlun = scsi_is_wlun(scp->device->lun);
@@ -2080,7 +2086,8 @@ static int resp_inquiry(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	else if (sdebug_no_lun_0 && (devip->lun == SDEBUG_LUN_0_VAL))
 		pq_pdt = 0x7f;	/* not present, PQ=3, PDT=0x1f */
 	else
-		pq_pdt = (sdebug_ptype & 0x1f);
+		pq_pdt = ((scp->device->type >= 32 ?
+				sdebug_ptype : scp->device->type) & 0x1f);
 	arr[0] = pq_pdt;
 	if (0x2 & cmd[1]) {  /* CMDDT bit set */
 		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 1, 1);
@@ -2203,7 +2210,7 @@ static int resp_inquiry(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	if (is_disk) {		/* SBC-4 no version claimed */
 		put_unaligned_be16(0x600, arr + n);
 		n += 2;
-	} else if (sdebug_ptype == TYPE_TAPE) {	/* SSC-4 rev 3 */
+	} else if (is_tape) {	/* SSC-4 rev 3 */
 		put_unaligned_be16(0x525, arr + n);
 		n += 2;
 	} else if (is_zbc) {	/* ZBC BSR INCITS 536 revision 05 */
@@ -2312,7 +2319,7 @@ static int resp_start_stop(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	changing = (stopped_state != want_stop);
 	if (changing)
 		atomic_xchg(&devip->stopped, want_stop);
-	if (sdebug_ptype == TYPE_TAPE && !want_stop) {
+	if (scp->device->type == TYPE_TAPE && !want_stop) {
 		int i;
 
 		set_bit(SDEBUG_UA_NOT_READY_TO_READY, devip->uas_bm); /* not legal! */
@@ -2948,9 +2955,9 @@ static int resp_mode_sense(struct scsi_cmnd *scp,
 	subpcode = cmd[3];
 	msense_6 = (MODE_SENSE == cmd[0]);
 	llbaa = msense_6 ? false : !!(cmd[1] & 0x10);
-	is_disk = (sdebug_ptype == TYPE_DISK);
+	is_disk = (scp->device->type == TYPE_DISK);
 	is_zbc = devip->zoned;
-	is_tape = (sdebug_ptype == TYPE_TAPE);
+	is_tape = (scp->device->type == TYPE_TAPE);
 	if ((is_disk || is_zbc || is_tape) && !dbd)
 		bd_len = llbaa ? 16 : 8;
 	else
@@ -3165,7 +3172,7 @@ static int resp_mode_select(struct scsi_cmnd *scp,
 	md_len = mselect6 ? (arr[0] + 1) : (get_unaligned_be16(arr + 0) + 2);
 	bd_len = mselect6 ? arr[3] : get_unaligned_be16(arr + 6);
 	off = (mselect6 ? 4 : 8);
-	if (sdebug_ptype == TYPE_TAPE) {
+	if (scp->device->type == TYPE_TAPE) {
 		int blksize;
 
 		if (bd_len != 8) {
@@ -3230,7 +3237,7 @@ static int resp_mode_select(struct scsi_cmnd *scp,
 		}
 		break;
 	case 0xf:       /* Compression mode page */
-		if (sdebug_ptype != TYPE_TAPE)
+		if (scp->device->type != TYPE_TAPE)
 			goto bad_pcode;
 		if ((arr[off + 2] & 0x40) != 0) {
 			devip->tape_dce = (arr[off + 2] & 0x80) != 0;
@@ -3238,7 +3245,7 @@ static int resp_mode_select(struct scsi_cmnd *scp,
 		}
 		break;
 	case 0x11:	/* Medium Partition Mode Page (tape) */
-		if (sdebug_ptype == TYPE_TAPE) {
+		if (scp->device->type == TYPE_TAPE) {
 			int fld;
 
 			fld = process_medium_part_m_pg(devip, &arr[off], pg_len);
@@ -6667,7 +6674,7 @@ static void scsi_debug_sdev_destroy(struct scsi_device *sdp)
 
 	debugfs_remove(devip->debugfs_entry);
 
-	if (sdebug_ptype == TYPE_TAPE) {
+	if (sdp->type == TYPE_TAPE) {
 		kfree(devip->tape_blocks[0]);
 		devip->tape_blocks[0] = NULL;
 	}
@@ -6855,18 +6862,16 @@ static int sdebug_fail_lun_reset(struct scsi_cmnd *cmnd)
 
 static void scsi_tape_reset_clear(struct sdebug_dev_info *devip)
 {
-	if (sdebug_ptype == TYPE_TAPE) {
-		int i;
+	int i;
 
-		devip->tape_blksize = TAPE_DEF_BLKSIZE;
-		devip->tape_density = TAPE_DEF_DENSITY;
-		devip->tape_partition = 0;
-		devip->tape_dce = 0;
-		for (i = 0; i < TAPE_MAX_PARTITIONS; i++)
-			devip->tape_location[i] = 0;
-		devip->tape_pending_nbr_partitions = -1;
-		/* Don't reset partitioning? */
-	}
+	devip->tape_blksize = TAPE_DEF_BLKSIZE;
+	devip->tape_density = TAPE_DEF_DENSITY;
+	devip->tape_partition = 0;
+	devip->tape_dce = 0;
+	for (i = 0; i < TAPE_MAX_PARTITIONS; i++)
+		devip->tape_location[i] = 0;
+	devip->tape_pending_nbr_partitions = -1;
+	/* Don't reset partitioning? */
 }
 
 static int scsi_debug_device_reset(struct scsi_cmnd *SCpnt)
@@ -6884,7 +6889,8 @@ static int scsi_debug_device_reset(struct scsi_cmnd *SCpnt)
 	scsi_debug_stop_all_queued(sdp);
 	if (devip) {
 		set_bit(SDEBUG_UA_POR, devip->uas_bm);
-		scsi_tape_reset_clear(devip);
+		if (SCpnt->device->type == TYPE_TAPE)
+			scsi_tape_reset_clear(devip);
 	}
 
 	if (sdebug_fail_lun_reset(SCpnt)) {
@@ -6923,7 +6929,8 @@ static int scsi_debug_target_reset(struct scsi_cmnd *SCpnt)
 	list_for_each_entry(devip, &sdbg_host->dev_info_list, dev_list) {
 		if (devip->target == sdp->id) {
 			set_bit(SDEBUG_UA_BUS_RESET, devip->uas_bm);
-			scsi_tape_reset_clear(devip);
+			if (SCpnt->device->type == TYPE_TAPE)
+				scsi_tape_reset_clear(devip);
 			++k;
 		}
 	}
@@ -6955,7 +6962,8 @@ static int scsi_debug_bus_reset(struct scsi_cmnd *SCpnt)
 
 	list_for_each_entry(devip, &sdbg_host->dev_info_list, dev_list) {
 		set_bit(SDEBUG_UA_BUS_RESET, devip->uas_bm);
-		scsi_tape_reset_clear(devip);
+		if (SCpnt->device->type == TYPE_TAPE)
+			scsi_tape_reset_clear(devip);
 		++k;
 	}
 
@@ -6979,7 +6987,8 @@ static int scsi_debug_host_reset(struct scsi_cmnd *SCpnt)
 		list_for_each_entry(devip, &sdbg_host->dev_info_list,
 				    dev_list) {
 			set_bit(SDEBUG_UA_BUS_RESET, devip->uas_bm);
-			scsi_tape_reset_clear(devip);
+			if (SCpnt->device->type == TYPE_TAPE)
+				scsi_tape_reset_clear(devip);
 			++k;
 		}
 	}
-- 
2.43.0


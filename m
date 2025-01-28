Received: from fgw23-4.mail.saunalahti.fi (fgw23-4.mail.saunalahti.fi [62.142.5.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9869D19F11B
	for <linux-scsi@vger.kernel.org>; Tue, 28 Jan 2025 14:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.142.5.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738074193; cv=none; b=hrPNWuNIJJdNqUxBq+4wHQP2P7dgOmo2QGrYCHCRWqmRRVr97utvpFFzIoP93HMvqY0GVSxLCPyBeEP7gTAu6BDzZ17b+pogWthIXrU8SssI3ftTov5T4nK4g94dXvaUEgM4XNABXCzQdzFULsspRskxHctj7RNIdpJSr1ewZW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738074193; c=relaxed/simple;
	bh=2M6k+DsYAMJCPOVzvlVP2VtfhES06yIndeT5+90aXnI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QYgxjM2aukk/eACEZN/ULT2AQOSr4wM42lLWIgpvE5qhJ0UBlsilOSNxEfbpxG1RkCwornUae+ukKcm8lGwVdxhjJccLLLxDaGYBj0/smUJAp6zAhZjxJbSMGsJhlbN3Z5aRc0h8u6ZvYlDY40w5QCd++9MmZlE2zK6HSobfQ4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi; spf=pass smtp.mailfrom=kolumbus.fi; dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b=DK8K2g6G; arc=none smtp.client-ip=62.142.5.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b="DK8K2g6G"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=kolumbus.fi; s=elisa1;
	h=content-transfer-encoding:content-type:mime-version:references:in-reply-to:
	 message-id:date:subject:cc:to:from:from:to:cc:reply-to:subject:date:
	 in-reply-to:references:list-archive:list-subscribe:list-unsubscribe:
	 content-type:content-transfer-encoding:message-id;
	bh=xAgNlQZX/jDGUIhfy3hB7tnSWYPmrrVRICUvmeVtmR0=;
	b=DK8K2g6Gfi2a5a9RF2+GMUS/7XiNbm3FE8euvI1PcibhGSm70g4I2Qy8vwm+VKWTiYGULym6cj5wd
	 PVlXJxM9l/LDdeN5ebQdBGK3SpXG5HSo/PLVNkA3BTk97DBnz6TRpx/Hzj3bCxHfcg1uOX/pfVaFJ1
	 WKXcVLLCygcHTGUxr0V4rBd0vdVogRGVep9Z3y7dZFb2xilrFwK9v6dvSOqFTFPrIPDgnBtfEK+qaW
	 xoglp61PQCApY1QMx4IDQyqeAiqfzsb+iwivKxxg2UjXne1hhJKDo5jdwzkv2bNZ05i1Ny+vFDJr+B
	 sLPCo9XOWRAXb0KduP92lOs4YufAPmw==
Received: from kaipn1.makisara.private (85-156-116-90.elisa-laajakaista.fi [85.156.116.90])
	by fgw23.mail.saunalahti.fi (Halon) with ESMTPSA
	id 649cf8df-dd83-11ef-a25c-005056bdfda7;
	Tue, 28 Jan 2025 16:23:07 +0200 (EET)
From: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
To: linux-scsi@vger.kernel.org,
	dgilbert@interlog.com
Cc: jmeneghi@redhat.com,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
Subject: [RFC PATCH 1/6] scsi: scsi_debug: First fixes for tapes
Date: Tue, 28 Jan 2025 16:22:45 +0200
Message-ID: <20250128142250.163901-2-Kai.Makisara@kolumbus.fi>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250128142250.163901-1-Kai.Makisara@kolumbus.fi>
References: <20250128142250.163901-1-Kai.Makisara@kolumbus.fi>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Patch includes the following:
- enable MODE SENSE/SELECT without actual page (to read/write only
  the Block Descriptor)
- store the density code and block size in the Block Descriptor
- fix REWIND not to use the wrong page filling function

Signed-off-by: Kai Mäkisara <Kai.Makisara@kolumbus.fi>
---
 drivers/scsi/scsi_debug.c | 38 +++++++++++++++++++++++++++++++++-----
 1 file changed, 33 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 680ba180a672..00daa77f636c 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -173,6 +173,10 @@ static const char *sdebug_version_date = "20210520";
 #define DEF_ZBC_MAX_OPEN_ZONES	8
 #define DEF_ZBC_NR_CONV_ZONES	1
 
+/* Default parameters for tape drives */
+#define TAPE_DEF_DENSITY  0x0
+#define TAPE_DEF_BLKSIZE  0
+
 #define SDEBUG_LUN_0_VAL 0
 
 /* bit mask values for sdebug_opts */
@@ -363,6 +367,10 @@ struct sdebug_dev_info {
 	ktime_t create_ts;	/* time since bootup that this device was created */
 	struct sdeb_zone_state *zstate;
 
+	/* For tapes */
+	unsigned int tape_blksize;
+	unsigned int tape_density;
+
 	struct dentry *debugfs_entry;
 	struct spinlock list_lock;
 	struct list_head inject_err_list;
@@ -773,7 +781,7 @@ static const struct opcode_info_t opcode_info_arr[SDEB_I_LAST_ELEM_P1 + 1] = {
 /* 20 */
 	{0, 0x1e, 0, 0, NULL, NULL, /* ALLOW REMOVAL */
 	    {6,  0, 0, 0, 0x3, 0xc7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
-	{0, 0x1, 0, 0, resp_start_stop, NULL, /* REWIND ?? */
+	{0, 0x1, 0, 0, NULL, NULL, /* REWIND ?? */
 	    {6,  0x1, 0, 0, 0, 0xc7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
 	{0, 0, 0, F_INV_OP | FF_RESPOND, NULL, NULL, /* ATA_PT */
 	    {0,  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
@@ -2742,7 +2750,7 @@ static int resp_mode_sense(struct scsi_cmnd *scp,
 	unsigned char *ap;
 	unsigned char *arr __free(kfree);
 	unsigned char *cmd = scp->cmnd;
-	bool dbd, llbaa, msense_6, is_disk, is_zbc;
+	bool dbd, llbaa, msense_6, is_disk, is_zbc, is_tape;
 
 	arr = kzalloc(SDEBUG_MAX_MSENSE_SZ, GFP_ATOMIC);
 	if (!arr)
@@ -2755,7 +2763,8 @@ static int resp_mode_sense(struct scsi_cmnd *scp,
 	llbaa = msense_6 ? false : !!(cmd[1] & 0x10);
 	is_disk = (sdebug_ptype == TYPE_DISK);
 	is_zbc = devip->zoned;
-	if ((is_disk || is_zbc) && !dbd)
+	is_tape = (sdebug_ptype == TYPE_TAPE);
+	if ((is_disk || is_zbc || is_tape) && !dbd)
 		bd_len = llbaa ? 16 : 8;
 	else
 		bd_len = 0;
@@ -2793,7 +2802,11 @@ static int resp_mode_sense(struct scsi_cmnd *scp,
 			put_unaligned_be32(0xffffffff, ap + 0);
 		else
 			put_unaligned_be32(sdebug_capacity, ap + 0);
-		put_unaligned_be16(sdebug_sector_size, ap + 6);
+		if (is_tape) {
+			ap[0] = devip->tape_density;
+			put_unaligned_be16(devip->tape_blksize, ap + 6);
+		} else
+			put_unaligned_be16(sdebug_sector_size, ap + 6);
 		offset += bd_len;
 		ap = arr + offset;
 	} else if (16 == bd_len) {
@@ -2802,6 +2815,8 @@ static int resp_mode_sense(struct scsi_cmnd *scp,
 		offset += bd_len;
 		ap = arr + offset;
 	}
+	if (cmd[2] == 0)
+		goto only_bd; /* Only block descriptor requested */
 
 	/*
 	 * N.B. If len>0 before resp_*_pg() call, then form of that call should be:
@@ -2902,6 +2917,7 @@ static int resp_mode_sense(struct scsi_cmnd *scp,
 	default:
 		goto bad_pcode;
 	}
+only_bd:
 	if (msense_6)
 		arr[0] = offset - 1;
 	else
@@ -2945,7 +2961,14 @@ static int resp_mode_select(struct scsi_cmnd *scp,
 			    __func__, param_len, res);
 	md_len = mselect6 ? (arr[0] + 1) : (get_unaligned_be16(arr + 0) + 2);
 	bd_len = mselect6 ? arr[3] : get_unaligned_be16(arr + 6);
-	off = bd_len + (mselect6 ? 4 : 8);
+	off = (mselect6 ? 4 : 8);
+	if (sdebug_ptype == TYPE_TAPE) {
+		devip->tape_density = arr[off];
+		devip->tape_blksize = get_unaligned_be16(arr + off + 6);
+	}
+	off += bd_len;
+	if (res <= off)
+		goto only_bd; /* No page written, just descriptors */
 	if (md_len > 2 || off >= res) {
 		mk_sense_invalid_fld(scp, SDEB_IN_DATA, 0, -1);
 		return check_condition_result;
@@ -2998,6 +3021,7 @@ static int resp_mode_select(struct scsi_cmnd *scp,
 	return check_condition_result;
 set_mode_changed_ua:
 	set_bit(SDEBUG_UA_MODE_CHANGED, devip->uas_bm);
+only_bd:
 	return 0;
 }
 
@@ -5835,6 +5859,10 @@ static struct sdebug_dev_info *sdebug_device_create(
 		} else {
 			devip->zoned = false;
 		}
+		if (sdebug_ptype == TYPE_TAPE) {
+			devip->tape_density = TAPE_DEF_DENSITY;
+			devip->tape_blksize = TAPE_DEF_BLKSIZE;
+		}
 		devip->create_ts = ktime_get_boottime();
 		atomic_set(&devip->stopped, (sdeb_tur_ms_to_ready > 0 ? 2 : 0));
 		spin_lock_init(&devip->list_lock);
-- 
2.43.0


Received: from fgw20-4.mail.saunalahti.fi (fgw20-4.mail.saunalahti.fi [62.142.5.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBC3C1F1908
	for <linux-scsi@vger.kernel.org>; Tue, 11 Feb 2025 14:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.142.5.107
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739283117; cv=none; b=XENg+JidAhKSQFB4tyU+C7/AiU8gOA6t7MHdPar0SpIUheeYSb+fIPuhqv02J/opAxg8lKzgoMHyBZ4tRa9kMUB9dy5BEDME8ZTew8rt/e0lCCVvZ8Yg1Y98oIR7i6YkcHK/k67S0iNzX+fSTNUO2RuZZOq5MVjnAO7C7kGFias=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739283117; c=relaxed/simple;
	bh=3wygPu782PpPk7An9T28IbdI+79vM76Nk1+qzDL12Hk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KE0/EQm8YKsATgdettkhJFtdEwMZdyF3fWFgJMDnB5FQt+pK2ZnFiqcAL3MAwh8ZZiy2ndX0SO57tvFFIo/8ZgIZ2jl17w0nWCxL0VD95fCy1wFF0H8jVZH3B70R/EyeRyqviGZGKZ8lKj2yfT84n52KzFJScWC8gizofTx3qCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi; spf=pass smtp.mailfrom=kolumbus.fi; dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b=T+k/UxRT; arc=none smtp.client-ip=62.142.5.107
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b="T+k/UxRT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=kolumbus.fi; s=elisa1;
	h=content-transfer-encoding:content-type:mime-version:references:in-reply-to:
	 message-id:date:subject:cc:to:from:from:to:cc:reply-to:subject:date:
	 in-reply-to:references:list-archive:list-subscribe:list-unsubscribe:
	 content-type:content-transfer-encoding:message-id;
	bh=3/QDaSf52kvdvjN+SF+IoSctPrtKulqRyTaKxtBe3t0=;
	b=T+k/UxRTw3eunYlyPAYgDHFXznb+DQ4HAMXrPiJv8PVuZ73dV+DMWxw8egqyvC+FJNy6C3555SN5M
	 75oAa8nWytH542ZaVYRM9diVNCkxv8D2xcApmlVMn1712lowfDZAh6a5rBPwHBc669HBeq1BJkDZ9n
	 T6x0LMyH2RB0VqL6+fZhKCtcZJi1bfcv+0/mqbdLaHXnjHv4AB1MhbLqfcgKwUZUSfRx8TNb+kc+rR
	 NMnyOipCqdVX+Ejp08hG45OY4/CntZcd0CV9Bufco6Sxus88jZusHwZbMB3I/6CE49FhxLYd/OLXUE
	 Gr/5txmweun5ffOMeshGfTBEKDWVerw==
Received: from kaipn1.makisara.private (85-156-116-90.elisa-laajakaista.fi [85.156.116.90])
	by fgw23.mail.saunalahti.fi (Halon) with ESMTPSA
	id 22170d01-e882-11ef-a280-005056bdfda7;
	Tue, 11 Feb 2025 16:11:49 +0200 (EET)
From: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
To: linux-scsi@vger.kernel.org,
	dgilbert@interlog.com
Cc: martin.petersen@oracle.com,
	James.Bottomley@HansenPartnership.com,
	jmeneghi@redhat.com,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
Subject: [PATCH v1b 2/7] scsi: scsi_debug: Add READ BLOCK LIMITS and modify LOAD for tapes
Date: Tue, 11 Feb 2025 16:11:31 +0200
Message-ID: <20250211141132.3532-1-Kai.Makisara@kolumbus.fi>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250210191232.185207-3-Kai.Makisara@kolumbus.fi>
References: <20250210191232.185207-3-Kai.Makisara@kolumbus.fi>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The changes:
- add READ BLOCK LIMITS (512 - 1048576 bytes)
- make LOAD send New Media UA (not correct by the standard, but
  makes possible to test also this UA)

Signed-off-by: Kai Mäkisara <Kai.Makisara@kolumbus.fi>
---
v1 -> v1b:
- change 'len +=' to 'len =' to fix the bug reported by the Kernel Test Robot

 drivers/scsi/scsi_debug.c | 127 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 121 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 4da0c259390b..21c64f79797a 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -80,6 +80,7 @@ static const char *sdebug_version_date = "20210520";
 #define INVALID_FIELD_IN_CDB 0x24
 #define INVALID_FIELD_IN_PARAM_LIST 0x26
 #define WRITE_PROTECTED 0x27
+#define UA_READY_ASC 0x28
 #define UA_RESET_ASC 0x29
 #define UA_CHANGED_ASC 0x2a
 #define TARGET_CHANGED_ASC 0x3f
@@ -175,7 +176,11 @@ static const char *sdebug_version_date = "20210520";
 
 /* Default parameters for tape drives */
 #define TAPE_DEF_DENSITY  0x0
+#define TAPE_BAD_DENSITY  0x65
 #define TAPE_DEF_BLKSIZE  0
+#define TAPE_MIN_BLKSIZE  512
+#define TAPE_MAX_BLKSIZE  1048576
+#define TAPE_MAX_PARTITIONS 2
 
 #define SDEBUG_LUN_0_VAL 0
 
@@ -220,7 +225,8 @@ static const char *sdebug_version_date = "20210520";
 #define SDEBUG_UA_LUNS_CHANGED 5
 #define SDEBUG_UA_MICROCODE_CHANGED 6	/* simulate firmware change */
 #define SDEBUG_UA_MICROCODE_CHANGED_WO_RESET 7
-#define SDEBUG_NUM_UAS 8
+#define SDEBUG_UA_NOT_READY_TO_READY 8
+#define SDEBUG_NUM_UAS 9
 
 /* when 1==SDEBUG_OPT_MEDIUM_ERR, a medium error is simulated at this
  * sector on read commands: */
@@ -370,6 +376,8 @@ struct sdebug_dev_info {
 	/* For tapes */
 	unsigned int tape_blksize;
 	unsigned int tape_density;
+	unsigned char tape_partition;
+	unsigned int tape_location[TAPE_MAX_PARTITIONS];
 
 	struct dentry *debugfs_entry;
 	struct spinlock list_lock;
@@ -491,14 +499,16 @@ enum sdeb_opcode_index {
 	SDEB_I_ZONE_OUT = 30,		/* 0x94+SA; includes no data xfer */
 	SDEB_I_ZONE_IN = 31,		/* 0x95+SA; all have data-in */
 	SDEB_I_ATOMIC_WRITE_16 = 32,
-	SDEB_I_LAST_ELEM_P1 = 33,	/* keep this last (previous + 1) */
+	SDEB_I_READ_BLOCK_LIMITS = 33,
+	SDEB_I_LOCATE = 34,
+	SDEB_I_LAST_ELEM_P1 = 35,	/* keep this last (previous + 1) */
 };
 
 
 static const unsigned char opcode_ind_arr[256] = {
 /* 0x0; 0x0->0x1f: 6 byte cdbs */
 	SDEB_I_TEST_UNIT_READY, SDEB_I_REZERO_UNIT, 0, SDEB_I_REQUEST_SENSE,
-	    0, 0, 0, 0,
+	    0, SDEB_I_READ_BLOCK_LIMITS, 0, 0,
 	SDEB_I_READ, 0, SDEB_I_WRITE, 0, 0, 0, 0, 0,
 	0, 0, SDEB_I_INQUIRY, 0, 0, SDEB_I_MODE_SELECT, SDEB_I_RESERVE,
 	    SDEB_I_RELEASE,
@@ -506,7 +516,7 @@ static const unsigned char opcode_ind_arr[256] = {
 	    SDEB_I_ALLOW_REMOVAL, 0,
 /* 0x20; 0x20->0x3f: 10 byte cdbs */
 	0, 0, 0, 0, 0, SDEB_I_READ_CAPACITY, 0, 0,
-	SDEB_I_READ, 0, SDEB_I_WRITE, 0, 0, 0, 0, SDEB_I_VERIFY,
+	SDEB_I_READ, 0, SDEB_I_WRITE, SDEB_I_LOCATE, 0, 0, 0, SDEB_I_VERIFY,
 	0, 0, 0, 0, SDEB_I_PRE_FETCH, SDEB_I_SYNC_CACHE, 0, 0,
 	0, 0, 0, SDEB_I_WRITE_BUFFER, 0, 0, 0, 0,
 /* 0x40; 0x40->0x5f: 10 byte cdbs */
@@ -581,6 +591,8 @@ static int resp_open_zone(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_close_zone(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_finish_zone(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_rwp_zone(struct scsi_cmnd *, struct sdebug_dev_info *);
+static int resp_read_blklimits(struct scsi_cmnd *, struct sdebug_dev_info *);
+static int resp_locate(struct scsi_cmnd *, struct sdebug_dev_info *);
 
 static int sdebug_do_add_host(bool mk_new_store);
 static int sdebug_add_host_helper(int per_host_idx);
@@ -808,6 +820,7 @@ static const struct opcode_info_t opcode_info_arr[SDEB_I_LAST_ELEM_P1 + 1] = {
 	    resp_pre_fetch, pre_fetch_iarr,
 	    {10,  0x2, 0xff, 0xff, 0xff, 0xff, 0x3f, 0xff, 0xff, 0xc7, 0, 0,
 	     0, 0, 0, 0} },			/* PRE-FETCH (10) */
+						/* READ POSITION (10) */
 
 /* 30 */
 	{ARRAY_SIZE(zone_out_iarr), 0x94, 0x3, F_SA_LOW | F_M_ACCESS,
@@ -823,6 +836,12 @@ static const struct opcode_info_t opcode_info_arr[SDEB_I_LAST_ELEM_P1 + 1] = {
 	    resp_atomic_write, NULL, /* ATOMIC WRITE 16 */
 		{16,  0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
 		 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff} },
+	{0, 0x05, 0, F_D_IN, resp_read_blklimits, NULL,    /* READ BLOCK LIMITS (6) */
+	    {6,  0, 0, 0, 0, 0xc7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
+	{0, 0x2b, 0, F_D_UNKN, resp_locate, NULL,    /* LOCATE (10) */
+	    {10,  0x2, 0xff, 0xff, 0xff, 0xff, 0x3f, 0xff, 0xff, 0xc7, 0, 0,
+	     0, 0, 0, 0} },
+
 /* sentinel */
 	{0xff, 0, 0, 0, NULL, NULL,		/* terminating element */
 	    {0,  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
@@ -1501,6 +1520,12 @@ static int make_ua(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 			if (sdebug_verbose)
 				cp = "reported luns data has changed";
 			break;
+		case SDEBUG_UA_NOT_READY_TO_READY:
+			mk_sense_buffer(scp, UNIT_ATTENTION, UA_READY_ASC,
+					0);
+			if (sdebug_verbose)
+				cp = "not ready to ready transition/media change";
+			break;
 		default:
 			pr_warn("unexpected unit attention code=%d\n", k);
 			if (sdebug_verbose)
@@ -2204,6 +2229,14 @@ static int resp_start_stop(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	changing = (stopped_state != want_stop);
 	if (changing)
 		atomic_xchg(&devip->stopped, want_stop);
+	if (sdebug_ptype == TYPE_TAPE && !want_stop) {
+		int i;
+
+		set_bit(SDEBUG_UA_NOT_READY_TO_READY, devip->uas_bm); /* not legal! */
+		for (i = 0; i < TAPE_MAX_PARTITIONS; i++)
+			devip->tape_location[i] = 0;
+		devip->tape_partition = 0;
+	}
 	if (!changing || (cmd[1] & 0x1))  /* state unchanged or IMMED bit set in cdb */
 		return SDEG_RES_IMMED_MASK;
 	else
@@ -2736,6 +2769,17 @@ static int resp_sas_sha_m_spg(unsigned char *p, int pcontrol)
 	return sizeof(sas_sha_m_pg);
 }
 
+static unsigned char partition_pg[] = {0x11, 12, 1, 0, 0x24, 3, 9, 0,
+	0xff, 0xff, 0x00, 0x00};
+
+static int resp_partition_m_pg(unsigned char *p, int pcontrol, int target)
+{	/* Partition page for mode_sense (tape) */
+	memcpy(p, partition_pg, sizeof(partition_pg));
+	if (pcontrol == 1)
+		memset(p + 2, 0, sizeof(partition_pg) - 2);
+	return sizeof(partition_pg);
+}
+
 /* PAGE_SIZE is more than necessary but provides room for future expansion. */
 #define SDEBUG_MAX_MSENSE_SZ PAGE_SIZE
 
@@ -2876,6 +2920,12 @@ static int resp_mode_sense(struct scsi_cmnd *scp,
 		}
 		offset += len;
 		break;
+	case 0x11:	/* Partition Mode Page (tape) */
+		if (!is_tape)
+			goto bad_pcode;
+		len = resp_partition_m_pg(ap, pcontrol, target);
+		offset += len;
+		break;
 	case 0x19:	/* if spc==1 then sas phy, control+discover */
 		if (subpcode > 0x2 && subpcode < 0xff)
 			goto bad_subpcode;
@@ -2974,9 +3024,16 @@ static int resp_mode_select(struct scsi_cmnd *scp,
 					mselect6 ? 3 : 6, -1);
 			return check_condition_result;
 		}
+		if (arr[off] == TAPE_BAD_DENSITY) {
+			mk_sense_invalid_fld(scp, SDEB_IN_DATA, 0, -1);
+			return check_condition_result;
+		}
 		blksize = get_unaligned_be16(arr + off + 6);
-		if ((blksize % 4) != 0) {
-			mk_sense_invalid_fld(scp, SDEB_IN_DATA, off + 6, -1);
+		if (blksize != 0 &&
+			(blksize < TAPE_MIN_BLKSIZE ||
+				blksize > TAPE_MAX_BLKSIZE ||
+				(blksize % 4) != 0)) {
+			mk_sense_invalid_fld(scp, SDEB_IN_DATA, 1, -1);
 			return check_condition_result;
 		}
 		devip->tape_density = arr[off];
@@ -3177,6 +3234,36 @@ static int resp_log_sense(struct scsi_cmnd *scp,
 		    min_t(u32, len, SDEBUG_MAX_INQ_ARR_SZ));
 }
 
+enum {SDEBUG_READ_BLOCK_LIMITS_ARR_SZ = 6};
+static int resp_read_blklimits(struct scsi_cmnd *scp,
+			struct sdebug_dev_info *devip)
+{
+	unsigned char arr[SDEBUG_READ_BLOCK_LIMITS_ARR_SZ];
+
+	arr[0] = 4;
+	put_unaligned_be24(TAPE_MAX_BLKSIZE, arr + 1);
+	put_unaligned_be16(TAPE_MIN_BLKSIZE, arr + 4);
+	return fill_from_dev_buffer(scp, arr, SDEBUG_READ_BLOCK_LIMITS_ARR_SZ);
+}
+
+static int resp_locate(struct scsi_cmnd *scp,
+		struct sdebug_dev_info *devip)
+{
+	unsigned char *cmd = scp->cmnd;
+
+	if ((cmd[1] & 0x02) != 0) {
+		if (cmd[8] >= TAPE_MAX_PARTITIONS) {
+			mk_sense_invalid_fld(scp, SDEB_IN_CDB, 8, -1);
+			return check_condition_result;
+		}
+		devip->tape_partition = cmd[8];
+	}
+	devip->tape_location[devip->tape_partition] =
+		get_unaligned_be32(cmd + 3);
+
+	return 0;
+}
+
 static inline bool sdebug_dev_is_zoned(struct sdebug_dev_info *devip)
 {
 	return devip->nr_zones != 0;
@@ -4957,7 +5044,10 @@ static int resp_sync_cache(struct scsi_cmnd *scp,
  * a GOOD status otherwise. Model a disk with a big cache and yield
  * CONDITION MET. Actually tries to bring range in main memory into the
  * cache associated with the CPU(s).
+ *
+ * The pcode 0x34 is also used for READ POSITION by tape devices.
  */
+enum {SDEBUG_READ_POSITION_ARR_SZ = 20};
 static int resp_pre_fetch(struct scsi_cmnd *scp,
 			  struct sdebug_dev_info *devip)
 {
@@ -4969,6 +5059,31 @@ static int resp_pre_fetch(struct scsi_cmnd *scp,
 	struct sdeb_store_info *sip = devip2sip(devip, true);
 	u8 *fsp = sip->storep;
 
+	if (sdebug_ptype == TYPE_TAPE) {
+		if (cmd[0] == PRE_FETCH) { /* READ POSITION (10) */
+			int all_length;
+			unsigned char arr[20];
+			unsigned int pos;
+
+			all_length = get_unaligned_be16(cmd + 7);
+			if ((cmd[1] & 0xfe) != 0 ||
+				all_length != 0) { /* only short form */
+				mk_sense_invalid_fld(scp, SDEB_IN_CDB,
+						all_length ? 7 : 1, 0);
+				return check_condition_result;
+			}
+			memset(arr, 0, SDEBUG_READ_POSITION_ARR_SZ);
+			arr[1] = devip->tape_partition;
+			pos = devip->tape_location[devip->tape_partition];
+			put_unaligned_be32(pos, arr + 4);
+			put_unaligned_be32(pos, arr + 8);
+			return fill_from_dev_buffer(scp, arr,
+						SDEBUG_READ_POSITION_ARR_SZ);
+		}
+		mk_sense_invalid_opcode(scp);
+		return check_condition_result;
+	}
+
 	if (cmd[0] == PRE_FETCH) {	/* 10 byte cdb */
 		lba = get_unaligned_be32(cmd + 2);
 		nblks = get_unaligned_be16(cmd + 7);
-- 
2.43.0


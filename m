Received: from fgw23-4.mail.saunalahti.fi (fgw23-4.mail.saunalahti.fi [62.142.5.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAFA02571D3
	for <linux-scsi@vger.kernel.org>; Fri, 28 Feb 2025 12:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.142.5.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740746882; cv=none; b=KGkvIGmNqFLhfFbEqqvlVZDpytGbzu/lw9VfpR99IpUvWceVuZ1I+9IlETnGamt+oYa2rR8EzZnx7922SwJyRcbMgmSV/RUAPZeuCDwpAngb8HJyuNCfN7+lET4SvbwP4o41oeEDgpx+pczz0+wB2Xw9i/zj25Phbkgp5IKQtNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740746882; c=relaxed/simple;
	bh=NsXsu5z3QCEP1r4d2OoY7QdY1IxvmR2lFszYFG5SChM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YaAH7eJZwr2KpJbWluWm4FGqU76Blf6g1CEzKTOSs33CrXofeq0zweMweWTpIHwCFOiO8Gh5A8SyD4DE7/n58q2EEe7AETu3RdjmS2cNYwJXD+STvudhULNSa+hsazEgLj9bAYQDabC1C78i2ng1jcvr57r9u+VuYkuNlOW/rmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi; spf=pass smtp.mailfrom=kolumbus.fi; dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b=LqVvIvJh; arc=none smtp.client-ip=62.142.5.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b="LqVvIvJh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=kolumbus.fi; s=elisa1;
	h=content-transfer-encoding:content-type:mime-version:references:in-reply-to:
	 message-id:date:subject:cc:to:from:from:to:cc:reply-to:subject:date:
	 in-reply-to:references:list-archive:list-subscribe:list-unsubscribe:
	 content-type:content-transfer-encoding:message-id;
	bh=KGOhSldz5wMgFDOoWzSzEY8nz+Y6W8yOmWWhLpfHiRY=;
	b=LqVvIvJh3d56vKbIFItRhNmzzDrOm9+8edgvXWWi3RElLvEf4HS8Q/usDSqW9DFWnBGGMN/qiInNi
	 mnVZ514t1uTZ+mBMsGkzK6J33kw0UhM5NDsTBB9/63B7r/2eMnuxO0CRo5gTOipCKE1bXpHytYWhLM
	 6Gt8fgYl9nU6pgG/toKYLlj2sXTzqDptUVURWuvDuMXKMjTU0ucZCk4azDmiWapMmyWfAsPAPDiBTw
	 rm+EKFEu02Ie74tRKYG0nXrsqO+BpWgV54VSiXGDu+FvZUfP9QuD3BxifvNRO/wNtvLqJRrRl9Y7xQ
	 55M4e17V13xqbl8bImWHraaxZjznDyg==
Received: from kaipn1.makisara.private (85-156-116-90.elisa-laajakaista.fi [85.156.116.90])
	by fgw23.mail.saunalahti.fi (Halon) with ESMTPSA
	id 13f16736-f5d2-11ef-a2a5-005056bdfda7;
	Fri, 28 Feb 2025 14:46:49 +0200 (EET)
From: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
To: linux-scsi@vger.kernel.org,
	dgilbert@interlog.com
Cc: martin.petersen@oracle.com,
	James.Bottomley@HansenPartnership.com,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
Subject: [PATCH 3/4] scsi: scsi_debug: Move some tape-specific commands to separate definitions
Date: Fri, 28 Feb 2025 14:46:26 +0200
Message-ID: <20250228124627.177873-5-Kai.Makisara@kolumbus.fi>
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

New definitions (struct opcode_info_t) are created for READ(6),
WRITE(6), READ POSITION(10) for tape devices.

Signed-off-by: Kai Mäkisara <Kai.Makisara@kolumbus.fi>
---
 drivers/scsi/scsi_debug.c | 77 +++++++++++++++++++--------------------
 1 file changed, 38 insertions(+), 39 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 58f29b877362..15f24d11be05 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -594,7 +594,9 @@ static int resp_mode_select(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_log_sense(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_readcap(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_read_dt0(struct scsi_cmnd *, struct sdebug_dev_info *);
+static int resp_read_tape(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_write_dt0(struct scsi_cmnd *, struct sdebug_dev_info *);
+static int resp_write_tape(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_write_scat(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_start_stop(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_readcap16(struct scsi_cmnd *, struct sdebug_dev_info *);
@@ -622,6 +624,7 @@ static int resp_read_blklimits(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_locate(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_write_filemarks(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_space(struct scsi_cmnd *, struct sdebug_dev_info *);
+static int resp_read_position(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_rewind(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_format_medium(struct scsi_cmnd *, struct sdebug_dev_info *);
 
@@ -651,8 +654,10 @@ static const struct opcode_info_t read_iarr[] = {
 	{0, 0x28, 0, DS_NO_SSC, F_D_IN | FF_MEDIA_IO, resp_read_dt0, NULL,/* READ(10) */
 	    {10,  0xff, 0xff, 0xff, 0xff, 0xff, 0x3f, 0xff, 0xff, 0xc7, 0, 0,
 	     0, 0, 0, 0} },
-	{0, 0x8, 0, DS_ALL, F_D_IN | FF_MEDIA_IO, resp_read_dt0, NULL, /* READ(6) */
+	{0, 0x8, 0, DS_NO_SSC, F_D_IN | FF_MEDIA_IO, resp_read_dt0, NULL, /* READ(6) disk */
 	    {6,  0xff, 0xff, 0xff, 0xff, 0xc7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
+	{0, 0x8, 0, DS_SSC, F_D_IN | FF_MEDIA_IO, resp_read_tape, NULL, /* READ(6) tape */
+	    {6,  0x03, 0xff, 0xff, 0xff, 0xc7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
 	{0, 0xa8, 0, DS_NO_SSC, F_D_IN | FF_MEDIA_IO, resp_read_dt0, NULL,/* READ(12) */
 	    {12,  0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xbf,
 	     0xc7, 0, 0, 0, 0} },
@@ -662,9 +667,12 @@ static const struct opcode_info_t write_iarr[] = {
 	{0, 0x2a, 0, DS_NO_SSC, F_D_OUT | FF_MEDIA_IO, resp_write_dt0,  /* WRITE(10) */
 	    NULL, {10,  0xfb, 0xff, 0xff, 0xff, 0xff, 0x3f, 0xff, 0xff, 0xc7,
 		   0, 0, 0, 0, 0, 0} },
-	{0, 0xa, 0, DS_ALL, F_D_OUT | FF_MEDIA_IO, resp_write_dt0,   /* WRITE(6) */
+	{0, 0xa, 0, DS_NO_SSC, F_D_OUT | FF_MEDIA_IO, resp_write_dt0, /* WRITE(6) disk */
 	    NULL, {6,  0xff, 0xff, 0xff, 0xff, 0xc7, 0, 0, 0, 0, 0, 0, 0,
 		   0, 0, 0} },
+	{0, 0xa, 0, DS_SSC, F_D_OUT | FF_MEDIA_IO, resp_write_tape, /* WRITE(6) tape */
+	    NULL, {6,  0x01, 0xff, 0xff, 0xff, 0xc7, 0, 0, 0, 0, 0, 0, 0,
+		   0, 0, 0} },
 	{0, 0xaa, 0, DS_NO_SSC, F_D_OUT | FF_MEDIA_IO, resp_write_dt0,  /* WRITE(12) */
 	    NULL, {12,  0xfb, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
 		   0xbf, 0xc7, 0, 0, 0, 0} },
@@ -729,6 +737,9 @@ static const struct opcode_info_t pre_fetch_iarr[] = {
 	{0, 0x90, 0, DS_NO_SSC, F_SYNC_DELAY | FF_MEDIA_IO, resp_pre_fetch, NULL,
 	    {16,  0x2, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
 	     0xff, 0xff, 0xff, 0xff, 0x3f, 0xc7} },	/* PRE-FETCH (16) */
+	{0, 0x34, 0, DS_SSC, F_SYNC_DELAY | FF_MEDIA_IO, resp_read_position, NULL,
+	    {10,  0x1f, 0x00, 0x00, 0x00, 0x00, 0x00, 0xff, 0xff, 0xc7, 0, 0,
+	     0, 0, 0, 0} },				/* READ POSITION (10) */
 };
 
 static const struct opcode_info_t zone_out_iarr[] = {	/* ZONE OUT(16) */
@@ -845,7 +856,7 @@ static const struct opcode_info_t opcode_info_arr[SDEB_I_LAST_ELEM_P1 + 1] = {
 	{0, 0x89, 0, DS_NO_SSC, F_D_OUT | FF_MEDIA_IO, resp_comp_write, NULL,
 	    {16,  0xf8, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0, 0,
 	     0, 0xff, 0x3f, 0xc7} },		/* COMPARE AND WRITE */
-	{ARRAY_SIZE(pre_fetch_iarr), 0x34, 0, DS_ALL, F_SYNC_DELAY | FF_MEDIA_IO,
+	{ARRAY_SIZE(pre_fetch_iarr), 0x34, 0, DS_NO_SSC, F_SYNC_DELAY | FF_MEDIA_IO,
 	    resp_pre_fetch, pre_fetch_iarr,
 	    {10,  0x2, 0xff, 0xff, 0xff, 0xff, 0x3f, 0xff, 0xff, 0xc7, 0, 0,
 	     0, 0, 0, 0} },			/* PRE-FETCH (10) */
@@ -3586,6 +3597,30 @@ static int resp_space(struct scsi_cmnd *scp,
 	return check_condition_result;
 }
 
+enum {SDEBUG_READ_POSITION_ARR_SZ = 20};
+static int resp_read_position(struct scsi_cmnd *scp,
+			struct sdebug_dev_info *devip)
+{
+	u8 *cmd = scp->cmnd;
+	int all_length;
+	unsigned char arr[20];
+	unsigned int pos;
+
+	all_length = get_unaligned_be16(cmd + 7);
+	if ((cmd[1] & 0xfe) != 0 ||
+		all_length != 0) { /* only short form */
+		mk_sense_invalid_fld(scp, SDEB_IN_CDB,
+				all_length ? 7 : 1, 0);
+		return check_condition_result;
+	}
+	memset(arr, 0, SDEBUG_READ_POSITION_ARR_SZ);
+	arr[1] = devip->tape_partition;
+	pos = devip->tape_location[devip->tape_partition];
+	put_unaligned_be32(pos, arr + 4);
+	put_unaligned_be32(pos, arr + 8);
+	return fill_from_dev_buffer(scp, arr, SDEBUG_READ_POSITION_ARR_SZ);
+}
+
 static int resp_rewind(struct scsi_cmnd *scp,
 		struct sdebug_dev_info *devip)
 {
@@ -3627,10 +3662,6 @@ static int resp_format_medium(struct scsi_cmnd *scp,
 	int res = 0;
 	unsigned char *cmd = scp->cmnd;
 
-	if (sdebug_ptype != TYPE_TAPE) {
-		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 0, -1);
-		return check_condition_result;
-	}
 	if (cmd[2] > 2) {
 		mk_sense_invalid_fld(scp, SDEB_IN_DATA, 2, -1);
 		return check_condition_result;
@@ -4490,9 +4521,6 @@ static int resp_read_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	u8 *cmd = scp->cmnd;
 	bool meta_data_locked = false;
 
-	if (sdebug_ptype == TYPE_TAPE)
-		return resp_read_tape(scp, devip);
-
 	switch (cmd[0]) {
 	case READ_16:
 		ei_lba = 0;
@@ -4862,9 +4890,6 @@ static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	u8 *cmd = scp->cmnd;
 	bool meta_data_locked = false;
 
-	if (sdebug_ptype == TYPE_TAPE)
-		return resp_write_tape(scp, devip);
-
 	switch (cmd[0]) {
 	case WRITE_16:
 		ei_lba = 0;
@@ -5596,7 +5621,6 @@ static int resp_sync_cache(struct scsi_cmnd *scp,
  *
  * The pcode 0x34 is also used for READ POSITION by tape devices.
  */
-enum {SDEBUG_READ_POSITION_ARR_SZ = 20};
 static int resp_pre_fetch(struct scsi_cmnd *scp,
 			  struct sdebug_dev_info *devip)
 {
@@ -5608,31 +5632,6 @@ static int resp_pre_fetch(struct scsi_cmnd *scp,
 	struct sdeb_store_info *sip = devip2sip(devip, true);
 	u8 *fsp = sip->storep;
 
-	if (sdebug_ptype == TYPE_TAPE) {
-		if (cmd[0] == PRE_FETCH) { /* READ POSITION (10) */
-			int all_length;
-			unsigned char arr[20];
-			unsigned int pos;
-
-			all_length = get_unaligned_be16(cmd + 7);
-			if ((cmd[1] & 0xfe) != 0 ||
-				all_length != 0) { /* only short form */
-				mk_sense_invalid_fld(scp, SDEB_IN_CDB,
-						all_length ? 7 : 1, 0);
-				return check_condition_result;
-			}
-			memset(arr, 0, SDEBUG_READ_POSITION_ARR_SZ);
-			arr[1] = devip->tape_partition;
-			pos = devip->tape_location[devip->tape_partition];
-			put_unaligned_be32(pos, arr + 4);
-			put_unaligned_be32(pos, arr + 8);
-			return fill_from_dev_buffer(scp, arr,
-						SDEBUG_READ_POSITION_ARR_SZ);
-		}
-		mk_sense_invalid_opcode(scp);
-		return check_condition_result;
-	}
-
 	if (cmd[0] == PRE_FETCH) {	/* 10 byte cdb */
 		lba = get_unaligned_be32(cmd + 2);
 		nblks = get_unaligned_be16(cmd + 7);
-- 
2.43.0


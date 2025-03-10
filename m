Received: from fgw21-4.mail.saunalahti.fi (fgw21-4.mail.saunalahti.fi [62.142.5.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C2A822F166
	for <linux-scsi@vger.kernel.org>; Mon, 10 Mar 2025 15:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.142.5.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741622303; cv=none; b=Atiw9Fg/mcdk9K2Icp8bHV2F1mZZkxWEPdm9Bx9ksmzEEY5p5eiTRZS9XkHsrITCSnxPm9xU3QP8qJYrLOiFzIkZQbwyx1sgSpRRV6z4UUoomSWH0nIOENXLv9HmiFTVCG91E4ZRNltf1CTLrevqw02/1QS2/XaETXjK05dN+ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741622303; c=relaxed/simple;
	bh=k/abbkI8ScMTMIKgFDbN0oLgOBq45abOic8vo7SwCAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QAInoLTj9snA0e2q7mU/lonplqT/6mz+vIErJzR5lfZV0AnqsUYnnn5tRAPeLUA2hBuqAA2gfmJ2SlvOa2pbDw6S5Ss0IW/6wWMw87vj6LhUeP37RcX4YjNSTdT37nmCZRprCbJ8K8dbIXEXW6Qc3mC8OIByA3FTaNa6CprPk2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi; spf=pass smtp.mailfrom=kolumbus.fi; dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b=kArP0vnF; arc=none smtp.client-ip=62.142.5.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b="kArP0vnF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=kolumbus.fi; s=elisa1;
	h=content-transfer-encoding:content-type:mime-version:references:in-reply-to:
	 message-id:date:subject:cc:to:from:from:to:cc:reply-to:subject:date:
	 in-reply-to:references:list-archive:list-subscribe:list-unsubscribe:
	 content-type:content-transfer-encoding:message-id;
	bh=A4Imlvcpz98dSWnv8BnUSfIv0ntlSPJZmzG+DBKd8Lc=;
	b=kArP0vnF3+OOhg97eiA8h03yuFTKdLsxtoMFlEf+zoDa48YekOfTSELVCtqwFKyFGbrzduLNUWQuy
	 +EkZk2xR2p1EfuWx7VJJhqXEGCTR7kKtW0gL4GMBegA0nOCv0/Midbw9WjuLpkT9xDrcd8MkTd1fbe
	 rlmvu9VdZJ+goL54uSkpEZDj1+2udMMcNpy+Njh2CLrXbEhoU0xJ2VoSbL1I8h5G1QzpJvdJBzsuyG
	 MKzT8JyUekNBAkAtqc//BtjDqXKp5Dr6vLUeOqo/DCfNVkuzgTynGg/BIrYqRhbgkMm0gsIVXb4aXM
	 Y8vVWCBzYeKqd5H+cr8dJo5czDdSxaA==
Received: from kaipn1.makisara.private (85-156-116-90.elisa-laajakaista.fi [85.156.116.90])
	by fgw21.mail.saunalahti.fi (Halon) with ESMTPSA
	id 50d78384-fdc8-11ef-839f-005056bdd08f;
	Mon, 10 Mar 2025 17:57:06 +0200 (EET)
From: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
To: linux-scsi@vger.kernel.org,
	dgilbert@interlog.com
Cc: martin.petersen@oracle.com,
	James.Bottomley@HansenPartnership.com,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
Subject: [PATCH v2 5/5] scsi_scsi_debug: Add ERASE for tapes
Date: Mon, 10 Mar 2025 17:55:57 +0200
Message-ID: <20250310155557.2872-6-Kai.Makisara@kolumbus.fi>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310155557.2872-1-Kai.Makisara@kolumbus.fi>
References: <20250310155557.2872-1-Kai.Makisara@kolumbus.fi>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The command ERASE (6) for tape devices is added.

Signed-off-by: Kai Mäkisara <Kai.Makisara@kolumbus.fi>
---
 drivers/scsi/scsi_debug.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index e4b336cc0a5f..de91bb18e036 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -528,7 +528,8 @@ enum sdeb_opcode_index {
 	SDEB_I_WRITE_FILEMARKS = 35,
 	SDEB_I_SPACE = 36,
 	SDEB_I_FORMAT_MEDIUM = 37,
-	SDEB_I_LAST_ELEM_P1 = 38,	/* keep this last (previous + 1) */
+	SDEB_I_ERASE = 38,
+	SDEB_I_LAST_ELEM_P1 = 39,	/* keep this last (previous + 1) */
 };
 
 
@@ -539,7 +540,7 @@ static const unsigned char opcode_ind_arr[256] = {
 	SDEB_I_READ, 0, SDEB_I_WRITE, 0, 0, 0, 0, 0,
 	SDEB_I_WRITE_FILEMARKS, SDEB_I_SPACE, SDEB_I_INQUIRY, 0, 0,
 	    SDEB_I_MODE_SELECT, SDEB_I_RESERVE, SDEB_I_RELEASE,
-	0, 0, SDEB_I_MODE_SENSE, SDEB_I_START_STOP, 0, SDEB_I_SEND_DIAG,
+	0, SDEB_I_ERASE, SDEB_I_MODE_SENSE, SDEB_I_START_STOP, 0, SDEB_I_SEND_DIAG,
 	    SDEB_I_ALLOW_REMOVAL, 0,
 /* 0x20; 0x20->0x3f: 10 byte cdbs */
 	0, 0, 0, 0, 0, SDEB_I_READ_CAPACITY, 0, 0,
@@ -627,6 +628,7 @@ static int resp_space(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_read_position(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_rewind(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_format_medium(struct scsi_cmnd *, struct sdebug_dev_info *);
+static int resp_erase(struct scsi_cmnd *, struct sdebug_dev_info *);
 
 static int sdebug_do_add_host(bool mk_new_store);
 static int sdebug_add_host_helper(int per_host_idx);
@@ -887,7 +889,9 @@ static const struct opcode_info_t opcode_info_arr[SDEB_I_LAST_ELEM_P1 + 1] = {
 	    {6,  0x07, 0xff, 0xff, 0xff, 0xc7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
 	{0, 0x4, 0, DS_SSC, 0, resp_format_medium, NULL,  /* FORMAT MEDIUM (6) */
 	    {6,  0x3, 0x7, 0, 0, 0xc7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
-/* 38 */
+	{0, 0x19, 0, DS_SSC, F_D_IN, resp_erase, NULL,    /* ERASE (6) */
+	    {6,  0x03, 0x33, 0, 0, 0xc7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
+/* 39 */
 /* sentinel */
 	{0xff, 0, 0, 0, 0, NULL, NULL,		/* terminating element */
 	    {0,  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
@@ -3692,6 +3696,19 @@ static int resp_format_medium(struct scsi_cmnd *scp,
 	return 0;
 }
 
+static int resp_erase(struct scsi_cmnd *scp,
+		struct sdebug_dev_info *devip)
+{
+	int partition = devip->tape_partition;
+	int pos = devip->tape_location[partition];
+	struct tape_block *blp;
+
+	blp = devip->tape_blocks[partition] + pos;
+	blp->fl_size = TAPE_BLOCK_EOD_FLAG;
+
+	return 0;
+}
+
 static inline bool sdebug_dev_is_zoned(struct sdebug_dev_info *devip)
 {
 	return devip->nr_zones != 0;
-- 
2.43.0


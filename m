Received: from fgw20-4.mail.saunalahti.fi (fgw20-4.mail.saunalahti.fi [62.142.5.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FDD225E446
	for <linux-scsi@vger.kernel.org>; Mon, 10 Feb 2025 19:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.142.5.107
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739214850; cv=none; b=QFfhmGYTMj3z8yxE3qczWsJ0KeEz1vdLJz+fT/th9XSGOMmezr+AJcF+sKMb8Z2rG1OtBT8b1CDhYZiGVf1ioemlT9qgtD4oSNjLEH9TXqQekVHf6b6Fuu1UZwxFTvRBZ1vpr60v1WZ28qFG+6A96txZBOj+S75BTqLyYFdhsWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739214850; c=relaxed/simple;
	bh=YnMzgrrGTHFRNSeC9OtOmHTI5f+OPlZ3b9JpXoUOztQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sjRLyeNlw80r8eJApSGWmzX81OLjlyu7EtFvR2c0XRQtedOLxWP2BIu8IjwtNCqbH5GxY9XlEEtuUEzPKyfHothD3+yXK/jLKi/X0wq5XML9FClCjLwXwz2wN2hCVRYgaaMUKQ6Z/JKHu7YnaYqCoD8wG0MaXi1etjDBhzNZUFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi; spf=pass smtp.mailfrom=kolumbus.fi; dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b=GxY5bWKk; arc=none smtp.client-ip=62.142.5.107
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b="GxY5bWKk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=kolumbus.fi; s=elisa1;
	h=content-transfer-encoding:content-type:mime-version:references:in-reply-to:
	 message-id:date:subject:cc:to:from:from:to:cc:reply-to:subject:date:
	 in-reply-to:references:list-archive:list-subscribe:list-unsubscribe:
	 content-type:content-transfer-encoding:message-id;
	bh=qj0DzGCRqFg1nIu8AxmR96KboRXll30H+CcV3RMRLr4=;
	b=GxY5bWKkhAHODqMO+7stLKgpDl4q3scyh4UW1M4ohGT4gCKfKNBlX3utiXcUWNnAVZ6Gtw72EwOMs
	 SwUhnc+WgT5p8NDo1/kGAMrtsXS7++eIBvZhFHMrEq6YksKt7QMEuvvc2QBZsAbjIKK1uiQlrTEtd6
	 PzxklEGr8URgB7TSx13orZ/xPOXPlA2TGfioZGCX8zwNaQAs1krITGPRkUD3UiL1KJg11fQ+IQ1MnC
	 ZZmEE4AQrmwYFcyyRbuQVbVJg+mQXjdpKzlShuzeyESKWDGJm04/FbwlG4jBVH76XofDXZDEj7RccZ
	 Fp+QP7mFQm47SfFeztHvH7duqS0wPlA==
Received: from kaipn1.makisara.private (85-156-116-90.elisa-laajakaista.fi [85.156.116.90])
	by fgw23.mail.saunalahti.fi (Halon) with ESMTPSA
	id 09bdeef1-e7e3-11ef-a27d-005056bdfda7;
	Mon, 10 Feb 2025 21:12:57 +0200 (EET)
From: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
To: linux-scsi@vger.kernel.org,
	dgilbert@interlog.com
Cc: martin.petersen@oracle.com,
	James.Bottomley@HansenPartnership.com,
	jmeneghi@redhat.com,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
Subject: [PATCH v1 5/7] scsi: scsi_debug: Add compression mode page for tapes
Date: Mon, 10 Feb 2025 21:12:30 +0200
Message-ID: <20250210191232.185207-6-Kai.Makisara@kolumbus.fi>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250210191232.185207-1-Kai.Makisara@kolumbus.fi>
References: <20250210191232.185207-1-Kai.Makisara@kolumbus.fi>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Add support for compression mode page. The compression status
is saved and returned. No UA is generated.

Signed-off-by: Kai Mäkisara <Kai.Makisara@kolumbus.fi>
---
 drivers/scsi/scsi_debug.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 691b573b105b..7b84acebe0fe 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -405,6 +405,7 @@ struct sdebug_dev_info {
 	unsigned int tape_density;
 	unsigned char tape_partition;
 	unsigned char tape_nbr_partitions;
+	unsigned char tape_dce;
 	unsigned int tape_location[TAPE_MAX_PARTITIONS];
 	unsigned int tape_eop[TAPE_MAX_PARTITIONS];
 	struct tape_block *tape_blocks[TAPE_MAX_PARTITIONS];
@@ -2843,6 +2844,20 @@ static int resp_partition_m_pg(unsigned char *p, int pcontrol, int target)
 	return sizeof(partition_pg);
 }
 
+static int resp_compression_m_pg(unsigned char *p, int pcontrol, int target,
+	unsigned char dce)
+{	/* Compression page for mode_sense (tape) */
+	unsigned char compression_pg[] = {0x0f, 14, 0x40, 0, 0, 0, 0, 0,
+		0, 0, 0, 0, 00, 00};
+
+	memcpy(p, compression_pg, sizeof(compression_pg));
+	if (dce)
+		p[2] |= 0x80;
+	if (pcontrol == 1)
+		memset(p + 2, 0, sizeof(compression_pg) - 2);
+	return sizeof(compression_pg);
+}
+
 /* PAGE_SIZE is more than necessary but provides room for future expansion. */
 #define SDEBUG_MAX_MSENSE_SZ PAGE_SIZE
 
@@ -2983,6 +2998,12 @@ static int resp_mode_sense(struct scsi_cmnd *scp,
 		}
 		offset += len;
 		break;
+	case 0xf:	/* Compression Mode Page (tape) */
+		if (!is_tape)
+			goto bad_pcode;
+		len += resp_compression_m_pg(ap, pcontrol, target, devip->tape_dce);
+		offset += len;
+		break;
 	case 0x11:	/* Partition Mode Page (tape) */
 		if (!is_tape)
 			goto bad_pcode;
@@ -3143,6 +3164,14 @@ static int resp_mode_select(struct scsi_cmnd *scp,
 			goto set_mode_changed_ua;
 		}
 		break;
+	case 0xf:       /* Compression mode page */
+		if (sdebug_ptype != TYPE_TAPE)
+			goto bad_pcode;
+		if ((arr[off + 2] & 0x40) != 0) {
+			devip->tape_dce = (arr[off + 2] & 0x80) != 0;
+			return 0;
+		}
+		break;
 	case 0x1c:      /* Informational Exceptions Mode page */
 		if (iec_m_pg[1] == arr[off + 1]) {
 			memcpy(iec_m_pg + 2, arr + off + 2,
@@ -3158,6 +3187,10 @@ static int resp_mode_select(struct scsi_cmnd *scp,
 set_mode_changed_ua:
 	set_bit(SDEBUG_UA_MODE_CHANGED, devip->uas_bm);
 	return 0;
+
+bad_pcode:
+	mk_sense_invalid_fld(scp, SDEB_IN_CDB, 2, 5);
+	return check_condition_result;
 }
 
 static int resp_temp_l_pg(unsigned char *arr)
-- 
2.43.0


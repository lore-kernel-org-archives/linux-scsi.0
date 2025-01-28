Received: from fgw20-4.mail.saunalahti.fi (fgw20-4.mail.saunalahti.fi [62.142.5.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3583819F11B
	for <linux-scsi@vger.kernel.org>; Tue, 28 Jan 2025 14:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.142.5.107
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738074278; cv=none; b=LSRHKU1lu8tCgieJfNL0zZkdVjRAKGawsXUFhOoBObN9s1kD3ElT5iPxs72/gEqDvx4sWT0UcWojxTDyDo8r385oQL2CfqYdO8ewzUkn48aMqXvtRnxZqaivu+6Gb7KBIZ3+VFMioEVBW+NA8kSa/GEZ6h0idfYtpjwXugKNDac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738074278; c=relaxed/simple;
	bh=mINQUpI1X+b3DHHvEgZnXyQEM0o0IDBpOu1dkt9EwGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E7yK0UcoIwiTOitl78XzKHKpdkITHaBDoVekjsWBbJkeMWL4+QqYUGhdCu97XTfEM+A/ey/IA7cjxGEm0LAur+d63ifn88n9AssngMTh7dUNKeWGykyvXK3KpVoH7Bu2BulC7ELFPXUBywbEgQQmrs77OGrpkeuMCB2vGYaUjgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi; spf=pass smtp.mailfrom=kolumbus.fi; dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b=UXLON3p2; arc=none smtp.client-ip=62.142.5.107
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b="UXLON3p2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=kolumbus.fi; s=elisa1;
	h=content-transfer-encoding:content-type:mime-version:references:in-reply-to:
	 message-id:date:subject:cc:to:from:from:to:cc:reply-to:subject:date:
	 in-reply-to:references:list-archive:list-subscribe:list-unsubscribe:
	 content-type:content-transfer-encoding:message-id;
	bh=G+RyuJJ81pSLT5gtmDqg/qBXzBTsufbLYGGhXZzNR2M=;
	b=UXLON3p2yL3zRSDjf/n6g06vrLQiOmc4nxg1twf4A0KtDCum3g4pKxxcYXkIi4JUN2r47LjDsvfv5
	 h6A1Iq6D0LOPV/aUUVaViU5qYVRwytvlCJGLHg5Ez5YrjV8h0VroJ2SLRr8rdskeqO2qLG5sWoFktz
	 LLnR9R7V7+DxkkrsSWI/55mw8vRk/ggXUEC7AZ+XBzQvc34CQtE1172UUUNKJ2IbE7Z9xw6N8hU3t/
	 UgIppqBjOnHndI7jcWOKtQYclslq0Om3Lc6XF6n3DhNE5QDVUxDp2h+tF2laAtVTKpC8z1DdWATQr8
	 fX6wF3h9n1WdKroUxYjXEF5V0fzmNkw==
Received: from kaipn1.makisara.private (85-156-116-90.elisa-laajakaista.fi [85.156.116.90])
	by fgw23.mail.saunalahti.fi (Halon) with ESMTPSA
	id 6b41b66e-dd83-11ef-a25c-005056bdfda7;
	Tue, 28 Jan 2025 16:23:18 +0200 (EET)
From: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
To: linux-scsi@vger.kernel.org,
	dgilbert@interlog.com
Cc: jmeneghi@redhat.com,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
Subject: [RFC PATCH 5/6] scsi: scsi_debug: Add compression mode page for tapes
Date: Tue, 28 Jan 2025 16:22:49 +0200
Message-ID: <20250128142250.163901-6-Kai.Makisara@kolumbus.fi>
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

Add support for compression mode page. The compression status
is saved and returned. No UA is generated.

Signed-off-by: Kai Mäkisara <Kai.Makisara@kolumbus.fi>
---
 drivers/scsi/scsi_debug.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 912b1c6cf92d..ceacf38cee71 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -405,6 +405,7 @@ struct sdebug_dev_info {
 	unsigned int tape_blksize;
 	unsigned int tape_density;
 	unsigned char tape_partition;
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
 
@@ -2979,6 +2994,12 @@ static int resp_mode_sense(struct scsi_cmnd *scp,
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
@@ -3132,6 +3153,14 @@ static int resp_mode_select(struct scsi_cmnd *scp,
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
@@ -3147,6 +3176,10 @@ static int resp_mode_select(struct scsi_cmnd *scp,
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


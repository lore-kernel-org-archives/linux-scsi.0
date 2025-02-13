Received: from fgw21-4.mail.saunalahti.fi (fgw21-4.mail.saunalahti.fi [62.142.5.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0827F20C49C
	for <linux-scsi@vger.kernel.org>; Thu, 13 Feb 2025 09:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.142.5.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739438869; cv=none; b=i7YBDNd+PO+Xhm+apUQTfD28/ki3++mXbV1Wiguyc2mUJqpY/GpHkHoBLbNT/8CgWPO88vfbmMMVNCpR9VE4oeKxOciXbHP+GzwdgCWO0tq+L/qiUWEY02AdCl/gnV/gdDyjqRCBLphNOzuq+n57k+gfLkapAufoqsQKNYT3NsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739438869; c=relaxed/simple;
	bh=LR/W6zGNfhLtX7o6Vyvigxna5bVaQxTs1yysfaNQ/QE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qxDhtCvZyxD7FDGZUdFCkDOkPnOlq63FFGzTY6wEVncdJWk2OxFsWqgUCAoPl+NEJ2QtKFNaupRXG+1HKot7cPsKMdRbWkcaftQDwQffoN8ft7xtESIk74nwsboE8EDYAWuxzm02Gjdl06VevMf20aqCersDPEtT93hAYmmTgkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi; spf=pass smtp.mailfrom=kolumbus.fi; dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b=tEdIutKi; arc=none smtp.client-ip=62.142.5.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b="tEdIutKi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=kolumbus.fi; s=elisa1;
	h=content-transfer-encoding:content-type:mime-version:references:in-reply-to:
	 message-id:date:subject:cc:to:from:from:to:cc:reply-to:subject:date:
	 in-reply-to:references:list-archive:list-subscribe:list-unsubscribe:
	 content-type:content-transfer-encoding:message-id;
	bh=kOFtz1pPFFvuYqoh7ZgMDYSFe56phLojw7HWsDUUgRU=;
	b=tEdIutKicAZNt/En7PWuLtZWePDXoFQ7HMGafVzNzm2brGR7D1a2YfLlv3TmxFVJymtNUe5SfdLWp
	 MDwpt8mkTcaNK4dPiBdEQYFzD3iz2hpxOa5EPrSj+ljIuo7yZb0tiAE4RKDh9dfSL89haIl+qiRiy5
	 ODkNPHxL0VGEAknbSrVrFTKpYrzajhEm1C+cA8I/pUS/Y6FU88xLgPJMtELaZm5xY4vyt+9+rqjvpX
	 eVYDjs/a/lm4Mt5Ij6ZLlk/RAQQ1utSwM23jokYKv3XYwsHxGnyr8YteRk0BjBntucgBCB6cLUuYGG
	 aDItgKWisSRbpWCeFdZNdJc6R2vItXw==
Received: from kaipn1.makisara.private (85-156-116-90.elisa-laajakaista.fi [85.156.116.90])
	by fgw22.mail.saunalahti.fi (Halon) with ESMTPSA
	id adc60686-e9ec-11ef-838a-005056bdf889;
	Thu, 13 Feb 2025 11:27:00 +0200 (EET)
From: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
To: linux-scsi@vger.kernel.org,
	dgilbert@interlog.com
Cc: martin.petersen@oracle.com,
	James.Bottomley@HansenPartnership.com,
	jmeneghi@redhat.com,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
Subject: [PATCH v2 5/7] scsi: scsi_debug: Add compression mode page for tapes
Date: Thu, 13 Feb 2025 11:26:34 +0200
Message-ID: <20250213092636.2510-6-Kai.Makisara@kolumbus.fi>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213092636.2510-1-Kai.Makisara@kolumbus.fi>
References: <20250213092636.2510-1-Kai.Makisara@kolumbus.fi>
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
index 29a9aea30d22..0a5cd35c41de 100644
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


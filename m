Received: from fgw23-4.mail.saunalahti.fi (fgw23-4.mail.saunalahti.fi [62.142.5.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 450F71D47B4
	for <linux-scsi@vger.kernel.org>; Fri, 15 Nov 2024 16:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.142.5.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731687647; cv=none; b=mxRqB9FMBiaDtdeKu8rmRSxGT68G1XHOkNdEgHGozk/WN+y9Ehy79h2jXvTbJ9dUldUBGgZN35gIgl1+IFVqjMW9PGzpXHekC7OdEduCExl6A7uAU34g4772yH+XZ5sPpmBhoY9c9FPs8cSQBsAnVLFMjhw3iBeEG/zKh8VG3f8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731687647; c=relaxed/simple;
	bh=CHv7/4lMmHuSaimORnAiT68tZsIPzy3UBDk0gsqA+Rc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A0tfwh9iM6g1wosYjevrKMZR91xpGfyUACjr6DOe7T7ndZanK6zppJBX9WQqcHWR6rao2bOBuY1WSNJdKtjDwlv7KoTGh2hZuLtfW4AiBD9x6CfSS9vrtdDANaCEvCJdrH8TBH/I1A5s2O8VywtDnnsMvl3bJSncTr+P+8LYL0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi; spf=pass smtp.mailfrom=kolumbus.fi; dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b=BNyelQQ8; arc=none smtp.client-ip=62.142.5.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b="BNyelQQ8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=kolumbus.fi; s=elisa1;
	h=content-transfer-encoding:content-type:mime-version:references:in-reply-to:
	 message-id:date:subject:cc:to:from:from:to:cc:reply-to:subject:date:
	 in-reply-to:references:list-archive:list-subscribe:list-unsubscribe:
	 content-type:content-transfer-encoding:message-id;
	bh=hx5TYMwxtgIqdQrP/af/RYP7Oyzzfp7c8/OQ9LlbdtQ=;
	b=BNyelQQ8ui9xOqQ1n9hjQSFriGQhgsAzDmge0VGcKO7jx6LCKf9XI9Cgg0Ka9DUYk3I7CIIUysb0T
	 eHsL2r8/8ufbU1UQrLk8xE5k9xnwTlML0FgdHfhXdyzt3IYOzxPQvStuaW/F8g3W9s4sv22BZCALhA
	 RTOH+ao+FoOA5Xhk8rb71Ut5t3GeQun0k4+ur4tCuufeVEmVryVZlVU/qzgbLUY9QODiU45A8TU+gq
	 7HVK6Wla4cWqZNk7zmQGpD0JdBkRx7p3GSL1LeJzBb7P9EwgKIeIRpNc2Y+6dbKqjfpHKzko+yOgo4
	 uEXsOplR6dg0Fo2v4vqTxBqMeNmEmsQ==
Received: from kaipn1.makisara.private (85-156-116-90.elisa-laajakaista.fi [85.156.116.90])
	by fgw20.mail.saunalahti.fi (Halon) with ESMTPSA
	id 8f46f045-a36d-11ef-9b34-005056bd6ce9;
	Fri, 15 Nov 2024 18:20:42 +0200 (EET)
From: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
To: linux-scsi@vger.kernel.org,
	jmeneghi@redhat.com
Cc: martin.petersen@oracle.com,
	James.Bottomley@HansenPartnership.com,
	loberman@redhat.com,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
Subject: [PATCH 1/2] scsi: st: Remove use of device->was_reset
Date: Fri, 15 Nov 2024 18:20:02 +0200
Message-ID: <20241115162003.3908-2-Kai.Makisara@kolumbus.fi>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115162003.3908-1-Kai.Makisara@kolumbus.fi>
References: <20241115162003.3908-1-Kai.Makisara@kolumbus.fi>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Don't use the was_reset flag set by scsi error handling. It is enough to
recognize device resets based in the UNIT ATTENTION sense data. (The
retry counts are zero and either REQ_OP_DRV_OUT or REC_OP_DRV_IN are
used to prevent retries by midlevel.)

Signed-off-by: Kai Mäkisara <Kai.Makisara@kolumbus.fi>
---
 drivers/scsi/st.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index e8ef27d7ef61..3acaa3561c81 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -163,9 +163,11 @@ static const char *st_formats[] = {
 
 static int debugging = DEBUG;
 
+/* Setting these non-zero may risk recognizing resets */
 #define MAX_RETRIES 0
 #define MAX_WRITE_RETRIES 0
 #define MAX_READY_RETRIES 0
+
 #define NO_TAPE  NOT_READY
 
 #define ST_TIMEOUT (900 * HZ)
@@ -413,10 +415,11 @@ static int st_chk_result(struct scsi_tape *STp, struct st_request * SRpnt)
 	if (cmdstatp->have_sense &&
 	    cmdstatp->sense_hdr.asc == 0 && cmdstatp->sense_hdr.ascq == 0x17)
 		STp->cleaning_req = 1; /* ASC and ASCQ => cleaning requested */
-	if (cmdstatp->have_sense && scode == UNIT_ATTENTION && cmdstatp->sense_hdr.asc == 0x29)
+	if (cmdstatp->have_sense && scode == UNIT_ATTENTION &&
+		cmdstatp->sense_hdr.asc == 0x29) {
 		STp->pos_unknown = 1; /* ASC => power on / reset */
-
-	STp->pos_unknown |= STp->device->was_reset;
+		st_printk(KERN_WARNING, STp, "Power on/reset recognized.");
+	}
 
 	if (cmdstatp->have_sense &&
 	    scode == RECOVERED_ERROR
@@ -3631,9 +3634,7 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
 				retval = (-EIO);
 				goto out;
 			}
-			reset_state(STp);
-			/* remove this when the midlevel properly clears was_reset */
-			STp->device->was_reset = 0;
+			reset_state(STp); /* Clears pos_unknown */
 		}
 
 		if (mtc.mt_op != MTNOP && mtc.mt_op != MTSETBLK &&
-- 
2.43.0


Received: from fgw20-4.mail.saunalahti.fi (fgw20-4.mail.saunalahti.fi [62.142.5.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E172A1EEA51
	for <linux-scsi@vger.kernel.org>; Mon, 20 Jan 2025 19:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.142.5.107
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737402622; cv=none; b=a2wgGZuMKvWGSURJG9QA9u24KCLuBREqpjN7T1REh65LpOwa7Uv6PCNGC6G2SCuOVjyNhHxnJH7v2Gxqg+0fRmdNEWatnGbFa91Zjv3vZNSrSKLstVjvJTeIU4maU2HVfK06VYWVsRGi5ZEwsBJURCFTBsrxR1yatyC6pfKw76Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737402622; c=relaxed/simple;
	bh=iGHb7QYGM/qKY0kNKWyNlbWXLhzUWbd9VfPi8yK8EuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PXosAz6ATSkJIgnnpBBiYZuErvLy1WnphyBkCUJ2XLggWJ0zYA3a4WnC8i+8GRufNjXdbNNmrVx++ULscIJ/tpjdS877NYgYhEz56GRDMtR9+ySK50+RhfMSs6RURM9FCS/uiSW1cfuXHjffi2Jyc4qjWmzadykQwQDh0Pl4jZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi; spf=pass smtp.mailfrom=kolumbus.fi; dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b=PTZvIExw; arc=none smtp.client-ip=62.142.5.107
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b="PTZvIExw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=kolumbus.fi; s=elisa1;
	h=content-transfer-encoding:content-type:mime-version:references:in-reply-to:
	 message-id:date:subject:cc:to:from:from:to:cc:reply-to:subject:date:
	 in-reply-to:references:list-archive:list-subscribe:list-unsubscribe:
	 content-type:content-transfer-encoding:message-id;
	bh=fOxipktNqCrigYZ7B5hPT1lw2rZhoRC3OXaHW10XMDU=;
	b=PTZvIExwseunHDuzrNXu1GyIQIEDbm4J+FCI7O5+JJdOTPn99LxUvLgw+hVNoimLxc9Diz2WzsXQk
	 2zHN8CJ3A76+dCuq0c97K8Bc79U6316EeHYHehX8Dj1NsOLBM9Ke6wUkr8fmPmniowRytcFwboSkRp
	 izIMMQ2bZXknE3C1lXAQHSk0REU8fEEh0HyvIQ/1foztzsTNF7JJMEO+sz8J5HIBoIjHPcEVdh5oMH
	 2xKfEP6iq30p3bw5Crhu4gcHcf0XIZ0trdNNempkFGyTuxRgKVaawziklBjOIsFxtGSIU/ZE2yWLSF
	 apgOx1xfvLTYihC9UbkRJGFXbIzR/CA==
Received: from kaipn1.makisara.private (85-156-116-90.elisa-laajakaista.fi [85.156.116.90])
	by fgw21.mail.saunalahti.fi (Halon) with ESMTPSA
	id c126253c-d767-11ef-88a3-005056bdd08f;
	Mon, 20 Jan 2025 21:50:09 +0200 (EET)
From: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
To: linux-scsi@vger.kernel.org,
	jmeneghi@redhat.com
Cc: martin.petersen@oracle.com,
	James.Bottomley@HansenPartnership.com,
	loberman@redhat.com,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
Subject: [PATCH v3 3/4] scsi: st: scsi_device: Modify st.c to use the new scsi_error counters
Date: Mon, 20 Jan 2025 21:49:24 +0200
Message-ID: <20250120194925.44432-4-Kai.Makisara@kolumbus.fi>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250120194925.44432-1-Kai.Makisara@kolumbus.fi>
References: <20250120194925.44432-1-Kai.Makisara@kolumbus.fi>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Compare the stored values of por_ctr and new_media_ctr against
the values in the device struct. In case of mismatch, the
Unit Attention corresponding to the counter has happened.
This is a safeguard against another ULD catching the
Unit Attention sense data.

Macros scsi_get_ua_new_media_ctr and scsi_get_ua_por_ctr are added to
read the current values of the counters.

Signed-off-by: Kai Mäkisara <Kai.Makisara@kolumbus.fi>
---
 drivers/scsi/st.c          | 30 +++++++++++++++++++++++++-----
 drivers/scsi/st.h          |  4 ++++
 include/scsi/scsi_device.h |  6 ++++++
 3 files changed, 35 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 0fc9afe60862..6ec1cfeb92ff 100644
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
@@ -357,10 +359,18 @@ static int st_chk_result(struct scsi_tape *STp, struct st_request * SRpnt)
 {
 	int result = SRpnt->result;
 	u8 scode;
+	unsigned int ctr;
 	DEB(const char *stp;)
 	char *name = STp->name;
 	struct st_cmdstatus *cmdstatp;
 
+	ctr = scsi_get_ua_por_ctr(STp->device);
+	if (ctr != STp->por_ctr) {
+		STp->por_ctr = ctr;
+		STp->pos_unknown = 1; /* ASC => power on / reset */
+		st_printk(KERN_WARNING, STp, "Power on/reset recognized.");
+	}
+
 	if (!result)
 		return 0;
 
@@ -413,10 +423,11 @@ static int st_chk_result(struct scsi_tape *STp, struct st_request * SRpnt)
 	if (cmdstatp->have_sense &&
 	    cmdstatp->sense_hdr.asc == 0 && cmdstatp->sense_hdr.ascq == 0x17)
 		STp->cleaning_req = 1; /* ASC and ASCQ => cleaning requested */
-	if (cmdstatp->have_sense && scode == UNIT_ATTENTION && cmdstatp->sense_hdr.asc == 0x29)
+	if (cmdstatp->have_sense && scode == UNIT_ATTENTION &&
+		cmdstatp->sense_hdr.asc == 0x29 && !STp->pos_unknown) {
 		STp->pos_unknown = 1; /* ASC => power on / reset */
-
-	STp->pos_unknown |= STp->device->was_reset;
+		st_printk(KERN_WARNING, STp, "Power on/reset recognized.");
+	}
 
 	if (cmdstatp->have_sense &&
 	    scode == RECOVERED_ERROR
@@ -968,6 +979,7 @@ static int test_ready(struct scsi_tape *STp, int do_wait)
 {
 	int attentions, waits, max_wait, scode;
 	int retval = CHKRES_READY, new_session = 0;
+	unsigned int ctr;
 	unsigned char cmd[MAX_COMMAND_SIZE];
 	struct st_request *SRpnt = NULL;
 	struct st_cmdstatus *cmdstatp = &STp->buffer->cmdstat;
@@ -1024,6 +1036,13 @@ static int test_ready(struct scsi_tape *STp, int do_wait)
 			}
 		}
 
+		ctr = scsi_get_ua_new_media_ctr(STp->device);
+		if (ctr != STp->new_media_ctr) {
+			STp->new_media_ctr = ctr;
+			new_session = 1;
+			DEBC_printk(STp, "New tape session.");
+		}
+
 		retval = (STp->buffer)->syscall_result;
 		if (!retval)
 			retval = new_session ? CHKRES_NEW_SESSION : CHKRES_READY;
@@ -3639,8 +3658,6 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
 				goto out;
 			}
 			reset_state(STp); /* Clears pos_unknown */
-			/* remove this when the midlevel properly clears was_reset */
-			STp->device->was_reset = 0;
 
 			/* Fix the device settings after reset, ignore errors */
 			if (mtc.mt_op == MTREW || mtc.mt_op == MTSEEK ||
@@ -4402,6 +4419,9 @@ static int st_probe(struct device *dev)
 		goto out_idr_remove;
 	}
 
+	tpnt->new_media_ctr = scsi_get_ua_new_media_ctr(SDp);
+	tpnt->por_ctr = scsi_get_ua_por_ctr(SDp);
+
 	dev_set_drvdata(dev, tpnt);
 
 
diff --git a/drivers/scsi/st.h b/drivers/scsi/st.h
index 6d31b894ee84..0d7c4b8c2c8a 100644
--- a/drivers/scsi/st.h
+++ b/drivers/scsi/st.h
@@ -179,6 +179,10 @@ struct scsi_tape {
 	int recover_count;     /* From tape opening */
 	int recover_reg;       /* From last status call */
 
+	/* The saved values of midlevel counters */
+	unsigned int new_media_ctr;
+	unsigned int por_ctr;
+
 #if DEBUG
 	unsigned char write_pending;
 	int nbr_finished;
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index f5c0f07a053a..013018608370 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -687,6 +687,12 @@ static inline int scsi_device_busy(struct scsi_device *sdev)
 	return sbitmap_weight(&sdev->budget_map);
 }
 
+/* Macros to access the UNIT ATTENTION counters */
+#define scsi_get_ua_new_media_ctr(sdev) \
+	((const unsigned int)(sdev->ua_new_media_ctr))
+#define scsi_get_ua_por_ctr(sdev) \
+	((const unsigned int)(sdev->ua_por_ctr))
+
 #define MODULE_ALIAS_SCSI_DEVICE(type) \
 	MODULE_ALIAS("scsi:t-" __stringify(type) "*")
 #define SCSI_DEVICE_MODALIAS_FMT "scsi:t-0x%02x"
-- 
2.43.0


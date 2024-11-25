Received: from fgw20-4.mail.saunalahti.fi (fgw20-4.mail.saunalahti.fi [62.142.5.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92485376E0
	for <linux-scsi@vger.kernel.org>; Mon, 25 Nov 2024 14:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.142.5.107
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732543411; cv=none; b=bZnnmZyIwSLLUHPZs8NUfD3Yz1ajOOx6o/JhERt769B0dgFTww+ZwcOxFzU+Xh0AxJGYJaFa/6qRr+fl3tewkfLE4iCEYeB/kupDDkd6UzhBalwX/6I70wnhnQAjb0Y3ZI7Y/wLEwBwEJpys2lLdtpLXfMM+w+aeR1OgnY9PrSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732543411; c=relaxed/simple;
	bh=8MEwmFiTo7rjB+NGx5umIcQHlacB3w2MExmzilxAQ1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cuqQSMI5J6kM69vVASWbq0xteocSP+wM5BtV/NAIF69h5gQliUHFYLJjt/ljvKqtt7DrNfS9c3nNXz+npUSPRAewsZN3qxjn0rWACj0PzF6Cqe4Q+99o/moV+joP41YAO+u9NH7WdgquafDIjvW1tQvMzJA83dERGLFCj3b+9jI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi; spf=pass smtp.mailfrom=kolumbus.fi; dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b=w/Wmtq98; arc=none smtp.client-ip=62.142.5.107
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b="w/Wmtq98"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=kolumbus.fi; s=elisa1;
	h=content-transfer-encoding:content-type:mime-version:references:in-reply-to:
	 message-id:date:subject:cc:to:from:from:to:cc:reply-to:subject:date:
	 in-reply-to:references:list-archive:list-subscribe:list-unsubscribe:
	 content-type:content-transfer-encoding:message-id;
	bh=CCuEaY1I75CVu4/J/xAMzSkf6Fn2artCV/2R6lhlYWQ=;
	b=w/Wmtq980wUa254ld7SjzoVDJbB8kqkxc5GYnRM7Ogr/Q+VBq1aqRLZF2z8ewoeZghvBBMQ/BdGKK
	 sD3Jh35OLXfEslh74VQs74xna2nS4vUMQW/EjSaHWT5qlOJqtXRSUBlGIzw2lZX//mroS+wA1hJyb9
	 7aBr3GOWXjPypYKwW8OaATUPZTAuZXZ0hnm8SX8Sdb4Y9bNs5XuCW0YjhdG/8A1ZmKFsPK4rZPbj1D
	 3v0H/+NHesWKfhffWEv1eEHGnbo5mLwUz59i4U74INxIG8SCffSc8O/2jJzs380vIhuJD8ay192s60
	 ez5zjrqXWVxnX7oa34rIEDkb07aAS0A==
Received: from kaipn1.makisara.private (85-156-116-90.elisa-laajakaista.fi [85.156.116.90])
	by fgw21.mail.saunalahti.fi (Halon) with ESMTPSA
	id 05da4e4f-ab36-11ef-8882-005056bdd08f;
	Mon, 25 Nov 2024 16:03:18 +0200 (EET)
From: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
To: linux-scsi@vger.kernel.org,
	jmeneghi@redhat.com
Cc: martin.petersen@oracle.com,
	James.Bottomley@HansenPartnership.com,
	loberman@redhat.com,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
Subject: [PATCH v2 3/4] scsi: st: Modify st.c to use the new scsi_error counters
Date: Mon, 25 Nov 2024 16:03:00 +0200
Message-ID: <20241125140301.3912-4-Kai.Makisara@kolumbus.fi>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241125140301.3912-1-Kai.Makisara@kolumbus.fi>
References: <20241125140301.3912-1-Kai.Makisara@kolumbus.fi>
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

Remove use of the was_reset flag in struct scsi_device.

Signed-off-by: Kai Mäkisara <Kai.Makisara@kolumbus.fi>
---
 drivers/scsi/st.c | 28 +++++++++++++++++++++++++---
 drivers/scsi/st.h |  4 ++++
 2 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index a0667a0ae4c9..ad86dfbc8919 100644
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
@@ -4394,6 +4413,9 @@ static int st_probe(struct device *dev)
 		goto out_idr_remove;
 	}
 
+	tpnt->new_media_ctr = scsi_get_ua_new_media_ctr(SDp);
+	tpnt->por_ctr = scsi_get_ua_por_ctr(SDp);
+
 	dev_set_drvdata(dev, tpnt);
 
 
diff --git a/drivers/scsi/st.h b/drivers/scsi/st.h
index 2105c6a5b458..47b0e31b7828 100644
--- a/drivers/scsi/st.h
+++ b/drivers/scsi/st.h
@@ -178,6 +178,10 @@ struct scsi_tape {
 	int recover_count;     /* From tape opening */
 	int recover_reg;       /* From last status call */
 
+	/* The saved values of midlevel counters */
+	unsigned int new_media_ctr;
+	unsigned int por_ctr;
+
 #if DEBUG
 	unsigned char write_pending;
 	int nbr_finished;
-- 
2.43.0


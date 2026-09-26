Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0EFE2DCBE3
	for <linux-scsi@vger.kernel.org>; Sat, 26 Sep 2026 18:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790446640; cv=none; b=LoB3qOk2blMWCzyF5j7/pQH4KtOUEVvh31y6qLHnq6nqKsl0+jjicgZpgZ1ZvecFRCBzG8wwOXMpRUcNjpCSVCkM0SPJGyocaiPN6LmorYw5VQNdKKlPqWocjgR52rylXuzyPNmugzlAiFZNi38r3SU6s+gnj1JvVYxva+YgIko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790446640; c=relaxed/simple;
	bh=NX1mYnPgng+E/m6faM/4rbuCEd2zxfeZIjnBeoBx/wE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jB7FSY49ApOXEu2I1qkfB+XzXuXAUe7bts/njIZEd2cWhaGB3FRHUGZM3rI1WXQdKlMRzxVs+rM0iZrKIx7KC+kcYVJISCVZSqmHmyW6DwLeHZ5jvGSFj7SiS8+OrwhzmPUOEHki2shfUm1noKtqQ/SnSnPvEdZsafOShVw3b6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AajZV9nM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AajZV9nM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF66F1F00893;
	Sat, 26 Sep 2026 18:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790446639;
	bh=jdlZH4SyqSTe/Yx+ert15fo6zsIRnoAqNnu1e6VVllU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AajZV9nMMQIWBblCd7DMcfgj+CxfStly+cAMUVNmnaazqa8ut3GQ1x1g6LTW2OX+j
	 cHz1pe0s0jn9gpmafsteNBKjLyaWCE/EUwARO7XtRb0P8q2iAAte3OmoHzgrLl8YEY
	 ly7SzP4nZ9AONqcAamEWs+dToPPYFbOqM8sca73Y5H6Rx9mUCQAND+8jPvsI68seIJ
	 9eD+R6fjjTTSQ8Jz1FgS81BJKGmu1KUhlWwTTep+kTxQFniiwlH7WtdehvOtJDwYSj
	 vc+57K7eT7dolf6CHlUjvTPyULiCNPq9mFP9do9TYggvXJRzwsWZYUMlTObfGXxoW4
	 lsSavQvk5l7ag==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v8 05/11] scsi: scsi_debug: Report the residual of a write
Date: Sat, 26 Sep 2026 20:17:08 +0200
Message-ID: <20260926181702.508975-18-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260926181702.508975-13-cassel@kernel.org>
References: <20260926181702.508975-13-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4459; i=cassel@kernel.org; h=from:subject; bh=NX1mYnPgng+E/m6faM/4rbuCEd2zxfeZIjnBeoBx/wE=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLJ28Midjg4oXx0RH1CgfUQ6Nn1JTYTUi4UT26fWWr4KY p+5tOFdRykLgxgXg6yYIovvD5f9xd3uU44r3rGBmcPKBDKEgYtTACYy04WR4WGsrZ+K49M/XbyR fzfOjCs/dfqdXffE1k4dIRG33SYp9gz/gz8qX7bW9lb7ufd9/Uyhnxf/nF64oVq7gH3fjRRZPv4 6RgA=
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

A write whose data buffer is larger than its transfer length leaves a
residual that the initiator is entitled to be told about. resp_read_dt0()
and resp_write_tape() report it, but the write paths for a disk do not,
so such a write completes with GOOD status and a residual of zero while
a READ of the same length into the same buffer reports it correctly.

Report it in resp_write_dt0(), resp_write_scat() and resp_atomic_write().

resp_write_scat() differs twice over. Its data-out buffer also holds the
parameter list header and the LBA range descriptors, so what the command
consumed is sg_off rather than the bytes that the last range
transferred; and sg_off counts what was asked for rather than what was
transferred, so it can exceed the buffer and needs a guard. Two of its
exits also bypass the end of the loop: a command with no LBA range
descriptors or a buffer transfer length of zero transfers nothing, so
the whole buffer is residual, and an injected error ends the command
after a range has been written, where resp_write_dt0() reports the
residual before injecting it.

Assisted-by: LLM
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
Tested with:

  modprobe scsi_debug zbc=managed sector_size=512 physblk_exp=3 \
      zone_size_mb=8 dev_size_mb=128 zone_nr_conv=2

An eight logical block WRITE(16) with a 5000 byte buffer reports
resid=904, having transferred 4096. A READ(16) of the same length into
the same buffer reported that before this patch and the WRITE reported
0. A buffer of exactly 4096 bytes reports 0, as does a 512 byte buffer,
which is consumed in its entirety. WRITE ATOMIC (16) behaves like the
WRITE, on a device that is not zoned.

WRITE SCATTERED (16) with one LBA range descriptor of eight blocks and a
5632 byte buffer reports resid=1024, having consumed 512 bytes of
parameter list and 4096 bytes of data. The same command with a 1024 byte
buffer completes and reports resid=0: sg_off reaches 4608, past the end
of the buffer, and without the guard the residual would have been
reported as 4294963712.
---
 drivers/scsi/scsi_debug.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index b64ae3ad300d..9220758bb801 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -5162,6 +5162,8 @@ static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 			    "%s: write: cdb indicated=%u, IO sent=%d bytes\n",
 			    my_name, num * sdebug_sector_size, ret);
 
+	scsi_set_resid(scp, scsi_bufflen(scp) - ret);
+
 	if (unlikely((sdebug_opts & SDEBUG_OPT_RECOV_DIF_DIX) &&
 		     atomic_read(&sdeb_inject_pending))) {
 		if (sdebug_opts & SDEBUG_OPT_RECOVERED_ERR) {
@@ -5233,8 +5235,10 @@ static int resp_write_scat(struct scsi_cmnd *scp,
 					    "Unprotected WR to DIF device\n");
 		}
 	}
-	if ((num_lrd == 0) || (bt_len == 0))
+	if (num_lrd == 0 || bt_len == 0) {
+		scsi_set_resid(scp, scsi_bufflen(scp));
 		return 0;       /* T10 says these do-nothings are not errors */
+	}
 	if (lbdof == 0) {
 		if (sdebug_verbose)
 			sdev_printk(KERN_INFO, scp->device,
@@ -5327,6 +5331,9 @@ static int resp_write_scat(struct scsi_cmnd *scp,
 
 		if (unlikely((sdebug_opts & SDEBUG_OPT_RECOV_DIF_DIX) &&
 			     atomic_read(&sdeb_inject_pending))) {
+			if (scsi_bufflen(scp) > sg_off + num_by)
+				scsi_set_resid(scp, scsi_bufflen(scp) -
+					       (sg_off + num_by));
 			if (sdebug_opts & SDEBUG_OPT_RECOVERED_ERR) {
 				mk_sense_buffer(scp, RECOVERED_ERROR,
 					FAILURE_PREDICTION_THRESHOLD_EXCEEDED);
@@ -5350,6 +5357,13 @@ static int resp_write_scat(struct scsi_cmnd *scp,
 		sg_off += num_by;
 		cum_lb += num;
 	}
+	/*
+	 * sg_off counts what the command asked for, which can exceed the
+	 * buffer: lbdof is not validated against it, and a range is counted
+	 * in full even if do_device_access() copied less.
+	 */
+	if (scsi_bufflen(scp) > sg_off)
+		scsi_set_resid(scp, scsi_bufflen(scp) - sg_off);
 	ret = 0;
 err_out_unlock:
 	sdeb_meta_write_unlock(sip);
@@ -6206,6 +6220,8 @@ static int resp_atomic_write(struct scsi_cmnd *scp,
 		return DID_ERROR << 16;
 	if (unlikely(ret != len * sdebug_sector_size))
 		return DID_ERROR << 16;
+
+	scsi_set_resid(scp, scsi_bufflen(scp) - ret);
 	return 0;
 }
 
-- 
2.55.0


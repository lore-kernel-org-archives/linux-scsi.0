Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A725739B94F
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2026 08:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790670374; cv=none; b=Uwk9zsofemBFbrjXMnRCvEdPF0ajpIv2ukWFt+rkqJG3Cm0D6Y9XYWI1YE4ybgHuoD+l5GqPYXFn0qhEj6yPtyuGcDqAS6sGrjwo0j9EQF0vIdU4SWCfSOpns4OuY5NWOGpbOUdrgfFanRHos+JrvJHq+TGspd3UjTzyNhQMZQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790670374; c=relaxed/simple;
	bh=KIFH+0W2+j/aa6z58OUGgX6rAYY2XpBUI5PmEcSNK08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Il9Jo2mTcLzlsmYr6N7PGGEiw7pjOd1VNIo4IPw4CKoZl5XehB4Q4exIVnV6Ib8Q9/Ah+2/KerTZacUu9BvYmEvXy31wqbbspmCnjZcm8KeCMfT7eEXG4yMT6pe6U64rXhNhUrLpZFf1sr+NtL3nbATkksBZ7SUWwLPbzmTbjuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IYp0VWTF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IYp0VWTF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0964C1F000FF;
	Tue, 29 Sep 2026 08:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790670373;
	bh=HUZxkjnuEweAh+TKVPdJU4xA/UBmceUBWej/b3DWi48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IYp0VWTFxbDX+U1a6SLMbEaQXTWbO/4HGOV2k7XF9AYesQdsr1dvogytKZZqYrAN7
	 ErzVkM7tuHzq77mPGEmPX2Wc7r4Nxt/R/mpEY5uYSRIeD/WR/nOcj6nardCJtZi5kw
	 PeA8e7CxebxNxKgbkdQPcX+OIVqrenOXU4A3acClaSPLh2lz9Wr0Yhzph0QhumoeuI
	 lL24wbAP5+S7WfGC7OGogxhyGvOEj9TlMlZS9B0CcA4VDnHwBpVjkqwLqS6XHpTx/7
	 IxhsjpC7sZUCMpA3V2xBt3z9ojzLWyfTF6gCAh/9wa+Xl7BX5wYcx7b1iCrm3qkFPy
	 AeH9+DmxZYUoA==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v11 07/13] scsi: scsi_debug: Report the residual of a write
Date: Tue, 29 Sep 2026 10:25:04 +0200
Message-ID: <20260929082456.857423-22-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260929082456.857423-15-cassel@kernel.org>
References: <20260929082456.857423-15-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4656; i=cassel@kernel.org; h=from:subject; bh=KIFH+0W2+j/aa6z58OUGgX6rAYY2XpBUI5PmEcSNK08=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLJ2l76NTWPa5brc5NISuwBPBptfThE5GWstTi2NvRf5X +8Bw7zSjlIWBjEuBlkxRRbfHy77i7vdpxxXvGMDM4eVCWQIAxenAEzkXhbDP7UOgy5HjnL/x2rR GvP/u95o/znfps9VXuHIv9pdh1X0NzL8D5/9wsnOo04zqPHvnS3c2xdeE11mXSJn3vB7opGLrW8 KNwA=
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

Documentation/scsi/scsi_mid_low_api.rst defines the residual as the
length of the data buffer less the number of bytes actually transferred,
so a write whose data buffer is larger than its transfer length leaves
one. resp_read_dt0() and resp_write_tape() report it, but the write
paths for a disk do not, so such a write completes with GOOD status and
a residual of zero while a READ of the same length into the same buffer
reports it correctly.

Report it in resp_write_dt0(), resp_write_scat() and resp_atomic_write().

resp_write_scat() differs twice over. Its data-out buffer also holds the
parameter list header and the LBA range descriptors, so what the command
consumed is sg_off rather than the bytes that the last range
transferred; and sg_off counts what was asked for rather than what was
transferred, so it can exceed the buffer and needs a guard. A command
with no LBA range descriptors or a buffer transfer length of zero
transfers nothing, so the whole buffer is residual. An error, real or
injected, can end the command after some ranges have been written, so
the residual is reported on every exit once the parameter list has been
fetched.

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

Changes since v10: the residual is only set when it is non-zero in
resp_write_dt0() and resp_atomic_write(), as Damien suggested.
---
 drivers/scsi/scsi_debug.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 879746c2ed7d..2f828820cbea 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -5162,6 +5162,9 @@ static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 			    "%s: write: cdb indicated=%u, IO sent=%d bytes\n",
 			    my_name, num * sdebug_sector_size, ret);
 
+	if (ret < scsi_bufflen(scp))
+		scsi_set_resid(scp, scsi_bufflen(scp) - ret);
+
 	if (unlikely((sdebug_opts & SDEBUG_OPT_RECOV_DIF_DIX) &&
 		     atomic_read(&sdeb_inject_pending))) {
 		if (sdebug_opts & SDEBUG_OPT_RECOVERED_ERR) {
@@ -5234,8 +5237,10 @@ static int resp_write_scat(struct scsi_cmnd *scp,
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
@@ -5330,6 +5335,8 @@ static int resp_write_scat(struct scsi_cmnd *scp,
 
 		if (unlikely((sdebug_opts & SDEBUG_OPT_RECOV_DIF_DIX) &&
 			     atomic_read(&sdeb_inject_pending))) {
+			/* This range has been written */
+			sg_off += num_by;
 			if (sdebug_opts & SDEBUG_OPT_RECOVERED_ERR) {
 				mk_sense_buffer(scp, RECOVERED_ERROR,
 					FAILURE_PREDICTION_THRESHOLD_EXCEEDED);
@@ -5355,6 +5362,13 @@ static int resp_write_scat(struct scsi_cmnd *scp,
 	}
 	ret = 0;
 err_out_unlock:
+	/*
+	 * sg_off counts what the command asked for, which can exceed the
+	 * buffer: lbdof is not validated against it, and a range is counted
+	 * in full even if do_device_access() copied less.
+	 */
+	if (scsi_bufflen(scp) > sg_off)
+		scsi_set_resid(scp, scsi_bufflen(scp) - sg_off);
 	sdeb_meta_write_unlock(sip);
 err_out:
 	kfree(lrdp);
@@ -6209,6 +6223,9 @@ static int resp_atomic_write(struct scsi_cmnd *scp,
 		return DID_ERROR << 16;
 	if (unlikely(ret != len * sdebug_sector_size))
 		return DID_ERROR << 16;
+
+	if (ret < scsi_bufflen(scp))
+		scsi_set_resid(scp, scsi_bufflen(scp) - ret);
 	return 0;
 }
 
-- 
2.55.0


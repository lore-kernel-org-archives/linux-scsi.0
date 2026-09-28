Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 759484078E4
	for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2026 07:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790580089; cv=none; b=igoQRJcPmdd9/0jCYskjzF56N1Ddyuur4wl7swlmZiyLEk4uaousWHBJ7M+6iRJAxYeVjRDPPK4w9x0c8jZIDsvBtM/cmfh7kgypEQKsdgk6TbmpHBqNKC0kg0CwmjsgQBRZP3vnAKexOaEox5gkEHyLAncgNChhFJ0UsyGgeH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790580089; c=relaxed/simple;
	bh=6ddhB4bD/zxmuKrvlQZXRUSLg7JeTCCxpn9LaD6VEg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VJjJFpphqy5+qgywe3WRz4fyc7ar+kP/Uw7UEBQ6p1TQfoc1IC2EoqrXePRM9ovs476QQbuQKCpMAtfT2rHsbX3RzB5E6yqe9TP6Mw40AIkG6Bc6u5OEvYXm+r0o3SJqme4drKx+icHfKCqTJvCGw71NlKTWS01d2+GfhPoMDL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dWRniQtj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dWRniQtj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2BE61F000FF;
	Mon, 28 Sep 2026 07:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790580088;
	bh=/b05eMUCfn+df1YhcEV1G4KEqs9pmjOndBsXvKDC61M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dWRniQtjFym9RwxbaV9YMneMnaqghJ1/5zpMY4FMP7FpwejqV0Xz+DV1BRc1TDu3Q
	 ctSXImmOAOzLKgI5Wr3ywOIlzGz4zELRDtNve0Hk/Ss/eH730cbht5qS8thBIzL2PF
	 btd6yk4IPBmEflM31SL3o1rDHBOt3ZMHT9QTs/JwNHr4B2HR4yFeKbiKgrEcq99CId
	 RKyvjmPGWNlg7ZuSglrrPoflKjJ/NKLoNrszFXK02vB+ZXziJvBHmn3JIbFP+otiux
	 2C8TelsiaDsqu3qQ8kyOe1DU1IstTuMSmm3DpwKO6vrv50wmXwMkvj9L9WS+GlhnTR
	 eTinqvdr5Yr3w==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v10 06/12] scsi: scsi_debug: Report the residual of a write
Date: Mon, 28 Sep 2026 09:21:09 +0200
Message-ID: <20260928072102.725566-20-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260928072102.725566-14-cassel@kernel.org>
References: <20260928072102.725566-14-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4526; i=cassel@kernel.org; h=from:subject; bh=6ddhB4bD/zxmuKrvlQZXRUSLg7JeTCCxpn9LaD6VEg8=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLJ2iaabpwfek4mrFbwQG/ftdrY998/QjPK2klvSbIf3y jz5PKu8o5SFQYyLQVZMkcX3h8v+4m73KccV79jAzGFlAhnCwMUpABNZMIWRYbebFscbWc0DV7kd 3H/O4VY64e+U+fpQ+d6ML3cSMjdyxDL8r7tldNZ2jYPh49/ZUd2PHq04cP3Fu/es0zIS/itV7pi XwQUA
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

Changes since v9: the commit message cites the definition of the
residual in Documentation/scsi/scsi_mid_low_api.rst.
---
 drivers/scsi/scsi_debug.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 8f9d54269dce..691a5ad56161 100644
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
@@ -5234,8 +5236,10 @@ static int resp_write_scat(struct scsi_cmnd *scp,
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
@@ -5329,6 +5333,8 @@ static int resp_write_scat(struct scsi_cmnd *scp,
 
 		if (unlikely((sdebug_opts & SDEBUG_OPT_RECOV_DIF_DIX) &&
 			     atomic_read(&sdeb_inject_pending))) {
+			/* This range has been written */
+			sg_off += num_by;
 			if (sdebug_opts & SDEBUG_OPT_RECOVERED_ERR) {
 				mk_sense_buffer(scp, RECOVERED_ERROR,
 					FAILURE_PREDICTION_THRESHOLD_EXCEEDED);
@@ -5354,6 +5360,13 @@ static int resp_write_scat(struct scsi_cmnd *scp,
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
@@ -6208,6 +6221,8 @@ static int resp_atomic_write(struct scsi_cmnd *scp,
 		return DID_ERROR << 16;
 	if (unlikely(ret != len * sdebug_sector_size))
 		return DID_ERROR << 16;
+
+	scsi_set_resid(scp, scsi_bufflen(scp) - ret);
 	return 0;
 }
 
-- 
2.55.0


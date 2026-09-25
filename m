Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87691201278
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 07:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790320676; cv=none; b=ZGoufQ0Qx/1C4Vd5jSJ1eNqZ/QHapvv0r+my9OibRf2p/MbcSw7pNTrS4VRXmVb+HR/Q0+MrI+QIWQbbUhsGKHNfD2ZODTUeo+BN47JNvfO5y2AYmTCmAckd9C8tWW0WsecYcjnRdSlHteUhoxnoHPJwZQFEMyAshjmKYlZtH/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790320676; c=relaxed/simple;
	bh=1eLAxpHWsVwV8T48gEOwCy8pK5ydMwG5oJZzf5eV4Yw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cW/soWDjSchmSfast0UstIEiwSmUbiPBmx0oXYDwaFGlomedKkUS/g1YntWBkKEDCMylBENs/xgI7sl7dbN27ks7jkY4XOdqjNnGOsbIuOZ+PCM/qDYjwsO/howo6eHml6wCVuAx+p1zt5gAFn0UR5LNerFwhEWcpkCxfmM75eA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=daCLeXNk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="daCLeXNk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A64921F00893;
	Fri, 25 Sep 2026 07:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790320675;
	bh=SND3vaB94WYDf2H39crAHohUQ8mvfCfrMasI+Ox1/ZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=daCLeXNk0Xe8YP4k3Bv8e1mIu72LYb1ilwVSNZhwKiPAr/i++69VY5yztd+APGzus
	 ao7GJuluLqzKKIp8TJWmiX8GjhpapB9wb7aXE1zKIjd8J/SlglWOf4rocRkSa5btz6
	 AAj38wZZJ1DnTU9CTL7GUjJPJjSYewMEYYjA71gUP1RqGFzJ22sH8jZ78o5PB2dDWj
	 c/qmJDUQcI0Y2zbz41dlwIP5cRDEB1h8R6Yj7KuDJoPtvjX9rMgFXWONHm4JThxXhX
	 yULvqyD3ferfSfmZ+vDRk+ZvNk3oZ3WCWGB2PxxC5YZ6aFyoE/htS1AotiE3XFNVVd
	 +rAB0oly7g/9A==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v7 05/11] scsi: scsi_debug: Report the residual of a write
Date: Fri, 25 Sep 2026 09:17:32 +0200
Message-ID: <20260925071726.140915-18-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260925071726.140915-13-cassel@kernel.org>
References: <20260925071726.140915-13-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4763; i=cassel@kernel.org; h=from:subject; bh=1eLAxpHWsVwV8T48gEOwCy8pK5ydMwG5oJZzf5eV4Yw=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLK2KQglz3rxeyNL1Pnm2m/aG4+bL3goH37h/2Vxjaheb dusZV03O0pZGMS4GGTFFFl8f7jsL+52n3Jc8Y4NzBxWJpAhDFycAjARS19GhoV9Zy+uisie/rpj IauxELeyhHgB20on5gPMGXUMRi8/zmNkmNWkrH1w9ZxJ4jUbs/++ujt/7lrGC2cqM7p9qyNcNJ8 t4AQA
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

Changes since v6: a WRITE SCATTERED (16) with no LBA range descriptors,
or with a buffer transfer length of zero, and a 1024 byte buffer
reports resid=1024, as does the command above with a RECOVERED ERROR
injected (opts=8, every_nth=1), on a device that is not zoned. All
three reported 0 in v6.
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


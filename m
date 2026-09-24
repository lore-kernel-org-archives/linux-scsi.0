Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F1DF44238A
	for <linux-scsi@vger.kernel.org>; Thu, 24 Sep 2026 11:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790248912; cv=none; b=etvwAGTP0Llplgt2VSv/1qE+79CSL63IQty4h/tXzXtqaD5M3XZ/5uGoMFDZCyZUci94B+cfOOmlCQrsSwLR3xeJkS7ilA6w0ZayyZeEhTf/fIpJ5W+FxIbW7ogDKtvmx+w+PYMXXD98iqZk+67mtNVSalBClEAEsZ2p/tg48FQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790248912; c=relaxed/simple;
	bh=H4YkYzIoB7UWg9DDljninclKQ+JPlYWF3T9qZ3dL9iY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hq6JlVh+/qZRz5Yhx9cN1508O7ptznnPJM/yStWD/10VDdDkTeOrUC7s50GbicPojJxUIymWn5TwoPnT/MFsADBLo+ZRmbtRHGkzLOFstfiDG9YUCIpHAdvtwJlQhth7JrHMFdla6Gweqb5eb8gTDc5hUq29//TUU5RanPrcvFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bswnNTc6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bswnNTc6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC1121F000FF;
	Thu, 24 Sep 2026 11:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790248909;
	bh=0vJZI00jylhrgouQzIQ5ve853sM8yE1+7aWr/6ynKHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bswnNTc67jgqNT+F/vaGKnioZW+VvrrGqaYJELwt2uzh/3yiDmDr6RYwbvRiBIulx
	 I9rmCz1V0TKo9ebOg7LoqeG58pD6QmfccZO2lrdSYeT99bvNxyfm29lF69RL58l+xc
	 9ABWxb02BTLWZFD2Zzx6D65UyJco+21ai+vH01rek1uA7EUC+fBkuKX0ouD20p7qYg
	 K9iwEqF7jBovVuoPmCT+hVt55joupI6maGVwTdj2R9eqdZayuWFzYmRv+XOsT2L0NL
	 INlUMlw2N55veZZnpA/1MlKWQA7VXYOpqGk//tUw+athBiMOywj2gP1ZoHoJ1T/Z3P
	 d/0e2x/n6dE0Q==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v6 05/11] scsi: scsi_debug: Report the residual of a write
Date: Thu, 24 Sep 2026 13:21:33 +0200
Message-ID: <20260924112127.3815255-18-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260924112127.3815255-13-cassel@kernel.org>
References: <20260924112127.3815255-13-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3253; i=cassel@kernel.org; h=from:subject; bh=H4YkYzIoB7UWg9DDljninclKQ+JPlYWF3T9qZ3dL9iY=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLK2su9+8W+fxIGQ8ik8jJOesThnaskJdcziCeAq++taz D3j+PZ5HaUsDGJcDLJiiiy+P1z2F3e7TzmueMcGZg4rE8gQBi5OAZjI9zhGhutFh+9rrXYq7nlo yrDOPWQ/29rqOp2yq9dbJ68W0+2obmBkWMWzPNB94hop9elRcnYXjn3NahEs3HXEZ9Zn5upMu6N CfAA=
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
transferred, so it can exceed the buffer and needs a guard.

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
 drivers/scsi/scsi_debug.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index b64ae3ad300d..fd80f66a86ac 100644
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
@@ -5350,6 +5352,13 @@ static int resp_write_scat(struct scsi_cmnd *scp,
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
@@ -6206,6 +6215,8 @@ static int resp_atomic_write(struct scsi_cmnd *scp,
 		return DID_ERROR << 16;
 	if (unlikely(ret != len * sdebug_sector_size))
 		return DID_ERROR << 16;
+
+	scsi_set_resid(scp, scsi_bufflen(scp) - ret);
 	return 0;
 }
 
-- 
2.55.0


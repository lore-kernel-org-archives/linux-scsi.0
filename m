Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 122384B5CD0
	for <linux-scsi@vger.kernel.org>; Mon, 21 Sep 2026 15:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790005277; cv=none; b=sJm7Rd/sjDjGMmLwV4IbJzx1rlMu6WoQw6ZE071S40t9B8Ei83I5Pc5ujbMIGnKrOGmGFo4o6+UV8p85AuazULzY/bmXSEn9LtHApMXqMLq3+vheapN5CIpgE8A2TmKzgsgXaauAW2YK/nf3pIFMisjRifyYgfndc7pL0NGQ6Ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790005277; c=relaxed/simple;
	bh=DO/ijweBuDVvHl0rRNw0MsftkaQk8zEsKsLBgwvRCqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wmpx2j4zng+U9lu0ZiKQApVuX4BX7Br5grgp+kDpL5RXVybSxMfYh/gMJohIZAxFb/pqzLzA+AIebTXBU2fp/yFF5v54vx8439oXyYCIl/hgs7mtXsNBqzNtM+RBXn+3Z4aX1Prgh8xM3ldtAV4id5uU9kgoaYzlKsf5kpWTYD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nockTtbi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nockTtbi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B0EE1F000FF;
	Mon, 21 Sep 2026 15:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790005275;
	bh=jfxxAIiDnExdBHj1aN8KBaa2PWOAKePCtQY1p4XxwiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nockTtbi4w5nDn9+tWCW2lmSVYMzajSq9VgvvHA46mmIiTCk9hXdG0IHOgtIwQ5GD
	 /zi013wKD2hwEn07KbhLYQZ0Va4cMZmWlZCmp2Nf5sXDHB3BQVaeRbmCvenSGPrWsM
	 Ocbb5C9us5QeXXD1B8HruXpinQ6kh5HLPKjaux5CU7nUa0m5mWMKpORp89H1XqyvLO
	 EpFMAsPl59OOu6Mi0m7xXGvNZTy+hB+gvx/O1xZL3QrsxcjBk36OgNJOTDW4o2Kkqi
	 EKBtQ2KeaSZr+ubsYBmcKa5tIGRVyRVT/MrZwwI3XG/TmVpjJdqsg9560xilD7tNdU
	 xQ8Yq06CRrM7w==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v5 05/10] scsi: scsi_debug: Report the residual of a write
Date: Mon, 21 Sep 2026 17:40:21 +0200
Message-ID: <20260921154015.2971990-17-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260921154015.2971990-12-cassel@kernel.org>
References: <20260921154015.2971990-12-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4049; i=cassel@kernel.org; h=from:subject; bh=DO/ijweBuDVvHl0rRNw0MsftkaQk8zEsKsLBgwvRCqs=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLI2+j+7aR2+SEeL96vhIab1ZQevnCm+ncccuypTz7rg7 YknxfPOdpSyMIhxMciKKbL4/nDZX9ztPuW44h0bmDmsTCBDGLg4BWAiRhcYGT63tE+LkS/YpxlY 9vNS93GvPzbWHLbflDRaSvsjb3HPWMTwT5snTmhVQJ74iu4f6uLMZ1nymh5+3yVUFOT4efJ/t/N KbAA=
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

A command transfers the number of logical blocks that it asks for,
bounded by the data buffer that the initiator provided. When the buffer
is larger than that, the bytes beyond are not transferred, and the
difference is a residual that the initiator is entitled to be told
about.

resp_read_dt0() reports it, as does resp_write_tape(), but the write
paths for a disk do not: scsi_get_resid() keeps the zero that
scsi_debug_queuecommand() initialised it with, so a write with an
oversized buffer completes with GOOD status and a residual of zero, as
though the whole buffer had been consumed. A READ of the same length
into the same buffer reports the residual correctly, so the two
directions disagree.

Report it in resp_write_dt0(), resp_write_scat() and
resp_atomic_write().

resp_write_scat() needs a different expression from the other two. Its
data-out buffer holds the parameter list header and the LBA range
descriptors as well as the data, and sg_off walks over all of it, from
the offset at which the data begins to the end of the last range that
was written, so what the command consumed is sg_off and not the number
of bytes that the last range transferred.

It also needs a guard that the other two do not. sg_off counts what the
command asked for rather than what was transferred: lbdof is not
validated against the length of the buffer, and a range is counted in
full even when do_device_access() copied less of it, so sg_off can
exceed the buffer. The other two subtract the number of bytes that were
copied, which the buffer bounds.

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
index c68dba6dbbdd..170d5c944b61 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -5166,6 +5166,8 @@ static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 			    "%s: write: cdb indicated=%u, IO sent=%d bytes\n",
 			    my_name, num * sdebug_sector_size, ret);
 
+	scsi_set_resid(scp, scsi_bufflen(scp) - ret);
+
 	if (unlikely((sdebug_opts & SDEBUG_OPT_RECOV_DIF_DIX) &&
 		     atomic_read(&sdeb_inject_pending))) {
 		if (sdebug_opts & SDEBUG_OPT_RECOVERED_ERR) {
@@ -5354,6 +5356,13 @@ static int resp_write_scat(struct scsi_cmnd *scp,
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
@@ -6210,6 +6219,8 @@ static int resp_atomic_write(struct scsi_cmnd *scp,
 		return DID_ERROR << 16;
 	if (unlikely(ret != len * sdebug_sector_size))
 		return DID_ERROR << 16;
+
+	scsi_set_resid(scp, scsi_bufflen(scp) - ret);
 	return 0;
 }
 
-- 
2.55.0


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9317F54707C
	for <linux-scsi@vger.kernel.org>; Sun, 27 Sep 2026 05:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790486844; cv=none; b=TQde9zLIAZB4invD9xXwuNVNTBn0NUuJs43ZvxyhtsyM9ByrKXmQCHmShu8A5GPfKzSwf2rsP5TK4sh9QJjHrTys7Z6rIkD+dba/qfAX4SmoZtVNeiHTDwFeA/AZLwZSKjtFaQskpz8l52GuwYsj389dro6BXZthGA5POaf6a1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790486844; c=relaxed/simple;
	bh=UkZv/qFk3xo8N4J2KrbhluHpLPmOZN7OTfn6uwJgQTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kKHwRbfsRpQbkl3wNCdceRmZ4rtFGK4YrrKoqOkCKdfkXftcPhadNBv1UZIYIBbU22TW6mfl4vrJCClcHIrg62/FTE/44EEBzKsH3boGh4kYSTiW2vEoeC/wh/OBnHGfDaMvs7UqYdX7drHAa/cQg/k9rm3VYatlxCCSA9DSPao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WlIagiBm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WlIagiBm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEF401F000FF;
	Sun, 27 Sep 2026 05:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790486843;
	bh=tyEAOouswbANwGb/BQ5A4Oqe9MyvMxeY7gpEdTsphxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WlIagiBmyHdtXPFbZ80Z5ioF7gcFPuvWny5XWCwC1dfgmb3wq9joInuA6yumtPcbY
	 Zlb5s6L3//eSU7txz/g0Uck7VnDnoHt4GZ2+HVfSL26WTMJPtEH9nWAXJ7Zpwf5sS1
	 frkBIEhtHY3xsCzsH3sZa+E4HQcawJLltEokIxgngn7KBG/1n11Jh/DlSbQ+v771Fq
	 rFcrQ5nQm+khdaLxj6g0jTu0zZQDQyrJgaMCA8YEtHwHQ0JchlXEA2kLkz45sVbJNm
	 EUBmbxkGuQ7QE0UF+e8gwsK9cEZhc0gHmUhIz409UA3sHwA+7r0Gj74N0g1WxFTjwh
	 7iXD9+CAS8q/g==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v9 10/11] scsi: scsi_debug: Map the region written by WRITE ATOMIC (16)
Date: Sun, 27 Sep 2026 07:27:01 +0200
Message-ID: <20260927052650.567035-23-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260927052650.567035-13-cassel@kernel.org>
References: <20260927052650.567035-13-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2501; i=cassel@kernel.org; h=from:subject; bh=UkZv/qFk3xo8N4J2KrbhluHpLPmOZN7OTfn6uwJgQTE=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLJ2rFSwM1e9mivIdY6h1XlNLcvczk38G/8s6018VnptS ruY8r3WjlIWBjEuBlkxRRbfHy77i7vdpxxXvGMDM4eVCWQIAxenAEzEexrDP/uHWfHG5uemHjAI DVO583mv5u75PokmMwQKdD7t4NUXZWFkmGO8l0XfYcveE9va/uur7G5L/N7++IruT7bfk/f/Paq whxUA
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

When logical block provisioning is enabled, every command that writes
user data calls map_region() so that GET LBA STATUS reports the region
as mapped. resp_atomic_write() does not, so GET LBA STATUS keeps
reporting a region as deallocated after a WRITE ATOMIC (16) has written
it.

Call map_region() the way resp_write_dt0() does, holding the zone
metadata write lock across the access. That lock is what serialises the
map against resp_unmap(), which does nothing unless logical block
provisioning is enabled.

Assisted-by: LLM
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: John Garry <john.garry@linux.dev>
Fixes: 84f3a3c01d70 ("scsi: scsi_debug: Atomic write support")
Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
Tested with:

  modprobe scsi_debug sector_size=512 physblk_exp=3 dev_size_mb=128 \
      atomic_wr=1 lbpu=1

GET LBA STATUS reports a region that has never been written as
deallocated, and reports it as mapped after a WRITE ATOMIC (16) of eight
blocks. Only an ordinary WRITE did so before this patch.
---
 drivers/scsi/scsi_debug.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 1753b7b087b3..11f2565fb676 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -4876,6 +4876,11 @@ static unsigned int map_state(struct sdeb_store_info *sip, sector_t lba,
 	return mapped;
 }
 
+/*
+ * Callers may map the whole range of a write without checking how much of
+ * it was written. SBC-6 4.7.4.6.2 allows a deallocated LBA to become mapped
+ * at any time, and only requires an LBA that was written to be mapped.
+ */
 static void map_region(struct sdeb_store_info *sip, sector_t lba,
 		       unsigned int len)
 {
@@ -6202,6 +6207,7 @@ static int resp_atomic_write(struct scsi_cmnd *scp,
 	u8 *cmd = scp->cmnd;
 	u16 boundary, len;
 	u64 lba, lba_tmp;
+	bool lbp = scsi_debug_lbp();
 	int ret;
 
 	if (!scsi_debug_atomic_write()) {
@@ -6250,7 +6256,15 @@ static int resp_atomic_write(struct scsi_cmnd *scp,
 	if (scsi_bufflen(scp) < len * sdebug_sector_size)
 		return DID_ERROR << 16;
 
+	if (lbp)
+		sdeb_meta_write_lock(sip);
+
 	ret = do_device_access(sip, scp, 0, lba, len, 0, true, true);
+	if (lbp) {
+		map_region(sip, lba, len);
+		sdeb_meta_write_unlock(sip);
+	}
+
 	if (unlikely(ret == -1))
 		return DID_ERROR << 16;
 	if (unlikely(ret != len * sdebug_sector_size))
-- 
2.55.0


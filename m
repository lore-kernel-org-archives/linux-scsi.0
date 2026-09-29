Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3AE03B38BC
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2026 08:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790670381; cv=none; b=NNIcTSM9d0GLNA+3NYe2Bbe1EPAuBS9yCSDLY+KeidnczhrlvhzKx2Gn1gW2dLNyjumQhlJU8wsuSqiIlMniaS38krvpTjSU81/gr2UUFs1GN7OHtqW9lZjYWODp18DVtlTvZdeM6cbdEpybcoDJLBZ71GvrGcsoNQwMhACYnVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790670381; c=relaxed/simple;
	bh=jd9eLFP3Zeq5vz1ODoX7S6QUcGEDtBSV33lLifsOV30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XkaHsjwA9/2mID9tS20DMQv6ibcvt3cZojRPE1HRmplv+Aw7YAAS+A40XT6kL2GpDaKF0PokemL2kE7ld16TakB2i1gvQsEY5/YhUr6ubWMwL2SI0nFM8iXy2rDwCI0PJp4iSPa6uMsUYojVvgiw/q/pTqgMrCUgVGtCvKDAJm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qwh7+PuE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qwh7+PuE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ABCE1F000FF;
	Tue, 29 Sep 2026 08:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790670380;
	bh=dXkdEScIoBqaB62tmqD4GR7l3RNZcOm7O5by4WPEqQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qwh7+PuExUQjOWtJ9vwEqdwZY6rbo88NvXVzwDy1T6nST/b2EDDVDY54IP+l3atKW
	 es9fI3txsMmZNinn/upgT8/X9r4C5fRaknbA7yq1e/oocubPfv7nKtSAk0v6Wl/+yu
	 c/3+HmqbfaW4ndXTuQlx+GE18XOUJuK12gltiKrBpSiMrGfWjD3KOttGStpFWRkiTl
	 jOI8Y6eeIIdDNn981ygbXrWt2MIt25Tddy21Tw4qhICTKj5rQyB6a6mq6LX/ZBEuna
	 PcN8LhLvh5gi5RIkZgdhtoMdokSLxfw6j50lCzR20tX6rl+tiD+XvItMeq1eznybUp
	 ARF8MrCy9sRXA==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v11 11/13] scsi: scsi_debug: Refuse a short WRITE ATOMIC (16) before writing it
Date: Tue, 29 Sep 2026 10:25:08 +0200
Message-ID: <20260929082456.857423-26-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260929082456.857423-15-cassel@kernel.org>
References: <20260929082456.857423-15-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2457; i=cassel@kernel.org; h=from:subject; bh=jd9eLFP3Zeq5vz1ODoX7S6QUcGEDtBSV33lLifsOV30=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLJ2l749OPH3cq6SBVpunUnXdwXrBFaJbb0jwhGSbtR9I dpffp5SRykLgxgXg6yYIovvD5f9xd3uU44r3rGBmcPKBDKEgYtTACbCps3wT6fJvJhzhj575JkX Xye+3HxNdtaPlCiOhy+eHuvcu/ztnZUM/3SvnutqePdp3ozwOOedli7Lv25W4xc71iQlttdZwiU 3hw8A
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

A write whose data-out buffer is shorter than its transfer length is
short. An ordinary write transfers what the buffer holds and reports the
rest as a residual, but an atomic write cannot be short: SBC-6 r02
(T10/BSR INCITS 587), 4.28.1, requires each atomic write operation to
write either all of its data or none of it, and 4.28.2 requires one that
cannot complete to leave the LBAs that it specifies unaltered.

resp_atomic_write() does fail a short WRITE ATOMIC (16) with DID_ERROR,
but only after do_device_access() has returned, and do_device_access()
copies one logical block at a time, so by then the blocks that the
buffer did hold have been written. An eight block WRITE ATOMIC (16) with
a buffer of four fails having overwritten the first four.

Check the length of the buffer before writing anything, and fail the
command with the same DID_ERROR as before.

Assisted-by: LLM
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: John Garry <john.garry@linux.dev>
Fixes: 84f3a3c01d70 ("scsi: scsi_debug: Atomic write support")
Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
Tested with:

  modprobe scsi_debug sector_size=512 physblk_exp=3 dev_size_mb=128 \
      atomic_wr=1 lbpu=1

issuing a WRITE ATOMIC (16) of eight blocks through SG_IO with a buffer
of four blocks of 0xaa. It fails with DID_ERROR before and after this
patch, but before it the first four blocks read back as 0xaa afterwards,
and after it all eight read back as they were. A WRITE ATOMIC (16) with
a full buffer writes all eight blocks, as before.

Changes since v10: the comment above the check also cites SBC-6
4.28.2, as John suggested.
---
 drivers/scsi/scsi_debug.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 98078fbeba37..41239ca364b3 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -6250,6 +6250,14 @@ static int resp_atomic_write(struct scsi_cmnd *scp,
 		}
 	}
 
+	/*
+	 * Short atomic writes are not allowed: SBC-6 4.28.2 requires an
+	 * atomic write that cannot complete to leave its LBAs unaltered, and
+	 * do_device_access() would already have written part of it.
+	 */
+	if (scsi_bufflen(scp) < len * sdebug_sector_size)
+		return DID_ERROR << 16;
+
 	ret = do_device_access(sip, scp, 0, lba, len, 0, true, true);
 	if (unlikely(ret == -1))
 		return DID_ERROR << 16;
-- 
2.55.0


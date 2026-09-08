Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1899E50EC11;
	Tue,  8 Sep 2026 09:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788858248; cv=none; b=qcBim9XQAnJhpkttlEg/PxDFwjK3FZLDBZOVl5ayUilvtRD3qRrj0Pu8t7acc7cPpW3cZ4KhqRhbQz4MxbtqLo/aTWasXlcX4Rd6wooK7XcAFRFSvKTONDvUVbTr1WQOPJuDT2QYThCQzqGAE4xE7ZOdJayn0iaTWzuu1ACIjh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788858248; c=relaxed/simple;
	bh=br3cC5PucbK2XpA+kdu6o77Fdw+5gMc3N/ze5qZIuT4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oOL1Ayg1KgFHFfuDcYgy4rCvelY4igDEkzoX88IAItfYjFX7CYUMtcLaQuKPIMehxnIcxPVXPcRTFdwWcfZB0Zq4MniUoQtavmFYtnPhcy5df135TAmhklSm20Hw8Qp+H4MUEse4ZQv6avjpxvz1lcPhh36SApeA75Hh2JdUkq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b7vA9Y0V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b7vA9Y0V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 140C01F00A3D;
	Tue,  8 Sep 2026 09:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788858244;
	bh=R03Gnbon/kqVwY0vHCIAx6DwVIT9dulIZm4csDbvUA4=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=b7vA9Y0V9YR74LZWvJsV9fvsYe1vvr29G5k6GSK4p7GwIWRazVFO87YGJBiIxLVdF
	 RTgVrtC1xFTtCWQX19+Y6/VjOoa3HfUx/HtiHRRQ+cenCA2Ppa4u3uKqiMKaFYXl0j
	 +jcEzSfh5/HoWKhdJ1yqoTxaq9B7J3Gsqbt6nSoa4vZLdHUnQfAdYmfCWwCnmOIQIL
	 PqMhSU1Hpq8XS99I8MC0d1I7XS5+BrshYccgJObBcDg7xMXJuQfO4B2Yw6cL6WXwmG
	 C0w4/Jbhc5WWay2W1oDSMKaNYZHqT/2MotGs2xhi7A2zVadaJaYLkihClEZiLJK+27
	 K99yvGbexfwcA==
From: Damien Le Moal <dlemoal@kernel.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	linux-scsi@vger.kernel.org,
	linux-ide@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	linux-usb@vger.kernel.org,
	Alan Stern <stern@rowland.harvard.edu>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-s390@vger.kernel.org,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH v6 25/40] scsi: ps3rom: use 16-bits defined sense codes
Date: Tue,  8 Sep 2026 18:02:53 +0900
Message-ID: <20260908090308.1085097-26-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260908090308.1085097-1-dlemoal@kernel.org>
References: <20260908090308.1085097-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Refactor the PS3 DVD driver to use scsi_set_sense() and replace all
hard-coded additional sense codes and additional sense code qualifiers
with the enum values defined in include/scsi/scsi_sense.h. This helps with
code clarity as the sense codes being processed are easier to test and
self-documented.

No functional change intended.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/ps3rom.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ps3rom.c b/drivers/scsi/ps3rom.c
index a9c727d22931..c63c581b493c 100644
--- a/drivers/scsi/ps3rom.c
+++ b/drivers/scsi/ps3rom.c
@@ -233,7 +233,8 @@ static enum scsi_qc_status ps3rom_queuecommand_lck(struct scsi_cmnd *cmd)
 	}
 
 	if (res) {
-		scsi_build_sense(cmd, 0, ILLEGAL_REQUEST, 0, 0);
+		scsi_set_sense(cmd, 0, ILLEGAL_REQUEST,
+			       NO_ADDITIONAL_SENSE_INFORMATION);
 		cmd->result = res;
 		priv->curr_cmd = NULL;
 		scsi_done(cmd);
@@ -316,7 +317,7 @@ static irqreturn_t ps3rom_interrupt(int irq, void *data)
 		goto done;
 	}
 
-	scsi_build_sense(cmd, 0, sense_key, asc, ascq);
+	scsi_set_sense(cmd, 0, sense_key, scsi_sense_code(asc, ascq));
 
 done:
 	priv->curr_cmd = NULL;
-- 
2.55.0


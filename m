Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68BF44FECD7
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 12:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789649753; cv=none; b=Z0GX5jda0TO7ajjLnGBDsGpH/mBQr2ZLNjVT7opXnT6DtvCTVl4Q3IuTbwojQPVj7/+wfhx2HjcmIGtX0Hx7xZSRDf/WBBDzbgWtMIpo/F/SfgoQyUxViighsAI+PgpZRr0Msl9PT8iSmhhAhwKj5VPD+hgvTATbIyrhR6YMHDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789649753; c=relaxed/simple;
	bh=8fSSR0cPOjH99xno13mYz0ccyW0EWjLe5aOQYR080CA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ePGRLxv0iNK/k3r3ZBwKkZZUFAyDED4ciF6UWwojNNJKzEuOzU6nSwk8O1cRLz7G6/5l2Xwe4cKDj1hrTPofYBGbzxF3W7HV//iN4QOR7QVvUJY1ZZ29EqTghO8EriJZvp5FaQMz5EaGlamp156z0n2pnUORbJdCwiQX2hrjVfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IDqvyzic; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IDqvyzic"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA5B71F00898;
	Thu, 17 Sep 2026 12:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789649747;
	bh=ElLI+IuJMvGmGqI3ZnEhO/c257k0RsljNU2LpfSetks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IDqvyzic3ejylOVK7d7f8lv1+D9h0UjbrG47k99tnuJFnJM5gRcE8g8wpPGwc4YRW
	 XSUuuneHyk3FhMUT5b9u5uPO/G/Na9TUSW4lndKKxC4mrgAlY7lCUtRuavdS56K4NI
	 dSYNp1OQEN7hX3+LbhQFQXR4xn0/J/JuLDr+qubzN1dPrUfE4YxX4puTod8bFlU4wJ
	 WGa+zXp/LMIfEkBs7coaSJLgpWMvCUm4tAQFIBbVLYZkWY0OEUtyiXYcmYZe8M5F5H
	 UobtQff9m/7urlEcxy2QIY3fVIq9mAm+nviiF0kjTjY41Gxy/RnQO+D/Meee4usS4/
	 O9/sHCZz6yaRA==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v3 2/6] scsi: scsi_debug: Do not write a partial physical block
Date: Thu, 17 Sep 2026 14:54:48 +0200
Message-ID: <20260917125445.1376493-10-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917125445.1376493-8-cassel@kernel.org>
References: <20260917125445.1376493-8-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2107; i=cassel@kernel.org; h=from:subject; bh=8fSSR0cPOjH99xno13mYz0ccyW0EWjLe5aOQYR080CA=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLJWP5aaLeEc/syx0DdoiZlB8dT6p0y5PYquVrPd81Xu1 zacOsneUcrCIMbFICumyOL7w2V/cbf7lOOKd2xg5rAygQxh4OIUgIl4tDD8j8kx4EkyXOHZuX1z 7CWLaVrP+qpXt/LXtuVNmpKz+pO9BSPDqZVeBeLPby8PEDzEuOW96Zpb+4wO3tDLc3bXLTzSbf+ BCwA=
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

do_device_access() copies one logical block at a time and stops at the
first short copy, so when the data-out buffer is smaller than the
transfer length of the command it can write part of a physical block.
An initiator can arrange that with SG_IO.

A device writes whole physical blocks, and ZBC-3 r06 (T10/BSR INCITS
579), 4.5.3.3.2, requires a write to a sequential write required zone to
end on a physical block boundary, so a partly written physical block is
not a state that a device can be left in.

Stop at the last whole physical block that the buffer holds. The bytes
that are left over are not written, and are reported to the initiator as
part of the residual.

With the default physblk_exp=0 the physical block size equals the
logical block size and this changes nothing. Nothing changes either when
the buffer holds all of the data that the command asks for, so a command
that transfers fewer logical blocks than a physical block, which is
legal outside a sequential write required zone, is unaffected.

Assisted-by: LLM
Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
 drivers/scsi/scsi_debug.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 641dd6f93791..8ed7d5cd0ae0 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -4290,6 +4290,19 @@ static int do_device_access(struct sdeb_store_info *sip, struct scsi_cmnd *scp,
 
 	fsp = sip->storep;
 
+	/*
+	 * A data-out buffer that does not hold all of the data that the
+	 * command asks for is written up to the last whole physical block
+	 * that it does hold, so that a partial physical block is never
+	 * written. The bytes that are left over are reported as a residual.
+	 */
+	if (do_write) {
+		u32 avail = (sdb->length - sg_skip) / sdebug_sector_size;
+
+		if (avail < num)
+			num = round_down(avail, 1U << sdebug_physblk_exp);
+	}
+
 	block = do_div(lba, sdebug_store_sectors);
 
 	/* Only allow 1x atomic write or multiple non-atomic writes at any given time */
-- 
2.55.0


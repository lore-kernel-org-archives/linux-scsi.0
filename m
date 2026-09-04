Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5963330216D;
	Fri,  4 Sep 2026 00:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788481662; cv=none; b=gWVsWqtGX06Su0NgMVUbyn6SyLiCAYXzHLy60FnkRUiur7a/BhxZjHZX4kk5fxErWG5T1LwyUyOr2v13TLIBE+k7yfIIO+RTQ36FPMuVNKjCT+mZwEykA1bC77m0hlpnV0huT/mJS8ACqRqrsisqzR9d1uGDpsGB6Zi8IsEKLH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788481662; c=relaxed/simple;
	bh=gcjMW3ubVT6P31ovg6jJSK0VI7MAZ31/Nf0v7YPd+dI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=itnYDd+W07Jt26VVXujr47Pr+u3b0+YU+wzxrRihdQ9fDLJ6Co7dJpgNyqtCUsNOTh6oikt8OWKRAAXlTEQKfJXzq8zaqWnu5gq6TD+wynhrONpoVOxuK1+1WtFy6QO8DlYKzB0VDQWphI8z7nazvWAhoKnFZmnA88pWUekLgew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bmd/jxKm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bmd/jxKm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDD601F00A3D;
	Fri,  4 Sep 2026 00:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788481661;
	bh=kAYHHp/LsBL3rsDwvCzc9nieAEGXN6oNnsCLaWoi958=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=Bmd/jxKm7niltXUdjq0Px+uHn3JLTOW8wt5QJOlQJcImCPBVORm7cYwEDxNwkuD/I
	 188gmf/Epc3aMZOUllY6z7gGg8EMzXwvSJJu8pVPCA8OP29kaaITwJqBylxX/VqQlU
	 jBYjdPwR9BvQAcmPLEBX5M09nBHxY9Fy03xLJOna/8AyMyvXTQ6xn2Hw2JPCSZrw9n
	 7/tiEnOWiT5GzLPNg5ANaou+swMcNPgbD0DQSrOtu+T5ztcJsc1uMTOM8nihrviOq9
	 VVzMJq0Yf7RJ8SOeuFUpe/1/eluDJYoGWcd2uE/s/rLzE2HSZjcqnMx8azoDkiggGl
	 FVi13VX+/rR2A==
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
Subject: [PATCH v3 25/40] scsi: ps3rom: use 16-bits defined sense codes
Date: Fri,  4 Sep 2026 09:26:29 +0900
Message-ID: <20260904002644.157668-26-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904002644.157668-1-dlemoal@kernel.org>
References: <20260904002644.157668-1-dlemoal@kernel.org>
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


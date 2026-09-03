Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87AB239479B;
	Thu,  3 Sep 2026 03:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788407000; cv=none; b=uXNnAsle24vdgkRf6P47lHgOmzQAWFC3/d5f1UhqL1+pBt2nfiRLhWzVmvxcD7e8EJrHf1akCIPWyH0kseyrVW46OJAr1LL3d22dgTDYa+GKWec+3JnGeG096+PpdOMtfCOdfYVleY+gWeUQlW3GfPa6ycNKbX0yMvX9LClMtT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788407000; c=relaxed/simple;
	bh=czEvGvequjNPcuTW4mQPvet0E5w0nP8lxOvbX5Y4qv4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UejZphOWATKv3sx7adDzSx6QtBAQkJJaL7+AWFnMKrKUpEYG2WiKm4B+uEnw4Gdm9XNZ3dVQCuvlTzjp0B9R6PPTsSFU/yFT6VdAwP0xwdytYf1BY4qOjE6PEc99VUPYUzDa8f3vx3/9r70Kfr2zRmEiSLMKb7PjY00M1HHlwcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WcGgAQ01; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WcGgAQ01"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 650BD1F000E9;
	Thu,  3 Sep 2026 03:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788406989;
	bh=y5531/ziW4yYSlUfHnpSR1gRaWvxio9dXP0OqmFFusg=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=WcGgAQ01cvNyUg8aX2T8EF/vxzil+E2GkRGTYISrsexTxQJumHZeJLxuN6HJ4KMSi
	 46LnTrwKsYhSAaPr4gMZ651Egv2tUA2iiVSujLgxyOHltF9IZVg5XeQO6HfpHj9nob
	 wSp2csn0FztxSEUViUZIUmDFcSh0755NPsTC8bUBqHkdqRI53qPbUBy2ZomnU2/NlZ
	 we6P0splgnskbibrUr+yruAfp2+4jW5WXWSdE21cA1IiveaKXGDxDyd6aa35e/XwHf
	 t2DERlokTUOTwwzajXyWBhgtuWKkXOp68lDAlXyQovPtbCtXE8dWIS2RxyLWqGqOKP
	 m5NRUa8JZDxaQ==
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
Subject: [PATCH v2 30/40] scsi: ibmvscsi_tgt: use 16-bits defined sense codes
Date: Thu,  3 Sep 2026 12:41:51 +0900
Message-ID: <20260903034201.112211-31-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260903034201.112211-1-dlemoal@kernel.org>
References: <20260903034201.112211-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Refactor the IBM virtual SCSI target driver to use scsi_set_sense_buffer()
and replace all hard-coded additional sense codes and additional sense
code qualifiers with the enum values defined in include/scsi/scsi_sense.h.
This helps with code clarity as the sense codes being processed are easier
to test and self-documented.

No functional change intended.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
index 61f682800765..e2af90b6da39 100644
--- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
+++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
@@ -3757,9 +3757,8 @@ static int ibmvscsis_queue_data_in(struct se_cmd *se_cmd)
 		dev_err(&vscsi->dev, "srp_transfer_data failed: %d\n", rc);
 		se_cmd->scsi_sense_length = 18;
 		memset(se_cmd->sense_buffer, 0, se_cmd->scsi_sense_length);
-		/* Logical Unit Communication Time-out asc/ascq = 0x0801 */
-		scsi_build_sense_buffer(0, se_cmd->sense_buffer, MEDIUM_ERROR,
-					0x08, 0x01);
+		scsi_set_sense_buffer(0, se_cmd->sense_buffer, MEDIUM_ERROR,
+				      LU_COMMUNICATION_TIMEOUT);
 	}
 
 	srp_build_response(vscsi, cmd, &len);
-- 
2.55.0


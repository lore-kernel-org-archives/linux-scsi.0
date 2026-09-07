Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06F033F4DE2;
	Mon,  7 Sep 2026 02:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788749082; cv=none; b=EZ/4MskxvjIWMHrOHlrasS0QtA+Yfuc9L2SIBs1lmhPG/Siyo/WgW5KQ79m9bU9u6vWd5igeuMMFqGQN4UFyjaYY+WCutQd6FwfhoY0rAWbYv9kHs5yUElPDuYbuZouq096f++LNgkiQVILbn2zjf0/FyHxlwXkDb0Tgw2oHCU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788749082; c=relaxed/simple;
	bh=/mW41zqDDqdpOsgXHkPmsVI/0GS/DDbcEJiTrCb2nMc=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=apxj646U4dQrg17ogdE10d5zqHrMIbXCtl5RrsWKmBUEHnKbCnXRAb9iDPVyHcxAs1I1GqVPz0uN6pYZkBuJLVL46ysQdZsjsX93wIl2FjpeVHv4SQftdB5yJ2P4UE1Ed2qrUe+n6p4tsCDm3SQg4XNrrVi8ioOf8+12zRXUCPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SJpJmDb0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SJpJmDb0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1EE31F00A3D;
	Mon,  7 Sep 2026 02:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788749080;
	bh=ezZo3cIeZob5n0jUfDw8efAraNLL9XA404n3FNk6lwA=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=SJpJmDb0xcN6OHCQXq1RkwYeJqs8XVE191wh8QzuxK57th/O+VPRQXiHvm8mLhnOB
	 IK4oSrH2TBPBpzsufQ0D3JNVkqs7dj1EmwrYK/hCVU21U3gJD91LnQufbhtc2ckGKd
	 HquomHKNFeaEy6cUAFUz/hRpYAciHRbnR2m1NjEcYa1xS2et1qpFxa2wJyGbygpJ8f
	 9oDl9LA5RJ1+7mZXvMVh8MrBWyKWu8xXqhs7W3ZY9OFgoRbFHF5BlcLWABLpD+aFn6
	 gqmWtin/RjED7N5zsDblW7TVSHSrQXECeJ1+CjSoJ03cZRI+dzZWkjKuwbKpIlyjks
	 u8tdxKJl/fT6Q==
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
Subject: [PATCH v5 29/40] scsi: libiscsi: use 16-bits defined sense codes
Date: Mon,  7 Sep 2026 11:43:32 +0900
Message-ID: <20260907024343.1046387-30-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260907024343.1046387-1-dlemoal@kernel.org>
References: <20260907024343.1046387-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Refactor libiscsi to use scsi_set_sense() and replace all hard-coded
additional sense codes and additional sense code qualifiers with the enum
values defined in include/scsi/scsi_sense.h. This helps with code clarity
as the sense codes being processed are easier to test and self-documented.

No functional change intended.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/scsi/libiscsi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 5cbc51899de0..7637aacd6037 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -892,7 +892,8 @@ static void iscsi_scsi_cmd_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 
 		ascq = session->tt->check_protection(task, &sector);
 		if (ascq) {
-			scsi_build_sense(sc, 1, ILLEGAL_REQUEST, 0x10, ascq);
+			scsi_set_sense(sc, 1, ILLEGAL_REQUEST,
+				scsi_sense_code(ASC_ID_CRC_OR_ECC_ERROR, ascq));
 			scsi_set_sense_information(sc->sense_buffer,
 						   SCSI_SENSE_BUFFERSIZE,
 						   sector);
-- 
2.55.0


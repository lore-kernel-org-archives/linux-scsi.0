Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1172357D19;
	Mon, 31 Aug 2026 02:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788141952; cv=none; b=t+ba293RmwrE+edliQRDqPZOP+DjVzlHfKHQS91+I1yrWzGGDGqvVHz0u0EdlppMkN86i0mFyl3dJdLyvw7Q3xMKInVH13jzHKcWaj71f3pIjm5IU/SjO3KLrJbLudNgexSdbFaILmxve3prpAqswIMTWvd8n+KepdwMpZBMvKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788141952; c=relaxed/simple;
	bh=/mW41zqDDqdpOsgXHkPmsVI/0GS/DDbcEJiTrCb2nMc=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kb7BvDYODsCL2k7leDSj0D6Yp573LsJa77phKQLHe5QVm53FPsSi8pKWd14Yswlw2C3xrJ0fGlXe/CWmZq2BxFUPdIPznBWSfQdhTRWFgZPjWPueW1yxzZnTGZNo6I5dz3MxGvgUKSTKUGzJS8mgzOKpRprVhT5r+JG8NCBUe9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZsI+yQOr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZsI+yQOr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 061051F000E9;
	Mon, 31 Aug 2026 02:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788141950;
	bh=ezZo3cIeZob5n0jUfDw8efAraNLL9XA404n3FNk6lwA=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=ZsI+yQOrl0trtzBJ2jpO0Dmo990vHVjUie2mSUyLf1rkSEP69YaPY2/TKErUu9zan
	 MnQSvW6gMQuyUTM3hCaEiQB5nUHIAJJ9qpdJnTEGORRn3GIRvlsOZ9yK6vEmGVZVlG
	 ShQqrnbSAVgJ7cV77S/JFWnXMV+n+DNgVgcsPjYFpMUR8tffhcxxcvZc/qaOE4MDbX
	 G/Jf4jYZ2wSu+wBGB+9k2uIM2+V7DIdoJc7flrsEvpi3oyVVyr/+xKaGUrgUuUWXvS
	 zADtWjgBGO/JEm3hFfTU2eTdlR8mYRoFc1Wj1X13YJFWByAVivB1Stri60H38tBiJI
	 eDKyTN9jahwOA==
From: Damien Le Moal <dlemoal@kernel.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	linux-scsi@vger.kernel.org,
	linux-ide@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	linux-usb@vger.kernel.org,
	Alan Stern <stern@rowland.harvard.edu>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 29/37] scsi: libiscsi: use 16-bits defined sense codes
Date: Mon, 31 Aug 2026 11:04:43 +0900
Message-ID: <20260831020451.585944-30-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831020451.585944-1-dlemoal@kernel.org>
References: <20260831020451.585944-1-dlemoal@kernel.org>
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


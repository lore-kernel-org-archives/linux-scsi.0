Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5278330FC1A;
	Fri,  4 Sep 2026 00:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788481669; cv=none; b=TEaLvuU6qHmuAVB79DXIQMb/FdOl8NhunmMWIXnBvmxgWUoPcDKVI3BUJKI1nCj/0S5QnpqfDUGwtA5xYc7e6gKObg3EP3olwfSuuC5TOC+UKL5IJ0J8mCL32GnnnUEzC1R1p/ZeXSyBMyTArrsB+e2I2Rw5SBcxgG7oEqbIvnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788481669; c=relaxed/simple;
	bh=/mW41zqDDqdpOsgXHkPmsVI/0GS/DDbcEJiTrCb2nMc=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DMFyh/Jlq6VxLxNM3/E6DjEgHssYcrGg5psLNPy2LATSfGMG8kJ25rzNpD4oNfmeipLPLrjE7Lfo8CHXFnJpV8y2IWtqvYhZzCohETMnZKQMSvC02QXInB1DeA9pTo34NPlBOSNZtaaQlm0gen6RJDyu3DF+ym5+E5j1WMG7ovw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rx7FS5xI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rx7FS5xI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D79191F00A3F;
	Fri,  4 Sep 2026 00:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788481668;
	bh=ezZo3cIeZob5n0jUfDw8efAraNLL9XA404n3FNk6lwA=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=Rx7FS5xI2d3vYsn2l0IYe/B+0jFJQYwwYJvc1DuhDtOuUjuTTj1caFXdLmgyLRIOb
	 5F9SWIhBulupvZJo4z47W+rBWW7A+A8ypN+zII+KcNxaZFCFKADtRfdgCorjTEXRT/
	 AgF/Z8JFtkUhRv/TXlh5SJmZspVmOJUu/0s1OkpZYTmJMOH9E42HjLuAUbmRNKx/Xk
	 pbwoaMGTedL2sLrl5ioVxBDBxbA7H54ZbdXQoy3FwPI3qCAAMwXUJYxlszTq4XRZIu
	 /voKJC1HlwNeH86DVMmolFRE8SrgOh1cn3GhrKFNyQXCh3v/TLGhrz+PKNpIX55TiR
	 GLDISipRAsNig==
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
Subject: [PATCH v3 29/40] scsi: libiscsi: use 16-bits defined sense codes
Date: Fri,  4 Sep 2026 09:26:33 +0900
Message-ID: <20260904002644.157668-30-dlemoal@kernel.org>
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


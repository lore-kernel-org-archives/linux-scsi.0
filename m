Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9303E30D3EF;
	Thu,  3 Sep 2026 03:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788407011; cv=none; b=Fz29cQcz1Ucci6PorXvrIAzmAAkVNm4ftLXsvepkoTNyGbuJ13M7xiI8q6LxyGOnnLmsr1i+VWeLUqA0yuFfoG/vi6zrOgLULPEsgHS2fWwV4YHoCYftVRivrfHy//b9OiTNtUiwoAvybQpXN5TosG1ioDykJVff/t6ouMGwxr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788407011; c=relaxed/simple;
	bh=DN7FlXUW0lkgj1usVZmlfq1rhb3RSV4TqH5A0CQl1WM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gg/BKSsuDwdVHbiWIjBd2m3fa8ChN7c80cI56ddai825gibm7Gyiqduhwzg7dZsXYOO+nJ3cDb1eVMP7RUt40B1QCPf0VDTQgXA8G+Cn5wiTEanSS87JYpWefTAcPmqDb4ABymFhChydgHVLA01t+jPySRLuYh3d0T0/p51rGwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DLj0WnZf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DLj0WnZf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78D471F00AC4;
	Thu,  3 Sep 2026 03:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788407004;
	bh=qqNO9Pzl8CFFEsdq0uZZZu13a5cGGO5WAky/SX5enkQ=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=DLj0WnZf8sobDvvHO67/TEAjBPQKsirkIOGkwRccQZDRchgYlPBnZVkjqkU3z6fBp
	 6ccFWLGG8PFEIwyL/h54GzcQonpwK33WqQ9F7CPaq1CT7Px0rF9zPRKEHSLp0Ei41+
	 KjdVRlLVZuEOOWzrZoAwbWi5y4S0WHfAokAJE87ec/rI8nCAJgGxtLGGzPel+0DJXh
	 nkPWn2BPf+EAMKi38Sv3eLnDZoOGDKueVcbY+e0wpBvYIT3cqIejjcERWcJ3kQYoOX
	 oU4Duj0gnhSDA3s7XG4J/aP6dhmCPWGae8ButPl8BkscJxiFt/jw2MyibaiZJfT51u
	 /tHt6DRppaeHA==
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
Subject: [PATCH v2 38/40] s390: scsi: use 16-bits defined sense codes
Date: Thu,  3 Sep 2026 12:41:59 +0900
Message-ID: <20260903034201.112211-39-dlemoal@kernel.org>
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

Use the 16-bits sense codes and replace all hard-coded additional sense
codes and additional sense code qualifiers with the enum values defined
in include/scsi/scsi_sense.h. This helps with code clarity as the sense
codes being processed are easier to test and self-documented.

No functional change intended.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/s390/scsi/zfcp_scsi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index 3590113c2b74..0994fa328a4f 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -856,7 +856,8 @@ void zfcp_scsi_set_prot(struct zfcp_adapter *adapter)
  */
 void zfcp_scsi_dif_sense_error(struct scsi_cmnd *scmd, int ascq)
 {
-	scsi_build_sense(scmd, 1, ILLEGAL_REQUEST, 0x10, ascq);
+	scsi_set_sense(scmd, 1, ILLEGAL_REQUEST,
+		       scsi_sense_code(ASC_ID_CRC_OR_ECC_ERROR, ascq));
 	set_host_byte(scmd, DID_SOFT_ERROR);
 }
 
-- 
2.55.0


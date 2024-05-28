Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C20B513AD0E;
	Tue, 28 May 2024 21:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716933422; cv=none; b=E/KJpwgIS25y+lKM8/I7U3LmRbAv+ziSoxc5ZTtIIdorR4JHedK1njC4hlzoz0V30l3075W1Xqe+IheTcCL8tXpbIMHo7VKg+K5OHm1g8KIti0Z5/6bpvaGbUYDj2/3j77V/w9nPpIxYf8jbCZBylRmmEN/DD/oXEQ5fufkyBrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716933422; c=relaxed/simple;
	bh=ohEurSGig2qE42glJYdmj/T6mbwtgrXzuwprHjyXuO8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=E8hFJ16x/QLUjnfw2FPnbsQKHXm9AE49MvLg2qMalBgWNvVMwEXmQaNm9qFppwxoHSo8/dZgO6K4KeMQQ8FtVXgZ4OtEELQ5Ard09PdDEMh0eRgbJ+d2ekv2eD2lrvpQAePY02vDlndS+KAJuD/e0ORTRPv8SfOo2evnvSrCPG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=Rgc1OEeV; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="Rgc1OEeV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=MIME-Version:Message-ID:Date:Subject:From:Content-Type:From
	:Subject; bh=WbJJ4Mwx5sika0WW/PColmV60EevJ2qmfZcxLyzIi1Y=; b=Rgc1OEeVx/XGV7Xc
	ppIdYp6lNvmF2dPgpWNYD/fYZrXxEVfWQ9ai+LEHfiZiro2g+XcVVnpSkLmhktd5F6zspY6bbljzR
	HMPlIFF9CPe5FK8RC+dUw1ahoZ8HDcU3eOn27eeb3/NiMkwq1ByyXdKDYb8qkHumnaZ2KqOQGZ66Z
	u+BmH8Pj/UhW/ljU0wRGBCZqsOVO7jpIzH4oUWesxwTX2UQLZmTG4YInD0MoyrvAhansqBBuld/0T
	CXwBKFS9IFOrEN0GCxqGreEnFsR35bHuMr62csWRucGU4Nw2JVkHIF4dkAp72+7Sw8VQUi6cpxzdJ
	fGkzhM1l4xU21yMrOA==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
	by mx.treblig.org with esmtp (Exim 4.96)
	(envelope-from <linux@treblig.org>)
	id 1sC4oI-0033Ie-1M;
	Tue, 28 May 2024 21:56:46 +0000
From: linux@treblig.org
To: njavali@marvell.com,
	GR-QLogic-Storage-Upstream@marvell.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Dr. David Alan Gilbert" <linux@treblig.org>
Subject: [PATCH] scsi: qla2xxx: remove unused struct 'scsi_dif_tuple'
Date: Tue, 28 May 2024 22:56:40 +0100
Message-ID: <20240528215640.91771-1-linux@treblig.org>
X-Mailer: git-send-email 2.45.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Dr. David Alan Gilbert" <linux@treblig.org>

'scsi_dif_tuple' is unused since
commit 8cb2049c7448 ("[SCSI] qla2xxx: T10 DIF - Handle uninitalized
sectors.").

Remove it.

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
---
 drivers/scsi/qla2xxx/qla_isr.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index d48007e18288..fe98c76e9be3 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3014,12 +3014,6 @@ qla2x00_handle_sense(srb_t *sp, uint8_t *sense_data, uint32_t par_sense_len,
 	}
 }
 
-struct scsi_dif_tuple {
-	__be16 guard;       /* Checksum */
-	__be16 app_tag;         /* APPL identifier */
-	__be32 ref_tag;         /* Target LBA or indirect LBA */
-};
-
 /*
  * Checks the guard or meta-data for the type of error
  * detected by the HBA. In case of errors, we set the
-- 
2.45.1


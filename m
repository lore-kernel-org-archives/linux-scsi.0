Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D12B93624B2
	for <linux-scsi@vger.kernel.org>; Thu,  4 Dec 2025 18:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764872172; cv=none; b=T+flsA0x8cUTpACs6WbC8uPeXmT858iGZxywPZn2R9wvet2C4PJd4tpjVWVQiJunQvrtaGZ/qvHbimTA0chIPetl1DxDQwVCTXRptj8lOPjDWcGvXYagZPqb9l8qgqN4unVCPUwp5WRFSRXLjBKb+i5iHJIDVRjMIzKNSQ2zIdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764872172; c=relaxed/simple;
	bh=xJ9j2tjZDW5szQsrjS25o9Na5/5fpciOuggW8Zq3v4M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=V2AqaHUdtweKksVCnJ6rNHwZ0B5XWDe1o1nz3C35Ox4Q3oAAmuDZpgdyOUMXf55sQUUMACWFgElzCFOP77wLZ9UYFOIru+ibcp5y360HGxTKGVrC+Ixp0fL69pLa9Gw9nyyqjnKNEMsVBcS01tOGNMdu2q7gYph1rWWiVCnneDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=YupscChU; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="YupscChU"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4dMjPM0sZzzlh1P0;
	Thu,  4 Dec 2025 18:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1764872164; x=1767464165; bh=S1WmRzMCp3ONpS0TeCgjSwU57o4tF6CwOGy
	6C8qm06o=; b=YupscChUno1/mw7x4qrBj2SC9BQXkn7dpDPQ9lZbE45tTDjApD3
	hVAiZl2pcfalYkAEm8s0t7J44addv3c0Wt9lcRmynjbGI+dPRfs6150Gmqb6PJZI
	e3oQxlApMdsR0MnVSRUiToXo6w2HUwE/528JnxzhAgwV7zCfYjFjcdlrUNtHb2Zn
	BUVVw4E3C9+12mi8t7R1IOCogerS7rEIRCs23JCGXPxL1DCDqrGJ5SGc3WSjijsz
	+l+kuLaqRb6cnEpLPqVZZYvmZwfNff/oBD0IQ6Nr8Wt+mfYgIe4iB+AD5TWvpfnF
	/1Ti6Lkf24sZiA67c6eAA7fZ+XGCvRESUxQ==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 56Cv9sRR89Xs; Thu,  4 Dec 2025 18:16:04 +0000 (UTC)
Received: from bvanassche-glaptop2.roam.corp.google.com (syn-098-153-230-237.biz.spectrum.com [98.153.230.237])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4dMjPB3FvdzlgqwD;
	Thu,  4 Dec 2025 18:15:57 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Roger Shimizu <rosh@debian.org>,
	Nitin Rawat <nitin.rawat@oss.qualcomm.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bean Huo <beanhuo@micron.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>
Subject: [PATCH] ufs: core: Fix a deadlock in the frequency scaling code
Date: Thu,  4 Dec 2025 08:15:43 -1000
Message-ID: <20251204181548.1006696-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.52.0.177.g9f829587af-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Commit 08b12cda6c44 ("scsi: ufs: core: Switch to scsi_get_internal_cmd()"=
)
accidentally introduced a deadlock in the frequency scaling code.
ufshcd_clock_scaling_unprepare() may submit a device management command
while SCSI command processing is blocked. The deadlock was introduced by
using the SCSI core for submitting device management commands
(scsi_get_internal_cmd() + blk_execute_rq()). Fix this deadlock by callin=
g
blk_mq_unquiesce_tagset() before any device management commands are
submitted by ufshcd_clock_scaling_unprepare().

Fixes: 08b12cda6c44 ("scsi: ufs: core: Switch to scsi_get_internal_cmd()"=
)
Reported-by: Manivannan Sadhasivam <mani@kernel.org>
Reported-by: Roger Shimizu <rosh@debian.org>
Closes: https://lore.kernel.org/linux-scsi/ehorjaflathzab5oekx2nae2zss5vi=
2r36yqkqsfjb2fgsifz2@yk3us5g3igow/
Tested-by: Roger Shimizu <rosh@debian.org>
Cc: Nitin Rawat <nitin.rawat@oss.qualcomm.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 1837ae204d5e..80c0b49f30b0 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1455,15 +1455,14 @@ static int ufshcd_clock_scaling_prepare(struct uf=
s_hba *hba, u64 timeout_us)
 static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba, int err)
 {
 	up_write(&hba->clk_scaling_lock);
+	mutex_unlock(&hba->wb_mutex);
+	blk_mq_unquiesce_tagset(&hba->host->tag_set);
+	mutex_unlock(&hba->host->scan_mutex);
=20
 	/* Enable Write Booster if current gear requires it else disable it */
 	if (ufshcd_enable_wb_if_scaling_up(hba) && !err)
 		ufshcd_wb_toggle(hba, hba->pwr_info.gear_rx >=3D hba->clk_scaling.wb_g=
ear);
=20
-	mutex_unlock(&hba->wb_mutex);
-
-	blk_mq_unquiesce_tagset(&hba->host->tag_set);
-	mutex_unlock(&hba->host->scan_mutex);
 	ufshcd_release(hba);
 }
=20

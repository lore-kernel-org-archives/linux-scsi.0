Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14E691E7C34
	for <linux-scsi@vger.kernel.org>; Fri, 15 Aug 2025 16:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755273673; cv=none; b=PpQASlReP73ny2Jz9u4QWo9MxAc9ANiKmcu1X4wNhky/GwI88OBeIeVBzG0ldpEykLe9h+DEeKKAWvulqMkb4W4qpwRD6MgcnHAa5E6NHtFlcuM6icLmwCov8K09jmkp2HWhXNYPXKhbP2Y2P2Q3l5ngNNT47WICnKz031wbokY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755273673; c=relaxed/simple;
	bh=c/2CS+Y1rQp/18pBi6zU4585K6Jz/qpUXbk6i1iQQUM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ut8A+65ILESKWFobWh6DMzOpbM/XQ6fv1kGYmLDjuyxCdv2bADi/qKDauTGFj7L2/Sg+yjHXsqLusN4npGI0LNay0BBxnuN52iHvnSrtdC9rd44EyDCuWYV1JGiTNnntS9fU0/UMsSgS1Q3MJkH7efUDVTORz6XggBE+vchM2G8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=NU5zPzmP; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="NU5zPzmP"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4c3Rfv05QXzm1751;
	Fri, 15 Aug 2025 16:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1755273668; x=1757865669; bh=kNMaqhy6AC8hLpqIerd9AyjXPJqKaPhTGNL
	WKtk5JXo=; b=NU5zPzmPEprWFrRS9honPcmqcRt0mkhjKcpXyG9Fiy99gwVaVqB
	v3Mm5HyqV6gaJpEPr+tEFgGILVzlN1ACpzpUt1d+t+TpUdVSPqLQqXyY2HbpOwUn
	t4IX/065/mGCSFMjlXDRCmibYmSOn2y27QegoEK9n48LIGKhAy3pEBS5/0lDHv/z
	7wAt4RWr+hK554LKzhPkKLSoxGlPPbAbcgZOc7tNLREpottJ/fGHTNTEyxOjWeAk
	UWSkD3BoYILIvJiDTAYzXCN5+G51qBJS1fH0XYqvk7L8nOCNCoTS6EInAlTSgUUN
	JQYQLd5zVSacecohHMpLMOnX5FLTQIyDRwA==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 0f8rsm3z9oJh; Fri, 15 Aug 2025 16:01:08 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4c3Rfh6DY6zm1757;
	Fri, 15 Aug 2025 16:01:00 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Can Guo <cang@codeaurora.org>,
	Bean Huo <beanhuo@micron.com>,
	Daejun Park <daejun7.park@samsung.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@sandisk.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH] ufs: core: Only collect timestamps if the monitoring functionality is enabled
Date: Fri, 15 Aug 2025 09:00:42 -0700
Message-ID: <20250815160049.473550-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.rc1.163.g2494970778-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Every ktime_get() call in the hot path has a measurable impact on IOPS. H=
ence,
only collect timestamps if the monitoring functionality is enabled.

See also commit 1d8613a23f3c ("scsi: ufs: core: Introduce HBA performance
monitor sysfs nodes"; v5.14).

Cc: Can Guo <cang@codeaurora.org>
Cc: Bean Huo <beanhuo@micron.com>
Cc: Daejun Park <daejun7.park@samsung.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 714d9966431e..027dc0355ae6 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2357,10 +2357,12 @@ void ufshcd_send_command(struct ufs_hba *hba, uns=
igned int task_tag,
 	struct ufshcd_lrb *lrbp =3D &hba->lrb[task_tag];
 	unsigned long flags;
=20
-	lrbp->issue_time_stamp =3D ktime_get();
-	lrbp->issue_time_stamp_local_clock =3D local_clock();
-	lrbp->compl_time_stamp =3D ktime_set(0, 0);
-	lrbp->compl_time_stamp_local_clock =3D 0;
+	if (hba->monitor.enabled) {
+		lrbp->issue_time_stamp =3D ktime_get();
+		lrbp->issue_time_stamp_local_clock =3D local_clock();
+		lrbp->compl_time_stamp =3D ktime_set(0, 0);
+		lrbp->compl_time_stamp_local_clock =3D 0;
+	}
 	ufshcd_add_command_trace(hba, task_tag, UFS_CMD_SEND);
 	if (lrbp->cmd)
 		ufshcd_clk_scaling_start_busy(hba);
@@ -5622,8 +5624,10 @@ void ufshcd_compl_one_cqe(struct ufs_hba *hba, int=
 task_tag,
 	enum utp_ocs ocs;
=20
 	lrbp =3D &hba->lrb[task_tag];
-	lrbp->compl_time_stamp =3D ktime_get();
-	lrbp->compl_time_stamp_local_clock =3D local_clock();
+	if (hba->monitor.enabled) {
+		lrbp->compl_time_stamp =3D ktime_get();
+		lrbp->compl_time_stamp_local_clock =3D local_clock();
+	}
 	cmd =3D lrbp->cmd;
 	if (cmd) {
 		if (unlikely(ufshcd_should_inform_monitor(hba, lrbp)))

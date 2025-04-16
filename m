Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D0691922DD;
	Wed, 16 Apr 2025 00:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744762973; cv=none; b=f2bXOmewbCAk3A/Q+WG0gMjZm0zrTOkSty+9LCs4kMf4yapB3nV/+cxwmw8mxx9muTdDPxauOcNUl9LGBoBbBP5T6WGU3+HBFsZJqEatu0QZdIGwttfW8+93M0LBDS4hbIS1WqCZTb37CCmRzgmk12LZ0DP5Ix77vjlHFd7HTxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744762973; c=relaxed/simple;
	bh=RbiavKUzCZbPrkCX33KFiaPoo7PQdFCOyuVCTAXbVrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F0MVA1ax9AQN0J3tsUXoCUtjyfsMvPoLWIwbcyRtFaib6PM7mfqsjwu9lvq83kGHAooxHjXBPpODQ2oC8oIfK4q4MgR6dnugGl6Iz6k3at9GFhPH5nFC3PE9BEhQBAPrR6Sc9Js1QJ95N9c4d6o6fuBATEUj9BqLzh11CX2k68c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=SvvTZBv3; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="SvvTZBv3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=MIME-Version:Message-ID:Date:Subject:From:Content-Type:From
	:Subject; bh=KCNI+OuOpLCYIeqvaALe5uiUq1bwA+YtpRvrM/oVzkI=; b=SvvTZBv308HtVeLv
	nDPrsDRLyoXqIaeozmVzInXJom3svED+TMDg6iz9C3JpeDQVZXq5KmUTZ1QxXmbQebxJ5bmfGmS6/
	6JQctbSU1nL9Zrltgx61fRZs/ek0jOf4XNVs9dL+0ROepoGaHzZkJoDBnzKdzTLGXbC2Ns3YEnNh5
	RV6SF1y7Edwv2Joh8ThAVOsCo4z2sue0HMndClIUG5x0O+thdS22i9w5jhSkd5MEzGnDyA5qv3/nB
	ykmmbnTroTBxV70fxs/rz7axJvXfJ2OGF2bsT57j2UQ9lJ8MfH5T3g8TVc7MZheui0rNn/dgFJa5T
	0WVQrph8m430IntUzA==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
	by mx.treblig.org with esmtp (Exim 4.96)
	(envelope-from <linux@treblig.org>)
	id 1u4qY1-00Bl42-10;
	Wed, 16 Apr 2025 00:22:37 +0000
From: linux@treblig.org
To: njavali@marvell.com,
	mrangankar@marvell.com,
	GR-QLogic-Storage-Upstream@marvell.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Dr. David Alan Gilbert" <linux@treblig.org>
Subject: [PATCH 2/2] scsi: qedi: Remove unused qedi_get_proto_itt
Date: Wed, 16 Apr 2025 01:22:35 +0100
Message-ID: <20250416002235.299347-3-linux@treblig.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250416002235.299347-1-linux@treblig.org>
References: <20250416002235.299347-1-linux@treblig.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Dr. David Alan Gilbert" <linux@treblig.org>

qedi_get_proto_itt() last use was removed in 2021 by
commit ed1b86ba0fba ("scsi: qedi: Wake up if cmd_cleanup_req is set")

Remove it.

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
---
 drivers/scsi/qedi/qedi_gbl.h  | 1 -
 drivers/scsi/qedi/qedi_main.c | 8 --------
 2 files changed, 9 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_gbl.h b/drivers/scsi/qedi/qedi_gbl.h
index 772218445a56..5e10441f2e22 100644
--- a/drivers/scsi/qedi/qedi_gbl.h
+++ b/drivers/scsi/qedi/qedi_gbl.h
@@ -45,7 +45,6 @@ int qedi_iscsi_cleanup_task(struct iscsi_task *task,
 void qedi_iscsi_unmap_sg_list(struct qedi_cmd *cmd);
 void qedi_update_itt_map(struct qedi_ctx *qedi, u32 tid, u32 proto_itt,
 			 struct qedi_cmd *qedi_cmd);
-void qedi_get_proto_itt(struct qedi_ctx *qedi, u32 tid, u32 *proto_itt);
 void qedi_get_task_tid(struct qedi_ctx *qedi, u32 itt, int16_t *tid);
 void qedi_process_iscsi_error(struct qedi_endpoint *ep,
 			      struct iscsi_eqe_data *data);
diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index e87885cc701c..b168bb2178e9 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -1877,14 +1877,6 @@ void qedi_get_task_tid(struct qedi_ctx *qedi, u32 itt, s16 *tid)
 	WARN_ON(1);
 }
 
-void qedi_get_proto_itt(struct qedi_ctx *qedi, u32 tid, u32 *proto_itt)
-{
-	*proto_itt = qedi->itt_map[tid].itt;
-	QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_CONN,
-		  "Get itt map tid [0x%x with proto itt[0x%x]",
-		  tid, *proto_itt);
-}
-
 struct qedi_cmd *qedi_get_cmd_from_tid(struct qedi_ctx *qedi, u32 tid)
 {
 	struct qedi_cmd *cmd = NULL;
-- 
2.49.0


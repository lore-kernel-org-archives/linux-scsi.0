Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A80822D9EFF;
	Sun,  1 Mar 2026 01:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772330332; cv=none; b=deTeawGOd6t8BqWoWIN6kSKw59pp9uwpouOuk9EGZumGte/9NtebU2ZW+6BFPRUxnoZP05944Jfe/DywnX46wfa2OjuKV91F1izYiOl3qDQvP0NrkuTR+lPkAywuTsg5Fz84sgQ3wQTryYole/+KMM31f+8WwwLM/VFDSUOgI7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772330332; c=relaxed/simple;
	bh=4hi9eizbb3IBmM61iBKMizRqoDTJ319WiFH9XhM/H/0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=b8/4rHG47sM+Bu4tQgGaMbCBQsMZqUuXZMvPvL36gxP+JM+1HwE1f6UnX5/Mkz0Z96zKjGyXRwi2P12zISBgeaRINHaZ/vKJgbT0GYZcKZJK/R+T9VRAXVVIIRFNXZn+jX4ROHXRbL9Wo+8/9jxGfdaHA1gKPEYz6UDqWwC0llA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aDC0rz4O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aDC0rz4O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFD28C19421;
	Sun,  1 Mar 2026 01:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772330332;
	bh=4hi9eizbb3IBmM61iBKMizRqoDTJ319WiFH9XhM/H/0=;
	h=From:To:Cc:Subject:Date:From;
	b=aDC0rz4OUIjgfh7m+ifp2tCqkac8J5pJBeMsMyZAcI4Zi9BF+w/VM2/gcvIr885er
	 Mr+YsTz2V9o/vrMbR26ckBr9hHKx7pOuJ3BM/ZK6wspsBHdd1XRRTBVvGpAMF1KotW
	 ItyZ72Ep8YGlUAdOWtQAwEIbLIxrRR2Z+lKrkrnhTw3w2fPoszQq1YWpx7NK9DHQGl
	 f6Q5cHW8ThpsMDDRjMzOfbi4dgNaO8FkR2gFZT6vK4gMJOcEFyfCr5JpJLBZGAPdzT
	 zwRut6Ox9TAvKPd+k4v9kxZMbdajW6ZAxJ22ZMZgUCdMLhWAgz0BcKBjdHM+lwrr5p
	 196fpC6gpeZxA==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	sdeodhar@marvell.com
Cc: Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <hmadhani2024@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org
Subject: FAILED: Patch "scsi: qla2xxx: Allow recovery for tape devices" failed to apply to 5.10-stable tree
Date: Sat, 28 Feb 2026 20:58:50 -0500
Message-ID: <20260301015850.1724443-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit

The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From b0335ee4fb94832a4ef68774ca7e7b33b473c7a6 Mon Sep 17 00:00:00 2001
From: Shreyas Deodhar <sdeodhar@marvell.com>
Date: Wed, 10 Dec 2025 15:45:58 +0530
Subject: [PATCH] scsi: qla2xxx: Allow recovery for tape devices

Tape device doesn't show up after RSCNs.  To fix this, remove tape
device specific checks which allows recovery of tape devices.

Fixes: 44c57f205876 ("scsi: qla2xxx: Changes to support FCP2 Target")
Cc: stable@vger.kernel.org
Signed-off-by: Shreyas Deodhar <sdeodhar@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <hmadhani2024@gmail.com>
Link: https://patch.msgid.link/20251210101604.431868-7-njavali@marvell.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/qla2xxx/qla_gs.c   | 3 ---
 drivers/scsi/qla2xxx/qla_init.c | 9 ---------
 2 files changed, 12 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 51c7cea71f902..02a52c2157971 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -3266,9 +3266,6 @@ void qla_fab_scan_finish(scsi_qla_host_t *vha, srb_t *sp)
 			    atomic_read(&fcport->state) == FCS_ONLINE) ||
 				do_delete) {
 				if (fcport->loop_id != FC_NO_LOOP_ID) {
-					if (fcport->flags & FCF_FCP2_DEVICE)
-						continue;
-
 					ql_log(ql_log_warn, vha, 0x20f0,
 					       "%s %d %8phC post del sess\n",
 					       __func__, __LINE__,
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 9729e32012aa1..6ce3a492ad6f5 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1859,15 +1859,6 @@ void qla2x00_handle_rscn(scsi_qla_host_t *vha, struct event_arg *ea)
 	case RSCN_PORT_ADDR:
 		fcport = qla2x00_find_fcport_by_nportid(vha, &ea->id, 1);
 		if (fcport) {
-			if (ql2xfc2target &&
-			    fcport->flags & FCF_FCP2_DEVICE &&
-			    atomic_read(&fcport->state) == FCS_ONLINE) {
-				ql_dbg(ql_dbg_disc, vha, 0x2115,
-				       "Delaying session delete for FCP2 portid=%06x %8phC ",
-					fcport->d_id.b24, fcport->port_name);
-				return;
-			}
-
 			if (vha->hw->flags.edif_enabled && DBELL_ACTIVE(vha)) {
 				/*
 				 * On ipsec start by remote port, Target port
-- 
2.51.0





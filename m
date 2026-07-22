Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F83639F184;
	Wed, 22 Jul 2026 06:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784701819; cv=none; b=obcmRxKtCxx5jy8kbe/2IvUIM1KolaN3o8XSKWvwnOEoL0S2/018g6KnLiTUEpMRIIbWBLEe3J5T2ssJ/1wdbAlDgiplzPCU64238F7sNMepWdIiEkgMpkyVuxKUVAZI5DJIvmwosdoYj+IwqGTC2f5T3ypcx/f6tlT0LP1gDGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784701819; c=relaxed/simple;
	bh=yB9BeP8B27SeSIN6pTv9a9Xwndw99Ys1vDKabTh4haY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=eDkjnA447yyL0C2iL9YsjwVWHo3E5TKJOWsT7jVFLpMKU06mU8Kh9qZiT254qoE/EusZ1/DEa8lmc7VWQkLZxJHDB82asOVgTzMc2yx3SvJnL/mhtdNenzxsvs2LXrQcC4CRNG6zx1tDjDUFGtM8+EqU5M8IKIy05BslFww0dVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fdo2Lj6t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fdo2Lj6t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09D8B1F000E9;
	Wed, 22 Jul 2026 06:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784701818;
	bh=DQR3wT8iWrhBjTxw5U4L2DFIr9nhKDPuzWzUxn65AQs=;
	h=From:To:Cc:Subject:Date;
	b=fdo2Lj6tuOj8eFuNrUiWHx/SwtMSrw570RJLM6GPISW1fk1i8X6KnysM0oOOidd1+
	 +gLGJMfplb5Mzn9DnCY4hPMbAsS5r7aT7ajIdFSH1X8Xu5lqSXRBsvqLD+pQsJu1Vp
	 OnbQVQf7wkcj5fsdvBBEDAwyc4LdryWsz5UmeeDJoS60GSnGwmcmNFiksG+OmpIaMK
	 4JrsTOtcLhKnTXiMos8yqE1Xz90cP183+rcWAT6W1zSFH+sV8vs4FlVV7rR7Kcd7bq
	 E6POyLWu4KLjxD4LwZVzLa0ajf2Cs+JolcbslGef1dMhDdE+evCSYUZHq6MAC/Qru5
	 dOnRXzZdYFbCQ==
From: Leon Romanovsky <leon@kernel.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>,
	Mike Christie <michael.christie@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: target: Clear cmd_cnt when initial counter enrollment fails
Date: Wed, 22 Jul 2026 09:30:10 +0300
Message-ID: <20260722-reference-count-underflow-in-target-v1-1-63ab664f12fd@nvidia.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Change-ID: 20260721-reference-count-underflow-in-target-a7e580e549ca
X-Mailer: b4 0.15-dev-18f8f
Content-Transfer-Encoding: 8bit

From: Leon Romanovsky <leonro@nvidia.com>

When target_get_sess_cmd() fails during session shutdown because
percpu_ref_tryget_live() returns false, the command keeps the
se_cmd->cmd_cnt pointer that __target_init_cmd() assigned earlier without
owning a reference. Final release through target_release_cmd_kref() then
issues an unmatched percpu_ref_put().

Commit 8e288be8606a ("scsi: target: Pass in cmd counter to use during cmd
setup") moved the cmd_cnt assignment ahead of the reference acquisition.
Clear se_cmd->cmd_cnt whenever the initial target_get_sess_cmd() fails in
target_init_cmd() and target_submit_tmr(), so release performs exactly one
matching put per acquired reference.

Fixes: 8e288be8606a ("scsi: target: Pass in cmd counter to use during cmd setup")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
Found by sashiko.
---
 drivers/target/target_core_transport.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index fad03a15c969..dcfe94594916 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1734,6 +1734,7 @@ int target_init_cmd(struct se_cmd *se_cmd, struct se_session *se_sess,
 		    u32 data_length, int task_attr, int data_dir, int flags)
 {
 	struct se_portal_group *se_tpg;
+	int ret;
 
 	se_tpg = se_sess->se_tpg;
 	BUG_ON(!se_tpg);
@@ -1763,7 +1764,11 @@ int target_init_cmd(struct se_cmd *se_cmd, struct se_session *se_sess,
 	 * necessary for fabrics using TARGET_SCF_ACK_KREF that expect a second
 	 * kref_put() to happen during fabric packet acknowledgement.
 	 */
-	return target_get_sess_cmd(se_cmd, flags & TARGET_SCF_ACK_KREF);
+	ret = target_get_sess_cmd(se_cmd, flags & TARGET_SCF_ACK_KREF);
+	if (ret)
+		se_cmd->cmd_cnt = NULL;
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(target_init_cmd);
 
@@ -2039,8 +2044,10 @@ int target_submit_tmr(struct se_cmd *se_cmd, struct se_session *se_sess,
 	 * allocation failure.
 	 */
 	ret = core_tmr_alloc_req(se_cmd, fabric_tmr_ptr, tm_type, gfp);
-	if (ret < 0)
+	if (ret < 0) {
+		se_cmd->cmd_cnt = NULL;
 		return -ENOMEM;
+	}
 
 	if (tm_type == TMR_ABORT_TASK)
 		se_cmd->se_tmr_req->ref_task_tag = tag;
@@ -2048,6 +2055,7 @@ int target_submit_tmr(struct se_cmd *se_cmd, struct se_session *se_sess,
 	/* See target_submit_cmd for commentary */
 	ret = target_get_sess_cmd(se_cmd, flags & TARGET_SCF_ACK_KREF);
 	if (ret) {
+		se_cmd->cmd_cnt = NULL;
 		core_tmr_release_req(se_cmd->se_tmr_req);
 		return ret;
 	}

---
base-commit: 74f49255492a62658f36bf2578d7916f1c6ffad1
change-id: 20260721-reference-count-underflow-in-target-a7e580e549ca

Best regards,
--  
Leon Romanovsky <leonro@nvidia.com>


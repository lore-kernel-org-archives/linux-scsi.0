Received: from mail-pj2-f43.google.com (mail-pj2-f43.google.com [74.125.227.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BD8A3314C3
	for <linux-scsi@vger.kernel.org>; Tue, 22 Sep 2026 04:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790053197; cv=none; b=WW40bJddGwc+htAXVpMus2rYqz8wnBXkGUeA82zTIKz+xrfkXzjQ7YDfQtkHE3MhCBvb9IBeFqXb3+3SYbm0JBwAgqPxGAt1AJscOoeJ/DKo/qLYNPZ3D6eex/fg4316APYdN0Ss0cwwvdHOK1PuH6S6lpAQXtFmpq/RqoSgIIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790053197; c=relaxed/simple;
	bh=RdIF8XukB6mLMbrowWjQegMtJnADB0V1+3f+fhgeGw4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZNwFdBYOI7ovyxv/DcxobPutRXihAW7oPvjsk9V91f9m3sHePgmTHxDfLmQ74YuBFDJui6HgmOqKwFm0NMAIDJWRXznVYjTqozQ/d6vNWp4u4sT5a+hbCP5DASVjewODijoitdZpdem7dUa5E5/YsHCOQS7A92VvQZOCbapSees=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OCv905pi; arc=none smtp.client-ip=74.125.227.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OCv905pi"
Received: by mail-pj2-f43.google.com with SMTP id 98e67ed59e1d1-39b2ad83dc6so3245089a91.0
        for <linux-scsi@vger.kernel.org>; Mon, 21 Sep 2026 21:59:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790053195; x=1790657995; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=OaKpuEK5VzBphHr/baBNloyZfCxIvUDsT/1EiLcK14o=;
        b=OCv905pi5KtL7/VE8qi9b30UrX6cm3mcUlRgXiEyMJso7iJRdMW4oWCOOfIAKptuiJ
         BxP+baTAtqyS6KUrtRdjYg2bANgLQi7a4o5WbnYvFR1k0Za8I1e2SdLsvF4+jkvFX3kh
         1biBX2ohpVSDCym0FIb16ZQZvoXXe7MR/9BTOwAIYwTY8YsMhFEfGJT9ve8DjF9DZWVE
         3vrWvNykOIxayiertyK+wz4kW3lTEyTLfb2WVf/HmjsbFbmp4xSCv1JYNtZyR7cVdDa7
         LJrDFz0ZjXooRTw07u7tm3dXqFWU38owoUWr9s2qQhSbWM79blTVi5oBsARZALrb/46A
         1otg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790053195; x=1790657995;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OaKpuEK5VzBphHr/baBNloyZfCxIvUDsT/1EiLcK14o=;
        b=Q4snVQbOvkIYd2dIzW0HhM2f2ZmEsp4+WY5A4xjLdLIODx9De01ZNmKJLxDmGGPq1u
         ufu0bN9FyuhvxYtb3RKZtvSoTmCgXYw5zkUtaqaB30nTmGoXsLf4ZbuuPcOJ7xdGNgmi
         1me2m1xR1qnPFp++Y7UwXYFyD98kM4nQJfTrrx1XkVUIc/2fLT6aJubLCU4Q2ax/+BCA
         bgZkZ4xt4NwJjpb53y0Pp0e0IJD3PF+FAcZ3lvrKgWiJjKhSgr6lonpyjceYPtK1xulr
         Do79ZSr95oHEf62s3v4eQJ5uLHIiVjPXwkY2yLHid0NyOllesM6bq10dMapKuYEYso0f
         TDpw==
X-Gm-Message-State: AFuF++nQUeyugiVHSID1dKQmMEaEqP6FP+bEgPMXRa7skT9SbKuBDn/8
	6JYjHAAH9n78F0/C1Ksk3OSyyf95Ljpqj9jNxWlBi4mtnLL3QVRzmyml
X-Gm-Gg: AYBFou3jCux9Eot9YPbC14GBqQ915anLgReTA2FfuKe03KcxaoC10lRDqZ583f0q1kX
	0Rug4NUhZek5hZoDHsuecTCJSmxQfSSC6nyXcIT4D16H1QU0RdXbX30fK9T4PsjK+iQ7K/Hz+Xp
	+2fJAELrVXqSNI0ODeDzxwU5RUgzDozGJO4IFzA9nhi1B/sy5QiMJDQd25UNrp4AlG7hbDxakp8
	Dd+/GPyv5UZVwn5GMrg/OlUGV00BF9ci9x7hPjv2SIg2oCC2SwBjh/5SI2qN7/LyCdGoV/YxVd8
	uM9QAcVukizLklXPd8SQ12pQv14lm44QMMA/tS6NTw3E7iKAHFV2OBpgFD7qip/fQJtLNP/n0/2
	nlQaM+mOhxpDwomIZwS8ABYAz8EnFZseAQ2k8G830DmaLyQim4l+vdJj5AguQdUsQq5q3dSQPHZ
	V3V10NSmyDpDpw7tFwOPz4TizppAdfHHFgdMxPUCGLSGSDp84wmVjvlpRAKur+o/lVMsYKV0s0Z
	tkYH4rXgqUCfYV+zCzwXG34S2Yk0eOsh15D7ne+YlU=
X-Received: by 2002:a17:90b:4f4c:b0:39e:6a7f:1dcd with SMTP id 98e67ed59e1d1-39e6a7f221fmr12748658a91.41.1790053195504;
        Mon, 21 Sep 2026 21:59:55 -0700 (PDT)
Received: from localhost.localdomain ([202.189.109.160])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0674c321dsm2393796a91.14.2026.09.21.21.59.53
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 21 Sep 2026 21:59:54 -0700 (PDT)
From: Ginger Li <ginger.jzllee@gmail.com>
To: James.Bottomley@HansenPartnership.com,
	mkp@kernel.org
Cc: linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: mvumi: Fix a NULL pointer dereference in mvumi_timed_out()
Date: Tue, 22 Sep 2026 12:59:48 +0800
Message-ID: <20260922045948.10018-1-ginger.jzllee@gmail.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mvumi_timed_out() reads mvumi_priv(scmd)->cmd_priv before it takes host_lock.
If the command completes in the meantime, the interrupt handler clears
cmd_priv in mvumi_complete_cmd(), and mvumi_timed_out() then uses the NULL
pointer for cmd->frame->tag and cmd->queue_pointer.

Read cmd_priv under host_lock and return without doing anything if the command
has already been completed.

Fixes: f0c568a478f0 ("[SCSI] mvumi: Add Marvell UMI driver")
Signed-off-by: Ginger Li <ginger.jzllee@gmail.com>
---
 drivers/scsi/mvumi.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -2111,12 +2111,24 @@ static enum scsi_timeout_action mvumi_timed_out(struct
 
 static enum scsi_timeout_action mvumi_timed_out(struct scsi_cmnd *scmd)
 {
-	struct mvumi_cmd *cmd = mvumi_priv(scmd)->cmd_priv;
 	struct Scsi_Host *host = scmd->device->host;
 	struct mvumi_hba *mhba = shost_priv(host);
+	struct mvumi_cmd *cmd;
 	unsigned long flags;
 
 	spin_lock_irqsave(mhba->shost->host_lock, flags);
+
+	/*
+	 * The command may have been completed by the interrupt handler just
+	 * before the timeout fired, in which case mvumi_complete_cmd() has
+	 * already cleared cmd_priv.  Read the pointer under host_lock so that
+	 * it is consistent with the state of the command.
+	 */
+	cmd = mvumi_priv(scmd)->cmd_priv;
+	if (!cmd) {
+		spin_unlock_irqrestore(mhba->shost->host_lock, flags);
+		return SCSI_EH_NOT_HANDLED;
+	}
 
 	if (mhba->tag_cmd[cmd->frame->tag]) {
 		mhba->tag_cmd[cmd->frame->tag] = NULL;
-- 
2.43.0


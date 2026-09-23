Received: from mail-pz2-f42.google.com (mail-pz2-f42.google.com [74.125.228.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66A4A3B895E
	for <linux-scsi@vger.kernel.org>; Wed, 23 Sep 2026 08:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790152719; cv=none; b=W0mQ+DoHtlNr7sfwF9wOSwEgK8MNRGl1IjU+KV5PPaJ+YF3TRg7ZcBWoLuQA+htVrnRjjMaMSjyv+tWbFNmjzT2sr7Wejm1oDBv551SEk5rsVHrH2gKHZL3MkpPl9+kC89hgKGJQeGGWF8pzvp7upSOluPDwg6jMC6UHCTzwBZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790152719; c=relaxed/simple;
	bh=5MDcLEaso1xaP4AeiREVxfmH9AbDxkQzOHe+BIo5YwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=L0y6ndaiYUoftm/hGkIrhRa5nuJocbl/Vv3xqq5CA1xfmnFVbyLuusT4nwTlAYiF5hDrg/qwMX/pCQUWLNDIQvLlwkCJ5XkyJk/BlPiXFv6GOe7QMAT96Rxwey+4RiIKKlmmeBTvCW10EXj3aXIOEyPqPhlCmtLXmTovUpYYdjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jLoN/6zf; arc=none smtp.client-ip=74.125.228.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jLoN/6zf"
Received: by mail-pz2-f42.google.com with SMTP id 41be03b00d2f7-cc1ceb47d53so154742a12.0
        for <linux-scsi@vger.kernel.org>; Wed, 23 Sep 2026 01:38:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790152702; x=1790757502; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Ru5GUJQ/jJZenl6rNxGccFjH8Yan3srwh4Oocvd7nRs=;
        b=jLoN/6zfm9CbOxH8qxymNFwqCUMt1S25+4Gk+IVP/eN+OwAhQvHqSSDbVjj0ORBAVv
         Ykz8r67tDXSPTI47NPHW1mrUMVvdD6SUNoVKwg76BShDRkTzKMVT1IcPAueu1bo6UmLw
         20gsZaYOzBUQwXYykHt29e9lodbsVkHxe+N4kiE0IM/RAd+A+35nhqZB+JhfXBP4RihP
         EbNN+knskx1vnEVw35aOxSvQBnI0V/yiZA2Uob0t73sM6V767hBrufofEq05MDr2ph3+
         0X4hp6YgulP134edRRWMCSHb3BnqRBt0YvrbNIVDFzmxN5RxrnTT4gPL7WQHhCO6YwFk
         zSZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790152702; x=1790757502;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ru5GUJQ/jJZenl6rNxGccFjH8Yan3srwh4Oocvd7nRs=;
        b=bOqDs+wBwoK+Uh+Am/dxbcjIhEoeOZs+3JsPNPbdMXxigbw+Ltj7bGJAkJzeBXOtdf
         WkezfSrCzwSq+EwMcULbGrEGbFd3MJWFNZoynEZSJxA1KWp8cSi4ndOC02RVuKEDmI3b
         oJdCQ5u5GDU7YkMVEKfXcb0p0Zk2AzOLvsKkQ+YIqhIpXCLnnUXLvz6qC/QKirwSdVlj
         X5/Hpw8lYjDq5UQn6bIwgcOX+vQpjKd7Or+1KwRhY17xKfdVnwjRlwo0eBPU0mIQUTul
         YUUnSSgI4dnMrrUtY83kqiUFBgWrwu0LL+PyEqqIABz0/QoHp+YIDUO1N0EAUtAEIEIc
         QrHQ==
X-Gm-Message-State: AFuF++kd5djGcIIKGt8MnDhY5OegX1bE9fKwQFpPtBtfeLdLWKqj/DFr
	yQWjHGd5zT0sQoLhDiE/iuzoLI+V37lYlNLC/uRruuLdFQrtb2T/xMkX3OjxGRro
X-Gm-Gg: AYBFou0GASXrqrRDrM1bOws7Z7dXXapLG1brVsE3dnzHy5kN74fIu6LYP8alR7FmcYq
	PBgDVGXMI3KwmxKUXaGZVNs6UpPhovoxhTU3KJyR3AAODHCXxtbgYO/NtzhdiWZAqr2QwXg2LHy
	3/yvPvVzIlhfI0DfrtLt2pyS5Oc2OGIr1An0+C7LgWKg+bEhE4JFePPOPcaWtsLHepp4pFQkHhx
	FBdFefwHYvOoBHcVe3bsYX++mgafnq8eV08zV9AJa7Ig7o0YEGgfT3mv4loNyVxLKlzYiorrn3v
	mPibEMydhDJsl9bHb/C4K4RE4Dw/qzSYBoju8IoTYo5qpyOPcNvoksI6mn/mZ5NSY3gVr+WccyP
	u0QLNxFxnJXO8USWRoMBCjfuZtIfZii/Ar3N0CLiXXg4cyUWnBO18jfrO7lW7oSmKnd2st0BlQQ
	bNAFBEiDRc+1ZZaF2I9XxaklY2yiILUeGdp8oaySpbihErLgqF4DaIhIAuiicPHoHju28NdjDOf
	2a16e4pxN4h5xnarKISgIaZRIMlz2cqPcqPwB2RYEeJ9XRknQyKLc+dNp0jGUWziRFfk36SegAH
	tw==
X-Received: by 2002:a17:90b:50c3:b0:39e:6a7f:618b with SMTP id 98e67ed59e1d1-3a07e595addmr1182846a91.28.1790152701752;
        Wed, 23 Sep 2026 01:38:21 -0700 (PDT)
Received: from localhost.localdomain (ec2-13-212-242-176.ap-southeast-1.compute.amazonaws.com. [13.212.242.176])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a07dbc5451sm4314920a91.7.2026.09.23.01.38.19
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 23 Sep 2026 01:38:21 -0700 (PDT)
From: Ginger Li <ginger.jzllee@gmail.com>
To: bootc@bootc.net,
	mkp@kernel.org
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux1394-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: target: sbp: Protect agent->orb_pointer and agent->doorbell with the lock
Date: Wed, 23 Sep 2026 16:38:13 +0800
Message-ID: <20260923083813.64892-1-ginger.jzllee@gmail.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

tgt_agent_rw_orb_pointer() and tgt_agent_rw_doorbell() update
agent->orb_pointer and agent->doorbell after they have dropped agent->lock,
while the work item tgt_agent_fetch_work() reads both fields to decide which
ORB to process.

The work item already accesses the fields under the lock when it updates them
and tgt_agent_check_active() takes the lock as well, so the unlocked stores
and this unlocked read race with each other.  The work item can then use an
ORB pointer that has been replaced by a newer request, or miss the doorbell
that belongs to the current one.

Update and read the two fields while holding agent->lock.

Fixes: a511ce339780 ("sbp-target: Initial merge of firewire/ieee-1394 target mode support")
Signed-off-by: Ginger Li <ginger.jzllee@gmail.com>
---
 drivers/target/sbp/sbp_target.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/target/sbp/sbp_target.c b/drivers/target/sbp/sbp_target.c
--- a/drivers/target/sbp/sbp_target.c
+++ b/drivers/target/sbp/sbp_target.c
@@ -721,10 +721,9 @@ static int tgt_agent_rw_orb_pointer(struct fw_card *ca
 			return RCODE_CONFLICT_ERROR;
 		}
 		agent->state = AGENT_STATE_ACTIVE;
-		spin_unlock_bh(&agent->lock);
-
 		agent->orb_pointer = sbp2_pointer_to_addr(ptr);
 		agent->doorbell = false;
+		spin_unlock_bh(&agent->lock);
 
 		pr_debug("tgt_agent ORB_POINTER write: 0x%llx\n",
 				agent->orb_pointer);
@@ -757,10 +756,9 @@ static int tgt_agent_rw_doorbell(struct fw_card *card,
 			return RCODE_CONFLICT_ERROR;
 		}
 		agent->state = AGENT_STATE_ACTIVE;
+		agent->doorbell = true;
 		spin_unlock_bh(&agent->lock);
 
-		agent->doorbell = true;
-
 		pr_debug("tgt_agent DOORBELL\n");
 
 		queue_work(system_dfl_wq, &agent->work);
@@ -933,9 +931,14 @@ static void tgt_agent_fetch_work(struct work_struct *w
 	struct sbp_session *sess = agent->login->sess;
 	struct sbp_target_request *req;
 	int ret;
-	bool doorbell = agent->doorbell;
-	u64 next_orb = agent->orb_pointer;
+	bool doorbell;
+	u64 next_orb;
 
+	spin_lock_bh(&agent->lock);
+	doorbell = agent->doorbell;
+	next_orb = agent->orb_pointer;
+	spin_unlock_bh(&agent->lock);
+
 	while (next_orb && tgt_agent_check_active(agent)) {
 		req = sbp_mgt_get_req(sess, sess->card, next_orb);
 		if (IS_ERR(req)) {
-- 
2.43.0


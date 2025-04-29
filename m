Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0580F2D557F;
	Tue, 29 Apr 2025 23:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745970802; cv=none; b=uE9rAIZe8vrY2pJghT3zBDDpgVHVZPRIG/lb/Sv7ZZrn9twytVMqW0aTPcj38q7OiKvqnrLxFHRe50iv/Zz/WYo+8kOMLP6tlrcVJJeuXHw12BXnRG+E5YvSnDP4+5IogXZ9IycXiYxXxucyuRQuMwayPLyWbOwra+dStGi3JQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745970802; c=relaxed/simple;
	bh=qLCS3tCIkyIT4QO76cRxABly/Xab58us3KObZz8eMsc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=MjU5E7UEF54WzH54PFd2hIPCMoqzRqqF1w6+tWVTuFuL1VPBWqcMJEojuX68p6ZSM7EwYclrzI+/XHDpZ/agXvWZIa1yrf/JYUl40AeNfjw2whGFt0B+JEUCgvr0fab22RvRlnrS9tFCMVvvEW83nwAoLlK9T7z0llwAowprpbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fRMXlB4/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fRMXlB4/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 178DBC4CEE3;
	Tue, 29 Apr 2025 23:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745970801;
	bh=qLCS3tCIkyIT4QO76cRxABly/Xab58us3KObZz8eMsc=;
	h=From:To:Cc:Subject:Date:From;
	b=fRMXlB4/voqMF+xSsSYCiSkbu/89pDqbWQ4mJ58mDW+QApnswvO6ylqvqEGo2m8QR
	 Kv/PaIDBZU9J2U4BWbBqEPmOWNpyno8CpcJOQuziGJ2lnAyq4rHrPjMGaCguEu99DQ
	 zXIEdSoxdvyaQGEPKPphkNm0XTcZHf9UQYCSDAh28tb5MwwFbXEnJISoTWRc/DwSdM
	 wP97mDbc8khXvc3Y4i/UBFEBBE+irAPDZ5SN3Eo73UN6IT/GwiPCpqGs4V3o3zsFdu
	 C+yDheaVIop7lokap4086SjITEcVYQCPrZyRFCL1tXuhp/TFzA+SP9jftrY4Xm9l83
	 6BUgk6WmhTNJA==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Dmitry Bogdanov <d.bogdanov@yadro.com>,
	Maurizio Lombardi <mlombard@redhat.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	linux@treblig.org,
	ebiggers@google.com,
	ardb@kernel.org,
	viro@zeniv.linux.org.uk,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 01/10] scsi: target: iscsi: Fix timeout on deleted connection
Date: Tue, 29 Apr 2025 19:53:06 -0400
Message-Id: <20250429235316.538129-1-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.135
Content-Transfer-Encoding: 8bit

From: Dmitry Bogdanov <d.bogdanov@yadro.com>

[ Upstream commit 7f533cc5ee4c4436cee51dc58e81dfd9c3384418 ]

NOPIN response timer may expire on a deleted connection and crash with
such logs:

Did not receive response to NOPIN on CID: 0, failing connection for I_T Nexus (null),i,0x00023d000125,iqn.2017-01.com.iscsi.target,t,0x3d

BUG: Kernel NULL pointer dereference on read at 0x00000000
NIP  strlcpy+0x8/0xb0
LR iscsit_fill_cxn_timeout_err_stats+0x5c/0xc0 [iscsi_target_mod]
Call Trace:
 iscsit_handle_nopin_response_timeout+0xfc/0x120 [iscsi_target_mod]
 call_timer_fn+0x58/0x1f0
 run_timer_softirq+0x740/0x860
 __do_softirq+0x16c/0x420
 irq_exit+0x188/0x1c0
 timer_interrupt+0x184/0x410

That is because nopin response timer may be re-started on nopin timer
expiration.

Stop nopin timer before stopping the nopin response timer to be sure
that no one of them will be re-started.

Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
Link: https://lore.kernel.org/r/20241224101757.32300-1-d.bogdanov@yadro.com
Reviewed-by: Maurizio Lombardi <mlombard@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/iscsi/iscsi_target.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 07e196b44b91d..04d40e76772b3 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4314,8 +4314,8 @@ int iscsit_close_connection(
 	spin_unlock(&iscsit_global->ts_bitmap_lock);
 
 	iscsit_stop_timers_for_cmds(conn);
-	iscsit_stop_nopin_response_timer(conn);
 	iscsit_stop_nopin_timer(conn);
+	iscsit_stop_nopin_response_timer(conn);
 
 	if (conn->conn_transport->iscsit_wait_conn)
 		conn->conn_transport->iscsit_wait_conn(conn);
-- 
2.39.5


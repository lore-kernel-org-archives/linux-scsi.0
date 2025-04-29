Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D46812DCB75;
	Tue, 29 Apr 2025 23:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745970625; cv=none; b=q/z5chzY+uK8SSJ5jDQjOYk03Ug15fj4DB5RnL3kB9I81Ppfvj7GE6X+z3GXSNkK9yOGjmR0ooDdUHnne0KOXGSqsMpa5qUwANZSu/9M7LipxM+Bk8kx2FOC8rvXwGYoJ/DGrXMEXETO180NQ0rJjiS3GqhA2AYUA+qhuzmFp4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745970625; c=relaxed/simple;
	bh=a7k02qLmMDTllQLkzH5LHgRJ+bfx3pBDplo3NLh8tEw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gmRs0QuPm+5JGFWXewETLMysOvXYiV3j1qaKbf52eYOrtYVAmwEI0B4g/05z+1cdBLMEUfCwe2tQOm876wawYmJMsU7ew4ASg4vVIDUSrie86pOMH+bqD6Gc7645dFZo1MlHhuCqWxk0XLEbn8BmvlaW6uaNAK8odbPpUEH1Pik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dBFcMjhH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dBFcMjhH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65975C4CEEB;
	Tue, 29 Apr 2025 23:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745970624;
	bh=a7k02qLmMDTllQLkzH5LHgRJ+bfx3pBDplo3NLh8tEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dBFcMjhH2oHG4ICsf9pjCm33/WVOcYjtmILaiwerMJslwajZ7GKP0jcQkhxV9kiqh
	 qZlxw/OxaqEPSqUd8dOuKgymOaBkY8EMdq7tmxNzjZe7PkvDlAMajfXuEyvd7YSH4T
	 OIo3U7KqceVbNG+JzITggwWgf1IkL4ByN8aJl5FZi3Di7H8LD+18ZCH+LPd1AqC+78
	 AThyVblQ2btSp3Rpd8bcWvpJ8isG7KfzzdXL1brRQ4uAgcP+cpzQkN9dS11W/rhpCE
	 DPUIYDOXvyR5QXOARBbqwk/oJQHoof9l2cHov2UC0BRFv8Eiw8CO45AyF58bitAl6K
	 yA7Qh8PuPNU+w==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Dmitry Bogdanov <d.bogdanov@yadro.com>,
	Maurizio Lombardi <mlombard@redhat.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	ardb@kernel.org,
	ebiggers@google.com,
	linux@treblig.org,
	viro@zeniv.linux.org.uk,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.14 09/39] scsi: target: iscsi: Fix timeout on deleted connection
Date: Tue, 29 Apr 2025 19:49:36 -0400
Message-Id: <20250429235006.536648-9-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250429235006.536648-1-sashal@kernel.org>
References: <20250429235006.536648-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.4
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
index 1244ef3aa86c1..620ba6e0ab075 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4263,8 +4263,8 @@ int iscsit_close_connection(
 	spin_unlock(&iscsit_global->ts_bitmap_lock);
 
 	iscsit_stop_timers_for_cmds(conn);
-	iscsit_stop_nopin_response_timer(conn);
 	iscsit_stop_nopin_timer(conn);
+	iscsit_stop_nopin_response_timer(conn);
 
 	if (conn->conn_transport->iscsit_wait_conn)
 		conn->conn_transport->iscsit_wait_conn(conn);
-- 
2.39.5


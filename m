Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CC36248F54;
	Tue, 29 Apr 2025 23:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745970825; cv=none; b=HMZnsqAVY7m83YeyOP8cG0x23HyFzU8rTB2eG0oxEKwF8VOseqqbDCq0ARCYmBMrxanmmT79ql890vjMUCT0PQl5+M8+SgfO0RakxlXsn3jVz5MvjRl6CmYT8yzwQHoe3yzP1SS7Q+pxgesQcGh4qtrQzi+ch4M4mr/uVZh9bkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745970825; c=relaxed/simple;
	bh=RRj6F2BZA9TgE0RpxN8xBByEwnh5uXhrZs3u/lfN2W4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=UduqmyVCPj0E6Qi21QINCQpuvI+XzkCVzPKz/W045tCy5BVGVCxa9+tr/OgV8ks/iBKsuKXbMi5pSws32C+RmJv/NglvoOoMXNqeQwB1SJ3X2WbeDfICzr0FjOooMiYjYcfyh9U6RxGFZ4pvxIWelO05/2B/tXwI5z+kaEqdI6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lC6jA/bv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lC6jA/bv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C798C4CEE3;
	Tue, 29 Apr 2025 23:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745970825;
	bh=RRj6F2BZA9TgE0RpxN8xBByEwnh5uXhrZs3u/lfN2W4=;
	h=From:To:Cc:Subject:Date:From;
	b=lC6jA/bvjDWhCfMQ3iDCO0YPDA3gu6cKUCChclsf7+4Urpa7PYHbG1pnRlPpNw99Y
	 UXw+6U7+duNjo54wMgYjVxrxzuoieVx0aa24yAPDt0OtbyNCF7wEyF7isU8jKEum+s
	 vvFewrDLShn7LLXF3TaPhh+0Dc3u+1dI25NN5BD6h4sMGe361Lh9bY/4AJFsMaxuoj
	 Yaqiq/EDnlAO1/ctHIhAX8sxir0Kjip9mZwqXNZ/s0gJazT5/dAd4c+PaR3vpuZHVo
	 H+jfpSNGPVu94Kb7UTLqr1X+aywAe5zp2X/HuGK6PAa4g1gvN9JzLdYBYfccqysps5
	 SP2T6pPNi02EQ==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Dmitry Bogdanov <d.bogdanov@yadro.com>,
	Maurizio Lombardi <mlombard@redhat.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	ardb@kernel.org,
	linux@treblig.org,
	viro@zeniv.linux.org.uk,
	ebiggers@google.com,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 1/7] scsi: target: iscsi: Fix timeout on deleted connection
Date: Tue, 29 Apr 2025 19:53:32 -0400
Message-Id: <20250429235339.538269-1-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.15.180
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
index 686a9e5918e21..b072718701329 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4170,8 +4170,8 @@ int iscsit_close_connection(
 	spin_unlock(&iscsit_global->ts_bitmap_lock);
 
 	iscsit_stop_timers_for_cmds(conn);
-	iscsit_stop_nopin_response_timer(conn);
 	iscsit_stop_nopin_timer(conn);
+	iscsit_stop_nopin_response_timer(conn);
 
 	if (conn->conn_transport->iscsit_wait_conn)
 		conn->conn_transport->iscsit_wait_conn(conn);
-- 
2.39.5


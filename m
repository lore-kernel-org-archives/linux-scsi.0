Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25F3228D2EC;
	Tue, 29 Apr 2025 23:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745970701; cv=none; b=J4UEJpRWHcyR7eU8Nz9WmeEL5BAqQVtZ+JgYaZS86zgGJFSZeUjvEeq3eKAVfQgbQb7G1bgKoKIqxRrBxxzOyMHtQuuG0EyK+J7Uezt+L37HEgViRfdsFwzioVdLecYIRPnyYCez7BpgmMdg64jR6VfAgxxvWNORt5jc419/Lm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745970701; c=relaxed/simple;
	bh=ofhStOBBu44WNh/kOYbGD9CXZ7JH5SbkINp/KuxRD70=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=e/VWUuYKMGT8JEPgntbdHL5tXG9Z06Bb/jeG6ILt1pu9XXCW0jd3Zr9yEmPATHKBixhalV37Col0gJXs/cESKHBdLjJ4i/zttTYhjQ+R3fI36GM0t28mlMAqjMboQ5XOI3HiL0HqQupkuXNx+kbnmIBN+AQaevx66nFhR+NBdyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GQST++pr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GQST++pr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 110F8C4CEE3;
	Tue, 29 Apr 2025 23:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745970700;
	bh=ofhStOBBu44WNh/kOYbGD9CXZ7JH5SbkINp/KuxRD70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GQST++prxUY9xy6doEN4ANlO+2JtHxnzFJ6HX9CFGFo3UcMx/1xW+l4EQz5/G4SKc
	 ZFysx/S6kJ/vqEW/KXLirG67ov1Z2Gdq7nm9t3Z/QQaluX5l8c6NstmUcllBTmoS5G
	 kINsseyeLP5ZMmnChp5hnGJAFWMWCJTeyIKMmfH39yRVx1cb1vjiZHoQNXP0302rGM
	 KR/baC6J0Bu15PQq0eioZEbbCuAJwbKqL6KSG8YEjfz7R0W2eNGzUzUOSjMl1sqxyi
	 vJqa7G9QAoxXHkrWHdsLYd8OmegJ9xLA+68CJ9YIEvh1Q1cPZ+qFrqX93axVrJuL1l
	 dN9Gry+HRc8Rw==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Dmitry Bogdanov <d.bogdanov@yadro.com>,
	Maurizio Lombardi <mlombard@redhat.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	linux@treblig.org,
	ardb@kernel.org,
	viro@zeniv.linux.org.uk,
	ebiggers@google.com,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.12 09/37] scsi: target: iscsi: Fix timeout on deleted connection
Date: Tue, 29 Apr 2025 19:50:54 -0400
Message-Id: <20250429235122.537321-9-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250429235122.537321-1-sashal@kernel.org>
References: <20250429235122.537321-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.25
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
index 6002283cbebab..68bbdf3ee101d 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4317,8 +4317,8 @@ int iscsit_close_connection(
 	spin_unlock(&iscsit_global->ts_bitmap_lock);
 
 	iscsit_stop_timers_for_cmds(conn);
-	iscsit_stop_nopin_response_timer(conn);
 	iscsit_stop_nopin_timer(conn);
+	iscsit_stop_nopin_response_timer(conn);
 
 	if (conn->conn_transport->iscsit_wait_conn)
 		conn->conn_transport->iscsit_wait_conn(conn);
-- 
2.39.5


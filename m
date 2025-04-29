Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A49DB2DBB27;
	Tue, 29 Apr 2025 23:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745970842; cv=none; b=i3kSajz+r2/UbnuGVMZQpYUqeLwVfwczK0OleaWEBuzgxZeQ6amz1qGZRVpk8HlmVphtCs0KOoQBoZVhggy7YfSalskRyFXwWLOg248NaUy6mLuZ4RBnqIrObtHuY6LJ4SnqaHjgKlB+if4I14GXRQraEQ7qETWNiIiJeDDRMpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745970842; c=relaxed/simple;
	bh=NmWJglNYPADg72kVQTeC+hCvh2f9FYFgQWciw8auiA8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Yi0JCJGrkYv9cLd74f+P+M5AKcpwDmh/2T/2QL0DTo1e+L9RUJKgVuFV2NUw9J1R724kwz1uhCE8tgUIjXRGuoWU8OmSwdnjwYPYFAs36UFns/r7mEgL5OidwmVa+PYCiQDzkha24U1sM9LncDGadKHJxZN3cQEGB4SCBm9qXTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f8canMWp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f8canMWp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B69D4C4CEE3;
	Tue, 29 Apr 2025 23:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745970842;
	bh=NmWJglNYPADg72kVQTeC+hCvh2f9FYFgQWciw8auiA8=;
	h=From:To:Cc:Subject:Date:From;
	b=f8canMWpElYAxOGoDqro70MjOtToZ5fUl0JsM8qh7GJ7KUyqelE7Cf0KH6omwHoZS
	 7h3olDloU2zPy4xq6xXehSG5BA6P9K+wP8o5aD7rRKj/BCGsi835gTMr0ACllMwjeU
	 9zwPyMyVNkpP+FnRAD1Pb6cVNqTCx6b+L7BCpz5bWz9rQDx+lAo5xjgig2vmHrKgXV
	 kQ2AaUPGQ7l/nBVnce6wJG8w+zCf75Am4fBsb4isXvirAI5IEqnAW922D20cp7H0F1
	 7lXxkLMSUp1Y9kRuRk0zV9P4j8WK6ZmaHEFIxtH5g/QSuoWSAHyGkSbh/rEjIPDgL4
	 h/uNA6/4EYVKA==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Dmitry Bogdanov <d.bogdanov@yadro.com>,
	Maurizio Lombardi <mlombard@redhat.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	ardb@kernel.org,
	linux@treblig.org,
	ebiggers@google.com,
	viro@zeniv.linux.org.uk,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 1/3] scsi: target: iscsi: Fix timeout on deleted connection
Date: Tue, 29 Apr 2025 19:53:53 -0400
Message-Id: <20250429235356.538413-1-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.10.236
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
index 075e2a6fb474f..48fe53323f84c 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4168,8 +4168,8 @@ int iscsit_close_connection(
 	spin_unlock(&iscsit_global->ts_bitmap_lock);
 
 	iscsit_stop_timers_for_cmds(conn);
-	iscsit_stop_nopin_response_timer(conn);
 	iscsit_stop_nopin_timer(conn);
+	iscsit_stop_nopin_response_timer(conn);
 
 	if (conn->conn_transport->iscsit_wait_conn)
 		conn->conn_transport->iscsit_wait_conn(conn);
-- 
2.39.5


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6061D274B22;
	Tue,  5 Aug 2025 13:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754399513; cv=none; b=V5X5eFhQdwGnCjAWfkELD0rzscVX3H0ZuXvmtabPwehoc60F22R8IXEGRflgSVbyEdfXuB8nIXG4Tae3YwS8BCsuGlmB4xeyn5t/VthaEUkhBKrpRouin/hXeAZKS/YvO4eJXi9pfHUNHqQA6UGHVL+Wira0akPjr2fza1Osaks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754399513; c=relaxed/simple;
	bh=6uIb4nkt7xiCZha/sR4CrJA8W+MSMbEi2oBzsmeitns=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VbVxkXE3oAlyj9iD3IhehoaLzGF9521ZdH+VLXQqEp1lJdu4GXPtqP0ni2iNOtaar/Au69f75adJDMMeEA/DmRKzJ+tIPdXpn1x4o5iYE1mR3A1vcakwegpJ3v/9L2STMmxudf9ZTsm1Z/cMKtTeCdOekYpQQ//NUnxfnKQ1IDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KeX1sK3h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KeX1sK3h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BF1DC4CEF0;
	Tue,  5 Aug 2025 13:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754399513;
	bh=6uIb4nkt7xiCZha/sR4CrJA8W+MSMbEi2oBzsmeitns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KeX1sK3h0rXSPGVMpJAdsn6m2XI0pq+kNt3XS+WvFS8q7YUzIvyJtTTN/vEUY6EP4
	 R7JdMyl2fnzbhNh+LM9Kosgv5TxPY6Oy/dPcQZ/ZKABvL3gpISaGrhwy8tw72yoUf5
	 wei7norbf3FdgiT09AwKTtDsiyR98OAker4so698QmPYOo3rESYFfjfB/Ekp27h/pX
	 TMJyuBkbaoichp8AFQOWksK+7G5GsTGz/qKMxok1EgxMSFj1bkWZGrKtTp00CSUR5n
	 Ryv2x5+M6ULCuYIz2bNZiZjYPssK9m1b20XIbcFZJZB2rZIo6LUnIWgw88QZY7w2gU
	 5GMB6bb6RmOfA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Showrya M N <showrya@chelsio.com>,
	Potnuri Bharat Teja <bharat@chelsio.com>,
	Chris Leech <cleech@redhat.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	lduncan@suse.com,
	michael.christie@oracle.com,
	James.Bottomley@HansenPartnership.com,
	open-iscsi@googlegroups.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.16-5.4] scsi: libiscsi: Initialize iscsi_conn->dd_data only if memory is allocated
Date: Tue,  5 Aug 2025 09:09:31 -0400
Message-Id: <20250805130945.471732-56-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250805130945.471732-1-sashal@kernel.org>
References: <20250805130945.471732-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16
Content-Transfer-Encoding: 8bit

From: Showrya M N <showrya@chelsio.com>

[ Upstream commit 3ea3a256ed81f95ab0f3281a0e234b01a9cae605 ]

In case of an ib_fast_reg_mr allocation failure during iSER setup, the
machine hits a panic because iscsi_conn->dd_data is initialized
unconditionally, even when no memory is allocated (dd_size == 0).  This
leads invalid pointer dereference during connection teardown.

Fix by setting iscsi_conn->dd_data only if memory is actually allocated.

Panic trace:
------------
 iser: iser_create_fastreg_desc: Failed to allocate ib_fast_reg_mr err=-12
 iser: iser_alloc_rx_descriptors: failed allocating rx descriptors / data buffers
 BUG: unable to handle page fault for address: fffffffffffffff8
 RIP: 0010:swake_up_locked.part.5+0xa/0x40
 Call Trace:
  complete+0x31/0x40
  iscsi_iser_conn_stop+0x88/0xb0 [ib_iser]
  iscsi_stop_conn+0x66/0xc0 [scsi_transport_iscsi]
  iscsi_if_stop_conn+0x14a/0x150 [scsi_transport_iscsi]
  iscsi_if_rx+0x1135/0x1834 [scsi_transport_iscsi]
  ? netlink_lookup+0x12f/0x1b0
  ? netlink_deliver_tap+0x2c/0x200
  netlink_unicast+0x1ab/0x280
  netlink_sendmsg+0x257/0x4f0
  ? _copy_from_user+0x29/0x60
  sock_sendmsg+0x5f/0x70

Signed-off-by: Showrya M N <showrya@chelsio.com>
Signed-off-by: Potnuri Bharat Teja <bharat@chelsio.com>
Link: https://lore.kernel.org/r/20250627112329.19763-1-showrya@chelsio.com
Reviewed-by: Chris Leech <cleech@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I see the pattern clearly! When `iscsi_alloc_conn` is called with
`dd_size = 0`:
- It allocates only `sizeof(*conn)` (no extra space)
- It sets `conn->dd_data = NULL` (because dd_size is 0, the condition
  `if (dd_size)` is false)

But in the original code in `iscsi_conn_setup()`, it was unconditionally
setting:
```c
conn->dd_data = cls_conn->dd_data + sizeof(*conn);
```

This would set `conn->dd_data` to point past the allocated memory when
`dd_size = 0`, leading to the panic when the iSER driver tries to
dereference it in `iscsi_iser_conn_stop()`.

**Backport Status: YES**

This commit should definitely be backported to stable kernel trees for
the following reasons:

1. **Critical Bug Fix**: This fixes a kernel panic/crash that occurs
   during iSCSI/iSER connection teardown when memory allocation fails.
   The panic trace shows a page fault at address `fffffffffffffff8`,
   which is clearly an invalid pointer dereference.

2. **Real-World Impact**: The bug triggers when `ib_fast_reg_mr`
   allocation fails during iSER setup, which can happen under memory
   pressure. This leads to a system crash during error recovery, turning
   a recoverable allocation failure into a fatal kernel panic.

3. **Small and Contained Fix**: The fix is minimal - just adding a
   single conditional check:
  ```c
  if (dd_size)
  conn->dd_data = cls_conn->dd_data + sizeof(*conn);
  ```
  This only affects the initialization path when `dd_size = 0`.

4. **No Architectural Changes**: This is a straightforward bug fix that
   doesn't introduce new features or change any architecture. It simply
   prevents setting an invalid pointer when no driver-specific data is
   allocated.

5. **Clear Root Cause**: The issue is well-understood: when drivers like
   iSER pass `dd_size = 0` to `iscsi_conn_setup()`, the code was
   unconditionally calculating a pointer past the allocated memory.
   During teardown, accessing this invalid pointer causes the panic.

6. **Minimal Risk**: The change only affects the case where `dd_size =
   0`, which is specifically the iSER driver's usage pattern. Other
   drivers that pass non-zero `dd_size` values are unaffected.

7. **Follows Stable Rules**: This meets all stable kernel criteria:
   - Fixes a real bug that users can hit
   - Fix is already upstream (has proper sign-offs and review)
   - Small change (2 lines)
   - Obviously correct
   - Doesn't add new features

The commit prevents a kernel panic during error handling in the
iSCSI/iSER subsystem, making it an important stability fix that should
be backported to all maintained stable kernels that include the iSER
driver.

 drivers/scsi/libiscsi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 392d57e054db..c9f410c50978 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -3185,7 +3185,8 @@ iscsi_conn_setup(struct iscsi_cls_session *cls_session, int dd_size,
 		return NULL;
 	conn = cls_conn->dd_data;
 
-	conn->dd_data = cls_conn->dd_data + sizeof(*conn);
+	if (dd_size)
+		conn->dd_data = cls_conn->dd_data + sizeof(*conn);
 	conn->session = session;
 	conn->cls_conn = cls_conn;
 	conn->c_stage = ISCSI_CONN_INITIAL_STAGE;
-- 
2.39.5


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 336B0226D1D;
	Tue, 24 Jun 2025 04:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750738401; cv=none; b=hN1srWoGKeSDsGHEZw+LG13E/LlhFvqHoudbSxkI1U/Aoau9WiNAOwcvanJ12vXUvC9Ms8haoGf27rszQoHvShz2XmT5f687QfiHdWk9fTX+S2i5W8e/IfMelse8PhVO84mEe/ty+KawmCWP4pxxLenOpml/X/OKdmuoPSXHeVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750738401; c=relaxed/simple;
	bh=ecQyuLhBpmBHb1XD43VJf6smQfc/1veiQMrSiP2Dkfk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EqhupBxlLXpVgUmqTbn2+aaFcB6tU1+95beDOgWawGFsglX+eX9+farkSj2QK6/Gg55LdsSZj6bgm1Q7ALFBj93AnVLDKvqj4144RvwCiPUkgmPtQaQJTgvZUYES1lLyVYKzXltWcvRiciymhrogTefLeHY8i8DxXCdM6LQZR6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MVy749Y4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MVy749Y4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0347C4CEEF;
	Tue, 24 Jun 2025 04:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750738401;
	bh=ecQyuLhBpmBHb1XD43VJf6smQfc/1veiQMrSiP2Dkfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MVy749Y45Gt+WJHsoonklitOINSdxOEuRIVyzdg9x22s0aNPgUm+JPbZvhCIEwURL
	 LLRS1dAPC3Xc6159sjoR2zXoxkBnJMdif75/GrEEDgbc3wUnJb9Ax/JrRauP0P+fxv
	 nQ++UcKkBjptibn/GtNFfCuvarus8XZoCXjiifw7W963HBUfJ2AreAbkk94TbQ0nmi
	 MJVhaRkIjtCAOuFZhc472gn/0izvhK5P/9HiEb0VkyML1RuyKIX+Zbfn65ZhgSpTJv
	 fxY5kiFs5ZGF9FyKazTIW2FL8jANU6Rm9Afebt36StaZEZMvduFfJiwZ7Fex3rCDm+
	 QYrDqu0LFrhTw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Maurizio Lombardi <mlombard@redhat.com>,
	Mike Christie <michael.christie@oracle.com>,
	John Meneghini <jmeneghi@redhat.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 4/8] scsi: target: Fix NULL pointer dereference in core_scsi3_decode_spec_i_port()
Date: Tue, 24 Jun 2025 00:13:11 -0400
Message-Id: <20250624041316.85209-4-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250624041316.85209-1-sashal@kernel.org>
References: <20250624041316.85209-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.10.238
Content-Transfer-Encoding: 8bit

From: Maurizio Lombardi <mlombard@redhat.com>

[ Upstream commit d8ab68bdb294b09a761e967dad374f2965e1913f ]

The function core_scsi3_decode_spec_i_port(), in its error code path,
unconditionally calls core_scsi3_lunacl_undepend_item() passing the
dest_se_deve pointer, which may be NULL.

This can lead to a NULL pointer dereference if dest_se_deve remains
unset.

SPC-3 PR SPEC_I_PT: Unable to locate dest_tpg
Unable to handle kernel paging request at virtual address dfff800000000012
Call trace:
  core_scsi3_lunacl_undepend_item+0x2c/0xf0 [target_core_mod] (P)
  core_scsi3_decode_spec_i_port+0x120c/0x1c30 [target_core_mod]
  core_scsi3_emulate_pro_register+0x6b8/0xcd8 [target_core_mod]
  target_scsi3_emulate_pr_out+0x56c/0x840 [target_core_mod]

Fix this by adding a NULL check before calling
core_scsi3_lunacl_undepend_item()

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Link: https://lore.kernel.org/r/20250612101556.24829-1-mlombard@redhat.com
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: John Meneghini <jmeneghi@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

I see now! If we look at the error path, when
`core_get_se_deve_from_rtpi()` returns NULL (line 1667), the code jumps
to `out_unmap` at line 1675. However, there could be existing entries in
the `tid_dest_list` that were already added before this failure.

The commit shows the stack trace mentions "SPC-3 PR SPEC_I_PT: Unable to
locate dest_tpg" which actually happens at line 1641, and then jumps to
`out_unmap` (line 1644).

In this case, any tidh entries in the list would have `dest_se_deve =
NULL` because the failure happens before `dest_se_deve` is even
assigned.

**YES**

This commit should be backported to stable kernel trees for the
following reasons:

1. **It fixes a real NULL pointer dereference bug**: The commit
   addresses a kernel crash that occurs when
   `core_scsi3_lunacl_undepend_item()` is called with a NULL
   `dest_se_deve` pointer. The function dereferences the pointer at line
   1453 (`if (!se_deve->se_lun_acl)`) without checking for NULL, causing
   a crash.

2. **The bug affects normal error handling paths**: This crash occurs
   during error handling in the SCSI target subsystem when processing
   PERSISTENT RESERVE OUT commands with SPEC_I_PT (Specify Initiator
   Ports). When certain lookups fail (like "Unable to locate dest_tpg"),
   the error cleanup path can have NULL `dest_se_deve` values in the
   tid_dest_list.

3. **The fix is minimal and safe**: The fix simply adds a NULL check
   before calling `core_scsi3_lunacl_undepend_item()`:
  ```c
  if (dest_se_deve)
  core_scsi3_lunacl_undepend_item(dest_se_deve);
  ```
  This is a defensive programming practice that prevents the crash
  without changing the logic flow.

4. **The fix is confined to error handling**: The change only affects
   the error cleanup path and doesn't modify the normal operation flow,
   minimizing the risk of regression.

5. **Similar to other backported fixes**: Looking at the similar
   commits, commit #3 (qla2xxx NULL pointer fix) and commit #5
   (rt5514-spi NULL pointer fix) were both backported and had similar
   characteristics - they were simple NULL pointer checks that prevented
   crashes.

6. **Production impact**: NULL pointer dereferences in kernel code lead
   to kernel panics, which can cause system crashes and data loss. This
   is particularly important for storage-related code where reliability
   is critical.

The commit follows the stable tree rules by fixing an important bug
(kernel crash) with minimal risk and without introducing new features or
architectural changes.

 drivers/target/target_core_pr.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index b42193c554fb2..2bc849799739e 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -1858,7 +1858,9 @@ core_scsi3_decode_spec_i_port(
 		}
 
 		kmem_cache_free(t10_pr_reg_cache, dest_pr_reg);
-		core_scsi3_lunacl_undepend_item(dest_se_deve);
+
+		if (dest_se_deve)
+			core_scsi3_lunacl_undepend_item(dest_se_deve);
 
 		if (is_local)
 			continue;
-- 
2.39.5


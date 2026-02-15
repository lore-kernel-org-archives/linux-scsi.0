Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83FEE1367;
	Sun, 15 Feb 2026 15:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771167818; cv=none; b=AAe+XGg2zdu1AVQgduehEVnG6RJgiqxgflgkgj0+XzVrdBKxDHzu+g4t5aBeQ26rn0zlEThejZgJfQenM/wH9VxVPrF6aNicvf76nkCtMU70i8RWN5PdNYGyHe+XR8UgPa5Cnx68TK928KaJtXXX1s5jJQdlK7Yro1aECV84tWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771167818; c=relaxed/simple;
	bh=ALJQ6v0jihErAld2wDaIVC7Dc1Pu90VzccUmQjBo3qE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gdBDAsdDNbEQjv8lGoLEY8Z20J9DFsvg/4gyhxcg8zMSLaQf4qVV9O+zO337Vuy7RNsGH63dPxztdZSNiuxjWqlwB4klAk2QzuMK19mz77c3gBV+2f2uOWgRvahO1hXkkXegnPiZBL2Wfr8oIhqfYQv5EqNZg4ZjyJG5OUWKdGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SnD4l3f9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SnD4l3f9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E36BAC4CEF7;
	Sun, 15 Feb 2026 15:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771167818;
	bh=ALJQ6v0jihErAld2wDaIVC7Dc1Pu90VzccUmQjBo3qE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SnD4l3f95hoKZ/Qa9q6GeL+aHkkQKVGQWYcFSumWEgq764zoOJ+SDty/oFEzQOMYl
	 lSM3cEflzIPYKNXUptUEOm3DlLfAonrrD6hxii/Vz95CXvLTu//U46YAHR2Vc9Cls5
	 4n6DrSkRYbsSpscFIsDngHW/KOAxCoy9GBRWHFezHLSJrjnfzAnoEaIppTare5prrM
	 57vm27zFvAnmjZx/0eH/CbGKvSPqpcbSy4DaVWwVXj3q57LZF4LpkjDG4JL8mFJonC
	 FbPDZj8zapFhj9fzpbEYFua19kRVE8XXhciHFMChAQAWHAzjjJ0N4HHJvVw9uM8fg6
	 JTwGGwMHJgF0A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Keita Morisaki <keita.morisaki@tier4.jp>,
	Peter Wang <peter.wang@mediatek.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	chaotian.jing@mediatek.com,
	matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	linux-scsi@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 6.19-6.12] scsi: ufs: mediatek: Fix page faults in ufs_mtk_clk_scale() trace event
Date: Sun, 15 Feb 2026 10:03:19 -0500
Message-ID: <20260215150333.2150455-2-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260215150333.2150455-1-sashal@kernel.org>
References: <20260215150333.2150455-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Keita Morisaki <keita.morisaki@tier4.jp>

[ Upstream commit 9672ed3de7d772ceddd713c769c05e832fc69bae ]

The ufs_mtk_clk_scale() trace event currently stores the address of the
name string directly via __field(const char *, name). This pointer may
become invalid after the module is unloaded, causing page faults when the
trace buffer is subsequently accessed.

This can occur because the MediaTek UFS driver can be configured as a
loadable module (tristate in Kconfig), meaning the name string passed to
the trace event may reside in module memory that becomes invalid after
module unload.

Fix this by using __string() and __assign_str() to copy the string contents
into the ring buffer instead of storing the pointer. This ensures the trace
data remains valid regardless of module state.

This change increases the memory usage for each ftrace entry by a few bytes
(clock names are typically 7-15 characters like "ufs_sel" or
"ufs_sel_max_src") compared to storing an 8-byte pointer.

Note that this change does not affect anything unless all of the following
conditions are met:

 - CONFIG_SCSI_UFS_MEDIATEK is enabled

 - ftrace tracing is enabled

 - The ufs_mtk_clk_scale event is enabled in ftrace

Signed-off-by: Keita Morisaki <keita.morisaki@tier4.jp>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Link: https://patch.msgid.link/20260202024526.122515-1-keita.morisaki@tier4.jp
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The `ufs_mtk_clk_scale` trace event was introduced in August 2022
(kernel 6.1 era), so this buggy code exists in multiple stable trees
(6.1.y, 6.6.y, and later).

### 8. CONCLUSION

This is a textbook stable backport candidate:
- **Fixes a real crash** (page fault / use-after-free on dangling
  pointer)
- **Extremely small and contained** (4-line change in one file)
- **Uses well-established patterns**
  (`__string()/__assign_str()/__get_str()`) that are the correct and
  standard approach
- **Zero risk of regression** — this is strictly more correct than the
  original code
- **Affected code exists in stable trees** dating back to at least 6.1
- **Reviewed and accepted** by the relevant maintainers
- **Self-contained** — no dependencies on other patches

The fix is small, surgical, and meets all stable kernel criteria.

**YES**

 drivers/ufs/host/ufs-mediatek-trace.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek-trace.h b/drivers/ufs/host/ufs-mediatek-trace.h
index b5f2ec3140748..0df8ac843379a 100644
--- a/drivers/ufs/host/ufs-mediatek-trace.h
+++ b/drivers/ufs/host/ufs-mediatek-trace.h
@@ -33,19 +33,19 @@ TRACE_EVENT(ufs_mtk_clk_scale,
 	TP_ARGS(name, scale_up, clk_rate),
 
 	TP_STRUCT__entry(
-		__field(const char*, name)
+		__string(name, name)
 		__field(bool, scale_up)
 		__field(unsigned long, clk_rate)
 	),
 
 	TP_fast_assign(
-		__entry->name = name;
+		__assign_str(name);
 		__entry->scale_up = scale_up;
 		__entry->clk_rate = clk_rate;
 	),
 
 	TP_printk("ufs: clk (%s) scaled %s @ %lu",
-		  __entry->name,
+		  __get_str(name),
 		  __entry->scale_up ? "up" : "down",
 		  __entry->clk_rate)
 );
-- 
2.51.0


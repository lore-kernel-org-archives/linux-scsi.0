Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CB18EEBB;
	Thu, 11 Jun 2026 12:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781182568; cv=none; b=si9sx9CLnTkw6P38vZmYk1CTT4JsyaYBYLuQ2noYfYj83Pv7pDrIs9jow450AZDf17vgqUXFhqXh6Y2Xewwa74m674VhBoPyCRwnkAUU3iHg5JydZTvQib5m3PdEi/Pi85K0JEA4PH7c9JaNoERg3q9NwqUqXWtt6DIvO9U3PdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781182568; c=relaxed/simple;
	bh=DmIjU3x/SEAEpCl+gbbBkEz91WrO/E0QgXWGDEvi9CE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=AAxJ4mTeD4r8YzLyDwE43J8Bwq0MP9Kty4bMu37tXgLcc/Sb5BQ7oVlBVcaXrzij5aiR8X8wn1lySdiahGy6jR6GB/jSYgrq/zhvNd5pJzt+QQPwhjqU2ReOc8Kj/JFybY/HxmOGko3jMgXdFmwuCDU1vDa3Vq6eF4g7BUPVGrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AWy9kMbI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AWy9kMbI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE1F01F00893;
	Thu, 11 Jun 2026 12:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781182566;
	bh=mqeGLS1xSMHnHuirRJiKVE5d1yFDFFJiKFLcDHcv4Jc=;
	h=From:To:Cc:Subject:Date;
	b=AWy9kMbIfOioVg1b+pKrNwsjvwr5PuYM4HfjzXzUPY597isqyeORxz7DxkadujbDX
	 oZINbe8Ru6xFKT3tuMjBgAjpuNz0xF/t6njNuBiDT1ugNxd3da8jdrU80I9+gU6A/W
	 vO5ttrDPxl/UDl2nnILif1TRiFuHFQ2536WCqtf1hwarJ5kX6nfVaGT+d5MrMOPWWL
	 qZL1e7x0+9dGPQjjQ6hXORWEiLv+4moFxVAoJJm8a/pjPR3EGSaNvgbePw6whHR/yY
	 Wjw1k3mGA+iUpwv1FVfp1HgvTT5t7srkhAozhcJHpouXSI6BgB1t2tkC85skgChiMI
	 4EBP98kHsI0ew==
From: Arnd Bergmann <arnd@kernel.org>
To: Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
	Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Kees Cook <kees@kernel.org>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: bfa: reduce kernel stack usage in bfa_fcs_lport_fdmi_build_portattr_block
Date: Thu, 11 Jun 2026 14:55:56 +0200
Message-Id: <20260611125601.3385418-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

bfa_fcs_fdmi_get_portattr() gets inlined into multiple places and has two
fairly large variables on the stack, to the point of causing a warning
in some randconfig builds:

drivers/scsi/bfa/bfa_fcs_lport.c:2198:1: error: stack frame size (1560) exceeds limit (1280) in 'bfa_fcs_lport_fdmi_build_portattr_block' [-Werror,-Wframe-larger-than]
 2198 | bfa_fcs_lport_fdmi_build_portattr_block(struct bfa_fcs_lport_fdmi_s *fdmi,
      | ^
drivers/scsi/bfa/bfa_fcs_lport.c:1856:1: error: stack frame size (1600) exceeds limit (1280) in 'bfa_fcs_lport_fdmi_build_rhba_pyld' [-Werror,-Wframe-larger-than]
 1856 | bfa_fcs_lport_fdmi_build_rhba_pyld(struct bfa_fcs_lport_fdmi_s *fdmi, u8 *pyld)
      | ^

Mark the inner function as noinline_for_stack to keep it separate from
the other variables and prevent multiple copies of the same variable
to get inlined here.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/bfa/bfa_fcs_lport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/bfa/bfa_fcs_lport.c b/drivers/scsi/bfa/bfa_fcs_lport.c
index 2df399c537c1..8c9d423129c0 100644
--- a/drivers/scsi/bfa/bfa_fcs_lport.c
+++ b/drivers/scsi/bfa/bfa_fcs_lport.c
@@ -2627,7 +2627,7 @@ bfa_fcs_fdmi_get_hbaattr(struct bfa_fcs_lport_fdmi_s *fdmi,
 
 }
 
-static void
+static noinline_for_stack void
 bfa_fcs_fdmi_get_portattr(struct bfa_fcs_lport_fdmi_s *fdmi,
 			  struct bfa_fcs_fdmi_port_attr_s *port_attr)
 {
-- 
2.39.5


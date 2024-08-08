Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB3671F19A;
	Thu,  8 Aug 2024 17:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723136817; cv=none; b=tVIOgCxlq8FByVEHtLJmatzfV9lsd54pgw33Iv+F3aY9ezfVHpMsMj/x/e+RuDOYbeguvAFs7FExZn9hcVfHp8XqfPpAOo5Jk08Vxu4cNCf/TuGy4SQ+pfD1/jks2sOULA/7UhSHn3FtRkSxd9ZtzDc3XcPyI0njxdmTM7Kuhsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723136817; c=relaxed/simple;
	bh=pNlH+7HI3TR9dpc9zTA0Qmu4ReupDI0h17l5PY7YrcA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IKuKxGntTzZKc/xG8ZT9YzGhFarWyt6BRxDRoP4+SfNv74CsFJ1NKxl8SgUnC0+7nyxMX1BjzEuasIQr+152KHJdIu0VEqTMyNbeQ1m7rXol/mK1bkrnflrZ7KiQvFYkBBGvi8KBmqX0KdSx4rTe6OLUNTglAageaOuW/FZVyw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cOP4Ak1P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cOP4Ak1P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6047AC32782;
	Thu,  8 Aug 2024 17:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723136817;
	bh=pNlH+7HI3TR9dpc9zTA0Qmu4ReupDI0h17l5PY7YrcA=;
	h=From:To:Cc:Subject:Date:From;
	b=cOP4Ak1PmXnIBxIUilWoLghQw2l+MIg4wXxQ1NWA7gXpKJxmLiyva7B5V0SHVNdBa
	 SyESSO9umE7hLqVJp+Ss6SZijnizXWG7cXrya0dP4O554NjD/dX9UDhw0u55V6psnv
	 4EmSuGIOMhzTwuyiU/080qx1ytUzRU7tTYoE3DSegaByCxoZpEi5UH1uIWj3bcEnA8
	 P8KaQP+/Ef2vMPt9TqbE2bMcNE28UVYexwsMxZx8vvUmdUjnEFmyYeGhpFVGjcBQqM
	 nUdx5y0Tn3iPMUHvz5BaawGzpY+zdc3DThH5d/52J2KIUZl5gUZ+t9r70TgKqx235b
	 +oJ6t6+MirHFA==
From: "Rob Herring (Arm)" <robh@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Bart Van Assche <bvanassche@acm.org>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] scsi: ufs: ufshcd-pltfrm: Use of_property_present()
Date: Thu,  8 Aug 2024 11:06:44 -0600
Message-ID: <20240808170644.1436991-1-robh@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use of_property_present() to test for property presence rather than
of_find_property(). This is part of a larger effort to remove callers
of of_find_property() and similar functions. of_find_property() leaks
the DT struct property and data pointers which is a problem for
dynamically allocated nodes which may be freed.

Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
---
v2:
 - Update subject to include 'ufshcd-pltfrm'
---
 drivers/ufs/host/ufshcd-pltfrm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/host/ufshcd-pltfrm.c b/drivers/ufs/host/ufshcd-pltfrm.c
index a3e69ecafd27..2e1eb898a27c 100644
--- a/drivers/ufs/host/ufshcd-pltfrm.c
+++ b/drivers/ufs/host/ufshcd-pltfrm.c
@@ -272,10 +272,10 @@ static int ufshcd_parse_operating_points(struct ufs_hba *hba)
 	const char **clk_names;
 	int cnt, i, ret;
 
-	if (!of_find_property(np, "operating-points-v2", NULL))
+	if (!of_property_present(np, "operating-points-v2"))
 		return 0;
 
-	if (of_find_property(np, "freq-table-hz", NULL)) {
+	if (of_property_present(np, "freq-table-hz")) {
 		dev_err(dev, "%s: operating-points and freq-table-hz are incompatible\n",
 			 __func__);
 		return -EINVAL;
-- 
2.43.0


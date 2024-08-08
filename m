Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE20B1F19A;
	Thu,  8 Aug 2024 17:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723136859; cv=none; b=PvifBCKx9089wRNiWEtpi8JFy7JdoPmi8a+iJNrLb/EzZk/8QGXXPLtZXGr1t0+WA2sm6NPOtfA0p5s/6woM0VkegOTJ2IxuH8T4f5Q89H6bDrucANjVyzYxSJKj+G9zGkxNzwZBFyG40c0iOcace2g0ls0vMjiXXo2F6bvK2MU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723136859; c=relaxed/simple;
	bh=Rzb89voYZneQbKj+/f0ulrexRm3ovFyYt+v+0qoef/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=A0e4Bm1mkn2d70DnET7op+eyaobRiOk2AAiRnWIK/YHCZ2aQbtZZta+YUyOFMr9TSp5y4XrfP82zEndbCOqRkGMeYg7S+CxPi4YgScpqCMFtNU9AT/D/uyZoDM+NDzgo8D4L6oDM9u1T6bzE6NLKRPVpnQze7l8nN6iI2ToFadI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PG4s4DFn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PG4s4DFn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 387F9C32782;
	Thu,  8 Aug 2024 17:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723136859;
	bh=Rzb89voYZneQbKj+/f0ulrexRm3ovFyYt+v+0qoef/Y=;
	h=From:To:Cc:Subject:Date:From;
	b=PG4s4DFnzGXjKx4aHAhfKQYSD74T2NqVQXgdLo9daTYt/zrZ+FJUAmI0AJZRIoQhL
	 40qjBwL8utd3dqA8WCSBSDO1oKpHJmX6p8kemr9NYaq9jraUHj8X8ulFDgapxpo+0r
	 /RPXebbNsy9EihbqyGdygZq2r4pofFEW2J75BNAqqWRwGdW4GBBt8yEW+49L6nvn8S
	 1yZJFFkqHmtF8viLrmbNAyJ/+j48ZOcEoWyLPOhYMPfDTZRdUGPoa3346hmPqarK5b
	 bVlojbXehChFLMRbGaPN9O0hOQdsAEWAtetOVz9eR5BoD6r1g4hW/IGWFbjUNNIfB4
	 wxlG2udqPwabA==
From: "Rob Herring (Arm)" <robh@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Bart Van Assche <bvanassche@acm.org>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] scsi: ufs: ufshcd-pltfrm: Use of_property_count_u32_elems() to get property length
Date: Thu,  8 Aug 2024 11:07:03 -0600
Message-ID: <20240808170704.1438658-1-robh@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace of_get_property() with the type specific
of_property_count_u32_elems() to get the property length.

This is part of a larger effort to remove callers of of_get_property()
and similar functions. of_get_property() leaks the DT property data
pointer which is a problem for dynamically allocated nodes which may
be freed.

Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
---
v2:
 - Update subject to include 'ufshcd-pltfrm'
---
 drivers/ufs/host/ufshcd-pltfrm.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/ufs/host/ufshcd-pltfrm.c b/drivers/ufs/host/ufshcd-pltfrm.c
index 2e1eb898a27c..0c9b303ccfa0 100644
--- a/drivers/ufs/host/ufshcd-pltfrm.c
+++ b/drivers/ufs/host/ufshcd-pltfrm.c
@@ -31,7 +31,6 @@ static int ufshcd_parse_clock_info(struct ufs_hba *hba)
 	const char *name;
 	u32 *clkfreq = NULL;
 	struct ufs_clk_info *clki;
-	int len = 0;
 	size_t sz = 0;
 
 	if (!np)
@@ -50,15 +49,12 @@ static int ufshcd_parse_clock_info(struct ufs_hba *hba)
 	if (cnt <= 0)
 		goto out;
 
-	if (!of_get_property(np, "freq-table-hz", &len)) {
+	sz = of_property_count_u32_elems(np, "freq-table-hz");
+	if (sz <= 0) {
 		dev_info(dev, "freq-table-hz property not specified\n");
 		goto out;
 	}
 
-	if (len <= 0)
-		goto out;
-
-	sz = len / sizeof(*clkfreq);
 	if (sz != 2 * cnt) {
 		dev_err(dev, "%s len mismatch\n", "freq-table-hz");
 		ret = -EINVAL;
-- 
2.43.0


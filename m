Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FEC516D9AD;
	Wed, 31 Jul 2024 20:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722456889; cv=none; b=CFSMkcDEmFtOHscZkpCeFdHUJ7C6NeFEA7e3PqA4jN9lFTBBe8swhba87c9NxzwR2ebqj8/kUw8fuDQgo52UL0TfXhZNrIYvbGeqh7W4Azla++Vd+DH14CJ827iFavKuutrQ5hhnn1ntUZenDHFIxgJMpSftAXIPddQia3lCi4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722456889; c=relaxed/simple;
	bh=t2kc0K9l76IswGytJY3ieedKBdixh8jI9A2JOmFIaZY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JxVhsCoWwxtm6ARpwbpDiPcoFWNEnlt4jDz4TlSzPtUmwlsqjRcC/RG/wSaMrMkWtcqosteWibT2EdQdprKyleMRWJ+lF3/G+aqX17sv3xLPFZ1SjCzg5JmsRpUqwlSmXpUWgOnfFqZzlomF1dWNPOwdHnEzwzpIRNCicJLOcJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cJGPZkGk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cJGPZkGk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5768C4AF0F;
	Wed, 31 Jul 2024 20:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722456889;
	bh=t2kc0K9l76IswGytJY3ieedKBdixh8jI9A2JOmFIaZY=;
	h=From:To:Cc:Subject:Date:From;
	b=cJGPZkGkEOYC6YLYEDGdlNOqTy6HcIVA8grNWYVHOI79b7606HAFCXUVDrIDdzzbh
	 QzCdQz+EtMuW1vfLcfe/Ct9trEkhizmmpxC0BLVbaJMKJ21z808pO3MsReloSZSNbX
	 vP5TxvqB9IXEFISbAJ1rzK+ZuXHfQj8Lh4ACkUzkOLfxqFbJMumsbayeoEBj2iQV+j
	 VzzhhVs/iJ3LjCHRiBfGBkupj+6ZgYz5W1TvXzVd3IxN1qodiKR0j8Vv9Is8/jBqU/
	 N/1k6zKyrJ5cZ+nt5A7Gbblzy5/SSofsz6Qa7ByO9VyJepvOZ1YC490XzfbfdbuRLG
	 YakehlzoL8Iog==
From: "Rob Herring (Arm)" <robh@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] ufs: ufshcd: Use of_property_count_u32_elems() to get property length
Date: Wed, 31 Jul 2024 14:14:04 -0600
Message-ID: <20240731201407.1838385-9-robh@kernel.org>
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


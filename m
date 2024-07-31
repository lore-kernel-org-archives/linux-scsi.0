Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E45C116C684;
	Wed, 31 Jul 2024 19:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722453228; cv=none; b=X1FRUD8BrzBoq5KbOmVZ5e0g89klLMFn3Jf1V5zN2YBychYRNkgD2e0bxPkWmyxG4N+8N9iXD1zJJUvJ0v3swdGaNzjj1DEpChgTouwLRbanxi0nAzuqTmL1qdD4j7mrBm89swLr5YcL4q3gOyr2YmN5Zi7UYEbpuMS9omLoiwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722453228; c=relaxed/simple;
	bh=LBX/fvql08mYzJWK5iN8UsFKYmPl02R2DmMAXvpAiH4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=K9EMTLELeWvHIeqvk6Ni0Fn+SnPN9NH1UBorSUqW7YPR37UdC2Qq4w8+OQRj9uEXbO+MNHIVM9idG9N32yA252DgENS77W58XnGzoVcxzV2U5sV2jtKc3WBa4u8sxY3y5RBPKChtG80Nx9ytfNGN+N6TyTCagqLjw5UKaykvgO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jIVKJYxU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jIVKJYxU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47775C4AF0F;
	Wed, 31 Jul 2024 19:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722453227;
	bh=LBX/fvql08mYzJWK5iN8UsFKYmPl02R2DmMAXvpAiH4=;
	h=From:To:Cc:Subject:Date:From;
	b=jIVKJYxUOcAtiz/3UhTP3hy3ewuM0SCCgK8Kk9bWn4ehOu8udQP1UYODm/2QZRlJO
	 VhovZchsmEw+Md2gFYbt4O0FZIePf7RrsET+Z7fOCXaCyb5cUrfKrIFIrWF30oNppF
	 3arEY5YkKyuqOQKb7c2V8lSAPan/qtLKvz7pu4A8PZnklpJxl6y0Ipv4EoWheM7ZdH
	 sw0qX6ZuNiiommjNH5IHIOFMcrLS2Cc5Y3jL+lvTvrSHO9VNIeo23uNPZ8nzq3kRPX
	 uUL+aJ4tnt0gxNzPq4Q0B7/pYm+DGjo6FqNdNLyvDMpmA7J/UBNAjyssrXngheeQZy
	 WFxK62yiqzoVw==
From: "Rob Herring (Arm)" <robh@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] ufs: Use of_property_present()
Date: Wed, 31 Jul 2024 13:12:46 -0600
Message-ID: <20240731191312.1710417-8-robh@kernel.org>
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


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 750AB40928B;
	Thu, 17 Sep 2026 21:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789679501; cv=none; b=D/8+nM6dD19X7tY2mZjjbsSRvPxOJnZkc0H4GsanhJlzbjbT3hckW1mA+B5eXbz84bgN70zBNsJFAt3VHDBGoLlsRwVZlQOw+XshechBABf0iC6zkEooIv/hUUiGDy+ekdvBIlii2I3OeVSC+oC9ZlpnnUpo5kJzdVuhok+qESE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789679501; c=relaxed/simple;
	bh=MJ97ti6kE1FqMOweapUYAZexCKOQKohuEFRfs0ffhrM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=gI6W62t7i6hZYG/rVTfcV/h3xsAH05Y3pQeTrKCxcF8M7eQSB6U3znvzN/9h+yzo1cnK/W69+GqneKXxVHrwIdi/58kGqy9uZl0aOR7ijTwRNtB0/Av/nGrPAi2MgkPU5zPWp8tEymZp5VaNDfTb3gTDjg0SsKQQdOm6q3d9Hak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bHUQfzGr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bHUQfzGr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21AB61F000FF;
	Thu, 17 Sep 2026 21:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789679500;
	bh=sqk96yXCSHVBTjHFA/xCjbv2qiuPygIeoxuQkhu1c+c=;
	h=From:To:Cc:Subject:Date;
	b=bHUQfzGrNAiCgpujMDYiq2GnnyXN01GOqTsgGsTDBuBZxcv5MsEoY/Qs6pXs2zbn2
	 QxNpVAcMS+DWdGdZkG/i0BFWU6MoMCRGvmuSPCVYCy+ckvELv50SK0oYf1e6Qv/ADU
	 A6GFEXJEwlG0+flS8A0EI95oIwuq5caABlzgSN65Cv3AUelBoum5H2PJZA2JXuQFZF
	 ppZFNjfIQHAqik+p66YsoGWkv/YQnMDRAwkXh+PpSdGNeiqyFWbosZtNIm4noZ7nde
	 RAaZ9whLiZ78pmNgwoTdPka+H6UNpoqzAUulWjAI8uWRxs7JsTwdNFuF1Zx15Tex7m
	 FpDr5E1THkX/g==
From: Kees Cook <kees@kernel.org>
To: Don Brace <don.brace@microchip.com>
Cc: Kees Cook <kees@kernel.org>,
	Kees Cook <kees+treewide@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	storagedev@microchip.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: [PATCH] scsi: hpsa: Make buff allocation type unsigned
Date: Thu, 17 Sep 2026 14:11:38 -0700
Message-Id: <20260917211137.i.357-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1613; i=kees@kernel.org; h=from:subject:message-id; bh=O+otsY4zhFP5y7nRMxvKWQ/3WJnnb0Wp73WvCWz9wrk=; b=owGbwMvMwCVmps19z/KJym7G02pJDFlrwrsyWHosRVvPMDBp1tpsS2D8tzF+psaDeAc9qTMWb icDZpzuKGVhEONikBVTZAmyc49z8XjbHu4+VxFmDisTyBAGLk4BmAhLFiPDqUXqspd+/xIx+Pyj wtBOYsNbl+mn+FbvYvq8P/ykakiXKcP/bM3bW1Nvt2buPCXycTLj2d1nN/HuCS+PWLNr4hTvkn9 p/AA=
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

From: Kees Cook <kees+treewide@kernel.org>

In preparation for converting the kmalloc family of allocators to the
type-aware kmalloc_obj family, we need to make sure that the returned
type from the allocation matches the type of the variable being
assigned. (The kmalloc family returns "void *", which can be implicitly
cast to any pointer type.)

The assigned type is "unsigned char **", but the converted allocation
type would be "char **", whose elements point to a character type of a
different signedness, so the two pointer types are not compatible. Take
the size from the assignment target instead. No change in allocation
size results.

Build tested ARCH=x86_64 allmodconfig with GCC 16.2.0:
drivers/scsi/hpsa.o

Assisted-by: LLM coccinelle
Signed-off-by: Kees Cook <kees+treewide@kernel.org>
---
Cc: Don Brace <don.brace@microchip.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <mkp@kernel.org>
Cc: <storagedev@microchip.com>
Cc: <linux-scsi@vger.kernel.org>
---
 drivers/scsi/hpsa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 8edad1830abe..364cff7671e5 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -6499,7 +6499,7 @@ static int hpsa_big_passthru_ioctl(struct ctlr_info *h,
 		return -EINVAL;
 	if (ioc->buf_size > ioc->malloc_size * SG_ENTRIES_IN_CMD)
 		return -EINVAL;
-	buff = kcalloc(SG_ENTRIES_IN_CMD, sizeof(char *), GFP_KERNEL);
+	buff = kcalloc(SG_ENTRIES_IN_CMD, sizeof(*buff), GFP_KERNEL);
 	if (!buff) {
 		status = -ENOMEM;
 		goto cleanup1;
-- 
2.34.1


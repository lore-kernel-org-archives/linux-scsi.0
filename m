Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A469712E1CD;
	Sat, 26 Apr 2025 06:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745648415; cv=none; b=kVucguOjcdc3huU0rLgENTmnexYlQ4e2Wz0tuulCbFAhKDVL65sBMHBvM6K4N+Djk5bXcq0GquER8cQI/hPiD2nDnNRr9cZDPoSXetqeWIZUjBkRKD0tdKW56mZ7t1nOqVo1xpWH1ac5n5xWisMk4CAtrfphc+u3XmlSxJDYuIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745648415; c=relaxed/simple;
	bh=mTSjaJNevtGX41DDFhx2Fl+zfoCRVGyVKVL44QAREPE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=mwnH+Vd+Huv43TfxQqSXXtDxlwxSKGKFFXi+avm2M1sjAOB3cVAdEi/xgGX81YCZDyhlHOhu/+W/279auMthlpCVAuTLY1Qsz/qqtknA3fD1WgtZxdLZubayYYrdj4fDlH/vDm58QA32UIro2zRLve701K651zPzYCfmBwKcXeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BIC9Y3ns; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BIC9Y3ns"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A257C4CEE2;
	Sat, 26 Apr 2025 06:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745648415;
	bh=mTSjaJNevtGX41DDFhx2Fl+zfoCRVGyVKVL44QAREPE=;
	h=From:To:Cc:Subject:Date:From;
	b=BIC9Y3ns9rbQL+kMzXgUkqlqXCYRHPB6t++NHCTsRYVlYTL/9/zemAh3QawGlIemo
	 qedi8Ne1uPlwuR8YGLRwoygSG0gY9LR9tQ2Wk6ioLKcsum3mt3oxfxfgzeBdfcz/9a
	 Z88MioaW/JVBBQu3CX/wDZPpPS2Gx4cqO544sC4AEfVz8rC8pjVIF9kvKg/eWQBcFs
	 0H0GzB1eXRGF5pMSNMV5N9Za6Y5B3srpN8+QM9N6yvurUcqvjwekWQpz/mvnFNDmd5
	 ZeMWFihYrJBQ6wcvq+eLJccBNh/Zf42AZwBOkfU58vItSFJgqjPoh4wzEHs+UKengy
	 JKDhBXRc/fIeg==
From: Kees Cook <kees@kernel.org>
To: Nilesh Javali <njavali@marvell.com>
Cc: Kees Cook <kees@kernel.org>,
	Manish Rangankar <mrangankar@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: [PATCH] scsi: qla4xxx: Remove duplicate struct crb_addr_pair
Date: Fri, 25 Apr 2025 23:20:11 -0700
Message-Id: <20250426062010.work.878-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1423; i=kees@kernel.org; h=from:subject:message-id; bh=mTSjaJNevtGX41DDFhx2Fl+zfoCRVGyVKVL44QAREPE=; b=owGbwMvMwCVmps19z/KJym7G02pJDBk81dKW71XbX+2fe2nKGiWP9+sECvPta/b06HXL7vv7O V5e0FCso5SFQYyLQVZMkSXIzj3OxeNte7j7XEWYOaxMIEMYuDgFYCJ/lzH8j+ntFZjd8PaZ/A2/ i8v+1sTU9bG8nnr5lkZQbOvqT0+CHzMyPEi4VrSyqfnWSv8dL6xLpG0+HX538XyC8cnd+s91FoQ HMAEA
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

In preparation for making the kmalloc family of allocators type aware,
we need to make sure that the returned type from the allocation matches
the type of the variable being assigned. (Before, the allocator would
always return "void *", which can be implicitly cast to any pointer type.)

The assigned type is "struct crb_addr_pair *" and the returned type will
be a _different_ "struct crb_addr_pair *", causing a warning. This really
stumped me for a bit. :) Drop the redundant declaration.

Signed-off-by: Kees Cook <kees@kernel.org>
---
Cc: Nilesh Javali <njavali@marvell.com>
Cc: Manish Rangankar <mrangankar@marvell.com>
Cc: <GR-QLogic-Storage-Upstream@marvell.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: <linux-scsi@vger.kernel.org>
---
 drivers/scsi/qla4xxx/ql4_nx.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.c
index 47adff9f0506..da2fc66ffedd 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.c
+++ b/drivers/scsi/qla4xxx/ql4_nx.c
@@ -973,11 +973,6 @@ qla4_82xx_pinit_from_rom(struct scsi_qla_host *ha, int verbose)
 	unsigned long off;
 	unsigned offset, n;
 
-	struct crb_addr_pair {
-		long addr;
-		long data;
-	};
-
 	/* Halt all the indiviual PEGs and other blocks of the ISP */
 	qla4_82xx_rom_lock(ha);
 
-- 
2.34.1


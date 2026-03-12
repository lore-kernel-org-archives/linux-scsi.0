Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 526003783BD;
	Thu, 12 Mar 2026 20:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773347290; cv=none; b=ss03lUEqaCx7bUpnmjNjvDhs9phKNCwjQzwbpLoOZicyUR4YLPBHCETDm8Z7DP1ZS+iCp5k1YrnIsv+XJ180c0wQWQI6dtQ7LMEGgpmOBJiHvXVrPk7kxixEqPib/JZCb/Rqff/nqqnJu6kE71FOIAstdQUmubnajBDM7pFMcSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773347290; c=relaxed/simple;
	bh=JCZVqkUElmN6+yCXi96nBc4FJ3bPC1rGzZ/PK/wD/Eg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hrmuuQWZg6AQbVZptt2K4KbMaXsCynXUoJEnt20ZZvBOJ7hox0FbUAoCDYxMWwMXIpq1bgoI/hRFsuDj8BVVKRsAjlMkcwUWqg2RuoG+PHOAWyKMOKSnHRgCnIE0m3r47i/fjAP3Exzh9N1F0FapRl6v4YwTD+/cKuZ/DDClveE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bfGi+MTK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bfGi+MTK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FA22C2BC9E;
	Thu, 12 Mar 2026 20:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773347290;
	bh=JCZVqkUElmN6+yCXi96nBc4FJ3bPC1rGzZ/PK/wD/Eg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bfGi+MTK8J6+mDwEcB2grAiIoBHNi6ToIdSweYX1KKTkIHiX3GURmWNfrAPxerS1D
	 Nh/VkCCCUnOOCtEf13Nb7zc/Q98rW4rch/4GeajMhVO7hPVVQc5xcVK1s25YhJRpW2
	 xYKrvKjtMajgyUtSI4IiXea1EajvOkTjbzEsPPlR9UDH2PcVnhQczcinWoycNGju0S
	 S0yWAgLQ/wAaVAfZXdxfrzJhHe3RVXPuTcwQxxSgJBDJHwR9hb1+Ld+hj3z/82CDeW
	 BLrnwr4XSxCp3KnFGnZtYZxl6LgeP0MJ0NsIPfiShyv/SmPPC3dT3X7Hu3a5Y/5mg+
	 AGWawBzWNWhwQ==
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>,
	Clemens Ladisch <clemens@ladisch.de>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"K . Y . Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Richard Weinberger <richard@nod.at>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Bodo Stroesser <bostroesser@gmail.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	linux-mtd@lists.infradead.org,
	linux-staging@lists.linux.dev,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-afs@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	Ryan Roberts <ryan.roberts@arm.com>
Subject: [PATCH 09/15] mtdchar: replace deprecated mmap hook with mmap_prepare, clean up
Date: Thu, 12 Mar 2026 20:27:24 +0000
Message-ID: <75cdd8bf8833104cb35268a0fe9bd6b969eb8c17.1773346620.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773346620.git.ljs@kernel.org>
References: <cover.1773346620.git.ljs@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace the deprecated mmap callback with mmap_prepare.

Commit f5cf8f07423b ("mtd: Disable mtdchar mmap on MMU systems") commented
out the CONFIG_MMU part of this function back in 2012, so after ~14 years
it's probably reasonable to remove this altogether rather than updating
dead code.

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 drivers/mtd/mtdchar.c | 21 +++------------------
 1 file changed, 3 insertions(+), 18 deletions(-)

diff --git a/drivers/mtd/mtdchar.c b/drivers/mtd/mtdchar.c
index 55a43682c567..816ab1ae8b8d 100644
--- a/drivers/mtd/mtdchar.c
+++ b/drivers/mtd/mtdchar.c
@@ -1376,27 +1376,12 @@ static unsigned mtdchar_mmap_capabilities(struct file *file)
 /*
  * set up a mapping for shared memory segments
  */
-static int mtdchar_mmap(struct file *file, struct vm_area_struct *vma)
+static int mtdchar_mmap_prepare(struct vm_area_desc *desc)
 {
 #ifdef CONFIG_MMU
-	struct mtd_file_info *mfi = file->private_data;
-	struct mtd_info *mtd = mfi->mtd;
-	struct map_info *map = mtd->priv;
-
-        /* This is broken because it assumes the MTD device is map-based
-	   and that mtd->priv is a valid struct map_info.  It should be
-	   replaced with something that uses the mtd_get_unmapped_area()
-	   operation properly. */
-	if (0 /*mtd->type == MTD_RAM || mtd->type == MTD_ROM*/) {
-#ifdef pgprot_noncached
-		if (file->f_flags & O_DSYNC || map->phys >= __pa(high_memory))
-			vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
-#endif
-		return vm_iomap_memory(vma, map->phys, map->size);
-	}
 	return -ENODEV;
 #else
-	return vma->vm_flags & VM_SHARED ? 0 : -EACCES;
+	return vma_desc_test_flags(desc, VMA_SHARED_BIT) ? 0 : -EACCES;
 #endif
 }
 
@@ -1411,7 +1396,7 @@ static const struct file_operations mtd_fops = {
 #endif
 	.open		= mtdchar_open,
 	.release	= mtdchar_close,
-	.mmap		= mtdchar_mmap,
+	.mmap_prepare	= mtdchar_mmap_prepare,
 #ifndef CONFIG_MMU
 	.get_unmapped_area = mtdchar_get_unmapped_area,
 	.mmap_capabilities = mtdchar_mmap_capabilities,
-- 
2.53.0


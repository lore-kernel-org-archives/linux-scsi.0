Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FC7D3D0921;
	Fri, 20 Mar 2026 22:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774046465; cv=none; b=hS4Zcgfj9ABwF1K+n4MHHM3GzBWB7ykkjs1RGB53BY85sd5iWRNn6jgn3DoRd9MMuHaDMDhYji4YSN/K2Y+VqMDTpGrvHrWx4P8CI7dZ8H0soG6YJUI4P/HXo4DYd8SB5ilBxCuPDQeA4s9T/bd3YCNsbeyqf3wlDiAcmp24S5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774046465; c=relaxed/simple;
	bh=8qR80FHVrw1W7dNRTWXARimuDYTsH7/Z1DNv6yL8KUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fmZGr6edWGtqZz0Xl77txGw6bZPoUNJqFF9CKtRZEcfdlnuOeQoCeF+/72oCgU2eX0MC9Nlj44Y3EyonxMChmQ3F31JWn0olGksZUbqTVmbIvBXomLg7PW6/lOW1Q8ehgHyhkhw6UxK1YD8eBYxhYtC7rgjmN7OsiRmhrtQiitM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y5lVmyuB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y5lVmyuB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BA36C4CEF7;
	Fri, 20 Mar 2026 22:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774046465;
	bh=8qR80FHVrw1W7dNRTWXARimuDYTsH7/Z1DNv6yL8KUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y5lVmyuBl/YHtF0SUASv3ZsIQ1natPUk22znSNUOoj9GyIsqTvNjDfuA4n6b+bsdY
	 0IktpYP0BWJT+oAlqd91mH+ucfqkC0/or3yrh+9mqekZCcnZ68PC+3+GOlR+kG/Gqk
	 qR3lrrIWipYfuWAhUod8000ikrQiwAYZOzekjarGe48HdLKV5DVaWMA5C5CGo49xdA
	 LZZnpmr2iLBxtmHqo8tPDQrQ9okPRHfMxpwhKc1UaJ49bwA70Zc8q8d7EItWlI2LcM
	 BcStZ6sq6rzSZ540KpAs0bxeFgzoEwLwBn4HNb9lYff6pOhtpLKVcI0Nxiz30+Upqb
	 ALlXbBOZOjIoA==
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
Subject: [PATCH v4 21/21] mm: on remap assert that input range within the proposed VMA
Date: Fri, 20 Mar 2026 22:39:47 +0000
Message-ID: <0fc1092f4b74f3f673a58e4e3942dc83f336dd85.1774045440.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774045440.git.ljs@kernel.org>
References: <cover.1774045440.git.ljs@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now we have range_in_vma_desc(), update remap_pfn_range_prepare() to check
whether the input range in contained within the specified VMA, so we can
fail at prepare time if an invalid range is specified.

This covers the I/O remap mmap actions also which ultimately call into
this function, and other mmap action types either already span the full
VMA or check this already.

Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 mm/memory.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/memory.c b/mm/memory.c
index 53ef8ef3d04a..68cc592ff0ba 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3142,6 +3142,9 @@ int remap_pfn_range_prepare(struct vm_area_desc *desc)
 	const bool is_cow = vma_desc_is_cow_mapping(desc);
 	int err;
 
+	if (!range_in_vma_desc(desc, start, end))
+		return -EFAULT;
+
 	err = get_remap_pgoff(is_cow, start, end, desc->start, desc->end, pfn,
 			      &desc->pgoff);
 	if (err)
-- 
2.53.0


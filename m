Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44E0940801E;
	Tue, 30 Jun 2026 10:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782816875; cv=none; b=jWv5ss777e6OwFI58tpvRbB3s0310+Qxvosw3b15LeDLWToW5Gz8S+jlq5kjguzc/Bx540KsKNrVLhdkTbd/yfVbkutR/K0VTilKNJN1N3U7qn/seoO/lH2O0TjyDP77tWyKzur81YW+LfamRhMFhUxShlhbi1D5y3nB8WzvFD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782816875; c=relaxed/simple;
	bh=RiadHkM/ciJz4LJtIKzl0wSOiOE8945XvTKOQOOKBS8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=DWmh/nDBw4jnNAiwakgDI5C7gy/AMUdm5W0UskYfRUHsiy40ed8sfUrx++r4e0qswn+EFqrjCB6CoLFt6nAixkeBccEtdHjEbcobkqAAMyP4boVmu6eJONltu/JzuMqbX6ngwJ8B24SRnJAggAX+yr4N+PIFxnFwmwM9d5ViFZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kIXozC/6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kIXozC/6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A02C11F000E9;
	Tue, 30 Jun 2026 10:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782816873;
	bh=o4zrAKFV36+my9sEQud+nD9Mpl7nfKTgVOKBUepgezI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=kIXozC/6GRZNoThE7wVrh+Th54Zlbfibcc5IpHidsZAcdx7VFXo3pEpijZTNqJJL8
	 HAhXH+MpFe2aWX2fs3Mge3pm2kiSI6dFCqrZoMw+XtUUfI37m1TXWiOEnt5IRtmY/A
	 Bd/VEHNDnpWqP9c6Xv/NbkbxXROjlqdEY3kv402EamAMjLngoZkbypvmzYrid801B0
	 EII5nPXACbGjLE5yEoQY9s8e5HVZNNUU94tEnD+M6yBoZ7qdf/nH5rMadn4DbQhCF4
	 M63R5M04lGhRaCDs/mYyHSAmzzOOqyxif1n63zUmKYFZiXJ9/eQ5Xf+I7pmCLPw3jW
	 quPIeT1kCcHTw==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Tue, 30 Jun 2026 13:54:21 +0300
Subject: [PATCH 4/4] scsi: sym53c8xx_2: replace __get_free_pages() with
 kmalloc()
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260630-b4-scsi-v1-4-494fb37ebe7b@kernel.org>
References: <20260630-b4-scsi-v1-0-494fb37ebe7b@kernel.org>
In-Reply-To: <20260630-b4-scsi-v1-0-494fb37ebe7b@kernel.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Brian King <brking@us.ibm.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 Matthew Wilcox <willy@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
X-Mailer: b4 0.15.2

sym53c8xx_2 driver has an internal memory allocator for small
allocations of the driver structures. The backing memory for that
allocator is allocated with __get_free_pages().

This memory can be allocated with kmalloc() as there's nothing special
about it to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Performance difference between kmalloc() and __get_free_pages() is not
measurable as both allocators take an object/page from a per-CPU list for
fast path allocations.

For the slow path the performance is anyway determined by the amount of
reclaim involved rather than by what allocator is used.

Replace use of __get_free_pages() with kmalloc() and free_pages() with
kfree().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/scsi/sym53c8xx_2/sym_hipd.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.h b/drivers/scsi/sym53c8xx_2/sym_hipd.h
index 9231a2899064..aa365e8ba66f 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.h
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.h
@@ -1110,9 +1110,9 @@ sym_build_sge(struct sym_hcb *np, struct sym_tblmove *data, u64 badd, int len)
  */
 
 #define sym_get_mem_cluster()	\
-	(void *) __get_free_pages(GFP_ATOMIC, SYM_MEM_PAGE_ORDER)
+	kmalloc(PAGE_SIZE << SYM_MEM_PAGE_ORDER, GFP_ATOMIC)
 #define sym_free_mem_cluster(p)	\
-	free_pages((unsigned long)p, SYM_MEM_PAGE_ORDER)
+	kfree(p)
 
 /*
  *  Link between free memory chunks of a given size.

-- 
2.53.0


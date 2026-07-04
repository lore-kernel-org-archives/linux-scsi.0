Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 195E2390228;
	Sat,  4 Jul 2026 06:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783145634; cv=none; b=O6NUXsHe7Vim+0jr5CrVT7MecYe3xZiBD3aF6NUEw0XDQdFD0SZv/lLrvlSF6ArcQVrG543cWHMnG68xeKB3Ivox/ByPz0dDnQUA4vAqAaA4cka7cA06lDxdSo96ny2XE3ITbDwp7sU2GIArGuzMsRNlGqn+RiIehEznj94WQzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783145634; c=relaxed/simple;
	bh=+J9KLrK1JoXnuSNb+6A/uwLlgsi2Q/AEjfdroSsRXeI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=OhBaUNCmInD+V6ptqotV4Pd+62C2tnFpeBvTvdajddpbISUiTtsTjrSt1EMBJS2XJLCXQteQb8AD7SnRVKGpUOp8cQWNs6WmdrznC29maX40HBdKJouCfCZWYJjYj2OrkE3JB9Ur9t4HubVtBsETUqidWoee7JCJuD+Ps5/xPCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jmk2gMFL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jmk2gMFL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C40E1F000E9;
	Sat,  4 Jul 2026 06:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783145633;
	bh=ChsJbQD+rYLxKREcHCGErBZhvfE4abQxVMv0tWl2ri4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=jmk2gMFLrK3eU2lLP0K0XOJ1Pm0Uzkc7RJEuAmXhOwd75+F/e2QiRDrlyllwdNK7+
	 b7wQ+uYlfHvWU0PmUHehslmgcJxmnK3217gkV1Xl9Y+JTBcBPOQN687QayTgxlZBXJ
	 /5ewIJhudgeSA0G5uY3yPFK2holTLgZaFvSjEANSl+0Ox1T4WJHp3oMK6Dn9kDP3/I
	 nVVVNdy5wti/f00rRlEtOaGzXqfUSayxeZUlhmTy5eu1IiZ8sD+71yo54zPfQHeKwC
	 +Dwl/S7zgOdKLTh4ttH8FEgQu47KXFvAsqX8h0GvVXTZpNddSk1yMzGN2sLJMnAFPY
	 YKGxAnmygkPlA==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sat, 04 Jul 2026 09:13:37 +0300
Subject: [PATCH v2 4/4] scsi: sym53c8xx_2: replace __get_free_pages() with
 kmalloc()
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260704-b4-scsi-v2-4-7d2d21a810de@kernel.org>
References: <20260704-b4-scsi-v2-0-7d2d21a810de@kernel.org>
In-Reply-To: <20260704-b4-scsi-v2-0-7d2d21a810de@kernel.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Brian King <brking@us.ibm.com>, Hannes Reinecke <hare@suse.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 Matthew Wilcox <willy@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
 Wen Xiong <wenxiong@linux.ibm.com>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-scsi@vger.kernel.org, 
 target-devel@vger.kernel.org, Hannes Reinecke <hare@kernel.org>
X-Mailer: b4 0.16-dev

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
Reviewed-by: Hannes Reinecke <hare@kernel.org>
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


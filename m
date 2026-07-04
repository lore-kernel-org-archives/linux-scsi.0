Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 312BF38F935;
	Sat,  4 Jul 2026 06:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783145631; cv=none; b=dmwbI6dAgt4Meg+KfHBckJUV+Nmi07QInGVtgsDQFC98IGCv0onpvCoDEfFdAptUEtOBKgkLGnvcyCMfZpGyCSdkyPyKU+EhmCCT3oiZuKrC/NEO1PWUU0ilo5fvaBZ9MRPw+r1Uzun/YGd7HopqXIGtLVdFeHr8SqAfQmotu6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783145631; c=relaxed/simple;
	bh=A7N/Q/0K8heFPCuZJqA8TBPwU0by4KGx+/f1NPt9jqc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=DJfGko5SnOfDlUML2GblgvH0Q21hHIPUcrowjRDeCSQg/62nOQqdP5hI9G/HZ6YCLLHuWDYpVip5EV7LvcbH+DRvA+Fq7wjzXYe/fAWmZh8U2QMuAslcy8umGRCfCzn1xfoU84TVn3SYBAXI9N1OraXIji72DfMCeSkfFsef5YU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Clgh8Jsr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Clgh8Jsr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E1251F00A3E;
	Sat,  4 Jul 2026 06:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783145629;
	bh=emLjy5o6r8ZJF+EiAHY/zB3OczqvGQ9Eeeqy3Pf2Faw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Clgh8JsrEBdQ/oKnX72d0RSb06OkNypaXXjAe3KGHnzii5UbuKYLr0SsoAneFYrgc
	 qkKvKO3F18YV1fu/fQPB6bXsgevm6whYsfxTTsSOkA4kjyuWvUBrUSifbZcNBWIQqr
	 sHy51Gje1SH2XwNdaEck2RaYjfPS6kdVPXxcmoyOaMknHbsC3FuHj7sILfI3r3oaMk
	 xvTOOSI7rnJ6j5YVJb1cCqPSs+fdIaMrqdfKrLgSH3JYKneob10MjxUZdrcNAeHAHK
	 gjAGZIhxn7ZIbsA/tevlL8B5k6rafA7tfV90Aj82lRzAPRdB2HVJqH6ZAE56Qdot20
	 nhtIBmqdJXLLw==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sat, 04 Jul 2026 09:13:36 +0300
Subject: [PATCH v2 3/4] scsi: ipr: use kmalloc() to allocate IPR dump
 buffer memory
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260704-b4-scsi-v2-3-7d2d21a810de@kernel.org>
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

IPR dump machinery allocates memory to save adapter's crash dump using
__get_free_page().

This memory can be allocated with kmalloc() as there's nothing special
about it to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Replace use of __get_free_page() with kmalloc().

While on it, relax GFP_ATOMIC to GFP_NOIO for allocation of dump
buffers.
The allocations happen in a workqueue context, but with storage adapter
being in a state where it can't handle I/O.

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Tested-by: Wen Xiong <wenxiong@linux.ibm.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/scsi/ipr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index d207e5e81afe..19153dd24736 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -2893,7 +2893,7 @@ static int ipr_sdt_copy(struct ipr_ioa_cfg *ioa_cfg,
 	       (ioa_dump->hdr.len + bytes_copied) < max_dump_size) {
 		if (ioa_dump->page_offset >= PAGE_SIZE ||
 		    ioa_dump->page_offset == 0) {
-			page = (__be32 *)__get_free_page(GFP_ATOMIC);
+			page = kmalloc(PAGE_SIZE, GFP_NOIO);
 
 			if (!page) {
 				ipr_trace;
@@ -3226,7 +3226,7 @@ static void ipr_release_dump(struct kref *kref)
 	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
 
 	for (i = 0; i < dump->ioa_dump.next_page_index; i++)
-		free_page((unsigned long) dump->ioa_dump.ioa_data[i]);
+		kfree(dump->ioa_dump.ioa_data[i]);
 
 	vfree(dump->ioa_dump.ioa_data);
 	kfree(dump);

-- 
2.53.0


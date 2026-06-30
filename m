Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC3FA38C41B;
	Tue, 30 Jun 2026 10:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782816864; cv=none; b=pgAtvysTs4OpBZiwfDv4xAptjcumgkj9ZzIhWWOJ+w5OGHDmZTPGdYk9xmViO9CtkxbTQp7qI8gz+KQ+paJpbjcXqX4WcDG5iun23e9cyGCE9/Ls2/xMMjTEVMVavo6oLblxVrLkDi8RmCBWDVlroOQnSHQKjE3iLnNS2lqeeps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782816864; c=relaxed/simple;
	bh=h/gEhfrUJha1kZVU8awchaudZMXL+KTCgzMarIdQPmc=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=HIWfOElikMgJ8xw56Ye22ojIwzKpL7FwoyPZEk/PN2PRQkxz9J3z1ro/wEl1SaMFLUAhfhqNzHNgQLdMLvmnIUNbmwajdn+sh2md07/TNu9lXok9oUBIF21TDcrIv0qEuGNd51g4Y24aaTMcP7cLGI8SZ3UX4hXrfnwaFfv+jQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fJgceCav; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fJgceCav"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2563F1F000E9;
	Tue, 30 Jun 2026 10:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782816863;
	bh=FnV8WNv2U/2NeCf/652mdSlf9RYHKUxm9hACRNRtpLQ=;
	h=From:Subject:Date:To:Cc;
	b=fJgceCavbNPcF66SdZ9l13sifefI0sGJa2R/z+GKzBrF6OvGDYZL9bxpDhALEYZfg
	 B+OQ9FyUviVgK11A9a03ctqjcK1DF0Zkcw8ZPHNR++4Gn83wGnDEYjJVjgMwN0K0jm
	 krV3K2OueN3a6Hvez+zmYWyAPzsRP9jxD+m9prbSRIIbyghVlpOmvsJ6uq+JpWTa8T
	 KdvIxZ1KHQRxye+1mO5tSoXGtsqWbl7ZVCJVHsbyyCPLsSUY3eCYmeNEUH60ZADbNU
	 VhftXGA08ItqiRlKnf37DEIAlMF+a4DKeh5D+AFXfXhJO6Cp79/Y0qO4UarPwEcDJq
	 ZffD7riVNrXkQ==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: [PATCH 0/4] scsi: replace __get_free_pages() with kmalloc()
Date: Tue, 30 Jun 2026 13:54:17 +0300
Message-Id: <20260630-b4-scsi-v1-0-494fb37ebe7b@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAFmgQ2oC/yWM0QrCMAxFf2Xk2WA76lB/RXxo2sxFsEqiMhj79
 7X6eC7n3AWMVdjg3C2g/BWTZ6ngdx2kKZYbo+TK0Lt+cIP3SAEtmWB25JjC8XQYA1T7pTzK/Hu
 6XP9sH7pzere8GRSNkTSWNLWJwl7zI8K6bqAOpNyFAAAA
X-Change-ID: 20260611-b4-scsi-d0b0eb4895f4
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Brian King <brking@us.ibm.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 Matthew Wilcox <willy@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
X-Mailer: b4 0.15.2

This is a (small) part of larger work of replacing page allocator calls
with kmalloc.

My initial intention a few month ago was to remove ugly casts [1], but then
willy pointed out that Linus objected to something like this [2] and it
looks like more than a decade old technical debt.

Largely, anything that doesn't need struct page (or a memdesc in the
future) should just use kmalloc() or kvmalloc() to allocate memory.
kmalloc() guarantees alignment, physical contiguity and working
virt_to_phys() and beside nicer API that returns void * on alloc and
doesn't require to know the allocation size on free, kmalloc() provides
better debugging capabilities than page allocator.

Another thing is that touching these allocation sites gives the reviewers
opportunity to see if a PAGE_SIZE buffer is actually needed or maybe
another size is appropriate.

For larger allocations that don't need physically contiguous memory
kvmalloc() can be a better option that __get_free_pages() because under
memory pressure it's is easier to allocate several order-0 pages than a
physically contiguous chunk with the same number of pages.

And last, but not least, removing needless calls to page allocator should
help with memdesc (aka project folio) conversion. There will be way less
places to audit to see if the user was actually using struct page.

Also in git:
https://git.kernel.org/pub/scm/linux/kernel/git/rppt/linux.git gfp-to-kmalloc/scsi

[1] https://lore.kernel.org/all/20251018093002.3660549-1-rppt@kernel.org/
[2] https://lore.kernel.org/all/CA+55aFwp4iy4rtX2gE2WjBGFL=NxMVnoFeHqYa2j1dYOMMGqxg@mail.gmail.com/ 

---
Mike Rapoport (Microsoft) (4):
      scsi: target: file: use kmalloc() to allocate temporary protection buffer
      scsi: proc: use kmalloc() in proc writers
      scsi: ipr: use kmalloc() to allocate IPR dump buffer memory
      scsi: sym53c8xx_2: replace __get_free_pages() with kmalloc()

 drivers/scsi/ipr.c                  | 4 ++--
 drivers/scsi/scsi_devinfo.c         | 4 ++--
 drivers/scsi/scsi_proc.c            | 9 +++++----
 drivers/scsi/sym53c8xx_2/sym_hipd.h | 4 ++--
 drivers/target/target_core_file.c   | 4 ++--
 5 files changed, 13 insertions(+), 12 deletions(-)
---
base-commit: dc59e4fea9d83f03bad6bddf3fa2e52491777482
change-id: 20260611-b4-scsi-d0b0eb4895f4

Best regards,
--  
Sincerely yours,
Mike.


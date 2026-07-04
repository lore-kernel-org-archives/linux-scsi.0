Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C86A2EA154;
	Sat,  4 Jul 2026 06:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783145621; cv=none; b=OI+RT71yk8BK5JYAaVfzsinofywgYeEIVJ4UmTwXgbQZXeyjIIbUEi8uRGVyyl2W1RcJvxd6GI5vqQHXVJYvZtFdqLunFZJozVE9GU/U3G/PguKAU8B5lAeHXwg3SFlR2RlDCKtaBPkKVYTRcQLugasIk/OUO1kMMT+gq6TXb5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783145621; c=relaxed/simple;
	bh=Ae3LLEbj1wUuBML+5S1ihzOWqgCBFcJMramPuzJ2xd0=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=JnkHT56L/16OpsHklReqjdBENm4KeNJ8krvY+xgqwaeYCpo1vn7XM6ldpog3APvcLcR0Q7jdkDpZTCFovl5hDEHmT5O/cqj3nWmovd3vFQBbRgTJiLJqqmuk2wrc/77ocuL9DETmps8fwOESW4ECk7RfHQUDJjyEyX4VKTaf9Tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MWX88DRk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MWX88DRk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F8791F000E9;
	Sat,  4 Jul 2026 06:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783145620;
	bh=ws31OmbOfyl6nG5V5F4r74N/O/5v/oyarnt17TdEJgI=;
	h=From:Subject:Date:To:Cc;
	b=MWX88DRkGxlLPON9lrKAXoGQa79xdBX5lFfhacabPYFPrPz34p12iRiw+TNwZZqFl
	 eHWwuUoqzxXQLe++dTq/rqQRlSk7EuxD9oiJ1dCQcNfOcDveHiOk7tUMsyxYZ5JPo6
	 CHjCWcvK6EAdykMI0ZmaO3SF4jFWciHhfsAjez9CqPeEQLiji4hp6N3PrG6Bggj2Dq
	 Nduf44gCIxmxfdvcRyFB9AgPD4yYK9Ff5mN6uk3HgGBBx2V0qqFgk6vMyILXOii0+e
	 90nKN3JZ6m4Dnotxn79/J9AWOc3kyt/FrEsuoj9QFjmD5TLkVoUdM/Hq2SftGjY8/H
	 bVjJwFTtDqAYg==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: [PATCH v2 0/4] scsi: replace __get_free_pages() with kmalloc()
Date: Sat, 04 Jul 2026 09:13:33 +0300
Message-Id: <20260704-b4-scsi-v2-0-7d2d21a810de@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAI2kSGoC/z2OTQ6CMBCFr0JmbU0LFcSV9zAsmDLAqCmmg0RDu
 LsUjcvv5f3NIBSYBE7JDIEmFh78CukuAdfXviPFzcqQ6jTXuTEKrRInrBqNmtAey0NrYXU/ArX
 82pou1ZfliVdyY4xHB9ZCCkPtXR+liFHuWcYhvLcHk4nx31im/2OTUVrZ0raYFYRU4PlGwdN9P
 4QOqmVZPlrQABPIAAAA
X-Change-ID: 20260611-b4-scsi-d0b0eb4895f4
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Brian King <brking@us.ibm.com>, Hannes Reinecke <hare@suse.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 Matthew Wilcox <willy@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
 Wen Xiong <wenxiong@linux.ibm.com>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-scsi@vger.kernel.org, 
 target-devel@vger.kernel.org, Hannes Reinecke <hare@kernel.org>, 
 John Garry <john.g.garry@oracle.com>
X-Mailer: b4 0.16-dev

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
v2 changes:
* replace GFP_ATOMIC with GFP_NOIO in ipr driver

v1: https://patch.msgid.link/20260630-b4-scsi-v1-0-494fb37ebe7b@kernel.org

---
Mike Rapoport (Microsoft) (4):
      scsi: target: file: use kmalloc() to allocate temporary protection buffer
      scsi: proc: use kmalloc() in proc writers
      scsi: ipr: use kmalloc() to allocate IPR dump buffer memory
      scsi: sym53c8xx_2: replace __get_free_pages() with kmalloc()

 drivers/scsi/ipr.c                  | 4 ++--
 drivers/scsi/scsi_devinfo.c         | 5 +++--
 drivers/scsi/scsi_proc.c            | 9 +++++----
 drivers/scsi/sym53c8xx_2/sym_hipd.h | 4 ++--
 drivers/target/target_core_file.c   | 4 ++--
 5 files changed, 14 insertions(+), 12 deletions(-)
---
base-commit: dc59e4fea9d83f03bad6bddf3fa2e52491777482
change-id: 20260611-b4-scsi-d0b0eb4895f4

--
Sincerely yours,
Mike.


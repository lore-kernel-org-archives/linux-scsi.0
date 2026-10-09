Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1727F2F619D;
	Fri,  9 Oct 2026 18:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791569078; cv=none; b=BhrQlWHAx6rosmFMynLdAnz/qe6nG3xLpHk7Rk4xfav1ixRdth98gNxjPjmgjfhUGscGjyNGSnGrOsDBK4NkiKLqlszqO14tWEgEjSNOdLe1Ko28/M4MKeXTBU9lXKV8aYlgjC5vIXVTGPsTsMQYsQE6n31kszhO5NN8g0sDpxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791569078; c=relaxed/simple;
	bh=n4V9rL2hXS1EHjEQMTlg867FNgqGNKwt46gTB6wkitI=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=OJ6S7s1rlPoKMU1qztIzHAZkL/kRCNuZbOciW4xpbQN/Ep2bY1s/7Umaf8o1p8UIEJ9Yn4c7xQ5u56UWJ32bqKJ2tRFj+e05gLFcP+bdDxHiw/2AGUcZJuf6SqWIVR9KyJyPKaBbap/keXnouYDKja6Vc0rVbGbqHvScNp1RH3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qad3KSrd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qad3KSrd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9D731F000FF;
	Fri,  9 Oct 2026 18:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791569076;
	bh=SHbPL8zAhY1EPDigTnWul0MzUeZXzl8KtpG/s8AqHXY=;
	h=From:Subject:Date:To:Cc;
	b=Qad3KSrddBgXnQWBK0Lx2JvuXuUvt6cFnQA7ziRLUO7kybnH5xcjHLqxLIjnOMaae
	 vIQcFH7oS6EG/qkp0/aK8LoTXMFgmhjy8SLC9NLnfIJA2cfdZuTMiR8PyUCOAQbXT1
	 SizGfxN5Cy1MC+n11o8cFtpHAJG50xLWg2Tr2mMYCFNV6/fB5HU0wOp/rJnC886Ulz
	 N9BwAObrLZTs86EmJo66Ak0JXK1F4SkrFaqzUctVqRC6UlARTGESabx4ECJvmNMtDi
	 o/hVI7HkK3JlHS0y5DTpLbGC5XZp7HJYNWyCNIRpIaQmIjHHWfFRcBBc6/R0RQAT2A
	 AS2nq+aY71VAg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: [PATCH v5 00/38] mm: make VMA flag semantics explicit, eliminate
 VM_SPECIAL
Date: Fri, 09 Oct 2026 19:03:54 +0100
Message-Id: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/4XQTW7DIBAF4KtErEsFAwQ7q96j6mIMg0Mb/whS1
 Cjy3YsTqUqVhZdPevreaK4sU4qU2WF3ZYlKzHEaazAvO+aOOPbEo6+ZgYC9sCB5p/kw4MznRDM
 m4mVAHk7Y84xjDBcOUggNxgeDyKpSeyH+3BbeP+45f3ef5M4ruzaOMZ+ndLmdUOTau6+1otlcK
 5IL7tEF2TpHAN3bF6WRTq9T6tk6V+ABlHobhApa39pGkjdqL59A9QjabVBVUJtG+QZBdQ6fQP0
 H1tepbVBXEGUQBowQwdt/4LIsv+zINubUAQAA
X-Change-ID: 20260721-b4-mmap-prepare-vma-flag-sanify-2100425df5aa
To: Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Jonathan Corbet <corbet@lwn.net>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
 Paul Moore <paul@paul-moore.com>, 
 Stephen Smalley <stephen.smalley.work@gmail.com>, 
 Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, 
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
 Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
 Kumar Kartikeya Dwivedi <memxor@gmail.com>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Doug Gilbert <dgilbert@interlog.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <mkp@kernel.org>, Simona Vetter <simona@ffwll.ch>, 
 Helge Deller <deller@gmx.de>, Sebastian Reichel <sre@kernel.org>, 
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
 Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
 Arnaldo Carvalho de Melo <acme@kernel.org>, 
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
 David Airlie <airlied@gmail.com>, Will Deacon <will@kernel.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Arnd Bergmann <arnd@arndb.de>, 
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, Anup Patel <anup@brainfault.org>, 
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Janosch Frank <frankja@linux.ibm.com>, 
 Claudio Imbrenda <imbrenda@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 "David S. Miller" <davem@davemloft.net>, 
 Andreas Larsson <andreas@gaisler.com>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
 Youngjun Park <youngjun.park@lge.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Michal Hocko <mhocko@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, 
 Xu Xin <xu.xin@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-usb@vger.kernel.org, 
 linux-rdma@vger.kernel.org, selinux@vger.kernel.org, 
 linux-sound@vger.kernel.org, bpf@vger.kernel.org, 
 linux-scsi@vger.kernel.org, linux-fbdev@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linux-trace-kernel@vger.kernel.org, 
 linux-perf-users@vger.kernel.org, linux-arch@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
 linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, 
 fuse-devel@lists.linux.dev, Ihor Solodrai <ihor.solodrai@linux.dev>, 
 Bert Karwatzki <spasswolf@web.de>, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, 
 Takashi Iwai <tiwai@suse.de>, Emil Tsalapatis <emil@etsalapatis.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=13909; i=ljs@kernel.org;
 h=from:subject:message-id; bh=n4V9rL2hXS1EHjEQMTlg867FNgqGNKwt46gTB6wkitI=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJO6kydo702/Ib2xh9+HSqmfsVCNscPR/U77Ut0rj9xh
 SnxoOn3jlIWBjEuBlkxRZbnX8T3B4mEzeu84O8GM4eVCWQIAxenAEzEUJ2R4eZn3ZoPJ+4KpZV/
 zIlJktF97JTUnWozvY7fWIl3JdsSR0aGw3Ec7V0VV6v3Wah8KNselbo8wS/c8P0f3eQCy6s2bXW
 cAA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14

The VM_SPECIAL / VMA_SPECIAL_FLAGS mask conflates several unrelated
properties:

* Is this managed by core mm, or by a driver mapping MMIO, kernel-allocated
  pages, or even ordinary pages itself?
* Can it be expanded or merged?
* Is this a 'weird' case like mlock where migration might race and we
  'have' to set invalid flags to notify?
* Is it another 'weird' case where we just want to stop GUP from touching
  it?

Driver writers have often been confused about this, and who can blame them?

It also interacts badly with the eternal edgecase known as hugetlb - which
sets VMA_DONTEXPAND_BIT but doesn't also want to be treated like a
'special' flag.

Another issue is that we cannot make sensible assumptions about flag
use. It's not possible to assume VMA_IO_BIT means iommu because drivers
abuse it and mlock abuses it.

Special is also an overloaded term in mm. VDSO and VVAR mappings are also
called 'special' but they're special in a... special way.

Sometimes things are called special that are a subset of
VMA_SPECIAL_FLAGS (VMA_PFNMAP_BIT and VMA_MIXEDMAP_BIT for instance when it
comes to zapping or vm_normal_folio()).

There's a specific kind of special for THP too, which considers
PFN map, mixed map 'special' but DAX not.

It's all rather a mess.

This series brings some order to things by both limiting what drivers can
do with VMA flags and switching to using predicates that describe
behaviour, not arbitrary flags.

It establishes the invariant that mm-managed mappings may neither set
VMA_IO_BIT nor clear VMA_MAYWRITE_BIT in an mmap hook, enforcing this by
validating VMA state after every mmap and mmap_prepare hook.

It updates usbmon and sg to mmap_prepare in order to do so, adding a new
mmap action for mapping discontiguous kernel pages, and has hfi1 and the
ALSA PCM status page map their pages eagerly instead.

It also establishes the invariant that VMA_MIXEDMAP_BIT be set when mapping
kernel memory, something that is usually the case but happens not to be for
some users - specifically defio, cmt_speech, uprobes and the bpf arena, all
of which are updated to do the right thing.

It replaces VM_SPECIAL and arbitrary flag tests with predicates that say
what is actually being tested:

     vma_is_mm_managed()   Are the VMA's contents established and managed
                           by core mm, rather than a driver or other kernel
                           component?

      vma_is_mm_backed()   Is the VMA backed by memory core mm itself
                           faults in and keeps, rather than a driver or
                           device?

  vma_is_fixed_mapping()   Is the VMA not permitted to be expanded or
                           merged?

         vma_can_merge()   Can the VMA be merged with a compatible
                           neighbour?

Remaining raw VMA_IO_BIT, VMA_PFNMAP_BIT and VMA_MIXEDMAP_BIT tests
scattered across mm are converted to predicates where they express one, and
left as explicit flag tests where they do not.

And also the opportunity is taken to eliminate THP's vma_is_special_huge()
which was an existing source of confusion.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
v5:
* Applied tags (thanks everybody!)
* Updated 3/38 to fix a bug in __mmap_new_file_vma() by zapping + closing
  the VMA before setting vma->vm_file NULL to avoid an i_mmap_writable
  imbalance. A repro was tested before/after and confirmed fixed.
* Updated 7/38 to make __map_kernel_pages_prepare() use
  mmap_assert_write_locked() rather than the weird
  assert-on-mmap_read_trylock() pattern, as per Suren.
* Also update vm_insert_page(), vm_insert_pages() to fix the same pattern
  and to use the new VMA API, and converted a BUG_ON to a
  VM_WARN_ON_ONCE().

v4:
* Pulled what was 2/40 out of the series to send as a fix instead, as per
  Suren.
* Updated 1/38 to rename put_map() to map_put_vm_file(), as per Suren and
  Liam.
* Updated 3/38 (was 4/40) to perform the vma_close() after unmapping the
  range as per Gregory.
* Updated 3/38 (was 4/40) to rename prev_* to orig_* in the mmap hook
  validation code, as per Suren.
* Updated 4/38 (was 5/40) to clarify that the mergeable-VMA action check
  runs after mmap_action_prepare(), as per Zi.
* Updated 7/38 (was 8/40) to have discontig_kernel_map_page_range() map
  only the pages which fit in the VMA, consistent with
  discontig_kernel_map_page(), as per Suren and Zi.
* Updated 7/38 (was 8/40) to unmap and close the VMA when an mmap action
  fails under the mmap_prepare compatibility layer, so state is correctly
  released there too, as per Lance.
* Updated 8/38 (was 9/40) to document this, as per Zi.
* Updated 14/38 (was 15/40) to replace vma[_flags]_is_kernel_owned() with
  its inverse, vma[_flags]_is_mm_managed() and reword accordingly
  throughout, as per David.
* Updated 22/38 (was 23/40) to add a clarifying comment, as per Zi.
* Updated 23/38 (was 24/40) to test VMA_LOCKED_MASK before draining the
  mlock batch in try_to_unmap_one() and try_to_migrate_one(), as per Lance.
* Updated 30/38 (was 31/40) to rename vma[_flags]_is_persistent() to
  vma[_flags]_is_mm_backed() and reword its documentation around what backs
  the mapping rather than persistence, as per David.
* Updated 31/38 (was 32/40) to make the code more succinct in
  vma_move_compatible(), as per David.
* Dropped what was 40/40, vma[_flags]_can_gup(), as per David.
https://lore.kernel.org/r/20261003-b4-mmap-prepare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org

v3:
* Fixed up bug in patch 1 as reported by Mike - have to delay setting
  map->vma_flags until after action prepare, though map->vm_file needs to
  be set before for correct reference count management.
* Updated 4/40 to add a symmetric vm_end check as well as vm_start in case
  of a dangerously insane driver, as per Sashiko.
* Updated 8/40 to check if a driver did something REALLY stupid like having
  a NULL discontig_kernel_page_ops ptr, as per Sashiko.
* Updated 15/40 to trivially synchronise userland test comments.
* Updated 17/40 to correctly duplicate code to the userland VMA tests as
  per Sashiko.
https://lore.kernel.org/r/20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org

v2:
* Rebased on mm-unstable.
* Introduced new patch to fix various mmap_prepare and file interactions
  that weren't quite right as per Sashiko. None impact anything upstream
  yet so it doesn't need to be a fix.
* Restore vma->vm_start if an mmap hook has moved it before tearing the
  VMA down, so we unmap the range we established rather than the one the
  hook invented, as per Sashiko.
* Reject a discontiguous kernel page batch of zero pages rather than
  looping forever, and bound batches by the pages remaining in the VMA,
  as per Sashiko.
* Add the missing map_kernel_discontig member to the userland VMA tests'
  copy of struct mmap_action as per Sashiko.
* Set VM_DONTEXPAND on hfi1's RCV_HDRQ, RCV_EGRBUF and RTAIL mappings, as
  dma_mmap_coherent() doesn't on the IOMMU-DMA path, as per Sashiko.
* Recompute vma->vm_page_prot in snd_pcm_mmap_status() after clearing
  VM_WRITE, as vm_insert_page() uses it immediately rather than at fault
  time, as per Sashiko.
* munlock_vma_folio() now tests VMA_LOCKED_MASK so an unmap racing the
  mlock walk still munlocks folios the walk has already counted, as per
  Sashiko.
https://lore.kernel.org/r/20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org

v1:
https://lore.kernel.org/r/20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org

---
Lorenzo Stoakes (ARM) (38):
      mm/vma: fix mmap_prepare file handling, remove file_doesnt_need_get
      mm/vma: introduce and use vma_[flags_]can_merge()
      mm: consistently validate VMA state after mmap[_prepare] hooks
      mm/vma: ensure mmap_prepare doesn't set actions on a mergeable vma
      mm: make map_kernel_pages_[prepare,complete] internal and unexported
      mm/vma: tidy up map kernel pages enum values
      mm: add mmap action for discontiguous kernel page mapping
      docs: filesystems: update mmap_prepare docs for discontig kernel pgs
      drivers/usb/mon: update to use mmap_prepare + map kernel pages
      infiniband: update hfi1 to use remap_vmalloc_range()
      selinux: reject writable opens of policy file, drop mmap shared/write check
      ALSA: pcm: use vm_insert_page() to map PCM status page
      bpf: arena: mark arena_map_mmap() mappings VM_MIXEDMAP
      mm/vma: add vma[_flags]_is_mm_managed() predicates
      mm/vma: only allow mmap to clear VMA_MAYWRITE_BIT if not mm-managed
      mm/vma: add and use vma_[flags]_is_fixed_mapping
      scsi: sg: convert mmap hook to mmap_prepare and rework
      fbdev: defio: assert FBINFO_VIRTFB, drop VM_IO, add VM_MIXEDMAP
      HSI: cmt_speech: convert mmap hook to mmap_prepare, refactor
      mm/gup: error out early on !VMA_MAYREAD_BIT VMAs
      uprobes: remove VM_IO, set VM_MIXEDMAP for mapped kernel pages
      mm/mlock: clear VMA_LOCKED_MASK over mmap callback
      mm/mlock: eliminate weird VMA_IO_BIT abuse and simplify
      mm/vma: enforce that mm-managed mappings may not set VMA_IO_BIT
      mm: remove VMA_IO_BIT check in vma[_flags]_is_mm_managed()
      mm: remove hugetlb_inline.h
      mm: rename is_vm_hugetlb_page() to vma_is_hugetlb()
      mm: drop some redundant checks around hugetlb VMAs
      mm/madvise: update is_valid_guard_vma() to use vma_can_merge()
      mm/vma: introduce vma[_flags]_is_mm_backed()
      mm/uffd: use predicates for userfaultfd checks
      mm/madvise: use predicates for madvise(..., MADV_DOFORK)
      mm: eliminate VMA_SPECIAL_FLAGS usage when hugetlb explicitly tested
      mm: eliminate VMA_SPECIAL_FLAGS check in lru_gen_look_around()
      mm: avoid use of VMA_SPECIAL_FLAGS in migrate_vma_setup()
      mm: eliminate VM_SPECIAL, VMA_SPECIAL_FLAGS
      fuse: dax: do not set VM_MIXEDMAP
      mm/huge_memory: remove vma_is_special_huge()

 Documentation/filesystems/mmap_prepare.rst |  81 ++++++++++
 arch/arm64/kvm/mmu.c                       |   4 +-
 arch/powerpc/mm/book3s64/radix_tlb.c       |   6 +-
 arch/powerpc/mm/nohash/e500_hugetlbpage.c  |   2 +-
 arch/powerpc/mm/nohash/tlb.c               |   2 +-
 arch/riscv/kvm/mmu.c                       |   2 +-
 arch/riscv/mm/tlbflush.c                   |   2 +-
 arch/s390/mm/gmap_helpers.c                |   6 +-
 arch/sparc/mm/init_64.c                    |   2 +-
 arch/x86/kernel/uprobes.c                  |   2 +-
 drivers/gpu/drm/drm_gpusvm.c               |   5 +-
 drivers/hsi/clients/cmt_speech.c           |  33 ++--
 drivers/infiniband/hw/hfi1/file_ops.c      |  83 +++-------
 drivers/scsi/sg.c                          | 115 ++++++-------
 drivers/usb/mon/mon_bin.c                  |  82 ++++++----
 drivers/video/fbdev/core/fb_defio.c        |   6 +-
 drivers/video/fbdev/ssd1307fb.c            |   2 +
 fs/coredump.c                              |   2 +-
 fs/fuse/dax.c                              |   2 +-
 fs/hugetlbfs/inode.c                       |   2 +-
 fs/proc/task_mmu.c                         |   8 +-
 include/asm-generic/tlb.h                  |   4 +-
 include/linux/hugetlb.h                    |   5 +-
 include/linux/hugetlb_inline.h             |  28 ----
 include/linux/mm.h                         | 240 +++++++++++++++++++++++++--
 include/linux/mm_types.h                   |  50 +++++-
 include/linux/pagemap.h                    |   1 -
 include/linux/rmap.h                       |   2 +-
 include/linux/userfaultfd_k.h              |   1 -
 kernel/bpf/arena.c                         |   3 +-
 kernel/events/core.c                       |   2 +-
 kernel/events/uprobes.c                    |   4 +-
 kernel/sched/fair.c                        |   3 +-
 mm/folio.c                                 |   2 +-
 mm/gup.c                                   |   8 +-
 mm/huge_memory.c                           |  31 ++--
 mm/hugetlb.c                               |  14 +-
 mm/internal.h                              |  80 +++++----
 mm/ksm.c                                   |   4 +-
 mm/madvise.c                               |  28 ++--
 mm/memory.c                                | 147 ++++++++++++++---
 mm/mempolicy.c                             |   2 +-
 mm/migrate_device.c                        |  12 +-
 mm/mlock.c                                 |  51 +++---
 mm/mmap.c                                  |   2 +-
 mm/mmu_gather.c                            |   2 +-
 mm/mprotect.c                              |   5 +-
 mm/mremap.c                                |  11 +-
 mm/page_vma_mapped.c                       |   4 +-
 mm/pagewalk.c                              |   2 +-
 mm/rmap.c                                  |   8 +-
 mm/swapfile.c                              |   2 +-
 mm/userfaultfd.c                           |  43 ++---
 mm/util.c                                  |  49 ++++--
 mm/vma.c                                   | 250 ++++++++++++++++++++++-------
 mm/vma.h                                   |  31 +++-
 mm/vma_internal.h                          |   1 -
 mm/vmscan.c                                |   9 +-
 security/selinux/selinuxfs.c               |  11 +-
 sound/core/pcm_native.c                    |  38 ++---
 tools/testing/vma/include/dup.h            |  80 +++++++--
 tools/testing/vma/include/stubs.h          |   6 +-
 tools/testing/vma/tests/merge.c            |  10 +-
 63 files changed, 1164 insertions(+), 571 deletions(-)
---
base-commit: 6b41451631cabf9ea3b384c2a099088e1598f963
change-id: 20260721-b4-mmap-prepare-vma-flag-sanify-2100425df5aa

Cheers,
-- 
Lorenzo Stoakes (ARM) <ljs@kernel.org>


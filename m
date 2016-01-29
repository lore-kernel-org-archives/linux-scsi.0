From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: mm: another VM_BUG_ON_PAGE(PageTail(page))
Date: Fri, 29 Jan 2016 15:35:11 +0300
Message-ID: <20160129123511.GA146512@black.fi.intel.com>
References: <CACT4Y+Z9UDZNLsoEz-DO3fX_+0gTwPUA=uE++J=w1sAG_4CGJg@mail.gmail.com>
 <20160128105136.GD2396@node.shutemov.name>
 <CACT4Y+ZZkWTuw8hxnqLEf81bF=GL2SKv8Buqwv3qByBeSLBf+A@mail.gmail.com>
 <20160128114042.GE2396@node.shutemov.name>
 <CACT4Y+Ybn_YAsP6f_wRfPr-zw2ZbF8cfKBMtqhZ=ya-qCpeq3w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <CACT4Y+Ybn_YAsP6f_wRfPr-zw2ZbF8cfKBMtqhZ=ya-qCpeq3w@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
To: Dmitry Vyukov <dvyukov@google.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>, Vlastimil Babka <vbabka@suse.cz>, Doug Gilbert <dgilbert@interlog.com>, Andrew Morton <akpm@linux-foundation.org>, David Rientjes <rientjes@google.com>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, Shiraz Hashim <shashim@codeaurora.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Hugh Dickins <hughd@google.com>, Sasha Levin <sasha.levin@oracle.com>, syzkaller <syzkaller@googlegroups.com>, Kostya Serebryany <kcc@google.com>, Alexander Potapenko <glider@google.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

>From e20cd50a8f612dbc720d31d269e748215607a0b8 Mon Sep 17 00:00:00 2001
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Date: Fri, 29 Jan 2016 14:55:40 +0300
Subject: [PATCH 1/2] mm: fix bogus VM_BUG_ON_PAGE() in isolate_lru_page()

We don't care if there's a tail pages which is not on LRU. We are not
going to isolate them anyway.

Testcase:

	#include <fcntl.h>
	#include <unistd.h>
	#include <stdio.h>
	#include <sys/mman.h>
	#include <numaif.h>

	#define SIZE 0x2000

	int foo;

	int main()
	{
		int fd;
		char *p;
		unsigned long mask = 2;

		fd = open("/dev/sg0", O_RDWR);
		p = mmap(NULL, SIZE, PROT_READ | PROT_WRITE, MAP_PRIVATE, fd, 0);
		/* Faultin pages */
		foo = p[0] + p[0x1000];
		mbind(p, SIZE, MPOL_BIND, &mask, 4, MPOL_MF_MOVE | MPOL_MF_STRICT);
		return 0;
	}

MPOL_MF_STRICT makes queue_pages_test_walk() ignore !vma_megratable()
and we try to queue such pages for migration. It's good question why we
ignore !vma_megratable() for MPOL_MF_STRICT, but it's subject for a
separate patch.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: Dmitry Vyukov <dvyukov@google.com>
Fixes: bb5b8589767a ("mm: make sure isolate_lru_page() is never called for tail page")
---
 mm/vmscan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index eb3dd37ccd7c..492fbe73420b 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1443,7 +1443,7 @@ int isolate_lru_page(struct page *page)
 	int ret = -EBUSY;
 
 	VM_BUG_ON_PAGE(!page_count(page), page);
-	VM_BUG_ON_PAGE(PageTail(page), page);
+	VM_BUG_ON_PAGE(PageLRU(page) && PageTail(page), page);
 
 	if (PageLRU(page)) {
 		struct zone *zone = page_zone(page);
-- 
2.7.0.rc3

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

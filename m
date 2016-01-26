From: Vlastimil Babka <vbabka@suse.cz>
Subject: Re: mm: VM_BUG_ON_PAGE(PageTail(page)) in mbind
Date: Tue, 26 Jan 2016 22:37:35 +0100
Message-ID: <56A7E71F.4060905@suse.cz>
References: <CACT4Y+YK7or=W4RGpv1k1T5-xDHu3_PPVZWqsQU6nWoArsV5vA@mail.gmail.com>
 <20160126202829.GA21250@node.shutemov.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53123 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751372AbcAZVhm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Jan 2016 16:37:42 -0500
In-Reply-To: <20160126202829.GA21250@node.shutemov.name>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Kirill A. Shutemov" <kirill@shutemov.name>, Dmitry Vyukov <dvyukov@google.com>, Doug Gilbert <dgilbert@interlog.com>, Andrew Morton <akpm@linux-foundation.org>, David Rientjes <rientjes@google.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Shiraz Hashim <shashim@codeaurora.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Hugh Dickins <hughd@google.com>, Sasha Levin <sasha.levin@oracle.com>, syzkaller <syzkaller@googlegroups.com>, Kostya Serebryany <kcc@google.com>, Alexander Potapenko <glider@google.com>, linux-scsi@vger.kernel.org

On 26.1.2016 21:28, Kirill A. Shutemov wrote:
> From 396ad132be07a2d2b9ec5d1d6ec9fe2fffe8105e Mon Sep 17 00:00:00 2001
> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> Date: Tue, 26 Jan 2016 22:59:16 +0300
> Subject: [PATCH] sg: mark VMA as VM_IO to prevent migration
> 
> Reduced testcase:
> 
> 	#include <fcntl.h>
> 	#include <unistd.h>
> 	#include <sys/mman.h>
> 	#include <numaif.h>
> 
> 	#define SIZE 0x2000
> 
> 	int main()
> 	{
> 		int fd;
> 		void *p;
> 
> 		fd = open("/dev/sg0", O_RDWR);
> 		p = mmap(NULL, SIZE, PROT_EXEC, MAP_PRIVATE | MAP_LOCKED, fd, 0);
> 		mbind(p, SIZE, 0, NULL, 0, MPOL_MF_MOVE);
> 		return 0;
> 	}
> 
> We shouldn't try to migrate pages in sg VMA as we don't have a way to
> update Sg_scatter_hold::pages accordingly from mm core.
> 
> Let's mark the VMA as VM_IO to indicate to mm core that the VMA is
> migratable.

 ^ not migratable.

Acked-by: Vlastimil Babka <vbabka@suse.cz>


> 
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Reported-by: Dmitry Vyukov <dvyukov@google.com>
> ---
>  drivers/scsi/sg.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index 503ab8b46c0b..5e820674432c 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -1261,7 +1261,7 @@ sg_mmap(struct file *filp, struct vm_area_struct *vma)
>  	}
>  
>  	sfp->mmap_called = 1;
> -	vma->vm_flags |= VM_DONTEXPAND | VM_DONTDUMP;
> +	vma->vm_flags |= VM_IO | VM_DONTEXPAND | VM_DONTDUMP;
>  	vma->vm_private_data = sfp;
>  	vma->vm_ops = &sg_mmap_vm_ops;
>  	return 0;
> 


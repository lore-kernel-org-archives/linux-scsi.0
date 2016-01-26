From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: mm: VM_BUG_ON_PAGE(PageTail(page)) in mbind
Date: Tue, 26 Jan 2016 12:49:16 -0800
Message-ID: <20160126124916.1f4ed291a6e4bcf19b74b7f7@linux-foundation.org>
References: <CACT4Y+YK7or=W4RGpv1k1T5-xDHu3_PPVZWqsQU6nWoArsV5vA@mail.gmail.com>
	<20160126202829.GA21250@node.shutemov.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160126202829.GA21250@node.shutemov.name>
Sender: linux-kernel-owner@vger.kernel.org
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Dmitry Vyukov <dvyukov@google.com>, Doug Gilbert <dgilbert@interlog.com>, David Rientjes <rientjes@google.com>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Shiraz Hashim <shashim@codeaurora.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Hugh Dickins <hughd@google.com>, Sasha Levin <sasha.levin@oracle.com>, syzkaller <syzkaller@googlegroups.com>, Kostya Serebryany <kcc@google.com>, Alexander Potapenko <glider@google.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 26 Jan 2016 22:28:29 +0200 "Kirill A. Shutemov" <kirill@shutemov.name> wrote:

> Let's mark the VMA as VM_IO to indicate to mm core that the VMA is
> migratable.
> 
> ...
>
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

I'll put cc:stable on this - I don't think we recently did anything to make
this happen?

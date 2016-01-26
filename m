From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: mm: VM_BUG_ON_PAGE(PageTail(page)) in mbind
Date: Tue, 26 Jan 2016 23:05:34 +0200
Message-ID: <20160126210534.GA22852@node.shutemov.name>
References: <CACT4Y+YK7or=W4RGpv1k1T5-xDHu3_PPVZWqsQU6nWoArsV5vA@mail.gmail.com>
 <20160126202829.GA21250@node.shutemov.name>
 <20160126124916.1f4ed291a6e4bcf19b74b7f7@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20160126124916.1f4ed291a6e4bcf19b74b7f7@linux-foundation.org>
Sender: owner-linux-mm@kvack.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dmitry Vyukov <dvyukov@google.com>, Doug Gilbert <dgilbert@interlog.com>, David Rientjes <rientjes@google.com>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Shiraz Hashim <shashim@codeaurora.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Hugh Dickins <hughd@google.com>, Sasha Levin <sasha.levin@oracle.com>, syzkaller <syzkaller@googlegroups.com>, Kostya Serebryany <kcc@google.com>, Alexander Potapenko <glider@google.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Jan 26, 2016 at 12:49:16PM -0800, Andrew Morton wrote:
> On Tue, 26 Jan 2016 22:28:29 +0200 "Kirill A. Shutemov" <kirill@shutemov.name> wrote:
> 
> > Let's mark the VMA as VM_IO to indicate to mm core that the VMA is
> > migratable.
> > 
> > ...
> >
> > --- a/drivers/scsi/sg.c
> > +++ b/drivers/scsi/sg.c
> > @@ -1261,7 +1261,7 @@ sg_mmap(struct file *filp, struct vm_area_struct *vma)
> >  	}
> >  
> >  	sfp->mmap_called = 1;
> > -	vma->vm_flags |= VM_DONTEXPAND | VM_DONTDUMP;
> > +	vma->vm_flags |= VM_IO | VM_DONTEXPAND | VM_DONTDUMP;
> >  	vma->vm_private_data = sfp;
> >  	vma->vm_ops = &sg_mmap_vm_ops;
> >  	return 0;
> 
> I'll put cc:stable on this - I don't think we recently did anything to make
> this happen?

The VM_BUG_ON is new bb5b8589767a ("mm: make sure isolate_lru_page() is
never called for tail page"), but I don't think it changes the picture
much.

-- 
 Kirill A. Shutemov

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

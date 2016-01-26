From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: mm: VM_BUG_ON_PAGE(PageTail(page)) in mbind
Date: Tue, 26 Jan 2016 23:07:43 +0200
Message-ID: <20160126210743.GB22852@node.shutemov.name>
References: <CACT4Y+YK7or=W4RGpv1k1T5-xDHu3_PPVZWqsQU6nWoArsV5vA@mail.gmail.com>
 <20160126202829.GA21250@node.shutemov.name>
 <20160126124823.15b08f0a53dd9671fbc685d9@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20160126124823.15b08f0a53dd9671fbc685d9@linux-foundation.org>
Sender: owner-linux-mm@kvack.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dmitry Vyukov <dvyukov@google.com>, Doug Gilbert <dgilbert@interlog.com>, David Rientjes <rientjes@google.com>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Shiraz Hashim <shashim@codeaurora.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Hugh Dickins <hughd@google.com>, Sasha Levin <sasha.levin@oracle.com>, syzkaller <syzkaller@googlegroups.com>, Kostya Serebryany <kcc@google.com>, Alexander Potapenko <glider@google.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Jan 26, 2016 at 12:48:23PM -0800, Andrew Morton wrote:
> On Tue, 26 Jan 2016 22:28:29 +0200 "Kirill A. Shutemov" <kirill@shutemov.name> wrote:
> 
> > The patch below fixes the issue for me, but this bug makes me wounder how
> > many bugs like this we have in kernel... :-/
> > 
> > Looks like we are too permissive about which VMA is migratable:
> > vma_migratable() filters out VMA by VM_IO and VM_PFNMAP.
> > I think VM_DONTEXPAND also correlate with VMA which cannot be migrated.
> > 
> > $ git grep VM_DONTEXPAND drivers | grep -v '\(VM_IO\|VM_PFNMAN\)' | wc -l 
> > 33
> > 
> > Hm.. :-|
> > 
> > It worth looking on them closely... And I wouldn't be surprised if some
> > VMAs without all of these flags are not migratable too.
> > 
> > Sigh.. Any thoughts?
> 
> Sigh indeed.  I think that both VM_DONTEXPAND and VM_DONTDUMP are
> pretty good signs that mbind() should not be mucking with this vma.  If
> such a policy sometimes results in mbind failing to set a policy then
> that's not a huge loss - something runs a bit slower maybe.
> 
> I mean, we only really expect mbind() to operate against regular old
> anon/pagecache memory, yes?

Well, it can work fine too if driver itself uses page tables to find out
which pages it should to operate on. I don't think it's a common case.

-- 
 Kirill A. Shutemov

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

From: Andrew Morton <akpm@digeo.com>
Subject: Re: 2.4.39 "Sleeping function called from illegal context at
 slab.c:1374"
Date: Tue, 01 Oct 2002 15:23:54 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3D9A207A.14BFF440@digeo.com>
References: <3D99885B.533C320D@aitel.hist.no> <3D99EF62.3A3E6932@digeo.com> <20021001215907.GA8273@midgaard.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Andreas Boman <aboman@nerdfest.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org

Andreas Boman wrote:
> 
> * Andrew Morton (akpm@digeo.com) wrote:
> > Helge Hafting wrote:
> > >
> > > ..
> > >  [<c01146c4>]__might_sleep+0x54/0x60
> > >  [<c012dca0>]kmalloc+0x4c/0x130
> > >  [<c010b6b2>]sys_ioperm+0x82/0x11c
> > >  [<c0106fbb>]syscall_call+0x7/0xb
> > >
> >
> >
> > You up to trying this fix?
> >
> 
> This patch on 2.3.40+xfsfix didnt change anything here, while my trace
> does look different it seems to be related.

It's different.

> I get a similar oops when ide initializes during boot,

It's not an oops.  It's just a warning.

> 
>  Debug: sleeping function called from illegal context at slab.c:1374

See?  I added "Debug:" to the message ;)

>  Call Trace:
>   [__kmem_cache_alloc+255/272]__kmem_cache_alloc+0xff/0x110
>   [get_vm_area+38/256]get_vm_area+0x26/0x100
>   [__vmalloc+75/304]__vmalloc+0x4b/0x130
>   [vmalloc+34/48]vmalloc+0x22/0x30
>   [<e08fe502>]sg_init+0x82/0x130 [sg]
>   [<e09022c7>].rodata.str1.1+0x23/0x2b0 [sg]
>   [<e0903be0>]sg_fops+0x0/0x58 [sg]
>   [<e0903b20>]sg_template+0x0/0x94 [sg]

That is known - sg_init() is blatantly calling vmalloc under
write_lock_irqsave().

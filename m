From: Laurence Oberman <loberman@redhat.com>
Subject: Re: SG does not ignore dxferp (direct io + mmap)
Date: Tue, 22 Nov 2016 13:46:57 -0500 (EST)
Message-ID: <626176297.1590260.1479840417254.JavaMail.zimbra@redhat.com>
References: <CAPrnrPAanjswy-aeLF2s_JWCHCudXC6cwWmX8M7NuLMDSR95Mw@mail.gmail.com> <408136530.631221.1479686684102.JavaMail.zimbra@redhat.com> <CAPrnrPBOrkzz5f5rVE4jBkEEvEQRoeo73y50V6cVNgP3c5yzNg@mail.gmail.com> <1479738275.19792.24.camel@localhost.localdomain> <1ca8515f-abd2-7428-8baa-dca879833be3@interlog.com> <1479752642.19792.43.camel@localhost.localdomain> <20161122083759.xeifuex3xxfimuwz@linux-x5ow.site> <1479839407.28416.21.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx5-phx2.redhat.com ([209.132.183.37]:51419 "EHLO
        mx5-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933717AbcKVTo1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Nov 2016 14:44:27 -0500
In-Reply-To: <1479839407.28416.21.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: emilne@redhat.com
Cc: Johannes Thumshirn <jthumshirn@suse.de>, dgilbert@interlog.com, Eyal Ben David <bdeyal@gmail.com>, linux-scsi@vger.kernel.org



----- Original Message -----
> From: "Ewan D. Milne" <emilne@redhat.com>
> To: "Johannes Thumshirn" <jthumshirn@suse.de>
> Cc: dgilbert@interlog.com, "Eyal Ben David" <bdeyal@gmail.com>, "Laurence Oberman" <loberman@redhat.com>,
> linux-scsi@vger.kernel.org
> Sent: Tuesday, November 22, 2016 1:30:07 PM
> Subject: Re: SG does not ignore dxferp (direct io + mmap)
> 
> On Tue, 2016-11-22 at 09:37 +0100, Johannes Thumshirn wrote:
> > On Mon, Nov 21, 2016 at 01:24:02PM -0500, Ewan Milne wrote:
> > > On Mon, 2016-11-21 at 12:34 -0500, Douglas Gilbert wrote:
> > > > There was also this change which seems closer to the problem area:
> > > > 
> > > > commit 461c7fa126794157484dca48e88effa4963e3af3
> > > > Author: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> > > > Date:   Tue Feb 2 16:57:35 2016 -0800
> > > > 
> > > >      drivers/scsi/sg.c: mark VMA as VM_IO to prevent migration
> > > > ...
> > > > 
> > > > diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> > > > index 503ab8b..5e82067 100644
> > > > --- a/drivers/scsi/sg.c
> > > > +++ b/drivers/scsi/sg.c
> > > > @@ -1261,7 +1261,7 @@ sg_mmap(struct file *filp, struct vm_area_struct
> > > > *vma)
> > > >          }
> > > > 
> > > >          sfp->mmap_called = 1;
> > > > -       vma->vm_flags |= VM_DONTEXPAND | VM_DONTDUMP;
> > > > +       vma->vm_flags |= VM_IO | VM_DONTEXPAND | VM_DONTDUMP;
> > > >          vma->vm_private_data = sfp;
> > > >          vma->vm_ops = &sg_mmap_vm_ops;
> > > >          return 0;
> > > > 
> > > > Doug Gilbert
> > > > 
> > > 
> > > Neither this change nor "sg: fix dxferp in from_to case" appears to
> > > fix the issue when applied on top of 4.4.  Still looking...
> > 
> > This brings bad memories from commit 2d99b55d3 back to live, but this is
> > applied on all test kernels I have.
> > 
> > I too will run some bisection as well now that we have an easy reproducer
> > and
> > my timezone is somewhat ahead. Let's see if we can stretch the workday a
> > bit.
> 
> I see the behavior (zero byte) on the 4.4.34, 4.5.7, 4.6.7, and 4.7.10
> -stable kernels.  But not (of course) on 4.8.10 -stable.
> 
> It doesn't look like the sg driver, might be something in the mmap code?
> 
> -Ewan
> 
> 
> 
> 
> 
> 
I have just re-installed my system here with a much larger /boot partition in preparation for the bisect builds.
My prior /boot was too small to hold multiple upstream kernels during the bisect.
I expect to have time Friday to Monday to do the bisects and hopefully narrow it down to what mmap code changes affect us here.

I will narrow the bisect starting with and 4.7.10 bad and 4.8.10 good.
Thanks
Laurence

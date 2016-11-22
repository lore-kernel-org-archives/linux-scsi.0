From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: SG does not ignore dxferp (direct io + mmap)
Date: Tue, 22 Nov 2016 09:37:59 +0100
Message-ID: <20161122083759.xeifuex3xxfimuwz@linux-x5ow.site>
References: <CAPrnrPAanjswy-aeLF2s_JWCHCudXC6cwWmX8M7NuLMDSR95Mw@mail.gmail.com>
 <408136530.631221.1479686684102.JavaMail.zimbra@redhat.com>
 <CAPrnrPBOrkzz5f5rVE4jBkEEvEQRoeo73y50V6cVNgP3c5yzNg@mail.gmail.com>
 <1479738275.19792.24.camel@localhost.localdomain>
 <1ca8515f-abd2-7428-8baa-dca879833be3@interlog.com>
 <1479752642.19792.43.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55023 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755002AbcKVIiB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 22 Nov 2016 03:38:01 -0500
Content-Disposition: inline
In-Reply-To: <1479752642.19792.43.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ewan D. Milne" <emilne@redhat.com>
Cc: dgilbert@interlog.com, Eyal Ben David <bdeyal@gmail.com>, Laurence Oberman <loberman@redhat.com>, linux-scsi@vger.kernel.org

On Mon, Nov 21, 2016 at 01:24:02PM -0500, Ewan Milne wrote:
> On Mon, 2016-11-21 at 12:34 -0500, Douglas Gilbert wrote:
> > There was also this change which seems closer to the problem area:
> > 
> > commit 461c7fa126794157484dca48e88effa4963e3af3
> > Author: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> > Date:   Tue Feb 2 16:57:35 2016 -0800
> > 
> >      drivers/scsi/sg.c: mark VMA as VM_IO to prevent migration
> > ...
> > 
> > diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> > index 503ab8b..5e82067 100644
> > --- a/drivers/scsi/sg.c
> > +++ b/drivers/scsi/sg.c
> > @@ -1261,7 +1261,7 @@ sg_mmap(struct file *filp, struct vm_area_struct *vma)
> >          }
> > 
> >          sfp->mmap_called = 1;
> > -       vma->vm_flags |= VM_DONTEXPAND | VM_DONTDUMP;
> > +       vma->vm_flags |= VM_IO | VM_DONTEXPAND | VM_DONTDUMP;
> >          vma->vm_private_data = sfp;
> >          vma->vm_ops = &sg_mmap_vm_ops;
> >          return 0;
> > 
> > Doug Gilbert
> > 
> 
> Neither this change nor "sg: fix dxferp in from_to case" appears to
> fix the issue when applied on top of 4.4.  Still looking...

This brings bad memories from commit 2d99b55d3 back to live, but this is
applied on all test kernels I have.

I too will run some bisection as well now that we have an easy reproducer and
my timezone is somewhat ahead. Let's see if we can stretch the workday a bit.

Byte,
	Johannes

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850

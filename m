From: Laurence Oberman <loberman@redhat.com>
Subject: Re: SG does not ignore dxferp (direct io + mmap)
Date: Tue, 22 Nov 2016 10:31:23 -0500 (EST)
Message-ID: <858849309.1558836.1479828683078.JavaMail.zimbra@redhat.com>
References: <CAPrnrPAanjswy-aeLF2s_JWCHCudXC6cwWmX8M7NuLMDSR95Mw@mail.gmail.com> <408136530.631221.1479686684102.JavaMail.zimbra@redhat.com> <CAPrnrPBOrkzz5f5rVE4jBkEEvEQRoeo73y50V6cVNgP3c5yzNg@mail.gmail.com> <1479738275.19792.24.camel@localhost.localdomain> <1ca8515f-abd2-7428-8baa-dca879833be3@interlog.com> <1479752642.19792.43.camel@localhost.localdomain> <20161122083759.xeifuex3xxfimuwz@linux-x5ow.site> <CAPrnrPB1kJZkzbJNVrtKLp_w9Ts8jmOzQczYwANodV=HerCm=w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx6-phx2.redhat.com ([209.132.183.39]:48909 "EHLO
        mx6-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932355AbcKVPb3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Nov 2016 10:31:29 -0500
In-Reply-To: <CAPrnrPB1kJZkzbJNVrtKLp_w9Ts8jmOzQczYwANodV=HerCm=w@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eyal Ben David <bdeyal@gmail.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>, "Ewan D. Milne" <emilne@redhat.com>, dgilbert@interlog.com, linux-scsi@vger.kernel.org



----- Original Message -----
> From: "Eyal Ben David" <bdeyal@gmail.com>
> To: "Johannes Thumshirn" <jthumshirn@suse.de>
> Cc: "Ewan D. Milne" <emilne@redhat.com>, dgilbert@interlog.com, "Laurence Oberman" <loberman@redhat.com>,
> linux-scsi@vger.kernel.org
> Sent: Tuesday, November 22, 2016 8:48:06 AM
> Subject: Re: SG does not ignore dxferp (direct io + mmap)
> 
> Same problem on Fedora 23
> 
> $ uname -r
> 4.7.10-100.fc23.x86_64
> 
> $ sudo ./sg_mmap_read -d /dev/sg0 -l 0 | od -t x1
> 0000000 eb 63 90 10 8e d0 bc 00 b0 b8 00 00 8e d8 8e c0
> ...
> 
> $ sudo ./sg_mmap_read -d /dev/sg0 -l 0 -m | od -t x1
> 0000000 eb 63 90 10 8e d0 bc 00 b0 b8 00 00 8e d8 8e c0
> ...
> 
> $ sudo ./sg_mmap_read -d /dev/sg0 -l 0 -m -b | od -t x1
> 0000000 00 63 90 10 8e d0 bc 00 b0 b8 00 00 8e d8 8e c0
> ...
> 
> 2016-11-22 10:37 GMT+02:00 Johannes Thumshirn <jthumshirn@suse.de>:
> > On Mon, Nov 21, 2016 at 01:24:02PM -0500, Ewan Milne wrote:
> >> On Mon, 2016-11-21 at 12:34 -0500, Douglas Gilbert wrote:
> >> > There was also this change which seems closer to the problem area:
> >> >
> >> > commit 461c7fa126794157484dca48e88effa4963e3af3
> >> > Author: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> >> > Date:   Tue Feb 2 16:57:35 2016 -0800
> >> >
> >> >      drivers/scsi/sg.c: mark VMA as VM_IO to prevent migration
> >> > ...
> >> >
> >> > diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> >> > index 503ab8b..5e82067 100644
> >> > --- a/drivers/scsi/sg.c
> >> > +++ b/drivers/scsi/sg.c
> >> > @@ -1261,7 +1261,7 @@ sg_mmap(struct file *filp, struct vm_area_struct
> >> > *vma)
> >> >          }
> >> >
> >> >          sfp->mmap_called = 1;
> >> > -       vma->vm_flags |= VM_DONTEXPAND | VM_DONTDUMP;
> >> > +       vma->vm_flags |= VM_IO | VM_DONTEXPAND | VM_DONTDUMP;
> >> >          vma->vm_private_data = sfp;
> >> >          vma->vm_ops = &sg_mmap_vm_ops;
> >> >          return 0;
> >> >
> >> > Doug Gilbert
> >> >
> >>
> >> Neither this change nor "sg: fix dxferp in from_to case" appears to
> >> fix the issue when applied on top of 4.4.  Still looking...
> >
> > This brings bad memories from commit 2d99b55d3 back to live, but this is
> > applied on all test kernels I have.
> >
> > I too will run some bisection as well now that we have an easy reproducer
> > and
> > my timezone is somewhat ahead. Let's see if we can stretch the workday a
> > bit.
> >
> > Byte,
> >         Johannes
> >
> > --
> > Johannes Thumshirn                                          Storage
> > jthumshirn@suse.de                                +49 911 74053 689
> > SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
> > GF: Felix Imendörffer, Jane Smithard, Graham Norton
> > HRB 21284 (AG Nürnberg)
> > Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Its not failing on 4.8-rc2 so working on tracing rgw ioctl SG_DXFER_FROM_DEV as well and will bisect this weekend and/or add some kernel probes.
Just need to get some time.
Johannes or Ewan may beat me to it.

Working RHEL7 

open("/dev/sg1", O_RDWR)                = 3
mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_SHARED, 3, 0) = 0x7f5645d4a000
ioctl(3, SG_IO, {'S', SG_DXFER_FROM_DEV, cmd[16]=[88, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 01, 00, 00], mx_sb_len=96, iovec_count=0, dxfer_len=512, timeout=30000, flags=0x4, data[512]=[0x7f5645d4a000], status=00, masked_status=00, sb[0]=[], host_status=0, driver_status=0, resid=0, duration=1, info=0}) = 0
write(1, 0x7f5645d4a000, 640000000 63eb 1090 d08e 00bc b8b0 0000 d88e c08e
)            = 64
0000010 befb 7c00 00bf b906 0200 a4f3 21ea 0006
0000020 be00 07be 0438 0b75 c683 8110 fefe 7507
0000030 ebf3 b416 b002 bb01 7c00 80b2 748a 8b01
munmap(0x7f5645d4a000, 8192)            = 0
close(3)                                = 0
exit_group(0)                           = ?
+++ exited with 0 +++
0000040

Failing 4.4

open("/dev/sg1", O_RDWR)                = 3
mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_SHARED, 3, 0) = 0x7f2951de3000
ioctl(3, SG_IO, {'S', SG_DXFER_FROM_DEV, cmd[16]=[88, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 01, 00, 00], mx_sb_len=96, iovec_count=0, dxfer_len=512, timeout=30000, flags=0x4, data[512]=[0x7f2951de3000], status=00, masked_status=00, sb[0]=[], host_status=0, driver_status=0, resid=0, duration=0, info=0}) = 0
write(1, 0x7f2951de3000, 64)            = 64
munmap(0x7f2951de3000, 81920000000 6300 1090 d08e 00bc b8b0 0000 d88e c08e
0000010 befb 7c00 00bf b906 0200 a4f3 21ea 0006
)            = 0
0000020 be00 07be 0438 0b75 c683 8110 fefe 7507
0000030 ebf3 b416 b002 bb01 7c00 80b2 748a 8b01
close(3)                                = 0
exit_group(0)                           = ?
+++ exited with 0 +++
0000040


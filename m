From: Eyal Ben David <bdeyal@gmail.com>
Subject: Re: SG does not ignore dxferp (direct io + mmap)
Date: Tue, 22 Nov 2016 15:48:06 +0200
Message-ID: <CAPrnrPB1kJZkzbJNVrtKLp_w9Ts8jmOzQczYwANodV=HerCm=w@mail.gmail.com>
References: <CAPrnrPAanjswy-aeLF2s_JWCHCudXC6cwWmX8M7NuLMDSR95Mw@mail.gmail.com>
 <408136530.631221.1479686684102.JavaMail.zimbra@redhat.com>
 <CAPrnrPBOrkzz5f5rVE4jBkEEvEQRoeo73y50V6cVNgP3c5yzNg@mail.gmail.com>
 <1479738275.19792.24.camel@localhost.localdomain> <1ca8515f-abd2-7428-8baa-dca879833be3@interlog.com>
 <1479752642.19792.43.camel@localhost.localdomain> <20161122083759.xeifuex3xxfimuwz@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:34044 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755681AbcKVNsH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Nov 2016 08:48:07 -0500
Received: by mail-io0-f193.google.com with SMTP id r94so478966ioe.1
        for <linux-scsi@vger.kernel.org>; Tue, 22 Nov 2016 05:48:07 -0800 (PST)
In-Reply-To: <20161122083759.xeifuex3xxfimuwz@linux-x5ow.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "Ewan D. Milne" <emilne@redhat.com>, dgilbert@interlog.com, Laurence Oberman <loberman@redhat.com>, linux-scsi@vger.kernel.org

Same problem on Fedora 23

$ uname -r
4.7.10-100.fc23.x86_64

$ sudo ./sg_mmap_read -d /dev/sg0 -l 0 | od -t x1
0000000 eb 63 90 10 8e d0 bc 00 b0 b8 00 00 8e d8 8e c0
...

$ sudo ./sg_mmap_read -d /dev/sg0 -l 0 -m | od -t x1
0000000 eb 63 90 10 8e d0 bc 00 b0 b8 00 00 8e d8 8e c0
...

$ sudo ./sg_mmap_read -d /dev/sg0 -l 0 -m -b | od -t x1
0000000 00 63 90 10 8e d0 bc 00 b0 b8 00 00 8e d8 8e c0
...

2016-11-22 10:37 GMT+02:00 Johannes Thumshirn <jthumshirn@suse.de>:
> On Mon, Nov 21, 2016 at 01:24:02PM -0500, Ewan Milne wrote:
>> On Mon, 2016-11-21 at 12:34 -0500, Douglas Gilbert wrote:
>> > There was also this change which seems closer to the problem area:
>> >
>> > commit 461c7fa126794157484dca48e88effa4963e3af3
>> > Author: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
>> > Date:   Tue Feb 2 16:57:35 2016 -0800
>> >
>> >      drivers/scsi/sg.c: mark VMA as VM_IO to prevent migration
>> > ...
>> >
>> > diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
>> > index 503ab8b..5e82067 100644
>> > --- a/drivers/scsi/sg.c
>> > +++ b/drivers/scsi/sg.c
>> > @@ -1261,7 +1261,7 @@ sg_mmap(struct file *filp, struct vm_area_struct=
 *vma)
>> >          }
>> >
>> >          sfp->mmap_called =3D 1;
>> > -       vma->vm_flags |=3D VM_DONTEXPAND | VM_DONTDUMP;
>> > +       vma->vm_flags |=3D VM_IO | VM_DONTEXPAND | VM_DONTDUMP;
>> >          vma->vm_private_data =3D sfp;
>> >          vma->vm_ops =3D &sg_mmap_vm_ops;
>> >          return 0;
>> >
>> > Doug Gilbert
>> >
>>
>> Neither this change nor "sg: fix dxferp in from_to case" appears to
>> fix the issue when applied on top of 4.4.  Still looking...
>
> This brings bad memories from commit 2d99b55d3 back to live, but this is
> applied on all test kernels I have.
>
> I too will run some bisection as well now that we have an easy reproducer=
 and
> my timezone is somewhat ahead. Let's see if we can stretch the workday a =
bit.
>
> Byte,
>         Johannes
>
> --
> Johannes Thumshirn                                          Storage
> jthumshirn@suse.de                                +49 911 74053 689
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
> GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=C3=BCrnberg)
> Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850

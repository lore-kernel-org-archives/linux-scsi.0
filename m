From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: SG does not ignore dxferp (direct io + mmap)
Date: Mon, 21 Nov 2016 12:34:11 -0500
Message-ID: <1ca8515f-abd2-7428-8baa-dca879833be3@interlog.com>
References: <CAPrnrPAanjswy-aeLF2s_JWCHCudXC6cwWmX8M7NuLMDSR95Mw@mail.gmail.com>
 <408136530.631221.1479686684102.JavaMail.zimbra@redhat.com>
 <CAPrnrPBOrkzz5f5rVE4jBkEEvEQRoeo73y50V6cVNgP3c5yzNg@mail.gmail.com>
 <1479738275.19792.24.camel@localhost.localdomain>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:52037 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752774AbcKURlC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 21 Nov 2016 12:41:02 -0500
In-Reply-To: <1479738275.19792.24.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: emilne@redhat.com, Eyal Ben David <bdeyal@gmail.com>
Cc: Laurence Oberman <loberman@redhat.com>, linux-scsi@vger.kernel.org

On 2016-11-21 09:24 AM, Ewan D. Milne wrote:
> On Mon, 2016-11-21 at 11:23 +0200, Eyal Ben David wrote:
>> Hi,
>>
>> The utility I mentioned is just a small program that I wrote to learn
>> more about the problem.
>>
>> It is a very simple read16 with options for mmap and dxferp as null or other.
>>
>> Here is the source code:
>>
>> == cut here ==
>>
>
> <snip>
>
>> 2016-11-21 2:04 GMT+02:00 Laurence Oberman <loberman@redhat.com>:
>>>
>>>
>>> ----- Original Message -----
>>>> From: "Eyal Ben David" <bdeyal@gmail.com>
>>>> To: linux-scsi@vger.kernel.org
>>>> Sent: Sunday, November 20, 2016 11:02:49 AM
>>>> Subject: SG does not ignore dxferp (direct io + mmap)
>>>>
>>>> Hi all,
>>>>
>>>> We have some IO utility that perform the IOs using sg and direct io with
>>>> mmap.
>>>> Our current systems are Ubuntu 14.04, RHEL 6,7
>>>> The IO utility always set dxferp to either the address or mmap of
>>>> other allocation (valloc)
>>>> Setting dxferp was harmless since SG is supposed to ignore the address
>>>> if mmap IO is selected.
>>>> When porting to Ubuntu 16.04, we had a corruption problem - first byte
>>>> of a read task is always 0.
>>>> When setting dxferp as NULL the corruption does not occur any more.
>>>> This is a regression and not according to SCSI generic documentation.
>>>>
>>>> I wrote a small program that shows the change:
>>>>
>>>> Read indirect (no mmap), lba=0:
>>>> =======================
>>>> $ ./sg_mmap_read -d /dev/sg0 -l 0
>>>> 0000000 eb 63 90 10 8e d0 bc 00 b0 b8 00 00 8e d8 8e c0
>>>>
>>>> Read with mmap, lba=0, dxferp=NULL:
>>>> ============================
>>>> $ ./sg_mmap_read -d /dev/sg0 -l 0 -m
>>>> 0000000 eb 63 90 10 8e d0 bc 00 b0 b8 00 00 8e d8 8e c0
>>>>
>>>> Read with mmap, lba=0, dxferp=address from mmap
>>>> ======================================
>>>> $ ./sg_mmap_read -d /dev/sg0 -l 0 -m -b
>>>> 0000000 00 63 90 10 8e d0 bc 00 b0 b8 00 00 8e d8 8e c0
>>>>
>>>> On the older systems all results are the same.
>>>>
>>>> Thanks for any answer!
>>>> --
>
> For what it's worth, I ran this on a 4.8 kernel and did not see your
> problem.  I couldn't reproduce it on a RHEL kernel either.
>
> # ./sg_mmap_read -d /dev/sg0 -l 0 | od -x
> 0000000 63eb 1090 d08e 00bc b8b0 0000 d88e c08e
> 0000020 befb 7c00 00bf b906 0200 a4f3 21ea 0006
> 0000040 be00 07be 0438 0b75 c683 8110 fefe 7507
> 0000060 ebf3 b416 b002 bb01 7c00 80b2 748a 8b01
> 0000100
> # ./sg_mmap_read -d /dev/sg0 -l 0 -m | od -x
> 0000000 63eb 1090 d08e 00bc b8b0 0000 d88e c08e
> 0000020 befb 7c00 00bf b906 0200 a4f3 21ea 0006
> 0000040 be00 07be 0438 0b75 c683 8110 fefe 7507
> 0000060 ebf3 b416 b002 bb01 7c00 80b2 748a 8b01
> 0000100
> # ./sg_mmap_read -d /dev/sg0 -l 0 -m -b | od -x
> 0000000 63eb 1090 d08e 00bc b8b0 0000 d88e c08e
> 0000020 befb 7c00 00bf b906 0200 a4f3 21ea 0006
> 0000040 be00 07be 0438 0b75 c683 8110 fefe 7507
> 0000060 ebf3 b416 b002 bb01 7c00 80b2 748a 8b01
> 0000100
>
> The only recent relevant change I see is:
>
> commit 5ecee0a3ee8d74b6950cb41e8989b0c2174568d4
> Author: Douglas Gilbert <dgilbert@interlog.com>
> Date:   Thu Mar 3 00:31:29 2016 -0500
>
>     sg: fix dxferp in from_to case
>
> However the kernel I used has that change, and the
> change purposely does not clear hp->dxferp if
> SG_DXFER_TO_FROM_DEV is specified, which your program
> does not, and the behavior is correct regardless.
>
> Can you modify your program to output the userspace
> address of your buffer?

There was also this change which seems closer to the problem area:

commit 461c7fa126794157484dca48e88effa4963e3af3
Author: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Date:   Tue Feb 2 16:57:35 2016 -0800

     drivers/scsi/sg.c: mark VMA as VM_IO to prevent migration
...

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 503ab8b..5e82067 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1261,7 +1261,7 @@ sg_mmap(struct file *filp, struct vm_area_struct *vma)
         }

         sfp->mmap_called = 1;
-       vma->vm_flags |= VM_DONTEXPAND | VM_DONTDUMP;
+       vma->vm_flags |= VM_IO | VM_DONTEXPAND | VM_DONTDUMP;
         vma->vm_private_data = sfp;
         vma->vm_ops = &sg_mmap_vm_ops;
         return 0;

Doug Gilbert


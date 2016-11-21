From: "Ewan D. Milne" <emilne@redhat.com>
Subject: Re: SG does not ignore dxferp (direct io + mmap)
Date: Mon, 21 Nov 2016 13:24:02 -0500
Message-ID: <1479752642.19792.43.camel@localhost.localdomain>
References: <CAPrnrPAanjswy-aeLF2s_JWCHCudXC6cwWmX8M7NuLMDSR95Mw@mail.gmail.com>
         <408136530.631221.1479686684102.JavaMail.zimbra@redhat.com>
         <CAPrnrPBOrkzz5f5rVE4jBkEEvEQRoeo73y50V6cVNgP3c5yzNg@mail.gmail.com>
         <1479738275.19792.24.camel@localhost.localdomain>
         <1ca8515f-abd2-7428-8baa-dca879833be3@interlog.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40658 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753990AbcKUSYE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 21 Nov 2016 13:24:04 -0500
In-Reply-To: <1ca8515f-abd2-7428-8baa-dca879833be3@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: Eyal Ben David <bdeyal@gmail.com>, Laurence Oberman <loberman@redhat.com>, linux-scsi@vger.kernel.org

On Mon, 2016-11-21 at 12:34 -0500, Douglas Gilbert wrote:
> There was also this change which seems closer to the problem area:
> 
> commit 461c7fa126794157484dca48e88effa4963e3af3
> Author: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Date:   Tue Feb 2 16:57:35 2016 -0800
> 
>      drivers/scsi/sg.c: mark VMA as VM_IO to prevent migration
> ...
> 
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index 503ab8b..5e82067 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -1261,7 +1261,7 @@ sg_mmap(struct file *filp, struct vm_area_struct *vma)
>          }
> 
>          sfp->mmap_called = 1;
> -       vma->vm_flags |= VM_DONTEXPAND | VM_DONTDUMP;
> +       vma->vm_flags |= VM_IO | VM_DONTEXPAND | VM_DONTDUMP;
>          vma->vm_private_data = sfp;
>          vma->vm_ops = &sg_mmap_vm_ops;
>          return 0;
> 
> Doug Gilbert
> 

Neither this change nor "sg: fix dxferp in from_to case" appears to
fix the issue when applied on top of 4.4.  Still looking...

-Ewan


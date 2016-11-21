From: Laurence Oberman <loberman@redhat.com>
Subject: Re: SG does not ignore dxferp (direct io + mmap)
Date: Sun, 20 Nov 2016 19:04:44 -0500 (EST)
Message-ID: <408136530.631221.1479686684102.JavaMail.zimbra@redhat.com>
References: <CAPrnrPAanjswy-aeLF2s_JWCHCudXC6cwWmX8M7NuLMDSR95Mw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx5-phx2.redhat.com ([209.132.183.37]:52854 "EHLO
        mx5-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752029AbcKUAEq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 20 Nov 2016 19:04:46 -0500
In-Reply-To: <CAPrnrPAanjswy-aeLF2s_JWCHCudXC6cwWmX8M7NuLMDSR95Mw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eyal Ben David <bdeyal@gmail.com>
Cc: linux-scsi@vger.kernel.org



----- Original Message -----
> From: "Eyal Ben David" <bdeyal@gmail.com>
> To: linux-scsi@vger.kernel.org
> Sent: Sunday, November 20, 2016 11:02:49 AM
> Subject: SG does not ignore dxferp (direct io + mmap)
> 
> Hi all,
> 
> We have some IO utility that perform the IOs using sg and direct io with
> mmap.
> Our current systems are Ubuntu 14.04, RHEL 6,7
> The IO utility always set dxferp to either the address or mmap of
> other allocation (valloc)
> Setting dxferp was harmless since SG is supposed to ignore the address
> if mmap IO is selected.
> When porting to Ubuntu 16.04, we had a corruption problem - first byte
> of a read task is always 0.
> When setting dxferp as NULL the corruption does not occur any more.
> This is a regression and not according to SCSI generic documentation.
> 
> I wrote a small program that shows the change:
> 
> Read indirect (no mmap), lba=0:
> =======================
> $ ./sg_mmap_read -d /dev/sg0 -l 0
> 0000000 eb 63 90 10 8e d0 bc 00 b0 b8 00 00 8e d8 8e c0
> 
> Read with mmap, lba=0, dxferp=NULL:
> ============================
> $ ./sg_mmap_read -d /dev/sg0 -l 0 -m
> 0000000 eb 63 90 10 8e d0 bc 00 b0 b8 00 00 8e d8 8e c0
> 
> Read with mmap, lba=0, dxferp=address from mmap
> ======================================
> $ ./sg_mmap_read -d /dev/sg0 -l 0 -m -b
> 0000000 00 63 90 10 8e d0 bc 00 b0 b8 00 00 8e d8 8e c0
> 
> On the older systems all results are the same.
> 
> Thanks for any answer!
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
Hello

Given that we cannot see what your utility (sg_mmap_read) is doing, can we get the source for that or an strace of your test here.
I am sure Doug will then be able to help you.

Thanks
Laurence

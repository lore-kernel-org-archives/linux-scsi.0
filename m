From: "Fajun Chen" <fajunchen@gmail.com>
Subject: Re: Bugs on Linux 2.6.18-rc2 sg code?
Date: Mon, 28 Aug 2006 15:12:42 -0600
Message-ID: <8202f4270608281412s2da23a52jfa0d2c4b73099587@mail.gmail.com>
References: <8202f4270608101843r7df002d2l40e03eca3271b050@mail.gmail.com>
	 <44E6388D.1000206@torque.net> <44E68F76.4010702@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nz-out-0102.google.com ([64.233.162.197]:10111 "EHLO
	nz-out-0102.google.com") by vger.kernel.org with ESMTP
	id S932129AbWH1VMn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Aug 2006 17:12:43 -0400
Received: by nz-out-0102.google.com with SMTP id n1so1119514nzf
        for <linux-scsi@vger.kernel.org>; Mon, 28 Aug 2006 14:12:42 -0700 (PDT)
In-Reply-To: <44E68F76.4010702@torque.net>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org

Hi Doug,

Forgot to report this. I've tested your patch and it works.

Thanks,
Fajun

On 8/18/06, Douglas Gilbert <dougg@torque.net> wrote:
> Douglas Gilbert wrote:
> > Fajun Chen wrote:
> >> Hi Folks,
> >>
> >> I use ATA pass through via sg ioctl interface for data read/write.
> >> Linux 2.6.18-rc2 patched with Jeff Garzik's libata git patch was
> >> running on ARM IOP80321 board. The HBA Sil3124 was used.
> >>
> >> Two problems were observed:
> >> 1. sg mmap bug?
> >>    My test program could not write data correctly to the mmapped
> >> buffer in the user space.      The program did a read immediately
> >> after a write and the data mismatches.  Swapped the sg_vma_nopage()
> >> function with the one in 2.6.15.4 release fixed the problem. So this
> >> appears to be a wrong change to the sg mmap code in 2.6.18-rc2
> >> release.
> >
> > Thanks for the report. I can confirm that mmap-ed IO
> > in the sg driver is broken. Simply reading 16 blocks
> > from some arbitrary offset with sg_dd and sgm_dd
> > and comparing the fetched data shows mismatches starting
> > above the first page (i.e. above byte offset 4096 on
> > i386).
> >
> > Your point about the change to sg_vma_nopage() between
> > lk 2.6.15 and lk 2.6.16 also seems to be correct.
> > The most indented part of that function has been
> > changed from incrementing the change count on the
> > reported page (as indicated by 'offset') in a
> > compound page allocation to ignoring the 'offset'
> > and incrementing the page count on the first page
> > in a compound page allocation.
>
> Fajun,
> Could you please try the patch below and report if it fixes
> your sg mmap problem. The patch is against lk 2.6.18-rc4
> and I assume it will apply against "rc2" as well.
> The patch re-instates the former logic and fixes the
> problem in my tests.
>
> Doug Gilbert
>
>
>

From: Laurence Oberman <loberman@redhat.com>
Subject: Re: SG does not ignore dxferp (direct io + mmap)
Date: Fri, 25 Nov 2016 13:01:10 -0500 (EST)
Message-ID: <210045942.93550.1480096870944.JavaMail.zimbra@redhat.com>
References: <CAPrnrPAanjswy-aeLF2s_JWCHCudXC6cwWmX8M7NuLMDSR95Mw@mail.gmail.com> <20161122083759.xeifuex3xxfimuwz@linux-x5ow.site> <1479839407.28416.21.camel@localhost.localdomain> <CAPrnrPAFSUL4C+N09-BUUm+7e84oxasaHb7-Ej-+8FuYOddRgA@mail.gmail.com> <2146476957.2165908.1479927335303.JavaMail.zimbra@redhat.com> <1479932524.28416.43.camel@localhost.localdomain> <20161125080758.5bh5jkcgvhw3xuvb@linux-x5ow.site> <1194718949.74785.1480096576577.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx3-phx2.redhat.com ([209.132.183.24]:53330 "EHLO
        mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755500AbcKYSBX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Nov 2016 13:01:23 -0500
In-Reply-To: <1194718949.74785.1480096576577.JavaMail.zimbra@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ewan Milne <emilne@redhat.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>, Eyal Ben David <bdeyal@gmail.com>, dgilbert@interlog.com, linux-scsi@vger.kernel.org



----- Original Message -----
> From: "Ewan Milne" <emilne@redhat.com>
> To: "Johannes Thumshirn" <jthumshirn@suse.de>
> Cc: "Laurence Oberman" <loberman@redhat.com>, "Eyal Ben David" <bdeyal@gmail.com>, dgilbert@interlog.com,
> linux-scsi@vger.kernel.org
> Sent: Friday, November 25, 2016 12:56:16 PM
> Subject: Re: SG does not ignore dxferp (direct io + mmap)
> 
> >> ---
> >> 
> >> In other words, this commit made the bad behavior go away in 4.8.
> >> Need to look at this in more detail, it doesn't appear as if this patch
> >> was intended to fix such a problem.
> >> 
> >> -Ewan
> >
> >Are you sure it did? I can repropduce copy_to_user() errors with 4.8 as
> >well.
> >Using the very same reproducer. On 4.8 it's just harder to trigger and
> >doesn't trigger on AHCI as fas as I can telli (maybe I just haven't hit
> >it hard enough). I can trigger it on QEMUs SCSI CDROM emulation and hpsa
> >though. I cannot however trigger this with a minimal config inside an
> >initrd.
> 
> It did for Eyal's supplied test case on my machine, but that was not an
> exhaustive test, and I am a little suspicious that the behavior change was
> due to a side-effect of the patch rather than actually fixing something.
> 
> I think what we need to understand is what caused the regression in the
> first place, I probably should have been bisecting the original failure
> rather than trying to find where it started working.
> 
> I was running against an internal (physical) drive.
> 
> -Ewan
> 

My 100000 loop was against an HPSA target and passed all tests.
Again, all I did was patch the 4.7.9 with the 2 line changes, the rest of the patch was line breaks.

I guess we need to understand when it first broke and what caused that, versus what seems to correct it.
Thanks
Laurence

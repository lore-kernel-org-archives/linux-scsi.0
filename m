From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: scsi: sg: assorted memory corruptions
Date: Sat, 10 Feb 2018 11:13:02 -0800
Message-ID: <20180210191302.GA23737@zzz.localdomain>
References: <CACT4Y+b0pizvOAxtWQ-TGCRAYvHXdv79BAEaXh50W6vF8gBvkQ@mail.gmail.com>
 <1516638634.2545.0.camel@wdc.com>
 <097921fa-52c5-8b2b-f564-4b24d9720478@interlog.com>
 <CACT4Y+aEx0ie3qjx6afCYV2vN7gYii0uupKWPXaNTnWUmhdHQw@mail.gmail.com>
 <c0a7ec39-e357-9db6-cf12-ff9c46259f26@interlog.com>
 <CACT4Y+bObXrFiB0Qn+nfkD8DZRiVck1GJ5U9UeQz+-y85gh70Q@mail.gmail.com>
 <1517501859.3417.67.camel@codethink.co.uk>
 <CACT4Y+ZEJ9_no0uQSXO66iyyUeJLn_zbPBEey62YkuzOEUMP2w@mail.gmail.com>
 <20180204090710.GA607@zzz.localdomain>
 <CACT4Y+av=1SmyN8m+F26Xs3DLmd7zLgTB6OWX0MC3gVkiqRpNg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f41.google.com ([74.125.83.41]:39250 "EHLO
        mail-pg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751116AbeBJTNH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 10 Feb 2018 14:13:07 -0500
Content-Disposition: inline
In-Reply-To: <CACT4Y+av=1SmyN8m+F26Xs3DLmd7zLgTB6OWX0MC3gVkiqRpNg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dmitry Vyukov <dvyukov@google.com>
Cc: Ben Hutchings <ben.hutchings@codethink.co.uk>, Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org, Doug Gilbert <dgilbert@interlog.com>, Bart Van Assche <Bart.VanAssche@wdc.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "syzkaller@googlegroups.com" <syzkaller@googlegroups.com>

On Sun, Feb 04, 2018 at 12:10:58PM +0100, Dmitry Vyukov wrote:
> >
> > To get memory corruption it's actually sufficient just to submit "1-byte" reads;
> > there's no need for the SG_NEXT_CMD_LEN ioctl or anything:
> >
> >         #include <fcntl.h>
> >         #include <unistd.h>
> >
> >         int main()
> >         {
> >                 int fd = open("/dev/sg0", O_RDWR);
> >                 char buf[43] = { [36] = 0x08 /* READ_6 */ };
> >
> >                 for (;;)
> >                         write(fd, buf, sizeof(buf));
> >         }
> >
> > (where /dev/sg0 is the default QEMU disk type, "82371SB PIIX3 IDE")
> >
> > The SCSI command descriptor block is the 6 bytes at indices 36-41, so index 42
> > is the only data byte.
> >
> > Also this is a different bug from the crash in ata_bmdma_fill_sg() which is
> > fixed by "libata: fix length validation of ATAPI-relayed SCSI commands".
> >
> > I'm guessing the driver is DMA'ing to somewhere it shouldn't be...
> 
> It would be good to add KASAN checks to the DMA code that issues
> transfers. This is another case where a silent memory corruption
> causes dozens of assorted crashes all over the kernel. If we add
> checks, KASAN would pinpoint the exact stack that issues the bad
> command. This may be the simplest way to debug this bug as well. I've
> filed https://bugzilla.kernel.org/show_bug.cgi?id=198661 for this.

It seems the problem is related to the fact that in the PRD (Physical Region
Descriptor) list for the DMA transfer for "BMDMA" ATA disks, the disk (emulated
in QEMU here: https://github.com/qemu/qemu/blob/master/hw/ide/pci.c#L89) ignores
the low bit in the lengths, causing a length of 1 (byte) to be interpreted as 0.
But, at the same time there is also a special case where a length of 0 is
interpreted as 65536 bytes.

So the disk will DMA up to 65536 bytes into a 1-byte buffer, causing massive
memory corruption.

I'm not sure what the best fix is, but probably it needs to be required that the
lengths in the sglist have the alignment needed for the disk.

KASAN would not have helped here unfortunately.  Even if there were KASAN checks
when mapping the sglist for DMA or when filling in the PRD list, the kernel
would not have known that the disk would actually interpret "1" as "65536".

- Eric

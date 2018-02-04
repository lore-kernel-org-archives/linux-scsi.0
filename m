From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: scsi: sg: assorted memory corruptions
Date: Sun, 4 Feb 2018 12:10:58 +0100
Message-ID: <CACT4Y+av=1SmyN8m+F26Xs3DLmd7zLgTB6OWX0MC3gVkiqRpNg@mail.gmail.com>
References: <CACT4Y+b0pizvOAxtWQ-TGCRAYvHXdv79BAEaXh50W6vF8gBvkQ@mail.gmail.com>
 <1516638634.2545.0.camel@wdc.com> <097921fa-52c5-8b2b-f564-4b24d9720478@interlog.com>
 <CACT4Y+aEx0ie3qjx6afCYV2vN7gYii0uupKWPXaNTnWUmhdHQw@mail.gmail.com>
 <c0a7ec39-e357-9db6-cf12-ff9c46259f26@interlog.com> <CACT4Y+bObXrFiB0Qn+nfkD8DZRiVck1GJ5U9UeQz+-y85gh70Q@mail.gmail.com>
 <1517501859.3417.67.camel@codethink.co.uk> <CACT4Y+ZEJ9_no0uQSXO66iyyUeJLn_zbPBEey62YkuzOEUMP2w@mail.gmail.com>
 <20180204090710.GA607@zzz.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20180204090710.GA607@zzz.localdomain>
Sender: linux-ide-owner@vger.kernel.org
To: Eric Biggers <ebiggers3@gmail.com>
Cc: Ben Hutchings <ben.hutchings@codethink.co.uk>, Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org, Doug Gilbert <dgilbert@interlog.com>, Bart Van Assche <Bart.VanAssche@wdc.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "syzkaller@googlegroups.com" <syzkaller@googlegroups.com>
List-Id: linux-scsi@vger.kernel.org

On Sun, Feb 4, 2018 at 10:07 AM, Eric Biggers <ebiggers3@gmail.com> wrote:
> On Thu, Feb 01, 2018 at 05:21:12PM +0100, 'Dmitry Vyukov' via syzkaller wrote:
>> On Thu, Feb 1, 2018 at 5:17 PM, Ben Hutchings
>> <ben.hutchings@codethink.co.uk> wrote:
>> > On Thu, 2018-02-01 at 08:04 +0100, Dmitry Vyukov wrote:
>> >> On Thu, Feb 1, 2018 at 7:03 AM, Douglas Gilbert <dgilbert@interlog.com> wrote:
>> >> > On 2018-01-30 07:22 AM, Dmitry Vyukov wrote:
>> > [...]
>> >> > > [1:0:0:0]    cd/dvd  QEMU     QEMU DVD-ROM     2.0.  /dev/sr0   /dev/sg1
>> >> > >
>> >> > > # readlink /sys/class/scsi_generic/sg0
>> >> > >
>> >> > > ../../devices/pci0000:00/0000:00:01.1/ata1/host0/target0:0:0/0:0:0:0/scsi_generic/sg0
>> >> > >
>> >> > > # cat /sys/class/scsi_generic/sg0/device/vendor
>> >> > > ATA
>> >> >
>> >> >
>> >> > ^^^^^
>> >> > That subsystem is the culprit IMO, most likely libata.
>> >> >
>> >> > Until you can show this test failing on something other than an
>> >> > ATA disk, then I will treat this issue as closed.
>> >>
>> >> Hi Doug,
>> >>
>> >> Why is bug in ATA not a bug? Is it long unused by everybody? I've got
>> >> it by running qemu with default flags...
>> >
>> > If the bug is in libata then it's not on Doug to fix it since he's only
>> > maintaining sg.
>>
>>
>> Then I think we need to CC ata maintainers rather than treat it as closed.
>> +Tejun, linux-ide@, you can see full thread here:
>> https://groups.google.com/forum/#!topic/syzkaller/9RNr9Gu0MyY
>>
>
> To get memory corruption it's actually sufficient just to submit "1-byte" reads;
> there's no need for the SG_NEXT_CMD_LEN ioctl or anything:
>
>         #include <fcntl.h>
>         #include <unistd.h>
>
>         int main()
>         {
>                 int fd = open("/dev/sg0", O_RDWR);
>                 char buf[43] = { [36] = 0x08 /* READ_6 */ };
>
>                 for (;;)
>                         write(fd, buf, sizeof(buf));
>         }
>
> (where /dev/sg0 is the default QEMU disk type, "82371SB PIIX3 IDE")
>
> The SCSI command descriptor block is the 6 bytes at indices 36-41, so index 42
> is the only data byte.
>
> Also this is a different bug from the crash in ata_bmdma_fill_sg() which is
> fixed by "libata: fix length validation of ATAPI-relayed SCSI commands".
>
> I'm guessing the driver is DMA'ing to somewhere it shouldn't be...

It would be good to add KASAN checks to the DMA code that issues
transfers. This is another case where a silent memory corruption
causes dozens of assorted crashes all over the kernel. If we add
checks, KASAN would pinpoint the exact stack that issues the bad
command. This may be the simplest way to debug this bug as well. I've
filed https://bugzilla.kernel.org/show_bug.cgi?id=198661 for this.

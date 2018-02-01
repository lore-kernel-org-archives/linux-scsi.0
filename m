From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: scsi: sg: assorted memory corruptions
Date: Thu, 1 Feb 2018 17:21:12 +0100
Message-ID: <CACT4Y+ZEJ9_no0uQSXO66iyyUeJLn_zbPBEey62YkuzOEUMP2w@mail.gmail.com>
References: <CACT4Y+b0pizvOAxtWQ-TGCRAYvHXdv79BAEaXh50W6vF8gBvkQ@mail.gmail.com>
 <1516638634.2545.0.camel@wdc.com> <097921fa-52c5-8b2b-f564-4b24d9720478@interlog.com>
 <CACT4Y+aEx0ie3qjx6afCYV2vN7gYii0uupKWPXaNTnWUmhdHQw@mail.gmail.com>
 <c0a7ec39-e357-9db6-cf12-ff9c46259f26@interlog.com> <CACT4Y+bObXrFiB0Qn+nfkD8DZRiVck1GJ5U9UeQz+-y85gh70Q@mail.gmail.com>
 <1517501859.3417.67.camel@codethink.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1517501859.3417.67.camel@codethink.co.uk>
Sender: linux-ide-owner@vger.kernel.org
To: Ben Hutchings <ben.hutchings@codethink.co.uk>, Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org
Cc: Doug Gilbert <dgilbert@interlog.com>, Bart Van Assche <Bart.VanAssche@wdc.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "syzkaller@googlegroups.com" <syzkaller@googlegroups.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Feb 1, 2018 at 5:17 PM, Ben Hutchings
<ben.hutchings@codethink.co.uk> wrote:
> On Thu, 2018-02-01 at 08:04 +0100, Dmitry Vyukov wrote:
>> On Thu, Feb 1, 2018 at 7:03 AM, Douglas Gilbert <dgilbert@interlog.com> wrote:
>> > On 2018-01-30 07:22 AM, Dmitry Vyukov wrote:
> [...]
>> > > [1:0:0:0]    cd/dvd  QEMU     QEMU DVD-ROM     2.0.  /dev/sr0   /dev/sg1
>> > >
>> > > # readlink /sys/class/scsi_generic/sg0
>> > >
>> > > ../../devices/pci0000:00/0000:00:01.1/ata1/host0/target0:0:0/0:0:0:0/scsi_generic/sg0
>> > >
>> > > # cat /sys/class/scsi_generic/sg0/device/vendor
>> > > ATA
>> >
>> >
>> > ^^^^^
>> > That subsystem is the culprit IMO, most likely libata.
>> >
>> > Until you can show this test failing on something other than an
>> > ATA disk, then I will treat this issue as closed.
>>
>> Hi Doug,
>>
>> Why is bug in ATA not a bug? Is it long unused by everybody? I've got
>> it by running qemu with default flags...
>
> If the bug is in libata then it's not on Doug to fix it since he's only
> maintaining sg.


Then I think we need to CC ata maintainers rather than treat it as closed.
+Tejun, linux-ide@, you can see full thread here:
https://groups.google.com/forum/#!topic/syzkaller/9RNr9Gu0MyY

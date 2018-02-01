From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: scsi: sg: assorted memory corruptions
Date: Thu, 1 Feb 2018 08:04:52 +0100
Message-ID: <CACT4Y+bObXrFiB0Qn+nfkD8DZRiVck1GJ5U9UeQz+-y85gh70Q@mail.gmail.com>
References: <CACT4Y+b0pizvOAxtWQ-TGCRAYvHXdv79BAEaXh50W6vF8gBvkQ@mail.gmail.com>
 <1516638634.2545.0.camel@wdc.com> <097921fa-52c5-8b2b-f564-4b24d9720478@interlog.com>
 <CACT4Y+aEx0ie3qjx6afCYV2vN7gYii0uupKWPXaNTnWUmhdHQw@mail.gmail.com> <c0a7ec39-e357-9db6-cf12-ff9c46259f26@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <c0a7ec39-e357-9db6-cf12-ff9c46259f26@interlog.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Gilbert <dgilbert@interlog.com>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "ben.hutchings@codethink.co.uk" <ben.hutchings@codethink.co.uk>, "syzkaller@googlegroups.com" <syzkaller@googlegroups.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Feb 1, 2018 at 7:03 AM, Douglas Gilbert <dgilbert@interlog.com> wrote:
> On 2018-01-30 07:22 AM, Dmitry Vyukov wrote:
>>
>> Uh, I've answered this a week ago, but did not notice that Doug
>> dropped everybody from CC. Reporting to all.
>>
>> On Mon, Jan 22, 2018 at 8:16 PM, Douglas Gilbert <dgilbert@interlog.com>
>> wrote:
>>>
>>> On 2018-01-22 02:06 PM, Dmitry Vyukov wrote:
>>>>
>>>>
>>>> On Mon, Jan 22, 2018 at 7:57 PM, Douglas Gilbert <dgilbert@interlog.com>
>>>
>>> Please show me the output of 'lsscsi -g' on your test machine.
>>> /dev/sg0 is often associated with /dev/sda which is often a SATA
>>> SSD (or a virtualized one) that holds the root file system.
>>> With the sg pass-through driver it is relatively easy to write
>>> random (user provided data) over the root file system which will
>>> almost certainly "root" the system.
>>
>>
>>
>> This is pretty standard qemu vm started with:
>>
>> qemu-system-x86_64 -hda wheezy.img -net user,host=10.0.2.10 -net nic
>> -nographic -kernel arch/x86/boot/bzImage -append "console=ttyS0
>> root=/dev/sda earlyprintk=serial " -m 2G -smp 4
>>
>> # lsscsi -g
>> [0:0:0:0]    disk    ATA      QEMU HARDDISK    0     /dev/sda   /dev/sg0
>
>
> With lk 4.15.0-rc9 I can run your test program (with some additions, see
> attachment) for 30 minutes against a scsi_debug simulated disk. You can
> easily replicate this test just run 'modprobe scsi_debug' and a third
> line should appear in your lsscsi output. The new device will most likely
> be /dev/sg2 .
>
> With lk 4.15.0 (release) running against a SAS SSD (SEAGATE ST200FM0073),
> the test has  been running 20 minutes and counting without problems. That
> is using a LSI HBA with the mpt3sas driver.
>
>> [1:0:0:0]    cd/dvd  QEMU     QEMU DVD-ROM     2.0.  /dev/sr0   /dev/sg1
>>
>> # readlink /sys/class/scsi_generic/sg0
>>
>> ../../devices/pci0000:00/0000:00:01.1/ata1/host0/target0:0:0/0:0:0:0/scsi_generic/sg0
>>
>> # cat /sys/class/scsi_generic/sg0/device/vendor
>> ATA
>
>
> ^^^^^
> That subsystem is the culprit IMO, most likely libata.
>
> Until you can show this test failing on something other than an
> ATA disk, then I will treat this issue as closed.

Hi Doug,

Why is bug in ATA not a bug? Is it long unused by everybody? I've got
it by running qemu with default flags...

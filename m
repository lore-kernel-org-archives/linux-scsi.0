From: Tom Yan <tom.ty89@gmail.com>
Subject: Re: configurable discard parameters
Date: Mon, 22 Jun 2015 04:30:00 +0800
Message-ID: <CAGnHSEnLACL6XisaFn3axRETAD3CjOa7fGrHKR7s6GOroQXkew@mail.gmail.com>
References: <CAGnHSEmDQ6xaJsw9i=v23BffWQ8RncrgNBsGWy3ziC36QK+9yQ@mail.gmail.com>
	<yq1fv5l9ajd.fsf@sermon.lab.mkp.net>
	<CAGnHSEk+=r1CwQaGd9n4nUm3_e3O7GOL_iFDeJTuNyaSq9WFYg@mail.gmail.com>
	<CAGnHSEnevg=advtq=CW2FvV5b93GX3kNwrFu587O2V7hf1J8hA@mail.gmail.com>
	<CAGnHSEnBvgWKw6g=c4vpCNEfpdh_45orz5JcSmfM7jadxjpxzQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <CAGnHSEnBvgWKw6g=c4vpCNEfpdh_45orz5JcSmfM7jadxjpxzQ@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

After rechecking the result of blkdiscard (without specifying --step)
with hexdump, I see that the single ioctl is actually broken into
multiple TRIM commands/ranges by 65535 sector. I wonder if it will be
further tuned by ANY KIND of granularity though. Though it will
probably only be a problem for device TRIM, and for that you can
probably always rely on blkdiscard with --step (and avoid device TRIM
with things like mkfs.btrfs) so I guess it won't be a big problem. And
it will be fine for filesystem TRIM anyway I guess.

So it seems that "Maximum write same length: 0x3fffc0 blocks" doesn't
really matter (In fact when I ran `sg_write_same -U --lba=0
--num=0x7fffffff`, the command also trim the first 65528 sectors of
the drive). However, I am curious what is the meaning of "Our current
TRIM payload is a single sector that can accommodate 64 * 65535 blocks
being unmapped. Report this value in the Block Limits Maximum Unmap
LBA count field." in the commit message. What does the value actually
mean/affect? Could it cause trouble to certain drives?

By the way I think I got the answer for my USB TRIM question.
Basically for USB->SATA drives the SATL is implemented in the bridges,
so it must be able to "SAT" one of the three SCSI unmap methods to ATA
TRIM, just like libata does, so that it can handle whatever requested
through the scsi disk driver, otherwise one can only TRIM it through
SCSI's ATA pass-through commands if the bridge supports them, e.g.
hdparm. So my dirty hacking was silly.

P.S.:

[tom@localhost ~]$ sudo sg_vpd -p ai /dev/sda
ATA information VPD page:
  SAT Vendor identification: linux
  SAT Product identification: libata
  SAT Product revision level: 3.00

So it actually tells. And I hope that the kernel wouldn't "falsify"
anything for devices which do provide some VPD(s). : \

Another P.S.: I made a mistake in one of my last mails. 65535 is two
bytes, not four bytes. : /

On 21 June 2015 at 20:36, Tom Yan <tom.ty89@gmail.com> wrote:
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/drivers/ata/libata-scsi.c?id=18f0f97850059303ed73b1f02084f55ca330a80c
>
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/drivers/ata/libata-scsi.c?id=e78db4dfb1355a895f7ea50133b702b55b8ed184
>
> So I think I found the answer myself. But I don't see the rationale
> here at all. So values (arbitrary?) of granularity and maximum has
> been hardcoded in the kernel for ALL devices which make use of libata,
> and the parameter cannot be changed by user in runtime? So does it
> expect all devices to be of the same spec? Or is it just like a
> draft/example which people can only consider it as "may work"?
>
> On 21 June 2015 at 16:05, Tom Yan <tom.ty89@gmail.com> wrote:
>> By the way do you think it could be a bug of libata's SATL anyway?
>> Like perhaps it should break a single unmap request to multiple ATA
>> commands? I am not totally sure about it but it looks like there's a
>> limit of addressed blocks in a single ATA DSM/TRIM command (4 bytes,
>> which is 65535).
>>
>> On 21 June 2015 at 15:03, Tom Yan <tom.ty89@gmail.com> wrote:
>>> On 21 June 2015 at 08:20, Martin K. Petersen <martin.petersen@oracle.com> wrote:
>>>> It is a SATA-attached drive, it has no block limits VPD. What you are
>>>> seeing is information prepared by libata's SATL.
>>>>
>>>> Because if the vendor got these trivial values wrong there is little to
>>>> no chance that they implemented discard correctly in their firmware.
>>>
>>> I don't get it. So there's a chance that the VPDs is not purely from
>>> the hardware? Then how can I differentiate them? But then you said
>>> "the vendor got these trivial values wrong", so were you talking about
>>> this drive or just for real SCSI drives?
--
To unsubscribe from this list: send the line "unsubscribe linux-ide" in

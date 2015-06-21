From: Tom Yan <tom.ty89@gmail.com>
Subject: Re: configurable discard parameters
Date: Sun, 21 Jun 2015 20:36:00 +0800
Message-ID: <CAGnHSEnBvgWKw6g=c4vpCNEfpdh_45orz5JcSmfM7jadxjpxzQ@mail.gmail.com>
References: <CAGnHSEmDQ6xaJsw9i=v23BffWQ8RncrgNBsGWy3ziC36QK+9yQ@mail.gmail.com>
	<yq1fv5l9ajd.fsf@sermon.lab.mkp.net>
	<CAGnHSEk+=r1CwQaGd9n4nUm3_e3O7GOL_iFDeJTuNyaSq9WFYg@mail.gmail.com>
	<CAGnHSEnevg=advtq=CW2FvV5b93GX3kNwrFu587O2V7hf1J8hA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <CAGnHSEnevg=advtq=CW2FvV5b93GX3kNwrFu587O2V7hf1J8hA@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/drivers/ata/libata-scsi.c?id=18f0f97850059303ed73b1f02084f55ca330a80c

https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/drivers/ata/libata-scsi.c?id=e78db4dfb1355a895f7ea50133b702b55b8ed184

So I think I found the answer myself. But I don't see the rationale
here at all. So values (arbitrary?) of granularity and maximum has
been hardcoded in the kernel for ALL devices which make use of libata,
and the parameter cannot be changed by user in runtime? So does it
expect all devices to be of the same spec? Or is it just like a
draft/example which people can only consider it as "may work"?

On 21 June 2015 at 16:05, Tom Yan <tom.ty89@gmail.com> wrote:
> By the way do you think it could be a bug of libata's SATL anyway?
> Like perhaps it should break a single unmap request to multiple ATA
> commands? I am not totally sure about it but it looks like there's a
> limit of addressed blocks in a single ATA DSM/TRIM command (4 bytes,
> which is 65535).
>
> On 21 June 2015 at 15:03, Tom Yan <tom.ty89@gmail.com> wrote:
>> On 21 June 2015 at 08:20, Martin K. Petersen <martin.petersen@oracle.com> wrote:
>>> It is a SATA-attached drive, it has no block limits VPD. What you are
>>> seeing is information prepared by libata's SATL.
>>>
>>> Because if the vendor got these trivial values wrong there is little to
>>> no chance that they implemented discard correctly in their firmware.
>>
>> I don't get it. So there's a chance that the VPDs is not purely from
>> the hardware? Then how can I differentiate them? But then you said
>> "the vendor got these trivial values wrong", so were you talking about
>> this drive or just for real SCSI drives?
--
To unsubscribe from this list: send the line "unsubscribe linux-ide" in

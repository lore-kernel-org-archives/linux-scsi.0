From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH RFC] support sata odd zero power
Date: Mon, 28 Jun 2010 11:04:16 +0200
Message-ID: <4C286590.50701@gmail.com>
References: <AANLkTimajvNh3frP9LcytXUhFAGk1gB52wa0LlGe0ZS0@mail.gmail.com>	<4C24B184.6050009@gmail.com> <AANLkTik1oiFzr-IpvaFQI75LfdTKkCaNEiRixOUsqen1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58172 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753687Ab0F1JEV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Jun 2010 05:04:21 -0400
Received: by bwz1 with SMTP id 1so80965bwz.19
        for <linux-scsi@vger.kernel.org>; Mon, 28 Jun 2010 02:04:20 -0700 (PDT)
In-Reply-To: <AANLkTik1oiFzr-IpvaFQI75LfdTKkCaNEiRixOUsqen1@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: su henry <henry.su.ati@gmail.com>
Cc: axboe@kernel.dk, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@suse.de>

Hello,

On 06/28/2010 10:43 AM, su henry wrote:
>> Can you please align fields?  Also, single struct for the whole
>> system?  I haven't read the spec but I don't think anybody would be
>> defining things like this system-wide.  Right?
>>
> 
> My original though is to put this structure to cdrom_device_info, but
> this structure should be firstly used by acpi_walk_namespace in
> sr_init, and cdrom_device_info is allocated in sr_probe, that's why I
> define a separate structure for the zero power odd.

What prevents you from walking the acpi device tree from sr_probe()?
Or even if you need to walk it from sr_init(), you still need to store
the result and associate it with a specific cdrom device.  It is
something which is specific to single device.  You can't use single
global data structure for all devices like this.

>> bool?
> 
> The return value of sr_test_unit_ready is int.

I would still go for bool but it's a peripheral issue.

>> This thing definitely belongs to struct scsi_cd.  What are the
>> synchronization rules here?  Also, what happens if async notification
>> is in use?  How does the timer get activated then?
> 
> This is a problem, any suggestions? Especially when the system goes to
> S3/S4 state.

Associate with specific device and using timer should work.

>>> +     default:
>>> +             /*tray/drawer/pop-up type*/
>>> +             /* 3a/01(asc/ascq) means MEDIUM NOT PRESENT - TRAY CLOSED */
>>> +             if (isvalid && (sshdr->asc  == 0x3a &&
>>> +                             sshdr->ascq == 0x01)) {
>>> +
>>> +                     /* Eject the tray for a tray type drive*/
>>> +                     if (sr_zpodd_device.flags & SR_ZPODD_NEED_EJECT) {
>>> +                             sr_tray_move(cdi, 1);
>>> +                             sr_zpodd_device.flags &= ~SR_ZPODD_NEED_EJECT;
>>> +                     } else if (!(sr_zpodd_device.flags &
>>> +                                     SR_ZPODD_NO_DISK)) {
>>> +                             sr_zpodd_device.flags |= SR_ZPODD_NO_DISK;
>>> +                             sr_zpodd_device.last_jiffies = jiffies;
>>> +                     } else if (time_after(jiffies,
>>> +                                     sr_zpodd_device.last_jiffies
>>> +                                     + SR_NO_MEDIA_TIMEOUT)) {
>>> +                             acpi_bus_set_power(sr_zpodd_device.handle,
>>> +                                                     ACPI_STATE_D3);
>>> +                     }
>>> +             } else
>>> +                     sr_zpodd_device.flags &= ~SR_ZPODD_NO_DISK;
>>> +             break;
>>> +     }
>>
>> It would probably be better to separate decision making and updating
>> states.
> 
> When user pressing the button on a tray type drive,  driver should set
> a flag used to eject the tray in sr_media_change, if we use that
> states here, we should a one more state "NEED_EJECT" for drive status.

Oh, I meant the code.  ie. instead of

	switch (device type) {
	type a:
		something something
		break;
	default:
		something something slightly differently
		break;
	}

do something like the following,

	switch (device type) {
	type a:
		determine what to do
		break;
	default:
		determine what to do slightly differently;
		break;
	}
	do what has been determined;

Thanks.

-- 
tejun

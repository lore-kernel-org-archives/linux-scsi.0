From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH RFC] support sata odd zero power
Date: Mon, 28 Jun 2010 14:45:20 +0200
Message-ID: <4C289960.2040900@gmail.com>
References: <AANLkTimajvNh3frP9LcytXUhFAGk1gB52wa0LlGe0ZS0@mail.gmail.com> <4C24B184.6050009@gmail.com> <AANLkTik1oiFzr-IpvaFQI75LfdTKkCaNEiRixOUsqen1@mail.gmail.com> <4C286590.50701@gmail.com> <AANLkTilaI2G9jOtb49gUboNYVh2AiWtnzU-Z0_MxVURt@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40623 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185Ab0F1MpZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Jun 2010 08:45:25 -0400
Received: by fxm14 with SMTP id 14so591816fxm.19
        for <linux-scsi@vger.kernel.org>; Mon, 28 Jun 2010 05:45:23 -0700 (PDT)
In-Reply-To: <AANLkTilaI2G9jOtb49gUboNYVh2AiWtnzU-Z0_MxVURt@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: su henry <henry.su.ati@gmail.com>
Cc: axboe@kernel.dk, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@suse.de>

Helo,

On 06/28/2010 12:42 PM, su henry wrote:
>> What prevents you from walking the acpi device tree from sr_probe()?
>> Or even if you need to walk it from sr_init(), you still need to store
>> the result and associate it with a specific cdrom device.  It is
>> something which is specific to single device.  You can't use single
>> global data structure for all devices like this.
> 
> In order to make sure we walk the name space one time only.
> 
> Because when the host starts the power supply to ODD, the driver will
> start from sr_probe. I think it unnecessary to walk the acpi name
> space when driver probes the device, so I  walk the acpi name space
> from sr_init.

I don't think it would matter at all whether you walk the ACPI tree
once during boot or on every sr_probe().  sr_probe() isn't exactly hot
path nor is ACPI tree walking a very expensive operation.  Even if it
is expensive, the right thing to do is to walk it in sr_init(), store
the result and _associate_ it with the appropriate device once the
device is probed.  It isn't a system global property.  It simply can't
live in a single global data structure shared by every device.  I
mean, what happens if there are multiple devices w/ ODDZ support?

>>> This is a problem, any suggestions? Especially when the system goes to
>>> S3/S4 state.
>>
>> Associate with specific device and using timer should work.
> 
> Considering the S3/S4 state, if we add a new timer for this, we should
> also add the suspend/resume callbacks for the driver, and modify the
> timer timeout(mod_timer) in the callback function.

I don't see why that would be necessary but if so, yeah, sure.

Thanks.

-- 
tejun

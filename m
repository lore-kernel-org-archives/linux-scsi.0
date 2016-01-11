From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH 01/23] devicetree: bindings: hisi_sas: add v2 HW bindings
Date: Mon, 11 Jan 2016 14:00:58 +0000
Message-ID: <5693B59A.6000705@huawei.com>
References: <1452262542-64589-1-git-send-email-john.garry@huawei.com>
 <1452262542-64589-2-git-send-email-john.garry@huawei.com>
 <20160108145256.GG3097@leverpostej> <568FD281.4050207@huawei.com>
 <20160108151934.GA32692@leverpostej> <568FD70D.1090303@huawei.com>
 <20160108164910.GD32692@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:14644 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760227AbcAKOCK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jan 2016 09:02:10 -0500
In-Reply-To: <20160108164910.GD32692@leverpostej>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Rutland <mark.rutland@arm.com>
Cc: JBottomley@odin.com, martin.petersen@oracle.com, robh+dt@kernel.org, pawel.moll@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de, devicetree@vger.kernel.org

>> This is a specific issue for hip06 chipset.
>
> Ok. So is this:
>
> * a bug within the SAS controller in hip06, or:
>
> * a requirement/bug of an endpoint attached to the controller, or:
>
> * a requirement/bug of some interconnect between the controller and
>    endpoint, or:
>
> * some other integration bug?
>

This is related to how the SAS controller IP was integrated into the 
chip. It is related to how many bursts are permitted for this controller 
on the AXI bus.

> Please describe what the issue is that you're trying to work around, not
> only your solution to it.
>
>> There is a bug in the HW on hip06 where controller #1 has to set to 2
>> registers to non-default values to limit "am-max-transmissions".
>
> I got that. However, I have no idea what "am-max-transmissions" is, no
> idea why you need to limit it (hopefully you can describe that a little
> better above), nor what the semantics are for "limit".
>

So am-max-transmissions is a SW configurable feature of the controller. 
 From a high-level, it means how many commands we can send in parallel 
to the end device(s) without waiting for a response. It is dependent on 
the chip bus design.

> The description of the property is an imperative, which reads like a
> description of a specific driver behaviour rather than a property of the
> hardware that leads to that behaviour being necessary. That's a warning
> sign that the property is ill-defined, and we may encounter problems in
> future due to changes in Linux.
>

Agreed.

> Without knowing _why_ it's necessary to limit this, it's not possible to
> know if the property is both necessary and sufficient to solve the
> problem such that it doesn't rear its ugly head in future.
>
> For example, if this is simply one way to work around a hip06-specific
> integration bug that we cannot imagine occurring elsewhere, it may be
> better to instead key off of a platform-specific compatible string for
> the v2 SAS controller in hip06. That gives us more freedom to apply
> different workarounds if we have to.
>
> I see that the presence of this property will cause the driver to writes
> hard-coded values two two registers. Not knowing the format of those
> registers, their default values, nor how they respond to writes, I can't
> tell:
>

As for writing hardcoded values, by default the related registers will 
hold 0x40, which means we can have upto 64 outstanding requests on this 
controller. Due to controller #1 integration restrictions, we can only 
issue 32 requests.

> * If the writes have other effects.
>
> * If the limit is a single bit being flipped (i.e. this is a boolean in
>    hardware too).
>
> * If the limit is some arbitrary chosen value which is not described in
>    the property or the binding, nor what that value is. If we encounter a
>    similar bug requiring a different bound in future, it may be
>    problematic to have chosen an arbitrary fixed value, and it may make
>    more sense to describe the value in the DT.
>
> So, please:
>
> * Update the DT property description to describe the specific HW issue
>    that needs to be worked around, with a full description in the commit
>    message.
>
> * Add a comment to the driver to explain what the effect of the register
>    writes is intended to be, i.e. what value am max transmissions is
>    being set to, and why that value isn't arbitrary.
>

As I understand, there are no more restictions/special requirements for 
controller #1. This v2 controller IP will be used in other chips, so we 
may have this issue again - I am seeking information from HW people. As 
such, it may be useful to know this info before decided on how this is 
decribed in the DT.

>> This would not be a common SAS/SCSI controller property and is
>> specific to our HW.
>
> Ok.
>
> Thanks,
> Mark.
>

Cheers,
John



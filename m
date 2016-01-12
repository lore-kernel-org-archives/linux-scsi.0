From: John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 01/23] devicetree: bindings: hisi_sas: add v2 HW bindings
Date: Tue, 12 Jan 2016 12:16:34 +0000
Message-ID: <5694EEA2.8060000@huawei.com>
References: <1452262542-64589-1-git-send-email-john.garry@huawei.com>
 <1452262542-64589-2-git-send-email-john.garry@huawei.com>
 <20160108145256.GG3097@leverpostej> <568FD281.4050207@huawei.com>
 <20160108151934.GA32692@leverpostej> <568FD70D.1090303@huawei.com>
 <20160108164910.GD32692@leverpostej> <5693B59A.6000705@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5693B59A.6000705-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Cc: devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, JBottomley-wo1vFcy6AUs@public.gmane.org, john.garry2-s/0ZXS5h9803lw97EnAbAg@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, zhangfei.gao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On 11/01/2016 14:00, John Garry wrote:
>>> This is a specific issue for hip06 chipset.
>>
>> Ok. So is this:
>>
>> * a bug within the SAS controller in hip06, or:
>>
>> * a requirement/bug of an endpoint attached to the controller, or:
>>
>> * a requirement/bug of some interconnect between the controller and
>>    endpoint, or:
>>
>> * some other integration bug?
>>
>
> This is related to how the SAS controller IP was integrated into the
> chip. It is related to how many bursts are permitted for this controller
> on the AXI bus.
>
>> Please describe what the issue is that you're trying to work around, not
>> only your solution to it.
>>
>>> There is a bug in the HW on hip06 where controller #1 has to set to 2
>>> registers to non-default values to limit "am-max-transmissions".
>>
>> I got that. However, I have no idea what "am-max-transmissions" is, no
>> idea why you need to limit it (hopefully you can describe that a little
>> better above), nor what the semantics are for "limit".
>>
>
> So am-max-transmissions is a SW configurable feature of the controller.
>  From a high-level, it means how many commands we can send in parallel
> to the end device(s) without waiting for a response. It is dependent on
> the chip bus design.
>
>> The description of the property is an imperative, which reads like a
>> description of a specific driver behaviour rather than a property of the
>> hardware that leads to that behaviour being necessary. That's a warning
>> sign that the property is ill-defined, and we may encounter problems in
>> future due to changes in Linux.
>>
>
> Agreed.
>
>> Without knowing _why_ it's necessary to limit this, it's not possible to
>> know if the property is both necessary and sufficient to solve the
>> problem such that it doesn't rear its ugly head in future.
>>
>> For example, if this is simply one way to work around a hip06-specific
>> integration bug that we cannot imagine occurring elsewhere, it may be
>> better to instead key off of a platform-specific compatible string for
>> the v2 SAS controller in hip06. That gives us more freedom to apply
>> different workarounds if we have to.
>>
>> I see that the presence of this property will cause the driver to writes
>> hard-coded values two two registers. Not knowing the format of those
>> registers, their default values, nor how they respond to writes, I can't
>> tell:
>>
>
> As for writing hardcoded values, by default the related registers will
> hold 0x40, which means we can have upto 64 outstanding requests on this
> controller. Due to controller #1 integration restrictions, we can only
> issue 32 requests.
>
>> * If the writes have other effects.
>>
>> * If the limit is a single bit being flipped (i.e. this is a boolean in
>>    hardware too).
>>
>> * If the limit is some arbitrary chosen value which is not described in
>>    the property or the binding, nor what that value is. If we encounter a
>>    similar bug requiring a different bound in future, it may be
>>    problematic to have chosen an arbitrary fixed value, and it may make
>>    more sense to describe the value in the DT.
>>
>> So, please:
>>
>> * Update the DT property description to describe the specific HW issue
>>    that needs to be worked around, with a full description in the commit
>>    message.
>>
>> * Add a comment to the driver to explain what the effect of the register
>>    writes is intended to be, i.e. what value am max transmissions is
>>    being set to, and why that value isn't arbitrary.
>>
>
> As I understand, there are no more restictions/special requirements for
> controller #1. This v2 controller IP will be used in other chips, so we
> may have this issue again - I am seeking information from HW people. As
> such, it may be useful to know this info before decided on how this is
> decribed in the DT.

This issue is specific to only SAS controller #1 in hip06. The 
controller is designed to permit upto 64, but, due to chip bus design, 
this specific controller is limited to support 32.
So, after considering this, would a platform-specific compatible string 
be a better way of decribing this specific controller?

>
>>> This would not be a common SAS/SCSI controller property and is
>>> specific to our HW.
>>
>> Ok.
>>
>> Thanks,
>> Mark.
>>
>
thanks,
John

> _______________________________________________
> linuxarm mailing list
> linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
> http://rnd-openeuler.huawei.com/mailman/listinfo/linuxarm


--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

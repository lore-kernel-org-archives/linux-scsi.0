From: John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 02/32] devicetree: bindings: scsi: HiSi SAS
Date: Tue, 27 Oct 2015 15:06:56 +0000
Message-ID: <562F9310.7000900@huawei.com>
References: <1445868903-183817-1-git-send-email-john.garry@huawei.com>
 <1445868903-183817-3-git-send-email-john.garry@huawei.com>
 <20151026144523.GB12277@leverpostej> <562F777B.6020407@huawei.com>
 <20151027143939.GG3091@leverpostej> <562F9016.50807@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <562F9016.50807-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: zhangfei <zhangfei.gao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Cc: JBottomley-wo1vFcy6AUs@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, john.garry2-s/0ZXS5h9803lw97EnAbAg@public.gmane.org, hare-l3A5Bk7waGM@public.gmane.org, xuwei5-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org
List-Id: linux-scsi@vger.kernel.org


>>> The syscon block is a general subsystem control block, and it is not
>>> specifically only for controlling reset and enabling clocks (other
>>> functions include serdes control, for example). It is also shared
>>> with other peripherals.
>>>
>>> So we can remove the ctrl-reg property (since it is not part of the
>>> SAS controller), and add the relevant syscon register offsets to the
>>> "hisilicon,sas-syscon" property, like this:
>>> hisilicon,sas-syscon = <&sas_ctrl0 0xa60 0x33c 0x5a30 0xa64 0x338>;
>>>
>>> Ok?
>>
>> It would be better to have each offset in a separate property.
>>
> These register are not used for different purpose.
> Instead, they are all used for one purpose, reset the sas controller;
> Though a bit complicated, the silicon has special requirement here.
>
> So still prefer using the original method,
> ctrl-reg = <0xa60 0x33c 0x5a30 0xa64 0x338>;
> Since we can simply use of_property_read_u32_array.
>
We can actually remove the deassert and clock enable properties as they 
are always at a fixed offset from their respective assert/clk disable 
partner register.

> Thanks
>
>
> .
>

thanks,
John

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

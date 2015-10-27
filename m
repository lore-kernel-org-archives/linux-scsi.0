From: zhangfei <zhangfei.gao@linaro.org>
Subject: Re: [PATCH v2 02/32] devicetree: bindings: scsi: HiSi SAS
Date: Tue, 27 Oct 2015 22:54:14 +0800
Message-ID: <562F9016.50807@linaro.org>
References: <1445868903-183817-1-git-send-email-john.garry@huawei.com> <1445868903-183817-3-git-send-email-john.garry@huawei.com> <20151026144523.GB12277@leverpostej> <562F777B.6020407@huawei.com> <20151027143939.GG3091@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:36451 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932345AbbJ0OyW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Oct 2015 10:54:22 -0400
Received: by pacfv9 with SMTP id fv9so234926739pac.3
        for <linux-scsi@vger.kernel.org>; Tue, 27 Oct 2015 07:54:22 -0700 (PDT)
In-Reply-To: <20151027143939.GG3091@leverpostej>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Rutland <mark.rutland@arm.com>, John Garry <john.garry@huawei.com>
Cc: JBottomley@odin.com, robh+dt@kernel.org, pawel.moll@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, arnd@arndb.de, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linuxarm@huawei.com, john.garry2@mail.dcu.ie, hare@suse.de, xuwei5@hisilicon.com



On 10/27/2015 10:39 PM, Mark Rutland wrote:
> On Tue, Oct 27, 2015 at 01:09:15PM +0000, John Garry wrote:
>> On 26/10/2015 14:45, Mark Rutland wrote:
>>> On Mon, Oct 26, 2015 at 10:14:33PM +0800, John Garry wrote:
>>>> Add devicetree bindings for HiSilicon SAS driver.
>>>>
>>>> Signed-off-by: John Garry <john.garry@huawei.com>
>>>> ---
>>>>   .../devicetree/bindings/scsi/hisilicon-sas.txt     | 70 ++++++++++++++++++++++
>>>>   1 file changed, 70 insertions(+)
>>>>   create mode 100644 Documentation/devicetree/bindings/scsi/hisilicon-sas.txt
>>>>
>>>> diff --git a/Documentation/devicetree/bindings/scsi/hisilicon-sas.txt b/Documentation/devicetree/bindings/scsi/hisilicon-sas.txt
>>>> new file mode 100644
>>>> index 0000000..d1e7b2a
>>>> --- /dev/null
>>>> +++ b/Documentation/devicetree/bindings/scsi/hisilicon-sas.txt
>>>> @@ -0,0 +1,70 @@
>>>> +* HiSilicon SAS controller
>>>> +
>>>> +The HiSilicon SAS controller supports SAS/SATA.
>>>> +
>>>> +Main node required properties:
>>>> +  - compatible : value should be as follows:
>>>> +	(a) "hisilicon,sas-controller-v1" for v1 of HiSilicon SAS controller IP
>>>> +  - reg : Address and length of the SAS register
>>>> +  - hisilicon,sas-syscon: phandle of syscon used for sas control
>>>> +  - ctrl-reg : offset to the following SAS control registers (in order):
>>>> +		- reset assert
>>>> +		- clock disable
>>>> +		- reset status
>>>> +		- reset de-assert
>>>> +		- clock enable
>>>
>>> This needs a better name, and it should probably be split up into
>>> several properties.
>>>
>>> However, it sounds like the syscon is actually a clock+reset
>>> controller, and should be modelled as such. It's not actually a part of
>>> the SAS controller as such.
>>
>> The syscon block is a general subsystem control block, and it is not
>> specifically only for controlling reset and enabling clocks (other
>> functions include serdes control, for example). It is also shared
>> with other peripherals.
>>
>> So we can remove the ctrl-reg property (since it is not part of the
>> SAS controller), and add the relevant syscon register offsets to the
>> "hisilicon,sas-syscon" property, like this:
>> hisilicon,sas-syscon = <&sas_ctrl0 0xa60 0x33c 0x5a30 0xa64 0x338>;
>>
>> Ok?
>
> It would be better to have each offset in a separate property.
>
These register are not used for different purpose.
Instead, they are all used for one purpose, reset the sas controller;
Though a bit complicated, the silicon has special requirement here.

So still prefer using the original method,
ctrl-reg = <0xa60 0x33c 0x5a30 0xa64 0x338>;
Since we can simply use of_property_read_u32_array.

Thanks


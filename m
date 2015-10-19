From: zhangfei <zhangfei.gao@linaro.org>
Subject: Re: [PATCH 02/25] devicetree: bindings: scsi: HiSi SAS
Date: Mon, 19 Oct 2015 22:51:22 +0800
Message-ID: <5625036A.3040203@linaro.org>
References: <1444663237-238302-1-git-send-email-john.garry@huawei.com> <1444663237-238302-3-git-send-email-john.garry@huawei.com> <CAL_JsqLk9p_YX2FCNiR4sOSU74asN0UrOSJ5gQfnyRhrFH8LgQ@mail.gmail.com> <5624CA64.9020209@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:33059 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677AbbJSOvb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Oct 2015 10:51:31 -0400
Received: by pabrc13 with SMTP id rc13so193343604pab.0
        for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2015 07:51:30 -0700 (PDT)
In-Reply-To: <5624CA64.9020209@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Garry <john.garry@huawei.com>, Rob Herring <robh@kernel.org>
Cc: Jej B <James.Bottomley@hansenpartnership.com>, linux-kernel@vger.kernel.com, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, linuxarm@huawei.com, linux-scsi@vger.kernel.org, Wei Xu <xuwei5@hisilicon.com>, john.garry2@mail.dcu.ie, hare@suse.de



On 10/19/2015 06:48 PM, John Garry wrote:
> On 16/10/2015 14:47, Rob Herring wrote:

>>> +  - reg : Address and length of the register sets for the device
>>> +   - SAS controller registers
>>> +   - SAS controller control registers
>>> +
>>> +  - reset-reg : offset to reset, status, and clock registers in
>>> control registers
>>
>> Within the above register range? If so and if this varies, then that
>> implies there is more than 1 version of IP. In that case you should
>> have a more specific compatible string.
>>
> The registers in the second region are for syscon register offsets. See
> last note, below.
>
>> How long is this property I count 3 cells here, but the example has 5.
>> Define what each cell corresponds to specifically.
>>
> We will add all the cells to the decription, which are:
> Reset assert, clock disable, reset status, reset de-assert, and clock
> enable.
>>> +

We have switch to using syscon,
The dts has been changed to

         sas_ctrl0: sas_ctrl@c0000000 {
                 compatible = "hisilicon,sas-ctrl", "syscon";
                 reg = <0x0 0xc0000000 0x0 0x10000>;
         };

         sas0: sas@c1000000 {
                 compatible = "hisilicon,sas-controller-v1";
                 reg = <0x0 0xc1000000 0x0 0x10000>;
                 hisilicon,sas-syscon = <&sas_ctrl0>;
                 ctrl-reg = <0xa60 0x33c 0x5a30 0xa64 0x338>;

ctrl-reg contains several regs in sas-ctrl, which need to be accessed 
since some complicated requirement of the silicon.

Have considered using
hisilicon,sas-syscon = <&sas_ctrl0 0xa60 0x33c 0x5a30 0xa64 0x338>;
But of_property_read_u32_array cat not get array from index 1.
Then we have to use of_property_read_u32_index one by one.

So instead we add additional ctrl-reg, and get the array one time via 
of_property_read_u32_array.

Thanks



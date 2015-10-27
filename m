From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH v2 02/32] devicetree: bindings: scsi: HiSi SAS
Date: Tue, 27 Oct 2015 13:09:15 +0000
Message-ID: <562F777B.6020407@huawei.com>
References: <1445868903-183817-1-git-send-email-john.garry@huawei.com>
 <1445868903-183817-3-git-send-email-john.garry@huawei.com>
 <20151026144523.GB12277@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151026144523.GB12277@leverpostej>
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Rutland <mark.rutland@arm.com>
Cc: JBottomley@odin.com, robh+dt@kernel.org, pawel.moll@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, arnd@arndb.de, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linuxarm@huawei.com, john.garry2@mail.dcu.ie, hare@suse.de, xuwei5@hisilicon.com, zhangfei.gao@linaro.org
List-Id: linux-scsi@vger.kernel.org

On 26/10/2015 14:45, Mark Rutland wrote:
> On Mon, Oct 26, 2015 at 10:14:33PM +0800, John Garry wrote:
>> Add devicetree bindings for HiSilicon SAS driver.
>>
>> Signed-off-by: John Garry <john.garry@huawei.com>
>> ---
>>   .../devicetree/bindings/scsi/hisilicon-sas.txt     | 70 ++++++++++++++++++++++
>>   1 file changed, 70 insertions(+)
>>   create mode 100644 Documentation/devicetree/bindings/scsi/hisilicon-sas.txt
>>
>> diff --git a/Documentation/devicetree/bindings/scsi/hisilicon-sas.txt b/Documentation/devicetree/bindings/scsi/hisilicon-sas.txt
>> new file mode 100644
>> index 0000000..d1e7b2a
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/scsi/hisilicon-sas.txt
>> @@ -0,0 +1,70 @@
>> +* HiSilicon SAS controller
>> +
>> +The HiSilicon SAS controller supports SAS/SATA.
>> +
>> +Main node required properties:
>> +  - compatible : value should be as follows:
>> +	(a) "hisilicon,sas-controller-v1" for v1 of HiSilicon SAS controller IP
>> +  - reg : Address and length of the SAS register
>> +  - hisilicon,sas-syscon: phandle of syscon used for sas control
>> +  - ctrl-reg : offset to the following SAS control registers (in order):
>> +		- reset assert
>> +		- clock disable
>> +		- reset status
>> +		- reset de-assert
>> +		- clock enable
>
> This needs a better name, and it should probably be split up into
> several properties.
>
> However, it sounds like the syscon is actually a clock+reset
> controller, and should be modelled as such. It's not actually a part of
> the SAS controller as such.

The syscon block is a general subsystem control block, and it is not 
specifically only for controlling reset and enabling clocks (other 
functions include serdes control, for example). It is also shared with 
other peripherals.

So we can remove the ctrl-reg property (since it is not part of the SAS 
controller), and add the relevant syscon register offsets to the 
"hisilicon,sas-syscon" property, like this:
hisilicon,sas-syscon = <&sas_ctrl0 0xa60 0x33c 0x5a30 0xa64 0x338>;

Ok?

>
>> +  - queue-count : number of delivery and completion queues in the controller
>> +  - phy-count : number of phys accessible by the controller
>> +  - interrupts : Interrupts for phys, completion queues, and fatal
>> +		 interrupts:
>> +		  - Each phy has 3 interrupt sources:
>> +			- broadcast
>> +			- phyup
>> +			- abnormal
>> +		  - Each completion queue has 1 interrupt source
>> +		  - Each controller has 2 fatal interrupt sources:
>> +			- ECC
>> +			- AXI bus
>
> Please make the ordering explicit here (you might only need to add the
> phrase "in order" in a few places).

Will do.

>
> Thanks,
> Mark.
>
Thanks,
John

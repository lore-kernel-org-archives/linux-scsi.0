From: John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 02/25] devicetree: bindings: scsi: HiSi SAS
Date: Mon, 19 Oct 2015 11:48:04 +0100
Message-ID: <5624CA64.9020209@huawei.com>
References: <1444663237-238302-1-git-send-email-john.garry@huawei.com>
 <1444663237-238302-3-git-send-email-john.garry@huawei.com>
 <CAL_JsqLk9p_YX2FCNiR4sOSU74asN0UrOSJ5gQfnyRhrFH8LgQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL_JsqLk9p_YX2FCNiR4sOSU74asN0UrOSJ5gQfnyRhrFH8LgQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jej B <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, linux-kernel-u79uwXL29TZ19SzzRMN9sA@public.gmane.org, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Zhangfei Gao <zhangfei.gao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Wei Xu <xuwei5-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>, john.garry2-s/0ZXS5h9803lw97EnAbAg@public.gmane.org, hare-l3A5Bk7waGM@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On 16/10/2015 14:47, Rob Herring wrote:
> On Mon, Oct 12, 2015 at 10:20 AM, John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
>> Add devicetree bindings for HiSilicon SAS driver.
>
> In the future, please use get_maintainers.pl.
>
Will do.

>> Signed-off-by: John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>> ---
>>   .../devicetree/bindings/scsi/hisilicon-sas.txt     | 63 ++++++++++++++++++++++
>>   1 file changed, 63 insertions(+)
>>   create mode 100644 Documentation/devicetree/bindings/scsi/hisilicon-sas.txt
>>
>> diff --git a/Documentation/devicetree/bindings/scsi/hisilicon-sas.txt b/Documentation/devicetree/bindings/scsi/hisilicon-sas.txt
>> new file mode 100644
>> index 0000000..472c022
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/scsi/hisilicon-sas.txt
>> @@ -0,0 +1,63 @@
>> +* HiSilison SAS controller
>> +
>> +The HiSilicon SAS controller supports SAS/SATA.
>> +
>> +Main node required properties:
>> +  - compatible : value should be as follows:
>> +       (a) "hisilicon,sas-controller-v1" for v1 of HiSilicon SAS controller IP
>> +
>> +  - controller-id : identifier for controller in the SoC
>
> We don't do indexes in DT (mostly). Why do you need this?

We don't strictly require it. A soc may have multiple instances of this 
IP, so having an index is useful for memory pools/workqueue/etc name 
string associated with each instance.

>
>> +  - reg : Address and length of the register sets for the device
>> +   - SAS controller registers
>> +   - SAS controller control registers
>> +
>> +  - reset-reg : offset to reset, status, and clock registers in control registers
>
> Within the above register range? If so and if this varies, then that
> implies there is more than 1 version of IP. In that case you should
> have a more specific compatible string.
>
The registers in the second region are for syscon register offsets. See 
last note, below.

> How long is this property I count 3 cells here, but the example has 5.
> Define what each cell corresponds to specifically.
>
We will add all the cells to the decription, which are:
Reset assert, clock disable, reset status, reset de-assert, and clock 
enable.
>> +
>> +  - queue-count : number of delivery and completion queues in the controller
>> +
>> +  - phy-count : number of phys accessible by the controller
>> +
>> +  - interrupts : Interrupts for phys, completion queues, and fatal
>> +                interrupts:
>> +                 - Each phy has 3 interrupt sources:
>> +                       - broadcast
>> +                       - phyup
>> +                       - abnormal
>> +                 - Each completion queue has 1 interrupt source
>> +                 - Each controller has 2 fatal interrupt sources:
>> +                       - ECC
>> +                       - AXI bus
>> +
>> +Example:
>> +       sas0: sas@c1000000 {
>> +               compatible = "hisilicon,sas-controller-v1";
>> +               controller-id = <0>;
>> +               reg = <0x0 0xc1000000 0x0 0x10000>,
>> +                       <0x0 0xc0000000 0x0 0x10000>;

We have decided to remove the second memory region and access the 
relevant memories through syscon interface.

>> +               reset-reg = <0xa60 0x33c 0x5a30 0xa64 0x338>;
>> +               queue-count = <32>;
>> +               phy-count = <8>;
>> +               #interrupt-cells = <2>;
>> +               dma-coherent;
>> +               interrupt-parent = <&mbigen_dsa>;
>> +               interrupts = <259 4>, <263 4>,<264 4>,/* phy irq(0~79) */
>> +                               <269 4>,<273 4>,<274 4>,/* phy irq(0~79) */
>> +                               <279 4>,<283 4>,<284 4>,/* phy irq(0~79) */
>> +                               <289 4>,<293 4>,<294 4>,/* phy irq(0~79) */
>> +                               <299 4>,<303 4>,<304 4>,/* phy irq(0~79) */
>> +                               <309 4>,<313 4>,<314 4>,/* phy irq(0~79) */
>> +                               <319 4>,<323 4>,<324 4>,/* phy irq(0~79) */
>> +                               <329 4>,<333 4>,<334 4>,/* phy irq(0~79) */
>> +                               <336 1>,<337 1>,<338 1>,<339 1>,<340 1>,
>> +                               <341 1>,<342 1>,<343 1>,/* cq irq (80~111) */
>> +                               <344 1>,<345 1>,<346 1>,<347 1>,<348 1>,
>> +                               <349 1>,<350 1>,<351 1>,/* cq irq (80~111) */
>> +                               <352 1>,<353 1>,<354 1>,<355 1>,<356 1>,
>> +                               <357 1>,<358 1>,<359 1>,/* cq irq (80~111) */
>> +                               <360 1>,<361 1>,<362 1>,<363 1>,<364 1>,
>> +                               <365 1>,<366 1>,<367 1>,/* cq irq (80~111) */
>> +                               <376 4>,/* chip fatal error irq(120) */
>> +                               <381 4>;/* chip fatal error irq(125) */
>> +               status = "okay";
>> +       };
>> --
>> 1.9.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe devicetree" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> .
>
Thanks,
John


--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

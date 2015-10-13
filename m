From: Alim Akhtar <alim.akhtar@samsung.com>
Subject: Re: [PATCH v3 11/13] Documentation: devicetree: ufs: Add DT bindings
 for exynos UFS host controller
Date: Tue, 13 Oct 2015 17:06:18 +0530
Message-ID: <561CECB2.2090208@samsung.com>
References: <1443686970-28104-1-git-send-email-alim.akhtar@samsung.com>
 <1443686970-28104-12-git-send-email-alim.akhtar@samsung.com>
 <1457698.WJ3mz2FHZZ@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <1457698.WJ3mz2FHZZ@wuerfel>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, JBottomley@odin.com, vinholikatti@gmail.com, amit.daniel@samsung.com, essuuj@gmail.com, devicetree@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Hi Arnd,
On 10/01/2015 05:07 PM, Arnd Bergmann wrote:
> On Thursday 01 October 2015 13:39:28 Alim Akhtar wrote:
>> From: Seungwon Jeon <essuuj@gmail.com>
>>
>> This adds Exynos Universal Flash Storage (UFS) Host Controller DT bindings.
>>
>> Signed-off-by: Seungwon Jeon <essuuj@gmail.com>
>> Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
>> ---
>>   .../devicetree/bindings/ufs/ufs-exynos.txt         |   93 ++++++++++++++++++++
>>   1 file changed, 93 insertions(+)
>>   create mode 100644 Documentation/devicetree/bindings/ufs/ufs-exynos.txt
>>
>> diff --git a/Documentation/devicetree/bindings/ufs/ufs-exynos.txt b/Documentation/devicetree/bindings/ufs/ufs-exynos.txt
>> new file mode 100644
>> index 0000000..00df72e
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/ufs/ufs-exynos.txt
>> @@ -0,0 +1,93 @@
>> +* Exynos Universal Flash Storage (UFS) Host Controller
>> +
>> +UFSHC nodes are defined to describe on-chip UFS host controllers.
>> +Each UFS controller instance should have its own node.
>> +
>> +Required properties:
>> +- compatible        : compatible name, contains "samsung,exynos7-ufs"
>> +- interrupts        : <interrupt mapping for UFS host controller IRQ>
>> +- reg               : <registers mapping>
>
> This needs a list of all the register ranges, which order they are in
> and what the respective strings must be.
>
will add the details
>> +- clocks                : List of phandle and clock specifier pairs
>> +- clock-names           : List of clock input name strings sorted in the same
>> +                          order as the clocks property.
>
> You need to list the names you require here. Also the 'clock specifier' includes
> the phandle, it's not a pair but just a list of specifiers.
>
ok will add
>> +- ufs,pwr-attr-mode : specifies mode value for power mode change
>> +- ufs,pwr-attr-lane : specifies lane count value for power mode change
>> +- ufs,pwr-attr-gear : specifies gear count value for power mode change
>> +- ufs,pwr-attr-hs-series : specifies HS rate series for power mode change
>> +- ufs,pwr-local-l2-timer : specifies array of local UNIPRO L2 timer values
>> +			   <FC0ProtectionTimeOutVal,TC0ReplayTimeOutVal, AFC0ReqTimeOutVal>
>> +- ufs,pwr-remote-l2-timer : specifies array of remote UNIPRO L2 timer values
>> +			   <FC0ProtectionTimeOutVal,TC0ReplayTimeOutVal, AFC0ReqTimeOutVal>
>> +- ufs-rx-adv-fine-gran-sup_en : specifies support of fine granularity of MPHY,
>> +			      this is a boolean property.
>> +- ufs-rx-adv-fine-gran-step : specifies granularity steps of MPHY
>> +- ufs-rx-adv-min-activate-time-cap : specifies rx advanced minimum activate time of MPHY
>> +- ufs-pa-granularity : specifies Granularity for PA_TActivate and PA_Hibern8Time
>> +- ufs-pa-tacctivate : specifies time wake-up remote M-RX
>> +- ufs-pa-hibern8time : specifies minimum time to wait in HIBERN8 state
>
> These all require a specification of what the allowed values are and/or the units
> for the numbers.
>
will update the specifications above
>> +
>> +		clocks = <&core 0>, <&ref 0>, <&iface 0>;
>> +		clock-names = "core_clk", "ref_clk", "iface_clk";
>
> Better rename them to "core", "ref" and "iface", no point requiring to
> spell out "clk" here.
>
>> +		ufs,pwr-attr-mode = "FAST";
>
> A string is rather unusual here, what are the allowed values? Could you
> use a boolean property instead?
>
will update the binding, supported modes are FAST, SLOW, FAST_auto etc, 
so kept the string for more readability
>> +		ufs,pwr-attr-lane = /bits/ 8 <2>;
>> +		ufs,pwr-attr-gear = /bits/ 8 <2>;
>
> Why the "/bits/ 8" ?
>
I am using of_property_read_u8() to read 8 bit value from property.
>
> 	Arnd
>

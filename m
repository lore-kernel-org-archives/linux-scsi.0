From: Sayali Lokhande <sayalil@codeaurora.org>
Subject: Re: [PATCH V5 1/2] scsi: ufs: set the device reference clock setting
Date: Mon, 16 Jul 2018 13:58:53 +0530
Message-ID: <11dc4af4-3424-8f85-1678-98f59faabc53@codeaurora.org>
References: <1530858040-13971-1-git-send-email-sayalil@codeaurora.org>
 <1530858040-13971-2-git-send-email-sayalil@codeaurora.org>
 <20180706210729.GA22391@rob-hp-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180706210729.GA22391@rob-hp-laptop>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Rob Herring <robh@kernel.org>
Cc: subhashj@codeaurora.org, cang@codeaurora.org, vivek.gautam@codeaurora.org, rnayak@codeaurora.org, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, asutoshd@codeaurora.org, evgreen@chromium.org, riteshh@codeaurora.org, linux-scsi@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>, Mathieu Malaterre <malat@debian.org>, "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" <devicetree@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Rob,


On 7/7/2018 2:37 AM, Rob Herring wrote:
> On Fri, Jul 06, 2018 at 11:50:39AM +0530, Sayali Lokhande wrote:
>> From: Subhash Jadavani <subhashj@codeaurora.org>
>>
>> UFS host supplies the reference clock to UFS device and UFS device
>> specification allows host to provide one of the 4 frequencies (19.2 MHz,
>> 26 MHz, 38.4 MHz, 52 MHz) for reference clock. Host should set the
>> device reference clock frequency setting in the device based on what
>> frequency it is supplying to UFS device.
>>
>> Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
>> Signed-off-by: Can Guo <cang@codeaurora.org>
>> Signed-off-by: Sayali Lokhande <sayalil@codeaurora.org>
>> ---
>>   .../devicetree/bindings/ufs/ufshcd-pltfrm.txt      |  7 +++
>>   drivers/scsi/ufs/ufs.h                             |  9 ++++
>>   drivers/scsi/ufs/ufshcd-pltfrm.c                   |  2 +
>>   drivers/scsi/ufs/ufshcd.c                          | 62 ++++++++++++++++++++++
>>   drivers/scsi/ufs/ufshcd.h                          |  2 +
>>   5 files changed, 82 insertions(+)
>>
>> diff --git a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
>> index c39dfef..bc20f59 100644
>> --- a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
>> +++ b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
>> @@ -41,6 +41,12 @@ Optional properties:
>>   -lanes-per-direction	: number of lanes available per direction - either 1 or 2.
>>   			  Note that it is assume same number of lanes is used both
>>   			  directions at once. If not specified, default is 2 lanes per direction.
>> +- assigned-clock-rates 	: Specify the device reference clock frequency, must be one of the following:
>> +			  0: 19.2 MHz
>> +			  1: 26 MHz
>> +			  2: 38.4 MHz
>> +			  3: 52 MHz
>> +			  Defaults to 26 MHz if not specified.
> Sigh. You obviously did not read the definition of assigned-clock-rates
> and understand how it works. I don't think you want the frequency to be
> 0-3 Hz.
>
Let me revisit this patch set w.r.t to use of assigned-clock-rates.
I will be separating this patch from provisioning patches and will 
upload its next version separately.
>>   Note: If above properties are not defined it can be assumed that the supply
>>   regulators or clocks are always on.
>> @@ -66,4 +72,5 @@ Example:
>>   		freq-table-hz = <100000000 200000000>, <0 0>, <0 0>;
>>   		phys = <&ufsphy1>;
>>   		phy-names = "ufsphy";
>> +		assigned-clock-rates = <0>; /* reference clock freq: 19.2 MHz */
>>   	};
>> diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
>> index 14e5bf7..e15deb0 100644
>> --- a/drivers/scsi/ufs/ufs.h
>> +++ b/drivers/scsi/ufs/ufs.h
>> @@ -378,6 +378,15 @@ enum query_opcode {
>>   	UPIU_QUERY_OPCODE_TOGGLE_FLAG	= 0x8,
>>   };
>>   
>> +/* bRefClkFreq attribute values */
>> +enum ref_clk_freq {
>> +	REF_CLK_FREQ_19_2_MHZ	= 0x0,
>> +	REF_CLK_FREQ_26_MHZ	= 0x1,
>> +	REF_CLK_FREQ_38_4_MHZ	= 0x2,
>> +	REF_CLK_FREQ_52_MHZ	= 0x3,
>> +	REF_CLK_FREQ_MAX	= REF_CLK_FREQ_52_MHZ,
>> +};
>> +
>>   /* Query response result code */
>>   enum {
>>   	QUERY_RESULT_SUCCESS                    = 0x00,
>> diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
>> index e82bde0..0953563 100644
>> --- a/drivers/scsi/ufs/ufshcd-pltfrm.c
>> +++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
>> @@ -343,6 +343,8 @@ int ufshcd_pltfrm_init(struct platform_device *pdev,
>>   	pm_runtime_set_active(&pdev->dev);
>>   	pm_runtime_enable(&pdev->dev);
>>   
>> +	ufshcd_parse_dev_ref_clk_freq(hba);
>> +
>>   	ufshcd_init_lanes_per_dir(hba);
>>   
>>   	err = ufshcd_init(hba, mmio_base, irq);
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> index c5b1bf1..455a6ad 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -6296,6 +6296,62 @@ static void ufshcd_def_desc_sizes(struct ufs_hba *hba)
>>   	hba->desc_size.hlth_desc = QUERY_DESC_HEALTH_DEF_SIZE;
>>   }
>>   
>> +void ufshcd_parse_dev_ref_clk_freq(struct ufs_hba *hba)
>> +{
>> +	struct device *dev = hba->dev;
>> +	int ret;
>> +
>> +	if (!dev)
>> +		return;
>> +
>> +	ret = device_property_read_u32(dev, "assigned-clock-rates",
>> +				   &hba->dev_ref_clk_freq);
>> +	if (ret ||
>> +	    (hba->dev_ref_clk_freq > REF_CLK_FREQ_52_MHZ)) {
>> +		dev_err(hba->dev,
>> +		"%s: invalid ref_clk setting = %d\n",
>> +		__func__, hba->dev_ref_clk_freq);
>> +		hba->dev_ref_clk_freq = REF_CLK_FREQ_MAX + 1;
>> +	}
>> +}
>> +
>> +static int ufshcd_set_dev_ref_clk(struct ufs_hba *hba)
>> +{
>> +	int err = 0;
>> +	int ref_clk = -1;
>> +	static const char * const ref_clk_freqs[] = {"19.2 MHz", "26 MHz",
>> +						     "38.4 MHz", "52 MHz"};
>> +
>> +	err = ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_READ_ATTR,
>> +			QUERY_ATTR_IDN_REF_CLK_FREQ, 0, 0, &ref_clk);
>> +
>> +	if (err) {
>> +		dev_err(hba->dev, "%s: failed reading bRefClkFreq. err = %d\n",
>> +			 __func__, err);
>> +		goto out;
>> +	}
>> +
>> +	if (ref_clk == hba->dev_ref_clk_freq)
>> +		goto out; /* nothing to update */
>> +
>> +	err = ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
>> +			QUERY_ATTR_IDN_REF_CLK_FREQ, 0, 0,
>> +			&hba->dev_ref_clk_freq);
>> +
>> +	if (err)
>> +		dev_err(hba->dev, "%s: bRefClkFreq setting to %s failed\n",
>> +			__func__, ref_clk_freqs[hba->dev_ref_clk_freq]);
>> +	/*
>> +	 * It is good to print this out here to debug any later failures
>> +	 * related to gear switch.
>> +	 */
>> +	dev_dbg(hba->dev, "%s: bRefClkFreq setting to %s succeeded\n",
>> +			__func__, ref_clk_freqs[hba->dev_ref_clk_freq]);
>> +
> I still don't understand how you think this is supposed to work. All
> this does is copy whatever freq setting you put into DT to this
> device attr. That does nothing to actually set the frequency of the
> ref_clk. It's frequency could be anything before and after this
> function.
Here, we are trying to check and then set parsed ref clock freq setting 
from DT.
Function ufshcd_query_attr_retry() is being used to first read the 
current freq and then write ref clk freq attr (if DT setting is 
different than what is already set in device).
> Also, according to the spec, isn't QUERY_ATTR_IDN_REF_CLK_FREQ
> write-once? So if you can read the value, wouldn't that mean you can't
> set it.
As per specs, bRefClkFreq field had “Write once” Access Property up to 
UFS 2.0.
 From 2.1 onwards,  bRefClkFreq access property changed from “Write 
once” to “Persistent”(can be written multiple times, the value is kept 
after power cycle or any type reset event).

> Rob

From: Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH V1 1/3] scsi: ufs: set the device reference clock setting
Date: Fri, 1 Jun 2018 16:17:39 +0300
Message-ID: <0e3f63f5-c912-c7fe-7528-b1290a9a2b05@intel.com>
References: <1527849774-7623-1-git-send-email-sayalil@codeaurora.org>
 <1527849774-7623-2-git-send-email-sayalil@codeaurora.org>
 <a103a853-5818-ba1b-8971-853e35162832@intel.com>
 <001201d3f9aa$20146380$603d2a80$@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <001201d3f9aa$20146380$603d2a80$@codeaurora.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: sayali <sayalil@codeaurora.org>, subhashj@codeaurora.org, cang@codeaurora.org, vivek.gautam@codeaurora.org, rnayak@codeaurora.org, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, asutoshd@codeaurora.org, evgreen@chromium.org
Cc: linux-scsi@vger.kernel.org, 'open list' <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 01/06/18 16:11, sayali wrote:
> Hi Adrain,
> 
> Updated my comments inline. Please check.
> 
> Thanks,
> Sayali
> -----Original Message-----
> From: Adrian Hunter [mailto:adrian.hunter@intel.com] 
> Sent: Friday, June 01, 2018 5:59 PM
> To: Sayali Lokhande <sayalil@codeaurora.org>; subhashj@codeaurora.org; cang@codeaurora.org; vivek.gautam@codeaurora.org; rnayak@codeaurora.org; vinholikatti@gmail.com; jejb@linux.vnet.ibm.com; martin.petersen@oracle.com; asutoshd@codeaurora.org; evgreen@chromium.org
> Cc: linux-scsi@vger.kernel.org; open list <linux-kernel@vger.kernel.org>
> Subject: Re: [PATCH V1 1/3] scsi: ufs: set the device reference clock setting
> 
> On 01/06/18 13:42, Sayali Lokhande wrote:
>> From: Subhash Jadavani <subhashj@codeaurora.org>
>>
>> UFS host supplies the reference clock to UFS device and UFS device 
>> specification allows host to provide one of the 4 frequencies (19.2 
>> MHz,
>> 26 MHz, 38.4 MHz, 52 MHz) for reference clock. Host should set the 
>> device reference clock frequency setting in the device based on what 
>> frequency it is supplying to UFS device.
>>
>> Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
>> [cang@codeaurora.org: Resolved trivial merge conflicts]
>> Signed-off-by: Can Guo <cang@codeaurora.org>
>> Signed-off-by: Sayali Lokhande <sayalil@codeaurora.org>
>> ---
>>  drivers/scsi/ufs/ufs.h    |  9 +++++++
>>  drivers/scsi/ufs/ufshcd.c | 62 
>> +++++++++++++++++++++++++++++++++++++++++++++++
>>  drivers/scsi/ufs/ufshcd.h |  1 +
>>  3 files changed, 72 insertions(+)
>>
>> diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h index 
>> 14e5bf7..e15deb0 100644
>> --- a/drivers/scsi/ufs/ufs.h
>> +++ b/drivers/scsi/ufs/ufs.h
>> @@ -378,6 +378,15 @@ enum query_opcode {
>>  	UPIU_QUERY_OPCODE_TOGGLE_FLAG	= 0x8,
>>  };
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
>>  /* Query response result code */
>>  enum {
>>  	QUERY_RESULT_SUCCESS                    = 0x00,
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c 
>> index c5b1bf1..3669bc4 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -6297,6 +6297,63 @@ static void ufshcd_def_desc_sizes(struct 
>> ufs_hba *hba)  }
>>  
>>  /**
>> + * ufshcd_set_dev_ref_clk - set the device bRefClkFreq
>> + * @hba: per-adapter instance
>> + * @ref_clk_freq: refrerence clock frequency to be set
>> + *
>> + * Read the current value of the bRefClkFreq attribute from device 
>> +and update it
>> + * if host is supplying different reference clock frequency than one 
>> +mentioned
>> + * in bRefClkFreq attribute.
>> + *
>> + * Returns zero on success, non-zero error value on failure.
>> + */
>> +static int ufshcd_set_dev_ref_clk(struct ufs_hba *hba, u32 
>> +ref_clk_freq) {
>> +	int err = 0;
>> +	int ref_clk = -1;
>> +	static const char * const ref_clk_freqs[] = {"19.2 MHz", "26 MHz",
>> +						     "38.4 MHz", "52 MHz"};
>> +
>> +	hba->dev_ref_clk_freq = ref_clk_freq;
>> +	err = ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_READ_ATTR,
>> +			QUERY_ATTR_IDN_REF_CLK_FREQ, 0, 0, &ref_clk);
>> +
>> +	if (err) {
>> +		dev_err(hba->dev, "%s: failed reading bRefClkFreq. err = %d\n",
>> +			 __func__, err);
>> +		goto out;
>> +	}
>> +
>> +	if ((ref_clk < 0) || (ref_clk > REF_CLK_FREQ_52_MHZ)) {
> 
> If you used u32 ref_clk then you wouldn't have to check < 0, also you should use REF_CLK_FREQ_MAX not REF_CLK_FREQ_52_MHZ, but really why is this check needed anyway?
> [Sayali] Here ref_clk is defined as integer with value -1. We are then reading bRefClkFreq attribute from device into ref_clk and hence the sanity check is required before we update/write bRefClkFreq attribute.

But why sanity check a value that is going to be overwritten?

> 
>> +		dev_err(hba->dev, "%s: invalid ref_clk setting = %d\n",
>> +			 __func__, ref_clk);
>> +		err = -EINVAL;
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
>> +	else
>> +		/*
>> +		 * It is good to print this out here to debug any later failures
>> +		 * related to gear switch.
>> +		 */
>> +		dev_info(hba->dev, "%s: bRefClkFreq setting to %s succeeded\n",
>> +			__func__, ref_clk_freqs[hba->dev_ref_clk_freq]);
> 
> Why not make this dev_dbg and print always even when there is no update.
> [Sayali] Agreed. Will update in next patchsets.
> 
>> +
>> +out:
>> +	return err;
>> +}
>> +
>> +/**
>>   * ufshcd_probe_hba - probe hba to detect device and initialize
>>   * @hba: per-adapter instance
>>   *
>> @@ -6361,6 +6418,11 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
>>  			"%s: Failed getting max supported power mode\n",
>>  			__func__);
>>  	} else {
>> +		/*
>> +		 * Set the right value to bRefClkFreq before attempting to
>> +		 * switch to HS gears.
>> +		 */
>> +		ufshcd_set_dev_ref_clk(hba, REF_CLK_FREQ_19_2_MHZ);
>>  		ret = ufshcd_config_pwr_mode(hba, &hba->max_pwr_info.info);
>>  		if (ret) {
>>  			dev_err(hba->dev, "%s: Failed setting power mode, err = %d\n", 
>> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h 
>> index 8110dcd..b026ad8 100644
>> --- a/drivers/scsi/ufs/ufshcd.h
>> +++ b/drivers/scsi/ufs/ufshcd.h
>> @@ -548,6 +548,7 @@ struct ufs_hba {
>>  	void *priv;
>>  	unsigned int irq;
>>  	bool is_irq_enabled;
>> +	u32 dev_ref_clk_freq;
>>  
>>  	/* Interrupt aggregation support is broken */
>>  	#define UFSHCD_QUIRK_BROKEN_INTR_AGGR			0x1
>>
> 
> 
> 

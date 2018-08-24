From: Sayali Lokhande <sayalil@codeaurora.org>
Subject: Re: [PATCH V9 1/2] scsi: ufs: set the device reference clock setting
Date: Fri, 24 Aug 2018 10:54:00 +0530
Message-ID: <73519148-aa7e-2bc4-bf12-3efbe8367efe@codeaurora.org>
References: <1534846649-2456-1-git-send-email-sayalil@codeaurora.org>
 <1534846649-2456-2-git-send-email-sayalil@codeaurora.org>
 <CAE=gft6tA=B008oS-TP2e-aJ80ZQT_tF3Ngf6Ly5f5r=QqpBng@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAE=gft6tA=B008oS-TP2e-aJ80ZQT_tF3Ngf6Ly5f5r=QqpBng@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Evan Green <evgreen@chromium.org>
Cc: subhashj@codeaurora.org, cang@codeaurora.org, vivek.gautam@codeaurora.org, Rajendra Nayak <rnayak@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, asutoshd@codeaurora.org, riteshh@codeaurora.org, adrian.hunter@intel.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


On 8/23/2018 10:49 PM, Evan Green wrote:
> On Tue, Aug 21, 2018 at 3:18 AM Sayali Lokhande <sayalil@codeaurora.org> wrote:
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
>>   drivers/scsi/ufs/ufs.h    | 14 ++++++++
>>   drivers/scsi/ufs/ufshcd.c | 92 +++++++++++++++++++++++++++++++++++++++++++++++
>>   drivers/scsi/ufs/ufshcd.h |  2 ++
>>   3 files changed, 108 insertions(+)
>>
>> diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
>> index 14e5bf7..a2e76b1 100644
>> --- a/drivers/scsi/ufs/ufs.h
>> +++ b/drivers/scsi/ufs/ufs.h
>> @@ -378,6 +378,20 @@ enum query_opcode {
>>          UPIU_QUERY_OPCODE_TOGGLE_FLAG   = 0x8,
>>   };
>>
>> +/* bRefClkFreq attribute values */
>> +enum ufs_ref_clk_freq {
>> +       REF_CLK_FREQ_19_2_MHZ   = 0,
>> +       REF_CLK_FREQ_26_MHZ     = 1,
>> +       REF_CLK_FREQ_38_4_MHZ   = 2,
>> +       REF_CLK_FREQ_52_MHZ     = 3,
>> +       REF_CLK_FREQ_INVAL      = -1,
>> +};
>> +
>> +struct ufs_ref_clk {
>> +       u32 freq_hz;
>> +       enum ufs_ref_clk_freq val;
>> +};
>> +
>>   /* Query response result code */
>>   enum {
>>          QUERY_RESULT_SUCCESS                    = 0x00,
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> index c5b1bf1..e946844 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -6296,6 +6296,91 @@ static void ufshcd_def_desc_sizes(struct ufs_hba *hba)
>>          hba->desc_size.hlth_desc = QUERY_DESC_HEALTH_DEF_SIZE;
>>   }
>>
>> +static struct ufs_ref_clk ufs_ref_clk_freqs[] = {
>> +       {19200000, REF_CLK_FREQ_19_2_MHZ},
>> +       {26000000, REF_CLK_FREQ_26_MHZ},
>> +       {38400000, REF_CLK_FREQ_38_4_MHZ},
>> +       {52000000, REF_CLK_FREQ_52_MHZ},
>> +       {0, REF_CLK_FREQ_INVAL},
>> +};
>> +
>> +static inline enum ufs_ref_clk_freq
>> +ufs_get_bref_clk_for_ref_clk_freq_hz(u32 freq)
> This name is a little hairy. Maybe ufs_get_bref_clk_from_hz, or
> ufs_hz_to_bref_clk?
Done.  ufs_get_bref_clk_from_hz() sounds good. Will update.
>> +{
>> +       int i = 0;
>> +
>> +       while (ufs_ref_clk_freqs[i].freq_hz != freq) {
>> +               if (!ufs_ref_clk_freqs[i].freq_hz)
>> +                       return REF_CLK_FREQ_INVAL;
>> +               i++;
>> +       }
>> +
>> +       return ufs_ref_clk_freqs[i].val;
>> +}
>> +
>> +void ufshcd_parse_dev_ref_clk_freq(struct ufs_hba *hba)
>> +{
>> +       struct device *dev = hba->dev;
>> +       struct device_node *np = dev->of_node;
>> +       struct clk *refclk = NULL;
>> +       u32 freq = 0;
>> +
>> +       if (!np)
>> +               return;
>> +
>> +       hba->dev_ref_clk_freq = REF_CLK_FREQ_INVAL;
>> +
>> +       refclk = of_clk_get_by_name(np, "ref_clk");
>> +       if (!refclk)
>> +               return;
>> +
>> +       freq = clk_get_rate(refclk);
>> +       if (freq > REF_CLK_FREQ_52_MHZ) {
> freq is in Hertz, but the enum value will be something like 3. I think
> you should just call your function below, and then check the return
> value of it for the error case you're trying to do here.
Agree. I should be checking hba->dev_ref_clk_freq instead of freq (which 
is in hz). Will update.
>> +               dev_err(hba->dev,
>> +               "%s: invalid ref_clk setting = %d\n",
>> +               __func__, freq);
>> +               return;
>> +       }
>> +
>> +       hba->dev_ref_clk_freq =
>> +               ufs_get_bref_clk_for_ref_clk_freq_hz(freq);
>> +}
>> +
>> +static int ufshcd_set_dev_ref_clk(struct ufs_hba *hba)
>> +{
>> +       int err = 0;
> You don't need to initialize this since you immediately assign it below.
Done.
>> +       int ref_clk = -1;
>> +       u32 freq = (u32)hba->dev_ref_clk_freq;
> Is the cast necessary?
Not necessary. Will be removed.
>> +
>> +       err = ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_READ_ATTR,
>> +                       QUERY_ATTR_IDN_REF_CLK_FREQ, 0, 0, &ref_clk);
>> +
>> +       if (err) {
>> +               dev_err(hba->dev, "%s: failed reading bRefClkFreq. err = %d\n",
>> +                        __func__, err);
>> +               goto out;
>> +       }
>> +
>> +       if (ref_clk == hba->dev_ref_clk_freq)
>> +               goto out; /* nothing to update */
>> +
>> +       err = ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
>> +                       QUERY_ATTR_IDN_REF_CLK_FREQ, 0, 0, &freq);
>> +
>> +       if (err)
>> +               dev_err(hba->dev, "%s: bRefClkFreq setting to %u Hz failed\n",
>> +               __func__, ufs_ref_clk_freqs[freq].freq_hz);
>> +       /*
>> +        * It is good to print this out here to debug any later failures
>> +        * related to gear switch.
>> +        */
>> +       dev_dbg(hba->dev, "%s: bRefClkFreq setting to %u Hz succeeded\n",
>> +               __func__, ufs_ref_clk_freqs[freq].freq_hz);
> In the error case you print out both the failed message and the success message?
Agree. Will add goto out; in error case above.
>> +
>> +out:
>> +       return err;
>> +}
>> +
>>   /**
>>    * ufshcd_probe_hba - probe hba to detect device and initialize
>>    * @hba: per-adapter instance
>> @@ -6361,6 +6446,12 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
>>                          "%s: Failed getting max supported power mode\n",
>>                          __func__);
>>          } else {
>> +               /*
>> +                * Set the right value to bRefClkFreq before attempting to
>> +                * switch to HS gears.
>> +                */
>> +               if (hba->dev_ref_clk_freq != REF_CLK_FREQ_INVAL)
>> +                       ufshcd_set_dev_ref_clk(hba);
>>                  ret = ufshcd_config_pwr_mode(hba, &hba->max_pwr_info.info);
>>                  if (ret) {
>>                          dev_err(hba->dev, "%s: Failed setting power mode, err = %d\n",
>> @@ -7693,6 +7784,7 @@ int ufshcd_alloc_host(struct device *dev, struct ufs_hba **hba_handle)
>>
>>          INIT_LIST_HEAD(&hba->clk_list_head);
>>
>> +       ufshcd_parse_dev_ref_clk_freq(hba);
> I get an uncomfortable feeling about calling this function from
> alloc_host, given that everybody else calls their parse functions from
> ufshcd_pltfrm_init. I wonder if you should just initialize the new
> member here in alloc_host to the invalid value, and then move the call
> to the parse function where you had it before in ufshcd_pltfrm_init.
> That way you don't have the problems in the previous series with
> leaving the value uninitialized, but you're also not calling of_
> functions from alloc_host, which seems like an abuse of alloc_host.
Agree. Will only initialize the ref_clk in alloc_host() and move the 
actual parse() call in pltfrm_init as before.
> -Evan

From: cang@codeaurora.org
Subject: Re: [PATCH v2 1/1] scsi: ufs: make UFS Tx lane1 clock optional for
 QCOM platforms
Date: Fri, 12 Oct 2018 08:55:25 +0800
Message-ID: <0f371e5e2cd1fe47834560a5072c0581@codeaurora.org>
References: <1539261196-14550-1-git-send-email-cang@codeaurora.org>
 <CAD=FV=VSyJAna4JwLXJi1=Z_Y1mzr8cW4iD+vJLPU2GASP3wQA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAD=FV=VSyJAna4JwLXJi1=Z_Y1mzr8cW4iD+vJLPU2GASP3wQA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Anderson <dianders@chromium.org>
Cc: subhashj@codeaurora.org, Asutosh Das <asutoshd@codeaurora.org>, Vivek Gautam <vivek.gautam@codeaurora.org>, Evan Green <evgreen@chromium.org>, Rajendra Nayak <rnayak@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, jejb@linux.vnet.ibm.com, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-arm-msm <linux-arm-msm@vger.kernel.org>, venkatg@codeaurora.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Doug,

On 2018-10-12 04:21, Doug Anderson wrote:
> Hi,
> 
> On Thu, Oct 11, 2018 at 5:33 AM Can Guo <cang@codeaurora.org> wrote:
>>  static int ufs_qcom_host_clk_get(struct device *dev,
>> -               const char *name, struct clk **clk_out)
>> +               const char *name, struct clk **clk_out, bool optional)
>>  {
>>         struct clk *clk;
>>         int err = 0;
>> 
>>         clk = devm_clk_get(dev, name);
>> -       if (IS_ERR(clk)) {
>> +       if (clk == ERR_PTR(-EPROBE_DEFER)) {
>> +               err = -EPROBE_DEFER;
>> +               dev_warn(dev, "required clock %s hasn't probed yet, 
>> err %d\n",
>> +                               name, err);
>> +       } else if (IS_ERR(clk)) {
>> +               if (optional)
>> +                       return 0;
> 
> Change this function to:
> 
> static int ufs_qcom_host_clk_get(struct device *dev,
>     const char *name, struct clk **clk_out, bool optional)
> {
>   struct clk *clk;
>   int err;
> 
>   clk = devm_clk_get(dev, name);
>   if (!IS_ERR(clk)) {
>     *clk_out = clk;
>     return 0;
>   }
> 
>   err = PTR_ERR(clk);
> 
>   if (optional && err == -ENOENT) {
>     *clk_out = NULL;
>     return 0;
>   }
> 
>   if (err != -EPROBE_DEFER)
>     dev_err(dev, "failed to get %s err %d",
>         name, err);
> 
>   return err;
> }
> 
> Specifically:
> 
> * Typically it just spams the log to print something when you see an
> -EPROBE_DEFER.
> 
> * If a clock is optional you should only consider things a success
> only if "-ENOENT" was returned.  All other errors should be considered
> fatal.
> 
> * If a clock is optional it's slightly cleaner to set *clk_out to
> NULL.  I know you're initting global data that happened to already be
> NULL by default, but it still feels nice for the abstraction of the
> function to do this.
> 
> * Please don't pass __func__ to your error messages.
> 
> 

Thank you for the detailed instructions. Shall make the change like so.

>>                 err = PTR_ERR(clk);
>>                 dev_err(dev, "%s: failed to get %s err %d",
>>                                 __func__, name, err);
>> @@ -113,10 +119,10 @@ static void ufs_qcom_disable_lane_clks(struct 
>> ufs_qcom_host *host)
>>         if (!host->is_lane_clks_enabled)
>>                 return;
>> 
>> -       if (host->hba->lanes_per_direction > 1)
>> +       if (host->tx_l1_sync_clk)
> 
> Remove this "if".  Always call clk_disable_unprepare() which will be a
> no-op if "host->tx_l1_sync_clk" is NULL.  clk_disable_unprepare() is a
> no-op for NULL clocks by design specifically to make code like this
> cleaner.
> 
> 

Shall do.

>>                 clk_disable_unprepare(host->tx_l1_sync_clk);
>>         clk_disable_unprepare(host->tx_l0_sync_clk);
>> -       if (host->hba->lanes_per_direction > 1)
>> +       if (host->rx_l1_sync_clk)
> 
> Remove this "if".  Always call clk_disable_unprepare() which will be a
> no-op if "host->rx_l1_sync_clk" is NULL.  clk_disable_unprepare() is a
> no-op for NULL clocks by design specifically to make code like this
> cleaner.
> 
> 

Shall do.

>>                 clk_disable_unprepare(host->rx_l1_sync_clk);
>>         clk_disable_unprepare(host->rx_l0_sync_clk);
>> 
>> @@ -141,12 +147,14 @@ static int ufs_qcom_enable_lane_clks(struct 
>> ufs_qcom_host *host)
>>         if (err)
>>                 goto disable_rx_l0;
>> 
>> -       if (host->hba->lanes_per_direction > 1) {
>> +       if (host->rx_l1_sync_clk) {
> 
> Remove this "if".  Always call ufs_qcom_host_clk_enable().  The
> clk_prepare_enable() inside ufs_qcom_host_clk_enable() will be a no-op
> if "host->rx_l1_sync_clk" is NULL and will return 0 (no error).
> 
> 

Shall do so.

>>                 err = ufs_qcom_host_clk_enable(dev, 
>> "rx_lane1_sync_clk",
>>                         host->rx_l1_sync_clk);
>>                 if (err)
>>                         goto disable_tx_l0;
>> +       }
>> 
>> +       if (host->tx_l1_sync_clk) {
> 
> Remove this "if".  Always call ufs_qcom_host_clk_enable().  The
> clk_prepare_enable() inside ufs_qcom_host_clk_enable() will be a no-op
> if "host->tx_l1_sync_clk" is NULL and will return 0 (no error).
> 
> 
> -Doug

Shall do so. Thank you.

-Can Guo

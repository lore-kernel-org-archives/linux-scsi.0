From: Rajendra Nayak <rnayak@codeaurora.org>
Subject: Re: [RFC v2 02/11] OPP: Make dev_pm_opp_set_rate() with freq=0 as
 valid
Date: Mon, 17 Jun 2019 09:34:06 +0530
Message-ID: <37e7ff9e-6bfa-585e-1ca6-f8e079dd0aef@codeaurora.org>
References: <20190320094918.20234-1-rnayak@codeaurora.org>
 <20190320094918.20234-3-rnayak@codeaurora.org>
 <20190614063210.lfsquoycronah3fe@vireshk-i7>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190614063210.lfsquoycronah3fe@vireshk-i7>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-pm@vger.kernel.org, linux-serial@vger.kernel.org, linux-spi@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-scsi@vger.kernel.org, swboyd@chromium.org, ulf.hansson@linaro.org, dianders@chromium.org, rafael@kernel.org
List-Id: linux-scsi@vger.kernel.org



On 6/14/2019 12:02 PM, Viresh Kumar wrote:
> On 20-03-19, 15:19, Rajendra Nayak wrote:
>> For devices with performance state, we use dev_pm_opp_set_rate()
>> to set the appropriate clk rate and the performance state.
>> We do need a way to *remove* the performance state vote when
>> we idle the device and turn the clocks off. Use dev_pm_opp_set_rate()
>> with freq=0 to achieve this.
>>
>> Signed-off-by: Rajendra Nayak <rnayak@codeaurora.org>
>> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
>> ---
>>   drivers/opp/core.c | 18 ++++++++++++------
>>   1 file changed, 12 insertions(+), 6 deletions(-)
> 
> What about this instead ?

yes, this works, thanks for updating the patch.

> 
> diff --git a/drivers/opp/core.c b/drivers/opp/core.c
> index 2fe96c2363a3..9accf8bb6afc 100644
> --- a/drivers/opp/core.c
> +++ b/drivers/opp/core.c
> @@ -711,7 +711,7 @@ static int _set_required_opps(struct device *dev,
>   
>          /* Single genpd case */
>          if (!genpd_virt_devs) {
> -               pstate = opp->required_opps[0]->pstate;
> +               pstate = likely(opp) ? opp->required_opps[0]->pstate : 0;
>                  ret = dev_pm_genpd_set_performance_state(dev, pstate);
>                  if (ret) {
>                          dev_err(dev, "Failed to set performance state of %s: %d (%d)\n",
> @@ -729,7 +729,7 @@ static int _set_required_opps(struct device *dev,
>          mutex_lock(&opp_table->genpd_virt_dev_lock);
>   
>          for (i = 0; i < opp_table->required_opp_count; i++) {
> -               pstate = opp->required_opps[i]->pstate;
> +               pstate = likely(opp) ? opp->required_opps[i]->pstate : 0;
>   
>                  if (!genpd_virt_devs[i])
>                          continue;
> @@ -770,14 +770,13 @@ int dev_pm_opp_set_rate(struct device *dev, unsigned long target_freq)
>   
>          if (unlikely(!target_freq)) {
>                  if (opp_table->required_opp_tables) {
> -                       /* drop the performance state vote */
> -                       dev_pm_genpd_set_performance_state(dev, 0);
> -                       return 0;
> +                       ret = _set_required_opps(dev, opp_table, NULL);
>                  } else {
> -                       dev_err(dev, "%s: Invalid target frequency %lu\n", __func__,
> -                               target_freq);
> -                       return -EINVAL;
> +                       dev_err(dev, "target frequency can't be 0\n");
> +                       ret = -EINVAL;
>                  }
> +
> +               goto put_opp_table;
>          }
>   
>          clk = opp_table->clk;
> 

-- 
QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation

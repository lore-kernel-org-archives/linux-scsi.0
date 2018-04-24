From: Chanwoo Choi <cw00.choi@samsung.com>
Subject: Re: [PATCH 1/3] PM / devfreq: Actually support providing freq_table
Date: Tue, 24 Apr 2018 11:48:06 +0900
Message-ID: <5ADE9AE6.9090601@samsung.com>
References: <20180424002016.9205-1-bjorn.andersson@linaro.org>
        <CGME20180424002041epcas5p11439bec6de910c2a465c5cf3acb45a3b@epcas5p1.samsung.com>
        <20180424002016.9205-2-bjorn.andersson@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <20180424002016.9205-2-bjorn.andersson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Bjorn Andersson <bjorn.andersson@linaro.org>, MyungJoo Ham <myungjoo.ham@samsung.com>, Kyungmin Park <kyungmin.park@samsung.com>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org, Vivek Gautam <vivek.gautam@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

Hi,

On 2018년 04월 24일 09:20, Bjorn Andersson wrote:
> The code in devfreq_add_device() handles the case where a freq_table is
> passed by the client, but then requests min and max frequences from
> the, in this case absent, opp tables.
> 
> Read the min and max frequencies from the frequency table, which has
> been built from the opp table if one exists, instead of querying the
> opp table.
> 
> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> ---
> 
> An alternative approach is to clarify in the devfreq code that it's not
> possible to pass a freq_table and then in patch 3 create an opp table for the
> device in runtime; although the error handling of this becomes non-trivial.
> 
> Transitioning the UFSHCD to use opp tables directly is hindered by the fact
> that the Qualcomm UFS hardware has two different clocks that needs to be
> running at different rates, so we would need a way to describe the two rates in
> the opp table. (And would force us to change the DT binding)
> 
>  drivers/devfreq/devfreq.c | 22 ++++------------------
>  1 file changed, 4 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
> index fe2af6aa88fc..086ced50a13d 100644
> --- a/drivers/devfreq/devfreq.c
> +++ b/drivers/devfreq/devfreq.c
> @@ -74,30 +74,16 @@ static struct devfreq *find_device_devfreq(struct device *dev)
>  
>  static unsigned long find_available_min_freq(struct devfreq *devfreq)
>  {
> -	struct dev_pm_opp *opp;
> -	unsigned long min_freq = 0;
> -
> -	opp = dev_pm_opp_find_freq_ceil(devfreq->dev.parent, &min_freq);
> -	if (IS_ERR(opp))
> -		min_freq = 0;
> -	else
> -		dev_pm_opp_put(opp);
> +	struct devfreq_dev_profile *profile = devfreq->profile;
>  
> -	return min_freq;
> +	return profile->freq_table[0];

It is wrong. The thermal framework support the devfreq-cooling device
which uses the dev_pm_opp_enable/disable().

In order to find the correct available min frequency,
the devfreq have to use the OPP function instead of using the first entry
of the freq_table array.

>  }
>  
>  static unsigned long find_available_max_freq(struct devfreq *devfreq)
>  {
> -	struct dev_pm_opp *opp;
> -	unsigned long max_freq = ULONG_MAX;
> -
> -	opp = dev_pm_opp_find_freq_floor(devfreq->dev.parent, &max_freq);
> -	if (IS_ERR(opp))
> -		max_freq = 0;
> -	else
> -		dev_pm_opp_put(opp);
> +	struct devfreq_dev_profile *profile = devfreq->profile;
>  
> -	return max_freq;
> +	return profile->freq_table[profile->max_state - 1];
>  }

ditto.

>  
>  /**
> 


-- 
Best Regards,
Chanwoo Choi
Samsung Electronics

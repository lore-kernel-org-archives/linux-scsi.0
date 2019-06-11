From: Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [RFC v2 01/11] OPP: Don't overwrite rounded clk rate
Date: Tue, 11 Jun 2019 16:24:32 +0530
Message-ID: <20190611105432.x3nzqiib35t6mvyg@vireshk-i7>
References: <20190320094918.20234-1-rnayak@codeaurora.org>
 <20190320094918.20234-2-rnayak@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190320094918.20234-2-rnayak@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: swboyd@chromium.org, Rajendra Nayak <rnayak@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-pm@vger.kernel.org, linux-serial@vger.kernel.org, linux-spi@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-scsi@vger.kernel.org, ulf.hansson@linaro.org, dianders@chromium.org, rafael@kernel.org
List-Id: linux-scsi@vger.kernel.org

On 20-03-19, 15:19, Rajendra Nayak wrote:
> From: Stephen Boyd <swboyd@chromium.org>
> 
> Doing this allows us to call this API with any rate requested and have
> it not need to match in the OPP table. Instead, we'll round the rate up
> to the nearest OPP that we see so that we can get the voltage or level
> that's required for that OPP. This supports users of OPP that want to
> specify the 'fmax' tables of a device instead of every single frequency
> that they need. And for devices that required the exact frequency, we
> can rely on the clk framework to round the rate to the nearest supported
> frequency instead of the OPP framework to do so.
> 
> Note that this may affect drivers that don't want the clk framework to
> do rounding, but instead want the OPP table to do the rounding for them.
> Do we have that case? Should we add some flag to the OPP table to
> indicate this and then not have that flag set when there isn't an OPP
> table for the device and also introduce a property like 'opp-use-clk' to
> tell the table that it should use the clk APIs to round rates instead of
> OPP?
> 
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> Signed-off-by: Rajendra Nayak <rnayak@codeaurora.org>
> ---
>  drivers/opp/core.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/opp/core.c b/drivers/opp/core.c
> index 0420f7e8ad5b..bc9a7762dd4c 100644
> --- a/drivers/opp/core.c
> +++ b/drivers/opp/core.c
> @@ -703,7 +703,7 @@ static int _set_required_opps(struct device *dev,
>  int dev_pm_opp_set_rate(struct device *dev, unsigned long target_freq)
>  {
>  	struct opp_table *opp_table;
> -	unsigned long freq, old_freq;
> +	unsigned long freq, opp_freq, old_freq, old_opp_freq;
>  	struct dev_pm_opp *old_opp, *opp;
>  	struct clk *clk;
>  	int ret;
> @@ -742,13 +742,15 @@ int dev_pm_opp_set_rate(struct device *dev, unsigned long target_freq)
>  		goto put_opp_table;
>  	}
>  
> -	old_opp = _find_freq_ceil(opp_table, &old_freq);
> +	old_opp_freq = old_freq;
> +	old_opp = _find_freq_ceil(opp_table, &old_opp_freq);
>  	if (IS_ERR(old_opp)) {
>  		dev_err(dev, "%s: failed to find current OPP for freq %lu (%ld)\n",
>  			__func__, old_freq, PTR_ERR(old_opp));
>  	}
>  
> -	opp = _find_freq_ceil(opp_table, &freq);
> +	opp_freq = freq;
> +	opp = _find_freq_ceil(opp_table, &opp_freq);
>  	if (IS_ERR(opp)) {
>  		ret = PTR_ERR(opp);
>  		dev_err(dev, "%s: failed to find OPP for freq %lu (%d)\n",

I see a logical problem with this patch.

Suppose the clock driver supports following frequencies: 500M, 800M,
1G, 1.2G and the OPP table contains following list: 500M, 1G, 1.2G
(i.e. missing 800M).

Now 800M should never get programmed as it isn't part of the OPP
table. But if you pass 600M to opp-set-rate, then it will end up
selecting 800M as clock driver will round up to the closest value.

Even if no one is doing this right now, it is a sensible usecase,
specially during testing of patches and I don't think we should avoid
it.

What exactly is the use case for which we need this patch ? What kind
of driver ? Some detail can be helpful to find another solution that
fixes this problem.

-- 
viresh

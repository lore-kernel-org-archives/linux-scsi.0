From: Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: Re: [PATCH 1/3] PM / devfreq: Actually support providing freq_table
Date: Tue, 24 Apr 2018 11:48:38 -0700
Message-ID: <20180424184838.GD18510@minitux>
References: <20180424052916.GD2052@tuxbook-pro>
 <20180424002016.9205-1-bjorn.andersson@linaro.org>
 <20180424002016.9205-2-bjorn.andersson@linaro.org>
 <5ADE9AE6.9090601@samsung.com>
 <CGME20180424002041epcas5p11439bec6de910c2a465c5cf3acb45a3b@epcms1p5>
 <529236451.01524550500717.JavaMail.epsvc@epcpmgr01>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <529236451.01524550500717.JavaMail.epsvc@epcpmgr01>
Sender: linux-kernel-owner@vger.kernel.org
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: Chanwoo Choi <cw00.choi@samsung.com>, Kyungmin Park <kyungmin.park@samsung.com>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>, Vivek Gautam <vivek.gautam@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

On Mon 23 Apr 23:09 PDT 2018, MyungJoo Ham wrote:

> >On Mon 23 Apr 19:48 PDT 2018, Chanwoo Choi wrote:
> >
> >> Hi,
> >> 
> >> On 2018??? 04??? 24??? 09:20, Bjorn Andersson wrote:
> >> > The code in devfreq_add_device() handles the case where a freq_table is
> >> > passed by the client, but then requests min and max frequences from
> >> > the, in this case absent, opp tables.
> >> > 
> >> > Read the min and max frequencies from the frequency table, which has
> >> > been built from the opp table if one exists, instead of querying the
> >> > opp table.
> >> > 
> >> > Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> >> > ---
> >> > 
> >> > An alternative approach is to clarify in the devfreq code that it's not
> >> > possible to pass a freq_table and then in patch 3 create an opp table for the
> >> > device in runtime; although the error handling of this becomes non-trivial.
> >> > 
> >> > Transitioning the UFSHCD to use opp tables directly is hindered by the fact
> >> > that the Qualcomm UFS hardware has two different clocks that needs to be
> >> > running at different rates, so we would need a way to describe the two rates in
> >> > the opp table. (And would force us to change the DT binding)
> >> > 
> >> >  drivers/devfreq/devfreq.c | 22 ++++------------------
> >> >  1 file changed, 4 insertions(+), 18 deletions(-)
> >> > 
> >> > diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
> >> > index fe2af6aa88fc..086ced50a13d 100644
> >> > --- a/drivers/devfreq/devfreq.c
> >> > +++ b/drivers/devfreq/devfreq.c
> >> > @@ -74,30 +74,16 @@ static struct devfreq *find_device_devfreq(struct device *dev)
> >> >  
> >> >  static unsigned long find_available_min_freq(struct devfreq *devfreq)
> >> >  {
> >> > -	struct dev_pm_opp *opp;
> >> > -	unsigned long min_freq = 0;
> >> > -
> >> > -	opp = dev_pm_opp_find_freq_ceil(devfreq->dev.parent, &min_freq);
> >> > -	if (IS_ERR(opp))
> >> > -		min_freq = 0;
> >> > -	else
> >> > -		dev_pm_opp_put(opp);
> >> > +	struct devfreq_dev_profile *profile = devfreq->profile;
> >> >  
> >> > -	return min_freq;
> >> > +	return profile->freq_table[0];
> >> 
> >> It is wrong. The thermal framework support the devfreq-cooling device
> >> which uses the dev_pm_opp_enable/disable().
> >> 
> >
> >Okay, that makes sense. So rather than registering a custom freq_table I
> >should register the min and max frequency using dev_pm_opp_add().
> >
> >> In order to find the correct available min frequency,
> >> the devfreq have to use the OPP function instead of using the first entry
> >> of the freq_table array.
> >> 
> >
> >Based on this there seems to be room for cleaning out the freq_table
> >from devfreq, to reduce the confusion. I will review this further.
> 
> Could you please check if the bug suffering you gets resolved by
> replacing 0 with ULONG_MAX in the function find_available_max_freq?
> 
> -                max_freq = 0;
> +                max_freq = ULONG_MAX;
> 
> Even if you are not using OPP, these functions should provide somewhat
> "compatible" values.
> 

I also need to make set_freq_table() handle the case where there is no
opp table and change a min_freq of 0 from being treated as an error.

With this I think we're back at supporting using devfreq without
specifying any available frequencies. I am however uncertain if this
should be considered valid use of devfreq.

Regards,
Bjorn

From: Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: Re: [PATCH 1/3] PM / devfreq: Actually support providing freq_table
Date: Tue, 24 Apr 2018 11:38:59 -0700
Message-ID: <20180424183859.GC18510@minitux>
References: <20180424002016.9205-1-bjorn.andersson@linaro.org>
 <CGME20180424002041epcas5p11439bec6de910c2a465c5cf3acb45a3b@epcas5p1.samsung.com>
 <20180424002016.9205-2-bjorn.andersson@linaro.org>
 <5ADE9AE6.9090601@samsung.com>
 <20180424052916.GD2052@tuxbook-pro>
 <5ADEDC1A.2000101@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5ADEDC1A.2000101@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>, Kyungmin Park <kyungmin.park@samsung.com>, Vinayak Holikatti <vinholikatti@gmail.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org, Vivek Gautam <vivek.gautam@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

On Tue 24 Apr 00:26 PDT 2018, Chanwoo Choi wrote:

> Hi,
> 
> On 2018??? 04??? 24??? 14:29, Bjorn Andersson wrote:
> > On Mon 23 Apr 19:48 PDT 2018, Chanwoo Choi wrote:
> > 
> >> Hi,
> >>
> >> On 2018??? 04??? 24??? 09:20, Bjorn Andersson wrote:
> >>> The code in devfreq_add_device() handles the case where a freq_table is
> >>> passed by the client, but then requests min and max frequences from
> >>> the, in this case absent, opp tables.
> >>>
> >>> Read the min and max frequencies from the frequency table, which has
> >>> been built from the opp table if one exists, instead of querying the
> >>> opp table.
> >>>
> >>> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> >>> ---
> >>>
> >>> An alternative approach is to clarify in the devfreq code that it's not
> >>> possible to pass a freq_table and then in patch 3 create an opp table for the
> >>> device in runtime; although the error handling of this becomes non-trivial.
> >>>
> >>> Transitioning the UFSHCD to use opp tables directly is hindered by the fact
> >>> that the Qualcomm UFS hardware has two different clocks that needs to be
> >>> running at different rates, so we would need a way to describe the two rates in
> >>> the opp table. (And would force us to change the DT binding)
> >>>
> >>>  drivers/devfreq/devfreq.c | 22 ++++------------------
> >>>  1 file changed, 4 insertions(+), 18 deletions(-)
> >>>
> >>> diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
> >>> index fe2af6aa88fc..086ced50a13d 100644
> >>> --- a/drivers/devfreq/devfreq.c
> >>> +++ b/drivers/devfreq/devfreq.c
> >>> @@ -74,30 +74,16 @@ static struct devfreq *find_device_devfreq(struct device *dev)
> >>>  
> >>>  static unsigned long find_available_min_freq(struct devfreq *devfreq)
> >>>  {
> >>> -	struct dev_pm_opp *opp;
> >>> -	unsigned long min_freq = 0;
> >>> -
> >>> -	opp = dev_pm_opp_find_freq_ceil(devfreq->dev.parent, &min_freq);
> >>> -	if (IS_ERR(opp))
> >>> -		min_freq = 0;
> >>> -	else
> >>> -		dev_pm_opp_put(opp);
> >>> +	struct devfreq_dev_profile *profile = devfreq->profile;
> >>>  
> >>> -	return min_freq;
> >>> +	return profile->freq_table[0];
> >>
> >> It is wrong. The thermal framework support the devfreq-cooling device
> >> which uses the dev_pm_opp_enable/disable().
> >>
> > 
> > Okay, that makes sense. So rather than registering a custom freq_table I
> > should register the min and max frequency using dev_pm_opp_add().
> 
> Thanks.
> 
> > 
> >> In order to find the correct available min frequency,
> >> the devfreq have to use the OPP function instead of using the first entry
> >> of the freq_table array.
> >>
> > 
> > Based on this there seems to be room for cleaning out the freq_table
> > from devfreq, to reduce the confusion. I will review this further.
> 
> Actually, devfreq must need to have the freq_table[] array. But, freq_table[]
> array should be handled in the devfreq core. Now, the devfreq device drivers can
> touch the freq_table. I think it is not good.
> 
> There is a reason why we have to maintain the freq_table[] as the internal variable.
> OPP doesn't provide the OPP API which get the all registered frequencies.
> If devfreq-cooling device disables the specific frequency by using dev_pm_oppdisable(),
> the user of OPP interface can not get the disabled frequency list.
> So, I maintain the freq_table even if using the OPP interface.
> 

Thanks for the clarification, I see some possibilities for improving
this but it makes sense.

> And, devfreq-cooling device uses the freq_table directly because
> released MALi driver from ARM initializes the freq_table list
> directly.
> 

Forgive me if I misunderstand this, but isn't this exactly what I'm
trying to do in patch 3? Which stopped working back in v4.15-rc1, with
the introduction of f1d981eaecf8 ("PM / devfreq: Use the available
min/max frequency").

> I have no any objection for refactoring. Just I'm sharing the issue
> and current status.
> 

Thanks for sharing the current status and helping me understand how to
properly use devfreq.

Regards,
Bjorn

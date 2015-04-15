From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
Subject: Re: [PATCH 2/5] ufs: Rename of regulator_set_optimum_mode
Date: Wed, 15 Apr 2015 11:35:16 -0700
Message-ID: <20150415183516.GC29061@sonymobile.com>
References: <1423712131-23795-1-git-send-email-bjorn.andersson@sonymobile.com>
 <1423712131-23795-3-git-send-email-bjorn.andersson@sonymobile.com>
 <CAC5umyisp-aWU1mGajCCwS5yxaJvqh1UHUACEXb2ixHk5_+fJA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-arm-msm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAC5umyisp-aWU1mGajCCwS5yxaJvqh1UHUACEXb2ixHk5_+fJA@mail.gmail.com>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Mark Brown <broonie@kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue 14 Apr 05:11 PDT 2015, Akinobu Mita wrote:

> 2015-02-12 12:35 GMT+09:00 Bjorn Andersson <bjorn.andersson@sonymobile.com>:
> > The function regulator_set_optimum_mode() is changing name to
> > regulator_set_load(), so update the code accordingly. Also cleaned up
> > ufshcd_config_vreg_load() while touching the code.
> >
> > Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>

[..]

> >  static inline int ufshcd_config_vreg_hpm(struct ufs_hba *hba,
> >                                          struct ufs_vreg *vreg)
> >  {
> > -       if (!vreg)
> > -               return 0;
> > -
> >         return ufshcd_config_vreg_load(hba->dev, vreg, vreg->max_uA);
> >  }
> 
> I tried this patch and it caused kernel null pointer dereference with
> 'verg->max_uA' when vreg == NULL.  So you can't simply move !vreg check here
> into ufshcd_config_vreg_load().

Akinobu-san, you're correct, sorry for missing that (and in essence
reverting your commit).

Looks like Linus merged the fix on master, so I will send out a fixup.

Regards,
Bjorn

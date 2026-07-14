Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F357C2D6E5A
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 16:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784047526; cv=pass; b=lqfFSAxPOwPOb6LO1E3URggPPprjEq56b80M6jftiWN5NBf9rTFLHATttNqYvsa6mN/P+ef9NXrVljXUb9h5dcDzOlGubLsAgcRoVDL2uJ329Ud22PIUX71ZCLKdF8pjlVbjEsd5vhZ8Ji2FmkDwqCVNRWTaT8iSJhb7HV0Fqt0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784047526; c=relaxed/simple;
	bh=iku74gWrqS8cAvvSR3MFrnX9bvZiCVWAxU38kO+sO8M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MYdX15rhb6Ygfd4ES4TgGr5di0w2HvZSybei4bJc7m/wP3TRJdBYG3sobzdDl8MksvYKFClTCNOsFqW09l6Z78687149V2Sr6or8GCZ6HXGm10yn1uTFtcskPoJP1pNrUHtS0qa2paVttIab9G9a0ezGlHfMCB1F0COrtQYm8FY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LjAvp85F; arc=pass smtp.client-ip=209.85.128.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LjAvp85F"
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-80cbb0688c8so58647427b3.1
        for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 09:45:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784047524; cv=none;
        d=google.com; s=arc-20260327;
        b=oBKNp2Z4AnCx9LqEOpVi0HIdXjYIHkAvHGRrAW4UqkgLh3K8ZxlNwFG9lXeJ3hmRpj
         Wo/2OfoS98sM8xFW4Q3xIHn5pWDWq1h+XBxURmobpqrMpHrerAS7gFMvZjUi7MYr3A8f
         N/wda/19fzAjQAxZPL4FMHWF3ZO+Wo8Jd9lIdFwYjhxOjeWRJuLuip+bG74spqFMDCWO
         4jcOM2U4fE/jlJF+xE9imaWaeyrJfTM5NpK/ut1Ji31IyD8YOifH4cdd06rKf/B01n91
         IGg4cwnLU6Um3YAqJYeuRiwCyI1a2tOf9UN6pmG0R2fTiaDamhH29oPUfFyI/K7bRb84
         UyMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=jX9wj+vDctF5gHG7/rvQAYqKwcLyeO9HSDbtekAjKmc=;
        fh=XkjfcoMfLOc2oxKNspz0H9mi+uv5mSXpitt2lRt/oAE=;
        b=bkCgsasDtynRgtNMEutsrqZ1NV5ErNNZXigO7mSmO2siBWKRlxIQpXvsGYmQFbZO4j
         YeAdBOOyPZu+YQ5HLN1QFQXJP70qTkl5sYYJuiWe0rezSr/LaXG/rozRNx/OTI8bETQX
         9uk02W7IJPwXzxZWegU2iCFk4UiM6m7pUNi9jNFJzbskrhdFA+5fiiEEk/TnodtDIjqY
         zFUzAjCOB2woLoYBGTmkGqRbUTWSHNMsuUtJuEMrOeeAaQAPOUWJMD5nNtCTLsyK227I
         7Sr1SjuJkI9sC1/y54ngK6scNWD2/jCWCUpuDf+2XuoHu0uviA7BbKho/WWydxRzyvda
         T5JQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784047524; x=1784652324; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jX9wj+vDctF5gHG7/rvQAYqKwcLyeO9HSDbtekAjKmc=;
        b=LjAvp85FvgIn6b5fsZ1Ax8GAJ3S3fAfehzthW/Yjr8MmHiqW9dJEbS13rFQRxVKGNO
         pJI/Ou3WSFg0rSgyF846aOfKyS8z5e1FR6u+O2V+KUZIIB2U6P2IdevaLiHOIIoKQdVd
         zNz6HDAapyGIuc76fnDYShF3OximA1YvGFH4TCNZjg+YNbKEblQHpZw4Z3/OJvRk/mX5
         4n7JSBOu7n3LO9jPqcLDgeFG+hazgDPdpd73NmmsJEtHCWz/rgsmMtOllzrPga2LxYiq
         mWJX4QVtpvnnqusNoTHBGwIrNnCzPVsLTqzbndhYHstV1ckNxNrPAVQUJASAt5rlCe7g
         XAMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784047524; x=1784652324;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=jX9wj+vDctF5gHG7/rvQAYqKwcLyeO9HSDbtekAjKmc=;
        b=kWNCdyFumPyfc9WdFyyLas8TeMQQGOUiIybhRt7xwTZCpQd+S2/vtd3vXYV6gd/3vI
         MBi0+WayIfI41E6uzgS8a0m7nOUpkqaIRxtaNVEeL7pApQxYZLZSQYTCvx9OOf3zh2mM
         VYYEK8VxBIvhLKtc9kHgqyE0Nhwfyh5WM19DrOMK/pbDzpUcI9Wcs1gqmu2kEAGCUZpb
         oyOUGfqfxoZBCK6ouL2OwdXxYv7CuWQaQEdDWe8ls+tRi1AJ7Blhk42+PXj2vTAO5UyS
         D9I9UcDo2rLUJOn5K7jpRN2uLYfURI0hZOBFn4Wu8Ue9ingbbtSGDLRIRYquy/t5U+3h
         XNRQ==
X-Forwarded-Encrypted: i=1; AHgh+Rq8n/0hrhbHTCwnSjG6j9sgO32dU8mw0y6Hf9l1wxwgSwSL/20Qj1a1slTOKNia8h5WUC5yDIDOscoN@vger.kernel.org
X-Gm-Message-State: AOJu0Yx5JFukBUiBHYq1qnIYmQQ1pkJfgphlYvPvYFXY09+2JyP0RsuB
	/upLSWqzHl5a8538veVVGMkOCY0yBFBfSXnXnPC1GVStUmF+6HD/lIca1JlTa6bU3BIG4fOt6V0
	wtw5SZG9xJ/Ak5IJUHy+5FpK5X5L2lfQ=
X-Gm-Gg: AfdE7ckAS/z3X0oj9Qdn9D2GuZBH2T9/tDZ3EqYl4mbK8+SS/iQJhgBPp+54+qDl/tG
	dSzRpXh1hMEJOfUsh8Nk6leXwctATggk404LWo0BfdowihCvy72Iu9XX5qYdJtLl6179st4kmDr
	9AE31UqHceqRwLubnzDRagDeC+woG0UKZLO3quAoFkP09TZt+wyGfnJ125qo1M0HvE6I6Q9gQwU
	rFIaEAvS0Ze3GROuZgl6LYEuRdQbx+bX6N6dGFuYHtCQVvxryPIUncGgJHY/eSTZ0eNf7buxMwu
	KqD7Xf9KWw==
X-Received: by 2002:a05:690c:e0d3:10b0:81e:b7dc:3dce with SMTP id
 00721157ae682-81eb7dc4e77mr30094237b3.63.1784047523912; Tue, 14 Jul 2026
 09:45:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260708124934.764281-1-lgs201920130244@gmail.com>
 <2160d030b5a6414335c84cb89632384866d94e1a.camel@iokpp.de> <3335691dad233520fcc6947545739dccc37a98ec.camel@iokpp.de>
In-Reply-To: <3335691dad233520fcc6947545739dccc37a98ec.camel@iokpp.de>
From: Guangshuo Li <lgs201920130244@gmail.com>
Date: Wed, 15 Jul 2026 00:45:12 +0800
X-Gm-Features: AVVi8Cf62c6IFQb-qwSHH64FPWjXQQ1GiYFyS8epfzywwMUIF1clmM_MKnFD1yA
Message-ID: <CANUHTR81V6-FwiFH3=3OAMuHd9mSL2OcqnXagZqbbx3uYgfsHA@mail.gmail.com>
Subject: Re: [PATCH] scsi: ufs: core: cancel RTC work in active-active suspend
To: Bean Huo <beanhuo@iokpp.de>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@sandisk.com>, 
	Bart Van Assche <bvanassche@acm.org>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Peter Wang <peter.wang@mediatek.com>, 
	Bean Huo <beanhuo@micron.com>, Can Guo <can.guo@oss.qualcomm.com>, 
	Adrian Hunter <adrian.hunter@intel.com>, =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Bean,

On Thu, 9 Jul 2026 at 22:50, Bean Huo <beanhuo@iokpp.de> wrote:
>
> Hi Guangshuo
>
> would you like to update your patch with the consideration of RTC update resume?
>
>
> Kind regard,
> Bean
>
>
> On Wed, 2026-07-08 at 23:04 +0200, Bean Huo wrote:
> > On Wed, 2026-07-08 at 20:49 +0800, Guangshuo Li wrote:
> > > UFS RTC support schedules ufs_rtc_update_work to periodically update the
> > > device RTC. The work can issue query commands and access the UFS host
> > > controller.
> > >
> > > __ufshcd_wl_suspend() cancels ufs_rtc_update_work in the common suspend
> > > path before calling the vendor suspend callback. However, the
> > > active-active path, where both the device power mode and link state stay
> > > active, jumps directly to vops_suspend after flushing exception handling
> > > work. That jump bypasses the RTC work cancellation.
> > >
> > > If the RTC work runs while the vendor suspend callback is gating or
> > > otherwise changing hardware state, it can access the controller during
> > > suspend and trigger an SError.
> > >
> > > Cancel the RTC work in the active-active path before jumping to
> > > vops_suspend, matching the common suspend path.
> > >
> > > Fixes: 6bf999e0eb41 ("scsi: ufs: core: Add UFS RTC support")
> >
> >
> > this fix tag is wrong, should be:
> > Fixes: b0bd84c39289 ("scsi: ufs: core: Fix SError in ufshcd_rtc_work() during
> > UFS suspend")
> >
> > since 6bf999e0eb41 ("scsi: ufs: core: Add UFS RTC support") placed the cancel
> > after the vops_suspend: label (after the POST_CHANGE vops call), so the
> > active-
> > active goto vops_suspend path did cancel the work. then b0bd84c39289 ("scsi:
> > ufs: core: Fix SError in ufshcd_rtc_work() during UFS suspend", moved the
> > cancel
> > up above the PRE_CHANGE vops call to close a race in the common path. That
> > move
> > is what removed cancellation from the active-active path. So the correct tag
> > is
> > Fixes: b0bd84c39289, not 6bf999e0eb41.
> >
> > > Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
> > > ---
> > >  drivers/ufs/core/ufshcd.c | 1 +
> > >  1 file changed, 1 insertion(+)
> > >
> > > diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> > > index d3044a3089b5..9d5571a7aec2 100644
> > > --- a/drivers/ufs/core/ufshcd.c
> > > +++ b/drivers/ufs/core/ufshcd.c
> > > @@ -10269,6 +10269,7 @@ static int __ufshcd_wl_suspend(struct ufs_hba *hba,
> > > enum ufs_pm_op pm_op)
> > >                         req_link_state == UIC_LINK_ACTIVE_STATE) {
> > >                 ufshcd_disable_auto_bkops(hba);
> > >                 flush_work(&hba->eeh_work);
> > > +               cancel_delayed_work_sync(&hba->ufs_rtc_update_work);
> >
> > RTC updates stop permanently after the first active-active suspend. you need
> > to
> > add resume:
> >
> >
> >
> > diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> > index 376a314189e4..06f253b08b65 100644
> > --- a/drivers/ufs/core/ufshcd.c
> > +++ b/drivers/ufs/core/ufshcd.c
> > @@ -10339,6 +10339,7 @@ static int __ufshcd_wl_suspend(struct ufs_hba *hba,
> > enum
> > ufs_pm_op pm_op)
> >                         req_link_state == UIC_LINK_ACTIVE_STATE) {
> >                 ufshcd_disable_auto_bkops(hba);
> >                 flush_work(&hba->eeh_work);
> > +               cancel_delayed_work_sync(&hba->ufs_rtc_update_work);
> >                 goto vops_suspend;
> >         }
> >
> > @@ -10548,10 +10549,11 @@ static int __ufshcd_wl_resume(struct ufs_hba *hba,
> > enum ufs_pm_op pm_op)
> >                 if (ret)
> >                         goto set_old_link_state;
> >                 ufshcd_set_timestamp_attr(hba);
> > -               schedule_delayed_work(&hba->ufs_rtc_update_work,
> > -
> > msecs_to_jiffies(UFS_RTC_UPDATE_INTERVAL_MS));
> >         }
> >
> > +       schedule_delayed_work(&hba->ufs_rtc_update_work,
> > +                             msecs_to_jiffies(UFS_RTC_UPDATE_INTERVAL_MS));
> > +
> >         if (ufshcd_keep_autobkops_enabled_except_suspend(hba))
> >                 ufshcd_enable_auto_bkops(hba);
> >         else
> >
> > Kind regards,
> > Bean
> >
> >
> >
> > >                 goto vops_suspend;
> > >         }
> > >
> >
>

Yes, I will update the patch to fix the Fixes tag and add the RTC work
rescheduling in the resume path.

Thanks for your review and suggestion.

Kind regards,
Guangshuo

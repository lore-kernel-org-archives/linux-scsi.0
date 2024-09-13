Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFA361D3180
	for <linux-scsi@vger.kernel.org>; Fri, 13 Sep 2024 04:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726201729; cv=none; b=d4HzOt9n+9I11sSlJoY4CNtWyYZp7qaAHnfKgbug+pr+5/QzmUCCwCqRvdHouLPJeuSBylntvn6/zgNSd6ILq7jYNyXlzIwAVjQKws3t3SRI7VllUHv2p9r2mTEApX56BnzwBfV2/wWZ9gkR9uoVx+YO5JxVCq3jQKMip9MgdcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726201729; c=relaxed/simple;
	bh=KusBDwUhmXYNVbr5wT6Kx07SJaf4b5aekkBhlWVphDw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ocm2HFtVsB1RIEAOGDg65mXJ79Lpts6tKkCk98whY4CTTUpjCHFmblEshxIetCx71JG1Q62N4azem27sw8BdIyH4DcBThT8vPAnakCB8qzkzuRB+27DBt22wkX0OBAChBMV5JByggmjwOde94Dyep2BQibzkMErHEYkvtPjTGA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=HYu5Si2V; arc=none smtp.client-ip=209.85.128.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="HYu5Si2V"
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-6db4b602e38so3929427b3.1
        for <linux-scsi@vger.kernel.org>; Thu, 12 Sep 2024 21:28:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726201725; x=1726806525; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ilV+VFly+BddHOcgu7zM+rbXi0owQaWaE+7ozG8j1J8=;
        b=HYu5Si2V9wHMJXg37JEYAMpMi4p0xE7k8YBCaZfu4ar9kgCrwllEiyVwwQDN1TzTHE
         6in+IGJPT6X/9YyMULXvO/pgGnsn/KSfwLDeP//uEdQHMOr1t2L6eUA3sB/3dcdRdy5W
         4QcpdFBmLvS9nycLTVeCCOnVZz+0jZmDIzrTJ2ZOF2GpxKPQSROeKPsvUVPduP6usS0T
         4qUVwBH6zQc7tW8N51BKM0VBV4BLatOW4sI7LPmRuyABM4k1jmYZ2H13g/0YJbvKPgcy
         lBYbCeo7qEvCPXJuLAZV6ImOOOC+m6/xl/zV02sA13QzAWWbWis//lFFyL4uhzN1iBR4
         AusQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726201725; x=1726806525;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ilV+VFly+BddHOcgu7zM+rbXi0owQaWaE+7ozG8j1J8=;
        b=FvC/5dTsO4rWnL6hqkaZqR5K7liT3TXiqFfbD6779IkGIW3l/mwBlym59B0scJCqEC
         VfAMDp8X0CipxQv3LdhT9Zmmj3VQNLYHnVE+h3vMSrIQAp36mIXYfwvE/6bQIKhthJKN
         gQJ2/dY1z4+ap0hjnrpW4D9jlQIHAzNFRllwPYuxDdDpwBxwjJQv8L4dHtIwcU3e3uAn
         BZ6hlKQCK1XbisU132Uyw63TryWuwRNKUyoQcYc774gCWsK8nmuMjoPp7ZtBfN0GVnT9
         M70XOnzD1mOywo6/w7/fC96r5nHXaDyLtwMU1UA+znjo7W7JQrs4VUt2ZoYnBGDM9OLi
         0peQ==
X-Forwarded-Encrypted: i=1; AJvYcCUQILxiQ9zt2P6NYRU3Gjv0t0eF35oryPSEIrZ0yi+lUQVm2D0vTScJa68GY58hWd7H8Iiq0+OTcnNp@vger.kernel.org
X-Gm-Message-State: AOJu0YwPaM2aIzvbGuz4VTZje3OpVU3YGtQjhHVeA3NxzxAC79vwCKo5
	7ODxEszTB2Sl7ostEb+2DFlWnrvfHMHIm7SD+4DGQPLithY9qTa/SKKyX43zlyGmGSOIz0CkIkZ
	/fL4tFEostLVXM6+qqhd76JswqhREKfFP1fR1kA==
X-Google-Smtp-Source: AGHT+IEsYPDl84kDOiPKnhXshOf/uCpRkyFvSaITqHrLWdXFp4TssTeTFmIHAEsuuIC3R6E/DGx/E2qFx2ZnbYmwAgU=
X-Received: by 2002:a05:690c:488a:b0:6b1:1476:d3c5 with SMTP id
 00721157ae682-6dbcc29f47amr14189417b3.12.1726201724872; Thu, 12 Sep 2024
 21:28:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240906-wrapped-keys-v6-0-d59e61bc0cb4@linaro.org>
 <20240906-wrapped-keys-v6-9-d59e61bc0cb4@linaro.org> <7uoq72bpiqmo2olwpnudpv3gtcowpnd6jrifff34ubmfpijgc6@k6rmnalu5z4o>
 <66953e65-2468-43b8-9ccf-54671613c4ab@linaro.org> <ivibs6qqxhbikaevys3iga7s73xq6dzq3u43gwjri3lozkrblx@jxlmwe5wiq7e>
 <98cc8d71d5d9476297a54774c382030d@quicinc.com> <CAA8EJpp_HY+YmMCRwdteeAHnSHtjuHb=nFar60O_PwLwjk0mNA@mail.gmail.com>
 <9bd0c9356e2b471385bcb2780ff2425b@quicinc.com> <20240912231735.GA2211970@google.com>
In-Reply-To: <20240912231735.GA2211970@google.com>
From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Date: Fri, 13 Sep 2024 07:28:33 +0300
Message-ID: <CAA8EJpq3sjfB0BsJTs3_r_ZFzhrrpy-A=9Dx9ks2KrDNYCntdg@mail.gmail.com>
Subject: Re: [PATCH v6 09/17] soc: qcom: ice: add HWKM support to the ICE driver
To: Eric Biggers <ebiggers@kernel.org>
Cc: "Gaurav Kashyap (QUIC)" <quic_gaurkash@quicinc.com>, Neil Armstrong <neil.armstrong@linaro.org>, 
	Bartosz Golaszewski <brgl@bgdev.pl>, Jens Axboe <axboe@kernel.dk>, Jonathan Corbet <corbet@lwn.net>, 
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
	Mikulas Patocka <mpatocka@redhat.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	Asutosh Das <quic_asutoshd@quicinc.com>, Ritesh Harjani <ritesh.list@gmail.com>, 
	Ulf Hansson <ulf.hansson@linaro.org>, Alim Akhtar <alim.akhtar@samsung.com>, 
	Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, "Theodore Y. Ts'o" <tytso@mit.edu>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Bjorn Andersson <andersson@kernel.org>, Konrad Dybcio <konradybcio@kernel.org>, 
	"manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>, 
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>, 
	"linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>, 
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, 
	"linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, 
	"linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>, 
	"bartosz.golaszewski" <bartosz.golaszewski@linaro.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, 13 Sept 2024 at 02:17, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Thu, Sep 12, 2024 at 10:17:03PM +0000, Gaurav Kashyap (QUIC) wrote:
> >
> > On Monday, September 9, 2024 11:29 PM PDT, Dmitry Baryshkov wrote:
> > > On Tue, 10 Sept 2024 at 03:51, Gaurav Kashyap (QUIC)
> > > <quic_gaurkash@quicinc.com> wrote:
> > > >
> > > > Hello Dmitry and Neil
> > > >
> > > > On Monday, September 9, 2024 2:44 AM PDT, Dmitry Baryshkov wrote:
> > > > > On Mon, Sep 09, 2024 at 10:58:30AM GMT, Neil Armstrong wrote:
> > > > > > On 07/09/2024 00:07, Dmitry Baryshkov wrote:
> > > > > > > On Fri, Sep 06, 2024 at 08:07:12PM GMT, Bartosz Golaszewski wrote:
> > > > > > > > From: Gaurav Kashyap <quic_gaurkash@quicinc.com>
> > > > > > > >
> > > > > > > > Qualcomm's ICE (Inline Crypto Engine) contains a proprietary
> > > > > > > > key management hardware called Hardware Key Manager (HWKM).
> > > > > > > > Add
> > > > > HWKM
> > > > > > > > support to the ICE driver if it is available on the platform.
> > > > > > > > HWKM primarily provides hardware wrapped key support where
> > > the
> > > > > > > > ICE
> > > > > > > > (storage) keys are not available in software and instead
> > > > > > > > protected in
> > > > > hardware.
> > > > > > > >
> > > > > > > > When HWKM software support is not fully available (from
> > > > > > > > Trustzone), there can be a scenario where the ICE hardware
> > > > > > > > supports HWKM, but it cannot be used for wrapped keys. In this
> > > > > > > > case, raw keys have to be used without using the HWKM. We
> > > > > > > > query the TZ at run-time to find out whether wrapped keys
> > > > > > > > support is
> > > > > available.
> > > > > > > >
> > > > > > > > Tested-by: Neil Armstrong <neil.armstrong@linaro.org>
> > > > > > > > Signed-off-by: Gaurav Kashyap <quic_gaurkash@quicinc.com>
> > > > > > > > Signed-off-by: Bartosz Golaszewski
> > > > > > > > <bartosz.golaszewski@linaro.org>
> > > > > > > > ---
> > > > > > > >   drivers/soc/qcom/ice.c | 152
> > > > > +++++++++++++++++++++++++++++++++++++++++++++++--
> > > > > > > >   include/soc/qcom/ice.h |   1 +
> > > > > > > >   2 files changed, 149 insertions(+), 4 deletions(-)
> > > > > > > >
> > > > > > > >   int qcom_ice_enable(struct qcom_ice *ice)
> > > > > > > >   {
> > > > > > > > + int err;
> > > > > > > > +
> > > > > > > >           qcom_ice_low_power_mode_enable(ice);
> > > > > > > >           qcom_ice_optimization_enable(ice);
> > > > > > > > - return qcom_ice_wait_bist_status(ice);
> > > > > > > > + if (ice->use_hwkm)
> > > > > > > > +         qcom_ice_enable_standard_mode(ice);
> > > > > > > > +
> > > > > > > > + err = qcom_ice_wait_bist_status(ice); if (err)
> > > > > > > > +         return err;
> > > > > > > > +
> > > > > > > > + if (ice->use_hwkm)
> > > > > > > > +         qcom_ice_hwkm_init(ice);
> > > > > > > > +
> > > > > > > > + return err;
> > > > > > > >   }
> > > > > > > >   EXPORT_SYMBOL_GPL(qcom_ice_enable);
> > > > > > > > @@ -150,6 +282,10 @@ int qcom_ice_resume(struct qcom_ice
> > > *ice)
> > > > > > > >                   return err;
> > > > > > > >           }
> > > > > > > > + if (ice->use_hwkm) {
> > > > > > > > +         qcom_ice_enable_standard_mode(ice);
> > > > > > > > +         qcom_ice_hwkm_init(ice); }
> > > > > > > >           return qcom_ice_wait_bist_status(ice);
> > > > > > > >   }
> > > > > > > >   EXPORT_SYMBOL_GPL(qcom_ice_resume);
> > > > > > > > @@ -157,6 +293,7 @@ EXPORT_SYMBOL_GPL(qcom_ice_resume);
> > > > > > > >   int qcom_ice_suspend(struct qcom_ice *ice)
> > > > > > > >   {
> > > > > > > >           clk_disable_unprepare(ice->core_clk);
> > > > > > > > + ice->hwkm_init_complete = false;
> > > > > > > >           return 0;
> > > > > > > >   }
> > > > > > > > @@ -206,6 +343,12 @@ int qcom_ice_evict_key(struct qcom_ice
> > > > > > > > *ice,
> > > > > int slot)
> > > > > > > >   }
> > > > > > > >   EXPORT_SYMBOL_GPL(qcom_ice_evict_key);
> > > > > > > > +bool qcom_ice_hwkm_supported(struct qcom_ice *ice) {  return
> > > > > > > > +ice->use_hwkm; }
> > > > > EXPORT_SYMBOL_GPL(qcom_ice_hwkm_supported);
> > > > > > > > +
> > > > > > > >   static struct qcom_ice *qcom_ice_create(struct device *dev,
> > > > > > > >                                           void __iomem *base)
> > > > > > > >   {
> > > > > > > > @@ -240,6 +383,7 @@ static struct qcom_ice
> > > > > > > > *qcom_ice_create(struct
> > > > > device *dev,
> > > > > > > >                   engine->core_clk = devm_clk_get_enabled(dev, NULL);
> > > > > > > >           if (IS_ERR(engine->core_clk))
> > > > > > > >                   return ERR_CAST(engine->core_clk);
> > > > > > > > + engine->use_hwkm = qcom_scm_has_wrapped_key_support();
> > > > > > >
> > > > > > > This still makes the decision on whether to use HW-wrapped keys
> > > > > > > on behalf of a user. I suppose this is incorrect. The user must
> > > > > > > be able to use raw keys even if HW-wrapped keys are available on
> > > > > > > the platform. One of the examples for such use-cases is if a
> > > > > > > user prefers to be able to recover stored information in case of
> > > > > > > a device failure (such recovery will be impossible if SoC is
> > > > > > > damaged and HW-
> > > > > wrapped keys are used).
> > > > > >
> > > > > > Isn't that already the case ? the
> > > BLK_CRYPTO_KEY_TYPE_HW_WRAPPED
> > > > > size
> > > > > > is here to select HW-wrapped key, otherwise the ol' raw key is passed.
> > > > > > Just look the next patch.
> > > > > >
> > > > > > Or did I miss something ?
> > > > >
> > > > > That's a good question. If use_hwkm is set, ICE gets programmed to
> > > > > use hwkm (see qcom_ice_hwkm_init() call above). I'm not sure if it
> > > > > is expected to work properly if after such a call we pass raw key.
> > > > >
> > > >
> > > > Once ICE has moved to a HWKM mode, the firmware key programming
> > > currently does not support raw keys.
> > > > This support is being added for the next Qualcomm chipset in Trustzone to
> > > support both at he same time, but that will take another year or two to hit
> > > the market.
> > > > Until that time, due to TZ (firmware) limitations , the driver can only
> > > support one or the other.
> > > >
> > > > We also cannot keep moving ICE modes, due to the HWKM enablement
> > > being a one-time configurable value at boot.
> > >
> > > So the init of HWKM should be delayed until the point where the user tells if
> > > HWKM or raw keys should be used.
> >
> > Ack.
> > I'll work with Bartosz to look into moving to HWKM mode only during the first key program request
> >
>
> That would mean the driver would have to initially advertise support for both
> HW-wrapped keys and raw keys, and then it would revoke the support for one of
> them later (due to the other one being used).  However, runtime revocation of
> crypto capabilities is not supported by the blk-crypto framework
> (Documentation/block/inline-encryption.rst), and there is no clear path to
> adding such support.  Upper layers may have already checked the crypto
> capabilities and decided to use them.  It's too late to find out that the
> support was revoked in the middle of an I/O request.  Upper layer code
> (blk-crypto, fscrypt, etc.) is not prepared for this.  And even if it was, the
> best it could do is cleanly fail the I/O, which is too late as e.g. it may
> happen during background writeback and cause user data to be thrown away.

Can we check crypto capabilities when the user sets the key?

Compare this to the actual HSM used to secure communication or
storage. It has certain capabilities, which can be enumerated, etc.
But then at the time the user sets the key it is perfectly normal to
return an error because HSM is out of resources. It might even have
spare key slots, but it might be not enough to be able to program the
required key (as a really crazy example, consider the HSM having at
this time a single spare DES key slot, while the user wants to program
3DES key).

>
> So, the choice of support for HW-wrapped vs. raw will need to be made ahead of
> time, rather than being implicitly set by the first use.  That is most easily
> done using a module parameter like qcom_ice.hw_wrapped_keys=1.  Yes, it's a bit
> inconvenient, but there's no realistic way around this currently.

This doesn't work for Android usecase. The user isn't able to setup modparams.

-- 
With best wishes
Dmitry

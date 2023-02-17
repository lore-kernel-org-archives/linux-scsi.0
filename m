Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B036FC636D6
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Feb 2023 19:47:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbjBQTrB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Feb 2023 14:47:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjBQTrB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Feb 2023 14:47:01 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07ACA5E59A
        for <linux-scsi@vger.kernel.org>; Fri, 17 Feb 2023 11:46:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676663169;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZJvS63mZp8a4uVZBve/VJPXGpljeuIj8NEqhQ0qZZ/g=;
        b=RaEACoalb5MpypOrVm8yy24/QJItugvI1cL9NvMeYgcsAksiC0ed3aZ7AxcLcoiw2i//xq
        7UkOCE3/69NNsEYmwGnxxhlmKaUWV2sNehBtotgB+Tzag7Zek2vRvFUnM0Ky2Lb3wSguVF
        0TMQLZaeOpFX0ne4pQGgOV8+sTQRMFY=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-33-_wSRYT2SPYqGTP5kxk-ecQ-1; Fri, 17 Feb 2023 14:46:07 -0500
X-MC-Unique: _wSRYT2SPYqGTP5kxk-ecQ-1
Received: by mail-qt1-f197.google.com with SMTP id g6-20020ac80706000000b003ba266c0c2bso854465qth.5
        for <linux-scsi@vger.kernel.org>; Fri, 17 Feb 2023 11:46:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZJvS63mZp8a4uVZBve/VJPXGpljeuIj8NEqhQ0qZZ/g=;
        b=qIWVBCXcTSq+XHF6R0wYd+0RoqjPS/U7TJcbPA9fIj98r8EmiQTWiyqdtQMSQT04hY
         dO7z4DuytxIXg2VjU311jQ7GgaXRwJiLsl56Eob2xQ8fhPRDA4+kLa/YjZ1sfisgM4o8
         e9bdLxhgnmGH06slMk/JmQl2MiORdFt6BENReRJRRLu6zAxF7iXyjMiJ3A1vtXLtASXp
         +gwdt7YOjfcAwUsh6oJmIBry6p78VGh8rYYw/F4CRcGsHAs45+Qc9Fw0Qw8p911uOn/9
         hjNTnnOY0/OR8jkC2Q43QJz2+QnUNrHJBF3kuRC97fRnRUC1kNlC5f02DUmM4wA3kb5N
         wOUQ==
X-Gm-Message-State: AO0yUKX3X90ZZ9NpgfAR0jBvNnOr/rgxLPDqG3c3Ufr+GPYL5cynFT/w
        fosfuDMVk7M0rSgw+70v0FLPLdB67hXDSV2pRCcfwEhBZBAxeQb5v6IitFdFbukKWLQxtQoaNVw
        Vrpri71wy55extgphPLev0A==
X-Received: by 2002:a05:6214:1d2e:b0:56f:154:2517 with SMTP id f14-20020a0562141d2e00b0056f01542517mr10507107qvd.10.1676663167116;
        Fri, 17 Feb 2023 11:46:07 -0800 (PST)
X-Google-Smtp-Source: AK7set88qjcbU+szscT+zCxDg2MYq79BqUHsB8Nku9sZAJdD34fLUqMG7DK6as/cnodieUU+OTDZVg==
X-Received: by 2002:a05:6214:1d2e:b0:56f:154:2517 with SMTP id f14-20020a0562141d2e00b0056f01542517mr10507080qvd.10.1676663166856;
        Fri, 17 Feb 2023 11:46:06 -0800 (PST)
Received: from fedora (modemcable181.5-202-24.mc.videotron.ca. [24.202.5.181])
        by smtp.gmail.com with ESMTPSA id a138-20020ae9e890000000b0072396cb73cdsm3903808qkg.13.2023.02.17.11.46.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Feb 2023 11:46:06 -0800 (PST)
Date:   Fri, 17 Feb 2023 14:46:04 -0500
From:   Adrien Thierry <athierry@redhat.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2] scsi: ufs: initialize devfreq synchronously
Message-ID: <Y+/ZfKjcUr+J5d+D@fedora>
References: <20230216210021.59776-1-athierry@redhat.com>
 <8e6c545c-9ad6-1d97-9e6a-721d8770b40a@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8e6c545c-9ad6-1d97-9e6a-721d8770b40a@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

Thanks for reviewing, I posted a v3.

Best,

Adrien

On Fri, Feb 17, 2023 at 09:13:59AM -0800, Bart Van Assche wrote:
> On 2/16/23 13:00, Adrien Thierry wrote:
> > During ufs initialization, devfreq initialization is asynchronous:
> > ufshcd_async_scan() calls ufshcd_add_lus(), which in turn initializes
> > devfreq for ufs. The simple ondemand governor is then loaded. If it is
> > build as a module, request_module() is called and throws a warning:
> 
> build -> built?
> 
> > @@ -9896,12 +9893,30 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
> >   	 */
> >   	ufshcd_set_ufs_dev_active(hba);
> > +	/* Initialize devfreq */
> > +	if (ufshcd_is_clkscaling_supported(hba)) {
> > +		memcpy(&hba->clk_scaling.saved_pwr_info.info,
> > +			&hba->pwr_info,
> > +			sizeof(struct ufs_pa_layer_attr));
> > +		hba->clk_scaling.saved_pwr_info.is_valid = true;
> > +		hba->clk_scaling.is_allowed = true;
> > +
> > +		err = ufshcd_devfreq_init(hba);
> > +		if (err)
> > +			goto out_power_off;
> > +
> > +		hba->clk_scaling.is_enabled = true;
> > +		ufshcd_init_clk_scaling_sysfs(hba);
> > +	}
> > +
> >   	async_schedule(ufshcd_async_scan, hba);
> >   	ufs_sysfs_add_nodes(hba->dev);
> >   	device_enable_async_suspend(dev);
> >   	return 0;
> > +out_power_off:
> > +	pm_runtime_put_sync(dev);
> >   free_tmf_queue:
> >   	blk_mq_destroy_queue(hba->tmf_queue);
> >   	blk_put_queue(hba->tmf_queue);
> 
> Something I should have noticed while reviewing v1 of this patch: the label
> name "out_power_off" is misleading. pm_runtime_put_sync() does not power off
> a device but instead gives the power management core permission to apply the
> power management policy configured via sysfs. Runtime power management can
> be disabled via sysfs. How about renaming this label into "rpm_put_sync"
> (RPM = Runtime Power Management)?
> 
> Thanks,
> 
> Bart.
> 


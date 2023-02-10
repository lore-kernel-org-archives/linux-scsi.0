Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D09AC636D4
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Feb 2023 20:25:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233693AbjBJUZ3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Feb 2023 15:25:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233592AbjBJUZ2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Feb 2023 15:25:28 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 456625A90E
        for <linux-scsi@vger.kernel.org>; Fri, 10 Feb 2023 12:24:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676060593;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Gn5NJUJKWfOM81OHA0QE0esBFLsDNOwgiohaF5+873Y=;
        b=QpGa6FNqEc96UWr1iZ1dCT7Un2hGvtKr8ajarYjURPigpMUk0/LG4uWBQp7Y47fZWAhuPG
        Ogzm5w/aF6q00QhOnvLhNkjZz3pHIpdHtIEK9OpSZC1HWcMcCUbBD1vRXZ794VcpeAHJYl
        U3Tdkkx7VudG5KfuzhMEEeJIKzMitrA=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-428-cUbQPBX3NpmTws9IiRgnbw-1; Fri, 10 Feb 2023 15:23:12 -0500
X-MC-Unique: cUbQPBX3NpmTws9IiRgnbw-1
Received: by mail-qv1-f71.google.com with SMTP id jh2-20020a0562141fc200b004c74bbb0affso3805934qvb.21
        for <linux-scsi@vger.kernel.org>; Fri, 10 Feb 2023 12:23:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gn5NJUJKWfOM81OHA0QE0esBFLsDNOwgiohaF5+873Y=;
        b=lNrSG00MYh6WHouCvYULX6hTD16KYsAipzz40PJkkAklQ+2TaB/5jXusKIySf8SxtF
         gHHfewcNsYpD8JPpxczrzqhfi2KVB9QPem4Eg6+TmH8HGk8eWDm+S/vWs+2EE8AAn/WK
         XEzVR0Rxl2xpzCbGpRBWXte8EMWUunjSTGtmp5VZdmLK0LCZQ2wOHjouIPdN3vvui9o6
         p82Dyi4gMmqOCIagDyOctDSKTocAMsWex2tAaRnaXAR485U2TH6IhzTlHel4lMemdVlp
         EFKLr+dcXUK/mQxogGu/LE0bQhEM7meS4UwhRsjDLmhBpQ3LaRCxuU/y1ezvdacwjQsR
         +pSQ==
X-Gm-Message-State: AO0yUKWfKaI6MVDv5Ui7jBp4w5abxpPR/4FepkMY0m+G93CjsSjkbGsS
        qLtxYUlliPitNEF6sxc0x5qQzLu1g9lr6Ysy8EU6AcPWDflqiENDiVZ9hlaDqXevdGOex2AWpF8
        qSnEfxHXmxLgXeN3ga+JLXuH8peI=
X-Received: by 2002:a05:622a:196:b0:3b9:b422:4d5b with SMTP id s22-20020a05622a019600b003b9b4224d5bmr27211273qtw.26.1676060591366;
        Fri, 10 Feb 2023 12:23:11 -0800 (PST)
X-Google-Smtp-Source: AK7set+uNUb69J87PKWYKf9SoxwuzQ3szZ9a3mor4jFAD7iIxUeqOuX0188ZXYZ8gI5pxez+KdTa3Q==
X-Received: by 2002:a05:622a:196:b0:3b9:b422:4d5b with SMTP id s22-20020a05622a019600b003b9b4224d5bmr27211235qtw.26.1676060591035;
        Fri, 10 Feb 2023 12:23:11 -0800 (PST)
Received: from fedora (modemcable181.5-202-24.mc.videotron.ca. [24.202.5.181])
        by smtp.gmail.com with ESMTPSA id c26-20020ac84e1a000000b003a5c6ad428asm3903809qtw.92.2023.02.10.12.23.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Feb 2023 12:23:10 -0800 (PST)
Date:   Fri, 10 Feb 2023 15:23:08 -0500
From:   Adrien Thierry <athierry@redhat.com>
To:     Bean Huo <huobean@gmail.com>
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: initialize devfreq synchronously
Message-ID: <Y+anrOnSoCuwg3Ab@fedora>
References: <20230209211456.54250-1-athierry@redhat.com>
 <3bd48609-c194-61a6-7a2e-90b9e0d76fc6@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3bd48609-c194-61a6-7a2e-90b9e0d76fc6@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bean,

> On 09.02.23 10:14 PM, Adrien Thierry wrote:
> > -	/* Initialize devfreq after UFS device is detected */
> > -	if (ufshcd_is_clkscaling_supported(hba)) {
> > -		memcpy(&hba->clk_scaling.saved_pwr_info.info,
> > -			&hba->pwr_info,
> > -			sizeof(struct ufs_pa_layer_attr));
> > -		hba->clk_scaling.saved_pwr_info.is_valid = true;
> > -		hba->clk_scaling.is_allowed = true;
> > -
> > -		ret = ufshcd_devfreq_init(hba);
> > -		if (ret)
> > -			goto out;
> > -
> > -		hba->clk_scaling.is_enabled = true;
> > -		ufshcd_init_clk_scaling_sysfs(hba);
> > -	}
> > -
> >   	ufs_bsg_probe(hba);
> >   	ufshpb_init(hba);
> >   	scsi_scan_host(hba->host);
> > @@ -8290,7 +8277,8 @@ static void ufshcd_async_scan(void *data, async_cookie_t cookie)
> >   	if (ret) {
> >   		pm_runtime_put_sync(hba->dev);
> >   		ufshcd_hba_exit(hba);
> > -	}
> > +	} else
> > +		hba->is_initialized = true;
> 
> after moving devfreq initialization out of the async routine, still has deadlock issue?
>

No more deadlock after moving devfreq initialization out of the async
routine. The reason I added the hba->is_initialized variable is to prevent
devfreq_monitor to update the ufs frequency until the async routine had a
chance to run and the ufs is initialized. Otherwise I would sometimes get
"dvfs failed with (-16) error" on boot.

Best,

Adrien


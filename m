Return-Path: <SRS0=1cZD=AT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04EF9C433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 12:25:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE4A920772
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 12:25:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="BYBdt3k6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729103AbgGHMZK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jul 2020 08:25:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728640AbgGHMZK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jul 2020 08:25:10 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3A1CC08E6DC
        for <linux-scsi@vger.kernel.org>; Wed,  8 Jul 2020 05:25:09 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id q5so48728452wru.6
        for <linux-scsi@vger.kernel.org>; Wed, 08 Jul 2020 05:25:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=y83T4okZmW+ewpDTi2O1QO/huCDpNe78uZke3IM8aJY=;
        b=BYBdt3k6fueAkq+OQSB3qjNqDf8pdREW9G+LDLWcysNpn6anqqwNqRGENnn0h2yLg+
         qAYnkh+Xr/+iASVbG/RFNkz1t8yJf8EXIrA267pEUVl5F6rws5CfZH9JkeebuOJjHoBP
         PKh6r+l7GnCvtRwQs4REx7hphmJpBe/kSMH1QR+oEsvAvZshCyDzh8KJsSNln67awZgZ
         OdIHF4H/MoeTMHacyw8Hzy1Lg7J0L9oa9DPGm3JumjS+LcdjdiLLeRNNmbzpAmtMi3xR
         10Vmn9BxvpKqM7F6EjVI4CKIXi+skKjUlsQU4A8P6cAwnoIvB18Ec98x0XzrJ0uDk8BT
         ha3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=y83T4okZmW+ewpDTi2O1QO/huCDpNe78uZke3IM8aJY=;
        b=pUQ9hNO+vzZ9a3EwbWESSZT41eq31opOHDbskfSQoaiZ7fXcO8cCqqv5CWmFVGglwh
         rbQ6JPyZ74xxaSAJDpECtsNNcxUEgHdthCGcAt2I+QMJFTzu8ydAWMKobhmPUtK8BULH
         pg8XyKsSz8kawBGOJ5NaCasDCAGqGoaLS6Yjr2E+1x3beY6H5E/78du2U/I34jGhceI9
         H4DeIhVLbZlUYsJ1eBTwTAKE4t8fasgEqwplYaAalsEhvmFBBjiX9yHFyN4Ecwdg+3qq
         N4YpsRZd1Q2AY4eW8zyU0V4Fxysdp3oLrjje+SbWO6GheFgHuldQSL1JWbz1HMPnqGYU
         qWgg==
X-Gm-Message-State: AOAM532SgTEeYmmCcK5hmey+0YRdRcPByhwbfiVPE1FyLPR6NNnq6TNT
        Buml6ZsZTQG5PdBLqWl6TWOk5Of62gQ=
X-Google-Smtp-Source: ABdhPJzrYRVN7Bt5f2csl02uPGc8Nk19Pk8uC329kzLpjAE1BL4Mvzp8u3qykscb4eK2L/+dHQmT0Q==
X-Received: by 2002:adf:f546:: with SMTP id j6mr57660492wrp.167.1594211108378;
        Wed, 08 Jul 2020 05:25:08 -0700 (PDT)
Received: from dell ([2.27.35.206])
        by smtp.gmail.com with ESMTPSA id i67sm6052800wma.12.2020.07.08.05.25.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 05:25:07 -0700 (PDT)
Date:   Wed, 8 Jul 2020 13:25:06 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Cc:     "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 13/30] scsi: libfc: fc_rport: Fix bitrotted function
 parameter and copy/paste error
Message-ID: <20200708122506.GV3500@dell>
References: <20200708120221.3386672-1-lee.jones@linaro.org>
 <20200708120221.3386672-14-lee.jones@linaro.org>
 <SN4PR0401MB3598A5AF95715606071A64939B670@SN4PR0401MB3598.namprd04.prod.outlook.com>
 <20200708122416.GU3500@dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200708122416.GU3500@dell>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 08 Jul 2020, Lee Jones wrote:

> On Wed, 08 Jul 2020, Johannes Thumshirn wrote:
> 
> > On 08/07/2020 14:04, Lee Jones wrote:
> > > Description should state 'remote' port, not 'local'.
> > > 
> > > Fixes the following W=1 kernel build warning(s):
> > > 
> > >  drivers/scsi/libfc/fc_rport.c:1452: warning: Function parameter or member 'rdata_arg' not described in 'fc_rport_logo_resp'
> > >  drivers/scsi/libfc/fc_rport.c:1452: warning: Excess function parameter 'rport_arg' description in 'fc_rport_logo_resp'
> > > 
> > > Cc: Hannes Reinecke <hare@suse.de>
> > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > > ---
> > >  drivers/scsi/libfc/fc_rport.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
> > > index ea99e69d4d89c..18663a82865f9 100644
> > > --- a/drivers/scsi/libfc/fc_rport.c
> > > +++ b/drivers/scsi/libfc/fc_rport.c
> > > @@ -1445,7 +1445,7 @@ static void fc_rport_recv_rtv_req(struct fc_rport_priv *rdata,
> > >   * fc_rport_logo_resp() - Handler for logout (LOGO) responses
> > >   * @sp:	       The sequence the LOGO was on
> > >   * @fp:	       The LOGO response frame
> > > - * @rport_arg: The local port
> > > + * @rdata_arg: The remote port
> > >   */
> > >  static void fc_rport_logo_resp(struct fc_seq *sp, struct fc_frame *fp,
> > >  			       void *rdata_arg)
> > > 
> > 
> > 
> > Please fold this into patch 11
> 
> Yes, will do.

Actually, Martin, is this something you can do when applying, or would
you like me to do it and submit the entire set again?

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog

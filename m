Return-Path: <SRS0=xC/A=AZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B993C433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 07:58:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E8DD21582
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 07:58:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="C+EG+XoG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbgGNH6h (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jul 2020 03:58:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725977AbgGNH6h (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jul 2020 03:58:37 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FA5BC061755
        for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2020 00:58:37 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id o11so20194864wrv.9
        for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2020 00:58:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=WP+E7Gzj6PVJ2ddQoR4ENITwGviQMzkXLlWTSG6P9Wo=;
        b=C+EG+XoGDXZrOgdAVgjPyky+0C6vdaorrTtzP3C/Y5N+uJsfKIvb9HFoGrqJd3JJJS
         zQQ0YlYcf2eyOurqx5DAktYbsTuudnF48MCpO35LuMskDlu9Y8OPPf5Y8fQ2lbQf2eoW
         7+OAeMacDBFcJ0maVzCc90g0+HXvWxMscpC8CeJIy5qS7FpB4ZLFn7D0ZHybbjI9Ka3v
         nKgoH3uIRALzDmTA3gcaEXlwhHCimXtD7UD4MmWwh51kwH+81RXXdEgn7LENyBogKdsR
         Glu8uf88aM1ggL0cYFm9Tj4r7tzepxRQzDWmZTEPCO0HJC6vnacoP+mDNo4WGwBhQhXw
         /+cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=WP+E7Gzj6PVJ2ddQoR4ENITwGviQMzkXLlWTSG6P9Wo=;
        b=OewdJy8l0IAQ9YVD2KqnPa9zFAgTt5FLXFCQ9wlZE9WbHWKYBvzw+uTIEx5RLwo+Qk
         p134gXYCeGglubJhf88cJa1UoPXPKnjOYAwu+hzNK2AGl7dvbaio2SQHGRFcwfG9c1hy
         rihG6tVx4QV2SghBJAKjdhSVIvrxMhRFb6m42REx/QR6g1xp5RhZgBRypDnxXSIiVqoi
         d+eiIut9orh8Hrx7KbC5qiCnFuraEgRjELf45u+zhexmAuwattLJVaqfk3lzgOcGthui
         Cy3ETwBfLRLOD/MMWsfgPgDxat9oaV/WrG3akLsz5mA3ySL+pH9OA4NXfUVdr7xyOLn/
         HE4A==
X-Gm-Message-State: AOAM533AkS3eDCaS25S6vZjXcmgBORWwgignDh5XdHHDVduhLuUuhwFz
        Z9ESPxEq4ckGcl4YfKVS07gsuYt1G7M=
X-Google-Smtp-Source: ABdhPJweYtmFzDu77mUI7cZCU7+sT8sw1/UUcOD2+1eMC6c1lKqU0h8wdN3UEKHZtnX3gh4GdOA4og==
X-Received: by 2002:a5d:40ca:: with SMTP id b10mr4027551wrq.56.1594713515787;
        Tue, 14 Jul 2020 00:58:35 -0700 (PDT)
Received: from dell ([2.31.163.61])
        by smtp.gmail.com with ESMTPSA id g195sm3011377wme.38.2020.07.14.00.58.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2020 00:58:35 -0700 (PDT)
Date:   Tue, 14 Jul 2020 08:58:33 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     Hannes Reinecke <hare@suse.de>
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2 04/29] scsi: fcoe: fcoe: Fix various kernel-doc
 infringements
Message-ID: <20200714075833.GI3500@dell>
References: <20200713074645.126138-1-lee.jones@linaro.org>
 <20200713074645.126138-5-lee.jones@linaro.org>
 <06bc5e03-04b0-7e09-18f4-d9fd536b714b@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <06bc5e03-04b0-7e09-18f4-d9fd536b714b@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 14 Jul 2020, Hannes Reinecke wrote:

> On 7/13/20 9:46 AM, Lee Jones wrote:
> > A couple of headers make no attempt to document their associated function
> > parameters.  Others looks as if they are suffering with a little bitrot.
> > 
> > Fixes the following W=1 kernel build warning(s):
> > 
> >   drivers/scsi/fcoe/fcoe.c:654: warning: Function parameter or member 'lport' not described in 'fcoe_netdev_features_change'
> >   drivers/scsi/fcoe/fcoe.c:654: warning: Function parameter or member 'netdev' not described in 'fcoe_netdev_features_change'
> >   drivers/scsi/fcoe/fcoe.c:2039: warning: Function parameter or member 'ctlr_dev' not described in 'fcoe_ctlr_mode'
> >   drivers/scsi/fcoe/fcoe.c:2039: warning: Excess function parameter 'cdev' description in 'fcoe_ctlr_mode'
> >   drivers/scsi/fcoe/fcoe.c:2144: warning: Function parameter or member 'fcoe' not described in 'fcoe_dcb_create'
> >   drivers/scsi/fcoe/fcoe.c:2144: warning: Excess function parameter 'netdev' description in 'fcoe_dcb_create'
> >   drivers/scsi/fcoe/fcoe.c:2144: warning: Excess function parameter 'port' description in 'fcoe_dcb_create'
> >   drivers/scsi/fcoe/fcoe.c:2627: warning: Function parameter or member 'lport' not described in 'fcoe_elsct_send'
> >   drivers/scsi/fcoe/fcoe.c:2627: warning: Function parameter or member 'did' not described in 'fcoe_elsct_send'
> >   drivers/scsi/fcoe/fcoe.c:2627: warning: Function parameter or member 'fp' not described in 'fcoe_elsct_send'
> >   drivers/scsi/fcoe/fcoe.c:2627: warning: Function parameter or member 'op' not described in 'fcoe_elsct_send'
> >   drivers/scsi/fcoe/fcoe.c:2627: warning: Function parameter or member 'resp' not described in 'fcoe_elsct_send'
> >   drivers/scsi/fcoe/fcoe.c:2627: warning: Function parameter or member 'arg' not described in 'fcoe_elsct_send'
> >   drivers/scsi/fcoe/fcoe.c:2627: warning: Function parameter or member 'timeout' not described in 'fcoe_elsct_send'
> > 
> > Cc: Hannes Reinecke <hare@suse.de>
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >   drivers/scsi/fcoe/fcoe.c | 10 ++++------
> >   1 file changed, 4 insertions(+), 6 deletions(-)
> > 
> > diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
> > index cb41d166e0c0f..0f9274960dc6b 100644
> > --- a/drivers/scsi/fcoe/fcoe.c
> > +++ b/drivers/scsi/fcoe/fcoe.c
> > @@ -645,7 +645,7 @@ static int fcoe_lport_config(struct fc_lport *lport)
> >   	return 0;
> >   }
> > -/**
> > +/*
> >    * fcoe_netdev_features_change - Updates the lport's offload flags based
> >    * on the LLD netdev's FCoE feature flags
> >    */
> > @@ -2029,7 +2029,7 @@ static int fcoe_ctlr_enabled(struct fcoe_ctlr_device *cdev)
> >   /**
> >    * fcoe_ctlr_mode() - Switch FIP mode
> > - * @cdev: The FCoE Controller that is being modified
> > + * @ctlr_dev: The FCoE Controller that is being modified
> >    *
> >    * When the FIP mode has been changed we need to update
> >    * the multicast addresses to ensure we get the correct
> > @@ -2136,9 +2136,7 @@ static bool fcoe_match(struct net_device *netdev)
> >   /**
> >    * fcoe_dcb_create() - Initialize DCB attributes and hooks
> > - * @netdev: The net_device object of the L2 link that should be queried
> > - * @port: The fcoe_port to bind FCoE APP priority with
> > - * @
> > + * @fcoe:   The new FCoE interface
> >    */
> >   static void fcoe_dcb_create(struct fcoe_interface *fcoe)
> >   {
> > @@ -2609,7 +2607,7 @@ static void fcoe_logo_resp(struct fc_seq *seq, struct fc_frame *fp, void *arg)
> >   	fc_lport_logo_resp(seq, fp, lport);
> >   }
> > -/**
> > +/*
> >    * fcoe_elsct_send - FCoE specific ELS handler
> >    *
> >    * This does special case handling of FIP encapsualted ELS exchanges for FCoE,
> > 
> I'd rather convert this and the fcoe_netdev_features_change to proper
> kerneldocs:
> 
> diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
> index cb41d166e0c0..151fe4c53b07 100644
> --- a/drivers/scsi/fcoe/fcoe.c
> +++ b/drivers/scsi/fcoe/fcoe.c
> @@ -646,8 +646,12 @@ static int fcoe_lport_config(struct fc_lport *lport)
>  }
> 
>  /**
> - * fcoe_netdev_features_change - Updates the lport's offload flags based
> - * on the LLD netdev's FCoE feature flags
> + * fcoe_netdev_features_change - Updates the lport's offload flags
> + * @lport:  The local port that is associated with the net device
> + * @netdev: The associated net device
> + *
> + * Update the @lport offload flags based on the FCoE feature flags
> + * from the LLD @netdev.
>   */
>  static void fcoe_netdev_features_change(struct fc_lport *lport,
>                                         struct net_device *netdev)
> @@ -2611,6 +2615,13 @@ static void fcoe_logo_resp(struct fc_seq *seq, struct
> fc_frame *fp, void *arg)
> 
>  /**
>   * fcoe_elsct_send - FCoE specific ELS handler
> + * @lport: Local port
> + * @did: Destination ID
> + * @fp: FCoE frame
> + * @op: ELS operation
> + * @resp: Response callback
> + * @arg: Argument for the response callback
> + * @timeout: Timeout for the ELS response
>   *
>   * This does special case handling of FIP encapsualted ELS exchanges for
> FCoE,
>   * using FCoE specific response handlers and passing the FIP controller as

I don't want to steal your work.

Why don't you send this and a follow-up to fix the broken header for
fcoe_ctlr_disc_start() as follow-ups?

It also saves me from having to submit a v3 of this entire set.

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog

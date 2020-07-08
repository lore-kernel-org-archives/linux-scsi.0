Return-Path: <SRS0=1cZD=AT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95435C433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 12:24:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6CE6B20720
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 12:24:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="gPz3zvQU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729012AbgGHMYU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jul 2020 08:24:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728902AbgGHMYT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jul 2020 08:24:19 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6BE6C08E6DC
        for <linux-scsi@vger.kernel.org>; Wed,  8 Jul 2020 05:24:19 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id z15so37477419wrl.8
        for <linux-scsi@vger.kernel.org>; Wed, 08 Jul 2020 05:24:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=fOlHxGSRj06P9BZIF8Kv7DAI1DiEsA0q4WltzXak3yw=;
        b=gPz3zvQU0WZtncU/3eUeWCNpU9g0Ks8PoxQeRPsXfvxCSwQNsqLkQd35HIZ0tPPRc+
         4Eg+qtfjnhP6J107ISH8lQHSwdCDqIoCynWRwz1P8WL2EoBch8GkljgTa5XcKRXNhUzv
         o8wdZ/NqScC99jGoywmam8XNmTxO9zMz5NhqEy5tlFUTvBEN70wC8FlJQrDfD+Vfvtf1
         SWBJlbHhJtZJP+vUbANgPUc7JZ3U3hyeZMNzjjpKY5bXForcdaRNo76u2tv5qy53HReS
         Arftqmr60WfO7YFdnE/WZS2ahtoavPOk75OhKfAfy+tRGE3o5/S/ahTC4pqPAuGDJcq2
         puCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=fOlHxGSRj06P9BZIF8Kv7DAI1DiEsA0q4WltzXak3yw=;
        b=hk0BU1UTJP62XXJTS9xWAzGSLEc7M2zU8Bevi4gM53YK/lGsMvgVIvIkDMs1YX8YhY
         9abFWT9NHkQkvoufIVU/QGGJELH8K/Z/aABTpu8qkOc0BgWEV3l1oau4wFl3PmiS1N3e
         KT08U2vB9spt2Z1FpX/JgV74yZtNJPHom9N20EjDTjxpHwK8bfOb63TRg9+pXOOcHMGK
         kYx3Gg2HteJREnJtLBEMWFcTlI+cE1K0JtDapADUxFeNnaK8iJ1LmqSJZ8v5dHsE2MdK
         gzZhar4QIDnck8XTA0G/g1Vq6ARO4hBEPcZ1W78ua9tIw3Mi32lp+7LjF8R5+Mh5rLPr
         VbuA==
X-Gm-Message-State: AOAM5333Pmy/+MR94oH+a06vDVenS/CMENgiwBPJ6eccIaACvVXIFbt8
        OoZZzRmdWJsAA+8qrSj4/xwv01ZtYdE=
X-Google-Smtp-Source: ABdhPJzV6hwPkr3yVGxrp+dEtiQGc4oEE5HySdPNkm60AIPhpWAm/innAVpEssqKfWXzUwzLwSnTiQ==
X-Received: by 2002:a5d:5388:: with SMTP id d8mr57509451wrv.35.1594211058441;
        Wed, 08 Jul 2020 05:24:18 -0700 (PDT)
Received: from dell ([2.27.35.206])
        by smtp.gmail.com with ESMTPSA id 69sm2446679wma.16.2020.07.08.05.24.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 05:24:17 -0700 (PDT)
Date:   Wed, 8 Jul 2020 13:24:16 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Cc:     "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 13/30] scsi: libfc: fc_rport: Fix bitrotted function
 parameter and copy/paste error
Message-ID: <20200708122416.GU3500@dell>
References: <20200708120221.3386672-1-lee.jones@linaro.org>
 <20200708120221.3386672-14-lee.jones@linaro.org>
 <SN4PR0401MB3598A5AF95715606071A64939B670@SN4PR0401MB3598.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <SN4PR0401MB3598A5AF95715606071A64939B670@SN4PR0401MB3598.namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 08 Jul 2020, Johannes Thumshirn wrote:

> On 08/07/2020 14:04, Lee Jones wrote:
> > Description should state 'remote' port, not 'local'.
> > 
> > Fixes the following W=1 kernel build warning(s):
> > 
> >  drivers/scsi/libfc/fc_rport.c:1452: warning: Function parameter or member 'rdata_arg' not described in 'fc_rport_logo_resp'
> >  drivers/scsi/libfc/fc_rport.c:1452: warning: Excess function parameter 'rport_arg' description in 'fc_rport_logo_resp'
> > 
> > Cc: Hannes Reinecke <hare@suse.de>
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >  drivers/scsi/libfc/fc_rport.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
> > index ea99e69d4d89c..18663a82865f9 100644
> > --- a/drivers/scsi/libfc/fc_rport.c
> > +++ b/drivers/scsi/libfc/fc_rport.c
> > @@ -1445,7 +1445,7 @@ static void fc_rport_recv_rtv_req(struct fc_rport_priv *rdata,
> >   * fc_rport_logo_resp() - Handler for logout (LOGO) responses
> >   * @sp:	       The sequence the LOGO was on
> >   * @fp:	       The LOGO response frame
> > - * @rport_arg: The local port
> > + * @rdata_arg: The remote port
> >   */
> >  static void fc_rport_logo_resp(struct fc_seq *sp, struct fc_frame *fp,
> >  			       void *rdata_arg)
> > 
> 
> 
> Please fold this into patch 11

Yes, will do.

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog

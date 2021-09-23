Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B027C433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Sep 2021 12:40:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B4796054F
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Sep 2021 12:40:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241066AbhIWMmO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Sep 2021 08:42:14 -0400
Received: from mail-oi1-f179.google.com ([209.85.167.179]:40892 "EHLO
        mail-oi1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241115AbhIWMkt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Sep 2021 08:40:49 -0400
Received: by mail-oi1-f179.google.com with SMTP id t189so9458594oie.7;
        Thu, 23 Sep 2021 05:39:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=evADELF/DhUDG4cFBpRRtexlQz8+J2T78HfMruWlsoA=;
        b=2/bBrDTx2t0rbwbcx941zTR9LsNrr9SmiP9WzcZR+Uee/arLzyDQw6ksQIFbXOR9lp
         ChQ6w0POryKtsiMyvu8Bb13ZSnuhVZMTKzkPlFESPbVctZzpPecsJaPVTenVmAQKYA4M
         cmLkySpXS8n8Rzhoh+NsmVkXuSHBBafBSmvHAUr6fQvuRNcT8TWFcAteS2QLhaqbzYzP
         VNFIFMA3yQGPpo5VJOYdp40ifosETnWmXf4MtEfzg2v3OqYwnSrclwBWOLTuDDPCN0HQ
         WGqXkyTQ7iHjeNe9dxUEwXr/5h3p2Ok4GhEgS+o7Ncs+hLWDv/zBZDLaADaH+B0vgp9S
         7euw==
X-Gm-Message-State: AOAM532wR41ybT/+05dN0Bu5hjGlLgHOVSX/yhbhIDrAuXGXpJmE1HBw
        l4auGD/3iZYthW/9sZP+JA==
X-Google-Smtp-Source: ABdhPJzbV9gJr1OK9RVaY9hFrDno3DYw/Z3b/bgkCWJa+J6eg0/V14gGmSTNsHREGcBq1ORCjmSOSg==
X-Received: by 2002:aca:7c5:: with SMTP id 188mr3531211oih.60.1632400752204;
        Thu, 23 Sep 2021 05:39:12 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id a19sm33885oic.25.2021.09.23.05.39.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Sep 2021 05:39:11 -0700 (PDT)
Received: (nullmailer pid 2813429 invoked by uid 1000);
        Thu, 23 Sep 2021 12:39:10 -0000
Date:   Thu, 23 Sep 2021 07:39:10 -0500
From:   Rob Herring <robh@kernel.org>
To:     Chanho Park <chanho61.park@samsung.com>
Cc:     'Alim Akhtar' <alim.akhtar@samsung.com>,
        'Avri Altman' <avri.altman@wdc.com>,
        "'James E . J . Bottomley'" <jejb@linux.ibm.com>,
        "'Martin K . Petersen'" <martin.petersen@oracle.com>,
        'Krzysztof Kozlowski' <krzysztof.kozlowski@canonical.com>,
        'Bean Huo' <beanhuo@micron.com>,
        'Bart Van Assche' <bvanassche@acm.org>,
        'Adrian Hunter' <adrian.hunter@intel.com>,
        'Christoph Hellwig' <hch@infradead.org>,
        'Can Guo' <cang@codeaurora.org>,
        'Jaegeuk Kim' <jaegeuk@kernel.org>,
        'Gyunghoon Kwon' <goodjob.kwon@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-scsi@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v3 05/17] dt-bindings: ufs: exynos-ufs: add sysreg regmap
 property
Message-ID: <YUx1bp8a/hhnlwl0@robh.at.kernel.org>
References: <20210917065436.145629-1-chanho61.park@samsung.com>
 <CGME20210917065523epcas2p3ff66daa15c8c782f839422756c388d93@epcas2p3.samsung.com>
 <20210917065436.145629-6-chanho61.park@samsung.com>
 <YUuKpSPgdKl2CiSy@robh.at.kernel.org>
 <000801d7b014$9ed9fe40$dc8dfac0$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000801d7b014$9ed9fe40$dc8dfac0$@samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Sep 23, 2021 at 09:47:44AM +0900, Chanho Park wrote:
> > > +  sysreg:
> > 
> > Needs a vendor prefix.
> 
> Thanks. I'll use "samsung,sysreg-phandle".

No '-phandle'.

> 
> > 
> > > +    $ref: '/schemas/types.yaml#/definitions/phandle'
> > > +    description: phandle for FSYS sysreg interface, used to control
> > > +                 sysreg register bit for UFS IO Coherency
> > 
> > Is there more than 1 FSYS? If not, you can just get the node by its
> > compatible.
> 
> The phandle can be differed each exynos SoCs, AFAIK. I think other exynos
> SoCs since exnos7 will need this but not upstreamed yet...

That's still fine. You really only need a phandle if there is more than 
1 instance on a given platform.

Of course you could end up with multiple compatible strings to deal 
with, but you might need that anyway as the registers are likely to be 
different. That can sometimes be mitigated by putting register offsets 
into the DT property (something to consider here).  This is the problem 
with drivers directly twiddling bits in  other h/w blocks and why we 
have common interfaces for clocks, resets, etc.

I leave it to you to decide how you want to do it.

BTW, If you want to see another way to handle the same problem, see 
highbank_platform_notifier(). Notifiers aren't great either, but it 
keeps some SoC specifics out of the driver.

Rob

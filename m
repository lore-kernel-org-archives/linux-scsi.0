Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BCDAC433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Sep 2021 12:26:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00BC66124C
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Sep 2021 12:26:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240838AbhIWM1q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Sep 2021 08:27:46 -0400
Received: from mail-oi1-f174.google.com ([209.85.167.174]:40724 "EHLO
        mail-oi1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240787AbhIWM1q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Sep 2021 08:27:46 -0400
Received: by mail-oi1-f174.google.com with SMTP id t189so9411768oie.7;
        Thu, 23 Sep 2021 05:26:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6yJapGwh6/gW5pXSlUGpnhUoHA3IK6b0lf7E6Y166Ww=;
        b=v5TwWo0m8gEzr5+8lFukRU39bWJmMgsFjDQV9xLMGxlC09cmvYHhTbXvqXRG5Q+gnb
         cqbpmTZroeVVE68ejJtujjsAIDaVAJ6VNSzkl6uxqhSoO1Uo8PRGd6BxZDm/dUN9NZq7
         1+/ff+eI7s3xRc4p402tIhcu9Ccc7JkueYNivURCUnPv2ug1mm/VQPnNswULKV8nZxOI
         TWhgX8bcXOgFm6w9+ThG7aOa6/iOwlLt2eDjb2Kr5W8fvmUzxvPcvba3zffjdlm+K94x
         LT9eW6MSWyxgJipSaDd73fcvLPVGxUWyrE05EGwJ/yv7aB33AVq84oF6M4eQXEs8IrPu
         qyBw==
X-Gm-Message-State: AOAM5338GY1EPvVvtlpxn0na4yoU9tD8XFTBdRsLK2PR1n09t1gO64Ad
        tPsqoeIb6q8nrdUOj00WhA==
X-Google-Smtp-Source: ABdhPJzybO4L5m6Us7Hp7E2Tqpiq4znHYgHN/lgJWN3skhWsh2JKouNENiRokKyjz5asnm+7XgbfEA==
X-Received: by 2002:aca:ba44:: with SMTP id k65mr3424768oif.131.1632399974171;
        Thu, 23 Sep 2021 05:26:14 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id y84sm1302856oie.16.2021.09.23.05.26.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Sep 2021 05:26:13 -0700 (PDT)
Received: (nullmailer pid 2793350 invoked by uid 1000);
        Thu, 23 Sep 2021 12:26:12 -0000
Date:   Thu, 23 Sep 2021 07:26:12 -0500
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
        'Kiwoong Kim' <kwmad.kim@samsung.com>
Subject: Re: [PATCH v3 06/17] scsi: ufs: ufs-exynos: get sysreg regmap for
 io-coherency
Message-ID: <YUxyZKRDYXtTUZGJ@robh.at.kernel.org>
References: <20210917065436.145629-1-chanho61.park@samsung.com>
 <CGME20210917065523epcas2p477a63b06cbb9f5588aa2c149c9d1db10@epcas2p4.samsung.com>
 <20210917065436.145629-7-chanho61.park@samsung.com>
 <YUuKJj7+wmJd7DSe@robh.at.kernel.org>
 <000701d7b013$8237ef50$86a7cdf0$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000701d7b013$8237ef50$86a7cdf0$@samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Sep 23, 2021 at 09:39:46AM +0900, Chanho Park wrote:
> > >  drivers/scsi/ufs/ufs-exynos.c | 5 +++++
> > > drivers/scsi/ufs/ufs-exynos.h | 1 +
> > >  2 files changed, 6 insertions(+)
> > 
> > This patch is a nop... Fold it into the patch using sysreg.
> 
> I separated them to be reviewed easily by different maintainers. I'll squash
> them on next patchset.

Patch 14 is what this should be merged with. How is that a different 
maintainer?

Rob

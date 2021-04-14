Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C461C43470
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Apr 2021 16:17:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E68E6121E
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Apr 2021 16:17:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352660AbhDNQSN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Apr 2021 12:18:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349131AbhDNQSK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Apr 2021 12:18:10 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2C6CC06138C
        for <linux-scsi@vger.kernel.org>; Wed, 14 Apr 2021 09:17:48 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id t22so10076053ply.1
        for <linux-scsi@vger.kernel.org>; Wed, 14 Apr 2021 09:17:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0eL/B6Xsq6Q/24IYguuLfwVoh9qvE+Qw7MZOf5nGHyg=;
        b=DWKLnEjIRc6nqOLRuoo9K6bOLQMW5c1mqbVDL7yGhVs88fhUl8h/izys8YK3f/gwVM
         PcQzKMKIFq9o0hwsUhKISfLDewBl34wWHl1mNxtvbMhH9ULpfprQDggqRkhav/DB3fq5
         Lt6TuRqVyREjop1FfnrZ4OwusSTzbuxed+y0o4pqUcZLeuQPE7o9Q0ERP1T2859SlHBK
         swDXpNsO2sseabX97kJN/6O4FliaKLmz/0n5+zOfFOhIc71jVo20vJcnie48mgAzBh32
         YSPSVWZiitdeHf/qr6sagNpJv+45RDkOHNv90Ca9f1wMkoDLDoLK0Hka9u0ctg+akLmV
         r8Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0eL/B6Xsq6Q/24IYguuLfwVoh9qvE+Qw7MZOf5nGHyg=;
        b=o4THnMX22EHgY9XBlNVqjjVmEFR3vC/elzvYOeZ4Rxk5UxHTuiEI+geK4hvVdRBfHH
         YjJg+uAm3QU0MUCsvsplW0rBG2nNTybqkfkipmtzvnGRsIUCVZn/PXFOc0GBii7Q6ZTX
         2SJ2Hv0c88zXPuPiuk7Wq0fyv9KeuMF4wkSxd1O+EsEv9tjMHxwP3yDY3NqlL7XiQbb0
         A6zvXkI5DFowSC+uqKrjnJYSyBfV8V+3ePfXHv1jiLO2JHXtBkNnLf9qxTK0DCsFHoRD
         DfK4pP5OivMP6pZIO8AEtutTYsEuEhI0yV1/uOWkHSCGZAyK7Az6ziFceCLVc230ti9L
         8+2w==
X-Gm-Message-State: AOAM532XwUZIDWte8pDn8wnuLSG0eIa1gGB3iPZgtHuBDiS8mNd3j1Ws
        NQzGRJPx4AJXhrUqkAjwnj656w==
X-Google-Smtp-Source: ABdhPJx5Ic6DX2vQpbh90Yradu9W82hKhZ9FhXc7n7c05NjGIO6V9+vgFJUqzgqafzt2aOiNHdkPHQ==
X-Received: by 2002:a17:902:cec1:b029:eb:66ee:6da0 with SMTP id d1-20020a170902cec1b02900eb66ee6da0mr1001099plg.84.1618417068337;
        Wed, 14 Apr 2021 09:17:48 -0700 (PDT)
Received: from hermes.local (76-14-218-44.or.wavecable.com. [76.14.218.44])
        by smtp.gmail.com with ESMTPSA id r5sm5092591pjd.38.2021.04.14.09.17.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Apr 2021 09:17:48 -0700 (PDT)
Date:   Wed, 14 Apr 2021 09:17:38 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Tianyu Lan <ltykernel@gmail.com>, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, arnd@arndb.de, akpm@linux-foundation.org,
        konrad.wilk@oracle.com, hch@lst.de, m.szyprowski@samsung.com,
        robin.murphy@arm.com, joro@8bytes.org, will@kernel.org,
        davem@davemloft.net, kuba@kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, Tianyu Lan <Tianyu.Lan@microsoft.com>,
        iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org, vkuznets@redhat.com,
        thomas.lendacky@amd.com, brijesh.singh@amd.com,
        sunilmut@microsoft.com
Subject: Re: [Resend RFC PATCH V2 08/12] UIO/Hyper-V: Not load UIO HV driver
 in the isolation VM.
Message-ID: <20210414091738.3df4bed5@hermes.local>
In-Reply-To: <YHcOL+HlEoh5jPb8@kroah.com>
References: <20210414144945.3460554-1-ltykernel@gmail.com>
        <20210414144945.3460554-9-ltykernel@gmail.com>
        <YHcOL+HlEoh5jPb8@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 14 Apr 2021 17:45:51 +0200
Greg KH <gregkh@linuxfoundation.org> wrote:

> On Wed, Apr 14, 2021 at 10:49:41AM -0400, Tianyu Lan wrote:
> > From: Tianyu Lan <Tianyu.Lan@microsoft.com>
> > 
> > UIO HV driver should not load in the isolation VM for security reason.
> > Return ENOTSUPP in the hv_uio_probe() in the isolation VM.
> > 
> > Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>

This is debatable, in isolation VM's shouldn't userspace take responsibility
to validate host communication. If that is an issue please participate with
the DPDK community (main user of this) to make sure netvsc userspace driver
has the required checks.


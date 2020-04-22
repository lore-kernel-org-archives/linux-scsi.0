Return-Path: <SRS0=1vX0=6G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B54EC54FCC
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 06:43:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A83A206E9
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 06:43:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Gb7ek6Yt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbgDVGnh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Apr 2020 02:43:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726041AbgDVGng (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Apr 2020 02:43:36 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A861DC03C1A6;
        Tue, 21 Apr 2020 23:43:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=n7bSWCy+yjEVd5/eEit7zxHT7ampFTjRw0vL4VxyfNM=; b=Gb7ek6Ytu/i+eVBcw6iQxNRQEX
        lFgqHAf+9baTdGXdabiAr/PxaKU/oTW7Od3ihMdBHDjmsw2H9DdSVYQ4FcFp/AXzBP9uD0vzsacV/
        tapmfrVksjcwdz0iIZuA5IBGrntQKC4uadFOFu+jhE2oUFc5Y8eNtHx8OPg8ZOGvMM5H8XOFUjtYb
        jnV/wJiasU6SV/kWNNNaYsCWbiJMLiM6eA8QR1Tyjvqq3D/oU/b1o+4SsGGVGBp0y5/Uswp+dlj1Z
        K7xwQEHwC3D/bE1rZnu8fqFKkgIFx9hPGXQSQ3wxr3r/2mZXpv9GXLabkoKPcyLT6Yw6wjLd+2wkO
        UKrLSXjQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jR96S-0004JA-9L; Wed, 22 Apr 2020 06:43:24 +0000
Date:   Tue, 21 Apr 2020 23:43:24 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     huobean@gmail.com
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/5] UFS Host Performance Booster (HPB v1.0) driver
Message-ID: <20200422064324.GF20318@infradead.org>
References: <20200416203126.1210-1-beanhuo@micron.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200416203126.1210-1-beanhuo@micron.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Apr 16, 2020 at 10:31:21PM +0200, huobean@gmail.com wrote:
> From: Bean Huo <beanhuo@micron.com>
> 
> Hi,
> I disclose my development/changes on UFS HPB (UFS Host Performance Booster) to
> the community, as this would enable more UFS developers to test and start an
> iterative review and update process.
> 
> The HPB is defined in Jedec Standard Universal Flash (UFS) Host Performance
> Booster (HPB) Extension Version 1.0, which is designed to improve  read
> performance by utilizing the host side memory. Based on our testing, the HPB
> can increase the random read performance by up to about 46% in the random read.
> 
> The original HPB driver is from [1]. Based on it, I did optimizations,
> simplifications, fixed reliability issues, implemented HPB host control mode
> and make it much more readable. which's pushed to here [2] as V1.
> 
> To avoid touching the traditional SCSI core, the HPB driver in this series HPB
> patch chooses to develop under SCSI sub-system layer, and sits the same layer
> with UFSHCD. At the same time, to minimize changes to UFSHCD driver, the HPB
> driver submits its HPB READ BUFFER and HPB WRITE BUFFER requests to the scsi
> device->request_queueu to execute, rather than that directly go through
> raw UPIU request path.

This feature is completley broken, and rather dangerous due to feeding
"physical" addresses looked up by the host in.  I do not think we should
support something that broken in Linux.

Independent of that using two requests in the I/O path is not going
to fly either.  The whole thing seems like an exercise in benchmarketing.

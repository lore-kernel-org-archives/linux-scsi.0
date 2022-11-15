Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC61AC433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Nov 2022 07:48:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbiKOHsi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Nov 2022 02:48:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbiKOHsh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Nov 2022 02:48:37 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EECF62AC7
        for <linux-scsi@vger.kernel.org>; Mon, 14 Nov 2022 23:48:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=C1Yse1Y7N+i3Us6jNkQq1BpK1R2Mfu3Rl2Fn/SJdLw4=; b=eab8igs+5PmVO7Z8fAJ7ihTIff
        8iLvUB48yBeoIqKv8omn50c1aXyWRLMvuYik3YRkEV2qyI3Kxxj6NSOz6XiDY9ApFIto+jQqJV8V8
        X/fVTqKyvUuaGeN0utapyPmDPrFb0QRBxaZIMGccxhuRTqYGP5dh+c1fH3sVQaat3d5OkHcFncsFy
        4ntPdPXmog2Kp6NyhmsMTH6LEK0c7VjU4ZI3eBfBTr0XxWpc5kBx0qxrpp6Mcj/UDIAohYMzzZFCR
        qGBm2WajH77hdLgPDRhfhYXE/uKq7ClUOFBWC6Rhq82ZXBCmygPKYibOyuPuLGDGm1Z0Ix4DC6tFt
        Ctt4Rx6A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ouqgH-008gir-4W; Tue, 15 Nov 2022 07:48:29 +0000
Date:   Mon, 14 Nov 2022 23:48:29 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Eric Biggers <ebiggers@google.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jinyoung Choi <j-young.choi@samsung.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>
Subject: Re: [PATCH v3 5/5] scsi: ufs: Allow UFS host drivers to override the
 sg entry size
Message-ID: <Y3NETRqATLK2Z6LZ@infradead.org>
References: <20221108233339.412808-1-bvanassche@acm.org>
 <20221108233339.412808-6-bvanassche@acm.org>
 <Y2uechJH/4GFDs8h@infradead.org>
 <e343400f-2c87-8abf-5ebc-9c9a4a9030d4@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e343400f-2c87-8abf-5ebc-9c9a4a9030d4@acm.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Nov 09, 2022 at 09:29:47AM -0800, Bart Van Assche wrote:
> I'm not sure how to interpret your reply. Anyway, this patch is required to
> use the encryption functionality of the UFS Exynos controller. The
> "vendor-specific fields" text in the patch description refers to the
> encryption fields since these follow the data buffer when using the Exynos
> controller. Although it makes me unhappy that the UFS Exynos controller is
> not compliant with the UFS specification, since it is being used widely I
> think we need support for this controller in the upstream kernel.

The fact that in UFS no one sticks to the standard, and not one but
us in the kernel being more strict and your employer sticking to that
can fix it.

But that's not the point here - the point is that such fields are
always implementation specific and never vendor specific.  Any
particular vendor can, and often does, have various different
implementation specific derivations from or extensions to a spec.

Just like there is no 'vendor' driver as there are plenty different
drivers for the same device class from the same manufacturer.

Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45ECBC4361B
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Dec 2020 21:41:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1AA7F23372
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Dec 2020 21:41:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392775AbgLKUrM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Dec 2020 15:47:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:41778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391288AbgLKUrJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 11 Dec 2020 15:47:09 -0500
Date:   Fri, 11 Dec 2020 12:46:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607719589;
        bh=W3XvV2FN8bnGn+0PE+UG66OnmrvBWes/FNmdjqojzaE=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=pVpvQXxdGH6hT8/deIH1b8KzzSU0P9l0Wa7k98mQrV/z/baUAEWISNvcHPkvyfwV4
         sIKtbNz6vlZEAmuqi6eWbIT6dppb13Sry8pkgZaGYdgxYQ8QxQysi6kBQR7mZbtj9R
         9KMnIGngOCJ90nfdMXaoRPljwwqfIkIhisA/+G2BPUz/kMzAqAKruFlXn6o08dWEJd
         G5AC3fFNB4WZ6YwBq7bCJJg4CvAoaJAk3Asel0VMBP428Oyj1UAQeMKVZPmB/njDev
         Cr2PQqRB6nX5zWogRC5Axyx7nGR2t4KWjqtUAs0Bec5P7BikHL1Zj3Kc8zgS5P12Up
         1DGs5ovOXtf5w==
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, cang@codeaurora.org,
        alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
        martin.petersen@oracle.com, stanley.chu@mediatek.com
Subject: Re: [PATCH] scsi: ufs: fix memory boundary check for UFS 3.0
Message-ID: <X9Pao72HrNrVB5Fn@google.com>
References: <20201211193814.1709484-1-jaegeuk@kernel.org>
 <X9PaCUbaIFhsKgc7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X9PaCUbaIFhsKgc7@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/11, Eric Biggers wrote:
> On Fri, Dec 11, 2020 at 11:38:14AM -0800, Jaegeuk Kim wrote:
> > From: Jaegeuk Kim <jaegeuk@google.com>
> > 
> > If param_offset is greater than what UFS supports, it'll give kernel panic.
> > 
> > Signed-off-by: Jaegeuk Kim <jaegeuk@google.com>
> > Change-Id: I48ea6f3f3074bd42abf4ecf8be87806732f3e6a3
> > ---
> >  drivers/scsi/ufs/ufshcd.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> > index d6a3a0ba6960..04687661d0df 100644
> > --- a/drivers/scsi/ufs/ufshcd.c
> > +++ b/drivers/scsi/ufs/ufshcd.c
> > @@ -3194,6 +3194,9 @@ int ufshcd_read_desc_param(struct ufs_hba *hba,
> >  		return -EINVAL;
> >  	}
> >  
> > +	if (param_offset > buff_len)
> > +		return -EINVAL;
> > +
> >  	/* Check whether we need temp memory */
> >  	if (param_offset != 0 || param_size < buff_len) {
> >  		desc_buf = kmalloc(buff_len, GFP_KERNEL);
> > -- 
> 
> Didn't this already get fixed by:
> 
> 	commit 1699f980d87fb678a669490462cf0b9517c1fb47
> 	Author: Can Guo <cang@codeaurora.org>
> 	Date:   Wed Oct 21 22:59:00 2020 -0700
> 
> 	    scsi: ufs: Fix unexpected values from ufshcd_read_desc_param()

Oh, cool. Yes, please ignore this.

Thanks,

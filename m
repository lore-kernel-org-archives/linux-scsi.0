Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EB2BC433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Dec 2020 21:39:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED60323372
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Dec 2020 21:39:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404164AbgLKUpE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Dec 2020 15:45:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:41274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726648AbgLKUol (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 11 Dec 2020 15:44:41 -0500
Date:   Fri, 11 Dec 2020 12:43:53 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607719435;
        bh=XcX7+spUVzxQU2kUDRo52Z3TxHXsNz38Q4dbCvUXJLM=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=leJmo82gpXgvmCGOYQOZxcw5lJONE+q+gzxcZb6Yvgt91/lSWgGAG7ZEqYztg4rDC
         DywMKnin/wrojGutM27uCxaSOnClCmhYmpfLwy2FU8yifm3V5NUCub3aYxzLnix27o
         npNpFEVOxbbLlI1JJHYM1KL7RuS9VdfEQp+t3FJVeNgc084/hx/fK+yDeJDeB7z56s
         6yV05xjabm8hIIhNddTsq5BCqmt3NYUiTdFP7HEXfSjqBMmSohMerZ66wPOsfWClSO
         6WMi0d9vPRCNmff9kVB8EiE4sA0jjlM76+NoBcy3TI9MR2Y1DTM3su4qYkLMG4XORY
         aGylM9LaYE+aw==
From:   Eric Biggers <ebiggers@kernel.org>
To:     Jaegeuk Kim <jaegeuk@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, cang@codeaurora.org,
        alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        Jaegeuk Kim <jaegeuk@google.com>
Subject: Re: [PATCH] scsi: ufs: fix memory boundary check for UFS 3.0
Message-ID: <X9PaCUbaIFhsKgc7@gmail.com>
References: <20201211193814.1709484-1-jaegeuk@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201211193814.1709484-1-jaegeuk@kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Dec 11, 2020 at 11:38:14AM -0800, Jaegeuk Kim wrote:
> From: Jaegeuk Kim <jaegeuk@google.com>
> 
> If param_offset is greater than what UFS supports, it'll give kernel panic.
> 
> Signed-off-by: Jaegeuk Kim <jaegeuk@google.com>
> Change-Id: I48ea6f3f3074bd42abf4ecf8be87806732f3e6a3
> ---
>  drivers/scsi/ufs/ufshcd.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index d6a3a0ba6960..04687661d0df 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -3194,6 +3194,9 @@ int ufshcd_read_desc_param(struct ufs_hba *hba,
>  		return -EINVAL;
>  	}
>  
> +	if (param_offset > buff_len)
> +		return -EINVAL;
> +
>  	/* Check whether we need temp memory */
>  	if (param_offset != 0 || param_size < buff_len) {
>  		desc_buf = kmalloc(buff_len, GFP_KERNEL);
> -- 

Didn't this already get fixed by:

	commit 1699f980d87fb678a669490462cf0b9517c1fb47
	Author: Can Guo <cang@codeaurora.org>
	Date:   Wed Oct 21 22:59:00 2020 -0700

	    scsi: ufs: Fix unexpected values from ufshcd_read_desc_param()

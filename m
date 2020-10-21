Return-Path: <SRS0=hn0g=D4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC7F7C388CE
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Oct 2020 04:41:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65C5222200
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Oct 2020 04:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603255293;
	bh=6uZ87hYjpqMWbluAtKdcHz+J86BJB1yfOvW6vRcBnTw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=odziGPbb9hrTH7qngnruxUqzifSN+DT/+FYKo1fn7onBH1RKHV98ULvRq5rPrd1bo
	 t8mlN4aCLk4lx6LtdIYsj+KiGhYi/9yFUcnCe4/NyvQPuEgAcpdLsFWMTOWs6q/3mQ
	 mwmzh87zktn4JwG+ajiSY1VVUTvdTxrMl8+3Sc+8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440215AbgJUEla (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Oct 2020 00:41:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:51088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440212AbgJUEl3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 21 Oct 2020 00:41:29 -0400
Received: from localhost (unknown [104.132.1.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C58E420870;
        Wed, 21 Oct 2020 04:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603255288;
        bh=6uZ87hYjpqMWbluAtKdcHz+J86BJB1yfOvW6vRcBnTw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TBXG1QljTF457ZpXCoGUHETOtkFuOQeydOxijaUXSFCz4y2/eiv3wWmaA2PJC2UbZ
         k4jRcyF7pl6MMWiMXan8KdWqmIKqhVPCqlMr4WDb1Aqus7d7Utu2sY8Gq6M77i3wUf
         wUibrN875yx1UDLUgLhi3ybi9icUSrlBSAUv/M3A=
Date:   Tue, 20 Oct 2020 21:41:28 -0700
From:   jaegeuk@kernel.org
To:     Can Guo <cang@codeaurora.org>
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, kernel-team@android.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>
Subject: Re: [PATCH v2 1/5] scsi: ufs: atomic update for clkgating_enable
Message-ID: <20201021044128.GA3004521@google.com>
References: <20201020195258.2005605-1-jaegeuk@kernel.org>
 <20201020195258.2005605-2-jaegeuk@kernel.org>
 <6c7bc6794b215a0ae1ae0cd9d448efa3@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6c7bc6794b215a0ae1ae0cd9d448efa3@codeaurora.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/21, Can Guo wrote:
> On 2020-10-21 03:52, Jaegeuk Kim wrote:
> > From: Jaegeuk Kim <jaegeuk@google.com>
> > 
> > When giving a stress test which enables/disables clkgating, we hit
> > device
> > timeout sometimes. This patch avoids subtle racy condition to address
> > it.
> > 
> > Cc: Alim Akhtar <alim.akhtar@samsung.com>
> > Cc: Avri Altman <avri.altman@wdc.com>
> > Cc: Can Guo <cang@codeaurora.org>
> > Signed-off-by: Jaegeuk Kim <jaegeuk@google.com>
> 
> Reviewed-by: Can Guo <cang@codeaurora.org>
> 
> Next time can you have a cover letter in case of multiple patches?

Ah, it seems I had to cc you here as well.

https://lore.kernel.org/linux-scsi/20201020195258.2005605-1-jaegeuk@kernel.org/T/#mb4e43f3bd03a6b7bc136bea21ac805041c1417a2

> 
> Thanks,
> 
> Can Guo.
> 
> > ---
> >  drivers/scsi/ufs/ufshcd.c | 12 ++++++------
> >  1 file changed, 6 insertions(+), 6 deletions(-)
> > 
> > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> > index b8f573a02713..7344353a9167 100644
> > --- a/drivers/scsi/ufs/ufshcd.c
> > +++ b/drivers/scsi/ufs/ufshcd.c
> > @@ -1807,19 +1807,19 @@ static ssize_t
> > ufshcd_clkgate_enable_store(struct device *dev,
> >  		return -EINVAL;
> > 
> >  	value = !!value;
> > +
> > +	spin_lock_irqsave(hba->host->host_lock, flags);
> >  	if (value == hba->clk_gating.is_enabled)
> >  		goto out;
> > 
> > -	if (value) {
> > -		ufshcd_release(hba);
> > -	} else {
> > -		spin_lock_irqsave(hba->host->host_lock, flags);
> > +	if (value)
> > +		__ufshcd_release(hba);
> > +	else
> >  		hba->clk_gating.active_reqs++;
> > -		spin_unlock_irqrestore(hba->host->host_lock, flags);
> > -	}
> > 
> >  	hba->clk_gating.is_enabled = value;
> >  out:
> > +	spin_unlock_irqrestore(hba->host->host_lock, flags);
> >  	return count;
> >  }

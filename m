Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6209AC433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Dec 2020 17:20:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2EBDE22CA1
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Dec 2020 17:20:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726155AbgLURUa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Dec 2020 12:20:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:60422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725833AbgLURU3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 21 Dec 2020 12:20:29 -0500
Date:   Mon, 21 Dec 2020 09:19:47 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608571189;
        bh=wPj0xjQToUwmlmERjSRgyfHiQl2REANx9BVSI/YNQuc=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=oeF8bzI3NpfW3FgxfVfdNpMS0A969fYXYj7RSORAwoNRum1QXQEliaIr3qJt08GsD
         /olvm77hJJIEvSRnWIXtQ5AKTYhAchQZvus/s1NXO0oknybC6K3qco0mIiINFXFecc
         rerbnlajLZY22Q5/n2RHifh4Nu86QpWwmqXUfOfp5KQzCR/E+0lhyljikPwS/XEsmc
         UPIvpCHeAzW0AlMkHahI7670I/DsgsLti2ynanW8XrZsniuzG2s/pjGX38z++vBgZ5
         /SWsKeYZya68gOFZKpLu3caN2m/I1LIuc1cEFvgpSTRql6Dl4jiY1yZ5UkyVxFr6M7
         1iIgWsZHFVQ4A==
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     Avri Altman <Avri.Altman@wdc.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>
Subject: Re: [PATCH] scsi: ufs: fix livelock of ufshcd_clear_ua_wluns
Message-ID: <X+DZMwSHsskcEgZE@google.com>
References: <20201218033131.2624065-1-jaegeuk@kernel.org>
 <DM6PR04MB6575B8729A62E6FB9F19930CFCC10@DM6PR04MB6575.namprd04.prod.outlook.com>
 <X+C9+1p1CbssKRdO@google.com>
 <DM6PR04MB65753B9D31B3643C757E4E23FCC00@DM6PR04MB6575.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR04MB65753B9D31B3643C757E4E23FCC00@DM6PR04MB6575.namprd04.prod.outlook.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/21, Avri Altman wrote:
> > > > When gate_work/ungate_work gets an error during hibern8_enter or
> > exit,
> > > >  ufshcd_err_handler()
> > > >    ufshcd_scsi_block_requests()
> > > >    ufshcd_reset_and_restore()
> > > >      ufshcd_clear_ua_wluns() -> stuck
> > > >    ufshcd_scsi_unblock_requests()
> > > >
> > > > In order to avoid it, ufshcd_clear_ua_wluns() can be called per recovery
> > > > flows
> > > > such as suspend/resume, link_recovery, and error_handler.
> > > Not sure that suspend/resume are UAC events?
> > 
> > Could you elaborate a bit? The goal is to clear UAC after UFS reset happens.
> So why calling it on every suspend and resume?

1. If UAC was cleared, there's no impact. 
2. ufshcd_link_recovery() can reset UFS directly by ufs_mtk_resume().
3. ufshcd_suspend can call ufshcd_host_reset_and_restore() as well.

> 
> > 
> > >
> > > Also the 'fixes' tag is missing.
> > 
> > Added. Thanks,
> > 
> > >
> > > Thanks,
> > > Avri

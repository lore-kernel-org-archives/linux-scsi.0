Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E4DFC433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Dec 2020 15:24:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49A0222CA1
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Dec 2020 15:24:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725935AbgLUPYW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Dec 2020 10:24:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:37026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725878AbgLUPYV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 21 Dec 2020 10:24:21 -0500
Date:   Mon, 21 Dec 2020 07:23:39 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608564221;
        bh=HJioMRVoMcIT1Q6KWC46hvYYCP4FmWGVONl/2sz7K3I=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=Tle9YVzSU6i6OT2eMgFgoD5m7Sy0TsxEeAUHQaIsR8SCmLZpF4CDwoP6JvB3uIKp+
         Vk0FYheN+3mAlKwW1TuztXLIVb81eY0oezrUe4Pcu9unRVdUUSrOs2Pyz3qE0jygwU
         ktt8tUuc6G3baIFp9QTy+XJi+p7C3kMpHIkUN01cZhe8aH2ieqRt6O8+fWYf+fnBcd
         1KR5nwOeKew4jKuQck0r8ZJbBjnYo7kxVfUzJUUmsUVHfDjYJf5O23F0oKILYnrLOx
         ySWWGecX4uX53K/8gmxPA6NUDDrUJBw7DkXrk2SqXMeTOSQYwfJsOkpZIJbniM3+yu
         Apmkr2WfbjR5A==
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
Message-ID: <X+C9+1p1CbssKRdO@google.com>
References: <20201218033131.2624065-1-jaegeuk@kernel.org>
 <DM6PR04MB6575B8729A62E6FB9F19930CFCC10@DM6PR04MB6575.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR04MB6575B8729A62E6FB9F19930CFCC10@DM6PR04MB6575.namprd04.prod.outlook.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

On 12/20, Avri Altman wrote:
> Hi J,
>  
> > 
> > When gate_work/ungate_work gets an error during hibern8_enter or exit,
> >  ufshcd_err_handler()
> >    ufshcd_scsi_block_requests()
> >    ufshcd_reset_and_restore()
> >      ufshcd_clear_ua_wluns() -> stuck
> >    ufshcd_scsi_unblock_requests()
> > 
> > In order to avoid it, ufshcd_clear_ua_wluns() can be called per recovery
> > flows
> > such as suspend/resume, link_recovery, and error_handler.
> Not sure that suspend/resume are UAC events?

Could you elaborate a bit? The goal is to clear UAC after UFS reset happens.

>  
> Also the 'fixes' tag is missing.

Added. Thanks,

> 
> Thanks,
> Avri

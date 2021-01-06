Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1AD8C433E6
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Jan 2021 04:29:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 894AA22D04
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Jan 2021 04:29:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725808AbhAFE3J (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Jan 2021 23:29:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:55950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725730AbhAFE3J (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 5 Jan 2021 23:29:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4BEBB222F9;
        Wed,  6 Jan 2021 04:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609907308;
        bh=lz5BPWBzDYfTPkYHVZajN8FoXiDTDIGP/JUJVEKRIQc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WhHX8Mp/LLEhHsNFTV8RfCUC/m+XgfIb/nO2QKVvDooAvP27eeSQJRm+1ZxLNMzdM
         T2x7DJ7Eq9Z68aYlg1FbpNjPUkEjA8b8w7D/Ow8nuYZOYyr6iHEEVxpDvx6mLpOZqQ
         E/KPh8hHRL79REJtA0/sze/CrCsnU/ruazz8/euLrL1IbSl5EJbYU4A2wgnW2ImwN4
         TAas8IMUyZkzygSuX/sVtfV2eurpQtsP7/rrP9vmWcIOtpSYe8OIDXVvWLzstw/bQR
         b3esiDAHCynRzapobDHqf5S/Ygn4h919085WiTKg7o8BiYl4N3kwExWsLMhg1biWtG
         RELU/yms5zN+w==
Date:   Tue, 5 Jan 2021 20:28:26 -0800
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, cang@codeaurora.org,
        alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
        stanley.chu@mediatek.com
Subject: Re: [PATCH v2] scsi: ufs: fix livelock of ufshcd_clear_ua_wluns
Message-ID: <X/U8avB/Sy546xlh@google.com>
References: <20201218033131.2624065-1-jaegeuk@kernel.org>
 <X+C+oqegC7EI6zDv@google.com>
 <yq17doqg2j3.fsf@ca-mkp.ca.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq17doqg2j3.fsf@ca-mkp.ca.oracle.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 01/05, Martin K. Petersen wrote:
> 
> Jaegeuk,
> 
> > When gate_work/ungate_work gets an error during hibern8_enter or exit,
> >  ufshcd_err_handler()
> >    ufshcd_scsi_block_requests()
> >    ufshcd_reset_and_restore()
> >      ufshcd_clear_ua_wluns() -> stuck
> >    ufshcd_scsi_unblock_requests()
> >
> > In order to avoid it, ufshcd_clear_ua_wluns() can be called per recovery flows
> > such as suspend/resume, link_recovery, and error_handler.
> >
> > Fixes: 1918651f2d7e ("scsi: ufs: Clear UAC for RPMB after ufshcd resets")
> > Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> 
> Please resubmit instead of replying to an existing patch. Both b4 and
> patchwork get confused.

Ok, I posted a new one. Thanks,

> 
> Thanks!
> 
> -- 
> Martin K. Petersen	Oracle Linux Engineering

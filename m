Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE516C433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 08:47:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C8A822AB9
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 08:47:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728111AbhAKIr0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jan 2021 03:47:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:42224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728100AbhAKIr0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 11 Jan 2021 03:47:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 69C4022581;
        Mon, 11 Jan 2021 08:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610354805;
        bh=iuSTbGqR+zsnjqjBJ9uA9PVEqOmt2IdakL8100IQQu8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=P89kzg7DSWAd18bJTIESq1nH4/nKUPtIt99k9lGIJQHXcws2N4kMrDpjn0rvF+UpD
         1mXRmtdQ+i4tWDKf9ALWlFmiJQVc3jOxxqOAIiOrOX3JwWEa0nezPxEUmopUajJDH9
         U8t0uhIg6rF3a5Lsx+6KtirpLqybb2xp/cXB03TSBMKHa6hzFGFIB1RswMVMWRSvNn
         Wki9pO90R7dZwEWMRqvqNCHFREzM7bD8wZswraqDsmlZq73XUHP/N97dEzDYULQK80
         wNWbk7hCb4XxYTJWIbXhxb1G6v3x7x9PonXph3CRW8uBJ4LM+ctWv7KWVyNHOuvgum
         Rq+pRWReWrgdA==
Date:   Mon, 11 Jan 2021 00:46:43 -0800
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     Can Guo <cang@codeaurora.org>
Cc:     Avri Altman <Avri.Altman@wdc.com>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        alim.akhtar@samsung.com, bvanassche@acm.org,
        martin.petersen@oracle.com, stanley.chu@mediatek.com
Subject: Re: [PATCH] scsi: ufs: should not override buffer lengh
Message-ID: <X/wQcwkdSOTkuFBV@google.com>
References: <20210111044443.1405049-1-jaegeuk@kernel.org>
 <6551e7d6dd7dc4132dc69e77a51f6f21@codeaurora.org>
 <e1b29f7cdd62cefcc9355baaed66641f@codeaurora.org>
 <DM6PR04MB65753C88CF333FABF5CB1704FCAB0@DM6PR04MB6575.namprd04.prod.outlook.com>
 <f4f633617ce91628b251b6ba668df820@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f4f633617ce91628b251b6ba668df820@codeaurora.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 01/11, Can Guo wrote:
> On 2021-01-11 16:15, Avri Altman wrote:
> > > 
> > > Sorry, typo corrected.
> > > 
> > > Hi Jaegeuk,
> > > 
> > > I think the problem is that func ufshcd_read_desc_param() is not
> > > expecting
> > > one access unsupported descriptors on RPMB LU.
> > Correct.
> > This is about wb introducing a new constraint: wb buffer is only
> > allowed in lu 0..7.
> > And this is why, IMHO, the fix should be in ufs_is_valid_unit_desc_lun,
> > To include param offset, as it is only called in contingency of
> > ufshcd_read_desc_param.
> > 
> > Thanks,
> > Avri
> 
> Yeah... Fixing it in ufs-sysfs.c also works. Anyways, the math in
> ufshcd_read_desc_param is already complex. Let's fix it somewhere
> close to the source/initiator.

Thank you, Can and Avri.
I think fixing the lun check makese sense. Let me post v2. :)

> 
> Thanks,
> Can Guo.

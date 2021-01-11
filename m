Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8B47C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 10:00:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 744AE2231F
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 10:00:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728531AbhAKJ7o (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jan 2021 04:59:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:41942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725843AbhAKJ7o (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 11 Jan 2021 04:59:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E37E522AAF;
        Mon, 11 Jan 2021 09:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610359143;
        bh=i3qjYaMyb4Fbq9fOi04wCv4NycJQX3mfmS+k6khBG6o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bm8/GSmQvXeBE5VLdR5Gs73RpO/2fVppL3nxDZmiBXMuCmoyWfQsFt8LwVfY3bvQw
         sL1+0qmsYm3dsOfZIDtJZVT+VjEUjOClRy0WNNxaFcRTCVqzOgOKy5yxiFkFTY8mGm
         EfyM/BoXqe/I5d8rEaqNOPmZKcOJ2ec+uf9aQZQa1l1vx0tmnqSGfmzlzW9iSU6WwD
         kR8N6wHXrPp3HuXMShVDvtzHn6T4hfe3MP9xOobwqc+LyKi7IzURvAVIhWZbo/Z1EF
         B6Vf0p84mDrHLyLpqTpxpJJ1Vo4EhQ/PrS7wnEbk8cyihbzan7VOyCKLoGAD5KBGcw
         Mw8yDcsX3LvJQ==
Date:   Mon, 11 Jan 2021 01:59:01 -0800
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
Subject: Re: [PATCH v2] scsi: ufs: WB is not allowed in RPMB_LUN
Message-ID: <X/whZfoRQvEncfUS@google.com>
References: <20210111084756.1810924-1-jaegeuk@kernel.org>
 <DM6PR04MB657566F1BB8C808EFBF9FBB9FCAB0@DM6PR04MB6575.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR04MB657566F1BB8C808EFBF9FBB9FCAB0@DM6PR04MB6575.namprd04.prod.outlook.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 01/11, Avri Altman wrote:
> >  static inline bool ufs_is_valid_unit_desc_lun(struct ufs_dev_info *dev_info,
> > -               u8 lun)
> > +               u8 lun, u8 param_offset)
> >  {
> >         if (!dev_info || !dev_info->max_lu_supported) {
> >                 pr_err("Max General LU supported by UFS isn't initialized\n");
> >                 return false;
> >         }
> > -
> > +       /* WB is not allowed in RPMB_WLUN */
> /* wb is only allowed to either a sha*/
> > +       if (param_offset == UNIT_DESC_PARAM_WB_BUF_ALLOC_UNITS)
> > +               return lun < dev_info->max_lu_supported;
> I think here you should use UFS_UPIU_MAX_WB_LUN_ID and not dev_info->max_lu_supported.

Ok, sending v3.

> 
> Thanks,
> Avri

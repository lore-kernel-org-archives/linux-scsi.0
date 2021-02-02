Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20EF0C433E6
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Feb 2021 11:13:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EBADA64F4F
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Feb 2021 11:13:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbhBBLNL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Feb 2021 06:13:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:56078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230073AbhBBLNI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 2 Feb 2021 06:13:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5BBA464E31;
        Tue,  2 Feb 2021 11:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612264348;
        bh=vHI7p08V2NUSHBNsPQcfDGdq5KHMXE1sVgvKoHPTqNk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=POeleXDMPfS7RAz68GaJjL/+ulxVZfeEfXWWYyApI8pHjcSagO1sQfHV8L5OcV5k/
         H+VGOiGpAQQbxwDJCJCzZHocIJwLgz4KFt5JR19I2mwgpLToq2e6BWb/eluu8bzcpm
         Dyjr/pOA0LyQdw0dgIF3lrjEGV87xWIT2sEd8Suo=
Date:   Tue, 2 Feb 2021 12:12:23 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Avri Altman <Avri.Altman@wdc.com>
Cc:     "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "huobean@gmail.com" <huobean@gmail.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>
Subject: Re: [PATCH v19 1/3] scsi: ufs: Introduce HPB feature
Message-ID: <YBkzlyj7BjXSVgDk@kroah.com>
References: <20210129052848epcms2p6e5797efd94e6282b76ad9ae6c99e3ab5@epcms2p6>
 <CGME20210129052848epcms2p6e5797efd94e6282b76ad9ae6c99e3ab5@epcms2p1>
 <20210129052936epcms2p136a2ae69803ca399c99e815e1244779a@epcms2p1>
 <DM6PR04MB65756A9DEB4F12043FA9C8BCFCB59@DM6PR04MB6575.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DM6PR04MB65756A9DEB4F12043FA9C8BCFCB59@DM6PR04MB6575.namprd04.prod.outlook.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Feb 02, 2021 at 07:46:47AM +0000, Avri Altman wrote:
> Daejun,
> 
> >  static const struct attribute_group *ufshcd_driver_groups[] = {
> >         &ufs_sysfs_unit_descriptor_group,
> >         &ufs_sysfs_lun_attributes_group,
> > +#ifdef CONFIG_SCSI_UFS_HPB
> > +       &ufs_sysfs_hpb_stat_group,
> > +#endif
> >         NULL,
> >  };
> Aren’t you creating a hpb_stats entries for every lun (even wlun)?
> This is confusing, even if safe (any non-hpb lun returns NODEV).
> Also user-space have no way to know which entry is valid.
> 
> Can we group those under ufshpb_lu<lun id> for valid hpb luns only?

How do you determine a valid lun?  If the kernel knows, then it should
just not create the files for any that is "invalid", which it can do by
setting the correct mode in the attribute group.

> Also need to document the stats?  Maybe in a separate sysfs-driver-ufs-features?

Aren't they all documented in the
Documentation/ABI/testing/sysfs-driver-ufs file in this patch?  What is
missing?

thanks,

greg k-h

Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9ED0BC4320A
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Jul 2021 08:00:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84D8160C41
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Jul 2021 08:00:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234392AbhG1IAU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Jul 2021 04:00:20 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:26949 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234351AbhG1IAM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Jul 2021 04:00:12 -0400
Received: from epcas3p2.samsung.com (unknown [182.195.41.20])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210728080003epoutp01e59ec454cbc2a3a0b3eadc9ad62a7f5f~V5YXqoWBv0282002820epoutp01L
        for <linux-scsi@vger.kernel.org>; Wed, 28 Jul 2021 08:00:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210728080003epoutp01e59ec454cbc2a3a0b3eadc9ad62a7f5f~V5YXqoWBv0282002820epoutp01L
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1627459203;
        bh=JqyD7m7APWwmtPpLdjR4HK5PnGYNNpt30gwpI0+/Z1k=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=Fb/PS5E1HIpMYXJH79a9g4wJHgB8j1iBLfKb9g8MQO9wvGbJtw9w2e5vwOpBu5/NW
         RgFBSnCCObEzzK9OuzXf49SI9JwxlTvle9apayZj//L+QRJx9TwO3t2t9YRXj1y7pW
         iaqzO6SewfvpotXuh50v4sdbWuStYNMz3aPLxAV8=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas3p2.samsung.com (KnoxPortal) with ESMTP id
        20210728080002epcas3p202065d45c64cbf868df919fccfae17f3~V5YWR8AnM0109501095epcas3p2z;
        Wed, 28 Jul 2021 08:00:02 +0000 (GMT)
Received: from epcpadp3 (unknown [182.195.40.17]) by epsnrtp1.localdomain
        (Postfix) with ESMTP id 4GZR0L19CKz4x9Q7; Wed, 28 Jul 2021 08:00:02 +0000
        (GMT)
Mime-Version: 1.0
Subject: RE:(2) [PATCH 2/3] scsi: ufs: Map the correct size to the rpmb unit
 descriptor
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     Avri Altman <Avri.Altman@wdc.com>,
        Daejun Park <daejun7.park@samsung.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Bean Huo <beanhuo@micron.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <DM6PR04MB6575191C52E5323A9754B2E7FCEA9@DM6PR04MB6575.namprd04.prod.outlook.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <2038148563.21627459202139.JavaMail.epsvc@epcpadp3>
Date:   Wed, 28 Jul 2021 16:51:56 +0900
X-CMS-MailID: 20210728075156epcms2p42663012c52063e014911b255b7908d8a
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20210727123637epcas2p23457bd807cee66ec4c4e487a3a15ef33
References: <DM6PR04MB6575191C52E5323A9754B2E7FCEA9@DM6PR04MB6575.namprd04.prod.outlook.com>
        <20210727123546.17228-3-avri.altman@wdc.com>
        <20210727123546.17228-1-avri.altman@wdc.com>
        <2038148563.21627450982237.JavaMail.epsvc@epcpadp4>
        <CGME20210727123637epcas2p23457bd807cee66ec4c4e487a3a15ef33@epcms2p4>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

> > Hi Avri,
> > 
> > > diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h index
> > > 579cf6f9e7a1..d0be8d4c8091 100644
> > > --- a/drivers/scsi/ufs/ufs.h
> > > +++ b/drivers/scsi/ufs/ufs.h
> > > @@ -167,6 +167,7 @@ enum desc_idn {
> > >          QUERY_DESC_IDN_GEOMETRY                = 0x7,
> > >          QUERY_DESC_IDN_POWER                = 0x8,
> > >          QUERY_DESC_IDN_HEALTH           = 0x9,
> > > +        QUERY_DESC_IDN_UNIT_RPMB        = 0xA,
> > >          QUERY_DESC_IDN_MAX,
> > 
> > By adding QUERY_DESC_IDN_UNIT_RPMB, the value of
> > QUERY_DESC_IDN_MAX is changed to 0xB.
> > ...
> Yes
>  
> > 
> > > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> > > index 74ccfd2b80ce..eec1bc95391b 100644
> > > --- a/drivers/scsi/ufs/ufshcd.c
> > > +++ b/drivers/scsi/ufs/ufshcd.c
> > > @@ -3319,11 +3319,13 @@ int ufshcd_query_descriptor_retry(struct ufs_hba
> > *hba,
> > >   * @desc_len: mapped desc length (out)
> > >   */
> > >  void ufshcd_map_desc_id_to_length(struct ufs_hba *hba, enum desc_idn
> > desc_id,
> > > -                                  int *desc_len)
> > > +                                  int desc_index, int *desc_len)
> > >  {
> > >          if (desc_id >= QUERY_DESC_IDN_MAX || desc_id ==
> > QUERY_DESC_IDN_RFU_0 ||
> > >              desc_id == QUERY_DESC_IDN_RFU_1)
> > >                  *desc_len = 0;
> > 
> > So, if user sending desc_id as 0xA, it can not be detected as invalid descriptor.
> Which user?
> Oh, you mean if someone uses the ufs-bsg with some upiu-based query app, like ufs-utils?
> Well, those apps are for developers and field engineers, expected to know what they are doing...

Yes, but checking QUERY_DESC_IDN_MAX can be useless because of adding entry in enum desc_idn.
 
> Alternatively, maybe its better to just remove the unit descriptor sysfs entries for wlun altogether?
> They really meant nothing and shouldn't be there in the first place.
> What do you think?

Although if they were removed, ufs-bsg can access unit descriptors of wlun.
But it can be OK because developers are expected to access unit descriptors of wlun correctly.
So, I think it can be a solution.

> Thanks,
> Avri 
> > 
> > > +        else if (desc_index == UFS_UPIU_RPMB_WLUN)
> > > +                *desc_len = hba->desc_size[QUERY_DESC_IDN_UNIT_RPMB];
> > >          else
> > >                  *desc_len = hba->desc_size[desc_id];  }
> > 
> > Thanks,
> > Daejun
>  
>  
>  

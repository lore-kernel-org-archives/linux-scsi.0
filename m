Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E743DC433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 01:24:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD66364F92
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 01:24:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231269AbhCLBYG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Mar 2021 20:24:06 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:30291 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230159AbhCLBYA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Mar 2021 20:24:00 -0500
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210312012358epoutp01293736ce9479dd21bbdd5e00fc34ba03~rc9JhxZZn1139211392epoutp015
        for <linux-scsi@vger.kernel.org>; Fri, 12 Mar 2021 01:23:58 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210312012358epoutp01293736ce9479dd21bbdd5e00fc34ba03~rc9JhxZZn1139211392epoutp015
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1615512238;
        bh=e9XRKhdV4tUwTnRv6eKswADTpjPaULXyJLLF99XmKww=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=X2EVeGxfyD6ghsOuYRlNtHF5/4FBVXgQp6DC6leKAhlwYiWuH7KFMPwlCSOZCNvxe
         P6xIPK3466HvQVtuxzZNpqHq7QckpYUWEyBGcsrqsqf2nBuP73k+L6ZMO2aA+w1swG
         DzQ0C5MCN82pDZN6eaQu6F3/MCJrWz8HGB+Uj4rE=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20210312012357epcas2p20f474112bdaadca6d2afb0b02ae81773~rc9IqUpZY1137811378epcas2p20;
        Fri, 12 Mar 2021 01:23:57 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.185]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4DxSkz4g1wz4x9Py; Fri, 12 Mar
        2021 01:23:55 +0000 (GMT)
X-AuditID: b6c32a46-1d9ff7000000dbf8-1f-604ac2a99ed6
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        28.E3.56312.9A2CA406; Fri, 12 Mar 2021 10:23:53 +0900 (KST)
Mime-Version: 1.0
Subject: RE: Re: [PATCH v26 2/4] scsi: ufs: L2P map management for HPB read
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     Can Guo <cang@codeaurora.org>,
        Daejun Park <daejun7.park@samsung.com>
CC:     Greg KH <gregkh@linuxfoundation.org>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "huobean@gmail.com" <huobean@gmail.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        JinHwan Park <jh.i.park@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <27fe9c42f4b9539f07f75b7978ab305e@codeaurora.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20210312012353epcms2p8ac7d5a43ce7a78437e751fde1e85c9d4@epcms2p8>
Date:   Fri, 12 Mar 2021 10:23:53 +0900
X-CMS-MailID: 20210312012353epcms2p8ac7d5a43ce7a78437e751fde1e85c9d4
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLJsWRmVeSWpSXmKPExsWy7bCmme7KQ14JBhffKls8mLeNzWJv2wl2
        i5c/r7JZHL79jt1i2oefzBaf1i9jtXh5SNNi1YNwi+bF69ks5pxtYLLo7d/KZvH4zmd2i0U3
        tjFZ9P9rZ7G4vGsOm0X39R1sFsuP/2OyuL2Fy2Lp1puMFp3T17A4iHhcvuLtcbmvl8lj56y7
        7B4TFh1g9Ng/dw27R8vJ/SweH5/eYvHo27KK0ePzJjmP9gPdTAFcUTk2GamJKalFCql5yfkp
        mXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUDPKSmUJeaUAoUCEouLlfTtbIry
        S0tSFTLyi0tslVILUnIKDA0L9IoTc4tL89L1kvNzrQwNDIxMgSoTcjKmTj/NVDBNoeLjEccG
        xstiXYycHBICJhJr3v5n7GLk4hAS2MEoMePPc5YuRg4OXgFBib87hEFqhAW8JaYd+c0KYgsJ
        KEmsvziLHSKuJ3Hr4RpGEJtNQEdi+on7YHERAU+Jr5NXs4LMZBZYzibRuGw/K8QyXokZ7U9Z
        IGxpie3Lt4I1cwrYSSy99hqqRkPix7JeZghbVOLm6rfsMPb7Y/MZIWwRidZ7Z6FqBCUe/NwN
        FZeUOLb7AxOEXS+x9c4vsMckBHoYJQ7vvAW1QF/iWsdGsCN4BXwlFh3aDBZnEVCVaJ2+B2qQ
        i8Tay0vB4swC8hLb385hBgUKs4CmxPpd+iCmhICyxJFbLDBvNWz8zY7OZhbgk+g4/BcuvmPe
        E6jT1CTW/VzPNIFReRYipGch2TULYdcCRuZVjGKpBcW56anFRgVGyHG7iRGczrXcdjBOeftB
        7xAjEwfjIUYJDmYlEd4/e7wShHhTEiurUovy44tKc1KLDzGaAn05kVlKNDkfmFHySuINTY3M
        zAwsTS1MzYwslMR5iw0exAsJpCeWpGanphakFsH0MXFwSjUwuZj1TzzXfap7Ef+zL1ZStVsM
        t1YZ1yQzFl4Myc9mkD06rcXrn9XZmjqLhOi53zlLfzydt/mm5tNi64iE7YU8KuGujq+Peet+
        uOD+fOHer5aXa1x5ex2+PW34b7ZN6t1kLWPFrBOn1S73hGd/mhjWOWm/jw7D/sRb4r9YNxb3
        LW0v7P3l1PBq8oKptZtP7XkZ4OYxxyXmg+XHaDv7lWGL7tgYTZkS/MilW2Dek52aRVFRZ3ec
        VuU/flbpQKNP5KU9J5W3fvNpXTFdJ6DPdtVsu/Wrfj30qxOweng6X8Zfqbz/fvK/f3oxAc+Z
        RbNa294J9f4L6nBLss7alB7//tYr330vs3dyLmt1b5jvfe+MEktxRqKhFnNRcSIA83TgQ3AE
        AAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210303062633epcms2p252227acd30ad15c1ca821d7e3f547b9e
References: <27fe9c42f4b9539f07f75b7978ab305e@codeaurora.org>
        <20210303062633epcms2p252227acd30ad15c1ca821d7e3f547b9e@epcms2p2>
        <20210303062829epcms2p678450953f611c340a2b8e88b5542fe73@epcms2p6>
        <CGME20210303062633epcms2p252227acd30ad15c1ca821d7e3f547b9e@epcms2p8>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > The HPB divides logical addresses into several regions. A region 
> > consists
> > of several sub-regions. The sub-region is a basic unit where L2P 
> > mapping is
> > managed. The driver loads L2P mapping data of each sub-region. The 
> > loaded
> > sub-region is called active-state. The HPB driver unloads L2P mapping 
> > data
> > as region unit. The unloaded region is called inactive-state.
> > 
> > Sub-region/region candidates to be loaded and unloaded are delivered 
> > from
> > the UFS device. The UFS device delivers the recommended active 
> > sub-region
> > and inactivate region to the driver using sensedata.
> > The HPB module performs L2P mapping management on the host through the
> > delivered information.
> > 
> > A pinned region is a pre-set regions on the UFS device that is always
> > activate-state.
> > 
> > The data structure for map data request and L2P map uses mempool API,
> > minimizing allocation overhead while avoiding static allocation.
> > 
> > The mininum size of the memory pool used in the HPB is implemented
> > as a module parameter, so that it can be configurable by the user.
> > 
> > To gurantee a minimum memory pool size of 4MB: 
> > ufshpb_host_map_kbytes=4096
> > 
> > The map_work manages active/inactive by 2 "to-do" lists.
> > Each hpb lun maintains 2 "to-do" lists:
> >   hpb->lh_inact_rgn - regions to be inactivated, and
> >   hpb->lh_act_srgn - subregions to be activated
> > Those lists are maintained on IO completion.
> > 
> > Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> > Reviewed-by: Can Guo <cang@codeaurora.org>
> > Acked-by: Avri Altman <Avri.Altman@wdc.com>
> > Tested-by: Bean Huo <beanhuo@micron.com>
> > Signed-off-by: Daejun Park <daejun7.park@samsung.com>
> > ---
> >  drivers/scsi/ufs/ufs.h    |   36 ++
> >  drivers/scsi/ufs/ufshcd.c |    4 +
> >  drivers/scsi/ufs/ufshpb.c | 1091 ++++++++++++++++++++++++++++++++++++-
> >  drivers/scsi/ufs/ufshpb.h |   65 +++
> >  4 files changed, 1181 insertions(+), 15 deletions(-)
> > 
> > diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
> > index 65563635e20e..957763db1006 100644
> > --- a/drivers/scsi/ufs/ufs.h
> > +++ b/drivers/scsi/ufs/ufs.h
> > @@ -472,6 +472,41 @@ struct utp_cmd_rsp {
> >          u8 sense_data[UFS_SENSE_SIZE];
> >  };
> > ...
> > +/*
> > + * This function will parse recommended active subregion information 
> > in sense
> > + * data field of response UPIU with SAM_STAT_GOOD state.
> > + */
> > +void ufshpb_rsp_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
> > +{
> > +        struct ufshpb_lu *hpb = ufshpb_get_hpb_data(lrbp->cmd->device);
> > +        struct utp_hpb_rsp *rsp_field = &lrbp->ucd_rsp_ptr->hr;
> > +        int data_seg_len;
> > +
> > +        if (unlikely(lrbp->lun != rsp_field->lun)) {
> > +                struct scsi_device *sdev;
> > +                bool found = false;
> > +
> > +                __shost_for_each_device(sdev, hba->host) {
> > +                        hpb = ufshpb_get_hpb_data(sdev);
> > +
> > +                        if (!hpb)
> > +                                continue;
> > +
> > +                        if (rsp_field->lun == hpb->lun) {
> > +                                found = true;
> > +                                break;
> > +                        }
> > +                }
> > +
> > +                if (!found)
> > +                        return;
> > +        }
> > +
> > +        if (!hpb)
> > +                return;
> > +
> > +        if ((ufshpb_get_state(hpb) != HPB_PRESENT) &&
> > +            (ufshpb_get_state(hpb) != HPB_SUSPEND)) {
> > +                dev_notice(&hpb->sdev_ufs_lu->sdev_dev,
> > +                           "%s: ufshpb state is not PRESENT/SUSPEND\n",
> > +                           __func__);
>  
> Please mute these prints before hpb is fully initilized, otherwise
> there can be tons of these prints during bootup. Say set a flag in
> ufshpb_hpb_lu_prepared() and check for that flag - just a rough idea.

OK, I will change it.

Thanks,
Daejun

Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82DA5C433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Feb 2021 08:02:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3972461492
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Feb 2021 08:02:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230156AbhBHICK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Feb 2021 03:02:10 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:40981 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230153AbhBHIB4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Feb 2021 03:01:56 -0500
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210208080114epoutp041a76f3bdf78540ca819c08c28e40407c~htu3hHTCw2309023090epoutp04D
        for <linux-scsi@vger.kernel.org>; Mon,  8 Feb 2021 08:01:14 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210208080114epoutp041a76f3bdf78540ca819c08c28e40407c~htu3hHTCw2309023090epoutp04D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1612771274;
        bh=ze1z1lQbFdnnFuFNdA6+aObS93VSOFjbwRiBaL0SMrM=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=e6bwgNL9VyTpSuuDnPg+3JEB0+zKdzR4yvAwkMpwjhY4q+G9I/4Yd22BhZoMuKTQm
         6CzIE2A4F4Ri4m/ieCP3mGn0dpI2d/UqhylDfzk+M1E4ARG3w6XiT2aHMdSpYIh62h
         vEm4n7TDkLT/HJnSnyZ36z+27VeHoK3MyvbQzlck=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20210208080112epcas2p1e1368084510f791f633dcf2681a1271d~htu2Ec_Cs0326103261epcas2p1L;
        Mon,  8 Feb 2021 08:01:12 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.185]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4DYz461TFZz4x9Q9; Mon,  8 Feb
        2021 08:01:10 +0000 (GMT)
X-AuditID: b6c32a45-337ff7000001297d-85-6020efc6dd8b
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        B8.D7.10621.6CFE0206; Mon,  8 Feb 2021 17:01:10 +0900 (KST)
Mime-Version: 1.0
Subject: RE: Re: [PATCH v19 2/3] scsi: ufs: L2P map management for HPB read
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
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <652fa8013c26df497049abe923eb1b97@codeaurora.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20210208080109epcms2p6ec657586e6afa269876d4f6205af2a3c@epcms2p6>
Date:   Mon, 08 Feb 2021 17:01:09 +0900
X-CMS-MailID: 20210208080109epcms2p6ec657586e6afa269876d4f6205af2a3c
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA52TbUxTVxjHd+4tbUFKLgXngfFSLtEIkdIWWk83avwwlxowY86NbMbBTbmh
        TGib3qKOfbAZUJAXlSGwsIobcyJY1sFaqBAja5GBmdk6BiovwiImA2EwjRFwLKMvTLOP+/bL
        P8/z/J+Xc7g438aJ5OZrDLReQxWQ7CBWtytBljS4JMgR9U8FoJnmbja6ZhrioLnVUTZyTfzB
        QQ3Lqzh6ZL0UgOacCah9JguVfGVlI/MtI4ZqztjZqOVON4ZGes1sVHXbwUatP/yNoQlbEPra
        fhegU40WFmr5so+1N0w58mu6cuR0Daa82jTFUZ5t6QfK6+ctHGXp8HWW8s8H4yzlaVs7UD7u
        ilGW91dhmUHvG0EapVep84/RAlqj0ubma/IU5DuH3khCpECtZQwK8rAYSYRiuVSYKhdKdh95
        VSwSSaSkQEMV0gryRJI/mxToVbqNaAPNGPS0it6Q9HsZA5VHCxmqkCnS5AlV2kJScIwqKNrI
        I5P3pKlpKpfWC3Jmgbpz8ltc92nsie/MTtwI1sMrQSAXEqmw1l7FqgRBXD7hALCk0RJQCbhc
        HhEK1x1hnpgwIh2uVX2CeZhPkNDqbuL4dCEc/80CPMwmdsHGoWmvHk7sh0/qrgR4auKEkQ1N
        N1sDfGY8+Fn5A5aPX4E9rXZvciCxBw5Pz/n1nXDlUg3u463w7pVFziYvDV4APg6HZfdu+WNC
        4cxqn1+PgIN9y5iPT0L75BrwNAGJagBdV8f9TSTDsYpOrxmPOADXZi97C7GI7fDiwvd+s9eh
        qXTAyzgRC3sWzbhnKTiRAK29yR6ERDwcGGdtjmXsfMb5L+NECKxwrf+rO5pn/a3tgN+sWrGz
        IL7p+aabXvBqeu71BcDbwcu0jinMoxmJTvziobuA9+Un7nOAusVloRNgXOAEkIuT4by3TsXk
        8Hm51EfFtF6brS8qoBknKN6YshaP3KrSbnwdjSFbLBNJZNKU1JQUaar0f8tSiUwmkkuRVCZB
        5DYeI5rJ5hN5lIE+StM6Wr9pjnEDI42YreLh/rJSdUhRmzpq6Oi8gnIPPBNVr52vnLKWLB+6
        nz2QM9FPKl6aX5kdS+vaNfq0s8J8s6zn/gIWQZbM2DJj6890DNcsnVyQh3NWZJGfm5o76lGr
        a+pGFkYMjp37UeEObeHjwRFP322zHXZn1gyb2NWxdXEfHr8Dln+pm3dIC7hxTMPvtWGBT+L5
        pqyP3Tv3YZz6ZMHj97KiJ8t29FpGyi+k9zXUZVgy8+NUB2XSgzq37YDgtdtOsbnt2o3L0dPy
        5o4tguAOqXY0TZS4JThkLSbDnnzxXuIH8owjiuCO3W9H8QNjUBIIe1Tx5rao9OhuQ+fPxYsN
        23/6i3QtH39Ishg1JU7E9Qz1D18NDtDHBAAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210129052848epcms2p6e5797efd94e6282b76ad9ae6c99e3ab5
References: <652fa8013c26df497049abe923eb1b97@codeaurora.org>
        <20210129052848epcms2p6e5797efd94e6282b76ad9ae6c99e3ab5@epcms2p6>
        <20210129053005epcms2p323338fbb83459d2786fc0ef92701b147@epcms2p3>
        <CGME20210129052848epcms2p6e5797efd94e6282b76ad9ae6c99e3ab5@epcms2p6>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> +
> > +static void ufshpb_kick_map_work(struct ufshpb_lu *hpb)
> > +{
> > +        bool ret = true;
>  
> -> ret = false;
>  
> > +        unsigned long flags;
> > +
> > +        spin_lock_irqsave(&hpb->rsp_list_lock, flags);
> > +        if (!list_empty(&hpb->lh_inact_rgn) || 
> > !list_empty(&hpb->lh_act_srgn))
> > +                ret = false;
>  
> -> ret = true;

Thanks, I will fix it.
  
> > +        spin_unlock_irqrestore(&hpb->rsp_list_lock, flags);
> > +
> > +        if (ret)
> > +                queue_work(ufshpb_wq, &hpb->map_work);
> > +}
> > +
> > +static bool ufshpb_is_hpb_rsp_valid(struct ufs_hba *hba,
> > +                                         struct ufshcd_lrb *lrbp,
> > +                                         struct utp_hpb_rsp *rsp_field)
> > +{
> > +        if (be16_to_cpu(rsp_field->sense_data_len) != DEV_SENSE_SEG_LEN ||
> > +            rsp_field->desc_type != DEV_DES_TYPE ||
> > +            rsp_field->additional_len != DEV_ADDITIONAL_LEN ||
> > +            rsp_field->hpb_op == HPB_RSP_NONE ||
>  
> HPB_RSP_NONE is checked again in switch-case, no need of this line.

OK, I agree.

> > +static void ufshpb_rsp_req_region_update(struct ufshpb_lu *hpb,
> > +                                         struct utp_hpb_rsp *rsp_field)
> > +{
> > +        int i, rgn_idx, srgn_idx;
> > +
> > +        BUILD_BUG_ON(sizeof(struct ufshpb_active_field) != 
> > HPB_ACT_FIELD_SIZE);
> > +        /*
> > +         * If the active region and the inactive region are the same,
> > +         * we will inactivate this region.
> > +         * The device could check this (region inactivated) and
> > +         * will response the proper active region information
> > +         */
> > +        spin_lock(&hpb->rsp_list_lock);
> > +        for (i = 0; i < rsp_field->active_rgn_cnt; i++) {
> > +                rgn_idx =
> > +                        be16_to_cpu(rsp_field->hpb_active_field[i].active_rgn);
> > +                srgn_idx =
> > +                        be16_to_cpu(rsp_field->hpb_active_field[i].active_srgn);
> > +
> > +                dev_dbg(&hpb->sdev_ufs_lu->sdev_dev,
> > +                        "activate(%d) region %d - %d\n", i, rgn_idx, srgn_idx);
> > +                ufshpb_update_active_info(hpb, rgn_idx, srgn_idx);
> > +                hpb->stats.rb_active_cnt++;
> > +        }
> > +
> > +        for (i = 0; i < rsp_field->inactive_rgn_cnt; i++) {
> > +                rgn_idx = be16_to_cpu(rsp_field->hpb_inactive_field[i]);
> > +                dev_dbg(&hpb->sdev_ufs_lu->sdev_dev,
> > +                        "inactivate(%d) region %d\n", i, rgn_idx);
> > +                ufshpb_update_inactive_info(hpb, rgn_idx);
> > +                hpb->stats.rb_inactive_cnt++;
> > +        }
> > +        spin_unlock(&hpb->rsp_list_lock);
> > +
> > +        dev_dbg(&hpb->sdev_ufs_lu->sdev_dev, "Noti: #ACT %u #INACT %u\n",
> > +                rsp_field->active_rgn_cnt, rsp_field->inactive_rgn_cnt);
> > +
> > +        queue_work(ufshpb_wq, &hpb->map_work);
> > +}
> > +
> > +/*
> > + * This function will parse recommended active subregion information 
> > in sense
> > + * data field of response UPIU with SAM_STAT_GOOD state.
> > + */
> > +void ufshpb_rsp_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
> > +{
> > +        struct ufshpb_lu *hpb = ufshpb_get_hpb_data(lrbp->cmd->device);
> > +        struct utp_hpb_rsp *rsp_field;
> > +        int data_seg_len;
> > +
> > +        if (!hpb)
> > +                return;
>  
> You are assuming HPB recommandations only come in responses to LUs
> with HPB enabled, but the specs says the recommandations can come
> in any responses with GOOD status, meaning you should check the *hpb
> which belongs to the LUN in res_field, but not the one belongs to
> lrbp->cmd->device.

I will add codes for checking lun to prevent getting wrong HPB
recommandations.

Thanks,
Daejun  

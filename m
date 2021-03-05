Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8475BC433DB
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Mar 2021 00:24:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3826E6500D
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Mar 2021 00:24:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231129AbhCEAYq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Mar 2021 19:24:46 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:20011 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230427AbhCEAYq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Mar 2021 19:24:46 -0500
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210305002444epoutp044528595a1906491f7113bc75d2beaada~pSobR14jm1437914379epoutp04R
        for <linux-scsi@vger.kernel.org>; Fri,  5 Mar 2021 00:24:44 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210305002444epoutp044528595a1906491f7113bc75d2beaada~pSobR14jm1437914379epoutp04R
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1614903884;
        bh=N+pGuJiY61brma0e6fQCuI3hojqJVS9Ib6piupBN2j8=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=sUMlUa26X34cGlXAVk4CmiOKCXf1NvkSParZ9C2h/meNhF0gL+FX/5YlH9xysbtD/
         BUW9x93iPpAgXNM0FqTjZem0Q5b7oTQNPSLf9XEFrEWRXrCRmAGS1VyeeZEC9ZQjIR
         567t45a2wYu7KfKOYdo+CnqaG19+dIguQsr+S0+8=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20210305002442epcas2p111bce47a4fed2ace73926512c3627516~pSoZxueUL1084710847epcas2p1I;
        Fri,  5 Mar 2021 00:24:42 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.181]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4Ds7lr5lBsz4x9Q6; Fri,  5 Mar
        2021 00:24:40 +0000 (GMT)
X-AuditID: b6c32a47-b81ff7000000148e-00-60417a48b7f8
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        A7.CE.05262.84A71406; Fri,  5 Mar 2021 09:24:40 +0900 (KST)
Mime-Version: 1.0
Subject: RE: Re: [PATCH v26 4/4] scsi: ufs: Add HPB 2.0 support
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     Bean Huo <huobean@gmail.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        ALIM AKHTAR <alim.akhtar@samsung.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        JinHwan Park <jh.i.park@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <2f1b8ff5aec540ef731bf5b2c3691dd23ea2e6b0.camel@gmail.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20210305002440epcms2p2205c56a96f6f8426fc1cb2d0cb7c16a3@epcms2p2>
Date:   Fri, 05 Mar 2021 09:24:40 +0900
X-CMS-MailID: 20210305002440epcms2p2205c56a96f6f8426fc1cb2d0cb7c16a3
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPJsWRmVeSWpSXmKPExsWy7bCmua5HlWOCQcs7dYsH87axWextO8Fu
        8fLnVTaLw7ffsVtM+/CT2eLT+mWsFi8PaVqsehBu0bx4PZvFnLMNTBa9/VvZLB7f+cxusejG
        NiaL/n/tLBaXd81hs+i+voPNYvnxf0wWt7dwWSzdepPRonP6GhYHEY/LV7w9Lvf1MnnsnHWX
        3WPCogOMHvvnrmH3aDm5n8Xj49NbLB59W1YxenzeJOfRfqCbKYArKscmIzUxJbVIITUvOT8l
        My/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB+g5JYWyxJxSoFBAYnGxkr6dTVF+
        aUmqQkZ+cYmtUmpBSk6BoWGBXnFibnFpXrpecn6ulaGBgZEpUGVCTsa8S7vZCp7yVZycO5e9
        gfEVZxcjJ4eEgInEggWTWboYuTiEBHYwSqxsv8nWxcjBwSsgKPF3hzBIjbCAvcTL96uYQGwh
        ASWJ9RdnsUPE9SRuPVzDCGKzCehITD9xnx1kjojAL2aJXQ+XM4E4zAK/mSQWn/zPBrGNV2JG
        +1MWCFtaYvvyrWDdnALuElvbt0LFNSR+LOtlhrBFJW6ufssOY78/Np8RwhaRaL13FqpGUOLB
        z91QcUmJY7s/MEHY9RJb7/xiBDlCQqCHUeLwzlusEAl9iWsdG8GW8Qr4Slza8xxsAYuAqsSM
        W0+hlrlI/N/ZDlbPLCAvsf3tHGZQqDALaEqs36UPYkoIKEscucUC81bDxt/s6GxmAT6JjsN/
        4eI75j2BOk1NYt3P9UwTGJVnIYJ6FpJdsxB2LWBkXsUollpQnJueWmxUYIwcu5sYwSldy30H
        44y3H/QOMTJxMB5ilOBgVhLhFX9pmyDEm5JYWZValB9fVJqTWnyI0RToy4nMUqLJ+cCsklcS
        b2hqZGZmYGlqYWpmZKEkzlts8CBeSCA9sSQ1OzW1ILUIpo+Jg1Oqgcm9rWVPScvzX4G3RCb2
        GnP0TZvwe9OkjtgL9e3HBTfWysj7skSvSlevuVV88TyXnWX61rVW5vsbX4btVDj6a++xM1f+
        v8x+klTL/PnP7k0lWdNWeSq/ellnsMUm0YJX+KYW1+eWxL2Su7onztK+1p8UsE+nQS+Q06Wn
        0UXKTUAhKM521cvIhHZDbdun9xmWbvz38IfmW8WSNrmwgANWEY/MyqbdPu47oU30pr8dM6/e
        B8cv2/fb3pt8S8+7Vu2u2Rvmx5Yv3yQX75f/f35P1ucjT9ltNJb2WPPKxF26Xao96b5daq0B
        x32p++pHN85snew0a23E3h/zX5u+di+cnbT9a2zMppwpSs51Vzcz1SqxFGckGmoxFxUnAgAs
        UfuzcgQAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210303062633epcms2p252227acd30ad15c1ca821d7e3f547b9e
References: <2f1b8ff5aec540ef731bf5b2c3691dd23ea2e6b0.camel@gmail.com>
        <20210303062633epcms2p252227acd30ad15c1ca821d7e3f547b9e@epcms2p2>
        <20210303062926epcms2p6aa6737e5ed3916eed9ab80011aad3d83@epcms2p6>
        <CGME20210303062633epcms2p252227acd30ad15c1ca821d7e3f547b9e@epcms2p2>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bean,

> > +
> > +static inline void ufshpb_put_pre_req(struct ufshpb_lu *hpb,
> > +                                     struct ufshpb_req *pre_req)
> > +{
> > +       pre_req->req = NULL;
> > +       pre_req->bio = NULL;
> > +       list_add_tail(&pre_req->list_req, &hpb->lh_pre_req_free);
> > +       hpb->num_inflight_pre_req--;
> > +}
> > +
> > +static void ufshpb_pre_req_compl_fn(struct request *req,
> > blk_status_t error)
> > +{
> > +       struct ufshpb_req *pre_req = (struct ufshpb_req *)req-
> > >end_io_data;
> > +       struct ufshpb_lu *hpb = pre_req->hpb;
> > +       unsigned long flags;
> > +       struct scsi_sense_hdr sshdr;
> > +
> > +       if (error) {
> > +               dev_err(&hpb->sdev_ufs_lu->sdev_dev, "block status
> > %d", error);
> > +               scsi_normalize_sense(pre_req->sense,
> > SCSI_SENSE_BUFFERSIZE,
> > +                                    &sshdr);
> > +               dev_err(&hpb->sdev_ufs_lu->sdev_dev,
> > +                       "code %x sense_key %x asc %x ascq %x",
> > +                       sshdr.response_code,
> > +                       sshdr.sense_key, sshdr.asc, sshdr.ascq);
> > +               dev_err(&hpb->sdev_ufs_lu->sdev_dev,
> > +                       "byte4 %x byte5 %x byte6 %x additional_len
> > %x",
> > +                       sshdr.byte4, sshdr.byte5,
> > +                       sshdr.byte6, sshdr.additional_length);
> > +       }
>  
>  
> How can you print out sense_key and sense code here? sense code will
> not be copied to pre_req->sense. you should directly use
> scsi_request->sense or let pre_req->sense point to scsi_request->sense.

OK, I will fix it.

> You update the new version patch so quickly. In another word, I am
> wondering if you tested your patch before submitting?

I will check more carefully for the next patch.

Thanks,
Daejun

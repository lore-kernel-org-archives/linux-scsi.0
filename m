Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4701C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Feb 2021 08:05:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D00C64E4B
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Feb 2021 08:05:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232115AbhBWIFN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Feb 2021 03:05:13 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:21802 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232156AbhBWIE7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Feb 2021 03:04:59 -0500
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210223080414epoutp04761a908b0496409d74653d26ad2c3a85~mUcxNMcJ52601126011epoutp04j
        for <linux-scsi@vger.kernel.org>; Tue, 23 Feb 2021 08:04:14 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210223080414epoutp04761a908b0496409d74653d26ad2c3a85~mUcxNMcJ52601126011epoutp04j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1614067454;
        bh=VsArMim74poNxoH+XzW3dQThRgDRsxRhbvqOoz51HZo=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=cH7tIk251SnM5mLHPFiMX5jwCSm+RRNywojq0V/CPQ0hfKYC5am3rjFS+pW8cMFjD
         E/r3Rh3qnjrFomBcxhERww+tm8SCXDNi0fGbNrCmqu67yz7bWwAlr4ygFNq4ut5xCV
         psV5scDqJwMIKqDZG/rI+1rYGcCGFy6mcRVKiERY=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20210223080413epcas2p1605fefab10cece77bba17d10ca32168a~mUcwVpGeH0566705667epcas2p1B;
        Tue, 23 Feb 2021 08:04:13 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.181]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4DlBQg73RLz4x9QP; Tue, 23 Feb
        2021 08:04:11 +0000 (GMT)
X-AuditID: b6c32a45-34dff7000001297d-1f-6034b6fb392a
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        81.CC.10621.BF6B4306; Tue, 23 Feb 2021 17:04:11 +0900 (KST)
Mime-Version: 1.0
Subject: RE: RE: [PATCH v22 4/4] scsi: ufs: Add HPB 2.0 support
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     Avri Altman <Avri.Altman@wdc.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "huobean@gmail.com" <huobean@gmail.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        JinHwan Park <jh.i.park@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <DM6PR04MB657588F1C76DC0D5BFC68862FC819@DM6PR04MB6575.namprd04.prod.outlook.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20210223080410epcms2p4704a20bb74cbbc1c1d0af92386eda2c7@epcms2p4>
Date:   Tue, 23 Feb 2021 17:04:10 +0900
X-CMS-MailID: 20210223080410epcms2p4704a20bb74cbbc1c1d0af92386eda2c7
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMJsWRmVeSWpSXmKPExsWy7bCmhe7vbSYJBvf3iVs8mLeNzWJv2wl2
        i5c/r7JZHL79jt1i2oefzBaf1i9jtXh5SNNi1YNwi+bF69ks5pxtYLLo7d/KZvH4zmd2i0U3
        tjFZ9P9rZ7G4vGsOm0X39R1sFsuP/2OyuL2Fy2Lp1puMFp3T17BYLFq4m8VB1OPyFW+Py329
        TB47Z91l95iw6ACjx/65a9g9Wk7uZ/H4+PQWi0ffllWMHp83yXm0H+hmCuCKyrHJSE1MSS1S
        SM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAfpQSaEsMacUKBSQWFys
        pG9nU5RfWpKqkJFfXGKrlFqQklNgaFigV5yYW1yal66XnJ9rZWhgYGQKVJmQk7H/+gnWgkWi
        FX9aZjI2ML7h62Lk5JAQMJFYdW4+O4gtJLCDUaL1n1IXIwcHr4CgxN8dwiBhYQF7iTcti5kg
        SpQk1l+cxQ4R15O49XANI4jNJqAjMf3EfaA4F4eIwAoWiYu/LrGBOMwCv5gkTjz+wAixjFdi
        RvtTFghbWmL78q1gcU6BWIk9Vw8yQcQ1JH4s62WGsEUlbq5+yw5jvz82H2qOiETrvbNQNYIS
        D37uhopLShzb/QFqTr3E1ju/GEGOkBDoYZQ4vPMWK0RCX+Jax0awI3gFfCXmP9gI1sAioCrR
        1zcHaqiLxJOfB8CGMgvIS2x/CxLnALI1Jdbv0gcxJQSUJY7cYoF5q2Hjb3Z0NrMAn0TH4b9w
        8R3znkCdpiax7ud6pgmMyrMQQT0Lya5ZCLsWMDKvYhRLLSjOTU8tNiowRI7cTYzg1K7luoNx
        8tsPeocYmTgYDzFKcDArifCy3TVKEOJNSaysSi3Kjy8qzUktPsRoCvTlRGYp0eR8YHbJK4k3
        NDUyMzOwNLUwNTOyUBLnLTZ4EC8kkJ5YkpqdmlqQWgTTx8TBKdXA1HKY23BV0eEGxpJ5t8/q
        aXyUb+IR7JjM+uli71v3PLt117fd+dDm/XXz8fKfr569m654JOaOlEhmNEukIkeMV1aNRj7H
        32VKjfKL3aZ/nxnw4+cmLbHLi1YWNH0NlHI4bccXIfezVSbuQM8+0ayXd+V+6x8yvCPHXHXu
        W/ByoQ9s+3ZlMzJNLIitKo4R6/L/LOh75MMxlxD9nsmbZgSXHORemO7+W/ng3WmFnY/2HfKv
        ad4iHlfF1eGytfKTkc3XyawX5HusDzgYikYb3quMm7mQS+bxhwVz3IJLT9RdnpVjlOTomt+v
        uNFrhUWH3vZcnzVd/zY4rm+bx7v4yfN0njmzFinaTN3PJfnOP/2oEktxRqKhFnNRcSIAaHMa
        WXYEAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210222092907epcms2p307f3c4116349ebde6eed05c767287449
References: <DM6PR04MB657588F1C76DC0D5BFC68862FC819@DM6PR04MB6575.namprd04.prod.outlook.com>
        <20210222092957epcms2p728b0c563f3cfbecbf8692d7e86f9afed@epcms2p7>
        <20210222092907epcms2p307f3c4116349ebde6eed05c767287449@epcms2p3>
        <20210222093150epcms2p155352e2255e6bfd8f8d71c737ed05e76@epcms2p1>
        <CGME20210222092907epcms2p307f3c4116349ebde6eed05c767287449@epcms2p4>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > @@ -7447,8 +7452,14 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
> > 
> >         if (dev_info->wspecversion >= UFS_DEV_HPB_SUPPORT_VERSION &&
> >             (b_ufs_feature_sup & UFS_DEV_HPB_SUPPORT)) {
> > -               dev_info->hpb_enabled = true;
> > -               ufshpb_get_dev_info(hba, desc_buf);
> > +               bool hpb_en = false;
> > +
> > +               err = ufshcd_query_flag_retry(hba,
> > UPIU_QUERY_OPCODE_READ_FLAG,
> > +                                             QUERY_FLAG_IDN_HPB_EN, 0, &hpb_en);
> > +               if (!err && hpb_en) {
> > +                       dev_info->hpb_enabled = true;
> > +                       ufshpb_get_dev_info(hba, desc_buf);
> QUERY_FLAG_IDN_HPB_EN only apply to HPB2.0

OK,

> > +               }
> >         }
> > 
> > +
> > +/*
> > + * WRITE_BUFFER CMD support 36K (len=9) ~ 512K (len=128) default.
> > + * it is possible to change range of transfer_len through sysfs.
> > + */
> Actually the transfer length is limited by its (and read id) single byte.
> Fixing MAX_HPB_READ_ID = 128  is IMO a reasonable choice,
> But not limited by spec.  Maybe make note of that ?
>  
> > +static inline bool ufshpb_is_required_wb(struct ufshpb_lu *hpb, int len)
> > +{
> > +       return (len >= hpb->pre_req_min_tr_len &&
> > +               len <= hpb->pre_req_max_tr_len);
> >  }
> Maybe also check HPB2.0 as well?

OK,

> > -void ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
> > +int ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
> >  {
> >         struct ufshpb_lu *hpb;
> >         struct ufshpb_region *rgn;
> > @@ -282,26 +546,27 @@ void ufshpb_prep(struct ufs_hba *hba, struct
> > ufshcd_lrb *lrbp)
> >         u64 ppn;
> >         unsigned long flags;
> >         int transfer_len, rgn_idx, srgn_idx, srgn_offset;
> > +       int read_id = MAX_HPB_READ_ID;
> Should be 0 if wb is not used?

I will fix it.

> > +
> > +       hpb->pre_req = kcalloc(qd, sizeof(struct ufshpb_req), GFP_KERNEL);
> > +       hpb->throttle_pre_req = qd;
> What is the point in throttling if you are allowing 32 simultaneous commands?
> There can't be more than qd/2 anyway?
> On the contrary, it makes much more sense to control the inflight map requests, instead?

OK, I will change it to qd/2.
 
> > +       hpb->num_inflight_pre_req = 0;
> > +
>  
> > -#define HPB_SUPPORT_VERSION                    0x100
> > +#define HPB_SUPPORT_VERSION                    0x200
> In ufshpb_get_dev_info you are bailing out if version != HPB_SUPPORT_VERSION
> Meaning you are no longer backward supporting HPB1.0?

I add to support legacy version of HPB.

Thanks,
Daejun

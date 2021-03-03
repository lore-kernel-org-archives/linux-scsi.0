Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF75FC28E87
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Mar 2021 13:06:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F67464EE7
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Mar 2021 13:06:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345011AbhCCMql (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Mar 2021 07:46:41 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:31218 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234377AbhCCClz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Mar 2021 21:41:55 -0500
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210303023229epoutp03995cd2a125aa557b246e2507089ba14c~otFZSToGd1138111381epoutp03X
        for <linux-scsi@vger.kernel.org>; Wed,  3 Mar 2021 02:32:29 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210303023229epoutp03995cd2a125aa557b246e2507089ba14c~otFZSToGd1138111381epoutp03X
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1614738749;
        bh=i3E2/xKVUq7q+TKnA0ChUWF73Ydf8977NkXsMuAKG1M=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=dhRVu28h/7km9VRct0JH4ljkk9DBBn3UKPwQdcvPBWl7QQGOwLmb/da+DjIFo/0LY
         xF2F1aOf95olxggaeVhtrM03/6dD21LAc61sZabxMsiWyie0sJEGdRSbufKkZxEzjJ
         iRzEi1Va8jZEY/qXhCgiLtMgVbwqnH5+d+WlOJ2g=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20210303023228epcas2p213d6724cf19532c9b582994130826eb0~otFYZ4eDW3238732387epcas2p2x;
        Wed,  3 Mar 2021 02:32:28 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.187]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4DqyhC1QR4z4x9Pt; Wed,  3 Mar
        2021 02:32:27 +0000 (GMT)
X-AuditID: b6c32a46-1d9ff7000000dbf8-ee-603ef53b5ec3
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        88.2A.56312.B35FE306; Wed,  3 Mar 2021 11:32:27 +0900 (KST)
Mime-Version: 1.0
Subject: RE: Re: [PATCH v25 4/4] scsi: ufs: Add HPB 2.0 support
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
In-Reply-To: <c3560201c8dad085b0c5a661256eef837095b24b.camel@gmail.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20210303023226epcms2p4b7a87abe2993806df0a1957628a5fba6@epcms2p4>
Date:   Wed, 03 Mar 2021 11:32:26 +0900
X-CMS-MailID: 20210303023226epcms2p4b7a87abe2993806df0a1957628a5fba6
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMJsWRmVeSWpSXmKPExsWy7bCmua71V7sEg4Uz2SwezNvGZrG37QS7
        xcufV9ksDt9+x24x7cNPZotP65exWrw8pGmx6kG4RfPi9WwWc842MFn09m9ls3h85zO7xaIb
        25gs+v+1s1hc3jWHzaL7+g42i+XH/zFZ3N7CZbF0601Gi87pa1gsFi3czeIg6nH5irfH5b5e
        Jo+ds+6ye0xYdIDRY//cNeweLSf3s3h8fHqLxaNvyypGj8+b5DzaD3QzBXBF5dhkpCampBYp
        pOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAH2opFCWmFMKFApILC5W
        0rezKcovLUlVyMgvLrFVSi1IySkwNCzQK07MLS7NS9dLzs+1MjQwMDIFqkzIyXjy6gxLwT7m
        ir4Ja9gaGM8xdTFyckgImEg8u9jG1sXIxSEksINRYuGHY8xdjBwcvAKCEn93CIPUCAvYS3w8
        288IYgsJKEmsvziLHSKuJ3Hr4RqwOJuAjsT0E/fZQeaICCxlkZhyfBkziMMs8ItJ4sTjD4wQ
        23glZrQ/ZYGwpSW2L98KFucUcJc4+/oHO0RcQ+LHsl5mCFtU4ubqt+ww9vtj86HmiEi03jsL
        VSMo8eDnbqi4pMSx3R+gPquX2HrnFyPIERICPYwSh3feYoVI6Etc69gIdgSvgK/E06/LmUA+
        ZhFQlXhwTxqixEViza8DYPOZBeQltr+dAw4UZgFNifW79EFMCQFliSO3WGC+atj4mx2dzSzA
        J9Fx+C9cfMe8J1CXqUms+7meaQKj8ixESM9CsmsWwq4FjMyrGMVSC4pz01OLjQqMkCN3EyM4
        tWu57WCc8vaD3iFGJg7GQ4wSHMxKIrziL20ThHhTEiurUovy44tKc1KLDzGaAj05kVlKNDkf
        mF3ySuINTY3MzAwsTS1MzYwslMR5iw0exAsJpCeWpGanphakFsH0MXFwSjUwxeaduHB1tU7F
        H27m8m9dDhc/BS56w7Lk313Lab9fs/Bwfjj4I/V26dx5FkHarhuCIxZHdscp/TVi/cx+p89h
        fdbvpzeWWrGof73GsHrmV+8VM8KXvJjBZu5ou+t8b/LR/qA/GndnXj2s5dknPOtkof8rAQ5f
        uRP7rzHyCxqx+u/WvnNY45mkcf3p/5xf955lvWjufE5/8/dzJ/kZ8szMF/67tm/B3zdPg/8H
        i7W7cK9R7zvytTNI1Xyf0PM2a40p8q9VxQ31k6/PWVD+aVvKzfTkt/9E9i//0fN90nPXvOuJ
        uic/NF+19nkwcV33xWfNMX4tf4xffz9mrPzrv9PC6xxnjJuts4/MyOCqdeX/e0qJpTgj0VCL
        uag4EQCDcB0kdgQAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210226073233epcms2p80fca2dffabea03143a9414838f757633
References: <c3560201c8dad085b0c5a661256eef837095b24b.camel@gmail.com>
        <20210226073233epcms2p80fca2dffabea03143a9414838f757633@epcms2p8>
        <20210226073525epcms2p5e7ddd6e92b2f76b2b3dcded49f8ff256@epcms2p5>
        <CGME20210226073233epcms2p80fca2dffabea03143a9414838f757633@epcms2p4>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > +
> > +/*
> > + * In this driver, WRITE_BUFFER CMD support 36KB (len=9) ~ 512KB
> > (len=128) as
> > + * default. It is possible to change range of transfer_len through
> > sysfs.
> > + */
> > +static inline bool ufshpb_is_required_wb(struct ufshpb_lu *hpb, int
> > len)
> > +{
> > +       return (len >= hpb->pre_req_min_tr_len &&
>  
> Here is wrong, should be : len > hpb->pre_req_min_tr_len.

OK, Done.

Thanks,
Daejun 

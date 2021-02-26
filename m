Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91E1BC433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Feb 2021 04:54:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C2BF64E38
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Feb 2021 04:54:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbhBZEya (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Feb 2021 23:54:30 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:50302 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbhBZEyW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Feb 2021 23:54:22 -0500
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210226045339epoutp04ac2d9702ca151337e5ac27b986deff72~nMyOnbTas1505815058epoutp04P
        for <linux-scsi@vger.kernel.org>; Fri, 26 Feb 2021 04:53:39 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210226045339epoutp04ac2d9702ca151337e5ac27b986deff72~nMyOnbTas1505815058epoutp04P
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1614315219;
        bh=pp03IT5nIzsMg+G9CsdDb48hXFNgkdc2RK6xVCNBuTg=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=YkvEUgf6/STRSLk9xs48b0tWeI//4M0BkCfZfXYIXreX+2n2WVZMsyvzAEa9M5ZM6
         MCcHdSdwBpYfvruKPYri+fHv4hAM6yWULbqQ/EVR05I4uoKOlxn6iN1awnn/Rb9dli
         Fx8bJqruSkPs7sm647HxMoug3lSfMKJGBO1GqBuA=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20210226045338epcas2p3e231265800700dabfbae471ed9dbc204~nMyNcCmEg0322703227epcas2p36;
        Fri, 26 Feb 2021 04:53:38 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.185]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4Dmy3N3Ph4z4x9Pv; Fri, 26 Feb
        2021 04:53:36 +0000 (GMT)
X-AuditID: b6c32a47-b81ff7000000148e-52-60387ecfe7b7
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        C5.FF.05262.FCE78306; Fri, 26 Feb 2021 13:53:35 +0900 (KST)
Mime-Version: 1.0
Subject: RE: Re: [PATCH v24 2/4] scsi: ufs: L2P map management for HPB read
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
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <23b7d59df2b83cdac53fdb4567c41c007257b436.camel@gmail.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20210226045335epcms2p4beca6dda1e809534ac510926362e913c@epcms2p4>
Date:   Fri, 26 Feb 2021 13:53:35 +0900
X-CMS-MailID: 20210226045335epcms2p4beca6dda1e809534ac510926362e913c
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA52TbUxTVxjHd+4tvRe2btfysiMk2F2iASN9oxcPDtQty+hG5liyjQRioJY7
        SoDS9baEOaPdcIAo8pINsWEoECQBMoRZKKDAYCAsI5sgqMUJRPjADNIBblKFraVlmn3ct9/5
        5/+c5/mfk4fEhT1EIJmuNbB6rSqT5vvw2gfCUPgvx1GK9J6VQTPV7Xx0LX+YQAtrE3w0MPWQ
        QBX2NRwtt1zyQgv9YahxJgHl1bXwUdWoCUPFJRY+un93hUC1t9sxVLJRwEPjXVV8dPqWlY8a
        rm9gaOqKD6q33AHo1LlmHqqt6eYd9FeO34xTjp8txpSd5t8IZWltH1D2fttMKE+O9PKUf8zb
        eMqzVxqBcqUtWFnQdxqL90k0gWiVXq1Jz2FFrFadnZquTYuhP/rw7XBEizTZnCGGTpIhuVgW
        xYgVUWL53sP7ZFKpnKFFWlUWG0PnhnuqaZFerXO6DSxn0LNq1inpD3IGVRor5lRZnFGbJlZn
        Z9GiHFWm0VlHS/ZHa1hVKqsXpcwBzfLgIy/dLJHbYy0BJpDvVQS8SUgpoOPWNSf7kELKCuDM
        r9NYESBJAbUNrlt9XR5fKg7al8oIFwspGrbcMBNuXQxts83AxXxqDzw3PE247vGjHDjsmm3A
        XAecqsdh07wJd3cTwMqCeZ6bg2BHg2Wz2puKhefnqwm3HgofXyr2+P3hnaZFYouXhi4AN/vB
        r+6Nejzb4Mxat0ffDoe67ZibT0DLXQdwDQGpMwAOdNo8kSVwsrB1cwgB9R5cddzAXYl51E5Y
        ZRO4LW/B1dGNTQtO7YAdi1WbFpwKgy1dEhdCKgT+aONtpTK1PiH+yzj1MiwcWP9Xt1bPeSbb
        Bb9ba8FKQYj52Uubn+tlftbrIsAbQQCr47LSWE6ui3j+o9vA5g7sjrWCykW7uB9gJOgHkMRp
        P8H3G0yKUJCq+uwoq89O1hszWa4fHHWGLMMD/dXZziXSGpJlkVJ5JBOhiIhgFMz/lhl5ZKQ0
        ikFMpBzRrwo46UyykEpTGdgMltWx+q3mGOkdaMLq4tsVo1UBMV8m7FF8ajheIRt794eLoSXv
        9OQdwjtODj7s/dreU/7C9ZyA4fgH4cl6SeKxn3PNh6Mdc/kIlpXbrlJ/9pky4j/4KeKCpDGO
        rFjN6QoqnMvNSNqePmncOzlx5OrN1I/La75pDWMO7HqwYNTknbJ/XvB3SPP65ds1jxKenni/
        fipqRDjpMK6G9ZSSl4V1uV5H7PvH9qV3LYM3ExMbiZUv+rPmkxTnf5/OULw01BA7cgZLZsvp
        T4LLbOuS4Ps7DhwKfS2/olan1mBN5qCxobYSmaayaJl8EruAXl86RuYg+dpO36eLL/411Twx
        MVjaSTveGOBe4Vumh0cei6ZpHqdRyXbjek71D35EJy/RBAAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210224045323epcms2p66cc6a4b73086621e050da37f12f432f0
References: <23b7d59df2b83cdac53fdb4567c41c007257b436.camel@gmail.com>
        <20210224045323epcms2p66cc6a4b73086621e050da37f12f432f0@epcms2p6>
        <20210224045437epcms2p7ed0a41233d899337ddbd3525fddeb042@epcms2p7>
        <CGME20210224045323epcms2p66cc6a4b73086621e050da37f12f432f0@epcms2p4>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > +static int ufshpb_init_mem_wq(void)
> > +{
> > +       int ret;
> > +       unsigned int pool_size;
> > +
> > +       ufshpb_mctx_cache = kmem_cache_create("ufshpb_mctx_cache",
> > +                                       sizeof(struct
> > ufshpb_map_ctx),
> > +                                       0, 0, NULL);
> > +       if (!ufshpb_mctx_cache) {
> > +               pr_err("ufshpb: cannot init mctx cache\n");
> > +               return -ENOMEM;
> > +       }
> > +
> > +       pool_size = PAGE_ALIGN(ufshpb_host_map_kbytes * 1024) /
> > PAGE_SIZE;
> > +       pr_info("%s:%d ufshpb_host_map_kbytes %u pool_size %u\n",
> > +              __func__, __LINE__, ufshpb_host_map_kbytes,
> > pool_size);
> > +
> 
> I think print function name is not proper while booting.
> And one HPB is associated with one HBA, if there are two UFS
> controllers, how can I differentiate them? 

I will use dev_info instead of pr_info.

Thanks,
Daejun

> Bean
> 
> 
> 

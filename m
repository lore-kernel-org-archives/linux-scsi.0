Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4AF7C48BDF
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Jun 2021 06:39:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7FC2D613CC
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Jun 2021 06:39:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231305AbhFXGmB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Jun 2021 02:42:01 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:13917 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231261AbhFXGmA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Jun 2021 02:42:00 -0400
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210624063940epoutp048dd5e0cc6555bcc92740e3788dc0f369~LcWeFS5qc2240522405epoutp04w
        for <linux-scsi@vger.kernel.org>; Thu, 24 Jun 2021 06:39:40 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210624063940epoutp048dd5e0cc6555bcc92740e3788dc0f369~LcWeFS5qc2240522405epoutp04w
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1624516780;
        bh=C+iDJUMS2sIgPBW359FjZkumkSxszd2JO6Cpqin4FSU=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=mbnnM3+gn11xoAN95rgchRrWBL/Qx5pu45KWEZMrj+JO9a9x1c5aJ73VTA3Xg8EiT
         9NrG3PNYgHpWnNI+RFgNHTvMHk1IGmN359W9UVMIGo2uir7r5IAXvBl+6emiQzrgQw
         tGDL5VhdUG3z3t7901vjqfFg96oOvWOSP0pmNiok=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20210624063939epcas2p34ddb7d04f73f78d3a924a9c4da82510f~LcWdRszMU0816008160epcas2p3L;
        Thu, 24 Jun 2021 06:39:39 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.188]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4G9VqG0cgqz4x9Q6; Thu, 24 Jun
        2021 06:39:38 +0000 (GMT)
X-AuditID: b6c32a45-f9dff700000026c1-05-60d428a963e9
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        BD.29.09921.9A824D06; Thu, 24 Jun 2021 15:39:37 +0900 (KST)
Mime-Version: 1.0
Subject: RE: Re: [PATCH v38 3/4] scsi: ufs: Prepare HPB read for cached
 sub-region
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        Daejun Park <daejun7.park@samsung.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "huobean@gmail.com" <huobean@gmail.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        JinHwan Park <jh.i.park@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Dukhyun Kwon <d_hyun.kwon@samsung.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Jaemyung Lee <jaemyung.lee@samsung.com>,
        Jieon Seol <jieon.seol@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <468d63c0-f902-efc2-17d7-5f4321806ca6@acm.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20210624063937epcms2p7bc4a600532730fe4fc83e07646a031b1@epcms2p7>
Date:   Thu, 24 Jun 2021 15:39:37 +0900
X-CMS-MailID: 20210624063937epcms2p7bc4a600532730fe4fc83e07646a031b1
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBJsWRmVeSWpSXmKPExsWy7bCmme5KjSsJBpPO2lg8mLeNzWJv2wl2
        i5c/r7JZTPvwk9ni0/plrBYvD2la7Dp4kM1i1YNwi+bF69ks5pxtYLLo7d/KZrH54AZmi8d3
        PrNbLLqxjcmi/187i8W2z4IWx0++Y7S4vGsOm0X39R1sFsuP/2OyWLr1JqNF5/Q1LA5iHpev
        eHtc7utl8tg56y67x4RFBxg99s9dw+7RcnI/i8fHp7dYPPq2rGL0+LxJzqP9QDdTAFdUjk1G
        amJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0JtKCmWJOaVA
        oYDE4mIlfTubovzSklSFjPziElul1IKUnAJDwwK94sTc4tK8dL3k/FwrQwMDI1OgyoScjD0L
        NrMVzGGuaLl/gbGBcRJTFyMnh4SAicTks0dYuhi5OIQEdjBKPJrZB5Tg4OAVEJT4u0MYpEZY
        IETi7NflYPVCAkoS6y/OYoeI60nceriGEcRmE9CRmH7iPjvIHBGBJhaJnYffgg1lFjjPLLHn
        RjsjxDZeiRntT1kgbGmJ7cu3gsU5Bawlfl2awwwR15D4sawXyhaVuLn6LTuM/f7YfKg5IhKt
        985C1QhKPPi5GyouKXFs9weoz+oltt75xQhyhIRAD6PE4Z23WCES+hLXOjayQHzpK9E+IQQk
        zCKgKrF3wT6oXS4S/Qd3gM1hFpCX2P4W5DYOIFtTYv0ufRBTQkBZ4sgtFpivGjb+ZkdnMwvw
        SXQc/gsX3zHvCdRlahLrfq5nmsCoPAsR0rOQ7JqFsGsBI/MqRrHUguLc9NRiowJD5MjdxAhO
        8lquOxgnv/2gd4iRiYPxEKMEB7OSCO+jlksJQrwpiZVVqUX58UWlOanFhxhNgb6cyCwlmpwP
        zDN5JfGGpkZmZgaWphamZkYWSuK8HOyHEoQE0hNLUrNTUwtSi2D6mDg4pRqYYqbNbnOetYYr
        zf3Ylr/fMn78u9tpJaqnq/1Sc0q8fbWFdQ2nvWvhmz8NXl3H+lc47c4UODt1/RutwmStjb7b
        XatbXNgO6kltm8Y95col47AnsUsmTTr7YNrulWa+tp0/Hrcnq8f7PuJbkv2j1sAp2dfkhIHq
        RT3PGcYbV9+8li/dl/KA/fByN/4HS1Zd3hHkyzk5RfqfQHPhVLbY015TjqTfsJZediPNyGpy
        8DO72ex5DuYnjlrkPZldpHK12+LtDQfd+JQtD99NcQ5yL5l4n+GTfOxvtUOs77oeGIbwL+YI
        lou+ZPSl9ifngraYRwdlAphTYj9sqpFUb3wu+y12ovrmoDttJk48S/ktIlSVWIozEg21mIuK
        EwFGC1T8ewQAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210616070700epcms2p734db9b60e13229696fb3cda5f69e210f
References: <468d63c0-f902-efc2-17d7-5f4321806ca6@acm.org>
        <20210616070700epcms2p734db9b60e13229696fb3cda5f69e210f@epcms2p7>
        <20210616070913epcms2p83805028905f46225a65cc71678cddde7@epcms2p8>
        <CGME20210616070700epcms2p734db9b60e13229696fb3cda5f69e210f@epcms2p7>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

> On 6/16/21 12:09 AM, Daejun Park wrote:
> > +        if (blk_rq_is_scsi(cmd->request) ||
> > +            (!ufshpb_is_write_or_discard(cmd) &&
> > +            !ufshpb_is_read_cmd(cmd)))
> > +                return;
>  
> If this patch series is reposted, please fix the indentation of
> "!ufshpb_is_read_cmd(cmd)".

Sure.

Thanks,
Daejun
>  
> Thanks,
>  
> Bart.
>  
>  
>   

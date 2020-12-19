Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD6E4C3526C
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Dec 2020 09:04:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 956FA23BEE
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Dec 2020 09:04:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726407AbgLSJER (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Dec 2020 04:04:17 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:23348 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726398AbgLSJEO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Dec 2020 04:04:14 -0500
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20201219090331epoutp020848701c7587512efe570be2c8bfb64f~SErr3PdDX2106321063epoutp02o
        for <linux-scsi@vger.kernel.org>; Sat, 19 Dec 2020 09:03:31 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20201219090331epoutp020848701c7587512efe570be2c8bfb64f~SErr3PdDX2106321063epoutp02o
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1608368611;
        bh=WuCZdDEh/jXoA6TvhZE/NDX8zNi3V8R4w+BE8vtaK+o=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=KDYYzKXsGCQk+ozaKCGUbA3csEhSaH5FJ5gfBcd85behw4oqflMgZIRwh07kgNK5s
         Njm56z2bp1xUM8iF4YRhiMMFUbUZYebWUbpedaLFGJbk8pTALywtpN9LRqb9oRNya4
         SdQ3FtJs7z3GfTP7tz/hv/We2CK3f9ZmKb7StyLo=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20201219090330epcas2p12211f875be993ffed9c975e1e5062ae6~SErq8_J4Q2759927599epcas2p1c;
        Sat, 19 Dec 2020 09:03:30 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.183]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4CyfsY0sWYzMqYkV; Sat, 19 Dec
        2020 09:03:29 +0000 (GMT)
X-AuditID: b6c32a45-34dff7000001297d-76-5fddc1e08e98
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        4E.1B.10621.0E1CDDF5; Sat, 19 Dec 2020 18:03:28 +0900 (KST)
Mime-Version: 1.0
Subject: RE: Re: [PATCH v15 1/3] scsi: ufs: Introduce HPB feature
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Daejun Park <daejun7.park@samsung.com>
CC:     "avri.altman@wdc.com" <avri.altman@wdc.com>,
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
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <X92xI1Atgcd7z8e0@kroah.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20201219090328epcms2p8d8b989962c118a9be983286e625b323e@epcms2p8>
Date:   Sat, 19 Dec 2020 18:03:28 +0900
X-CMS-MailID: 20201219090328epcms2p8d8b989962c118a9be983286e625b323e
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNJsWRmVeSWpSXmKPExsWy7bCmue6Dg3fjDZYetrTYePcVq8WDedvY
        LPa2nWC3ePnzKpvF4dvv2C2mffjJbPFp/TJWi5eHNC1WPQi3aF68ns1iztkGJove/q1sFotu
        bGOyuLxrDptF9/UdbBbLj/9jsri9hcti6dabjBad09ewWCxauJvFQcTj8hVvj8t9vUweO2fd
        ZfeYsOgAo8f+uWvYPVpO7mfx+Pj0FotH35ZVjB6fN8l5tB/oZgrgisqxyUhNTEktUkjNS85P
        ycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAF6TkmhLDGnFCgUkFhcrKRvZ1OU
        X1qSqpCRX1xiq5RakJJTYGhYoFecmFtcmpeul5yfa2VoYGBkClSZkJNx/2VKwQnWirVr5zM1
        MJ5g6WLk5JAQMJH4fHsrO4gtJLCDUWLLxIguRg4OXgFBib87hEHCwgKOEjNO3WSEKFGSWH9x
        FjtEXE/i1sM1YHE2AR2J6Sfus4O0iggESVyeZtDFyMXBLLCKTWLHyqXsEKt4JWa0P4VaKy2x
        fflWsF5OAU2JifcWsEHENSR+LOtlhrBFJW6ufssOY78/Np8RwhaRaL13FqpGUOLBz91QcUmJ
        Y7s/MEHY9RJb7/xiBDlCQqCHUeLwzlusEAl9iWsdG8GO4BXwlZh/6ATYAhYBVYlTC25CLXOR
        OPVxDlg9s4C8xPa3c5hBHmMGOnT9Ln0QU0JAWeLILRaYtxo2/mZHZzML8El0HP4LF98x7wnU
        aWoS636uZ5rAqDwLEdCzkOyahbBrASPzKkax1ILi3PTUYqMCQ+SY3cQITuVarjsYJ7/9oHeI
        kYmD8RCjBAezkghv6IPb8UK8KYmVValF+fFFpTmpxYcYTYG+nMgsJZqcD8wmeSXxhqZGZmYG
        lqYWpmZGFkrivKEr++KFBNITS1KzU1MLUotg+pg4OKUamGa/vz9hQjD/W+2HVsvDo38l50d/
        tjEJZZ+Wv/ZbMHOf4Oqmea7ft2R/9NQ796PVjG3RioMN/x2/idzQ+KHqKjKr77tKR1PDwhNO
        OS1fLTjnZwrsulfX+Oz1gWjv4vuuRSJiUh8vL15i+emy5n4dza1vUpLPbAy2UfthNtHs5gW2
        V3vNmD/9fxNQwCO1dsX8sk0ht/d67gu9Oy24cnVOcagPm/ZsF8WDMT9U9O0MrG5t3ZTDffCP
        Gmf151VHzkcYfF6zLq9umew6k3Mbz/+pDrWfOTNu+YRXAQ8KOB5KaxxRc3oTsaj4SzkDf129
        Xcm7OnsWky8yTjOmx9daKnyfbGq2r3Gn/bR/Tze2dJ5bLq/EUpyRaKjFXFScCAAOWMCTbgQA
        AA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20201219032952epcms2p668a76f6b5ab021f0e66c856c44d5be0d
References: <X92xI1Atgcd7z8e0@kroah.com>
        <20201219032952epcms2p668a76f6b5ab021f0e66c856c44d5be0d@epcms2p6>
        <20201219033039epcms2p849fa40807c1a10934a57a0c28fc356be@epcms2p8>
        <CGME20201219032952epcms2p668a76f6b5ab021f0e66c856c44d5be0d@epcms2p8>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Dec 19, 2020 at 12:30:39PM +0900, Daejun Park wrote:
> > @@ -323,6 +325,8 @@ static struct attribute *ufs_sysfs_device_descriptor[] = {
> >  	&dev_attr_number_of_secure_wpa.attr,
> >  	&dev_attr_psa_max_data_size.attr,
> >  	&dev_attr_psa_state_timeout.attr,
> > +	&dev_attr_hpb_version.attr,
> > +	&dev_attr_hpb_control.attr,
> >  	&dev_attr_ext_feature_sup.attr,
> >  	&dev_attr_wb_presv_us_en.attr,
> >  	&dev_attr_wb_type.attr,
> 
> I thought I said this before, but you are adding new sysfs files, with
> no Documentation/ABI/ update which is not allowed.

You're right, I fixed this on patch v14. But I dropped documentation on this patch.
I will resubmit patch.

Thanks,
Daejun

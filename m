Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47FA1C433B4
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Apr 2021 17:21:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 052FB6139E
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Apr 2021 17:21:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244375AbhDFRV3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Apr 2021 13:21:29 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:58025 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232358AbhDFRV2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Apr 2021 13:21:28 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20210406172118euoutp0113c9b1d8d6e4b9176b24c5e9d147d263~zVJJGF-dO2999129991euoutp01W
        for <linux-scsi@vger.kernel.org>; Tue,  6 Apr 2021 17:21:18 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20210406172118euoutp0113c9b1d8d6e4b9176b24c5e9d147d263~zVJJGF-dO2999129991euoutp01W
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1617729678;
        bh=xHfd2hyNWPJS2JLu6srt1nLn9XZMm6ec8dRnvtbr3nM=;
        h=Date:From:To:CC:Subject:In-Reply-To:References:From;
        b=XzSgIbHyYyhgwdB2wV9A6rDXpF9XSCrH41Q9hBVM90oOheQbowvp77kh7GUBja45s
         un4l/pEu36akQnSjlNliwVc+xupMDy8VnzpuixKs1s4tV1i71Ujfee7mptab62rmvy
         eLHm1rHBXOYYdERAcCFBM0MYeAxxo7g6RtaN40IE=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20210406172117eucas1p1d4d18ed200dcecfb6b0db021a3c6d9bc~zVJIvHSTD3051730517eucas1p1q;
        Tue,  6 Apr 2021 17:21:17 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 68.98.09439.D889C606; Tue,  6
        Apr 2021 18:21:17 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20210406172117eucas1p2b402e8bba29e214aa2d6632898d380c2~zVJH85C_J3246732467eucas1p2I;
        Tue,  6 Apr 2021 17:21:17 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210406172117eusmtrp1ed743ae381a9cb98bdc1a1788e339d7c~zVJH8IwrC3088630886eusmtrp1S;
        Tue,  6 Apr 2021 17:21:17 +0000 (GMT)
X-AuditID: cbfec7f5-c1bff700000024df-7b-606c988dc324
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 51.12.08696.C889C606; Tue,  6
        Apr 2021 18:21:17 +0100 (BST)
Received: from CAMSVWEXC02.scsc.local (unknown [106.1.227.72]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20210406172116eusmtip116464b6bc8eddb4b5960f2c8a3f57c13~zVJHxq2JT1264812648eusmtip1k;
        Tue,  6 Apr 2021 17:21:16 +0000 (GMT)
Received: from localhost (106.210.248.142) by CAMSVWEXC02.scsc.local
        (2002:6a01:e348::6a01:e348) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
        Tue, 6 Apr 2021 18:21:16 +0100
Date:   Tue, 6 Apr 2021 19:21:15 +0200
From:   Javier Gonzalez <javier.gonz@samsung.com>
To:     Bean Huo <huobean@gmail.com>
CC:     <daejun7.park@samsung.com>, Greg KH <gregkh@linuxfoundation.org>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        JinHwan Park <jh.i.park@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Dukhyun Kwon <d_hyun.kwon@samsung.com>,
        "Keoseong Park" <keosung.park@samsung.com>,
        Jaemyung Lee <jaemyung.lee@samsung.com>,
        Jieon Seol <jieon.seol@samsung.com>
Subject: Re: [PATCH v32 0/4] scsi: ufs: Add Host Performance Booster Support
Message-ID: <20210406172115.hi7r47la232ou6yg@mpHalley.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline
In-Reply-To: <a57cc487bcd1ccea0bc328d394d3ebdafb67a2f5.camel@gmail.com>
X-Originating-IP: [106.210.248.142]
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
        CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBKsWRmVeSWpSXmKPExsWy7djP87q9M3ISDG4dNLfY23aC3eLlz6ts
        FtM+/GS2+LR+GatF8+L1bBZzzjYwWSy6sY3J4vKuOWwW3dd3sFksP/6PyWLp1puMDtwel694
        e1zu62Xy2DnrLrvHhEUHGD32z13D7tFycj+Lx8ent1g8Pm+S82g/0M0UwBnFZZOSmpNZllqk
        b5fAlXFpw2/Wgm62ijcT3zM1ML5k6WLk5JAQMJF4dvg0cxcjF4eQwApGiTln1rNCOF8YJfZ3
        PGaCcD4zSuw4vAeojAOs5fQtL4j4ckaJ7klfEYo6JnaxQThbGCXerX7IDtLBIqAicfy+DMg+
        NgF9iVXbTzGC2CICChIX97wBq2cW+MImMXH+IbCjhAV8JI5/3QtWxCvgJPHg2gEoW1Di5Mwn
        YDXMAlYSnR+aWEHmMwtISyz/xwES5hRwl9ixfh4TxKHKEsun+0K8WStxasstsDslBJZzShy/
        +YgVIuEi8fXhenYIW1ji1fEtULaMxOnJPSwQDc2MEmfWXGGGcHoYJf5MWsEIscFaou9MDkSD
        o8S/3TNYIcJ8EjfeCkKcyScxadt0aMDxSnS0CUFUq0nsaNrKOIFReRaSx2YheWwWwmMLGJlX
        MYqnlhbnpqcWG+ellusVJ+YWl+al6yXn525iBCau0/+Of93BuOLVR71DjEwcjIcYJTiYlUR4
        d/RmJwjxpiRWVqUW5ccXleakFh9ilOZgURLn3bV1TbyQQHpiSWp2ampBahFMlomDU6qBKdfb
        5MNVS8/arxXbLgVMC/t1+mHy7QPq7hIHN7aUuE+dnnTHvyPw4Zr+G0FrQ0X5upgnnFNIYZtR
        Frmg9tuRrWKhRtHM+zhks3qT2hgj1scwZvnPC682XzHh5IIw3uPL19YKbQ7SfLP8V3j1SwdN
        gXO8F/sTXpdwPLr+9lb3801XeeZVh7F9Y+T5+yxpi6brImWlvo92Hz77G+maT2PXOvvG/ewV
        x71Ot0oqvD8UzjpztcntDOtKTYWQxEdbz6TtVN3lFPLncyT7/1h5hpQzPe93tDWYz3f2nXLU
        e1XStPwch4ztDGbFmmdfpvJsmM3GcPmb5f3ueO7DE+e5VbVefsC5eNIX34mBnt6dzum/lFiK
        MxINtZiLihMBwM0u8ssDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCIsWRmVeSWpSXmKPExsVy+t/xu7q9M3ISDNquM1nsbTvBbvHy51U2
        i2kffjJbfFq/jNWiefF6Nos5ZxuYLBbd2MZkcXnXHDaL7us72CyWH//HZLF0601GB26Py1e8
        PS739TJ57Jx1l91jwqIDjB77565h92g5uZ/F4+PTWywenzfJebQf6GYK4IzSsynKLy1JVcjI
        Ly6xVYo2tDDSM7S00DMysdQzNDaPtTIyVdK3s0lJzcksSy3St0vQy7i04TdrQTdbxZuJ75ka
        GF+ydDFycEgImEicvuXVxcjJISSwlFGi76gciC0hICPx6cpHdghbWOLPtS62LkYuoJqPjBIv
        3rSxQzhbGCXebN7LCjKIRUBF4vh9GZAGNgF9iVXbTzGC2CICChIX97wBa2YW+MIm8WvRTjaQ
        hLCAj8Txr3vBingFnCQeXDvACDH0EqPEsoZXrBAJQYmTM5+wgNjMAhYSM+efZwRZxiwgLbH8
        HwdImFPAXWLH+nlMEM8oSyyf7gtxdK3E57/PGCcwCs9CMmgWkkGzEAYtYGRexSiSWlqcm55b
        bKRXnJhbXJqXrpecn7uJERi924793LKDceWrj3qHGJk4GA8xSnAwK4nw7ujNThDiTUmsrEot
        yo8vKs1JLT7EaAoMiYnMUqLJ+cD0kVcSb2hmYGpoYmZpYGppZqwkzmtyZE28kEB6Yklqdmpq
        QWoRTB8TB6dUA1PtqmDLiQ/+TCzd7vVcSFvYU73815xjW0/JmXwI+zrhsgGD07ftbB6PmNky
        /vO/WL3wcyX/Z7+b645Wrrx9lO8of0G3gMSqvxuO/V2xcZfCH/Ua4elytzjnZ17l3m3iv+3o
        3blGVc9D6laGxB4Vnp8q8GfzLS/egHlW89wPGjF4N8vz3TB9W9M6uZxHXeDunO0TXn4R6Kjn
        05q1eNPUO7Zzs3SU17WH6gdZ6XzT4NDNmvS93KS9LthAcpt++lSvkgqbzPUuZ0xdppYH9m7t
        nbNVnUNs9Zl4H5aXvQ3q6WarrZedTtlx3vfllRar6C28e9Rnq74S42vVvDdvlqP9mTf8PMvV
        lkae+bS1/uS320uUWIozEg21mIuKEwEfLXrhZwMAAA==
X-CMS-MailID: 20210406172117eucas1p2b402e8bba29e214aa2d6632898d380c2
X-Msg-Generator: CA
X-RootMTR: 20210331011526epcms2p37684869a9781d1eb45bfcbfe9babd217
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20210331011526epcms2p37684869a9781d1eb45bfcbfe9babd217
References: <CGME20210331011526epcms2p37684869a9781d1eb45bfcbfe9babd217@epcms2p3>
        <20210331011526epcms2p37684869a9781d1eb45bfcbfe9babd217@epcms2p3>
        <a57cc487bcd1ccea0bc328d394d3ebdafb67a2f5.camel@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 31.03.2021 21:40, Bean Huo wrote:
>Hi Martin
>
>I don't know when/how do you plan to accept this patch. I think the
>Mobile vendors and chipset vendors are all looking forward to this UFS
>HPB feature that can be mainlined in the upstream Linux. Since the
>first version HPB driver submitted in the community, it is now V32, and
>we have been working on this feature for two years. Would you please
>take a look at this? thanks.

Hi Bean,

I believe it would help if you and others are willing to review this
patchset thoroughly and give a reviewed-by / tested-by tag. This will
give Martin and others more confidence that there is vendor alignment
and that there is a group of people is willing to maintain HPB going
forward.

What do you think?

Javier

Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E02FC433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Feb 2021 08:04:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1CE664DD0
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Feb 2021 08:04:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232084AbhBWIDu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Feb 2021 03:03:50 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:19616 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232125AbhBWIDY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Feb 2021 03:03:24 -0500
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210223080235epoutp04a51fe5e4b208283fa6803e689044e4a9~mUbVDy9-m2524825248epoutp04Z
        for <linux-scsi@vger.kernel.org>; Tue, 23 Feb 2021 08:02:35 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210223080235epoutp04a51fe5e4b208283fa6803e689044e4a9~mUbVDy9-m2524825248epoutp04Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1614067355;
        bh=umypOIWVMuOIZl7KF8RuZGFFckDlQDeVTfujdiXuuQk=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=Cm2dCCBk4P5Vd9YUeUSBrO1oiMhqOhYdHk1vQwDrMsnK3F+VVhK/gYdHzFhXQje5i
         YMIOYpCZqZN7uOZq9HIHnSIkP+yJMIzGczobQtf0US5hVxEgVElGoNkoXruyZsdJuX
         GSD6rXq2zypG7mfhwi+bB5eVjs1ApX7gTUZrRsfA=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20210223080234epcas2p202faa34bc713d851da78d66a6bfd6ff3~mUbUUq_wf0970109701epcas2p2D;
        Tue, 23 Feb 2021 08:02:34 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.187]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4DlBNn1y0dz4x9Ps; Tue, 23 Feb
        2021 08:02:33 +0000 (GMT)
X-AuditID: b6c32a47-b81ff7000000148e-87-6034b699aaa8
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        CB.F1.05262.996B4306; Tue, 23 Feb 2021 17:02:33 +0900 (KST)
Mime-Version: 1.0
Subject: RE: Re: [PATCH v22 4/4] scsi: ufs: Add HPB 2.0 support
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
In-Reply-To: <62be9fcfbd79b5977b34de85e486409ec74b7359.camel@gmail.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20210223080232epcms2p6f75e3537fc8c0457c0904a4e5f8c1cd8@epcms2p6>
Date:   Tue, 23 Feb 2021 17:02:32 +0900
X-CMS-MailID: 20210223080232epcms2p6f75e3537fc8c0457c0904a4e5f8c1cd8
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCJsWRmVeSWpSXmKPExsWy7bCmqe7MbSYJBnsfcFk8mLeNzWJv2wl2
        i5c/r7JZHL79jt1i2oefzBaf1i9jtXh5SNNi1YNwi+bF69ks5pxtYLLo7d/KZvH4zmd2i0U3
        tjFZ9P9rZ7G4vGsOm0X39R1sFsuP/2OyuL2Fy2Lp1puMFp3T17BYLFq4m8VB1OPyFW+Py329
        TB47Z91l95iw6ACjx/65a9g9Wk7uZ/H4+PQWi0ffllWMHp83yXm0H+hmCuCKyrHJSE1MSS1S
        SM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAfpQSaEsMacUKBSQWFys
        pG9nU5RfWpKqkJFfXGKrlFqQklNgaFigV5yYW1yal66XnJ9rZWhgYGQKVJmQk3F993bmgjlM
        FUuvrWdtYLzO2MXIySEhYCLxc+pMti5GLg4hgR2MEl+6+lm6GDk4eAUEJf7uEAapERawl3hx
        4ho7iC0koCSx/uIsdoi4nsSth2vA5rAJ6EhMP3GfHWSOiMBSFokpx5cxgzjMAr+YJE48/gC1
        jVdiRvtTFghbWmL78q1gcU4Bd4m3j08zQ8Q1JH4s64WyRSVurn7LDmO/PzYfao6IROu9s1A1
        ghIPfu6GiktKHNv9gQnCrpfYeucXI8gREgI9jBKHd95ihUjoS1zr2Ah2BK+Ar8S+a/fBmlkE
        VCUmfemEWuYiMbWtD6yeWUBeYvvbOcygUGEW0JRYv0sfxJQQUJY4cosF5q2Gjb/Z0dnMAnwS
        HYf/wsV3zHsCdZqaxLqf65kmMCrPQgT1LCS7ZiHsWsDIvIpRLLWgODc9tdiowBg5djcxgpO7
        lvsOxhlvP+gdYmTiYDzEKMHBrCTCy3bXKEGINyWxsiq1KD++qDQntfgQoynQlxOZpUST84H5
        Ja8k3tDUyMzMwNLUwtTMyEJJnLfY4EG8kEB6YklqdmpqQWoRTB8TB6dUA9Mi2eZNh9f0ulxO
        1ZHNstAL5li3SahAjv/mrDOPfi8zcxEVue1kr1F3Lpr56Mcnqz/vseOY9+NrceVMnvfbJyxk
        +TFtxRSXlPiHNn+2Z96U/iK5gMutyNg2rXKibtSbzN4dyQb5G04LFhoy6eve2HzD0/On1vGO
        mgexcTrTinnfWDNs/LThzVTHs+3TVh1XdlseHVv+b6Xz5icnA1Ij21+9P7p7i9y7gOcaXxnv
        bFwaYlBiWyPJY/Spm/Pu5ykG0pccFuXW7C6Y+LWTqzC9Q036m+mj+F3XP2x+r33opxZ3zdPs
        +eUzfAWcQ07Gmc//wZXEdo1D68zy0h8Hc5NUDmvrirlWb7rkf8vj8JfXLt1KLMUZiYZazEXF
        iQBt7JbvdwQAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210222092907epcms2p307f3c4116349ebde6eed05c767287449
References: <62be9fcfbd79b5977b34de85e486409ec74b7359.camel@gmail.com>
        <20210222092957epcms2p728b0c563f3cfbecbf8692d7e86f9afed@epcms2p7>
        <20210222092907epcms2p307f3c4116349ebde6eed05c767287449@epcms2p3>
        <20210222093150epcms2p155352e2255e6bfd8f8d71c737ed05e76@epcms2p1>
        <CGME20210222092907epcms2p307f3c4116349ebde6eed05c767287449@epcms2p6>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > +}
> > +static DEVICE_ATTR_RW(requeue_timeout_ms);
> > +
> > +static struct attribute *hpb_dev_param_attrs[] = {
> > +       &dev_attr_requeue_timeout_ms.attr,
> > +};
>  
> here, you lost a NULL member at the end of attribute struct.
>  
OK, I will.

Thanks,
Daejun

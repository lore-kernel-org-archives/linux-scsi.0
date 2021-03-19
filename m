Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E4B1C433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 02:52:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63E6E64F18
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 02:52:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233125AbhCSCvm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Mar 2021 22:51:42 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:48810 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233469AbhCSCvb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Mar 2021 22:51:31 -0400
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210319025128epoutp0104d5d220222d0cc35f2ae6bb92624008~tnqi6yOCX3078230782epoutp017
        for <linux-scsi@vger.kernel.org>; Fri, 19 Mar 2021 02:51:28 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210319025128epoutp0104d5d220222d0cc35f2ae6bb92624008~tnqi6yOCX3078230782epoutp017
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1616122288;
        bh=CPoTBRobhhShDeEhgFsIF/X3ZgQia3gxElCclIbPevw=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=nKEcxWnYiloX2AyjuQbKfIi1Ff6oTJr52CH83tjGTAvFzBZ8kBbOB+W5eHYVpJjNg
         YtrM8jwb4ynZMsF2ZBPSu85IIxcxmvhD94hsx8UCLs7DR8MecTCD8Wf8iWnG88Fv/E
         simObtuLkaO0KFzdxwzjaVHHlYfmNaX+GCzoiF3E=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20210319025126epcas2p2d0218e7f386123b70991caeaabd0c9fe~tnqgyj8eW1722817228epcas2p29;
        Fri, 19 Mar 2021 02:51:26 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.184]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4F1pLg4ghCz4x9QB; Fri, 19 Mar
        2021 02:51:23 +0000 (GMT)
X-AuditID: b6c32a45-34dff7000001297d-43-605411ab7ce6
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        92.EE.10621.BA114506; Fri, 19 Mar 2021 11:51:23 +0900 (KST)
Mime-Version: 1.0
Subject: RE: Re: [PATCH] scsi: ufs: Add selector to ufshcd_query_flag* APIs
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     Daejun Park <daejun7.park@samsung.com>
CC:     "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "huobean@gmail.com" <huobean@gmail.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        JinHwan Park <jh.i.park@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <yq1mtuzq3tu.fsf@ca-mkp.ca.oracle.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20210319025121epcms2p54274eddaa64ae4d0868424df3dac11b2@epcms2p5>
Date:   Fri, 19 Mar 2021 11:51:21 +0900
X-CMS-MailID: 20210319025121epcms2p54274eddaa64ae4d0868424df3dac11b2
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLJsWRmVeSWpSXmKPExsWy7bCmqe5qwZAEgxmLZC0ezNvGZrG37QS7
        xcufV9ksDt9+x24x7cNPZotP65exWrw8pGmx6kG4xZyzDUwWvf1b2SwW3djGZNH/r53F4vKu
        OWwW3dd3sFksP/6PyeL2Fi6LpVtvMlp0Tl/D4iDkcfmKt8flvl4mj52z7rJ7TFh0gNGj5eR+
        Fo+PT2+xePRtWcXo8XmTnEf7gW6mAM6oHJuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11D
        SwtzJYW8xNxUWyUXnwBdt8wcoG+UFMoSc0qBQgGJxcVK+nY2RfmlJakKGfnFJbZKqQUpOQWG
        hgV6xYm5xaV56XrJ+blWhgYGRqZAlQk5GT07z7IVvGWt2HnzJEsD4z6WLkZODgkBE4mWw7MZ
        uxi5OIQEdjBKHHn1G8jh4OAVEJT4u0MYpEZYwFviWMcEVhBbSEBJYv3FWewQcT2JWw/XMILY
        bAI6EtNP3AeLiwhoScw8s5cZZCazQCubxOSpX6CW8UrMaH8KZUtLbF++FayZU8BY4uGrq+wQ
        cQ2JH8t6mSFsUYmbq9+yw9jvj81nhLBFJFrvnYWqEZR48HM3VFxS4tjuD0wQdr3E1ju/wB6T
        EOhhlDi88xYrREJf4lrHRhaIJ30lFnRngZgsAqoSsx4IQlS4SLw8ugysmllAXmL72znMICXM
        ApoS63fpg5gSAsoSR27BPdWw8Tc7OptZgE+i4/BfuPiOeU+gDlOTWPdzPdMERuVZiHCehWTX
        LIRdCxiZVzGKpRYU56anFhsVGCJH7SZGcLrWct3BOPntB71DjEwcjIcYJTiYlUR4TfMCEoR4
        UxIrq1KL8uOLSnNSiw8xmgI9OZFZSjQ5H5gx8kriDU2NzMwMLE0tTM2MLJTEeYsNHsQLCaQn
        lqRmp6YWpBbB9DFxcEo1MGn1Pfb6E3p/mv+81M8Gzp+4Pug8qVcqkOTZkXH11oH3T5ZeClx8
        wa2v5NKVDz/tdKd4cC/2NJPu/XJlicte9j+Xq5fs4932Jlrv/Z/KyjnH/wl9UKiXXd5doSr1
        d+amA21lK1mKZ563sWR+pGLCeZDBIDC5YWnvvF2n+3ObWLP+3vRbXKD6aQW3YujqDPn5y3Ne
        qr+yCT//fVP16dPs0hV5ZrpzUqanhnh+mM7SUOHNdurp7a0Sv6Xm/Azb1nKc8ci1Kt0rJ04x
        R85/4nZLfXpybO+iRIkHkYvf+VaF7W53CmDo2lrYfSRc473Q/8hwmU2PZV/nmp6cezgz8NaW
        BafTWP1OMpXr1Ny6y7MxpFOJpTgj0VCLuag4EQAQJxroYAQAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210317033143epcms2p25b37bba2bb515c1ce85bf555656ca3f2
References: <yq1mtuzq3tu.fsf@ca-mkp.ca.oracle.com>
        <20210317033143epcms2p25b37bba2bb515c1ce85bf555656ca3f2@epcms2p2>
        <CGME20210317033143epcms2p25b37bba2bb515c1ce85bf555656ca3f2@epcms2p5>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin

> 
>Daejun,
> 
>> Unlike other query APIs in UFS, ufshcd_query_flag has a fixed selector
>> as 0. This patch allows ufshcd_query_flag API to choose selector value
>> by parameter.
> 
>I don't see any users of the added parameter. Am I missing something?

The JEDEC standard describes it as follows:
The selector field may be needed to further identify a particular element of a flag.

Other cannot used it because it is fixed as zero in the API.

Thanks,
Daejun

The selector field may be needed to further identify a particular element of a flag. Selector field is not
2218 used in this version of the standard and its value shall be zero.
> 
>-- 
>Martin K. Petersen        Oracle Linux Engineering
> 
> 
>  

Return-Path: <SRS0=xyUR=7V=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88BA3C433DF
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Jun 2020 02:46:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F8322067B
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Jun 2020 02:46:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="KvqwU7fM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728763AbgFHCp6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 7 Jun 2020 22:45:58 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:50240 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728501AbgFHCp5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Jun 2020 22:45:57 -0400
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200608024554epoutp04055c96706fa47155d979ca614b9d2636~WcYmUYvXW0149101491epoutp04c
        for <linux-scsi@vger.kernel.org>; Mon,  8 Jun 2020 02:45:54 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200608024554epoutp04055c96706fa47155d979ca614b9d2636~WcYmUYvXW0149101491epoutp04c
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1591584354;
        bh=C6kwEPVrZicQMVqPRY7G0nedp5JPKJuMGfwc+qpyuwA=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=KvqwU7fMbbAyxQmaB0nq6GE23hGELJQG+OFDXmz5F1jBV9oU/JvyEvwfTyewPBDw3
         io2uL1uF1fKnCmrzp6/8NKge26qpTkVFsVwx5iDZxMALZxA/NdS6L2gkFYleYBE8RF
         8/KfSle/yfI+yYe8SMvSvQC6aV1Np2Bu4v0IajX4=
Received: from epsmges5p3new.samsung.com (unknown [182.195.42.75]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20200608024553epcas5p3e04e585e4600019179baa620f295bad9~WcYl3-Llg0786907869epcas5p3C;
        Mon,  8 Jun 2020 02:45:53 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        32.1E.09475.166ADDE5; Mon,  8 Jun 2020 11:45:53 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20200608024553epcas5p31ec99c061aee14aa8362dcd8c110efc2~WcYllvBRC1438514385epcas5p3G;
        Mon,  8 Jun 2020 02:45:53 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200608024553epsmtrp1fb2b062906712c143df9d0b6797046dd~WcYlgPQbI1169511695epsmtrp1-;
        Mon,  8 Jun 2020 02:45:53 +0000 (GMT)
X-AuditID: b6c32a4b-389ff70000002503-89-5edda6619c7b
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        ED.E6.08303.066ADDE5; Mon,  8 Jun 2020 11:45:53 +0900 (KST)
Received: from alimakhtar02 (unknown [107.108.234.165]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200608024549epsmtip2a0a64a9e6e85eb65ccb898cdea3fba22~WcYidqe4w2506325063epsmtip2Y;
        Mon,  8 Jun 2020 02:45:49 +0000 (GMT)
From:   "Alim Akhtar" <alim.akhtar@samsung.com>
To:     "'Martin K. Petersen'" <martin.petersen@oracle.com>,
        <robh@kernel.org>, "'Kishon Vijay Abraham I'" <kishon@ti.com>
Cc:     <krzk@kernel.org>, <linux-samsung-soc@vger.kernel.org>,
        <avri.altman@wdc.com>, <stanley.chu@mediatek.com>,
        <linux-scsi@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <cang@codeaurora.org>,
        <devicetree@vger.kernel.org>, <kwmad.kim@samsung.com>,
        <linux-kernel@vger.kernel.org>, "'Vinod Koul'" <vkoul@kernel.org>
In-Reply-To: <159114947915.26776.12485309894552696104.b4-ty@oracle.com>
Subject: RE: [PATCH v10 00/10] exynos-ufs: Add support for UFS HCI
Date:   Mon, 8 Jun 2020 08:15:47 +0530
Message-ID: <013a01d63d3e$ecf404d0$c6dc0e70$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQNA14zZ9KpC6NxovY65uGX80LQ4kgIpylB3AdlmWUOl2LNuQA==
Content-Language: en-in
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIKsWRmVeSWpSXmKPExsWy7bCmlm7isrtxBrM/yFm8/HmVzeLT+mWs
        FvOPnGO1uPC0h83i/PkN7BY3txxlsdj0+BqrxeVdc9gsZpzfx2TRfX0Hm8Xy4/+YLP7v2cFu
        sXTrTUaLnXdOMDvweVzu62Xy2LSqk81j85J6j5aT+1k8Pj69xeLRt2UVo8fxG9uZPD5vkvNo
        P9DNFMAZxWWTkpqTWZZapG+XwJVx5l8Xc0EjZ8XfE9/YGhgPsncxcnJICJhILJ79nRXEFhLY
        zShx4oBwFyMXkP2JUeLw+qeMEM5nRonvnztYYDouNe5ngUjsYpT4dewpK4TzhlFi3b5rYFVs
        AroSOxa3sXUxcnCICFRIrFgmAVLDLHCOSWLeh23sIHFOAXeJr79jQcqFBZwkXq/YwwQSZhFQ
        kfg3IxAkzCtgKdHVsZUJwhaUODnzCdh0ZgF5ie1v5zBD3KMg8fPpMrAPRIDGfP1xBapGXOLo
        zx5mkLUSAi84JLa8Pgz1sovEpMt3WCFsYYlXx7dAxaUkXva3gZ0mIZAt0bPLGCJcI7F03jGo
        3+0lDlyZwwJSwiygKbF+lz7EKj6J3t9PmCA6eSU62oQgqlUlmt9dheqUlpjY3c0KUeIh0dck
        OoFRcRaSv2Yh+WsWkvtnIexawMiyilEytaA4Nz212LTAOC+1XK84Mbe4NC9dLzk/dxMjONVp
        ee9gfPTgg94hRiYOxkOMEhzMSiK81Q/uxAnxpiRWVqUW5ccXleakFh9ilOZgURLnVfpxJk5I
        ID2xJDU7NbUgtQgmy8TBKdXAxDZJpEV/hW7fgeL70f17uLiCqxJ33LBhv/Hq3NG5DZbTQ1ki
        Z063k0+ac/zlHO45+589+rq8dMLv3BcORYnOIZz2mtn20zpyTm4Mf2f87Kp84tOUa1mTRL/b
        yC8qig9iVpC5lBYzaUL1jv+Ck+Rl1Hc6nd2QUbksYkXqdl6xff29ESsZ4r5V6CYuPce26EWs
        QEDN7OcCYtaL/0zTPXa2L/7P78j5a6bOlFGwspf8teV48bT9YTbKvufO21lzp6jX23j8vPd5
        YW+GGp9OjO3fk4IPa8vj2vPs3jlfzd/qJjR7i8I7w2lBDwVzFV6Hxnmp3lrU/UemPSci/ZPr
        pf9cscFrj0m8+Xxg2+bLhxsUlViKMxINtZiLihMBkily0+QDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBIsWRmVeSWpSXmKPExsWy7bCSvG7isrtxBit3Mlu8/HmVzeLT+mWs
        FvOPnGO1uPC0h83i/PkN7BY3txxlsdj0+BqrxeVdc9gsZpzfx2TRfX0Hm8Xy4/+YLP7v2cFu
        sXTrTUaLnXdOMDvweVzu62Xy2LSqk81j85J6j5aT+1k8Pj69xeLRt2UVo8fxG9uZPD5vkvNo
        P9DNFMAZxWWTkpqTWZZapG+XwJVx5l8Xc0EjZ8XfE9/YGhgPsncxcnJICJhIXGrcz9LFyMUh
        JLCDUeL7ogMsEAlpiesbJ0AVCUus/PcczBYSeMUo8W+mO4jNJqArsWNxGxuILSJQJfHvyHt2
        kEHMAjeYJK73roGaepJR4vTs+0xdjBwcnALuEl9/x4I0CAs4SbxesQcszCKgIvFvRiBImFfA
        UqKrYysThC0ocXLmE7B7mAX0JNavn8MIYctLbH87hxniNgWJn0+XsULc4CTx9ccVqHpxiaM/
        e5gnMArPQjJqFpJRs5CMmoWkZQEjyypGydSC4tz03GLDAqO81HK94sTc4tK8dL3k/NxNjODI
        1dLawbhn1Qe9Q4xMHIyHGCU4mJVEeKsf3IkT4k1JrKxKLcqPLyrNSS0+xCjNwaIkzvt11sI4
        IYH0xJLU7NTUgtQimCwTB6dUA9O635bbZs88s1Xvwiljh9aE5Y2lYnETHu2/paX5ev02lxbm
        7ZVt7S4le9g2FeR7+J+uO+At4uWowHqq/++aK3/ehn+cJseW/UtFX36f9vd9B46az+Zn3iz7
        6aLYjUu75P/Mk5/veOp0WYYIQ2Ti65n7Z6h5dLvXLKlc+P+0AqO0wQGdYLfbjgF7RdeuMdll
        Epmkat8x6Uxv9vGYh79NNzlv0hc6pzbj/d/jCvlmgjPLHQPOlSaZOVmedC/Oqw8X2vJyjtap
        iOmX/RZv9n+yPDTOy8ugyv/6u4SMDa6J9veUOk72Pdncu+bK9t+7m6Qc73F0rNn7am+GO3t8
        1SSfDLO2K9Zhk/+2z8xwMVvU0qfEUpyRaKjFXFScCAACFD+lSwMAAA==
X-CMS-MailID: 20200608024553epcas5p31ec99c061aee14aa8362dcd8c110efc2
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200528013223epcas5p2be85fa8803326b49a905fb7225992cad
References: <CGME20200528013223epcas5p2be85fa8803326b49a905fb7225992cad@epcas5p2.samsung.com>
        <20200528011658.71590-1-alim.akhtar@samsung.com>
        <159114947915.26776.12485309894552696104.b4-ty@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Martin K. Petersen <martin.petersen@oracle.com>
> Sent: 03 June 2020 08:02
> To: robh@kernel.org; Alim Akhtar <alim.akhtar@samsung.com>
> Cc: Martin K . Petersen <martin.petersen@oracle.com>; krzk@kernel.org;
linux-
> samsung-soc@vger.kernel.org; avri.altman@wdc.com;
> stanley.chu@mediatek.com; linux-scsi@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org; cang@codeaurora.org;
devicetree@vger.kernel.org;
> kwmad.kim@samsung.com; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v10 00/10] exynos-ufs: Add support for UFS HCI
> 
> On Thu, 28 May 2020 06:46:48 +0530, Alim Akhtar wrote:
> 
> > This patch-set introduces UFS (Universal Flash Storage) host
> > controller support for Samsung family SoC. Mostly, it consists of UFS
> > PHY and host specific driver.
> > [...]
> 
> Applied [1,2,3,4,5,9] to 5.9/scsi-queue. The series won't show up in my
public
> tree until shortly after -rc1 is released.
> 
Thanks Martin,
Hi Rob and Kishon/Vinod
Can you please pickup dt-bindings and PHY driver respectively?

> Thanks!
> 
> --
> Martin K. Petersen	Oracle Linux Engineering


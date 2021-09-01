Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D66B4C432BE
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Sep 2021 00:41:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 976F56102A
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Sep 2021 00:41:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241479AbhIAAmw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 31 Aug 2021 20:42:52 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:37969 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240856AbhIAAmv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Aug 2021 20:42:51 -0400
Received: from epcas1p1.samsung.com (unknown [182.195.41.45])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210901004153epoutp035cd8ac188cde45bcbf71dbf6da0e9b94~gi_yd8hkj2039520395epoutp03j
        for <linux-scsi@vger.kernel.org>; Wed,  1 Sep 2021 00:41:53 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210901004153epoutp035cd8ac188cde45bcbf71dbf6da0e9b94~gi_yd8hkj2039520395epoutp03j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1630456913;
        bh=75MYQUynygglmFP6dlS0zEFz0RaqCD2+34Yy2vZ851I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Oi5m7ef3TlT6uyppaSBzyaYOek3RkfmajdkVApa1dYgYEX4Kk7vUlCAul4vz49jCc
         M8T+1eqyFEO0xvGOoXaS48CEwfgCC+k31ZI1qFzCl41869SsO895JPvfjBL0pvHmVn
         llz3YEUDfSxJcoBfI3tks/WgMhccpOk5eb0vZNOQ=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTP id
        20210901004149epcas1p1c7c60af3a2c9933ff60ce6c2d69cbcd1~gi_u-9jM20155501555epcas1p1B;
        Wed,  1 Sep 2021 00:41:49 +0000 (GMT)
Received: from epsmges1p2.samsung.com (unknown [182.195.38.247]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4GzlcX2lQ6z4x9Px; Wed,  1 Sep
        2021 00:41:48 +0000 (GMT)
Received: from epcas1p2.samsung.com ( [182.195.41.46]) by
        epsmges1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        8A.E3.09827.C4CCE216; Wed,  1 Sep 2021 09:41:48 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas1p3.samsung.com (KnoxPortal) with ESMTPA id
        20210901004146epcas1p336b99f1c66e27c2df92982e6fc796b22~gi_sKwZVX2142021420epcas1p3L;
        Wed,  1 Sep 2021 00:41:46 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210901004146epsmtrp18dabc9d9e6df2e41290ccd61b11580e0~gi_sJ0-hk1641616416epsmtrp1I;
        Wed,  1 Sep 2021 00:41:46 +0000 (GMT)
X-AuditID: b6c32a36-c7bff70000002663-b2-612ecc4c2b9b
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        B1.85.08750.A4CCE216; Wed,  1 Sep 2021 09:41:46 +0900 (KST)
Received: from localhost.localdomain (unknown [10.253.100.232]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210901004146epsmtip2cc75944705365eb71860273adcaf5f19~gi_r6mMHc1939819398epsmtip2G;
        Wed,  1 Sep 2021 00:41:46 +0000 (GMT)
From:   Chanwoo Lee <cw9316.lee@samsung.com>
To:     bvanassche@acm.org
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com, beanhuo@micron.com,
        cw9316.lee@samsung.com, daejun7.park@samsung.com,
        dh0421.hwang@samsung.com, grant.jung@samsung.com,
        jejb@linux.ibm.com, jt77.jang@samsung.com,
        keosung.park@samsung.com, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        sh043.lee@samsung.com, stanley.chu@mediatek.com
Subject: Re: Re: [PATCH] scsi: ufs: ufshpb: Remove unused parameters
Date:   Wed,  1 Sep 2021 09:34:32 +0900
Message-Id: <20210901003432.28784-1-cw9316.lee@samsung.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <634f24b5-c47e-0303-f462-8a63c3453af8@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOJsWRmVeSWpSXmKPExsWy7bCmnq7PGb1Eg5dH+S0ezNvGZvHy51U2
        i4MPO1kspn34yWwx41Qbq8WqB+EW+66dZLf49Xc9u8WiG9uYLHY8P8NucfzkO0aLy7vmsFl0
        X9/BZrH8+D8mi6Y/+1gslm69yegg4HH5irfHhEUHGD1aTu5n8fi+voPN4+PTWywefVtWMXp8
        3iTn0X6gmymAIyrbJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUn
        QNctMwfoASWFssScUqBQQGJxsZK+nU1RfmlJqkJGfnGJrVJqQUpOgVmBXnFibnFpXrpeXmqJ
        laGBgZEpUGFCdkb3gcWMBcuZK1Z15TQwXmfqYuTkkBAwkfg8eQdrFyMXh5DADkaJh+96mCCc
        T4wSsy5cZwOpEhL4DOScs4Pp2PD8K1THLkaJU1v3MUM4Xxglpl47CNTOwcEmoCVx+5g3SIOI
        gJjE5S/fGEFqmAX+MUmsOnGXBSQhLOAicX3eGbA7WARUJe7uWcAMYvMKWEtc2fSNBWKbvMSf
        +z1gcU6g+LdLh9ghagQlTs58AlbDDFTTvHU22BESAgc4JL5em8IG0ewicXzWNkYIW1ji1fEt
        7BC2lMTL/jZ2iIZmoBdmn4NyWhglXl+5AVVlLPHp82dGkHeYBTQl1u/ShwgrSuz8PZcRYjOf
        xLuvPawgJRICvBIdbUIQJSoSc7rOscHs+njjMSuE7SFx5t1ZaND1MUo8nrqCfQKjwiwkD81C
        8tAshM0LGJlXMYqlFhTnpqcWGxYYwaM4OT93EyM4RWuZ7WCc9PaD3iFGJg7GQ4wSHMxKIrzZ
        b7QShXhTEiurUovy44tKc1KLDzGaAoN7IrOUaHI+MEvklcQbmlgamJgZmVgYWxqbKYnzMr6S
        SRQSSE8sSc1OTS1ILYLpY+LglGpgyuReqii3jc3MYEHFvDdnGt6oVOuw+HbPKqlfcOTj32yO
        LfML5E+vFVi8lWF+hU6zrvuUg6rHzv4tr796d79N4haj9PuhH+xvl922zfBsUNin5zlTaVJI
        n5P/jUff80/oh21m+r1P5s/cT3fkN51Y4m7+0Oefe0Cn/O2ny/dYnjrPsFZ4gz1fUzmvTs9U
        Qf7jPOquU3f0sUzUzzy3TqODW8nTedGMS+ezZW1fT91yYHnwTLtHDF1Fz399Y839+MCfN26b
        acL9o3dkM/7nPJj+p7dghfFTzmLzQoVJR6etOrs+Nlfv+dRlhuelS5PyLsy2mLZObkPt6gwP
        u88VJooOwesv8Ol73em9pP6hVuZPgBJLcUaioRZzUXEiAPbZMtFaBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPLMWRmVeSWpSXmKPExsWy7bCSvK7XGb1EgycdKhYP5m1js3j58yqb
        xcGHnSwW0z78ZLaYcaqN1WLVg3CLfddOslv8+rue3WLRjW1MFjuen2G3OH7yHaPF5V1z2Cy6
        r+9gs1h+/B+TRdOffSwWS7feZHQQ8Lh8xdtjwqIDjB4tJ/ezeHxf38Hm8fHpLRaPvi2rGD0+
        b5LzaD/QzRTAEcVlk5Kak1mWWqRvl8CV0X1gMWPBcuaKVV05DYzXmboYOTkkBEwkNjz/ytrF
        yMUhJLCDUWLuw3ZmiISUxO7959m6GDmAbGGJw4eLIWo+MUo87fjJBBJnE9CSuH3MG6RcREBM
        4vKXb4wgNcwCE5gldvcuZQVJCAu4SFyfdwZsGYuAqsTdPQvA5vMKWEtc2fSNBWKXvMSf+z1g
        cU6g+LdLh9hBbCEBK4npCyazQ9QLSpyc+QSsnhmovnnrbOYJjAKzkKRmIUktYGRaxSiZWlCc
        m55bbFhglJdarlecmFtcmpeul5yfu4kRHEdaWjsY96z6oHeIkYmD8RCjBAezkghv9hutRCHe
        lMTKqtSi/Pii0pzU4kOM0hwsSuK8F7pOxgsJpCeWpGanphakFsFkmTg4pRqYCpky3l7w7Fw8
        2ZC7Xud41zr5WSoJcQFe0dNud11Vfs7zuurcl6LTS2PVHAry1in9cRFaM1HJxV9WoKdAyI05
        6+/sg6uOrbu7ac10RwU7q6Lwfi9jtfhJh/Zffsxz4PydP77Zjkfq70zhjdO2LtPPPS/bXRdl
        llQcdjMnaU1ge/y8efuM11YsyL6zZZOsS9PEtcucf51RYOfdttHPLuJQzeSKdtGuv0+TPldu
        Pr5yjsTFR0HTHiksXx77VO35wr0L7rzeZfqt0jrNQu+S7pdnbhPXLZVadOIYb16mxl3/VqPL
        Xcemf5rIpe3qXqyv4+StxvReiYEpy3D3m9LqlTVbHr2Y+6LnvK1GwVdtp7WVSizFGYmGWsxF
        xYkAC/pHuRIDAAA=
X-CMS-MailID: 20210901004146epcas1p336b99f1c66e27c2df92982e6fc796b22
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210901004146epcas1p336b99f1c66e27c2df92982e6fc796b22
References: <634f24b5-c47e-0303-f462-8a63c3453af8@acm.org>
        <CGME20210901004146epcas1p336b99f1c66e27c2df92982e6fc796b22@epcas1p3.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>On 8/31/21 00:04, Chanwoo Lee wrote:
>> From: ChanWoo Lee <cw9316.lee@samsung.com>
>> 
>> Remove unused parameters
>> * ufshpb_set_hpb_read_to_upiu()
>>   -> struct ufshpb_lu *hpb
>>   -> u32 lpn
>
>Please use full sentences in the patch description for future patch 
>submissions. Anyway:
>
>Reviewed-by: Bart Van Assche <bvanassche@acm.org>

Thank you, I will edit the description and upload it again.//v2

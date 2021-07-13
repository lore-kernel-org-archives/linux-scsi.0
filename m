Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55D09C07E96
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Jul 2021 23:35:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3AFCE6136D
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Jul 2021 23:35:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236998AbhGMXhu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Jul 2021 19:37:50 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:30054 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236981AbhGMXht (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Jul 2021 19:37:49 -0400
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210713233457epoutp016e2ec2ed69e283ff190a36fe6f443219~RfdWmMkXK1850018500epoutp01V
        for <linux-scsi@vger.kernel.org>; Tue, 13 Jul 2021 23:34:57 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210713233457epoutp016e2ec2ed69e283ff190a36fe6f443219~RfdWmMkXK1850018500epoutp01V
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1626219297;
        bh=a0bMVwQo+h2GMVyOxRasJNUFbZhTpUogH6uSC1zuPy0=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=UDLVUZe0aPtY+/HuSk+cSntjY3DKqmKy1rhW+s7XhBzxwMcKjgbnWQCQrJKlFRKG0
         INbdqbCQXRYKLSGbwiI/1qWmxeB0vOcvZqfxq1HBsAelw5tBCfmbZsekfyFHo7TDoz
         kvEGMkJMPup06mbeQke7OPI8IdWhaRyJCD1D55E4=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20210713233456epcas2p4f9774ff83ee061ab65f32679cbddb17b~RfdV01keh0977709777epcas2p4R;
        Tue, 13 Jul 2021 23:34:56 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.181]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4GPcRy56Qdz4x9QL; Tue, 13 Jul
        2021 23:34:54 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        69.17.09921.E132EE06; Wed, 14 Jul 2021 08:34:54 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20210713233453epcas2p1b29bd795101cea9059e574471095aa5d~RfdTQlmRg1321913219epcas2p1e;
        Tue, 13 Jul 2021 23:34:53 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210713233453epsmtrp14fb5c3b3438918d4d0537ee532ac1b74~RfdTPhAv72398023980epsmtrp1C;
        Tue, 13 Jul 2021 23:34:53 +0000 (GMT)
X-AuditID: b6c32a45-fb3ff700000026c1-96-60ee231e01a9
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        4E.8E.08394.D132EE06; Wed, 14 Jul 2021 08:34:53 +0900 (KST)
Received: from KORCO039056 (unknown [10.229.8.156]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20210713233453epsmtip2916be6fc7ac6154b8daae6ffd9be993e~RfdTBesT-2760227602epsmtip2d;
        Tue, 13 Jul 2021 23:34:53 +0000 (GMT)
From:   "Chanho Park" <chanho61.park@samsung.com>
To:     "'Krzysztof Kozlowski'" <krzk@kernel.org>,
        "'Alim Akhtar'" <alim.akhtar@gmail.com>
Cc:     "'Alim Akhtar'" <alim.akhtar@samsung.com>, <robh@kernel.org>,
        <devicetree@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <avri.altman@wdc.com>, <martin.petersen@oracle.com>,
        <kwmad.kim@samsung.com>, <cang@codeaurora.org>,
        <linux-samsung-soc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kishon@ti.com>
In-Reply-To: <CAJKOXPd6VMBaW7zBDXb7tXDHr3xwV2yZXxZtLJqNe3T69oUqsw@mail.gmail.com>
Subject: RE: [RESEND PATCH v10 08/10] dt-bindings: ufs: Add bindings for
 Samsung ufs host
Date:   Wed, 14 Jul 2021 08:34:53 +0900
Message-ID: <000001d7783f$ae446670$0acd3350$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQLSJHm6eNEbPiUjxcYKuzqoT35S6wG4t7PjAWYpiDECouhoZQFFh/mAqRP7SIA=
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLJsWRmVeSWpSXmKPExsWy7bCmha6c8rsEg29buS2W3qq2eDBvG5vF
        y59X2Sw+rV/GajH/yDlWiwtPe9gszp/fwG5xc8tRFotNj6+xWlzeNYfNYsb5fUwW3dd3sFks
        P/6PyeL/nh3sDnwel/t6mTx2zrrL7rFpVSebx+Yl9R4fn95i8ejbsorR4/iN7UwenzfJebQf
        6GYK4IzKsclITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB
        ul1JoSwxpxQoFJBYXKykb2dTlF9akqqQkV9cYquUWpCSU2BoWKBXnJhbXJqXrpecn2tlaGBg
        ZApUmZCTcfzjWqaCyawVOz/4NTB+Y+5i5OSQEDCReHjtF1MXIxeHkMAORondz44wQjifGCWm
        nP8E5XxjlDjTtwuuZW3zdjaIxF5GiQN37rNDOC8YJY68OghWxSagL/GyYxtrFyMHh4hAhMSb
        s/kgNcwCL5kkDq5/wg5SwykQKPHo2msWEFtYIFpi1fu3TCA2i4CqxOtpV8Hm8ApYShx+9pYR
        whaUODnzCVg9s4C8xPa3c6AuUpD4+XQZK4gtIuAn0TltGlSNiMTszjZmkMUSAnc4JD6fbGGB
        aHCRaF5wjA3CFpZ4dXwLO4QtJfGyv40doqGbUaL10X+oxGpGic5GHwjbXuLX9C1gnzELaEqs
        36UPYkoIKEscuQW1l0+i4/Bfdogwr0RHmxBEo7rEge3ToS6Qleie85l1AqPSLCSfzULy2Swk
        H8xC2LWAkWUVo1hqQXFuemqxUYEhcmRvYgSnay3XHYyT337QO8TIxMF4iFGCg1lJhHep0dsE
        Id6UxMqq1KL8+KLSnNTiQ4ymwLCeyCwlmpwPzBh5JfGGpkZmZgaWphamZkYWSuK8HOyHEoQE
        0hNLUrNTUwtSi2D6mDg4pRqYwp4JXuuJXZO+0tO3KG5C4o0UNpaTc6QWx3tfkl+U8YLn76q5
        KY5blWaZPp7GyXa+aepxkWf5kxQShVxWXzhkKfs3oK9/4793z20nT9Suulhp6zBhvrcL026F
        FsfrlZufaJ2JOH5ClbWQo0FPYhHD5quFteoT9qzdrGjyyq3xr+6SvKNxd473RshbSiabxIR+
        D5viJGG6967p4vVPZ2TPu3c1Kv/I6WNix71lt4sWHtStOVV73TfhWLDYx1R11XfZrSybRJ8w
        /OJcxjfHYhvzTxvf/JDu/zEGDA6ns3Z9dV1ZnbtZmP+MG9e1T61HfewqtZ1FFl3UydqgMCdQ
        //E23ZMzI7xnNbs52F8JtCxXYinOSDTUYi4qTgQAq3+T4WAEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBIsWRmVeSWpSXmKPExsWy7bCSvK6s8rsEg74HIhZLb1VbPJi3jc3i
        5c+rbBaf1i9jtZh/5ByrxYWnPWwW589vYLe4ueUoi8Wmx9dYLS7vmsNmMeP8PiaL7us72CyW
        H//HZPF/zw52Bz6Py329TB47Z91l99i0qpPNY/OSeo+PT2+xePRtWcXocfzGdiaPz5vkPNoP
        dDMFcEZx2aSk5mSWpRbp2yVwZRz/uJapYDJrxc4Pfg2M35i7GDk5JARMJNY2b2cDsYUEdjNK
        /GllgYjLSjx7t4MdwhaWuN9yhLWLkQuo5hmjxKwHq8ASbAL6Ei87trGC2CICERInb6xnByli
        FvjKJLH04QUWiI6TTBJHH8wFq+IUCJR4dO012AphgUiJb592g61mEVCVeD3tKthJvAKWEoef
        vWWEsAUlTs58AlbPLKAt8fTmUyhbXmL72zlQLyhI/Hy6DOoKP4nOadOgakQkZne2MU9gFJ6F
        ZNQsJKNmIRk1C0nLAkaWVYySqQXFuem5xYYFhnmp5XrFibnFpXnpesn5uZsYwZGrpbmDcfuq
        D3qHGJk4GA8xSnAwK4nwLjV6myDEm5JYWZValB9fVJqTWnyIUZqDRUmc90LXyXghgfTEktTs
        1NSC1CKYLBMHp1QD09SVWy8uy7na84jhhqy11abjU/RYNGYxz0rv9Nm+pe3exnP3itQveYks
        YL+R9GrfYdnjqxTv52dJnjJ/nchl0eE4/a4Gx4ea6evs1if92mQ6ofUhc7BE2f9HRYIe88OF
        pKbY2dQWrancblQW7HvU0WjjGzuj39caTtbbJVxZ+eKJ2IkTejYJ3Xnas10//TcoLbVVn7Nv
        TyCD9YaWj/uPM+U9cM7qKCpuVDk56Z2EvKiq5Vp1tvPLeLOr9x9/dt7LqCbyNuNbNWvzmS1H
        xSdfnC5/cr37dpd50tMKfEI+uq17btXq8fS2g7y2ndfxiZe2zhL/mqV891ZoovqGhNfNtpe3
        aZj2lYvFnuX1XCg7W4mlOCPRUIu5qDgRAP3kuk1LAwAA
X-CMS-MailID: 20210713233453epcas2p1b29bd795101cea9059e574471095aa5d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200613030454epcas5p400f76485ddb34ce6293f0c8fa94332b8
References: <CGME20200613030454epcas5p400f76485ddb34ce6293f0c8fa94332b8@epcas5p4.samsung.com>
        <20200613024706.27975-1-alim.akhtar@samsung.com>
        <20200613024706.27975-9-alim.akhtar@samsung.com>
        <CAGOxZ500JD5xNWb0xFyEgaUH0qwQKm+kn1Ng71_1SM1wmJFxKg@mail.gmail.com>
        <CAJKOXPd6VMBaW7zBDXb7tXDHr3xwV2yZXxZtLJqNe3T69oUqsw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > Hi Rob
> > Anything else needs to be done for this patch?
> >
> > On Sat, Jun 13, 2020 at 8:36 AM Alim Akhtar <alim.akhtar@samsung.com>
> wrote:
> > >
> > > This patch adds DT bindings for Samsung ufs hci
> > >
> > > Reviewed-by: Rob Herring <robh@kernel.org>
> > > Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
> 
> It has Rob's ack, so it can be taken directly via SCSI tree.
> 
> Chanho,
> I guess here is the answer why exynos7-ufs compatible was not documented,
> so you can build on top of it.
> 

Great. I'll update my compatibles on top of this patch.

Anyway, who will take this patch?

Best Regards,
Chanho Park


Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F051AC7EE22
	for <linux-scsi@archiver.kernel.org>; Tue, 16 May 2023 03:30:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbjEPDah (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 May 2023 23:30:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjEPDag (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 May 2023 23:30:36 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1662649DF
        for <linux-scsi@vger.kernel.org>; Mon, 15 May 2023 20:30:33 -0700 (PDT)
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20230516033030epoutp042c57b6533f7aaf4ed41ac356fe0b703e~fghktuepn2342423424epoutp04U
        for <linux-scsi@vger.kernel.org>; Tue, 16 May 2023 03:30:30 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20230516033030epoutp042c57b6533f7aaf4ed41ac356fe0b703e~fghktuepn2342423424epoutp04U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1684207830;
        bh=0IVFgx+bVaSUUTiSups5GbolNIPJ8x4Mfem7o00DH5w=;
        h=From:To:In-Reply-To:Subject:Date:References:From;
        b=Ii4OAqB3tq5BeaPFnYZrajJnVXdi6T/ZxJDQ9093nivz6H2kRe3grz+Tq/i/tEm/k
         cqdIbv//I6mT0IIp3fvcFapGoyLvrbIubwRtOxUdJRaNJIoV/Hp1gPgipCzNXVfroV
         anKoLhU+GNtf3TIVt3PHeNdmXXTKevD/AJeuzdsQ=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20230516033029epcas2p21d8685027d8cb652c18dddf12ef9a25b~fghkZLAkc0614206142epcas2p2t;
        Tue, 16 May 2023 03:30:29 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.36.70]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4QL1w51fGrz4x9Q2; Tue, 16 May
        2023 03:30:29 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        FB.24.22936.5D8F2646; Tue, 16 May 2023 12:30:29 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20230516033028epcas2p30679e540fe236b4ec9d53cb8b9fa5efa~fghjXefhQ1823618236epcas2p3q;
        Tue, 16 May 2023 03:30:28 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20230516033028epsmtrp236c32960638bb421ac2039432c06eff1~fghjWymkE3010030100epsmtrp2C;
        Tue, 16 May 2023 03:30:28 +0000 (GMT)
X-AuditID: b6c32a48-6d3fa70000005998-f4-6462f8d51580
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        B1.7C.27706.4D8F2646; Tue, 16 May 2023 12:30:28 +0900 (KST)
Received: from KORCO011456 (unknown [10.229.38.105]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20230516033028epsmtip27f31266fff112af6997302fb62a0b0e9~fghjNiwN71681016810epsmtip2G;
        Tue, 16 May 2023 03:30:28 +0000 (GMT)
From:   "Kiwoong Kim" <kwmad.kim@samsung.com>
To:     "'Avri Altman'" <Avri.Altman@wdc.com>,
        <linux-scsi@vger.kernel.org>, <sc.suh@samsung.com>,
        <hy50.seo@samsung.com>, <sh425.lee@samsung.com>,
        <kwangwon.min@samsung.com>
In-Reply-To: <DM6PR04MB6575DFEBFBE75610D9613220FC779@DM6PR04MB6575.namprd04.prod.outlook.com>
Subject: RE: [RFC PATCH v1] ufs: poll HCS.UCRDY before issuing a UIC command
Date:   Tue, 16 May 2023 12:30:28 +0900
Message-ID: <012e01d987a6$c2d83350$488899f0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQGTQ//Bn9HITMBER2fQmcGpYd1IAgEVn6BsAi60kyuvzqJwQA==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnk+LIzCtJLcpLzFFi42LZdljTVPfqj6QUg6tTuC1e/rzKZrF68QMW
        i603drJYdF/fwWbRdfcGo8XSf29ZHNg8+rasYvT4vEnOo/1AN1MAc1S2TUZqYkpqkUJqXnJ+
        SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QXiWFssScUqBQQGJxsZK+nU1R
        fmlJqkJGfnGJrVJqQUpOgXmBXnFibnFpXrpeXmqJlaGBgZEpUGFCdsaXrw3MBf/ZKzbsuczc
        wLiDrYuRk0NCwETi/+0FQDYXh5DADkaJi0s3sUA4nxgl+p61QWW+MUqcPfmUEaZl78Y5TBCJ
        vYwS25cfYIdwXjJKrGiawQRSxSagLTHt4W5WkISIwDpGidXTm4BmcXBwCsRKNK2vBakRFvCR
        WHqwBayeRUBV4v6sR2A2r4ClROuSPWwQtqDEyZlPWEBsZqCZyxa+Zoa4QkHi59NlrCC2iICT
        xJZNJ5ghakQkZne2MYPslRD4yi7xd9dlqAYXib6V99ghbGGJV8e3QNlSEp/f7QW7TUIgW2LP
        QjGIcIXE4mlvWSBsY4lZz9oZQUqYBTQl1u/Sh6hWljhyC+oyPomOw3/ZIcK8Eh1tQhCNyhK/
        Jk2GBpukxMybd6B2ekjc+3OEcQKj4iwkP85C8uMsJL/MQti7gJFlFaNYakFxbnpqsVGBCTyu
        k/NzNzGCU6SWxw7G2W8/6B1iZOJgPMQowcGsJMLbPjM+RYg3JbGyKrUoP76oNCe1+BCjKTDU
        JzJLiSbnA5N0Xkm8oYmlgYmZmaG5kamBuZI478cO5RQhgfTEktTs1NSC1CKYPiYOTqkGphph
        6V2fDj8KONa+jcudh2+9rsALx+yJO+4XHjSzOMw8h+nSsh3uGtnmM2ZwCVzQXSh4+TDLwxr5
        STM3vv9YJ/l5znVfQ62QpMq0phdZJeu3X0jdMienv/6ZVEdNmC5HXk5mstVhvvmXzvcUB320
        C2/MqNrC8Sv/i+1xAbZT8/Nivorp98ad997w0uDCzIZDZRU8CzXXh90yYvAMZzx27k6DSN9C
        hYwwDR8ly9KOj2sCZdvKoliet3yIdU7id+i58NdY5dPVqRdOr+YKymgwuexd53m9ZOrha0bm
        N1N/rGb2TI5n4Yybfm9Ws3hJWPLX6V+S7is5JC2bKNz8Z9aaPubJt+53eSa8F2Sbo7VOiaU4
        I9FQi7moOBEA4EGr3xoEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBLMWRmVeSWpSXmKPExsWy7bCSvO6VH0kpBvN+Gli8/HmVzWL14gcs
        Fltv7GSx6L6+g82i6+4NRoul/96yOLB59G1ZxejxeZOcR/uBbqYA5igum5TUnMyy1CJ9uwSu
        jN9bFrAW/GOv+LP2P3MD41a2LkZODgkBE4m9G+cwdTFycQgJ7GaUeP19DlRCUuLEzueMELaw
        xP2WI6wQRc8ZJb4ueQJWxCagLTHt4W6whIjAFkaJviOTwDqEBF4yShy+n9PFyMHBKRAr0bS+
        FiQsLOAjsfRgCxOIzSKgKnF/1iMwm1fAUqJ1yR42CFtQ4uTMJywgNjPQ/N6HrYww9rKFr5kh
        DlKQ+Pl0GSuILSLgJLFl0wlmiBoRidmdbcwTGIVmIRk1C8moWUhGzULSsoCRZRWjZGpBcW56
        brFhgWFearlecWJucWleul5yfu4mRnBkaGnuYNy+6oPeIUYmDsZDjBIczEoivO0z41OEeFMS
        K6tSi/Lji0pzUosPMUpzsCiJ817oOhkvJJCeWJKanZpakFoEk2Xi4JRqYCqdf6rwheL5te66
        BaslTyy9dFG6T2FGOX92YceSS3MfJ+jfXJuX9EHKb00C97UAxQKeGz5fvvFsbKgNX3zsYcLC
        gmmd1RvnFEmKTN/+9197ctTiZXEyUo7rlxzS4jGV2vb8HvtWRc+XZv5se5qWnnoZsDUnYVLd
        k9cGD+X+HVzLc1jUoaP2zOHAFv2FVx5rJjqd2uxrlsu+0uXfNuajCrc/XvyZf60hffZ+iyal
        u4FMAarbXorHXGh5ajORIb/uxEVRdYsJXxK/PQ3exze7UvqarurrhR9q53574Xnx6HF1yW+z
        fZXuLW6dMs9Nj2upxNS2fetf3FmYvKMyq2dOnFjHiVfrfy1N3p9/z/ZCrtZ6JZbijERDLeai
        4kQAo+oxB/sCAAA=
X-CMS-MailID: 20230516033028epcas2p30679e540fe236b4ec9d53cb8b9fa5efa
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230509083312epcas2p375f77d18a9026f7d263750baf9c9a5bb
References: <CGME20230509083312epcas2p375f77d18a9026f7d263750baf9c9a5bb@epcas2p3.samsung.com>
        <1683620674-160173-1-git-send-email-kwmad.kim@samsung.com>
        <DM6PR04MB6575DFEBFBE75610D9613220FC779@DM6PR04MB6575.namprd04.prod.outlook.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > With auto hibern8 enabled, UIC could be working for a while to process
> > a hibern8 operation and HCI reports UIC not ready for a short term
> > through HCS.UCRDY.
> > And UFS driver can't recognize the operation.
> > UFSHCI spec specifies UCRDY like this:
> > whether the host controller is ready to process UIC COMMAND
> >
> > The 'ready' could be seen as many different meanings. If the meaning
> > includes not processing any request from HCI, processing a hibern8
> > operation can be 'not ready'. In this situation, the driver needs to
> > wait until the operations is completed.
> >
> > Signed-off-by: Kiwoong Kim <kwmad.kim=40samsung.com>
> Is this replaces your previous suggestion -
> https://lore.kernel.org/lkml/1682385635-43601-1-git-send-email-
> kwmad.kim=40samsung.com/
> Or is it addressing another issue?
>=20
> Thanks,
> Avri
>=20

No, they are different. This is about reporting UIC ready and what you ment=
ioned
is about reporting UIC busy in a certain race condition.


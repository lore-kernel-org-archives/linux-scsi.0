Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C758C77B7F
	for <linux-scsi@archiver.kernel.org>; Fri, 12 May 2023 00:56:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239561AbjELA4d (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 May 2023 20:56:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229654AbjELA4c (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 May 2023 20:56:32 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 655EF4C1F
        for <linux-scsi@vger.kernel.org>; Thu, 11 May 2023 17:56:30 -0700 (PDT)
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20230512005626epoutp045edf3a176479968449254b445149f3de~eP16-TUT21841418414epoutp045
        for <linux-scsi@vger.kernel.org>; Fri, 12 May 2023 00:56:26 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20230512005626epoutp045edf3a176479968449254b445149f3de~eP16-TUT21841418414epoutp045
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1683852986;
        bh=UWdqvj4jqUiBJVcjC49V1+iOASf5bvIpCUi81ez4Mm0=;
        h=From:To:In-Reply-To:Subject:Date:References:From;
        b=XLw5a5YTVBVgN9/jbvwLyOJdbnhlM9mG6UYiN5kEHY5IZMSVAPGMFH+TQ4w/T2ZNS
         JsvONVlPY292L5CPT8NQ4XOi56UhcULnT4RiKo5iFgXFoMHBev8UtMvz6JpyBX7mYm
         xrcjHya7IokwjDmBbVTjfu9hBqBIWbBbnz/1kMqg=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20230512005626epcas2p1318ca098f6935858dca2440be16a1dc7~eP16znIP82227622276epcas2p1S;
        Fri, 12 May 2023 00:56:26 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.36.90]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4QHVhB0yW2z4x9Q7; Fri, 12 May
        2023 00:56:26 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        EC.4C.22936.8BE8D546; Fri, 12 May 2023 09:56:24 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20230512005624epcas2p3fcc75e005e49233579b4ac91ee6ebd87~eP15AbKEp1930919309epcas2p3U;
        Fri, 12 May 2023 00:56:24 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20230512005624epsmtrp2e042110166fbc71fcb08948670c1a8ad~eP14_yXYg1528415284epsmtrp2Y;
        Fri, 12 May 2023 00:56:24 +0000 (GMT)
X-AuditID: b6c32a48-6d3fa70000005998-30-645d8eb87200
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        C0.C3.28392.8BE8D546; Fri, 12 May 2023 09:56:24 +0900 (KST)
Received: from KORCO011456 (unknown [10.229.38.105]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20230512005624epsmtip20d9a215077b948c7ae41ac0951274d25~eP140X0um3016930169epsmtip2O;
        Fri, 12 May 2023 00:56:24 +0000 (GMT)
From:   "Kiwoong Kim" <kwmad.kim@samsung.com>
To:     "'Adrian Hunter'" <adrian.hunter@intel.com>,
        <linux-scsi@vger.kernel.org>
In-Reply-To: <08bc0186-4684-2321-65d8-4c2ae622acea@intel.com>
Subject: RE: [RFC PATCH v1] ufs: poll HCS.UCRDY before issuing a UIC command
Date:   Fri, 12 May 2023 09:56:24 +0900
Message-ID: <006701d9846c$92f5b190$b8e114b0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQGTQ//Bn9HITMBER2fQmcGpYd1IAgEVn6BsAb8Rfw2vy6shAA==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDKsWRmVeSWpSXmKPExsWy7bCmhe6OvtgUgydvLSxOPlnDZtF9fQeb
        A5PH4j0vmTw+b5ILYIrKtslITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21
        VXLxCdB1y8wBGq+kUJaYUwoUCkgsLlbSt7Mpyi8tSVXIyC8usVVKLUjJKTAv0CtOzC0uzUvX
        y0stsTI0MDAyBSpMyM64uvIWY0E7U8XKXeYNjOcZuxg5OSQETCSO7Z/IBmILCexglNh63K+L
        kQvI/sQoMfXnESYI5zOjxNKzv5lgOr7s2sUGkdjFKLFn4z8o5yWjRMe268wgVWwC2hLTHu5m
        BbFFBPwljsy6BLaPU8BWYtvpA2CThAV8JJYebAGzWQRUJa6/WA/WyytgKXG7t5kNwhaUODnz
        CQuIzSwgL7H97RxmiCsUJH4+XQY130li+dcpbBA1IhKzO9uYQQ6SEDjFLnFl30Sos10k5n35
        AtUsLPHq+BZ2CFtK4vO7vUDNHEB2tsSehWIQ4QqJxdPeskDYxhKznrUzgpQwC2hKrN+lD1Gt
        LHHkFtRlfBIdh/+yQ4R5JTrahCAalSV+TZoMDWhJiZk370Dt9JC49+cI4wRGxVlIfpyF5MdZ
        SH6ZhbB3ASPLKkax1ILi3PTUYqMCE3hMJ+fnbmIEJzstjx2Ms99+0DvEyMTBeIhRgoNZSYT3
        7ZLoFCHelMTKqtSi/Pii0pzU4kOMpsBQn8gsJZqcD0y3eSXxhiaWBiZmZobmRqYG5krivB87
        lFOEBNITS1KzU1MLUotg+pg4OKUamNgsf/JlyDc9mydhNi/CoMWx7L236gQ3mxA55ks+9max
        2/Y8SpFJ7+N+mXF958X/k7bFxP3RyRPV2u/03OE08yLejH/CTQF9Xbt+VtjkRj8vatosMy3+
        nuNKjdY7R47crv/4qni+/PFX01Z02cuFPdee9PGBf/kM/Zk3IypiGr42K/ons3sLrbp/Vufv
        zSnO+w8fMa/MMIm+uEFxsvXXxif3CwPC+DesqpWdwS9bWPv9wqwnF/+un6ndXFY3O/qYTO91
        U6eS/qSI9jhpk5evK7b/YM17nuUaZnX9hduFqYV33eds//lMYGNUn44c73afPT+VOWIOPBJi
        THsgJ5LJKbyGY94Ur5lT+DcdlVu6RImlOCPRUIu5qDgRAARjQKH/AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHLMWRmVeSWpSXmKPExsWy7bCSvO6OvtgUg6k31C1OPlnDZtF9fQeb
        A5PH4j0vmTw+b5ILYIrisklJzcksSy3St0vgyri68hZjQTtTxcpd5g2M5xm7GDk5JARMJL7s
        2sUGYgsJ7GCUmLEnHyIuKXFi53OoGmGJ+y1HWLsYuYBqnjNKTNyxESzBJqAtMe3hblYQW0TA
        X+LIrEuMEEUnGSUuLDjPBJLgFLCV2Hb6AJgtLOAjsfRgC5jNIqAqcf3FemYQm1fAUuJ2bzMb
        hC0ocXLmExYQmxloQe/DVkYIW15i+9s5zBAXKUj8fLoMarGTxPKvU9ggakQkZne2MU9gFJqF
        ZNQsJKNmIRk1C0nLAkaWVYySqQXFuem5xYYFRnmp5XrFibnFpXnpesn5uZsYwUGupbWDcc+q
        D3qHGJk4GA8xSnAwK4nwvl0SnSLEm5JYWZValB9fVJqTWnyIUZqDRUmc90LXyXghgfTEktTs
        1NSC1CKYLBMHp1QDU9zahTKXlGoa26wXFr5b4/pXZ9Kuw9NeH/4/8cmGrwzmEd7PfRdcuf1R
        u+Hj4wMtevMT57N/nMHvxVrzYHs20x6Zia/fGARvPLdzg1JaYAlvcjvD+j05OStO131J/yHv
        5LnhBcu21cmtJydaLJn5/MHpGus6jRr7HpmGe/y7V/XesI596T4rlYHFyO+Kyq/9l68u0Lng
        H/Gw1f1qjO/uY/8M8t5eWZqlmjp1+o6zhxVtLs7+JnaP+2zVDB+L00beF3bNPDlre/lBMZPQ
        PA5RoyOfZc9H/BJ7OL/v26XyaN0ES5c3R/iuCGzKu/LuYPiBqU90jGdZM0YxVny5eEZvnvQE
        xtTgYJuoxWlxr09dV+ZUYinOSDTUYi4qTgQAcSdMIOECAAA=
X-CMS-MailID: 20230512005624epcas2p3fcc75e005e49233579b4ac91ee6ebd87
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230509083312epcas2p375f77d18a9026f7d263750baf9c9a5bb
References: <CGME20230509083312epcas2p375f77d18a9026f7d263750baf9c9a5bb@epcas2p3.samsung.com>
        <1683620674-160173-1-git-send-email-kwmad.kim@samsung.com>
        <08bc0186-4684-2321-65d8-4c2ae622acea@intel.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> Pedantically, the sleep probably needs to be less than the auto-hibernate
> idle timer period?
> 
> > +	} while (ktime_before(ktime_get(), timeout));
> 
> read_poll_timeout() would be a better choice for I/O polling

It makes sense. Got it. Thanks.



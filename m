Return-Path: <SRS0=U9Ib=CS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91BE8C433E2
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 06:25:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F9FD20936
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 06:25:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="h0O/69nF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725948AbgIIGZB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Sep 2020 02:25:01 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:34951 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725826AbgIIGZB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Sep 2020 02:25:01 -0400
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200909062456epoutp026c03d8a0aa7c74ff1a64d2a31520a2c3~zCXZpNS9A1491114911epoutp02F
        for <linux-scsi@vger.kernel.org>; Wed,  9 Sep 2020 06:24:56 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200909062456epoutp026c03d8a0aa7c74ff1a64d2a31520a2c3~zCXZpNS9A1491114911epoutp02F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1599632696;
        bh=EQM/+iglUg+tu8lqvbXz7X0v67Uh45kYTa0PRqoOnng=;
        h=From:To:In-Reply-To:Subject:Date:References:From;
        b=h0O/69nFNLxLo+gNsAgBKgqmRGZujaRjXA7/nLoH3b1TJwSPZVkCWphS53vE0OGDK
         MytGl4cKaW7Z6Dm/J5IR6g9SIno0desN9/lNLG2ocQH6jn6UMql/SuoyB3o+3bV5ak
         wEVpczoiKbkbAhLL+1EFGumYDlz6oNYJCffhojZE=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20200909062456epcas2p4bcbc5622c90bddfa50669bb08ff7e2c2~zCXZKLGN10997709977epcas2p4a;
        Wed,  9 Sep 2020 06:24:56 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.184]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4BmX796F3XzMqYlx; Wed,  9 Sep
        2020 06:24:53 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        63.C5.19322.435785F5; Wed,  9 Sep 2020 15:24:52 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20200909062452epcas2p1a0bf194c7c79f702d29465ffd37b5701~zCXVjqpVB1538115381epcas2p1C;
        Wed,  9 Sep 2020 06:24:52 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200909062452epsmtrp11c23fb7c8d588f94f2af2856b289a5b1~zCXViTgTC0111101111epsmtrp1y;
        Wed,  9 Sep 2020 06:24:52 +0000 (GMT)
X-AuditID: b6c32a45-797ff70000004b7a-95-5f5875342a3f
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        E0.EA.08303.435785F5; Wed,  9 Sep 2020 15:24:52 +0900 (KST)
Received: from KORCO011456 (unknown [12.36.185.54]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20200909062452epsmtip2f6832948f6b6ab40ce47e110cc7829fb~zCXVTOBli0850308503epsmtip2n;
        Wed,  9 Sep 2020 06:24:52 +0000 (GMT)
From:   "Kiwoong Kim" <kwmad.kim@samsung.com>
To:     <jejb@linux.ibm.com>, <linux-scsi@vger.kernel.org>,
        <alim.akhtar@samsung.com>, <avri.altman@wdc.com>,
        <martin.petersen@oracle.com>, <beanhuo@micron.com>,
        <asutoshd@codeaurora.org>, <cang@codeaurora.org>,
        <bvanassche@acm.org>, <grant.jung@samsung.com>,
        <sc.suh@samsung.com>, <hy50.seo@samsung.com>,
        <sh425.lee@samsung.com>
In-Reply-To: <1599628866.10803.68.camel@linux.ibm.com>
Subject: RE: [PATCH v4 1/2] ufs: introduce skipping manual flush for wb
Date:   Wed, 9 Sep 2020 15:24:51 +0900
Message-ID: <022801d68671$ed2e28a0$c78a79e0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Content-Language: ko
Thread-Index: AQJdpB1H0b2R7qwRuUr8iZB6TFULWAJv97ciAZUlqQEBzVvhj6gjB8EA
X-Brightmail-Tracker: H4sIAAAAAAAAA01Ta0xbZRj2a0/bw5KaM6jjkxgsZ/sBjN5w7Q4CahiyLlsiU4mGTEsHJ4XR
        W3phoCYWs3BpBcFlGOrCHIyLI0szwFpAC+My2HBAoATEEmEBuSgZQmotBrDtqZF/z/u87/M9
        7/t+34fSw4eZUWiB2kDq1HIlzjyC2AfjxLxTxvdlwulqMbHYYGcSP5aNsoh13wyTeLBUiRB1
        Wz46sW1rYRC7ezYW0d60iBCNc3YaYZl1MInWkX0aYV6YA0Tz/ibyBls67Tovna6uoklrGvuB
        1GurYEr/XJlHpNVdd4F0pyNaWt5voWWi2cqUfFKeR+q4pDpXk1egVqTi59+RnZGJJUIRT5RE
        nMa5armKTMXTL2TyMgqU/pZxbpFcafRTmXK9Hhe8lqLTGA0kN1+jN6TipDZPqRWJtHy9XKU3
        qhX8XI3qVZFQmCj2V+Yo8x+OLTO0PUjxTetjmgmU080ARSF2Co7bMs3gCBqOOQCs3SilU8E2
        gA+ckwwq2AHwnr3ZnwkLKto3exEq0QNgw7AlFKwBuOp8yAhUMbGTsG6pNyjnYBM0eN88wgok
        wjAJ3OhsBQEcgZ2FntFyWgAj2AnYdjAe5NlYEpxbn2BR+Ch8VL+MBDAdexl+v3kz1AYX+lZa
        GBTPgV9XlgV5DpYB7//zLTNgDLEhFK5VNwBKkA7X26YQCkfAjZEuFoWj4PoXZSH8KXTeMDEo
        8ecArjj3Q+JXoPW3chBYGR2Lg7YeAbW943BoPtTb87BicI9F0WxYURZOCY/D3S+vhw55Edb/
        7A45SeG0dwHUgBjroSmth6a0HprM+r/vNwC5C46RWr1KQeoTtaLDt90Bgu85/k0HuL65xR8A
        NBQMAIjScQ7bPJAlC2fnyUs+InUamc6oJPUDQOzfey096oVcjf9DqA0ykThRIhEmiQmxJJHA
        I9mqmMkPwzGF3EAWkqSW1P2no6FhUSYab9211bKQNb96rvupxwhjm11HI374pLc7AjuhaOBn
        X/rlg6nfE9L2/56Ki8zJclZl5/T3D58Bk5EzT7o7zLfiTqPIezHWYmukZ9zQVCr4ynDV+1Zy
        YcJuYx+cjR66M1j00sWS75IFJV5lwhNThtS5nfDH1ed+rUqxsIp3j409cy32XctsLIqud/DG
        CF/pxE/vug7Y1852qtGatL98j5HXtywzB5/VXHla2Zl+eSee0xxmjj9necRqWm19NuFxq12F
        jIjRPdy7J+jJn6k7uXg52XHJzbl3ofiWCUrca8tpse07XdyPryz57sR63LUoZkrZadzkdyxH
        3549aHt7sc+OI/p8uSiertPL/wVV9H91WAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCIsWRmVeSWpSXmKPExsWy7bCSvK5JaUS8wZFfwhYP5m1js9jbdoLd
        4uXPq2wWBx92slhM+/CT2eLT+mWsFr/+rme3WL34AYvFohvbmCy6r+9gs1h+/B+TRdfdG4wW
        S/+9ZXHg9bh8xdvjcl8vk8eERQcYPb6v72Dz+Pj0FotH35ZVjB6fN8l5tB/oZgrgiOKySUnN
        ySxLLdK3S+DKOHb6CWvBLpaKObNOMTUwtjN3MXJySAiYSKx+u5uli5GLQ0hgB6NEz749bBAJ
        SYkTO58zQtjCEvdbjrBCFD1jlFj8pgesiE1AW2Law91gCRGBu0wS71oWg40VEmhhkrjwWwfE
        5hQwk3i1eTnYJGEBd4mvJ9qZQGwWARWJFf/PgcV5BSwlbrw8zw5hC0qcnPmEBcRmBlrQ+7CV
        EcKWl9j+dg7U2QoSP58uY4WIi0jM7mwDi4sIuEls/L2SbQKj0Cwko2YhGTULyahZSNoXMLKs
        YpRMLSjOTc8tNiwwykst1ytOzC0uzUvXS87P3cQIjkgtrR2Me1Z90DvEyMTBeIhRgoNZSYS3
        61BovBBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHer7MWxgkJpCeWpGanphakFsFkmTg4pRqYFgsq
        u22311W6XVx/kCVhsp/4xwn3/Zue3U3Mbf74cxOLKufqP3cjDlp9vmtdGTXXr9/svcnNZT6L
        9F2yNP4nOduHnPWNm214I1tblavObVJaytQqp2arTm3PDtUsnVblCc/n/5nIk52qluDUMEvw
        7h0j1f87VLsTfkz6FxB6++PNU0U1FQd3n7Baddyf+2hqia2V/7HcJZka3DfXVB6YOyedRSLu
        3t1AC75NUaF8mVZ1mnIFDk/Fj/oHPpt/Kl1t7oSDEZddXLZf589l64lfEtdaI6A43+joqkTx
        0kWcJrs6hAoO6+nt/7z6bm6mvKm1ys1vaY/EjFx3rvAXSHtV4+Zg3F3A+kbqjzZ3mhJLcUai
        oRZzUXEiAH6JdPQ3AwAA
X-CMS-MailID: 20200909062452epcas2p1a0bf194c7c79f702d29465ffd37b5701
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200905061549epcas2p3e3554be6bb9737f3133529ebac4ce99a
References: <cover.1599285983.git.kwmad.kim@samsung.com>
        <CGME20200905061549epcas2p3e3554be6bb9737f3133529ebac4ce99a@epcas2p3.samsung.com>
        <3cf3e93696510922b775d8887ca8408dd384648b.1599285983.git.kwmad.kim@samsung.com>
        <1599628866.10803.68.camel@linux.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> [...]
> > +
> > +	/*
> > +	 * This quirk needs to disable manual flush for write booster
> > +	 */
> > +	UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL		= 1 << 11,
> 
> You can't have 1 << 11 it's already taken by:
> 
> 8da76f71fef7 scsi: ufs-pci: Add quirk for broken auto-hibernate for Intel
> EHL
> 
> 	/*
>          * This quirk needs to disable manual flush for write booster
>          */
>         UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL          = 1 << 11,
> 
> I take it 1 << 12 is OK?
> 
> James
> 
Sure, no problem.

Thanks.
Kiwoong Kim


